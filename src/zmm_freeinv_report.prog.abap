REPORT ZMM_FREEINV_REPORT NO STANDARD PAGE HEADING.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*
TABLES: MARA.


TYPES: BEGIN OF TY_OPEN,
         AUFNR TYPE AUFNR,
       END OF TY_OPEN.

TYPES: BEGIN OF TY_WIP,
         MATNR   TYPE MATNR,
         WIP_QTY TYPE MENGE_D,
       END OF TY_WIP.

DATA LT_WIP TYPE HASHED TABLE OF TY_WIP WITH UNIQUE KEY MATNR.
DATA LT_OPEN TYPE SORTED TABLE OF TY_OPEN WITH UNIQUE KEY AUFNR.

SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                S_MTART FOR MARA-MTART.

PARAMETERS: P_WERKS  TYPE WERKS_D OBLIGATORY,
            P_TREQFM TYPE ABAP_BOOL DEFAULT ABAP_TRUE NO-DISPLAY,
            P_DOWN   AS CHECKBOX,
            P_FILE   TYPE RLGRAP-FILENAME DEFAULT '/Delval/India'.

SELECTION-SCREEN: BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-010.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-011.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-012.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-013.
SELECTION-SCREEN: END OF BLOCK B3.

CONSTANTS: C_LANG TYPE SPRAS VALUE 'E'.
TYPES: BEGIN OF TY_OUT,
         WERKS       TYPE WERKS_D,
         MATNR       TYPE MATNR,
         MAKTX       TYPE MAKTX,
         MEINS       TYPE MEINS,
         MINBM       TYPE MINBM,
         TOTREQ      TYPE MENGE_D,
         TOTSTCK     TYPE MENGE_D,
         TOTSTCK_VAL TYPE STPRS,
         WIP_QTY     TYPE MENGE_D,
         WIP_VAL     TYPE STPRS,
         QA_QTY      TYPE MENGE_D,
         QA_VAL      TYPE STPRS,
         SBCN_QTY    TYPE MENGE_D,
         SBCN_VAL    TYPE STPRS,
         FREE_QTY    TYPE MENGE_D,
         FREE_VAL    TYPE STPRS,
         ZRATE       TYPE VERPR,
         INSME       TYPE INSME,
         MTART       TYPE MTART,
       END OF TY_OUT.

DATA: GT_BASE TYPE STANDARD TABLE OF TY_OUT WITH DEFAULT KEY,
      GT_OUT  TYPE STANDARD TABLE OF TY_OUT WITH DEFAULT KEY.

" Download ITAB (same as your original)
TYPES: BEGIN OF ITAB,
         PLANT                   TYPE STRING,
         MATERIAL                TYPE STRING,
         MATERIAL_DESCRIPTION    TYPE STRING,
         UNIT                    TYPE STRING,
         MINIMUM_ORDER_QTY       TYPE STRING,
         TOTAL_REQUIREMENT       TYPE STRING,
         TOTAL_STOCK_QTY         TYPE STRING,
         TOTAL_STOCK_VALUE       TYPE STRING,
         WIP_QTY                 TYPE STRING,
         WIP_VALUE               TYPE STRING,
         QA_STOCK_QTY            TYPE STRING,
         QA_STOCK_VALUE          TYPE STRING,
         SUBCONTRACT_STOCK_QTY   TYPE STRING,
         SUBCONTRACT_STOCK_VALUE TYPE STRING,
         FREE_STOCK_QTY          TYPE STRING,
         FREE_STOCK_VALUE        TYPE STRING,
         MTART                   TYPE STRING,
         REF                     TYPE CHAR15,
         TIME                    TYPE CHAR15,
       END OF ITAB.

DATA: LT_FINAL TYPE TABLE OF ITAB,
      LS_FINAL TYPE ITAB.

