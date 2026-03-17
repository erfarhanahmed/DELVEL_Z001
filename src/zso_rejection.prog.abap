*&---------------------------------------------------------------------*
*& Report ZSO_REJECTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&Report: ZFG_RACK
*&Transaction
*&Functional Cosultant: Tejaswini Kapadnis
*&Technical Consultant: Jyoti MAhajan
*&TR: 1.
*&Date: 1. 26.03.2025
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSO_REJECTION.
TABLES :VBAP, VBAK .


TYPES : BEGIN OF TY_FINAL,
          VBELN  TYPE VBAP-VBELN,
          POSNR  TYPE VBAP-POSNR,
          MATNR  TYPE VBAP-MATNR,
          MATTXT TYPE TEXT100,
          KUNNR  TYPE KNA1-KUNNR,
          NAME1  TYPE KNA1-NAME1,
          ERDAT  TYPE VBAK-ERDAT,
          ABGRU  TYPE VBAP-ABGRU,
          BEZEI  TYPE TVAGT-BEZEI,
        END OF TY_FINAL.

DATA : IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.

TYPES : BEGIN OF TY_DOWN,
          VBELN    TYPE STRING,
          POSNR    TYPE STRING,
          MATNR    TYPE STRING,
          MATTXT   TYPE STRING,
          KUNNR    TYPE STRING,
          NAME1    TYPE STRING,
          ERDAT    TYPE STRING,
          ABGRU    TYPE STRING,
          BEZEI    TYPE STRING,
          REF_DATE TYPE STRING,
          REF_TIME TYPE STRING,
        END OF TY_DOWN.

DATA : IT_DOWN TYPE TABLE OF TY_DOWN,
       WA_DOWN TYPE TY_DOWN.

DATA : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
       GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : FS_LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA :  LV_LINES          TYPE STANDARD TABLE OF TLINE.
DATA : LS_MATTXT TYPE TLINE,
       LV_NAME   TYPE THEAD-TDNAME.

***********************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS: C_PLANT TYPE CHAR4 VALUE 'PL01',
           C_PATH  TYPE CHAR50 VALUE '/Delval/India'. "'E:\delval\temp'.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
      PARAMETERS : P_WERKS TYPE VBAP-WERKS OBLIGATORY DEFAULT C_PLANT MODIF ID BU.
      SELECT-OPTIONS   :  S_VBELN FOR VBAP-VBELN,
                          S_POSNR FOR VBAP-POSNR,
                          S_KUNNR FOR VBAK-KUNNR.
    SELECTION-SCREEN END OF BLOCK B2.
  SELECTION-SCREEN END OF BLOCK B1.


  SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
    PARAMETERS P_DOWN AS CHECKBOX.
    PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT C_PATH.
  SELECTION-SCREEN END OF BLOCK B5.

  SELECTION-SCREEN BEGIN OF BLOCK B6 WITH FRAME TITLE TEXT-005.
    SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN END OF BLOCK B6.

*  **********below logic for gray out the default valuse
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM FCT.
*perform GET_FCAT.

FORM GET_DATA.

  SELECT A~VBELN,
         A~POSNR,
         A~MATNR,
         A~ABGRU,
         A~ERDAT,
         B~KUNNR
        INTO TABLE @DATA(IT_DATA)
        FROM VBAP AS A
        JOIN VBAK AS B ON ( B~VBELN = A~VBELN )
        WHERE A~VBELN IN @S_VBELN
        AND A~POSNR IN @S_POSNR
        AND B~KUNNR IN @S_KUNNR
        AND A~ABGRU NE ' '.

  IF IT_DATA IS NOT INITIAL.

    SELECT KUNNR,
           NAME1
           FROM KNA1
           INTO TABLE @DATA(IT_KNA1)
           FOR ALL ENTRIES IN @IT_DATA
           WHERE KUNNR = @IT_DATA-KUNNR.

    SELECT SPRAS,
           ABGRU,
           BEZEI
           FROM TVAGT
           INTO TABLE @DATA(IT_TVAGT)
           FOR ALL ENTRIES IN @IT_DATA
           WHERE ABGRU = @IT_DATA-ABGRU
           AND SPRAS = 'E'.

  ENDIF.

  LOOP AT IT_DATA INTO DATA(WA_DATA).

    WA_FINAL-VBELN = WA_DATA-VBELN.
    WA_FINAL-POSNR = WA_DATA-POSNR.
    WA_FINAL-ERDAT = WA_DATA-ERDAT.
    WA_FINAL-MATNR = WA_DATA-MATNR.
