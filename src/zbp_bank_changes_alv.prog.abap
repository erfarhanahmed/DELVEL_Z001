*&---------------------------------------------------------------------*
*& Report zbp_bank_changes_alv
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBP_BANK_CHANGES_ALV.

TABLES: BUT000.

TYPES: BEGIN OF TY_OUT_TXT,
         OBJECTID  TYPE CDOBJECTV,
         USERNAME  TYPE CDUSERNAME,
         UDATE     TYPE CHAR11,   "16-JAN-2026
         UTIME     TYPE CDUZEIT,
         VALUE_NEW TYPE CDFLDVALN,
         VALUE_OLD TYPE CDFLDVALO,
         CHNGIND   TYPE CHAR10,
         FNAME     TYPE STRING,
         REF_ON    TYPE CHAR11,
         REF_TIM   TYPE SY-UZEIT,
       END OF TY_OUT_TXT.

TYPES: BEGIN OF TY_ALV,
         OBJECTID  TYPE CDOBJECTV,
         USERNAME  TYPE CDUSERNAME,
         UDATE     TYPE CDDATUM,
         UTIME     TYPE CDUZEIT,
         VALUE_NEW TYPE CDFLDVALN,
         VALUE_OLD TYPE CDFLDVALO,
         CHNGIND   TYPE CHAR10,
         FNAME     TYPE FIELDNAME,
         REF_ON    TYPE DATS,
         REF_TIM   TYPE SY-UZEIT,
       END OF TY_ALV.

DATA: LT_ALV TYPE TABLE OF TY_ALV,
      LS_ALV TYPE TY_ALV.

DATA GT_TXT TYPE STANDARD TABLE OF TY_OUT_TXT.
DATA LS_TXT TYPE TY_OUT_TXT.

TYPES: BEGIN OF TY_MONTH,
         NUM  TYPE CHAR02,
         NAME TYPE CHAR03,
       END OF TY_MONTH.

DATA GT_MONTH TYPE STANDARD TABLE OF TY_MONTH WITH EMPTY KEY.

DATA: GT_DATA TYPE ZCL_AMDP_BP_CHANGES=>TT_OUT,
      GO_ALV  TYPE REF TO CL_SALV_TABLE.

DATA: LT_BP_RANGE TYPE ZCL_AMDP_BP_CHANGES=>TT_BP_RANGE,
      LT_DT_RANGE TYPE ZCL_AMDP_BP_CHANGES=>TT_DATE_RANGE.

CONSTANTS LC_PATH TYPE STRING  VALUE '/Delval/India'.

TYPE-POOLS TRUXS.

DATA:
  IT_CSV TYPE TRUXS_T_TEXT_DATA,
  WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
  HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

SELECT-OPTIONS:
  S_BP   FOR BUT000-PARTNER,
  S_DATE FOR SY-DATUM.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER TYPE STRING LOWER CASE."'/Delval/India'."India'."temp'. " 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN :BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
SELECTION-SCREEN: END OF BLOCK B4.

INITIALIZATION.
  P_FOLDER = LC_PATH.
  GT_MONTH = VALUE #(
   ( NUM = '01' NAME = 'JAN' )
   ( NUM = '02' NAME = 'FEB' )
   ( NUM = '03' NAME = 'MAR' )
   ( NUM = '04' NAME = 'APR' )
   ( NUM = '05' NAME = 'MAY' )
   ( NUM = '06' NAME = 'JUN' )
   ( NUM = '07' NAME = 'JUL' )
   ( NUM = '08' NAME = 'AUG' )
   ( NUM = '09' NAME = 'SEP' )
   ( NUM = '10' NAME = 'OCT' )
   ( NUM = '11' NAME = 'NOV' )
   ( NUM = '12' NAME = 'DEC' )
  ).

