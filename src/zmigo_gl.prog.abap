*&---------------------------------------------------------------------*
*& Report ZMIGO_GL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMIGO_GL.

INCLUDE ZMIGO_GL_TOP.



SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECTION-SCREEN SKIP 1.
  PARAMETERS: P_FILE  TYPE LOCALFILE. "OBLIGATORY.                "File to upload data.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
*SELECTION-SCREEN SKIP 1.
*  PARAMETERS P1 AS CHECKBOX.
*PARAMETERS: p1 no-display RADIOBUTTON GROUP g1 DEFAULT 'X',                "Foreground
*            p2 RADIOBUTTON GROUP g1 .                            "Background
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.


INITIALIZATION.

  W_BUTTON = 'Download Excel Template'.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*----------------------------------------------------------------------*

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    PERFORM DOWNLOAD .
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
**To provide F4 Help for the file path on the Selection Screen
  PERFORM GET_FILE CHANGING P_FILE.

START-OF-SELECTION.
* Upload the flat file
  PERFORM UPLOAD_FILE USING P_FILE.
*  changing it_records.
  IF GT_RECORD IS INITIAL.
    MESSAGE   'No Data has been Uploaded' TYPE 'E'.
  ENDIF.

  IF 1 = 2   .
    PERFORM RUN_BDC.
  ENDIF .

  PERFORM BAPI .

*&---------------------------------------------------------------------*
*&      Form  GET_FILE
*&---------------------------------------------------------------------*
FORM GET_FILE CHANGING PV_FILE TYPE RLGRAP-FILENAME.

*F4 for the File Path
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      FILE_NAME = PV_FILE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form Download
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .


*INCLUDE ZROUTING_UPD_EXCEL_FORMAT_NEW.
*INCLUDE ZROUTING_UPLOAD_EXCEL_FORMAT.


  PERFORM FILL_DATA.
  PERFORM DOWNLOAD_DATA.
  PERFORM MODIFY_CELLS.
  PERFORM CELL_BORDER.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_DATA .
***START OF COLUMN NUMBERS


  WA_DATA-FIELD1  = FIELD1.
  WA_DATA-FIELD2  = FIELD2.
  WA_DATA-FIELD3  = FIELD3.
  WA_DATA-FIELD4  = FIELD4.
  WA_DATA-FIELD5  = FIELD5.
  WA_DATA-FIELD6  = FIELD6.
  WA_DATA-FIELD7  = FIELD7.
  WA_DATA-FIELD8  = FIELD8.
  WA_DATA-FIELD9  = FIELD9.

  APPEND WA_DATA TO IT_DATA.

  CREATE OBJECT APPLICATION 'EXCEL.APPLICATION'.
  SET PROPERTY OF APPLICATION 'VISIBLE' = 1.
  CALL METHOD OF
    APPLICATION
      'WORKBOOKS' = WORKBOOK.

* CREATE NEW WORKSHEET
  SET PROPERTY OF APPLICATION 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
    WORKBOOK
    'ADD'.

* CREATE FIRST EXCEL SHEET
  CALL METHOD OF
  APPLICATION
  'WORKSHEETS' = SHEET
  EXPORTING
    #1           = 1.
  CALL METHOD OF
    SHEET
    'ACTIVATE'.
  SET PROPERTY OF SHEET 'NAME' = 'ROUTING_UPLOAD'.


ENDFORM.                    " FILL_DATA


FORM CELL_BORDER .

*************************************************
*** MODIFY PROPERTIES OF CELL RANGE             *
*************************************************

  FREE RANGE.
  CALL METHOD OF APPLICATION 'CELLS' = CELL1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF APPLICATION 'CELLS' = CELL2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 51.   "ACROSS

  CALL METHOD OF
  APPLICATION
  'RANGE'     = RANGE
  EXPORTING
    #1          = CELL1
    #2          = CELL2.


* SET BORDER PROPERTIES OF RANGE
  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1        = '1'.  "LEFT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
  SET PROPERTY OF BORDER 'WEIGHT' = 1.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1        = '2'.  "RIGHT
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1        = '3'.   "TOP
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

  CALL METHOD OF
  RANGE
  'BORDERS' = BORDER
  EXPORTING
    #1        = '4'.   "BOTTOM
  SET PROPERTY OF BORDER 'LINESTYLE' = '1'.
  SET PROPERTY OF BORDER 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT BORDER.

