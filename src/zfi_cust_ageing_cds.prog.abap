REPORT ZFI_CUST_AGEING_CDS NO STANDARD PAGE HEADING LINE-COUNT 300.
TABLES: KNA1.
TYPE-POOLS: SLIS.

*----------------------------------------------------------------------
* Selection screen – labels rendered via comments (<=8 char names)
*----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK HEAD WITH FRAME.
  SELECTION-SCREEN COMMENT /1(40) LB_TITLE.
SELECTION-SCREEN END OF BLOCK HEAD.

SELECTION-SCREEN BEGIN OF BLOCK A1 WITH FRAME.
  PARAMETERS: PLANT TYPE BUKRS OBLIGATORY DEFAULT '1000'.
  SELECT-OPTIONS: S_KUNNR FOR KNA1-KUNNR NO INTERVALS.
  PARAMETERS: P_DATE TYPE BUDAT OBLIGATORY DEFAULT SY-DATUM.

  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT /1(30) LB_BUCK.
  PARAMETERS: RASTBIS1 TYPE I DEFAULT 30,
              RASTBIS2 TYPE I DEFAULT 60,
              RASTBIS3 TYPE I DEFAULT 90,
              RASTBIS4 TYPE I DEFAULT 180,
              RASTBIS5 TYPE I DEFAULT 360,
              RASTBIS6 TYPE I DEFAULT 720,
              RASTBIS7 TYPE I DEFAULT 720. "kept for parity
SELECTION-SCREEN END OF BLOCK A1.

SELECTION-SCREEN BEGIN OF BLOCK A2 WITH FRAME.
  PARAMETERS: R1 RADIOBUTTON GROUP ABX DEFAULT 'X',
              R2 RADIOBUTTON GROUP ABX.
  SELECTION-SCREEN COMMENT /1(20) LB_R1.
  SELECTION-SCREEN COMMENT /25(20) LB_R2.
SELECTION-SCREEN END OF BLOCK A2.

SELECTION-SCREEN BEGIN OF BLOCK A3 WITH FRAME.
  PARAMETERS P_DOWN  AS CHECKBOX.
  PARAMETERS P_FOLDER TYPE RLGRAP-FILENAME DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK A3.

SELECTION-SCREEN BEGIN OF BLOCK A4 WITH FRAME.
  PARAMETERS P_MAIL  AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK A4.

SELECTION-SCREEN BEGIN OF BLOCK A5 WITH FRAME.
  SELECTION-SCREEN COMMENT /1(40) LB_FN1.
  SELECTION-SCREEN COMMENT /1(40) LB_FN2.
SELECTION-SCREEN END OF BLOCK A5.

INITIALIZATION.
  LB_TITLE = 'Customer Ageing Report'.
  LB_BUCK  = 'Aging Buckets (days):'.
  LB_R1    = 'Document Date'.
  LB_R2    = 'Due Date'.
  LB_FN1   = '''ZCUST_AGE.TXT'''.
  LB_FN2   = '''DATE_TIME_ZCUST_AGE.TXT'''.

*----------------------------------------------------------------------
* Local types – match the CDS TF return structure
*----------------------------------------------------------------------
  TYPES: BEGIN OF TY_AGE,
           GROUP    TYPE STRING,
           BEZEI    TYPE TVKBT-BEZEI,
           TDISP    TYPE STRING,
           BLDAT    TYPE BUDAT,
           BUDAT    TYPE BUDAT,
           REC_TXT  TYPE STRING,
           DUEDATE  TYPE BUDAT,
           BLART    TYPE BLART,
           BELNR    TYPE BELNR_D,
           VBELN    TYPE VBELN_VF,
           XBLNR    TYPE XBLNR1,
           FKDAT    TYPE FKDAT,
           VTEXT    TYPE CHAR200,
           AUBEL    TYPE VBELN_VA,
           AUDAT    TYPE AUDAT,
           BSTKD    TYPE BSTKD,
           BSTDK    TYPE BSTDK,
           CURR     TYPE DMBTR,
           WAERS    TYPE WAERS,
           DEBIT    TYPE DMBTR,
           CREDIT   TYPE DMBTR,
           NETBAL   TYPE DMBTR,
           NOT_DUE  TYPE DMBTR,
           NETB30   TYPE DMBTR,
           NETB60   TYPE DMBTR,
           NETB90   TYPE DMBTR,
           NETB120  TYPE DMBTR,
           NETB180  TYPE DMBTR,
           NETB360  TYPE DMBTR,
           NETB720  TYPE DMBTR,
           NETB1000 TYPE DMBTR,
           DAY      TYPE I,
           KUNNR    TYPE KUNNR,
           REGIO    TYPE REGIO,
           REG_DESC TYPE BEZEI20,
           AKONT    TYPE SAKNR,
         END OF TY_AGE.

  DATA: GT_AGE TYPE STANDARD TABLE OF TY_AGE,
        GS_AGE TYPE TY_AGE.