*---------------------------------------------------------------------*
* Main
*---------------------------------------------------------------------*
START-OF-SELECTION.

  " Keep original behavior: always exclude UNBW
  S_MTART-SIGN   = 'I'.
  S_MTART-OPTION = 'NE'.
  S_MTART-LOW    = 'UNBW'.
  APPEND S_MTART.

  PERFORM FETCH_FROM_TF.
  IF GT_BASE IS INITIAL.
    MESSAGE 'No materials for plant/filters' TYPE 'S'.
    RETURN.
  ENDIF.

  PERFORM COMPUTE_TOTREQ_AND_FREE.

  IF P_DOWN = ABAP_TRUE.
    PERFORM DOWNLOAD_FILE.
  ELSE.
    PERFORM DISPLAY_SALV.
  ENDIF.

*---------------------------------------------------------------------*
* Fetch from Table Function ZTF_MM_FREEINV_REPORT
* IMPORTANT: DO NOT pass p_clnt (it is filled by compiler due to #CLIENT)
*---------------------------------------------------------------------*
FORM FETCH_FROM_TF.
  CLEAR GT_BASE.

  IF S_MATNR[] IS INITIAL AND S_MTART[] IS INITIAL.
    SELECT WERKS,
           MATNR,
           MAKTX,
           MEINS,
           MINBM,
           TOTREQ,
           TOTSTCK,
           TOTSTCK_VAL,
           WIP_QTY,
           WIP_VAL,
           QA_QTY,
           QA_VAL,
           SBCN_QTY,
           SBCN_VAL,
           FREE_QTY,
           FREE_VAL,
           ZRATE,
           INSME,
           MTART
      FROM ZTF_MM_FREEINV_REPORT(
          P_WERKS = @P_WERKS,
          P_LANGU = @C_LANG )
      INTO TABLE @GT_BASE.

  ELSEIF S_MATNR[] IS INITIAL.

    SELECT WERKS,
           MATNR,
           MAKTX,
           MEINS,
           MINBM,
           TOTREQ,
           TOTSTCK,
           TOTSTCK_VAL,
           WIP_QTY,
           WIP_VAL,
           QA_QTY,
           QA_VAL,
           SBCN_QTY,
           SBCN_VAL,
           FREE_QTY,
           FREE_VAL,
           ZRATE,
           INSME,
           MTART
      FROM ZTF_MM_FREEINV_REPORT(
          P_WERKS = @P_WERKS,
          P_LANGU = @C_LANG )
      WHERE MTART IN @S_MTART
      INTO TABLE @GT_BASE.

  ELSEIF S_MTART[] IS INITIAL.

    SELECT WERKS,
           MATNR,
           MAKTX,
           MEINS,
           MINBM,
           TOTREQ,
           TOTSTCK,
           TOTSTCK_VAL,
           WIP_QTY,
           WIP_VAL,
           QA_QTY,
           QA_VAL,
           SBCN_QTY,
           SBCN_VAL,
           FREE_QTY,
           FREE_VAL,
           ZRATE,
           INSME,
           MTART
      FROM ZTF_MM_FREEINV_REPORT(
          P_WERKS = @P_WERKS,
          P_LANGU = @C_LANG )
      WHERE MATNR IN @S_MATNR
      INTO TABLE @GT_BASE.

  ELSE.

    SELECT WERKS,
           MATNR,
           MAKTX,
           MEINS,
           MINBM,
           TOTREQ,
           TOTSTCK,
           TOTSTCK_VAL,
           WIP_QTY,
           WIP_VAL,
           QA_QTY,
           QA_VAL,
           SBCN_QTY,
           SBCN_VAL,
           FREE_QTY,
           FREE_VAL,
           ZRATE,
           INSME,
           MTART
      FROM ZTF_MM_FREEINV_REPORT(
           P_WERKS = @P_WERKS,
           P_LANGU = @C_LANG )
      WHERE MATNR IN @S_MATNR
        AND MTART IN @S_MTART
      INTO TABLE @GT_BASE.

  ENDIF.

  SELECT DISTINCT A~AUFNR
    FROM AFPO AS A
    INNER JOIN AUFK AS B
    ON A~AUFNR = B~AUFNR
    WHERE A~PWERK = @P_WERKS
      AND A~WEMNG < A~PSMNG
      AND B~IDAT2 IS INITIAL
    INTO TABLE @LT_OPEN.

  IF LT_OPEN IS NOT INITIAL.
    SELECT
      M~MATNR,
      SUM(
        CASE M~BWART
          WHEN '261' THEN  M~MENGE
          WHEN '262' THEN -M~MENGE
          ELSE 0
        END
      ) AS WIP_QTY
      FROM AUFM AS M
      INNER JOIN @LT_OPEN AS O
        ON O~AUFNR = M~AUFNR
      WHERE M~WERKS = @P_WERKS
        AND M~BWART IN ('261','262')
        AND M~MATNR IS NOT NULL
        AND M~MATNR IN @S_MATNR          "or IN @lt_matnr if you have lt_mat list
      GROUP BY M~MATNR
      HAVING SUM(
        CASE M~BWART
          WHEN '261' THEN  M~MENGE
          WHEN '262' THEN -M~MENGE
          ELSE 0
        END
      ) > 0
      INTO TABLE @LT_WIP.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
* Compute TOTREQ and FREE_* (same as your original ABAP)
*---------------------------------------------------------------------*
FORM COMPUTE_TOTREQ_AND_FREE.
  DATA: LS_OUT   TYPE TY_OUT,
        LV_FRINV TYPE MENGE_D.

  CLEAR: GT_OUT, LT_FINAL.

  LOOP AT GT_BASE INTO LS_OUT.

    IF ( LS_OUT-TOTSTCK + LS_OUT-WIP_QTY + LS_OUT-QA_QTY + LS_OUT-SBCN_QTY ) <= 0.
      CONTINUE.
    ENDIF.

    CLEAR LS_OUT-TOTREQ.

    " Requirements (unchanged)
    IF P_TREQFM = ABAP_TRUE AND LS_OUT-TOTSTCK > 0.
      DATA LT_MDPS TYPE TABLE OF MDPS.
      DATA LS_MDPS TYPE MDPS.

      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          MATNR = LS_OUT-MATNR
          WERKS = P_WERKS
        TABLES
          MDPSX = LT_MDPS.

      IF LT_MDPS IS NOT INITIAL.
        LOOP AT LT_MDPS INTO LS_MDPS.
          IF LS_MDPS-DELKZ = 'VC' OR LS_MDPS-DELKZ = 'SB'
           OR LS_MDPS-DELKZ = 'U1' OR LS_MDPS-DELKZ = 'U2'
           OR LS_MDPS-DELKZ = 'PP'
           OR ( LS_MDPS-DELKZ = 'BB' AND LS_MDPS-PLAAB <> 26 )
           OR ( LS_MDPS-DELKZ = 'AR' AND LS_MDPS-PLUMI <> '+' )
           OR ( LS_MDPS-DELKZ = 'KB' AND LS_MDPS-PLUMI <> 'B' ).
            LS_OUT-TOTREQ = LS_OUT-TOTREQ + LS_MDPS-MNG01.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    " Free inventory (unchanged)
    LV_FRINV = ( LS_OUT-TOTSTCK + LS_OUT-WIP_QTY + LS_OUT-QA_QTY + LS_OUT-SBCN_QTY ) - LS_OUT-TOTREQ.
    IF LV_FRINV < 0.
      LV_FRINV = 0.
    ENDIF.

    LS_OUT-FREE_QTY = LV_FRINV.
    LS_OUT-FREE_VAL = LS_OUT-FREE_QTY * LS_OUT-ZRATE.

    " Keep original filter
    IF LS_OUT-FREE_QTY <> 0.

      APPEND LS_OUT TO GT_OUT.

      " Download row mapping (same)
      CLEAR LS_FINAL.
      LS_FINAL-PLANT                   = |{ LS_OUT-WERKS }|.
      LS_FINAL-MATERIAL                = |{ LS_OUT-MATNR }|.
      LS_FINAL-MATERIAL_DESCRIPTION    = |{ LS_OUT-MAKTX }|.
      LS_FINAL-UNIT                    = |{ LS_OUT-MEINS }|.
      LS_FINAL-MINIMUM_ORDER_QTY       = |{ LS_OUT-MINBM }|.
      LS_FINAL-TOTAL_REQUIREMENT       = |{ LS_OUT-TOTREQ }|.
      LS_FINAL-TOTAL_STOCK_QTY         = |{ LS_OUT-TOTSTCK }|.
      LS_FINAL-TOTAL_STOCK_VALUE       = |{ LS_OUT-TOTSTCK_VAL }|.
      LS_FINAL-WIP_QTY                 = |{ LS_OUT-WIP_QTY }|.
      LS_FINAL-WIP_VALUE               = |{ LS_OUT-WIP_VAL }|.
      LS_FINAL-QA_STOCK_QTY            = |{ LS_OUT-QA_QTY }|.
      LS_FINAL-QA_STOCK_VALUE          = |{ LS_OUT-QA_VAL }|.
      LS_FINAL-SUBCONTRACT_STOCK_QTY   = |{ LS_OUT-SBCN_QTY }|.
      LS_FINAL-SUBCONTRACT_STOCK_VALUE = |{ LS_OUT-SBCN_VAL }|.
      LS_FINAL-FREE_STOCK_QTY          = |{ LS_OUT-FREE_QTY }|.
      LS_FINAL-FREE_STOCK_VALUE        = |{ LS_OUT-FREE_VAL }|.
      LS_FINAL-MTART                   = |{ LS_OUT-MTART }|.

      " Refresh date & time
      LS_FINAL-REF = SY-DATUM.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = LS_FINAL-REF
        IMPORTING
          OUTPUT = LS_FINAL-REF.

      CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
        INTO LS_FINAL-REF SEPARATED BY '-'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = LS_FINAL-REF.

      CONCATENATE LS_FINAL-REF+0(2) LS_FINAL-REF+2(3) LS_FINAL-REF+5(4)
        INTO LS_FINAL-REF SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) SY-UZEIT+2(2) INTO LS_FINAL-TIME SEPARATED BY ':'.

      APPEND LS_FINAL TO LT_FINAL.

    ENDIF.

  ENDLOOP.

