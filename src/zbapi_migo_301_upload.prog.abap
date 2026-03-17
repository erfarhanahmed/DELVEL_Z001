*&---------------------------------------------------------------------*
*& Report ZBDC_MIGO_301_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBAPI_MIGO_301_UPLOAD.
*
*TYPE-POOLS: TRUXS.
*
*TABLES: SSCRFIELDS.
*
*" Structure for Excel Data
*TYPES: BEGIN OF TY_DATA,
*         ROW_ID     TYPE I,
*         BLDAT      TYPE BLDAT,
*         BUDAT      TYPE BUDAT,
*         HEADER_TXT TYPE BAPI2017_GM_HEAD_01-HEADER_TXT,
*         MATNR      TYPE MATNR,
*         WERKS      TYPE WERKS_D,
*         LGORT      TYPE LGORT_D,
*         CHARG      TYPE CHARG_D, " Issuing Batch
*         UMWRK      TYPE UMWRK,
*         UMLGO      TYPE UMLGO,
*         UMCHA      TYPE UMCHA,   " Receiving Batch
*         ERFMG      TYPE ERFMG,
*         ITEM_TEXT  TYPE BAPI2017_GM_ITEM_CREATE-ITEM_TEXT,
*       END OF TY_DATA.
*
*TYPES: BEGIN OF TY_LOG,
*         ROW_ID  TYPE I,
*         STATUS  TYPE ICON_D,
*         MESSAGE TYPE STRING,
*         MBLNR   TYPE MBLNR,
*       END OF TY_LOG.
*
*DATA: IT_DATA TYPE STANDARD TABLE OF TY_DATA,
*      WA_DATA TYPE TY_DATA,
**      IT_BDC  TYPE STANDARD TABLE OF BDCDATA,
**      WA_BDC  TYPE BDCDATA,
*      IT_LOG  TYPE STANDARD TABLE OF TY_LOG,
*      WA_LOG  TYPE TY_LOG.
*
*SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*  PARAMETERS: P_FILE TYPE LOCALFILE.
*SELECTION-SCREEN END OF BLOCK B1.
*
*SELECTION-SCREEN FUNCTION KEY 1. " For Download Template Button
*
*INITIALIZATION.
*  SSCRFIELDS-FUNCTXT_01 = 'Download Template'.
*
*AT SELECTION-SCREEN.
*  IF SSCRFIELDS-UCOMM = 'FC01'.
*    PERFORM DOWNLOAD_TEMPLATE.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
*  PERFORM BROWSE_FILE.
*
*START-OF-SELECTION.
*  PERFORM UPLOAD_EXCEL.
*  PERFORM PROCESS_BAPI.
*  PERFORM DISPLAY_LOG.
*
***----------------------------------------------------------------------*
*** Form PROCESS_BDC
***----------------------------------------------------------------------*
**FORM PROCESS_BAPI.
**  LOOP AT IT_DATA INTO WA_DATA.
**    REFRESH: IT_BDC,IT_MSG.
**
**    " Screen 0001 - Initial Header
**    PERFORM BDC_INSERT USING 'SAPLMIGO' '0001' 'X' '' ''.
**    PERFORM BDC_INSERT USING '' '' '' 'BDC_OKCODE' '=OK_GO'.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-ACTION' 'A08'. " Transfer Posting
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-REFDOC' 'R10'. " Others
**    PERFORM BDC_INSERT USING '' '' '' 'GODEFAULT_TV-BWART' WA_DATA-BWART.
**    PERFORM BDC_INSERT USING '' '' '' 'GOHEAD-BLDAT' WA_DATA-BLDAT.
**    PERFORM BDC_INSERT USING '' '' '' 'GOHEAD-BUDAT' WA_DATA-BUDAT.
**
**    " Screen 0001 - Item Detail (Based on recording lines 29-38)
**    PERFORM BDC_INSERT USING 'SAPLMIGO' '0001' 'X' '' ''.
**    PERFORM BDC_INSERT USING '' '' '' 'BDC_OKCODE' '=OK_CHECK'.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-MAKTX' WA_DATA-MATNR.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-NAME1' WA_DATA-WERKS.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-LGOBE' WA_DATA-LGORT.
**    PERFORM BDC_INSERT USING '' '' '' 'GOITEM-UMNAME1' WA_DATA-UMWRK.
**    PERFORM BDC_INSERT USING '' '' '' 'GOITEM-UMLGOBE' WA_DATA-UMLGO.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-ERFMG' WA_DATA-ERFMG.
**    PERFORM BDC_INSERT USING '' '' '' 'GODYNPRO-DETAIL_TAKE' 'X'.
**
**    " Post Transaction
**    PERFORM BDC_INSERT USING 'SAPLMIGO' '0001' 'X' '' ''.
**    PERFORM BDC_INSERT USING '' '' '' 'BDC_OKCODE' '=OK_POST1'.
**
**    CALL TRANSACTION 'MIGO' USING IT_BDC MODE 'A' UPDATE 'S'.
**
**    CLEAR WA_LOG.
**    WA_LOG-ROW_ID = WA_DATA-ROW_ID.
**    READ TABLE IT_MSG INTO WA_MSG WITH KEY MSGTYP = 'S' MSGID = 'M7' MSGNR = '060'.
**    IF SY-SUBRC = 0.
**      WA_LOG-STATUS = '@0V@'. " Green Icon
**      WA_LOG-MBLNR  = WA_MSG-MSGV1.
**      WA_LOG-MESSAGE = 'Success'.
**    ELSE.
**      WA_LOG-STATUS = '@0W@'. " Red Icon
**      READ TABLE IT_MSG INTO WA_MSG WITH KEY MSGTYP = 'E'.
**      CALL FUNCTION 'FORMAT_MESSAGE'
**        EXPORTING
**          ID  = WA_MSG-MSGID
**          NO  = WA_MSG-MSGNR
**          V1  = WA_MSG-MSGV1
**          V2  = WA_MSG-MSGV2
**        IMPORTING
**          MSG = WA_LOG-MESSAGE.
**    ENDIF.
**    APPEND WA_LOG TO IT_LOG.
**
**  ENDLOOP.
**ENDFORM.
**&---------------------------------------------------------------------*
**& Form PROCESS_BAPI
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*FORM PROCESS_BAPI .
*  DATA: L_HEADER TYPE BAPI2017_GM_HEAD_01,
*        L_CODE   TYPE BAPI2017_GM_CODE,
*        L_MBLNR  TYPE BAPI2017_GM_HEAD_RET-MAT_DOC,
*        IT_ITEM  TYPE STANDARD TABLE OF BAPI2017_GM_ITEM_CREATE,
*        WA_ITEM  TYPE BAPI2017_GM_ITEM_CREATE,
*        IT_RET   TYPE STANDARD TABLE OF BAPIRET2,
*        WA_RET   TYPE BAPIRET2.
*
*  L_CODE-GM_CODE = '04'. " Transfer Posting Code
*
*  LOOP AT IT_DATA INTO WA_DATA.
*    REFRESH: IT_ITEM, IT_RET.
*    CLEAR: L_HEADER, L_MBLNR.
*
*    " Header Data Mapping
*    L_HEADER-PSTNG_DATE = WA_DATA-BUDAT.      "
*    L_HEADER-DOC_DATE   = WA_DATA-BLDAT.      "
*    L_HEADER-HEADER_TXT = WA_DATA-HEADER_TXT. "
*
*    " Item Data Mapping (Hardcoded 301)
*    WA_ITEM-MATERIAL   = WA_DATA-MATNR.      "
*    WA_ITEM-PLANT      = WA_DATA-WERKS.      "
*    WA_ITEM-STGE_LOC   = WA_DATA-LGORT.      "
*    WA_ITEM-BATCH      = WA_DATA-CHARG.      " Added Batch field
*    WA_ITEM-MOVE_TYPE  = '301'.              " Hardcoded 301
*    WA_ITEM-ENTRY_QNT  = WA_DATA-ERFMG.      "
*    WA_ITEM-ITEM_TEXT  = WA_DATA-ITEM_TEXT.  "
*
*    " Receiving Side Mapping
*    WA_ITEM-MOVE_MAT   = WA_DATA-MATNR.      "
*    WA_ITEM-MOVE_PLANT = WA_DATA-UMWRK.      "
*    WA_ITEM-MOVE_STLOC = WA_DATA-UMLGO.      "
*    WA_ITEM-MOVE_BATCH = WA_DATA-UMCHA.      " Receiving Batch
*    APPEND WA_ITEM TO IT_ITEM.
*
*    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
*      EXPORTING
*        GOODSMVT_HEADER  = L_HEADER
*        GOODSMVT_CODE    = L_CODE
*      IMPORTING
*        MATERIALDOCUMENT = L_MBLNR
*      TABLES
*        GOODSMVT_ITEM    = IT_ITEM
*        RETURN           = IT_RET.
*
*    WA_LOG-ROW_ID = WA_DATA-ROW_ID.
*    IF L_MBLNR IS NOT INITIAL.
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          WAIT = 'X'.
*      WA_LOG-STATUS  = ICON_LED_GREEN. " Green
*      WA_LOG-MBLNR   = L_MBLNR.
*      WA_LOG-MESSAGE = 'Success'.
*    ELSE.
*      WA_LOG-STATUS = ICON_LED_RED. " Red
*      READ TABLE IT_RET INTO WA_RET WITH KEY TYPE = 'E'.
*      IF SY-SUBRC <> 0.
*        READ TABLE IT_RET INTO WA_RET WITH KEY TYPE = 'A'.
*      ENDIF.
*      WA_LOG-MESSAGE = WA_RET-MESSAGE.
*    ENDIF.
*    APPEND WA_LOG TO IT_LOG.
*  ENDLOOP.
*ENDFORM.
*FORM DISPLAY_LOG.
*  DATA: LO_ALV TYPE REF TO CL_SALV_TABLE.
*  CALL METHOD CL_SALV_TABLE=>FACTORY
*    IMPORTING
*      R_SALV_TABLE = LO_ALV
*    CHANGING
*      T_TABLE      = IT_LOG.
*  LO_ALV->GET_FUNCTIONS( )->SET_ALL( ).
*  LO_ALV->DISPLAY( ).
*ENDFORM.
*
**----------------------------------------------------------------------*
** Helper Forms (File Handling)
**----------------------------------------------------------------------*
*FORM BROWSE_FILE.
*  CALL FUNCTION 'F4_FILENAME'
*    EXPORTING
*      PROGRAM_NAME = SY-REPID
*    IMPORTING
*      FILE_NAME    = P_FILE.
*ENDFORM.
*
*FORM UPLOAD_EXCEL.
*  DATA: IT_RAW TYPE STANDARD TABLE OF ALSMEX_TABLINE,
*        WA_RAW TYPE ALSMEX_TABLINE.
*
*  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
*    EXPORTING
*      FILENAME    = P_FILE
*      I_BEGIN_COL = 1
*      I_BEGIN_ROW = 2 " Start at 2 to skip header
*      I_END_COL   = 9
*      I_END_ROW   = 5000
*    TABLES
*      INTERN      = IT_RAW.
*
*  LOOP AT IT_RAW INTO WA_RAW.
*    CASE WA_RAW-COL.
*      WHEN 1.  WA_DATA-BLDAT      = WA_RAW-VALUE.
*      WHEN 2.  WA_DATA-BUDAT      = WA_RAW-VALUE.
*      WHEN 3.  WA_DATA-HEADER_TXT = WA_RAW-VALUE.
*      WHEN 4.  WA_DATA-MATNR      = WA_RAW-VALUE.
*      WHEN 5.  WA_DATA-WERKS      = WA_RAW-VALUE.
*      WHEN 6.  WA_DATA-LGORT      = WA_RAW-VALUE.
*      WHEN 7.  WA_DATA-CHARG      = WA_RAW-VALUE.
*      WHEN 8.  WA_DATA-UMWRK      = WA_RAW-VALUE.
*      WHEN 9.  WA_DATA-UMLGO      = WA_RAW-VALUE.
*      WHEN 10. WA_DATA-UMCHA      = WA_RAW-VALUE.
*      WHEN 11. WA_DATA-ERFMG      = WA_RAW-VALUE.
*      WHEN 12. WA_DATA-ITEM_TEXT  = WA_RAW-VALUE.
*    ENDCASE.
*    WA_DATA-ROW_ID = WA_RAW-ROW.
*    AT END OF ROW.
*      APPEND WA_DATA TO IT_DATA.
*      CLEAR WA_DATA.
*    ENDAT.
*  ENDLOOP.
*ENDFORM.
*
*FORM DOWNLOAD_TEMPLATE.
*  DATA: LV_FILENAME TYPE STRING,
*        LV_PATH     TYPE STRING,
*        LV_FULLPATH TYPE STRING,
*        C_TAB       TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*
*  LV_FILENAME = 'MIGO_301_Template.xls'.
*
*  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
*    EXPORTING
*      DEFAULT_FILE_NAME = LV_FILENAME
*    CHANGING
*      FILENAME          = LV_FILENAME
*      PATH              = LV_PATH
*      FULLPATH          = LV_FULLPATH.
*
*  IF LV_FULLPATH IS NOT INITIAL.
*    DATA: LT_HEADER TYPE STANDARD TABLE OF STRING,
*          LV_HEADER TYPE STRING.
*
*    CONCATENATE 'DocDate'   C_TAB 'PostDate'  C_TAB 'HeaderTxt' C_TAB
*              'Material'  C_TAB 'FromPlant' C_TAB 'FromSLOC'  C_TAB
*              'FromBatch' C_TAB 'ToPlant'   C_TAB 'ToSLOC'    C_TAB
*              'ToBatch'   C_TAB 'Qty'       C_TAB 'ItemTxt'
*              INTO LV_HEADER.
*
*    APPEND LV_HEADER TO LT_HEADER.
*
*    CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG(
*      EXPORTING
*        DEFAULT_FILE_NAME = 'MIGO_301_Template.xls'
*      CHANGING
*        FILENAME          = LV_FILENAME
*        PATH              = LV_PATH
*        FULLPATH          = LV_FULLPATH ).
*
*    CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
*      EXPORTING
*        FILENAME              = LV_FULLPATH
*        WRITE_FIELD_SEPARATOR = 'X'
*      CHANGING
*        DATA_TAB              = LT_HEADER
*      EXCEPTIONS
*        OTHERS                = 1.
*  ENDIF.
*ENDFORM.

