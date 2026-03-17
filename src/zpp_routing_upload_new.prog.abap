*&---------------------------------------------------------------------*
*& Report ZPP_ROUTING_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_ROUTING_UPLOAD NO STANDARD PAGE HEADING
        MESSAGE-ID ZDEL.

TABLES :SSCRFIELDS.

TYPES: BEGIN OF TY_RECORD,
         MATNR     TYPE MARA-MATNR,
         WERKS     TYPE T001W-WERKS,
         STTAG(10) TYPE C,
         VERWE     TYPE PLKOD-VERWE,
*         usage TYPE plkod-verwe,
         STATU     TYPE PLKOD-STATU,
         VORNR(10),
         ARBPL     TYPE PLPOD-ARBPL,
         STEUS     TYPE PLPOD-STEUS,
         LTXA1     TYPE PLPOD-LTXA1,
         VGW01(12),        " TYPE plpod-vgw01,
         VGE01     TYPE PLPOD-VGE01,
*        ZUONR,
*        FRDLB,
*        INFNR,
*        EKORG,
*        SAKTO,
       END OF TY_RECORD.

DATA GT_RECORD  TYPE TABLE OF TY_RECORD.
DATA GT_BDCDATA TYPE TABLE OF BDCDATA.


CONSTANTS :
*  c_tcode(04) TYPE c VALUE 'XD01',      "Tran. Code - XD01
*  c_a(01)     TYPE c VALUE 'A',
*  c_e(01)     TYPE c VALUE 'E',       "Indicator - MSG type ERROR
  C_X(01)     TYPE C VALUE 'X'.       "Assigning the Value X

*>>
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECTION-SCREEN SKIP 1.
  PARAMETERS: P_FILE  TYPE LOCALFILE. "OBLIGATORY.                "File to upload data.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
*SELECTION-SCREEN SKIP 1.
  PARAMETERS P1 AS CHECKBOX.
*PARAMETERS: p1 no-display RADIOBUTTON GROUP g1 DEFAULT 'X',                "Foreground
*            p2 RADIOBUTTON GROUP g1 .                            "Background
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK B2.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.


*----------------------------------------------------------------------*
* Initialization Event
*----------------------------------------------------------------------*
INITIALIZATION.

  W_BUTTON = 'Download Excel Template'.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*----------------------------------------------------------------------*

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZROUTING_UPLOAD_EXCEL_NEW VIA SELECTION-SCREEN .
  ENDIF.


*---------------------------------------------------------------------*
*  At Selection-screen on value-request for p_file
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
**To provide F4 Help for the file path on the Selection Screen
  PERFORM GET_FILE CHANGING P_FILE.



START-OF-SELECTION.
* Upload the flat file
  PERFORM UPLOAD_FILE USING P_FILE.
*  changing it_records.
  IF GT_RECORD IS INITIAL.
    MESSAGE E000 WITH 'No Data has been Uploaded'.
  ENDIF.

  PERFORM RUN_BDC.
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
*&      Form  UPLOAD_FILE
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
*&      Form  RUN_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RUN_BDC .

  DATA LS_RECORD TYPE TY_RECORD.

  LOOP AT GT_RECORD INTO LS_RECORD.

    PERFORM BDC_DYNPRO  USING 'SAPLCPDI' '1010'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '/00'.
    PERFORM BDC_FIELD   USING 'RC27M-MATNR'  LS_RECORD-MATNR.  "'21S011512C02000000'.
    PERFORM BDC_FIELD   USING 'RC27M-WERKS'  LS_RECORD-WERKS.  "'PL01'.

    REPLACE ALL OCCURRENCES OF '-' in LS_RECORD-STTAG WITH '.' .
    PERFORM BDC_FIELD   USING 'RC271-STTAG'  LS_RECORD-STTAG.  "'PL01'.

    PERFORM BDC_FIELD   USING 'RC271-PLNNR'  ' '.
*    PERFORM bdc_field   USING 'RC271-STTAG'  '31.03.2017'.

    PERFORM BDC_DYNPRO  USING 'SAPLCPDA' '1200'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'   '/00'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'    '=VOUE'.
    PERFORM BDC_FIELD   USING 'PLKOD-PLNAL'  '1'.
    PERFORM BDC_FIELD   USING 'PLKOD-KTEXT'  LS_RECORD-LTXA1.
    "'21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT'  & 'ED'.
*    PERFORM bdc_field   USING 'PLKOD-WERKS'  'PL01'.
    PERFORM BDC_FIELD   USING 'PLKOD-VERWE'  LS_RECORD-VERWE.  "'1'.
    PERFORM BDC_FIELD   USING 'PLKOD-STATU'  LS_RECORD-STATU.  "'4'.