* OVERWITES ALL CELL VALUES IN RANGE TO EQUAL 'TEST'
* SET PROPERTY OF RANGE    'VALUE' = 'TEST'.


***********************************************
* SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *
***********************************************
  CALL METHOD OF
    APPLICATION
      'COLUMNS' = COLUMN.
  CALL METHOD OF
    COLUMN
    'AUTOFIT'.

  FREE OBJECT COLUMN.

***********************************************
* SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME*
*************************************#*********
  CALL METHOD OF
    SHEET
    'SAVEAS'
    EXPORTING
      #1 = 'D:\SAP_DATA\ROUTING_UPLOAD.XLS'     "FILENAME
      #2 = 1.                          "FILEFORMAT

  FREE OBJECT SHEET.
  FREE OBJECT WORKBOOK.
  FREE OBJECT APPLICATION.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_CELLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MODIFY_CELLS .

***********************************************
****FORMATTING OF COLUMN NUMBER ROW ***********
***********************************************
  CALL METHOD OF
  APPLICATION
  'CELLS'     = CELL1
  EXPORTING
    #1          = 1     "DOWN
    #2          = 1.    "ACROSS
*END OF RANGE CELL
  CALL METHOD OF
  APPLICATION
  'CELLS'     = CELL2
  EXPORTING
    #1          = 1     "DOWN
    #2          = 51.   "ACROSS

  CALL METHOD OF
  APPLICATION
  'RANGE'     = RANGE
  EXPORTING
    #1          = CELL1
    #2          = CELL2.
***********************************************
* MODIFY PROPERTIES OF CELL RANGE             *
***********************************************
* SET FONT DETAILS OF RANGE

  GET PROPERTY OF RANGE 'FONT' = FONT.
  SET PROPERTY OF FONT 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
    RANGE
      'INTERIOR' = SHADING.
  SET PROPERTY OF SHADING 'COLORINDEX' = 0. "COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF SHADING 'PATTERN' = 1. "PATTERN - SOLID, STRIPED ETC
  FREE OBJECT SHADING.

***********************************************
*****END OF FORMATTING OF COLUMN NUMBER ROW****
***********************************************



ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD_DATA .

***********************************************
* DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET   *
***********************************************

  LD_ROWINDX = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT IT_DATA INTO WA_DATA.
    LD_ROWINDX = SY-TABIX . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR LD_COLINDX.
    DO.
      ASSIGN COMPONENT SY-INDEX OF STRUCTURE WA_DATA TO <FS>.
      IF SY-SUBRC NE 0.
        EXIT.
      ENDIF.
      LD_COLINDX = SY-INDEX.
      CALL METHOD OF
      SHEET
      'CELLS' = CELLS
      EXPORTING
        #1      = LD_ROWINDX
        #2      = LD_COLINDX.
      SET PROPERTY OF CELLS 'VALUE' = <FS>.
    ENDDO.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPLOAD_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_FILE
*&---------------------------------------------------------------------*
FORM UPLOAD_FILE  USING PV_FILE TYPE RLGRAP-FILENAME.
  DATA: LV_FILENAME TYPE RLGRAP-FILENAME,
        LV_RAW      TYPE TRUXS_T_TEXT_DATA.

  LV_FILENAME = PV_FILE.

*Upload Excel File

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      I_TAB_RAW_DATA       = LV_RAW
      I_FILENAME           = LV_FILENAME
      I_LINE_HEADER        = 'X'
    TABLES
      I_TAB_CONVERTED_DATA = GT_RECORD
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RUN_BDC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RUN_BDC .

  DATA: IT_BDCDATA TYPE TABLE OF BDCDATA,
        WA_BDCDATA LIKE LINE OF IT_BDCDATA.

  DATA LS_RECORD TYPE TY_RECORD.
  DATA:  LV_NUM TYPE NUM2.