*&---------------------------------------------------------------------*
*& Report ZMM_MIGO_301_UPLOAD
*&---------------------------------------------------------------------*
"REPORT ZMM_MIGO_301_UPLOAD.

TYPE-POOLS : SLIS, ICON.

TABLES: SSCRFIELDS.

" Structure matching the Excel Template
TYPES: BEGIN OF TY_UPLOAD,
         BLDAT      TYPE BLDAT,      " Document Date
         BUDAT      TYPE BUDAT,      " Posting Date
         HEADER_TXT TYPE BAPI2017_GM_HEAD_01-HEADER_TXT,
         MATNR      TYPE MATNR,
         WERKS      TYPE WERKS_D,    " From Plant
         LGORT      TYPE LGORT_D,    " From SLoc
         CHARG      TYPE CHARG_D,    " From Batch
         UMWRK      TYPE UMWRK,      " To Plant
         UMLGO      TYPE UMLGO,      " To SLoc
         UMCHA      TYPE UMCHA,      " To Batch
         ERFMG      TYPE ERFMG,      " Quantity
         ITEM_TEXT  TYPE BAPI2017_GM_ITEM_CREATE-ITEM_TEXT,
       END OF TY_UPLOAD.

TYPES: BEGIN OF TY_LOG,
         MATNR    TYPE MATNR,
         WERKS    TYPE WERKS_D,
         MSG_TYPE TYPE BAPI_MTYPE,
         MESSAGE  TYPE BAPI_MSG,
         MBLNR    TYPE MBLNR,       " Created Doc Number
       END OF TY_LOG.

