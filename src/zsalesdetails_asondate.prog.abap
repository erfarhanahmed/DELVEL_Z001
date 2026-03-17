*&---------------------------------------------------------------------*
*& Report ZSALESDETAILS_ASONDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsalesdetails_asondate.

TABLES :vbak.

TYPES :BEGIN OF ty_final,
         cust_ref      TYPE char40,
         doc_date      TYPE vbap-aedat,
         salesdoc_type TYPE char4,
         salesoffice type char50,
         sales_doc     TYPE char10,
         sales_item    TYPE char6,
         sold_to_party TYPE char10,
         name1 type kna1-name1,
         material      TYPE vbap-matnr,
        makt type makt-maktx,
         order_quan    TYPE vbrp-lmeng,
         sales_unit    TYPE Vbrp-meins,
         netvalue      TYPE vbrp-netwr,
         currency      TYPE vbrp-waerk,
         latestexc type char10,
        netamountasondate type vbrp-netwr,
       END OF ty_final.
DATA:lt_final TYPE STANDARD TABLE OF ty_final,
     ls_final TYPE ty_final.
DATA: lv_kurst TYPE kurst VALUE 'B',
      lv_curr  TYPE vdm_v_display_currency VALUE 'INR'.
DATA:ls_fcat TYPE slis_fieldcat_alv,
     lt_fcat TYPE STANDARD TABLE OF slis_fieldcat_alv.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*  SELECT-OPTIONS : s_date for vbak-aedat.
  PARAMETERS : s_date TYPE vbak-aedat.
*               s_time type ZDAY_PEND_SO-creationtime.
*                saleord type vbak-vbeln.
SELECTION-SCREEN END OF BLOCK b1.


START-OF-SELECTION.
  PERFORM get_data.

  PERFORM dis_data.



FORM get_data.
*    DATA:lt_date TYPE STANDARD TABLE OF casdayattr.
*  if s_date-high is NOT INITIAL.
*  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
*    EXPORTING
**     FACTORY_CALENDAR           = ' '
**     HOLIDAY_CALENDAR           = ' '
*      date_from                  = s_date-low
*      date_to                    = s_date-high
*      language                   = sy-langu
**     NON_ISO                    = ' '
** IMPORTING
**     YEAR_OF_VALID_FROM         =
**     YEAR_OF_VALID_TO           =
**     RETURNCODE                 =
*    TABLES
*      day_attributes             = lt_date
*    EXCEPTIONS
*      factory_calendar_not_found = 1
*      holiday_calendar_not_found = 2
*      date_has_invalid_format    = 3
*      date_inconsistency         = 4
*      OTHERS                     = 5.
*  else.
*
*      CALL FUNCTION 'DAY_ATTRIBUTES_GET'
*    EXPORTING
**     FACTORY_CALENDAR           = ' '
**     HOLIDAY_CALENDAR           = ' '
*      date_from                  = s_date-low
*      date_to                    = s_date-low
*      language                   = sy-langu
**     NON_ISO                    = ' '
** IMPORTING
**     YEAR_OF_VALID_FROM         =
**     YEAR_OF_VALID_TO           =
**     RETURNCODE                 =
*    TABLES
*      day_attributes             = lt_date
*    EXCEPTIONS
*      factory_calendar_not_found = 1
*      holiday_calendar_not_found = 2
*      date_has_invalid_format    = 3
*      date_inconsistency         = 4
*      OTHERS                     = 5.
*
*
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*  ENDIF.
*SELECT *
*  FROM ZI_SALES_PEND_RPt(
*         P_ExchangeRateType = @lv_kurst,
*         P_DisplayCurrency  = @lv_curr
*       )
  SELECT * FROM zday_pend_so
INTO TABLE @DATA(lt_sales) WHERE
    createddate LE @s_date.

  REFRESH lt_final.
  SORT lt_sales BY vbeln posnr createddate   DESCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_sales COMPARING vbeln posnr  .
  DATA(lt_sales1) =  lt_sales.
  SORT lt_sales1 DESCENDING.
  SELECT
    vbeln,
    createddate
