*&---------------------------------------------------------------------*
*& Report ZMRP_AREA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMRP_AREA.
TABLES : MDMA.


TYPES: BEGIN OF TY_FINAL,
         WERKS         TYPE STRING,
         MATNR         TYPE STRING,
         BERID         TYPE STRING,
         REFRESH_ON_DT TYPE STRING,
         REFRESH_ON_TM TYPE STRING,
       END OF TY_FINAL.

DATA: WA_FINAL TYPE TY_FINAL,
      IT_FINAL TYPE TABLE OF TY_FINAL,
      HD_CSV   TYPE LINE OF TRUXS_T_TEXT_DATA.


DATA: LV_MSG(80).

DATA: LV_FILE(30).
DATA: LV_FULLFILE TYPE STRING,
      IT_CSV      TYPE TRUXS_T_TEXT_DATA.



SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC.
  SELECT-OPTIONS : S_WERKS FOR MDMA-WERKS ,
                   S_MATNR FOR MDMA-MATNR ,
                   S_BERID FOR MDMA-BERID .
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
  PARAMETERS P_DOWN AS CHECKBOX  .
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.

SELECT WERKS,
       MATNR,
       BERID
  FROM MDMA
   INTO TABLE @DATA(IT_MDMA)
     WHERE WERKS   IN @S_WERKS
      AND  MATNR   IN @S_MATNR
      AND  BERID   IN @S_BERID
      AND  DISMM  = 'ND' .


IF  IT_MDMA IS NOT INITIAL .


  LOOP AT IT_MDMA INTO DATA(WA_MDMA).
    WA_FINAL-WERKS = WA_MDMA-WERKS .
    WA_FINAL-MATNR = WA_MDMA-MATNR .
    WA_FINAL-BERID = WA_MDMA-BERID .

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_FINAL-REFRESH_ON_DT.
    CONCATENATE  WA_FINAL-REFRESH_ON_DT+0(2)  WA_FINAL-REFRESH_ON_DT+2(3)  WA_FINAL-REFRESH_ON_DT+5(4)
                   INTO  WA_FINAL-REFRESH_ON_DT SEPARATED BY '-'.

    CONCATENATE SY-TIMLO+0(2) ':' SY-TIMLO+2(2) INTO WA_FINAL-REFRESH_ON_TM .

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR : WA_MDMA , WA_FINAL .
  ENDLOOP.


ELSE.

  MESSAGE: 'Data Not Found' TYPE 'E'.

ENDIF.

IF P_DOWN IS  INITIAL .
  PERFORM : ALV.
ELSE.
  PERFORM DOWNLOAD.

ENDIF.
*&---------------------------------------------------------------------*
*& Form ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ALV .



  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
    CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'WERKS'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Plant' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Material' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BERID'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Mrp area' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-CPROG
      IT_FIELDCAT        = CT_FIELDCAT
      I_DEFAULT          = 'X'
      I_SAVE             = 'A'
    TABLES
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_FINAL "it_output
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.
  LV_FILE = 'ZMRPEX.TXT'.

  CONCATENATE P_FOLDER '/'  LV_FILE
INTO LV_FULLFILE.



  OPEN DATASET LV_FULLFILE
  FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  IF SY-SUBRC = 0.
    DATA LV_STRING_1362 TYPE STRING.
    DATA LV_CRLF_1362 TYPE STRING.
    LV_CRLF_1362 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1362 = HD_CSV.

    LOOP AT IT_CSV INTO DATA(WA_CSV).
      CONCATENATE LV_STRING_1362 LV_CRLF_1362 WA_CSV INTO LV_STRING_1362.
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_1362 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


ENDFORM.
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.  CONCATENATE
           'Plant'                                 "        WERKS
           'Material'                              "        STLTY
           'MRP Area'    INTO PD_CSV
   SEPARATED BY L_FIELD_SEPERATOR.




ENDFORM.