*----------------------------------------------------------------------
* ALV artifacts (same style as your original)
*----------------------------------------------------------------------
  DATA: GS_LAYOUT   TYPE SLIS_LAYOUT_ALV,
        GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
        GT_SORT     TYPE SLIS_T_SORTINFO_ALV  WITH HEADER LINE.

*----------------------------------------------------------------------
* Selection validation – same sorted/upper-limit checks
*----------------------------------------------------------------------
AT SELECTION-SCREEN.
  PERFORM VALIDATE_BUCKETS.

*----------------------------------------------------------------------
* Start of selection
*----------------------------------------------------------------------
START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM BUILD_ALV.
  PERFORM DISPLAY_ALV.

END-OF-SELECTION.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD_TXT USING P_FOLDER.
    IF P_MAIL = 'X' AND P_DATE = SY-DATUM.
      PERFORM SEND_MAIL.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------
* Fetch from CDS Table Function (pushdown logic lives there)
*----------------------------------------------------------------------
FORM GET_DATA.
  CLEAR GT_AGE.
  SELECT *
    FROM ZTF_CustAgeing(
      P_BUKRS => @PLANT,
      P_DATE  => @P_DATE,
      P_R1    => @COND ABAP_BOOL( WHEN R1 = 'X' THEN 'X' ELSE '' ),
      P_B1    => @RASTBIS1,
      P_B2    => @RASTBIS2,
      P_B3    => @RASTBIS3,
      P_B4    => @RASTBIS4,
      P_B5    => @RASTBIS5,
      P_B6    => @RASTBIS6,
      P_B7    => @RASTBIS7 )
    INTO TABLE @GT_AGE.

  " Apply customer filter (SO on return set)
  IF S_KUNNR[] IS NOT INITIAL.
    DELETE GT_AGE WHERE NOT ( KUNNR IN S_KUNNR ).
  ENDIF.

  IF GT_AGE IS INITIAL.
    MESSAGE 'No data found for the selection' TYPE 'I'.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------
