*&---------------------------------------------------------------------*
*& Include          ZUS_STOCKFI_NEW_AMDP_DOWN
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form download
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .
  LOOP AT LT_ET_SORT INTO DATA(LS_SORT).
    LS_FINAL-MATNR       = LS_SORT-MATNR.
    LS_FINAL-MATTXT      = LS_SORT-MATTXT.
    LS_FINAL-WRKST       = LS_SORT-WRKST.
    LS_FINAL-BRAND       = LS_SORT-BRAND.
    LS_FINAL-ZSERIES       = LS_SORT-ZSERIES.
    LS_FINAL-ZSIZE         = LS_SORT-ZSIZE.
    LS_FINAL-MOC           = LS_SORT-MOC.
    LS_FINAL-TYPE          = LS_SORT-TYPE.
    LS_FINAL-OPEN_QTY      = LS_SORT-OPEN_QTY.
    LS_FINAL-PRICE         = LS_SORT-PRICE.
    LS_FINAL-UN_QTY        = LS_SORT-UN_QTY.
    LS_FINAL-UN_VAL        = LS_SORT-UN_VAL.
    LS_FINAL-OPEN_QTY_V    = LS_SORT-OPEN_QTY_V.
    LS_FINAL-LABST         = LS_SORT-LABST.
    LS_FINAL-LABST_V       = LS_SORT-LABST_V.
    LS_FINAL-KULAB         = LS_SORT-KULAB.
    LS_FINAL-KULAB_V       = LS_SORT-KULAB_V.
    LS_FINAL-FREE_STOCK    = LS_SORT-FREE_STOCK.
    LS_FINAL-FREE_STOCK_V  = LS_SORT-FREE_STOCK_V.
    LS_FINAL-TRAN_QTY_NEW      = LS_SORT-TRAN_QTY_NEW.
    LS_FINAL-TRAN_QTY_V_NEW    = LS_SORT-TRAN_QTY_V_NEW     .
    LS_FINAL-SO_FALL_QTY   = LS_SORT-SO_FALL_QTY.
    LS_FINAL-SO_FALL_QTY_V = LS_SORT-SO_FALL_QTY_V  .
    LS_FINAL-PEND_PO_QTY   = LS_SORT-PEND_PO_QTY.
    LS_FINAL-PO_VALUE      = LS_SORT-PO_VALUE  .
    LS_FINAL-OPEN_INV      = LS_SORT-OPEN_INV.
    LS_FINAL-AMOUNT        = LS_SORT-AMOUNT   .
    LS_FINAL-VALUE         = LS_SORT-VALUE   .
    LS_FINAL-MENGE_104         = LS_SORT-MENGE_104   ."added by jyoti on 28.09.2024
    LS_FINAL-QTY_104_VAL         = LS_SORT-QTY_104_VAL  .."added by jyoti on 28.09.2024
    LS_FINAL-REF = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-REF
      IMPORTING
        OUTPUT = LS_FINAL-REF.

    CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
                    INTO LS_FINAL-REF SEPARATED BY '-'.
    LS_FINAL-MTART = LS_SORT-MTART.
    LS_FINAL-ERSDA = LS_SORT-ERSDA.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = LS_FINAL-ERSDA
      IMPORTING
        OUTPUT = LS_FINAL-ERSDA.

    CONCATENATE LS_FINAL-ERSDA+0(2) LS_FINAL-ERSDA+2(3) LS_FINAL-ERSDA+5(4)
    INTO LS_FINAL-ERSDA SEPARATED BY '-'.

    LS_FINAL-BKLAS = LS_SORT-BKLAS.

    APPEND LS_FINAL TO LT_FINAL.
    CLEAR LS_FINAL.
    CLEAR:LS_SORT.
  ENDLOOP.

  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      I_TAB_SAP_DATA       = LT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

    LV_FILE = 'ZUS_STOCK_BANK_US01_NEW.TXT'.
    CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.
    WRITE: / 'Material Stock Bank Report started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
DATA lv_string_1392 TYPE string.
DATA lv_crlf_1392 TYPE string.
lv_crlf_1392 = cl_abap_char_utilities=>cr_lf.
lv_string_1392 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1392 lv_crlf_1392 wa_csv INTO lv_string_1392.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1392 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

  LV_FILE = 'ZUS_STOCK_BANK_US01_NEW.TXT'.
    CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'Material Stock Bank Report started on', SY-DATUM, 'at', SY-UZEIT.
    OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
      IF SY-SUBRC = 0.
DATA lv_string_1433 TYPE string.
DATA lv_crlf_1433 TYPE string.
lv_crlf_1433 = cl_abap_char_utilities=>cr_lf.
lv_string_1433 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1433 lv_crlf_1433 wa_csv INTO lv_string_1433.
  CLEAR: wa_csv.
ENDLOOP.

TRANSFER lv_string_1433 TO lv_fullfile.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CVS_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Material Code'
              'Material Description'
              'USA Material Code'
              'Brand'
              'Series'
              'Size'
              'MOC'
              'Type'
              'Pending SO'
              'Pending So Value'
              'Unrestricted Quantity'
              'Unrestricted Value'
              'Pending So Sales Total'
              'Stock In Hand'
              'Stock In Hand Value'
              'Consignment Stock'
              'Consignment Stock Value'
              'Free Stock'
              'Free Stock Value'
              'Transit Qty'
              'Transit Value'
              'SO Short Fall Qty'
              'SO Short Fall Qty Value'
              'Pending PO Qty'
              'Pending PO Amount'
              'Open Invoice Qty'
              'Last Item Price'
              'Moving Price'
              'Refresh File Date'
              'Valuation Class'
              'Material Type'
              'Material Created Date'
              '104 Qty'
              '104 Qty Value'
*              'Transit Qty New'
*              'Transit Value New'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