*    PERFORM bdc_field   USING 'PLKOD-LOSBS'  '99,999,999'.
*    PERFORM bdc_field   USING 'PLKOD-PLNME'   'NOS'.

*    PERFORM bdc_dynpro  USING 'SAPLCPDA' '1200'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'    '=VOUE'.
*    PERFORM bdc_field   USING 'PLKOD-KTEXT'  '21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT'  & 'ED'.
*    PERFORM bdc_field   USING 'PLKOD-WERKS'   'PL01'.
*    PERFORM bdc_field   USING 'PLKOD-VERWE'  '1'.
*    PERFORM bdc_field   USING 'PLKOD-STATU'  '4'.
*    PERFORM bdc_field   USING 'PLKOD-LOSBS'  '99,999,999'.
*    PERFORM bdc_field   USING 'PLKOD-PLNME'  'NOS'.

    PERFORM BDC_DYNPRO  USING 'SAPLCPDI' '1400'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '/00'.
    PERFORM BDC_FIELD   USING 'PLPOD-ARBPL(01)' LS_RECORD-ARBPL.   "'ACT'.

*    PERFORM bdc_dynpro  USING 'SAPLCPDI' '1400'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
*    PERFORM bdc_field   USING 'RC27X-ENTRY_ACT'  '1'.
    PERFORM BDC_FIELD   USING 'PLPOD-STEUS(01)'  LS_RECORD-STEUS.
    PERFORM BDC_FIELD   USING 'PLPOD-LTXA1(01)'  LS_RECORD-LTXA1.
    "'21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT' & 'ED'.
    PERFORM BDC_FIELD   USING 'PLPOD-VGW01(01)'  LS_RECORD-VGW01.   "'37'.
    PERFORM BDC_FIELD   USING 'PLPOD-VGE01(01)'  LS_RECORD-VGE01.   "

    PERFORM BDC_DYNPRO  USING 'SAPLCPDI' '1400'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'   '=MATA'.
    PERFORM BDC_FIELD   USING 'RC27X-ENTRY_ACT'  '1'.
    PERFORM BDC_FIELD   USING 'RC27X-FLG_SEL(01)'   'X'.

    PERFORM BDC_DYNPRO  USING 'SAPLCMDI' '1000'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '=MARA'.

    PERFORM BDC_DYNPRO  USING 'SAPLCMDI' '1000'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '=NEW'.

    PERFORM BDC_DYNPRO  USING 'SAPLCM01' '1090'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '=GOON'.
    PERFORM BDC_FIELD   USING 'RCM01-VORNR'  '0010'.
    PERFORM BDC_FIELD   USING 'RCM01-PLNFL'  '0'.

    PERFORM BDC_DYNPRO  USING 'SAPLCMDI' '1000'.
    PERFORM BDC_FIELD   USING 'BDC_OKCODE'  '=BU'.
    PERFORM BDC_TRANSACTION USING 'CA01'.

  ENDLOOP.

ENDFORM.
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
FORM BDC_DYNPRO  USING RPROGRAM TYPE BDC_PROG
                       RDYNPRO  TYPE BDC_DYNR.

*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = RPROGRAM.
  WA_BDCDATA-DYNPRO   = RDYNPRO.
  WA_BDCDATA-DYNBEGIN = C_X.
  APPEND WA_BDCDATA TO GT_BDCDATA.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
FORM BDC_FIELD  USING RFNAM TYPE FNAM_____4
                      RFVAL.
*Work Area for the Internal table T_BDCDATA
  DATA : WA_BDCDATA TYPE BDCDATA.

  CLEAR WA_BDCDATA.
  WA_BDCDATA-FNAM = RFNAM.
  WA_BDCDATA-FVAL = RFVAL.
  APPEND WA_BDCDATA TO GT_BDCDATA.

ENDFORM.                    " bdc_field
*----------------------------------------------------------------------*
*        Start new transaction according to parameters                 *
*----------------------------------------------------------------------*
FORM BDC_TRANSACTION USING TCODE.

  DATA: L_MSTRING(480).
  DATA: MESSTAB LIKE BDCMSGCOLL OCCURS 0 WITH HEADER LINE.
  DATA: L_SUBRC LIKE SY-SUBRC,
        CTUMODE LIKE CTU_PARAMS-DISMODE VALUE 'N',
        CUPDATE LIKE CTU_PARAMS-UPDMODE VALUE 'L'.

  IF P1 = 'X'.
    CTUMODE = 'A'.
  ELSE.
    CTUMODE = 'N'.
  ENDIF.

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