* Build ALV (fieldcat, sort, layout)
*----------------------------------------------------------------------
FORM BUILD_ALV.
  CLEAR GT_FIELDCAT.
  PERFORM F_FIELDCAT USING '1'  'GROUP'    'GL Type'.
  PERFORM F_FIELDCAT USING '2'  'BEZEI'    'Sales Office'.
  PERFORM F_FIELDCAT USING '3'  'TDISP'    'Customer Code Name'.
  PERFORM F_FIELDCAT USING '4'  'BLDAT'    'Document Date'.
  PERFORM F_FIELDCAT USING '5'  'BUDAT'    'Posting Date'.
  PERFORM F_FIELDCAT USING '6'  'REC_TXT'  'Reconciliation Account'.
  PERFORM F_FIELDCAT USING '7'  'DUEDATE'  'Due Date'.
  PERFORM F_FIELDCAT USING '8'  'BLART'    'FI Doc Type'.
  PERFORM F_FIELDCAT USING '9'  'BELNR'    'Accounting Doc No.'.
  PERFORM F_FIELDCAT USING '10' 'VBELN'    'Billing Doc.No.'.
  PERFORM F_FIELDCAT USING '11' 'XBLNR'    'Tax Invoice No.(ODN)'.
  PERFORM F_FIELDCAT USING '12' 'FKDAT'    'Tax Invoice Date'.
  PERFORM F_FIELDCAT USING '13' 'VTEXT'    'Payment Terms'.
  PERFORM F_FIELDCAT USING '14' 'AUBEL'    'Sales Order No.'.
  PERFORM F_FIELDCAT USING '15' 'AUDAT'    'Sales Order Date'.
  PERFORM F_FIELDCAT USING '16' 'BSTKD'    'Customer PO. NO.'.
  PERFORM F_FIELDCAT USING '17' 'BSTDK'    'Customer PO. Date'.
  PERFORM F_FIELDCAT USING '18' 'CURR'     'Amt Document Currency'.
  PERFORM F_FIELDCAT USING '19' 'WAERS'    'Currency Key'.
  PERFORM F_FIELDCAT USING '20' 'DEBIT'    'Total Inv Amt (INR)'.
  PERFORM F_FIELDCAT USING '21' 'CREDIT'   'Total Rec/Cre Memo Amt (INR)'.
  PERFORM F_FIELDCAT USING '22' 'NETBAL'   'Total Outstanding'.
  PERFORM F_FIELDCAT USING '23' 'NOT_DUE'  'Not Due'.
  PERFORM F_FIELDCAT USING '24' 'NETB30'   '000 to B1 Days'.
  PERFORM F_FIELDCAT USING '25' 'NETB60'   'B1 to B2 Days'.
  PERFORM F_FIELDCAT USING '26' 'NETB90'   'B2 to B3 Days'.
  PERFORM F_FIELDCAT USING '27' 'NETB120'  'B3 to B4 Days'.
  PERFORM F_FIELDCAT USING '28' 'NETB180'  'B4 to B5 Days'.
  PERFORM F_FIELDCAT USING '29' 'NETB360'  'B5 to B6 Days'.
  PERFORM F_FIELDCAT USING '30' 'NETB720'  'B6 to B7 Days'.
  PERFORM F_FIELDCAT USING '31' 'NETB1000' 'B7 and Above'.
  PERFORM F_FIELDCAT USING '32' 'DAY'      'Over Due Days'.
  PERFORM F_FIELDCAT USING '33' 'REGIO'    'Region'.
  PERFORM F_FIELDCAT USING '34' 'REG_DESC' 'Region Description'.

  CLEAR GT_SORT.
  GT_SORT-SPOS      = '1'. GT_SORT-FIELDNAME = 'GROUP'. GT_SORT-UP = 'X'. GT_SORT-SUBTOT = 'X'. APPEND GT_SORT.
  GT_SORT-SPOS      = '2'. GT_SORT-FIELDNAME = 'TDISP'. GT_SORT-UP = 'X'. GT_SORT-SUBTOT = 'X'. APPEND GT_SORT.
  GT_SORT-SPOS      = '3'. GT_SORT-FIELDNAME = 'BLDAT'. GT_SORT-UP = 'X'. GT_SORT-SUBTOT = SPACE. APPEND GT_SORT.

  GS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  GS_LAYOUT-ZEBRA             = 'X'.
  GS_LAYOUT-DETAIL_POPUP      = 'X'.
  GS_LAYOUT-SUBTOTALS_TEXT    = 'DR'.
ENDFORM.

FORM F_FIELDCAT USING P_POS P_FIELD P_TEXT.
  GT_FIELDCAT-COL_POS   = P_POS.
  GT_FIELDCAT-FIELDNAME = P_FIELD.
  GT_FIELDCAT-SELTEXT_L = P_TEXT.
  IF P_FIELD = 'BELNR'. GT_FIELDCAT-HOTSPOT = 'X'. ENDIF.
  IF P_FIELD = 'DEBIT'    OR P_FIELD = 'CREDIT'   OR P_FIELD = 'NETBAL' OR
     P_FIELD = 'NOT_DUE'  OR P_FIELD = 'NETB30'   OR P_FIELD = 'NETB60' OR
     P_FIELD = 'NETB90'   OR P_FIELD = 'NETB120'  OR P_FIELD = 'NETB180' OR
     P_FIELD = 'NETB360'  OR P_FIELD = 'NETB720'  OR P_FIELD = 'NETB1000'.
    GT_FIELDCAT-DO_SUM = 'X'.
  ENDIF.
  APPEND GT_FIELDCAT. CLEAR GT_FIELDCAT.
ENDFORM.

*----------------------------------------------------------------------
* ALV display (classic REUSE...)
*----------------------------------------------------------------------
FORM DISPLAY_ALV.
  DATA LS_VARIANT TYPE DISVARIANT.
  LS_VARIANT-REPORT = SY-REPID.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      IS_LAYOUT               = GS_LAYOUT
      IT_FIELDCAT             = GT_FIELDCAT[]
      IT_SORT                 = GT_SORT[]
      I_SAVE                  = 'X'
      IS_VARIANT              = LS_VARIANT
      I_CALLBACK_TOP_OF_PAGE  = 'TOP_OF_PAGE'
      I_CALLBACK_USER_COMMAND = 'USER_CMD'
    TABLES
      T_OUTTAB                = GT_AGE
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