*Material text
    CLEAR: LV_LINES, LS_MATTXT.
    REFRESH LV_LINES.
    LV_NAME = WA_FINAL-MATNR.
    IF LV_NAME IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'GRUN'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
    READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.
    WA_FINAL-MATTXT = LS_MATTXT-TDLINE.

    WA_FINAL-KUNNR = WA_DATA-KUNNR.
    READ TABLE IT_KNA1 INTO DATA(WA_KNA1) WITH KEY KUNNR = WA_FINAL-KUNNR.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
    ENDIF.

    WA_FINAL-ABGRU = WA_DATA-ABGRU.
    READ TABLE IT_TVAGT INTO DATA(WA_TVAGT) WITH KEY ABGRU = WA_FINAL-ABGRU.
    IF SY-SUBRC IS INITIAL.
      WA_FINAL-BEZEI           =  WA_TVAGT-BEZEI.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR : WA_FINAL, WA_TVAGT, WA_DATA , WA_KNA1.

  ENDLOOP.
  IF P_DOWN = 'X'.
    BREAK PRIMUSABAP.
    LOOP AT IT_FINAL INTO WA_FINAL.
      WA_DOWN-VBELN = WA_FINAL-VBELN.
      WA_DOWN-POSNR = WA_FINAL-POSNR.
      WA_DOWN-MATNR = WA_FINAL-MATNR.
      WA_DOWN-MATTXT = WA_FINAL-MATTXT.
      WA_DOWN-ABGRU = WA_FINAL-ABGRU.
      WA_DOWN-BEZEI = WA_FINAL-BEZEI.
      WA_DOWN-KUNNR = WA_FINAL-KUNNR.
      WA_DOWN-NAME1 = WA_FINAL-NAME1.
      IF WA_FINAL-ERDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_FINAL-ERDAT
          IMPORTING
            OUTPUT = WA_DOWN-ERDAT.
        CONCATENATE WA_DOWN-ERDAT+0(2) WA_DOWN-ERDAT+2(3) WA_DOWN-ERDAT+5(4)
                       INTO WA_DOWN-ERDAT SEPARATED BY '-'.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.

      CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                      INTO WA_DOWN-REF_DATE SEPARATED BY '-'.

      WA_DOWN-REF_TIME = SY-UZEIT .
*BREAK primusabap.
      CONCATENATE WA_DOWN-REF_TIME+0(2) ':' WA_DOWN-REF_TIME+2(2)':' WA_DOWN-REF_TIME+4(2) INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR :WA_DOWN, WA_FINAL..
    ENDLOOP.
  ENDIF.

ENDFORM.
FORM FCT .
  REFRESH GT_FIELDCAT.
  PERFORM GT_FIELDCATLOG USING :
'VBELN'        'IT_FINAL'     'SO NO.'                    '1' '10',
'POSNR'        'iT_FINAL'     'Line Item'                 '2' '05',
'KUNNR'        'IT_FINAL'     'Customer Code'             '3' '07',
'NAME1'        'IT_FINAL'     'Customer Name'             '4' '40',
'MATNR'        'IT_FINAL'     'SO Material'               '5' '10',
'MATTXT'       'IT_FINAL'     'Material Description'      '6' '50',
'ERDAT'        'IT_FINAL'     'SO Date'                   '7' '11',
'ABGRU'        'IT_FINAL'    'Rejection Code'             '8' '03',
'BEZEI'        'IT_FINAL'    'Rejection Code Description' '9' '50'.


  FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  FS_LAYOUT-ZEBRA = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = 'sy-repid'
      IS_LAYOUT          = FS_LAYOUT
      IT_FIELDCAT        = GT_FIELDCAT[]
      I_DEFAULT          = 'X'
      I_SAVE             = 'A'
    TABLES
      T_OUTTAB           = IT_FINAL.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0259   text
*      -->P_0260   text
*      -->P_0261   text
*      -->P_0262   text
*----------------------------------------------------------------------*
FORM GT_FIELDCATLOG   USING    V1 V2 V3 V4 V5.

  GS_FIELDCAT-FIELDNAME   = V1.
  GS_FIELDCAT-TABNAME     = V2.
  GS_FIELDCAT-SELTEXT_L   = V3.
  GS_FIELDCAT-COL_POS     = V4.
  GS_FIELDCAT-OUTPUTLEN     = V5.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR  GS_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWNLOAD.

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
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

  LV_FILE = 'ZSO_REJECTION.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
     INTO LV_FULLFILE.

  WRITE: / 'ZSO_REJECTION.TXT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
*    TRANSFER hd_csv TO lv_fullfile.
    DATA LV_STRING_1367 TYPE STRING.
    DATA LV_CRLF_1367 TYPE STRING.
    LV_CRLF_1367 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1367 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1367 LV_CRLF_1367 WA_CSV INTO LV_STRING_1367.
      CLEAR: WA_CSV.

*      IF SY-SUBRC = 0.
*        TRANSFER WA_CSV TO LV_FULLFILE.
        TRANSFER LV_STRING_1367 TO LV_FULLFILE.

*      ENDIF.
    ENDLOOP.
*    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE  'Sales Order'
               'Sales ord. item'
               'So Material'
               'Material Description'
               'Customer Code'
               'Customer Name'
               'SO Date'
               'Rejection Code'
               'Rejection Code Description'
               'Refreshable Date'
               'Refreshable Time'
               INTO P_HD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
