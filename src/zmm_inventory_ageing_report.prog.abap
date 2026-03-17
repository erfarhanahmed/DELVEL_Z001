*&---------------------------------------------------------------------*
*& Report ZINV_AGEING_CDS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT ZMM_INVENTORY_AGEING_REPORT NO STANDARD PAGE HEADING.
TABLES: MARA,MARC.
TYPE-POOLS: VRM.

TYPES: BEGIN OF TY_DOWN,
         MATERIALDOCUMENT   TYPE MSEG-MBLNR,
         PRODUCT            TYPE MSEG-MATNR,
         MOVEMENTTYPE       TYPE MSEG-BWART,
         MOVEMENTTEXT       TYPE CHAR256,
         PLANT              TYPE MSEG-WERKS,
         STORAGELOCATION    TYPE MSEG-LGORT,
         QUANTITY           TYPE CHAR256,
         ALLOCURQTY         TYPE CHAR256,
         ALLOCSOQTY         TYPE CHAR256,
         URAMOUNT           TYPE CHAR256,
         SOAMOUNT           TYPE CHAR256,
         POSTINGDATE        TYPE CHAR15,
         AGEDAYS            TYPE CHAR15,
         USACODE            TYPE MARA-WRKST,
         DOCUMENTDATE       TYPE CHAR15,
         REF                TYPE CHAR15,
         PRODUCTDESCRIPTION TYPE STRING,
       END OF TY_DOWN.

DATA: IT_DOWN TYPE TABLE OF TY_DOWN,
      WA_DOWN TYPE          TY_DOWN.
DATA: LT_OUT TYPE TABLE OF ZINV_AGEING_C_INVAGEDET.
DATA: LT_VALUES TYPE VRM_VALUES,
      LS_VALUE  TYPE VRM_VALUE.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                  S_WERKS FOR MARC-WERKS.
  PARAMETERS: P_LGORT TYPE LGORT_D OBLIGATORY,
              P_BUKRS TYPE BUKRS    DEFAULT '1000'.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK B2.

DATA:LR_MATNR TYPE RANGE OF MATNR,
     LR_WERKS TYPE RANGE OF WERKS_D.

DATA: LT_LINES TYPE TABLE OF TLINE,
      LS_LINES TYPE TLINE.
DATA: LV_TEXT TYPE TDOBNAME.

INITIALIZATION.
  IF SY-TCODE = 'ZINVAG_DET_V1'.
    P_FOLDER = '/Delval/India'.
    P_BUKRS = '1000'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'P_FOLDER' .
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF SY-TCODE = 'ZUS_INVAG_DET_V1 '.
    P_FOLDER = '/Delval/USA'.
    P_BUKRS = 'US00'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'P_FOLDER' .
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
      IF SCREEN-NAME = 'P_BUKRS' .
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDIF.


  IF SY-TCODE = 'ZINVAG_DET_V1' .
    IF S_WERKS[] IS INITIAL.
      APPEND VALUE #( SIGN = 'I' OPTION = 'CP' LOW = 'PL01' ) TO S_WERKS.
      LOOP AT SCREEN.
        IF SCREEN-NAME = 'S_WERKS-LOW' .
          SCREEN-INPUT = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.

    LOOP AT SCREEN.
      IF SCREEN-NAME = 'S_WERKS-HIGH'.
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_LGORT.
  PERFORM F4_HELP_STORAGE_LOCATION.

START-OF-SELECTION.
  IF SY-TCODE = 'ZUS_INVAG_DET_V1'.
    IF S_WERKS-LOW = 'US01' OR S_WERKS-LOW = 'US03'.
      DATA(LV_FLAG) = 'X' .
    ENDIF.
    IF LV_FLAG IS INITIAL .
      MESSAGE :'Please select correct plant - US01 or US03' TYPE 'I'.
    ENDIF.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'S_WERKS-HIGH'.
        SCREEN-INPUT = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.


  LR_MATNR = VALUE #( FOR R IN S_MATNR ( R ) ).
  LR_WERKS = VALUE #( FOR R_WERKS IN S_WERKS ( R_WERKS ) ).

  SELECT DISTINCT * FROM  ZINV_AGEING_C_INVAGEDET(
                          P_BUKRS = @P_BUKRS,
                          P_WERKS = @S_WERKS-LOW,
                          P_LGORT = @P_LGORT )
                    WHERE PRODUCT IN @S_MATNR
                    AND   PLANT   IN @S_WERKS
  INTO TABLE @LT_OUT.


  CLEAR: IT_DOWN.
  LOOP AT LT_OUT INTO DATA(WA_OUT).