*READ TABLE  GT_RECORD INTO DATA(wa_RECORD) index 1 .



  PERFORM BDC_DYNPRO      USING 'SAPLMIGO' '0001'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=MIGO_OK_ACTION'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'GODYNPRO-ACTION'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-ACTION'
                                'A07'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-REFDOC'
                                'R10'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-MAT_DOC'
                                LS_RECORD-MATERIAL.
  PERFORM BDC_FIELD       USING 'GODYNPRO-DOC_YEAR'
                                '2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BUDAT'
                                LS_RECORD-POST_DATE.
  PERFORM BDC_DYNPRO      USING 'SAPLMIGO' '0001'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=OK_GO'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'GODEFAULT_TV-BWART'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-ACTION'
                                'A07'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-REFDOC'
                                'R10'.
  PERFORM BDC_FIELD       USING 'GODEFAULT_TV-BWART'
                                 LS_RECORD-MOVE_TYPE ." '201'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BLDAT'
                                LS_RECORD-DOC_DATE. "'24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BUDAT'
                                 LS_RECORD-POST_DATE. . "'24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-WEVER'
                                '1'.
  PERFORM BDC_DYNPRO      USING 'SAPLMIGO' '0001'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=OK_GO'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-ACTION'
                                'A07'.
  PERFORM BDC_FIELD       USING 'GODYNPRO-REFDOC'
                                'R10'.
  PERFORM BDC_FIELD       USING 'GODEFAULT_TV-BWART'
                                 LS_RECORD-MOVE_TYPE ."'201'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BLDAT'
                                 LS_RECORD-DOC_DATE. " '24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BUDAT'
                                 LS_RECORD-POST_DATE. "'24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-WEVER'
                                '1'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'GOITEM-MAKTX(01)'.
  PERFORM BDC_FIELD       USING 'GOITEM-MAKTX(01)'
                                '4403P10057000003'.
  PERFORM BDC_DYNPRO      USING 'SAPLMIGO' '0001'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=OK_GO'.
  PERFORM BDC_FIELD       USING 'GODEFAULT_TV-BWART'
                                LS_RECORD-MOVE_TYPE ."'201'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BLDAT'
                                LS_RECORD-DOC_DATE. "'24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-BUDAT'
                                 LS_RECORD-POST_DATE. "'24.07.2025'.
  PERFORM BDC_FIELD       USING 'GOHEAD-WEVER'
                                '1'.

******
  LOOP AT GT_RECORD INTO LS_RECORD.
    LV_NUM = LV_NUM + 1 .

    CONCATENATE 'GOITEM-KONTO('  LV_NUM ')' INTO  DATA(LV_VAL).

    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                   LV_VAL . ""  'GOITEM-KONTO(01)'.
    CLEAR : LV_VAL .

    CONCATENATE 'GOITEM-ERFMG('  LV_NUM ')' INTO  LV_VAL.

    PERFORM BDC_FIELD       USING LV_VAL
                                   '1'.

    CLEAR : LV_VAL.


    CONCATENATE 'GOITEM-LGOBE('  LV_NUM ')' INTO  LV_VAL .
    PERFORM BDC_FIELD       USING  LV_VAL   "'GOITEM-LGOBE(01)'
                                   LS_RECORD-STR_LOC. "'KRM0'.

    CLEAR : LV_VAL .

    CONCATENATE 'GOITEM-KOSTL('  LV_NUM ')' INTO  LV_VAL .
    PERFORM BDC_FIELD       USING LV_VAL    "'GOITEM-KOSTL(01)'
                                   LS_RECORD-COST_CENTER.   "'1003050'.
    CLEAR : LV_VAL .

    CONCATENATE 'GOITEM-KONTO('  LV_NUM ')' INTO  LV_VAL .
    PERFORM BDC_FIELD       USING LV_VAL " 'GOITEM-KONTO(01)'
                                  LS_RECORD-GL_ACC .        "'620090'.
    CLEAR : LV_VAL .


    PERFORM BDC_DYNPRO      USING 'SAPLMIGO' '0001'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=OK_POST1'.


    PERFORM BDC_FIELD       USING 'GODEFAULT_TV-BWART'
                                  '201'.
    PERFORM BDC_FIELD       USING 'GOHEAD-BLDAT'
                                  LS_RECORD-DOC_DATE. "'24.07.2025'.
    PERFORM BDC_FIELD       USING 'GOHEAD-BUDAT'
                                   LS_RECORD-POST_DATE. "'24.07.2025'.
    PERFORM BDC_FIELD       USING 'GOHEAD-WEVER'
                                  '1'.