*    creationtime
  FROM @lt_sales as a
  ORDER BY createddate DESCENDINg
  INTO TABLE @DATA(lt_latest).

   SORT lt_latest by vbeln createddate DESCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_latest COMPARING vbeln.
*loop at lt_sales1 ASSIGNING FIELD-SYMBOL(<fs1>).

if lt_latest is NOT INITIAL.
SELECT
    a~vbeln,
    a~posnr,
    a~createddate,
    a~creationtime,
    a~bstkd,
    a~audat,
    a~auart,
    a~kunag,
    a~matnr,
    a~kwmeng,
    a~vrkme,
    a~netwr_ap,
    a~waerk
  FROM zday_pend_so AS a

*  FOR ALL ENTRIES IN @lt_sales1
  FOR ALL ENTRIES IN @lt_latest
  WHERE createddate = @lt_latest-createddate and vbeln = @lt_latest-vbeln
  INTO TABLE @DATA(lt_result).
*    SELECT SourceCurrency,
*       TargetCurrency,
*       ExchangeRate
*  FROM zi_latestexchangerate1(
*         P_ExchangeRateType = 'B'   " or your variable
*       )
*  INTO TABLE @DATA(lt_rate)
*  WHERE TargetCurrency = 'INR'.

    SELECT
    SourceCurrency,
    TargetCurrency,
    ExchangeRateType,
     exchangerate,
    ValidFrom
  FROM zsales_latest_rate1(
         P_ExchangeRateType = 'B',
         P_ValidFrom        = @s_date
       )
  INTO TABLE @DATA(lt_rate).
endif.

sort lt_result by vbeln posnr ASCENDING.
delete ADJACENT DUPLICATES FROM lt_result COMPARING vbeln posnr.
if lt_result is NOT INITIAL.
  SELECT vbeln, posnr ,LFSTA from vbap INTO TABLE @DATA(lt_vbap)
    FOR ALL ENTRIES IN @lt_result
    WHERE vbeln = @lt_result-vbeln and posnr = @lt_result-posnr
    and lfsta = 'C'.
    SELECT kunnr, name1 from kna1
      INTO TABLE @DATA(lt_kna1)
      FOR ALL ENTRIES IN @Lt_result
       WHERE kunnr = @lt_result-kunag AND spras = 'E'.
      SELECT vbeln ,vkbur FROM vbak INTO TABLE @DATA(lt_vbak)
        FOR ALL ENTRIES IN @lt_result
        where vbeln = @lt_result-vbeln .
        SELECT matnr ,maktx from makt INTO TABLE @DATA(lt_makt)
          FOR ALL ENTRIES IN @lt_result
           WHERE  matnr = @lt_result-matnr and spras = 'E'.
  ENDIF.

  LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs>)." WHERE createddate = <fs1>-createddate .
    READ TABLE lt_vbap INTO DATA(ls_data) with key vbeln = <fs>-vbeln posnr = <fs>-posnr lfsta = 'C'.
     IF sy-subrc = 0.
      if <fs>-createddate lt s_date.
        CLEAR:ls_data.
       CONTINUE.
     ENDIF.
     ENDIF.
    ls_final-cust_ref  = <fs>-bstkd.
    READ TABLE lt_kna1 INTO DATA(ls_kna1) with key kunnr = <fs>-kunag .
    ls_final-name1 = ls_kna1-name1.
    READ TABLE lt_makt INTO DATA(ls_makt) with key matnr = <fs>-matnr.
    ls_final-makt = ls_makt-maktx.
    READ TABLE lt_vbak INTO DATA(ls_vbak) with key vbeln = <fs>-vbeln.
    ls_final-salesoffice = ls_vbak-vkbur.


    ls_final-doc_date  = <fs>-audat.
    ls_final-salesdoc_type = <fs>-auart.
    ls_final-sales_doc  = <fs>-vbeln.
    SHIFT  ls_final-sales_doc LEFT DELETING LEADING '0'.
    ls_final-sales_item  = <fs>-posnr.
    SHIFT  ls_final-sales_item LEFT DELETING LEADING '0'.
    ls_final-sold_to_party = <fs>-kunag.
    SHIFT  ls_final-sold_to_party LEFT DELETING LEADING '0'.
    ls_final-material  = <fs>-matnr.
    ls_final-order_quan = <fs>-kwmeng.
    ls_final-sales_unit = <fs>-vrkme.
    ls_final-netvalue = <fs>-netwr_ap.
    ls_final-currency = <fs>-waerk.
      READ TABLE lt_rate INTO DATA(ls_rate)
       WITH KEY SourceCurrency = <fs>-waerk
                TargetCurrency = 'INR'.
      if <fs>-waerk = 'INR'.
        ls_final-latestexc = '1'.
        else.
        ls_final-latestexc   = ls_rate-exchangerate.
        ENDIF.
        IF ls_rate-exchangerate > 1.
         ls_final-netamountasondate  = ls_final-netvalue * ls_rate-exchangerate.
         else.