FORM TOP_OF_PAGE.
  DATA: T_HEADER TYPE SLIS_T_LISTHEADER,
        WA       TYPE SLIS_LISTHEADER.

  WA-TYP  = 'H'. WA-INFO = 'Customer Ageing Report'. APPEND WA TO T_HEADER. CLEAR WA.
  WA-TYP  = 'S'. WA-KEY  = 'As on   :'.
  WA-INFO = |{ P_DATE+6(2) }.{ P_DATE+4(2) }.{ P_DATE(4) }|. APPEND WA TO T_HEADER. CLEAR WA.
  WA-TYP  = 'S'. WA-KEY  = 'Run Date:'. WA-INFO = |{ SY-DATUM+6(2) }.{ SY-DATUM+4(2) }.{ SY-DATUM(4) }|. APPEND WA TO T_HEADER. CLEAR WA.
  WA-TYP  = 'S'. WA-KEY  = 'Run Time:'.
  WA-INFO = |{ SY-TIMLO(2) }:{ SY-TIMLO+2(2) }:{ SY-TIMLO+4(2) }|. APPEND WA TO T_HEADER. CLEAR WA.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
ENDFORM.

*----------------------------------------------------------------------
* Hotspot on BELNR -> FB03
*----------------------------------------------------------------------
FORM USER_CMD USING R_UCOMM LIKE SY-UCOMM RS_SELFIELD TYPE SLIS_SELFIELD.
  IF R_UCOMM = '&IC1' AND RS_SELFIELD-FIELDNAME = 'BELNR'.
    READ TABLE GT_AGE INDEX RS_SELFIELD-TABINDEX INTO DATA(LS).
    IF SY-SUBRC = 0 AND LS-BELNR IS NOT INITIAL.
      SET PARAMETER ID 'BLN' FIELD LS-BELNR.
      SET PARAMETER ID 'BUK' FIELD PLANT.
      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------
* TXT download to app server (tab-separated + one header line)
*----------------------------------------------------------------------
FORM DOWNLOAD_TXT USING PV_FOLDER TYPE RLGRAP-FILENAME.
  DATA: LT_LINES TYPE STANDARD TABLE OF STRING,
        LV_FILE  TYPE STRING,
        LV_LINE  TYPE STRING,
        SEP      TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  " Header
  CONCATENATE 'GL Type' 'Sales Office' 'Customer Code Name' 'Document Date' 'Posting Date'
              'Reconciliation Account' 'Due Date' 'FI Doc Type' 'Accounting Doc No.'
              'Billing Doc.No.' 'Tax Invoice No.(ODN)' 'Tax Invoice Date' 'Payment Terms'
              'Sales Order No.' 'Sales Order Date' 'Customer PO. NO.' 'Customer PO. Date'
              'Amt Document Currency' 'Currency Key' 'Total Inv Amt (INR)'
              'Total Rec/Cre Memo Amt (INR)' 'Total Outstanding' 'Not Due'
              '000 to B1 Days' 'B1 to B2 Days' 'B2 to B3 Days' 'B3 to B4 Days'
              'B4 to B5 Days' 'B5 to B6 Days' 'B6 to B7 Days' 'B7 and Above'
              'Over Due Days' 'Region' 'Region Description'
              INTO LV_LINE SEPARATED BY SEP.
  APPEND LV_LINE TO LT_LINES.

  " Rows
  LOOP AT GT_AGE INTO GS_AGE.
    LV_LINE =
      |{ GS_AGE-GROUP }{ SEP }{ GS_AGE-BEZEI }{ SEP }{ GS_AGE-TDISP }{ SEP }{ GS_AGE-BLDAT }{ SEP }{ GS_AGE-BUDAT }{ SEP }| &&
      |{ GS_AGE-REC_TXT }{ SEP }{ GS_AGE-DUEDATE }{ SEP }{ GS_AGE-BLART }{ SEP }{ GS_AGE-BELNR }{ SEP }{ GS_AGE-VBELN }{ SEP }| &&
      |{ GS_AGE-XBLNR }{ SEP }{ GS_AGE-FKDAT }{ SEP }{ GS_AGE-VTEXT }{ SEP }{ GS_AGE-AUBEL }{ SEP }{ GS_AGE-AUDAT }{ SEP }| &&
      |{ GS_AGE-BSTKD }{ SEP }{ GS_AGE-BSTDK }{ SEP }{ GS_AGE-CURR }{ SEP }{ GS_AGE-WAERS }{ SEP }{ GS_AGE-DEBIT }{ SEP }| &&
      |{ GS_AGE-CREDIT }{ SEP }{ GS_AGE-NETBAL }{ SEP }{ GS_AGE-NOT_DUE }{ SEP }{ GS_AGE-NETB30 }{ SEP }{ GS_AGE-NETB60 }{ SEP }| &&
      |{ GS_AGE-NETB90 }{ SEP }{ GS_AGE-NETB120 }{ SEP }{ GS_AGE-NETB180 }{ SEP }{ GS_AGE-NETB360 }{ SEP }{ GS_AGE-NETB720 }{ SEP }| &&
      |{ GS_AGE-NETB1000 }{ SEP }{ GS_AGE-DAY }{ SEP }{ GS_AGE-REGIO }{ SEP }{ GS_AGE-REG_DESC }|.
    APPEND LV_LINE TO LT_LINES.
  ENDLOOP.

  " Write two files like your original (dated and plain)
  LV_FILE = PV_FOLDER && '/ZCUST_AGE.TXT'.
  PERFORM WRITE_DATASET USING LV_FILE LT_LINES.

  LV_FILE = PV_FOLDER && '/' && SY-DATUM && SY-UZEIT && 'ZCUST_AGE.TXT'.
  PERFORM WRITE_DATASET USING LV_FILE LT_LINES.