DATA: LT_FINAL TYPE TABLE OF TY_UPLOAD,
      WA_FINAL TYPE TY_UPLOAD.

DATA: LT_LOG TYPE TABLE OF TY_LOG,
      WA_LOG TYPE TY_LOG.

DATA: GT_RETURN TYPE TABLE OF BAPIRET2.

DATA: TRAW TYPE TRUXS_T_TEXT_DATA,
      FILE TYPE IBIPPARMS-PATH.

DATA: LT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      LS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA: LS_LAYOUT TYPE SLIS_LAYOUT_ALV.

"----------------------------------------------------------------------"
" Selection Screen
"----------------------------------------------------------------------"
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
  PARAMETERS: PATH TYPE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN FUNCTION KEY 1.

INITIALIZATION.
  CONCATENATE ICON_NEXT_OBJECT 'Template Download' INTO SSCRFIELDS-FUNCTXT_01.

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM = 'FC01'.
    PERFORM DOWNLOAD_TEMPLATE.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PATH.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = FILE.
  PATH = FILE.

"----------------------------------------------------------------------"
" Start of Selection
"----------------------------------------------------------------------"
START-OF-SELECTION.
  IF PATH IS INITIAL.
    MESSAGE 'Please select a file' TYPE 'E'.
  ENDIF.

  PERFORM UPLOAD_DATA.
  PERFORM PROCESS_BAPI_LOGIC.
  PERFORM DISPLAY_LOG.