***************************************************************************
    "SOC Added by sanjay func-ashish 11.03.2026
    IF WA_OUT-ALLOCSOQTY IS NOT INITIAL AND WA_OUT-SOAMOUNT IS INITIAL.
      SELECT SUM( LBKUM ) AS LBKUM,
               SUM( SALK3 ) AS SALK3
               FROM EBEW  WHERE MATNR = @WA_OUT-PRODUCT AND SOBKZ = 'E'
                            AND BWKEY = @WA_OUT-PLANT
                            AND ( BWTAR = '' OR BWTAR IS NULL )
                            AND VBELN = @WA_OUT-SALESORDER
                            AND LBKUM > 0
                            INTO @DATA(WA_EBEW).
      TRY.
          WA_OUT-RATEUSED = WA_EBEW-SALK3 / WA_EBEW-LBKUM.
        CATCH CX_SY_ZERODIVIDE .

      ENDTRY.

      WA_OUT-SOAMOUNT = WA_OUT-RATEUSED * WA_OUT-ALLOCSOQTY.

    ENDIF.
    "EOC Added by sanjay func-ashish 11.03.2026
***************************************************************************
    MOVE-CORRESPONDING WA_OUT TO WA_DOWN.
    LV_TEXT = WA_OUT-PRODUCT.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        CLIENT                  = SY-MANDT
        ID                      = 'GRUN'
        LANGUAGE                = 'E'
        NAME                    = LV_TEXT
        OBJECT                  = 'MATERIAL'
      TABLES
        LINES                   = LT_LINES
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
* Implement suitable error handling here
    ENDIF.

    LOOP AT  LT_LINES INTO LS_LINES.
      CONCATENATE WA_OUT-PRODUCTDESCRIPTION  LS_LINES-TDLINE  INTO WA_OUT-PRODUCTDESCRIPTION SEPARATED BY SPACE.
      CONCATENATE WA_DOWN-PRODUCTDESCRIPTION  LS_LINES-TDLINE INTO WA_DOWN-PRODUCTDESCRIPTION SEPARATED BY SPACE.
    ENDLOOP.

    IF WA_OUT-POSTINGDATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUT-POSTINGDATE
        IMPORTING
          OUTPUT = WA_DOWN-POSTINGDATE.

      CONCATENATE WA_DOWN-POSTINGDATE+0(2)
                  WA_DOWN-POSTINGDATE+2(3)
                  WA_DOWN-POSTINGDATE+5(4)
                  INTO WA_DOWN-POSTINGDATE SEPARATED BY '-'.

    ENDIF.

    IF WA_OUT-DOCUMENTDATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUT-DOCUMENTDATE
        IMPORTING
          OUTPUT = WA_DOWN-DOCUMENTDATE.

      CONCATENATE WA_DOWN-DOCUMENTDATE+0(2)
                  WA_DOWN-DOCUMENTDATE+2(3)
                  WA_DOWN-DOCUMENTDATE+5(4)
                  INTO WA_DOWN-DOCUMENTDATE SEPARATED BY '-'.

    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_DOWN-REF.

    CONCATENATE WA_DOWN-REF+0(2)
                WA_DOWN-REF+2(3)
                WA_DOWN-REF+5(4)
               INTO WA_DOWN-REF SEPARATED BY '-'.

    APPEND WA_DOWN TO IT_DOWN.
    CLEAR: WA_DOWN.
    MODIFY LT_OUT FROM WA_OUT.
    CLEAR: WA_OUT.
  ENDLOOP.