ls_final-netamountasondate  = ls_final-netvalue.
        ENDIF.

    APPEND ls_final TO lt_final.
    CLEAR :ls_final,ls_rate,ls_data,ls_kna1,ls_makt,ls_vbak.
  ENDLOOP.
*  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form dis_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_data .
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'CUST_REF'  'Customer Reference No'    'LT_FINAL'  '40' ' '.
  PERFORM build_fc USING   pr_count 'DOC_DATE'  'Document Date'    'LT_FINAL'  '10' ' '.
  PERFORM build_fc USING   pr_count 'SALESDOC_TYPE'  'Sales Document Type'    'LT_FINAL'  '3' ' '.
  PERFORM build_fc USING   pr_count 'SALESOFFICE'  'Sales Office'    'LT_FINAL'  '3' ' '.
  PERFORM build_fc USING   pr_count 'SALES_DOC'  'Sales Document'    'LT_FINAL'  '10' ' '..
  PERFORM build_fc USING   pr_count 'SALES_ITEM'  'Sales Document Item'    'LT_FINAL'  '6' ' '..
  PERFORM build_fc USING   pr_count 'SOLD_TO_PARTY'  'Sold to party'    'LT_FINAL'  '30' ' '..
  PERFORM build_fc USING   pr_count 'NAME1'  'Cusomer Name'    'LT_FINAL'  '30' ' '..
  PERFORM build_fc USING   pr_count 'MATERIAL'  'Material'    'LT_FINAL'  '40' ' '..
  PERFORM build_fc USING   pr_count 'MAKT'  'Material Description'    'LT_FINAL'  '40' ' '..
  PERFORM build_fc USING   pr_count 'ORDER_QUAN'  'Open order quantity'    'LT_FINAL'  '20' ' '..
  PERFORM build_fc USING   pr_count 'SALES_UNIT'  'Sales Unit'    'LT_FINAL'  '4' ' '..
  PERFORM build_fc USING   pr_count 'NETVALUE'  'Net Value'    'LT_FINAL'  '20' ' '..
  PERFORM build_fc USING   pr_count 'CURRENCY'  'Currency'    'LT_FINAL'  '5' ' '..
  PERFORM build_fc USING   pr_count 'LATESTEXC'  'Latest Exchange Rate'    'LT_FINAL'  '20' ' '..
  PERFORM build_fc USING   pr_count 'NETAMOUNTASONDATE'  'NetAmount As on Date'    'LT_FINAL'  '20' ' '..

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lT_FINAL
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.



FORM build_fc  USING        "PR_ROW TYPE I
                            pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            pr_table TYPE slis_tabname
                            pr_length TYPE string
                            no_sign type string.

  pr_count = pr_count + 1.
*  GS_FIELDCAT-ROW_POS   = PR_ROW.
  ls_fcat-col_pos   = pr_count.
  ls_fcat-fieldname = pr_fname.
  ls_fcat-seltext_l = pr_title.
  ls_fcat-tabname   = pr_table.

  ls_fcat-outputlen = pr_length.
  ls_fcat-no_sign    = no_sign.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

ENDFORM.
