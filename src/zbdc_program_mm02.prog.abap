*&---------------------------------------------------------------------*
*& Report ZBDC_PROGRAM_MM02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBDC_PROGRAM_MM02

NO STANDARD PAGE HEADING LINE-SIZE 255.
TABLES : SSCRFIELDS.
TYPE-POOLS : TRUXS.
DATA: H_EXCEL TYPE OLE2_OBJECT,        " EXCEL OBJECT
      H_MAPL  TYPE OLE2_OBJECT,        " LIST OF WORKBOOKS
      H_MAP   TYPE OLE2_OBJECT,        " WORKBOOK
      H_ZL    TYPE OLE2_OBJECT,        " CELL
      H_F     TYPE OLE2_OBJECT,        " FONT
      H       TYPE I,
      INPUT   TYPE SY-UCOMM.

TYPES : BEGIN OF RECORD,
          MATNR         TYPE MARA-MATNR,
          VERTICAL(040),
        END OF RECORD.

TYPES : BEGIN OF TY_FINAL,
          MATNR         TYPE MARA-MATNR,
          VERTICAL(040),
          ERROR_MSG(60) TYPE C,
        END OF TY_FINAL.

TYPES : BEGIN OF TY_MSG,
          MATERIAL     TYPE MARA-MATNR,
          vertical type mara-VERTICAL,
          MSG_ID(2)    TYPE C,
          MESSAGE(100) TYPE C,
        END OF TY_MSG.

DATA:IT_RECORD TYPE TABLE OF RECORD,
     WA_RECORD TYPE RECORD.

DATA: IT_BDCDATA TYPE TABLE OF BDCDATA,
      WA_BDCDATA LIKE LINE OF IT_BDCDATA.

DATA: IT_RAW TYPE TRUXS_T_TEXT_DATA.

DATA : IT_MSG TYPE TABLE OF BDCMSGCOLL,
       WA_MSG TYPE BDCMSGCOLL.

DATA: GT_MSG TYPE TABLE OF TY_MSG,
      GS_MSG TYPE TY_MSG.

DATA: IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL.

DATA : LV_MSG TYPE STRING .

DATA : LV_MODE TYPE CHAR1 VALUE 'N'.

DATA : LV_UPDATE TYPE CHAR1 VALUE 'S'.

DATA: IS_LAYOUT TYPE SLIS_LAYOUT_ALV .

DATA: IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : VRT TYPE MARA-VERTICAL,
       DUP TYPE MARA-VERTICAL.

* DATA: LV_REPID TYPE SY-REPID.

SELECTION-SCREEN : BEGIN OF BLOCK B WITH FRAME TITLE TEXT-001 .
  PARAMETERS : P_FILE TYPE RLGRAP-FILENAME ."OBLIGATORY .
* PARAMETERS : p_mode TYPE ctu_params-dismode .
SELECTION-SCREEN : END OF BLOCK B.
*added by ps
SELECTION-SCREEN BEGIN OF LINE.
**SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
*
   SELECTION-SCREEN PUSHBUTTON 10(20) TEXT-002 USER-COMMAND CL1.
*
SELECTION-SCREEN END OF LINE.
INITIALIZATION.

*w_button = 'Download Excel Template'.

at SELECTION-SCREEN .
   CASE SY-UCOMM.
    WHEN 'CL1'.
      PERFORM DOWNLOAD_TEMPLATE .
  ENDCASE.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

START-OF-SELECTION.

  PERFORM FILE_UPLOAD.
  PERFORM MAPPING.
  PERFORM DISPLAY_ALV.

FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM = PROGRAM.
  WA_BDCDATA-DYNPRO = DYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND WA_BDCDATA TO IT_BDCDATA .
ENDFORM.

*----------------------------------------------------------------------*
* Insert field *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
* IF FVAL <> NODATA.
  CLEAR WA_BDCDATA.
  WA_BDCDATA-FNAM = FNAM.
  WA_BDCDATA-FVAL = FVAL.
  APPEND WA_BDCDATA TO IT_BDCDATA.
* ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form FILE_UPLOAD
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM FILE_UPLOAD .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      I_LINE_HEADER        = 'X'
      I_TAB_RAW_DATA       = IT_RAW
      I_FILENAME           = P_FILE
*     I_STEP               = 1
    TABLES
      I_TAB_CONVERTED_DATA = IT_RECORD
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAPPING
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM MAPPING .

  LOOP AT IT_RECORD INTO WA_RECORD.
    VRT = WA_RECORD-VERTICAL.





    REFRESH: IT_BDCDATA[],IT_MSG.

    PERFORM BDC_DYNPRO USING 'SAPLMGMM' '0060'.
    PERFORM BDC_FIELD USING 'BDC_CURSOR'
    'RMMG1-MATNR'.
    PERFORM BDC_FIELD USING 'BDC_OKCODE'
    '=ENTR'.
    PERFORM BDC_FIELD USING 'RMMG1-MATNR'
    WA_RECORD-MATNR.
                                                            "'5190005'.
    PERFORM BDC_DYNPRO USING 'SAPLMGMM' '0070'.
    PERFORM BDC_FIELD USING 'BDC_CURSOR'
    'MSICHTAUSW-DYTXT(01)'.
    PERFORM BDC_FIELD USING 'BDC_OKCODE'
    '=ENTR'.
    PERFORM BDC_FIELD USING 'MSICHTAUSW-KZSEL(01)'
          'X'.

    PERFORM BDC_DYNPRO USING 'SAPLMGMM' '4004'.
    PERFORM BDC_FIELD USING 'BDC_OKCODE'
    '/00'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
    'SAPLMGMM                                2004TABFRA1'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
    'SAPLMGD1                                1002SUB1'.
    PERFORM BDC_FIELD USING 'MAKT-MAKTX'
          '10,LEVER,-,DI 65-45-12,SQ17,F10H,BLUE PW'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLZMGD1                               0001SUB2'.
    PERFORM BDC_FIELD USING 'BDC_CURSOR'
          'MARA-VERTICAL'.
    PERFORM BDC_FIELD USING 'MARA-ZSERIES' '10'.
    PERFORM BDC_FIELD USING 'MARA-BRAND' 'DTO'.
    PERFORM BDC_FIELD USING 'MARA-TYPE' 'LVR'.
    PERFORM BDC_FIELD USING 'MARA-ZSIZE'  '0NA'.
    PERFORM BDC_FIELD USING 'MARA-MOC' '02'.
    PERFORM BDC_FIELD USING 'MARA-ZZMSS'  '015'.
    PERFORM BDC_FIELD USING 'MARA-VERTICAL'
           WA_RECORD-VERTICAL.
    PERFORM BDC_FIELD USING 'MARA-ZITEM_CLASS' 'B'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                2001SUB3'.
    PERFORM BDC_FIELD USING 'MARA-MEINS' 'NOS'.
    PERFORM BDC_FIELD USING 'MARA-MATKL' '0003'.
    PERFORM BDC_FIELD USING 'MARA-BISMT' '15080HANP00D'.
    PERFORM BDC_FIELD USING 'MARA-MTPOS_MARA' 'NORM'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
           'SAPLMGD1                                2561SUB4'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
           'SAPLMGD1                                2007SUB5'.
    PERFORM BDC_FIELD USING 'MARA-GEWEI' 'KG'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                2005SUB6'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                2011SUB7'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                2033SUB8'.
    PERFORM BDC_FIELD USING 'DESC_LANGU_GDTXT' 'E'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                0001SUB9'.
    PERFORM BDC_FIELD USING 'BDC_SUBSCR'
          'SAPLMGD1                                0001SUB10'.

    PERFORM BDC_DYNPRO USING 'SAPLSPO1' '0300'.
    PERFORM BDC_FIELD USING 'BDC_OKCODE' '=YES'.





    IF VRT EQ WA_RECORD-VERTICAL.
      IF VRT NE DUP.
        dup =  wa_record-vertical.



        CALL TRANSACTION 'MM02' USING IT_BDCDATA
        MODE LV_MODE
        UPDATE LV_UPDATE
        MESSAGES INTO IT_MSG.


      ENDIF.
    ENDIF.


    LOOP AT IT_MSG INTO WA_MSG WHERE MSGTYP = 'S' OR MSGTYP = 'E'.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          ID        = WA_MSG-MSGID
          LANG      = 'EN'
          NO        = WA_MSG-MSGNR
          V1        = WA_MSG-MSGV1
          V2        = WA_MSG-MSGV2
          V3        = WA_MSG-MSGV3
          V4        = WA_MSG-MSGV4
        IMPORTING
          MSG       = LV_MSG
        EXCEPTIONS
          NOT_FOUND = 1
          OTHERS    = 2.

      GS_MSG-MATERIAL = WA_RECORD-MATNR.
      gs_msg-VERTICAL = wa_record-VERTICAL.
      GS_MSG-MSG_ID = WA_MSG-MSGID.
      IF WA_MSG-MSGTYP = 'S'.
        GS_MSG-MESSAGE = 'Success'.
      ENDIF.

      APPEND : GS_MSG TO GT_MSG.
    ENDLOOP.
    IF LV_MSG IS INITIAL.

      GS_MSG-MATERIAL = WA_RECORD-MATNR.
      gs_msg-VERTICAL = wa_record-VERTICAL.
      GS_MSG-MESSAGE = 'Limit exceeded for vertical'.
       if vrt eq dup.
        GS_MSG-MESSAGE = 'Duplicated'.
        endif.
      APPEND : GS_MSG TO GT_MSG.
    ENDIF.
    CLEAR : LV_MSG, GS_MSG, WA_RECORD, VRT.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM DISPLAY_ALV .

  IS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  IS_LAYOUT-ZEBRA = 'X'.

  WA_FIELDCAT-COL_POS = 1.
  WA_FIELDCAT-FIELDNAME = 'Material'.
  WA_FIELDCAT-SELTEXT_M = 'material'.
  WA_FIELDCAT-TABNAME = 'GT_MSG'.
  APPEND : WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR: WA_FIELDCAT.

   WA_FIELDCAT-COL_POS = 2.
  WA_FIELDCAT-FIELDNAME = 'Vertical'.
  WA_FIELDCAT-SELTEXT_M = 'Vertical'.
  WA_FIELDCAT-TABNAME = 'GT_MSG'.
  APPEND : WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR: WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = 3.
  WA_FIELDCAT-FIELDNAME = 'MSG_ID'.
  WA_FIELDCAT-SELTEXT_M = 'Message ID'.
  WA_FIELDCAT-TABNAME = 'GT_MSG'.
  APPEND :WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR: WA_FIELDCAT.

  WA_FIELDCAT-COL_POS = 4.
  WA_FIELDCAT-FIELDNAME = 'MESSAGE'.
  WA_FIELDCAT-SELTEXT_M = 'Mesaage 1'.
  WA_FIELDCAT-TABNAME = 'gt_msg'.
  APPEND :WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR: WA_FIELDCAT.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = IS_LAYOUT
      IT_FIELDCAT        = IT_FIELDCAT
    TABLES
      T_OUTTAB           = GT_MSG
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form download_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD_TEMPLATE .
*  BREAK CTPLABAP.
  CASE  SSCRFIELDS-UCOMM.
    WHEN 'CL1'.
      INPUT = 'CL1'.
      CLEAR SY-UCOMM.
      PERFORM SHOW_EXCEL.
  ENDCASE.