*    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                  'GOITEM-KONTO(01)'.

  ENDLOOP .

*    PERFORM BDC_TRANSACTION USING 'MIGO'.

  LV_CTU_PARAMS-DEFSIZE = 'X'.
  LV_CTU_PARAMS-DISMODE = 'A'.
  LV_CTU_PARAMS-UPDMODE = 'S'.

  CALL TRANSACTION 'MIGO' USING IT_BDCDATA
                    OPTIONS FROM LV_CTU_PARAMS
                    MESSAGES INTO IT_MSG.



ENDFORM.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> SPACE.
    CLEAR BDCDATA.
    BDCDATA-FNAM = FNAM.
    BDCDATA-FVAL = FVAL.
    APPEND BDCDATA.
  ENDIF.
ENDFORM.
FORM BDC_TRANSACTION USING TCODE.

  DATA: L_MSTRING(480).
  DATA: MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
  DATA: L_SUBRC LIKE SY-SUBRC,
        CTUMODE LIKE CTU_PARAMS-DISMODE VALUE 'N',
        CUPDATE LIKE CTU_PARAMS-UPDMODE VALUE 'L'.

*  IF P1 = 'X'.
*    CTUMODE = 'A'.
*  ELSE.
*    CTUMODE = 'N'.
*  ENDIF.

  REFRESH MESSTAB.
  CALL TRANSACTION TCODE USING GT_BDCDATA
                   MODE   CTUMODE
                   UPDATE CUPDATE
                   MESSAGES INTO MESSTAB.
  L_SUBRC = SY-SUBRC.
*    IF SMALLLOG <> 'X'.
  WRITE: / 'CALL_TRANSACTION', TCODE,
           'returncode:'(i05),
           L_SUBRC,  'RECORD:', SY-INDEX.
  LOOP AT MESSTAB.
    MESSAGE ID     MESSTAB-MSGID
            TYPE   MESSTAB-MSGTYP
            NUMBER MESSTAB-MSGNR
            INTO L_MSTRING
            WITH MESSTAB-MSGV1
                 MESSTAB-MSGV2
                 MESSTAB-MSGV3
                 MESSTAB-MSGV4.
    WRITE: / MESSTAB-MSGTYP, L_MSTRING(250).
  ENDLOOP.
  WRITE: / '!----------------*--------------->'.
  SKIP.
*    ENDIF.
  REFRESH GT_BDCDATA.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form BAPI
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BAPI .
  DATA: GWA_HEADER TYPE BAPI2017_GM_HEAD_01,
        GT_ITEM    TYPE TABLE OF BAPI2017_GM_ITEM_CREATE,
        GWA_ITEM   TYPE BAPI2017_GM_ITEM_CREATE,
        LV_GMCODE  TYPE BAPI2017_GM_CODE,
        LV_DOC     LIKE BAPI2017_GM_HEAD_RET,
        GT_RETURN  TYPE TABLE OF BAPIRET2,
        GWA_RETURN TYPE BAPIRET2.




  DATA: LO_ALV  TYPE REF TO CL_SALV_TABLE.  " Reference to SALV table object

  LV_GMCODE = '03'.
  LOOP AT GT_RECORD INTO DATA(GWA_UPLOAD).


    CONCATENATE GWA_UPLOAD-POST_DATE+6(4)   GWA_UPLOAD-POST_DATE+3(2)  GWA_UPLOAD-POST_DATE+0(2) INTO GWA_HEADER-PSTNG_DATE .
    CONCATENATE GWA_UPLOAD-DOC_DATE+6(4)    GWA_UPLOAD-DOC_DATE+3(2)   GWA_UPLOAD-DOC_DATE+0(2) INTO GWA_HEADER-DOC_DATE .
    GWA_HEADER-REF_DOC_NO   =           'R10'.
    GWA_ITEM-MOVE_TYPE      =  GWA_UPLOAD-MOVE_TYPE.



    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = GWA_UPLOAD-GL_ACC
      IMPORTING
        OUTPUT = GWA_ITEM-GL_ACCOUNT.


