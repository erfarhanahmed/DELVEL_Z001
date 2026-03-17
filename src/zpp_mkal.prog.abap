*&---------------------------------------------------------------------*
*& Report ZPP_MKAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_MKAL.
TABLES : MKAL .
TYPES: BEGIN OF TY_FINAL,
         MATNR         TYPE STRING,
         WERKS         TYPE STRING,
         VERID         TYPE STRING,
         BDATU         TYPE STRING,
         ADATU         TYPE STRING,
         REFRESH_ON_DT TYPE STRING,
         REFRESH_ON_TM TYPE STRING,
       END OF TY_FINAL.
DATA: WA_FINAL TYPE TY_FINAL,
      IT_FINAL TYPE TABLE OF TY_FINAL,
      HD_CSV   TYPE LINE OF TRUXS_T_TEXT_DATA.

DATA: LV_FILE(30).
DATA: LV_FULLFILE TYPE STRING,
      IT_CSV      TYPE TRUXS_T_TEXT_DATA.

DATA: LV_MSG(80).

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE ABC.

  SELECT-OPTIONS : S_WERKS FOR MKAL-WERKS .
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
  PARAMETERS P_DOWN AS CHECKBOX  .
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
SELECT * FROM MKAL
  INTO TABLE @DATA(IT_MKAL)
   WHERE WERKS IN @S_WERKS.

LOOP AT IT_MKAL INTO DATA(WA_MKAL).

  WA_FINAL-MATNR                           =  WA_MKAL-MATNR                              .
  WA_FINAL-WERKS                           =  WA_MKAL-WERKS                              .
  WA_FINAL-VERID                           =  WA_MKAL-VERID                              .


  IF  WA_MKAL-BDATU IS NOT INITIAL .
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_MKAL-BDATU
      IMPORTING
        OUTPUT = WA_FINAL-BDATU.
    CONCATENATE  WA_FINAL-BDATU+0(2)  WA_FINAL-BDATU+2(3)  WA_FINAL-BDATU+5(4)
                   INTO  WA_FINAL-BDATU SEPARATED BY '-'.
  ENDIF.


  WA_FINAL-ADATU                           =  WA_MKAL-ADATU                              .

  IF  WA_MKAL-ADATU IS NOT INITIAL .
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_MKAL-ADATU
      IMPORTING
        OUTPUT = WA_FINAL-ADATU.
    CONCATENATE  WA_FINAL-ADATU+0(2)  WA_FINAL-ADATU+2(3)  WA_FINAL-ADATU+5(4)
                   INTO  WA_FINAL-ADATU SEPARATED BY '-'.
  ENDIF.



  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = SY-DATUM
    IMPORTING
      OUTPUT = WA_FINAL-REFRESH_ON_DT.
  CONCATENATE  WA_FINAL-REFRESH_ON_DT+0(2)  WA_FINAL-REFRESH_ON_DT+2(3)  WA_FINAL-REFRESH_ON_DT+5(4)
                 INTO  WA_FINAL-REFRESH_ON_DT SEPARATED BY '-'.



  CONCATENATE SY-TIMLO+0(2) ':' SY-TIMLO+2(2) INTO WA_FINAL-REFRESH_ON_TM .

  APPEND WA_FINAL TO IT_FINAL .

ENDLOOP.

IF P_DOWN IS NOT INITIAL .
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
  LV_FILE = 'ZMKAL.TXT'.

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
ELSE.

  PERFORM DIS_ALV.
ENDIF.

FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.  CONCATENATE
           'Material Number'                         " MATNR
           'Plant'                                   " WERKS
           'Production Version'                      " VERID
           'Valid-To Date'                           " BDATU
           'Valid-From Date'                         " ADATU
           'Refresh Date'                            " REFRESH_ON_DT
           'Refresh Time'                            " REFRESH_ON_TM
              INTO PD_CSV
   SEPARATED BY L_FIELD_SEPERATOR.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form DIS_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DIS_ALV .

  DATA:
    LT_FIELDCAT   TYPE SLIS_T_FIELDCAT_ALV,
    LS_ALV_LAYOUT TYPE SLIS_LAYOUT_ALV.


  PERFORM FCATE CHANGING LT_FIELDCAT.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-CPROG
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      IT_FIELDCAT        = LT_FIELDCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      I_DEFAULT          = 'X'
      I_SAVE             = 'A'
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
      T_OUTTAB           = IT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FCATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_FIELDCAT
*&---------------------------------------------------------------------*
FORM FCATE  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.


  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  REFRESH CT_FIELDCAT.
  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'MATNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Material Number' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

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
  LS_FIELDCAT-FIELDNAME = 'VERID'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Production Version' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

     GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'BDATU'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Valid-To Date' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


     GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ADATU'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Valid-From Date' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

     GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'REFRESH_ON_DT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Refresh Date' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

     GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'REFRESH_ON_TM'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Refresh Time' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.


ENDFORM.