ENDFORM.

FORM SHOW_EXCEL.

  CREATE OBJECT H_EXCEL 'EXCEL.APPLICATION'.

  SET PROPERTY OF H_EXCEL 'Visible' = 1.

  CALL METHOD OF H_EXCEL 'Workbooks' = H_MAPL.

  CALL METHOD OF H_MAPL 'Add' = H_MAP.

  IF INPUT = 'CL1'.

    PERFORM FILL_CELL USING 1 1   1 TEXT-003.
    PERFORM FILL_CELL USING 1 2   1 TEXT-004.
*    PERFORM FILL_CELL USING 1 3   1 TEXT-005.
*    PERFORM fill_cell USING 1 4   1 TEXT-006.
*    PERFORM fill_cell USING 1 5   1 TEXT-007.
*    PERFORM fill_cell USING 1 6   1 TEXT-008.
*    PERFORM fill_cell USING 1 7   1 TEXT-009.
*    PERFORM fill_cell USING 1 8   1 TEXT-010.
*    PERFORM fill_cell USING 1 7   1 TEXT-011.
*    PERFORM fill_cell USING 1 8   1 TEXT-012.
*    PERFORM fill_cell USING 1 9   1 TEXT-013.
*    PERFORM fill_cell USING 1 10  1 TEXT-014.
*    PERFORM fill_cell USING 1 11  1 TEXT-015.
*    PERFORM fill_cell USING 1 12  1 TEXT-016.
*    PERFORM fill_cell USING 1 13  1 TEXT-017.
*    PERFORM fill_cell USING 1 14  1 TEXT-018.
*    PERFORM fill_cell USING 1 15  1 TEXT-019.
*    PERFORM fill_cell USING 1 16  1 TEXT-020.
*    PERFORM fill_cell USING 1 17  1 TEXT-021.
*    PERFORM fill_cell USING 1 18  1 TEXT-022.
*    PERFORM fill_cell USING 1 19  1 TEXT-023.
*    PERFORM fill_cell USING 1 20  1 TEXT-024.
*    PERFORM fill_cell USING 1 21  1 TEXT-025.
*    PERFORM fill_cell USING 1 22  1 TEXT-026.
*    PERFORM fill_cell USING 1 23  1 TEXT-027.
*    PERFORM fill_cell USING 1 24  1 TEXT-028.
*    PERFORM fill_cell USING 1 25  1 TEXT-029.
*    PERFORM fill_cell USING 1 26  1 TEXT-030.
*    PERFORM fill_cell USING 1 27  1 TEXT-031.
*    PERFORM fill_cell USING 1 28  1 TEXT-032.
*    PERFORM fill_cell USING 1 29  1 TEXT-033.
*    PERFORM fill_cell USING 1 30  1 TEXT-034.
*    PERFORM fill_cell USING 1 31  1 TEXT-035.
*    PERFORM fill_cell USING 1 32  1 TEXT-036.
*    PERFORM fill_cell USING 1 33  1 TEXT-037.
*    PERFORM fill_cell USING 1 34  1 TEXT-038.
*    PERFORM fill_cell USING 1 35  1 TEXT-039.
*    PERFORM fill_cell USING 1 36  1 TEXT-045.
*    PERFORM fill_cell USING 1 37  1 TEXT-046.
*    PERFORM fill_cell USING 1 38  1 TEXT-047.
*    PERFORM fill_cell USING 1 39  1 TEXT-048.
*    PERFORM fill_cell USING 1 40  1 TEXT-049.
*    PERFORM fill_cell USING 1 41  1 TEXT-050.
**    PERFORM fill_cell USING 1 42  1 TEXT-018.
**    PERFORM fill_cell USING 1 43  1 TEXT-018.
**    PERFORM fill_cell USING 1 44  1 TEXT-018.
**    PERFORM fill_cell USING 1 45  1 TEXT-018.
**    PERFORM fill_cell USING 1 46  1 TEXT-018.
**    PERFORM fill_cell USING 1 47  1 TEXT-018.
**    PERFORM fill_cell USING 1 48  1 TEXT-018.
**    PERFORM fill_cell USING 1 49  1 TEXT-018.
**    PERFORM fill_cell USING 1 50  1 TEXT-018.
*
*


  ENDIF.
  CLEAR INPUT.


  CALL METHOD OF H_EXCEL 'Worksheets' = H_MAPL.

  FREE OBJECT H_EXCEL.

ENDFORM.

FORM FILL_CELL USING I J BOLD VAL.

  CALL METHOD OF H_EXCEL 'CELLS' = H_ZL
  EXPORTING
    #1 = I
    #2 = J.
  SET PROPERTY OF H_ZL 'Value' = VAL.
  GET PROPERTY OF H_ZL 'Font'  = H_F.
  SET PROPERTY OF H_F  'Bold'  = BOLD.


ENDFORM.