*&---------------------------------------------------------------------*
*& Form UPLOAD_DATA (Using CJ20N Method)
*&---------------------------------------------------------------------*
FORM UPLOAD_DATA.
  FILE = PATH.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = TRAW
      I_FILENAME           = FILE
    TABLES
      I_TAB_CONVERTED_DATA = LT_FINAL
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.

  IF SY-SUBRC <> 0.
    MESSAGE 'Upload failed' TYPE 'E'.
  ENDIF.

  IF LT_FINAL IS INITIAL.
    MESSAGE 'No data found in the uploaded file.' TYPE 'I'.
    LEAVE PROGRAM.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_BAPI_LOGIC
*&---------------------------------------------------------------------*
FORM PROCESS_BAPI_LOGIC.
  DATA: LS_HEADER TYPE BAPI2017_GM_HEAD_01,
        LS_CODE   TYPE BAPI2017_GM_CODE,
        LV_MBLNR  TYPE BAPI2017_GM_HEAD_RET-MAT_DOC,
        LT_ITEM   TYPE TABLE OF BAPI2017_GM_ITEM_CREATE,
        LS_ITEM   TYPE BAPI2017_GM_ITEM_CREATE,
        LS_RET    TYPE BAPIRET2.

  " GM_CODE 04 for Transfer Postings
  LS_CODE-GM_CODE = '04'.

  LOOP AT LT_FINAL INTO WA_FINAL.
    REFRESH: LT_ITEM, GT_RETURN.
    CLEAR: LS_HEADER, LV_MBLNR, WA_LOG.

    " Header Data
    LS_HEADER-PSTNG_DATE = WA_FINAL-BUDAT.
    LS_HEADER-DOC_DATE   = WA_FINAL-BLDAT.
    LS_HEADER-HEADER_TXT = WA_FINAL-HEADER_TXT.

    " Item Data (Hardcoded 301)
    LS_ITEM-MATERIAL   = WA_FINAL-MATNR.
    LS_ITEM-PLANT      = WA_FINAL-WERKS.
    LS_ITEM-STGE_LOC   = WA_FINAL-LGORT.
    LS_ITEM-BATCH      = WA_FINAL-CHARG.
    LS_ITEM-MOVE_TYPE  = '301'.
    LS_ITEM-ENTRY_QNT  = WA_FINAL-ERFMG.
    LS_ITEM-ITEM_TEXT  = WA_FINAL-ITEM_TEXT.
    LS_ITEM-MOVE_MAT   = WA_FINAL-MATNR.
    LS_ITEM-MOVE_PLANT = WA_FINAL-UMWRK.
    LS_ITEM-MOVE_STLOC = WA_FINAL-UMLGO.
    LS_ITEM-MOVE_BATCH = WA_FINAL-UMCHA.
    APPEND LS_ITEM TO LT_ITEM.

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        GOODSMVT_HEADER  = LS_HEADER
        GOODSMVT_CODE    = LS_CODE
      IMPORTING
        MATERIALDOCUMENT = LV_MBLNR
      TABLES
        GOODSMVT_ITEM    = LT_ITEM
        RETURN           = GT_RETURN.

    " Log Results
    WA_LOG-MATNR = WA_FINAL-MATNR.
    WA_LOG-WERKS = WA_FINAL-WERKS.

    READ TABLE GT_RETURN INTO LS_RET WITH KEY TYPE = 'E'.
    IF SY-SUBRC = 0.
      WA_LOG-MSG_TYPE = 'E'.
      WA_LOG-MESSAGE  = LS_RET-MESSAGE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      WA_LOG-MSG_TYPE = 'S'.
      WA_LOG-MESSAGE  = 'Document Created Successfully'.
      WA_LOG-MBLNR    = LV_MBLNR.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING WAIT = 'X'.
    ENDIF.

    APPEND WA_LOG TO LT_LOG.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DOWNLOAD_TEMPLATE (Using SALV Export Method)