START-OF-SELECTION.

  LOOP AT S_BP ASSIGNING FIELD-SYMBOL(<FS_BP>).
    APPEND VALUE ZCL_AMDP_BP_CHANGES=>TY_BP_RANGE(
      SIGN   = <FS_BP>-SIGN
      OPTION = <FS_BP>-OPTION
      LOW    = <FS_BP>-LOW
      HIGH   = <FS_BP>-HIGH
    ) TO LT_BP_RANGE.
  ENDLOOP.

  LOOP AT S_DATE ASSIGNING FIELD-SYMBOL(<DT>).
    APPEND VALUE #( SIGN = <DT>-SIGN OPTION = <DT>-OPTION
                    LOW  = <DT>-LOW  HIGH   = <DT>-HIGH ) TO LT_DT_RANGE.

  ENDLOOP.



  ZCL_AMDP_BP_CHANGES=>GET_BANK_DETAILS(
    EXPORTING
      IV_CLIENT     = SY-MANDT
      IV_BP_RANGE   = LT_BP_RANGE
      IV_DATE_RANGE = LT_DT_RANGE
*     iv_date_to    = p_datet
    IMPORTING
      ET_CHANGES    = GT_DATA ).

  IF GT_DATA IS INITIAL.
    MESSAGE 'No changes found for the selected BP' TYPE 'I'.
    RETURN.
  ENDIF.

  LOOP AT GT_DATA ASSIGNING FIELD-SYMBOL(<FS_DATA>).
    IF <FS_DATA> IS ASSIGNED.

      SHIFT <FS_DATA>-OBJECTID LEFT DELETING LEADING '0'.

      CASE <FS_DATA>-CHNGIND.
        WHEN 'U'.
          <FS_DATA>-CHNGIND = 'Changed'.
        WHEN 'E'.
          <FS_DATA>-CHNGIND = 'Deleted'.
      ENDCASE.

      CASE <FS_DATA>-FNAME.
        WHEN 'BANKN'.
          <FS_DATA>-FNAME = 'Bank Account Number'.
        WHEN 'BANKL'.
          <FS_DATA>-FNAME = 'Bank Key'.
        WHEN 'ACCNAME'.
          <FS_DATA>-FNAME = 'Account Name'.
        WHEN 'KOINH'.
          <FS_DATA>-FNAME = 'Account Holder'.
        WHEN 'BKONT'.
          <FS_DATA>-FNAME = 'Control Key'.
        WHEN 'BKEXT'.
          <FS_DATA>-FNAME = 'External ID'.
        WHEN 'BKREF'.
          <FS_DATA>-FNAME = 'Reference details'.
      ENDCASE..
    ENDIF.
  ENDLOOP..

  LOOP AT GT_DATA INTO DATA(WA_DATA).
    MOVE-CORRESPONDING WA_DATA TO LS_ALV.
    LS_ALV-REF_ON = SY-DATUM.
    LS_ALV-REF_TIM = SY-UZEIT.
    APPEND LS_ALV TO LT_ALV.
    CLEAR: WA_DATA, LS_ALV.
  ENDLOOP.

  CL_SALV_TABLE=>FACTORY(
    IMPORTING
      R_SALV_TABLE = GO_ALV
    CHANGING
      T_TABLE      = LT_ALV ).

  GO_ALV->GET_COLUMNS( )->SET_OPTIMIZE( ABAP_TRUE ).
  DATA(LO_COLUMNS) = GO_ALV->GET_COLUMNS( ).
  "DATA(lo_column) TYPE REF TO cl_salv_column.

  TRY.
      LO_COLUMNS->GET_COLUMN( 'OBJECTID' )->SET_SHORT_TEXT( CONV #( TEXT-S02 ) ).
      LO_COLUMNS->GET_COLUMN( 'OBJECTID' )->SET_MEDIUM_TEXT( CONV #( TEXT-S02 ) ).
      LO_COLUMNS->GET_COLUMN( 'OBJECTID' )->SET_LONG_TEXT( CONV #( TEXT-S02 ) ).

      LO_COLUMNS->GET_COLUMN( 'UDATE' )->SET_SHORT_TEXT( CONV #( TEXT-S06 ) ).
      LO_COLUMNS->GET_COLUMN( 'UDATE' )->SET_MEDIUM_TEXT( CONV #( TEXT-S06 ) ).
      LO_COLUMNS->GET_COLUMN( 'UDATE' )->SET_LONG_TEXT( CONV #( TEXT-S06 ) ).

      LO_COLUMNS->GET_COLUMN( 'FNAME' )->SET_SHORT_TEXT( CONV #( TEXT-S05 ) ).
      LO_COLUMNS->GET_COLUMN( 'FNAME' )->SET_MEDIUM_TEXT( CONV #( TEXT-S05 ) ).
      LO_COLUMNS->GET_COLUMN( 'FNAME' )->SET_LONG_TEXT( CONV #( TEXT-S05 ) ).

      LO_COLUMNS->GET_COLUMN( 'CHNGIND' )->SET_SHORT_TEXT( CONV #( TEXT-S01 ) ).
      LO_COLUMNS->GET_COLUMN( 'CHNGIND' )->SET_MEDIUM_TEXT( CONV #( TEXT-S01 ) ).
      LO_COLUMNS->GET_COLUMN( 'CHNGIND' )->SET_LONG_TEXT( CONV #( TEXT-S01 ) ).

      LO_COLUMNS->GET_COLUMN( 'REF_ON' )->SET_SHORT_TEXT( CONV #( TEXT-S03 ) ).
      LO_COLUMNS->GET_COLUMN( 'REF_ON' )->SET_MEDIUM_TEXT( CONV #( TEXT-S03 ) ).
      LO_COLUMNS->GET_COLUMN( 'REF_ON' )->SET_LONG_TEXT( CONV #( TEXT-S03 ) ).

      LO_COLUMNS->GET_COLUMN( 'REF_TIM' )->SET_SHORT_TEXT( CONV #( TEXT-S04 ) ).
      LO_COLUMNS->GET_COLUMN( 'REF_TIM' )->SET_MEDIUM_TEXT( CONV #( TEXT-S04 ) ).
      LO_COLUMNS->GET_COLUMN( 'REF_TIM' )->SET_LONG_TEXT( CONV #( TEXT-S04 ) ).

    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
  GO_ALV->DISPLAY( ).


*&---------------------------------------------------------------------*
*& Form DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .
  DATA:
    LV_FILE     TYPE STRING,
    LV_FULLFILE TYPE STRING,
    LV_MSG      TYPE STRING,
    LV_CRLF     TYPE STRING.

  LV_CRLF = CL_ABAP_CHAR_UTILITIES=>CR_LF.

  CLEAR IT_CSV.

  CLEAR GT_TXT.

  LOOP AT GT_DATA INTO DATA(LS_DATA).
    CLEAR LS_TXT.
    MOVE-CORRESPONDING LS_DATA TO LS_TXT.

    DATA(LV_DAY)   = LS_DATA-UDATE+6(2).
    DATA(LV_MONTH) = LS_DATA-UDATE+4(2).
    DATA(LV_YEAR)  = LS_DATA-UDATE+0(4).

    READ TABLE GT_MONTH INTO DATA(LS_MONTH)
      WITH KEY NUM = LV_MONTH.

    IF SY-SUBRC = 0.
      CONCATENATE LV_DAY '-' LS_MONTH-NAME '-' LV_YEAR
        INTO LS_TXT-UDATE.
    ENDIF.

    "Date format: 16-JAN-2026
    "WRITE ls_data-udate TO ls_txt-udate.
*    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
*      EXPORTING
*        DATE_INTERNAL = LS_DATA-UDATE
*      IMPORTING
*        DATE_EXTERNAL = LS_TXT-UDATE.

    DATA(LV_CURDAY) = SY-DATUM+6(2).
    DATA(LV_CURMON) = SY-DATUM+4(2).
    DATA(LV_CURYEAR) = SY-DATUM+0(4).

    READ TABLE GT_MONTH INTO DATA(LS_MONTH1) WITH KEY NUM = LV_CURMON.
    IF SY-SUBRC = 0.

      CONCATENATE LV_CURDAY '-' LS_MONTH1-NAME '-' LV_CURYEAR INTO LS_TXT-REF_ON.
    ENDIF.


    "LS_TXT-REF_ON  = SY-DATUM.                            "Added by prathmesh Haldankar 4.02.2026
    LS_TXT-REF_TIM = SY-UZEIT.                            "Added by prathmesh Haldankar 4.02.2026

    APPEND LS_TXT TO GT_TXT.
  ENDLOOP.

  "--------------------------------------------------
  " Convert internal table to TXT format
  "--------------------------------------------------
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*    TABLES
*      I_TAB_SAP_DATA       = GT_DATA     " <-- your ALV data
*      I_TAB_CONVERTED_DATA = IT_CSV
*    EXCEPTIONS
*      CONVERSION_FAILED    = 1
*      OTHERS               = 2.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
* EXPORTING
*   I_FIELD_SEPERATOR          =
*   I_LINE_HEADER              =
*   I_FILENAME                 =
*   I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_TXT
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


  IF SY-SUBRC <> 0.
    MESSAGE 'TXT conversion failed' TYPE 'E'.
    RETURN.
  ENDIF.

  "--------------------------------------------------
  " Header
  "--------------------------------------------------
  PERFORM CVS_HEADER USING HD_CSV.

  LV_FILE = 'ZBP_BANK_CHANGES.TXT'.
  CONCATENATE P_FOLDER '/' LV_FILE INTO LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  IF SY-SUBRC <> 0.
    MESSAGE 'Unable to open file on server' TYPE 'E'.
    RETURN.
  ENDIF.

  "--------------------------------------------------
  " Write Header + Data
  "--------------------------------------------------
  DATA(LV_STRING) = HD_CSV.

  LOOP AT IT_CSV INTO WA_CSV.
    CONCATENATE LV_STRING LV_CRLF WA_CSV INTO LV_STRING.
  ENDLOOP.

  TRANSFER LV_STRING TO LV_FULLFILE.
  CLOSE DATASET LV_FULLFILE.

  CONCATENATE 'File' LV_FULLFILE 'downloaded successfully'
    INTO LV_MSG SEPARATED BY SPACE.

  MESSAGE LV_MSG TYPE 'S'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CVS_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM CVS_HEADER  USING    P_HD_CSV.
  DATA LV_SEP TYPE C.
  LV_SEP = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
    'Business Partner'
    'User'
    'Change Date'
    'Change Time'
    'New Value'
    'Old Value'
    'Change Indicator'
    'Field Name'
    'Refreshed On'
    'Refreshed Time'
    INTO P_HD_CSV
    SEPARATED BY LV_SEP.


ENDFORM.
