*&---------------------------------------------------------------------*
*& Report ZSD_SO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsd_so.
*INCLUDE ztop.
*INCLUDE zget.

TABLES : vbak,vbap,cdhdr.
TYPES :BEGIN OF ty_final,
         cust_ref          TYPE vbkd-bstkd,
         Cust_name         TYPE kna1-name1,
         sales_office      TYPE vbak-vkbur,
         so                TYPE vbak-vbeln,
         item type vbap-posnr,
         so_date           TYPE vbak-audat,
         cdpos             TYPE vbap-ofm_date,
         hold_date         TYPE vbap-holdreldate,
         receipt_date      TYPE vbap-receipt_Date,
         mrp_date          TYPE cdhdr-udate,
         target_date       TYPE vbap-zmrp_date,
         mrp_tag           TYPE char20,
         so_mrp            TYPE char10,
         deldate type vbap-deldate,
         del_date          TYPE vbap-deldate,
         mat               TYPE vbap-matnr,
         posnr             TYPE vbap-posnr,
         desc              TYPE vbap-arktx,
         so_qty            TYPE vbap-kwmeng,
         so_status         TYPE vbep-ettyp,
         rate              TYPE prcd_elements-kbetr,
         currency          TYPE prcd_elements-waers,
         currency_conv     TYPE prcd_elements-kkurs,
         pending_so_amount TYPE vbap-kwmeng,
         ofm               TYPE datum,
         cust_Deldate      TYPE vbap-custdeldate,
         po_date           TYPE vbkd-bstdk,
         ctbg              TYPE vbap-ctbg,
         ofm_date          TYPE vbap-ofm_date,
         po_ofm            TYPE char10,
         ofm_po            TYPE char10,
         so_rel            TYPE char10,
         rel_del           TYPE char10,
         code_mrp          TYPE char10,
         tarmrp_mrpdate    TYPE char10,

       END OF ty_final.

DATA :lt_final TYPE STANDARD TABLE OF ty_final,
      ls_final TYPE ty_final.
DATA: ls_fcat TYPE slis_fieldcat_alv,
      lt_fcat TYPE STANDARD TABLE OF slis_fieldcat_alv.
data:lv_days type char10.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_so FOR vbak-vbeln,
                   s_kunnr FOR vbak-kunnr,
                   s_custd FOR vbap-custdeldate,
                    s_mrp  for cdhdr-UDATE OBLIGATORY,
                   s_ERDAT FOR vbak-erdat OBLIGATORY,
                   s_vkorg FOR vbak-vkorg OBLIGATORY,
                   s_vkbur for vbak-vkbur ,
                   s_rel FOR vbap-holdreldate.
SELECTION-SCREEN END OF BLOCK b1.




START-OF-SELECTION.

  PERFORM get.
  PERFORM dis_data.
*&---------------------------------------------------------------------*
*& Form get
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get .

  TYPES: BEGIN OF ty_vbeln90,
         vbeln90 TYPE c LENGTH 90,
         posnr type vbap-posnr,
       END OF ty_vbeln90.