ENDFORM.

FORM WRITE_DATASET USING PV_FILE TYPE STRING PT_LINES TYPE STANDARD TABLE.
  OPEN DATASET PV_FILE FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF SY-SUBRC = 0.
    LOOP AT PT_LINES INTO DATA(L).
      TRANSFER L TO PV_FILE.
    ENDLOOP.
    CLOSE DATASET PV_FILE.
    MESSAGE |File { PV_FILE } downloaded| TYPE 'S'.
  ELSE.
    MESSAGE |Cannot open { PV_FILE }| TYPE 'E'.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------
* Email (optional) – attaches TXT (same content as first file)
*----------------------------------------------------------------------
FORM SEND_MAIL.
  DATA(LO_REQ) = CL_BCS=>CREATE_PERSISTENT( ).
  DATA LT_BODY TYPE SOLI_TAB.
  APPEND VALUE SOLI( LINE = 'Dear Sir/Madam,' ) TO LT_BODY.
  APPEND VALUE SOLI( LINE = 'Please find attached the Customer Ageing Report.' ) TO LT_BODY.
  DATA(LO_DOC) = CL_DOCUMENT_BCS=>CREATE_DOCUMENT(
                   I_TYPE    = 'RAW'
                   I_TEXT    = LT_BODY
                   I_SUBJECT = 'Customer Ageing Report' ).
  LO_REQ->SET_DOCUMENT( LO_DOC ).

  " Build same TXT content in memory
  DATA: LT_LINES TYPE STANDARD TABLE OF STRING.
  PERFORM DOWNLOAD_TXT_PREPARE CHANGING LT_LINES.
  DATA LT_SOLI TYPE SOLI_TAB.
  LOOP AT LT_LINES INTO DATA(S).
    APPEND VALUE SOLI( LINE = S ) TO LT_SOLI.
  ENDLOOP.

  LO_DOC->ADD_ATTACHMENT(
      I_ATTACHMENT_TYPE    = 'TXT'
      I_ATTACHMENT_SUBJECT = 'Customer_Ageing'
      I_ATT_CONTENT_TEXT   = LT_SOLI ).

  " Example recipients from ZCUST_MAIL (zto)
  SELECT ZTO FROM ZCUST_MAIL INTO TABLE @DATA(LT_TO) WHERE ZOFFICE IS NOT NULL AND ZTO IS NOT NULL.
  LOOP AT LT_TO ASSIGNING FIELD-SYMBOL(<R>).
    LO_REQ->ADD_RECIPIENT( CL_CAM_ADDRESS_BCS=>CREATE_INTERNET_ADDRESS( <R>-ZTO ) ).
  ENDLOOP.

  LO_REQ->SEND( I_WITH_ERROR_SCREEN = ABAP_TRUE ).
  COMMIT WORK.
ENDFORM.