*&---------------------------------------------------------------------*
FORM DOWNLOAD_TEMPLATE.
  DATA: LV_FILENAME TYPE STRING,
        LV_PATH     TYPE STRING,
        LV_FULLPATH TYPE STRING,
        LV_FILE     TYPE IBIPPARMS-PATH.

  DATA: LT_EXCEL_STRUCTURE TYPE TABLE OF TY_UPLOAD,
        LR_EXCEL_STRUCTURE TYPE REF TO DATA,
        LV_CONTENT         TYPE XSTRING,
        LT_BINARY_TAB      TYPE TABLE OF SDOKCNTASC,
        LV_LENGTH          TYPE I.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      WINDOW_TITLE      = 'Enter File Name'
      DEFAULT_EXTENSION = 'XLSX'
      DEFAULT_FILE_NAME = 'MIGO_301_Template.xlsx'
    CHANGING
      FILENAME          = LV_FILENAME
      PATH              = LV_PATH
      FULLPATH          = LV_FULLPATH.

  IF LV_FULLPATH IS INITIAL. RETURN. ENDIF.

  LV_FILE = LV_FULLPATH.
  GET REFERENCE OF LT_EXCEL_STRUCTURE INTO LR_EXCEL_STRUCTURE.

  DATA(LO_TOOL_XLS) = CL_SALV_EXPORT_TOOL_ATS_XLS=>CREATE_FOR_EXCEL(
                        EXPORTING R_DATA = LR_EXCEL_STRUCTURE ).
  DATA(LO_CONFIG) = LO_TOOL_XLS->CONFIGURATION( ).

  " Defining Columns
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Doc Date'
                         FIELD_NAME = 'BLDAT'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Post Date'
                         FIELD_NAME = 'BUDAT'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Header Text'
                         FIELD_NAME = 'HEADER_TXT'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Material'
                         FIELD_NAME = 'MATNR'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'From Plant'
                         FIELD_NAME = 'WERKS'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'From SLoc'
                         FIELD_NAME = 'LGORT'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'From Batch'
                         FIELD_NAME = 'CHARG'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'To Plant'
                         FIELD_NAME = 'UMWRK'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'To SLoc'
                         FIELD_NAME = 'UMLGO'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'To Batch'
                         FIELD_NAME = 'UMCHA'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Qty'
                         FIELD_NAME = 'ERFMG'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).
  LO_CONFIG->ADD_COLUMN( HEADER_TEXT = 'Item Text'
                         FIELD_NAME = 'ITEM_TEXT'
                         DISPLAY_TYPE = IF_SALV_BS_MODEL_COLUMN=>UIE_TEXT_VIEW ).

  LO_TOOL_XLS->READ_RESULT( IMPORTING CONTENT = LV_CONTENT ).

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING  BUFFER = LV_CONTENT
    IMPORTING  OUTPUT_LENGTH = LV_LENGTH
    TABLES     BINARY_TAB = LT_BINARY_TAB.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
    EXPORTING
      BIN_FILESIZE = LV_LENGTH
      FILENAME     = CONV STRING( LV_FILE )
      FILETYPE     = 'BIN'
    CHANGING
      DATA_TAB     = LT_BINARY_TAB.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_LOG (Using Reuse ALV Method)
*&---------------------------------------------------------------------*
FORM DISPLAY_LOG.
  LS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LS_LAYOUT-ZEBRA             = 'X'.

  PERFORM BUILD_FIELDCAT USING 'MATNR'    'Material'.
  PERFORM BUILD_FIELDCAT USING 'WERKS'    'Plant'.
  PERFORM BUILD_FIELDCAT USING 'MSG_TYPE' 'Type'.
  PERFORM BUILD_FIELDCAT USING 'MESSAGE'  'Message Text'.
  PERFORM BUILD_FIELDCAT USING 'MBLNR'    'Material Doc'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = LT_FIELDCAT
    TABLES
      T_OUTTAB           = LT_LOG.
ENDFORM.

FORM BUILD_FIELDCAT USING P_FIELD P_TEXT.
  CLEAR LS_FIELDCAT.
  LS_FIELDCAT-FIELDNAME = P_FIELD.
  LS_FIELDCAT-SELTEXT_M = P_TEXT.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.
ENDFORM.