DATA: lt_vbeln90 TYPE STANDARD TABLE OF ty_vbeln90,
      ls_vbeln90 TYPE ty_vbeln90,
      lv_obj type thead-tdname,
      lt_lines TYPE STANDARD TABLE OF TLINE.

  SELECT * FROM vbak INTO TABLE @DATA(lt_vbak)
    WHERE vbeln IN @s_so AND kunnr IN @s_kunnr
     AND vkorg IN @s_vkorg AND erdat IN @s_erdat and vkbur in @s_vkbur.
  IF  lt_vbak IS NOT INITIAL .
    SELECT * FROM vbap INTO TABLE @DATA(lt_vbap)
      FOR ALL ENTRIES IN @lt_vbak
      WHERE vbeln = @lt_vbak-vbeln
       AND holdreldate IN @s_rel
      AND custdeldate IN @s_custd .
    IF  lt_vbap IS NOT INITIAL.
      SELECT kunnr, name1 FROM kna1 INTO TABLE @DATA(lt_kna1)
        FOR ALL ENTRIES IN @lt_vbak
        WHERE kunnr = @lt_vbak-kunnr.
      SELECT * FROM prcd_elements INTO TABLE @DATA(lt_prcd)
        FOR ALL ENTRIES IN @lt_vbap
        WHERE knumv = @lt_vbap-knumv_ana AND kposn = @lt_vbap-posnr.
      SELECT vbeln , posnr ,bstkd,bstdk FROM vbkd INTO TABLE @DATA(lt_vbkd)
        FOR ALL ENTRIES IN @lt_vbap
         WHERE vbeln = @lt_vbap-vbeln ."AND posnr = @lt_vbap-posnr.
   SELECT vbeln, posnr , ettyp from vbep INTO TABLE @DATA(lt_vbep)
     FOR ALL ENTRIES IN @lt_vbap
     WHERE vbeln = @lt_vbap-vbeln and posnr = @lt_vbap-posnr.
    "" ""naga
      lt_vbeln90 = VALUE #(
  FOR vbap_line IN lt_vbap
    ( vbeln90 = vbap_line-vbeln
      posnr = vbap_line-posnr )
).

     SELECT c~objectid,
       c~changenr,
       c~tabkey,
       C~fname
  FROM cdpos AS c
  INNER JOIN @lt_vbeln90 AS v
     ON c~objectid = v~vbeln90
    AND substring( c~tabkey, 14, 6 ) = v~posnr
  WHERE c~fname = 'ETTYP'
  INTO TABLE @DATA(lt_cdpos).
IF  lt_cdpos is NOT INITIAL.
 select OBJECTID , CHANGENR, UDATE from cdhdr INTO TABLE @DATA(lt_cdhdr)
   FOR ALL ENTRIES IN @lt_cdpos
   WHERE OBJECTID = @lt_cdpos-OBJECTID and CHANGENR = @lt_cdpos-CHANGENR and udate in @s_mrp.
  if s_mrp is NOT INITIAL.

    endif.
