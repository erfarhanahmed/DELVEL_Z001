*&---------------------------------------------------------------------*
*& Report ZSO_DAY_PENDING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zso_day_pending.

TYPES :BEGIN OF ty_final,
         bstkd type vbkd-bstkd,
           audat type vbak-aedat,
           auart type vbak-auart,
           vbeln type vbak-vbeln,
           posnr type vbap-posnr,
           kunnr type kna1-kunnr,
           matnr type vbap-matnr,
           kwmeng type vbap-kwmeng,
           vrkme type vbap-vrkme,
*           netwr_ap type vbap-netwr,
           vbap_netwr type vbap-netwr,
           waerk type vbap-waerk,
                  END OF ty_final.

data: lt_so type STANDARD TABLE OF ty_final.
data: lt_final type STANDARD TABLE OF ZDAY_PEND_SO,
      ls_final type ZDAY_PEND_SO.
DATA : lr_coll TYPE REF TO data.

FIELD-SYMBOLS : <lt_coll> TYPE ANY TABLE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*  SELECT-OPTIONS : s_date for vbak-aedat.
  PARAMETERS : s_date TYPE vbak-aedat DEFAULT sy-datum.

*                saleord type vbak-vbeln.
SELECTION-SCREEN END OF BLOCK b1.






START-OF-SELECTION.
  PERFORM get_data.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
*select *  from ZDAY_PEND_SO   INto TABLE @DATA(lt_zso)
*  WHERE CREATEDDATE le '20250119' .
*delete ZDAY_PEND_SO FROM TABLE lt_zso.

  cl_salv_bs_runtime_info=>set( EXPORTING display  = abap_false
                                                metadata = abap_false
                                                data     = abap_true ).
  TRY.
      SUBMIT  sd_sales_document_view
        USING SELECTION-SET 'PENDINGSOBOARD'
*                  WITH dd_kunnr IN so_kunnr
                      EXPORTING LIST TO MEMORY
                         AND RETURN .
    CATCH cx_root.
  ENDTRY.

  TRY.
      cl_salv_bs_runtime_info=>get_data_ref( IMPORTING r_data = lr_coll ).
      ASSIGN lr_coll->* TO <lt_coll>.
    CATCH cx_salv_bs_sc_runtime_info.
      MESSAGE TEXT-003 TYPE 'I'.
  ENDTRY.
  cl_salv_bs_runtime_info=>clear_all( ).
  IF <lt_coll> IS ASSIGNED.
*          REFRESH : IT_BOM .
    CLEAR : lr_coll.
          MOVE-CORRESPONDING <LT_COLL> TO lT_so.
    UNASSIGN :  <lt_coll>  .
  ENDIF.
  if lt_so is NOT INITIAL.
  SElect * from i_salesdocumentitemanalytics INto TABLE @DATA(lt_sales)
    FOR ALL ENTRIES IN @lt_so
    WHERE salesdocument = @lt_so-vbeln and salesdocumentitem = @lt_so-posnr.

SELECT d~referencesddocument,
       d~referencesddocumentitem,
       SUM( d~actualdeliveryquantity ) AS actualdeliveryquantity

  FROM i_deliverydocumentitem AS d
  INNER JOIN @lt_so AS s
    ON d~referencesddocument     = s~vbeln
   AND d~referencesddocumentitem = s~posnr

  GROUP BY d~referencesddocument,
           d~referencesddocumentitem  INTO TABLE @DATA(lt_delivery)..
    endif.

  LOOP AT lT_so ASSIGNING FIELD-SYMBOL(<fs>).
   if <fs> is ASSIGNED.
     ls_final-vbeln = <fs>-vbeln.
     ls_final-audat = <fs>-audat.
     ls_final-bstkd = <fs>-bstkd.
     ls_final-createddate = sy-datum.
     ls_final-creationtime = sy-uzeit.
     ls_final-kunag = <fs>-KUnnr.
     READ TABLE lt_sales INTO DATA(ls_sales) with key  salesdocument = <fs>-vbeln  salesdocumentitem = <fs>-posnr.
     READ TABLE lt_delivery INTO DATA(ls_deliver) with key referencesddocument = <fs>-vbeln  referencesddocumentitem = <fs>-posnr.
*     loop at lt_delivery INTO DATA(ls_deliver) where referencesddocument = <fs>-vbeln  and  referencesddocumentitem = <fs>-posnr.
     if ls_deliver-actualdeliveryquantity > '0'.
       ls_final-kwmeng = <fs>-kwmeng - ls_deliver-actualdeliveryquantity.
       ELSE.
          ls_final-kwmeng = <fs>-kwmeng.
       endif.
*       ENDLOOP.
       if ls_final-kwmeng is NOT INITIAL.
      ls_final-netwr_ap =   ls_final-kwmeng * ls_sales-netpriceamount ."*  ls_sales-PRICEDETNEXCHANGERATE.
      else.
        ls_final-kwmeng = ls_sales-TARGETQUANTITY.
        ls_final-netwr_ap = ls_final-kwmeng *  ls_sales-netpriceamount .
        endif.
*        read table
*     ls_final-kwmeng = <fs>-kwmeng.
     ls_final-matnr = <fs>-Matnr.
*     ls_final-netwr_ap = <fs>-netwr_ap.
*     ls_final-netwr_ap = <fs>-vbap_netwr.
     ls_final-posnr = <fs>-posnr.
     CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
       EXPORTING
         input                = <fs>-vrkme
*        LANGUAGE             = SY-LANGU
      IMPORTING
*        LONG_TEXT            =
        OUTPUT               =  ls_final-vrkme
*        SHORT_TEXT           =
      EXCEPTIONS
        UNIT_NOT_FOUND       = 1
        OTHERS               = 2
               .
     IF sy-subrc <> 0.
* Implement suitable error handling here
     ENDIF.

*     ls_final-vrkme = .
     ls_final-waerk = <fs>-waerk.
     ls_final-auart = <fs>-auart.
*     APPEND
     modify ZDAY_PEND_SO FROM ls_final.
     IF sy-subrc = 0.
      commit work.
      else.
        ROLLBACK WORK.
     ENDIF.
     CLEAR :ls_final,ls_sales,ls_deliver.


     endif.

  ENDLOOP.

ENDFORM.