ENDFORM.

*---------------------------------------------------------------------*
* Display SALV
*---------------------------------------------------------------------*
FORM DISPLAY_SALV.
  DATA LO_ALV   TYPE REF TO CL_SALV_TABLE.
  DATA LO_COLS  TYPE REF TO CL_SALV_COLUMNS_TABLE.
  DATA LO_FUNCS TYPE REF TO CL_SALV_FUNCTIONS_LIST.

  IF GT_OUT IS INITIAL.
    MESSAGE 'No output rows (FREE_QTY is 0 for all materials)' TYPE 'S'.
    RETURN.
  ENDIF.

  TRY.
      CL_SALV_TABLE=>FACTORY(
        IMPORTING R_SALV_TABLE = LO_ALV
        CHANGING  T_TABLE      = GT_OUT ).

      LO_FUNCS = LO_ALV->GET_FUNCTIONS( ).
      LO_FUNCS->SET_ALL( ABAP_TRUE ).

      LO_ALV->GET_COLUMNS( )->SET_OPTIMIZE( ABAP_FALSE ).
      LO_COLS = LO_ALV->GET_COLUMNS( ).

      PERFORM SET_COL USING LO_COLS 'WERKS'       'Plant'.
      PERFORM SET_COL USING LO_COLS 'MATNR'       'Material'.
      PERFORM SET_COL USING LO_COLS 'MAKTX'       'Material Description'.
      PERFORM SET_COL USING LO_COLS 'MEINS'       'Unit'.
      PERFORM SET_COL USING LO_COLS 'MINBM'       'Minimum Order Qty'.
      PERFORM SET_COL USING LO_COLS 'TOTREQ'      'Total Requirement'.
      PERFORM SET_COL USING LO_COLS 'TOTSTCK'     'Total Stock Quantity'.
      PERFORM SET_COL USING LO_COLS 'TOTSTCK_VAL' 'Total Stock Value'.
      PERFORM SET_COL USING LO_COLS 'WIP_QTY'     'WIP Quantity'.
      PERFORM SET_COL USING LO_COLS 'WIP_VAL'     'WIP Value'.
      PERFORM SET_COL USING LO_COLS 'QA_QTY'      'QA Stock Quantity'.
      PERFORM SET_COL USING LO_COLS 'QA_VAL'      'QA Stock Value'.
      PERFORM SET_COL USING LO_COLS 'SBCN_QTY'    'SubContract Stock Quantity'.
      PERFORM SET_COL USING LO_COLS 'SBCN_VAL'    'SubContract Stock Value'.
      PERFORM SET_COL USING LO_COLS 'FREE_QTY'    'Free Stock Quantity'.
      PERFORM SET_COL USING LO_COLS 'FREE_VAL'    'Free Stock Value'.

      " Hide helpers
      TRY. LO_COLS->GET_COLUMN( 'ZRATE' )->SET_VISIBLE( ABAP_FALSE ). CATCH CX_SALV_NOT_FOUND. ENDTRY.
      TRY. LO_COLS->GET_COLUMN( 'INSME' )->SET_VISIBLE( ABAP_FALSE ). CATCH CX_SALV_NOT_FOUND. ENDTRY.

      LO_ALV->DISPLAY( ).
    CATCH CX_SALV_MSG.
  ENDTRY.