ENDIF.

  """naga

    ENDIF.
  ENDIF.

  LOOP AT lt_vbap INTO DATA(ls_vbap).
    ls_final-hold_date = ls_vbap-holdreldate.
    ls_final-receipt_date = ls_vbap-receipt_date.
    ls_final-target_date = ls_vbap-zmrp_date.
    ls_final-item = ls_vbap-posnr.
  ls_final-deldate = ls_vbap-deldate.
    ls_final-cust_Deldate = ls_vbap-custdeldate.
    ls_final-mat = ls_vbap-matnr.
    ls_final-ofm_date = ls_vbap-ofm_date.
    ls_final-ctbg = ls_vbap-ctbg.
    ls_final-posnr = ls_vbap-posnr.
    ls_final-desc = ls_vbap-arktx.
    ls_final-so_qty = ls_vbap-kwmeng.
  READ TABLE lt_vbep INTO DATA(ls_vbep) with KEY vbeln = ls_vbap-vbeln posnr = ls_vbap-posnr.
  ls_final-so_status = ls_vbep-ettyp.
    READ TABLE lt_cdpos INTO DATA(ls_pos) with key  OBJECTID = ls_vbap-vbeln tabkey+13(6) = ls_vbap-posnr fname = 'ETTYP'.
      IF  ls_pos-changenr is NOT INITIAL.
        READ TABLE lt_cdhdr INTO DATA(ls_cdhdr) with key OBJECTID = ls_pos-objectid CHANGENR = ls_pos-CHANGENR. .
        IF sy-subrc = 0.
          ls_final-cdpos = ls_cdhdr-udate.
          ls_final-mrp_date = ls_cdhdr-udate.

        ENDIF.

      ENDIF.
      if s_mrp is NOT INITIAL and ls_final-mrp_date is INITIAL.
        continue.

        ENDIF.
    "" OFM
      lv_obj = ls_vbap-vbeln.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
       CLIENT                        = SY-MANDT
        id                            = 'Z016'
        language                      = sy-langu
        NAME                          = lv_obj
        OBJECT                        = 'VBBK'
*       ARCHIVE_HANDLE                = 0
*       LOCAL_CAT                     = ' '
*       USE_OLD_PERSISTENCE           = ABAP_FALSE
*     IMPORTING
*       HEADER                        =
*       OLD_LINE_COUNTER              =
      TABLES
        lines                         = lt_lines
     EXCEPTIONS
       ID                            = 1
       LANGUAGE                      = 2
       NAME                          = 3
       NOT_FOUND                     = 4
       OBJECT                        = 5
       REFERENCE_CHECK               = 6
       WRONG_ACCESS_TO_ARCHIVE       = 7
       OTHERS                        = 8
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    LOOP AT lt_lines INTO DATA(ls_line).
      if ls_line-tdline is NOT INITIAL.
      CONCATENATE ls_line-tdline+6(4) ls_line-tdline+3(2) ls_line-tdline+0(2) INTO  ls_final-ofm.
      ENDIF.
*    ls_final-ofm =  ls_line-tdline.
  ENDLOOP.

    "" OFM
    READ TABLE lt_vbkd INTO DATA(ls_vbkd) WITH KEY vbeln = ls_vbap-vbeln ."posnr = ls_vbap-posnr.
    ls_final-cust_ref = ls_vbkd-bstkd.
    ls_final-po_date = ls_vbkd-bstdk.
    READ TABLE lt_vbak INTO DATA(ls_vbak) WITH KEY vbeln = ls_vbap-vbeln.
    ls_final-so = ls_vbak-vbeln.
    ls_final-sales_office = ls_vbak-vkbur.
    ls_final-so_date  = ls_vbak-audat.
    READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr = ls_vbak-kunnr.
    ls_final-Cust_name = ls_kna1-name1.
    READ TABLE  lt_prcd INTO DATA(ls_prcd) WITH KEY knumv = ls_vbap-knumv_ana kposn = ls_vbap-posnr.
    ls_final-rate = ls_prcd-kbetr.
    ls_final-currency = ls_prcd-waers.
    ls_final-currency_conv = ls_prcd-kkurs.
*    days
    ls_final-pending_so_Amount = ls_final-so_qty *  ls_final-currency_conv * ls_final-rate.
    if ls_final-ofm  is NOT INITIAL  and ls_final-ofm ne '00000000' and ls_final-po_date is NOT INITIAL and ls_final-po_date ne '00000000' .
*    ls_final-po_ofm = ls_final-po_date - ls_final-ofm.
    ls_final-po_ofm =  ls_final-ofm - ls_final-po_date .
    else.
      ls_final-po_ofm = ' '.
      ENDIF.
     if  ls_final-so_date is NOT INITIAL  and ls_final-so_date  ne '00000000'and ls_final-target_date is
       NOT INITIAL and ls_final-target_date  ne '00000000'.
*    ls_final-so_mrp = ls_final-so_date - ls_final-target_date.
    ls_final-so_mrp =  ls_final-target_date - ls_final-so_date .
    else.
      ls_final-so_mrp = ' '.
      ENDIF.
      if ls_final-ofm is NOT INITIAL and  ls_final-ofm ne '000000000' and ls_final-so_date ne '00000000'
        and ls_final-so_date is NOT INITIAL.
*    ls_final-ofm_po = ls_final-ofm - ls_final-so_date.
    ls_final-ofm_po = ls_final-so_date - ls_final-ofm .
    else.
       ls_final-ofm_po = ' '.
      ENDIF.
      if  ls_final-so_date is NOT INITIAL and ls_final-so_date ne '00000000' and ls_final-hold_date is NOT INITIAL and
         ls_final-hold_date ne '00000000'.
*    ls_final-so_rel =  ls_final-so_date - ls_final-hold_date.
    ls_final-so_rel =  ls_final-hold_date - ls_final-so_date .
    else.
      ls_final-so_rel = ' '.
      ENDIF.
      if ls_final-hold_date is NOT INITIAL and ls_final-hold_date ne '00000000' and ls_final-receipt_date is NOT INITIAL and
        ls_final-receipt_date ne '00000000'.
*    ls_final-rel_del =  ls_final-hold_date - ls_final-receipt_date.
    ls_final-rel_del =   ls_final-receipt_date - ls_final-hold_date .
    else.
       ls_final-rel_del = ' '.
    ENDIF.
    if ls_final-receipt_date is NOT INITIAL and ls_final-receipt_date ne '00000000'
       and ls_final-target_date is NOT INITIAL and ls_final-target_date  ne '00000000'.
*    ls_final-code_mrp = ls_final-receipt_date - ls_final-target_date.
    ls_final-code_mrp =  ls_final-target_date - ls_final-receipt_date .
    else.
        ls_final-code_mrp = ' '.
    ENDIF.
    if ls_final-target_date is NOT  INITIAL and ls_final-target_date  ne '00000000'
        and ls_final-mrp_date is NOT INITIAL  and  ls_final-mrp_date ne '00000000'..
    ls_final-tarmrp_mrpdate =  ls_final-target_date  - ls_final-mrp_date.
    else.
      ls_final-tarmrp_mrpdate = ' '.
    ENDIF.
    if ls_final-target_date is NOT INITIAL and ls_final-target_date ne '00000000' .
    lv_days =  ls_final-target_date - ls_final-mrp_date .
    CONDENSE lv_days.
*    if lv_days is NOT IN.
    IF lv_days = '0'.
      ls_final-mrp_tag = 'ON TIME'.
      ELSEIF lv_days ca '-'.
         ls_Final-mrp_tag =  'DELAY'.
      ELSEIF lv_days > '0'.
        ls_final-mrp_tag = 'BEFORE TIME'.


    else.
      lv_days = ' '.
    ENDIF.

    ENDIF.
*    ENDIF.
APPEND ls_final to lt_final.
CLEAR :ls_final,ls_prcd,ls_kna1,ls_vbak,ls_vbkd,ls_vbap,ls_pos,ls_cdhdr,
        ls_vbep,lv_days.


  ENDLOOP.




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
  REFRESH lt_fcat.
  DATA: n TYPE i.
  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CUST_REF'.
  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-hotspot = 'X'.
  ls_fcat-seltext_l = 'Cust Referense No'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CUST_NAME'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Customer Name'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SALES_OFFICE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Sales_office'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Sales Order'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

 ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'POSNR'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Sales Order ITEM'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Sales Order Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CDPOS'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Changed Sales Order Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'HOLD_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Release Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'RECEIPT_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Code Receipt Dates'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'MRP_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'MRP DATE'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'TARGET_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Targeted MRP Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'MRP_TAG'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'MRP Tags'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO_MRP'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'SO Date to Targeted MRP Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'DELDATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Delivery Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CUST_DELDATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Customer Del Dt'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'MAT'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Material'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.





  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'DESC'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Description'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO_QTY'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'SO QTy'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.




  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO_STATUS'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'SO Status'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'RATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Rate'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CURRENCY'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Currency'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CURRENCY_CONV'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Currency Conv'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.





  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'PENDING_SO_AMOUNT'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Pending So Amount'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'OFM'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'OFM Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.







*  ls_fcat-col_pos = n + 1.
*  ls_fcat-fieldname = 'CUST_DELDATE'.
*  ls_fcat-tabname = 'LT_FINAL'.
*  ls_fcat-seltext_l = 'Cust Del Date'.
*  APPEND ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.





  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'PO_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'PO Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CTBG'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'CTBG Item Details'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'OFM_DATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'OFM Delivery Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'PO_OFM'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'PO date to OFM Date Diff'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'OFM_PO'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'OFM date to SO date diffrence'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'SO_REL'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'SO date to release date diffrence'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'REL_DEL'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Release date to code rcpt. Date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'CODE_MRP'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Code rcpt date to Target MRP date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos = n + 1.
  ls_fcat-fieldname = 'TARMRP_MRPDATE'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'Targeted MRP to MRP date'.
  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-cprog
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = lt_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB       =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = lt_final
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