*DELETE LT_OUT where MovementType = '321' and AllocationCategory = 'SO'. " Added by sanjay Func-Prathamesh 09.12.2025
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD TABLES IT_DOWN USING P_FOLDER P_LGORT.
  ENDIF.

  DATA: GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
        GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
        GT_LAYOUT   TYPE SLIS_LAYOUT_ALV.

  "------------------------------------------------------------
  " Build Field Catalog Manually
  "------------------------------------------------------------

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MATERIALDOCUMENT'.
  GS_FIELDCAT-SELTEXT_M = 'Document No'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'PRODUCT'.
  GS_FIELDCAT-SELTEXT_M = 'Material No'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.


  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MOVEMENTTYPE'.
  GS_FIELDCAT-SELTEXT_M = 'Movement Type'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MOVEMENTTEXT'.
  GS_FIELDCAT-SELTEXT_M = 'Movement Text'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'PLANT'.
  GS_FIELDCAT-SELTEXT_M = 'Plant'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'STORAGELOCATION'.
  GS_FIELDCAT-SELTEXT_M = 'Storage Location'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'QUANTITY'.
  GS_FIELDCAT-SELTEXT_M = 'Quantity'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'ALLOCATEDQTY'.
  GS_FIELDCAT-SELTEXT_M = 'UR Allocated Qty'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'ALLOCSOQTY'.
  GS_FIELDCAT-SELTEXT_M = 'SO Allocated Qty'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'ALLOCATEDAMOUNT'.
  GS_FIELDCAT-SELTEXT_M = 'UR Allocated Amount'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'SOAMOUNT'.
  GS_FIELDCAT-SELTEXT_M = 'SO Allocated Amount'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'POSTINGDATE'.
  GS_FIELDCAT-SELTEXT_M = 'Posting Date'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'AGEDAYS'.
  GS_FIELDCAT-SELTEXT_M = 'Age Days'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'PRODUCTDESCRIPTION'.
  GS_FIELDCAT-SELTEXT_M = 'Material Description'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'BASEUNIT'.
  GS_FIELDCAT-SELTEXT_M = 'Base Unit'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MATERIALDOCUMENTITEM'.
  GS_FIELDCAT-SELTEXT_M = 'Material Doc. Item'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MATERIALDOCUMENTYEAR'.
  GS_FIELDCAT-SELTEXT_M = 'Material Doc. Year'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'ALLOCATIONCATEGORY'.
  GS_FIELDCAT-SELTEXT_M = 'Allocation Category'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'RATEUSED'.
  GS_FIELDCAT-SELTEXT_M = 'Rate Used'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'USACODE'.
  GS_FIELDCAT-SELTEXT_M = 'USA Code'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'DOCUMENTDATE'.
  GS_FIELDCAT-SELTEXT_M = 'Document Date'.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  "------------------------------------------------------------
  " Layout (striped, optimize column width)
  "------------------------------------------------------------
  CLEAR GT_LAYOUT.
  GT_LAYOUT-ZEBRA              = 'X'.
  GT_LAYOUT-COLWIDTH_OPTIMIZE  = 'X'.

  "------------------------------------------------------------
  " Display ALV Grid
  "------------------------------------------------------------
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IS_LAYOUT          = GT_LAYOUT
      IT_FIELDCAT        = GT_FIELDCAT
    TABLES
      T_OUTTAB           = LT_OUT
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IT_DOWN
*&      --> P_FOLDER
*&      --> P_LGORT
*&---------------------------------------------------------------------*
FORM DOWNLOAD TABLES IT_DOWN USING P_FOLDER P_LGORT.
  TYPE-POOLS TRUXS.
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.


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
  CONCATENATE 'ZINVAG_DET_V1_' P_LGORT '_' S_WERKS-LOW '.TXT' INTO LV_FILE.
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE INTO LV_FULLFILE.

  WRITE: / 'ZINVAG_DET_V1 REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  IF SY-SUBRC = 0.
    DATA LV_STRING_944 TYPE STRING.
    DATA LV_CRLF_944 TYPE STRING.
    LV_CRLF_944 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_944 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_944 LV_CRLF_944 WA_CSV INTO LV_STRING_944.
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_944 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

  CONCATENATE 'ZINVAG_DET_V1_' P_LGORT '_' S_WERKS-LOW '.TXT' INTO LV_FILE.
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZINVAG_DET_V1 REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_981 TYPE STRING.
    DATA LV_CRLF_981 TYPE STRING.
    LV_CRLF_981 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_981 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_981 LV_CRLF_981 WA_CSV INTO LV_STRING_981.
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_981 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CVS_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE 'Document No'
            'Material No '
            'Movement Type '
            'Mov Type Desc'
            'Plant '
            'Storage Loc '
            'Quantity '
            'UR Allocated Quantity '
            'SO Allocated Quantity '
            'UR Amount '
            'SO Amount '
            'Posting Date '
            'Aging Day '
            'USA Code'
            'Document Date'
            'Refresh Date'
            'Material Description'
            INTO PD_CSV
            SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f4_help_storage_location
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F4_HELP_STORAGE_LOCATION .
  TYPES: BEGIN OF TY_LGORT,
           LGORT TYPE T001L-LGORT,
         END OF TY_LGORT.

  DATA: LT_LGORT  TYPE STANDARD TABLE OF TY_LGORT,
        LS_LGORT  TYPE TY_LGORT,
        LT_RETURN TYPE TABLE OF DDSHRETVAL,
        LS_RETURN TYPE DDSHRETVAL.


  DATA: LV_WERKS TYPE WERKS_D,
        LT_RET   TYPE TABLE OF DDSHRETVAL,
        SHLP     TYPE SHLP_DESCR,
        SHLP_TAB TYPE SHLP_DESCR_T,
        SELOPT   TYPE DDSHSELOPT,
        CALLC    TYPE DDSHF4CTRL,
        LV_DONE  TYPE ABAP_BOOL VALUE ABAP_FALSE.

  CLEAR: LT_LGORT,LT_RETURN.
  PERFORM RESOLVE_WERKS CHANGING S_WERKS-LOW."lv_werks.

  IF S_WERKS-LOW IS INITIAL.
    MESSAGE 'Please enter Plant first' TYPE 'I'.
  ENDIF.

  SELECT LGORT
    FROM T001L
    INTO TABLE LT_LGORT
    WHERE WERKS = S_WERKS-LOW.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE         = ' '
      RETFIELD    = 'LGORT'