FORM DOWNLOAD_TXT_PREPARE CHANGING CT_LINES TYPE STANDARD TABLE OF STRING.
  DATA SEP TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  DATA LV_LINE TYPE STRING.

  " Header
  CONCATENATE 'GL Type' 'Sales Office' 'Customer Code Name' 'Document Date' 'Posting Date'
              'Reconciliation Account' 'Due Date' 'FI Doc Type' 'Accounting Doc No.'
              'Billing Doc.No.' 'Tax Invoice No.(ODN)' 'Tax Invoice Date' 'Payment Terms'
              'Sales Order No.' 'Sales Order Date' 'Customer PO. NO.' 'Customer PO. Date'
              'Amt Document Currency' 'Currency Key' 'Total Inv Amt (INR)'
              'Total Rec/Cre Memo Amt (INR)' 'Total Outstanding' 'Not Due'
              '000 to B1 Days' 'B1 to B2 Days' 'B2 to B3 Days' 'B3 to B4 Days'
              'B4 to B5 Days' 'B5 to B6 Days' 'B6 to B7 Days' 'B7 and Above'
              'Over Due Days' 'Region' 'Region Description'
              INTO LV_LINE SEPARATED BY SEP.
  APPEND LV_LINE TO CT_LINES.

  LOOP AT GT_AGE INTO GS_AGE.
    LV_LINE =
      |{ GS_AGE-GROUP }{ SEP }{ GS_AGE-BEZEI }{ SEP }{ GS_AGE-TDISP }{ SEP }{ GS_AGE-BLDAT }{ SEP }{ GS_AGE-BUDAT }{ SEP }| &&
      |{ GS_AGE-REC_TXT }{ SEP }{ GS_AGE-DUEDATE }{ SEP }{ GS_AGE-BLART }{ SEP }{ GS_AGE-BELNR }{ SEP }{ GS_AGE-VBELN }{ SEP }| &&
      |{ GS_AGE-XBLNR }{ SEP }{ GS_AGE-FKDAT }{ SEP }{ GS_AGE-VTEXT }{ SEP }{ GS_AGE-AUBEL }{ SEP }{ GS_AGE-AUDAT }{ SEP }| &&
      |{ GS_AGE-BSTKD }{ SEP }{ GS_AGE-BSTDK }{ SEP }{ GS_AGE-CURR }{ SEP }{ GS_AGE-WAERS }{ SEP }{ GS_AGE-DEBIT }{ SEP }| &&
      |{ GS_AGE-CREDIT }{ SEP }{ GS_AGE-NETBAL }{ SEP }{ GS_AGE-NOT_DUE }{ SEP }{ GS_AGE-NETB30 }{ SEP }{ GS_AGE-NETB60 }{ SEP }| &&
      |{ GS_AGE-NETB90 }{ SEP }{ GS_AGE-NETB120 }{ SEP }{ GS_AGE-NETB180 }{ SEP }{ GS_AGE-NETB360 }{ SEP }{ GS_AGE-NETB720 }{ SEP }| &&
      |{ GS_AGE-NETB1000 }{ SEP }{ GS_AGE-DAY }{ SEP }{ GS_AGE-REGIO }{ SEP }{ GS_AGE-REG_DESC }|.
    APPEND LV_LINE TO CT_LINES.
  ENDLOOP.
ENDFORM.

*----------------------------------------------------------------------
* Bucket validation (mirrors your original checks)
*----------------------------------------------------------------------
FORM VALIDATE_BUCKETS.
  " Convert NULLs to zeros for comparisons
  DATA: B1 TYPE I VALUE RASTBIS1,
        B2 TYPE I VALUE RASTBIS2,
        B3 TYPE I VALUE RASTBIS3,
        B4 TYPE I VALUE RASTBIS4,
        B5 TYPE I VALUE RASTBIS5,
        B6 TYPE I VALUE RASTBIS6,
        B7 TYPE I VALUE RASTBIS7.

  " Max 998 and strictly ascending if provided – same rule as original
  IF B1 GT 998 OR B2 GT 998 OR B3 GT 998 OR B4 GT 998 OR B5 GT 998 OR B6 GT 998 OR B7 GT 998.
    MESSAGE 'Enter a consistent sorted list (max 998 days)' TYPE 'E'.
  ENDIF.

  IF NOT ( ( B2 IS INITIAL OR B2 GT B1 )
        AND ( B3 IS INITIAL OR B3 GT B2 )
        AND ( B4 IS INITIAL OR B4 GT B3 )
        AND ( B5 IS INITIAL OR B5 GT B4 )
        AND ( B6 IS INITIAL OR B6 GT B5 )
        AND ( B7 IS INITIAL OR B7 GT B6 ) ).
    MESSAGE 'Enter a maximum of 998 days in strictly increasing order' TYPE 'E'.
  ENDIF.
ENDFORM.