ENDFORM.

FORM SET_COL USING IO_COLS TYPE REF TO CL_SALV_COLUMNS_TABLE
                   IV_NAME TYPE LVC_FNAME
                   IV_TEXT TYPE CSEQUENCE.
  DATA LO_C TYPE REF TO CL_SALV_COLUMN_TABLE.
  DATA LV_S TYPE SCRTEXT_S.
  DATA LV_M TYPE SCRTEXT_M.
  DATA LV_L TYPE SCRTEXT_L.

  LV_L = IV_TEXT.
  LV_M = IV_TEXT.
  LV_S = IV_TEXT.

  TRY.
      LO_C ?= IO_COLS->GET_COLUMN( IV_NAME ).
      LO_C->SET_SHORT_TEXT(  LV_S ).
      LO_C->SET_MEDIUM_TEXT( LV_M ).
      LO_C->SET_LONG_TEXT(   LV_L ).
      LO_C->SET_VISIBLE( ABAP_TRUE ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
ENDFORM.

*---------------------------------------------------------------------*
* Download (tab-separated)
*---------------------------------------------------------------------*
FORM DOWNLOAD_FILE.
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  REFRESH IT_CSV.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    EXPORTING
      I_FIELD_SEPERATOR    = 'X'
    TABLES
      I_TAB_SAP_DATA       = LT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.

  DATA: LV_FILE     TYPE STRING,
        LV_FULLFILE TYPE STRING.

  PERFORM CVS_HEADER USING HD_CSV.
  LV_FILE = 'ZMM_FREEINV_REPORT.TXT'.
  CONCATENATE P_FILE '/' LV_FILE INTO LV_FULLFILE.

  OPEN DATASET LV_FULLFILE FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF SY-SUBRC = 0.
    DATA LV_CRLF TYPE STRING.
    DATA LV_STR  TYPE STRING.
    LV_CRLF = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STR  = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STR LV_CRLF WA_CSV INTO LV_STR.
      CLEAR WA_CSV.
    ENDLOOP.
    TRANSFER LV_STR TO LV_FULLFILE.
    CLOSE DATASET LV_FULLFILE.
    MESSAGE |File { LV_FULLFILE } downloaded| TYPE 'S'.
  ELSE.
    MESSAGE 'Cannot open file for output' TYPE 'E'.
  ENDIF.
ENDFORM.

FORM CVS_HEADER USING P_HD_CSV.
  DATA L_TAB TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE
    'Plant'
    'Material'
    'Material Description'
    'Unit'
    'Minimum Order Qty'
    'Total Requirement'
    'Total Stock Quantity'
    'Total Stock Value'
    'WIP Quantity'
    'WIP Value'
    'QA Stock Quantity'
    'QA Stock Value'
    'SubContract Stock Quantity'
    'SubContract Stock Value'
    'Free Stock Quantity'
    'Free Stock Value'
    'Material Type'
    'Refresh Date'
    'Refreshable Time'
    INTO P_HD_CSV SEPARATED BY L_TAB.
ENDFORM.