*     PVALKEY     = ' '
      DYNPPROG    = SY-REPID
      DYNPNR      = SY-DYNNR
      DYNPROFIELD = 'P_LGORT '
*     STEPL       = 0
*     WINDOW_TITLE           =
*     VALUE       = ' '
      VALUE_ORG   = 'S'
*     MULTIPLE_CHOICE        = ' '
*     DISPLAY     = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM          = ' '
*     CALLBACK_METHOD        =
*     MARK_TAB    =
*    IMPORTING
*     USER_RESET  =
    TABLES
      VALUE_TAB   = LT_LGORT
 "    FIELD_TAB   =
      RETURN_TAB  = LT_RETURN
*     DYNPFLD_MAPPING        =
*    EXCEPTIONS
*     PARAMETER_ERROR        = 1
*     NO_VALUES_FOUND        = 2
*     OTHERS      = 3
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  READ TABLE LT_RETURN INTO LS_RETURN INDEX 1.
  IF SY-SUBRC = 0.
    P_LGORT = LS_RETURN-FIELDVAL.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form resolve_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_WERKS
*&---------------------------------------------------------------------*
FORM RESOLVE_WERKS CHANGING CV_WERKS TYPE WERKS_D.
  DATA(LV_TXT) = VALUE STRING( ).
  CLEAR CV_WERKS.

  PERFORM READ_SEL_FIELD USING 'S_WERKS-LOW' CHANGING LV_TXT.
  IF LV_TXT IS NOT INITIAL.
    CV_WERKS = CONV WERKS_D( LV_TXT ).
  ENDIF.

  IF CV_WERKS IS INITIAL AND S_WERKS-LOW IS NOT INITIAL.
    CV_WERKS = S_WERKS-LOW.
  ENDIF.

  IF CV_WERKS IS INITIAL.
    GET PARAMETER ID 'WRK' FIELD CV_WERKS.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_sel_field
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      <-- LV_TXT
*&---------------------------------------------------------------------*
FORM READ_SEL_FIELD USING    IV_FIELDNAME TYPE DYNFNAM
                    CHANGING CV_VALUE     TYPE STRING.

  DATA: LT_DYNP TYPE STANDARD TABLE OF DYNPREAD,
        LS_DYNP TYPE DYNPREAD.

  CLEAR CV_VALUE.
  CLEAR LT_DYNP.

  LS_DYNP-FIELDNAME = IV_FIELDNAME.
  LS_DYNP-STEPL     = 0.             " 0 for PARAMETERS / first row of SO
  APPEND LS_DYNP TO LT_DYNP.

  " Primary: selection screen (main prog + 1000)
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      DYNAME             = SY-CPROG
      DYNUMB             = '1000'
      TRANSLATE_TO_UPPER = 'X'
    TABLES
      DYNPFIELDS         = LT_DYNP
    EXCEPTIONS
      OTHERS             = 1.

  " Fallback: current include/dynpro (rarely needed)
  IF LT_DYNP IS INITIAL OR LT_DYNP[ 1 ]-FIELDVALUE IS INITIAL.
    CLEAR LT_DYNP.
    LS_DYNP-FIELDNAME = IV_FIELDNAME.
    LS_DYNP-STEPL     = 0.
    APPEND LS_DYNP TO LT_DYNP.

    CALL FUNCTION 'DYNP_VALUES_READ'
      EXPORTING
        DYNAME             = SY-REPID
        DYNUMB             = SY-DYNNR
        TRANSLATE_TO_UPPER = 'X'
      TABLES
        DYNPFIELDS         = LT_DYNP
      EXCEPTIONS
        OTHERS             = 1.
  ENDIF.

  READ TABLE LT_DYNP INTO LS_DYNP INDEX 1.
  IF SY-SUBRC = 0.
    CV_VALUE = LS_DYNP-FIELDVALUE.
  ENDIF.
ENDFORM.
