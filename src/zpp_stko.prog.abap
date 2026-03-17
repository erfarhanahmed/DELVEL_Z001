*&---------------------------------------------------------------------*
*& Report ZPP_STKO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_STKO.

TABLES : MAST .
TYPES: BEGIN OF TY_FINAL,
         WERKS         TYPE STRING,
         MATNR         TYPE STRING,
         STLTY         TYPE STRING,
         STLNR         TYPE STRING,
         STLAL         TYPE STRING,
         STKOZ         TYPE STRING,
         DATUV         TYPE STRING,
         LKENZ         TYPE STRING,
         LOEKZ         TYPE STRING,
         ANDAT         TYPE STRING,
         ANNAM         TYPE STRING,
         AEDAT         TYPE STRING,
         AENAM         TYPE STRING,
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
  SELECT-OPTIONS : S_WERKS FOR MAST-WERKS .
  SELECT-OPTIONS : S_MATNR FOR MAST-MATNR .
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."temp'.
  PARAMETERS P_DOWN AS CHECKBOX  .
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


*MAST	STLNR
*MAST	MATNR
*MAST	WERKS
*MAST	STLAN
*MAST	STLAL

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
SELECT  STLNR   ,
        MATNR   ,
        WERKS   ,
        STLAN   ,
        STLAL
   FROM MAST INTO TABLE @DATA(IT_MAST)
   WHERE MATNR IN @S_MATNR
    AND WERKS IN @S_WERKS.

IF IT_MAST IS NOT INITIAL .
  SELECT STLTY ,
         STLNR ,
         STLAL ,
         STKOZ ,
         DATUV ,
         LKENZ ,
         LOEKZ ,
         ANDAT ,
         ANNAM ,
         AEDAT ,
         AENAM
    FROM STKO INTO TABLE @DATA(IT_STKO)
     FOR ALL ENTRIES IN @IT_MAST
      WHERE  STLNR = @IT_MAST-STLNR .


ENDIF.


*LOOP AT IT_MAST INTO DATA(WA_MAST).



LOOP AT IT_STKO INTO DATA(WA_STKO).
  READ TABLE IT_MAST INTO DATA(WA_MAST) WITH KEY STLNR = WA_STKO-STLNR .

  WA_FINAL-MATNR          = WA_MAST-MATNR              .
  WA_FINAL-WERKS          = WA_MAST-WERKS              .

  WA_FINAL-STLTY          =   WA_STKO-STLTY            .
  WA_FINAL-STLNR          =   WA_STKO-STLNR            .
  WA_FINAL-STLAL          =   WA_STKO-STLAL            .
  WA_FINAL-STKOZ          =   WA_STKO-STKOZ            .

  IF  WA_STKO-DATUV IS NOT INITIAL .
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_STKO-DATUV
      IMPORTING
        OUTPUT = WA_FINAL-DATUV.
    CONCATENATE  WA_FINAL-DATUV+0(2)  WA_FINAL-DATUV+2(3)  WA_FINAL-DATUV+5(4)
                   INTO  WA_FINAL-DATUV SEPARATED BY '-'.
  ENDIF.

*  WA_FINAL-DATUV          =   WA_stko-DATUV            .
  WA_FINAL-LKENZ          =   WA_STKO-LKENZ            .
  WA_FINAL-LOEKZ          =   WA_STKO-LOEKZ            .

*  WA_FINAL-ANDAT          =   WA_STKO-ANDAT            .

  IF  WA_STKO-ANDAT IS NOT INITIAL .
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_STKO-ANDAT
      IMPORTING
        OUTPUT = WA_FINAL-ANDAT.
    CONCATENATE  WA_FINAL-ANDAT+0(2)  WA_FINAL-ANDAT+2(3)  WA_FINAL-ANDAT+5(4)
                   INTO  WA_FINAL-ANDAT SEPARATED BY '-'.
  ENDIF.

  WA_FINAL-ANNAM          =   WA_STKO-ANNAM            .

  IF WA_STKO-AEDAT IS NOT INITIAL .
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = WA_STKO-AEDAT
      IMPORTING
        OUTPUT = WA_FINAL-AEDAT.
    CONCATENATE   WA_FINAL-AEDAT+0(2)   WA_FINAL-AEDAT+2(3)   WA_FINAL-AEDAT+5(4)
                   INTO   WA_FINAL-AEDAT SEPARATED BY '-'.
  ENDIF.


  WA_FINAL-AENAM          =   WA_STKO-AENAM            .


  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      INPUT  = SY-DATUM
    IMPORTING
      OUTPUT = WA_FINAL-REFRESH_ON_DT.
  CONCATENATE  WA_FINAL-REFRESH_ON_DT+0(2)  WA_FINAL-REFRESH_ON_DT+2(3)  WA_FINAL-REFRESH_ON_DT+5(4)
                 INTO  WA_FINAL-REFRESH_ON_DT SEPARATED BY '-'.


  CONCATENATE SY-TIMLO+0(2) ':' SY-TIMLO+2(2) INTO WA_FINAL-REFRESH_ON_TM .

  APPEND WA_FINAL TO IT_FINAL .
  CLEAR : WA_FINAL , WA_STKO ,WA_MAST .
ENDLOOP.




IF P_DOWN  = 'X'.
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
  LV_FILE = 'ZSTKO.TXT'.

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
           'Plant'                                 "        WERKS
           'Material'                              "        STLTY
           'BOM category'                          "        STLTY
           'BOM'                                   "        STLNR
           'Alternative'                           "        STLAL
           'Counter'                               "        STKOZ
           'Valid-From Date'                       "        DATUV
           'Deletion Indicator'                    "        LKENZ
           'Deletion flag for BOMs'                "        LOEKZ
           'Date Record Created On'                "        ANDAT
           'User created record'                   "        ANNAM
           'Last Changed On'                       "        AEDAT
           'Name of Person'                        "         AENAM
           'Refresh Date'                          "         REFRESH_ON_DT
           'Refresh Time'                           "        REFRESH_ON_TM
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
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FCATE  CHANGING CT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.


  DATA:
    GV_POS      TYPE I,
    LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

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
  LS_FIELDCAT-FIELDNAME = 'STLTY'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'BOM category' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STLNR'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'BOM' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STLAL'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Alternative' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'STKOZ'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Counter' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'DATUV'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Valid-From Date' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LKENZ'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Deletion Indicator' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'LOEKZ'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Deletion flag for BOMs' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ANDAT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Date Record Created On' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'ANNAM'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'User created record' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AEDAT'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Last Changed On' .
  LS_FIELDCAT-COL_POS   = GV_POS.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND LS_FIELDCAT TO CT_FIELDCAT.
  CLEAR LS_FIELDCAT.

  GV_POS = GV_POS + 1.
  LS_FIELDCAT-FIELDNAME = 'AENAM'.
*  ls_fieldcat-outputlen = '5'.
  LS_FIELDCAT-TABNAME   = 'IT_FINAL'.
  LS_FIELDCAT-SELTEXT_M = 'Name of Person' .
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