*    GWA_ITEM-GL_ACCOUNT     =  GWA_UPLOAD-GL_ACC.
*    GWA_ITEM-SPEC_STOCK     = GWA_UPLOAD-SPEC_STOCK.
    GWA_ITEM-MATERIAL       = GWA_UPLOAD-MATERIAL." |{ gwa_upload-material  ALPHA = IN }|.
    GWA_ITEM-PLANT          = GWA_UPLOAD-PLANT.
*    GWA_ITEM-MOVE_PLANT     = GWA_UPLOAD-MOVE_PLANT.
*    GWA_ITEM-STGE_LOC       = GWA_UPLOAD-.
*    GWA_ITEM-MOVE_STLOC     = GWA_UPLOAD-MOVE_STLOC.
    GWA_ITEM-ENTRY_QNT       = GWA_UPLOAD-QTY.
    GWA_ITEM-STGE_LOC        = GWA_UPLOAD-STR_LOC.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = GWA_UPLOAD-COST_CENTER
      IMPORTING
        OUTPUT = GWA_ITEM-COSTCENTER.


*    GWA_ITEM-VAL_SALES_ORD  = GWA_UPLOAD-VAL_SALES_ORD .
*    gwa_item-ORDERID  = gwa_upload-VAL_SALES_ORD .
*    GWA_ITEM-VAL_S_ORD_ITEM = GWA_UPLOAD-VAL_S_ORD_ITEM.
*    gwa_item-ORDER_ITNO = gwa_upload-VAL_S_ORD_ITEM.
*    GWA_ITEM-SALES_ORD      = GWA_UPLOAD-SALES_ORD .
*    GWA_ITEM-S_ORD_ITEM     = GWA_UPLOAD-S_ORD_ITEM.
*    GWA_ITEM-MOVE_MAT       = GWA_UPLOAD-MOVE_MAT.
*    gwa_item-batch = gwa_upload-batch     .
*    gwa_item-move_batch = gwa_upload-move_batch.

    APPEND GWA_ITEM TO GT_ITEM.
    CLEAR: GWA_ITEM.
  ENDLOOP .

  BREAK CTPLMM .
  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      GOODSMVT_HEADER  = GWA_HEADER
      GOODSMVT_CODE    = LV_GMCODE
    IMPORTING
      GOODSMVT_HEADRET = LV_DOC
    TABLES
      GOODSMVT_ITEM    = GT_ITEM
      RETURN           = GT_RETURN.

* Create the ALV object

  IF LV_DOC IS  INITIAL .

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    TRY.
        " Create an instance of the SALV table
        CL_SALV_TABLE=>FACTORY(
          IMPORTING
            R_SALV_TABLE = LO_ALV
          CHANGING
            T_TABLE      = GT_RETURN ).

*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'MESSAGE_V1' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'MESSAGE_V2' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'MESSAGE_V3' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'MESSAGE_V4' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'MESSAGE_V4' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'PARAMETER' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'ROW' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'FIELD' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).
*
*        LO_COLUMNS = LO_ALV->GET_COLUMNS( )->GET_COLUMN( 'SYSTEM' ). " Column name
*        LO_COLUMNS->SET_VISIBLE( ABAP_FALSE ).

        " Display the ALV report
        LO_ALV->DISPLAY( ).

      CATCH CX_SALV_MSG INTO DATA(LX_MSG).
        " Handle any errors in the ALV processing
        WRITE: / 'Error:', LX_MSG->GET_TEXT( ).
    ENDTRY.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        WAIT = ABAP_TRUE.
    WRITE: / 'Goods movement posted successfully. Material Document:', LV_DOC-MAT_DOC.
  ENDIF .

  CLEAR: GT_ITEM, GWA_ITEM, GWA_HEADER, GT_RETURN, GWA_RETURN.
ENDFORM.
