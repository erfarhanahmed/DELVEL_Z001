REPORT ZMM_INVENTORY_NEWV2 NO STANDARD PAGE HEADING.

*---------------------------------------------------------------------*
* Selection
*---------------------------------------------------------------------*
TABLES: MARA.

SELECT-OPTIONS: S_MATNR FOR MARA-MATNR,
                S_MTART FOR MARA-MTART.

PARAMETERS: P_WERKS  TYPE WERKS_D OBLIGATORY,
            P_TREQFM TYPE ABAP_BOOL DEFAULT ABAP_TRUE NO-DISPLAY,
            P_DOWN   AS CHECKBOX,
            P_FILE   TYPE RLGRAP-FILENAME DEFAULT '/Delval/India'.

" Retained for compatibility (not used in WIP after this update)
*DATA gv_lgort TYPE lgort_d.
*SELECT-OPTIONS: s_wiplg FOR gv_lgort NO INTERVALS.

SELECTION-SCREEN: BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-010.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-011.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-012.
  SELECTION-SCREEN  COMMENT /1(79) TEXT-013.
SELECTION-SCREEN: END OF BLOCK B3.

CONSTANTS: C_LANG TYPE SPRAS VALUE 'E'.

*---------------------------------------------------------------------*
* Exclusions / Ranges
*---------------------------------------------------------------------*
TYPES: R_LGORT TYPE RANGE OF LGORT_D.
DATA:  GR_EXCL_LGORT TYPE R_LGORT.

TYPES: R_MTART TYPE RANGE OF MTART.
DATA:  gr_excl_mTART TYPE R_MTART.

INITIALIZATION.
  " Default SLocs kept only for backward compatibility display
*  s_wiplg-sign = 'I'. s_wiplg-option = 'EQ'.
*  s_wiplg-low  = 'PRD1'. APPEND s_wiplg.
*  s_wiplg-low  = 'SFG1'. APPEND s_wiplg.
*  s_wiplg-low  = 'RWK1'. APPEND s_wiplg.
*  s_wiplg-low  = 'KPRD'. APPEND s_wiplg.
*  s_wiplg-low  = 'KSFG'. APPEND s_wiplg.
*  s_wiplg-low  = 'KRWK'. APPEND s_wiplg.

  GR_EXCL_LGORT = VALUE R_LGORT(
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'RJ01' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'SCR1' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'SRN1' )
    "( sign = 'I' option = 'EQ' low = 'VLD1' )
    "( sign = 'I' option = 'EQ' low = 'SLR1' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'SPC1' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'KRJ0' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'KSCR' )
    ( SIGN = 'I' OPTION = 'EQ' LOW = 'KSRN' )
    "( sign = 'I' option = 'EQ' low = 'KVLD' )
    "( sign = 'I' option = 'EQ' low = 'KSLR' )
    ).


*---------------------------------------------------------------------*
* Types / Data (16 fields + helpers)
*---------------------------------------------------------------------*
  TYPES: BEGIN OF TY_MAT,
           MATNR TYPE MATNR,
           MEINS TYPE MEINS,
           MTART TYPE MTART,
           MAKTX TYPE MAKTX,
           WERKS TYPE WERKS,
           LGORT TYPE LGORT_D,
           VBELN TYPE VBELN,
           POSNR TYPE POSNR,
         END OF TY_MAT.
  DATA: GT_MAT TYPE SORTED TABLE OF TY_MAT WITH UNIQUE KEY MATNR.

  TYPES: BEGIN OF TY_MARC, MATNR TYPE MATNR, EISBE TYPE EISBE, END OF TY_MARC.
  DATA: GT_MARC TYPE SORTED TABLE OF TY_MARC WITH UNIQUE KEY MATNR.

  TYPES: BEGIN OF TY_MBEW, MATNR TYPE MATNR, VPRSV TYPE VPRSV, VERPR TYPE VERPR, STPRS TYPE STPRS, END OF TY_MBEW.
  DATA: GT_MBEW TYPE TABLE OF TY_MBEW.

  TYPES: BEGIN OF TY_MOQ, MATNR TYPE MATNR, MINBM TYPE MINBM, END OF TY_MOQ.
  DATA: GT_MOQ TYPE SORTED TABLE OF TY_MOQ WITH UNIQUE KEY MATNR.

  TYPES: BEGIN OF TY_MSLB, MATNR TYPE MATNR, SBCNTR TYPE LABST, END OF TY_MSLB.
  DATA: GT_MSLB TYPE SORTED TABLE OF TY_MSLB WITH UNIQUE KEY MATNR.

  " Aggregate own & special stock (for totals, QA etc.)
  TYPES: BEGIN OF TY_MARD_SUM, MATNR TYPE MATNR, LGORT TYPE LGORT_D, LABST TYPE LABST, INSME TYPE INSME, END OF TY_MARD_SUM.
  DATA:  GT_MARD_SUM TYPE STANDARD TABLE OF TY_MARD_SUM WITH DEFAULT KEY.
  TYPES: BEGIN OF TY_MSKA_SUM,
           MATNR TYPE MATNR,
           WERKS TYPE WERKS_D,
           LGORT TYPE LGORT_D,
           VBELN TYPE VBELN,
           POSNR TYPE POSNR,
           KALAB TYPE LABST,
           KAINS TYPE INSME,
         END OF TY_MSKA_SUM.
  DATA:  GT_MSKA_SUM TYPE STANDARD TABLE OF TY_MSKA_SUM WITH DEFAULT KEY.
  DATA:  gt_EBEW TYPE STANDARD TABLE OF EBEW.

  " Open orders & WIP (components issued net of 262)
  TYPES: BEGIN OF TY_AUFNR, AUFNR TYPE AUFNR, END OF TY_AUFNR.
  DATA:  GT_OPEN_ORD TYPE SORTED TABLE OF TY_AUFNR WITH UNIQUE KEY AUFNR.

  " WIP per component (net result)
  TYPES: BEGIN OF TY_WIP, MATNR TYPE MATNR, QTY TYPE MENGE_D, END OF TY_WIP.
  DATA:  GT_WIP_SUM TYPE SORTED TABLE OF TY_WIP WITH UNIQUE KEY MATNR.

  " Helpers to hold 261 and 262 sums separately (explicit, no @DATA inline)
  TYPES: BEGIN OF TY_SUM, MATNR TYPE MATNR, QTY TYPE MENGE_D, END OF TY_SUM.
  DATA: LT_WIP261 TYPE SORTED TABLE OF TY_SUM WITH UNIQUE KEY MATNR.
  DATA: LT_WIP262 TYPE SORTED TABLE OF TY_SUM WITH UNIQUE KEY MATNR.

  " ==== OUTPUT (16 fields) + helpers ====
  TYPES: BEGIN OF TY_OUT,
           WERKS       TYPE WERKS_D,
           MATNR       TYPE MATNR,
           MAKTX       TYPE MAKTX,
           MEINS       TYPE MEINS,
           MINBM       TYPE MINBM,
           TOTREQ      TYPE MENGE_D,
           TOTSTCK     TYPE MENGE_D,
           TOTSTCK_VAL TYPE STPRS,
           WIP_QTY     TYPE MENGE_D,   " 261-262 net issues to open orders
           WIP_VAL     TYPE STPRS,
           QA_QTY      TYPE MENGE_D,
           QA_VAL      TYPE STPRS,
           SBCN_QTY    TYPE MENGE_D,
           SBCN_VAL    TYPE STPRS,
           FREE_QTY    TYPE MENGE_D,
           FREE_VAL    TYPE STPRS,
           " helpers (hidden)
           ZRATE       TYPE VERPR,
           ZSORATE     TYPE VERPR,
           INSME       TYPE INSME,
           MTART       TYPE MTART,
         END OF TY_OUT.
  DATA: GT_OUT TYPE STANDARD TABLE OF TY_OUT WITH DEFAULT KEY.

  " Download ITAB (exact 16 strings)
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
  S_MTART-SIGN =  'I' .
  S_MTART-OPTION = 'NE'.
  S_MTART-LOW = 'UNBW'.
  APPEND S_MTART.


  PERFORM FETCH_MATERIALS.
  IF GT_MAT IS INITIAL.
    MESSAGE 'No materials for plant/filters' TYPE 'S'. RETURN.
  ENDIF.

  PERFORM FETCH_MARC.
  PERFORM FETCH_MBEW.
  PERFORM FETCH_MOQ.
  PERFORM FETCH_MSLB.
  PERFORM FETCH_MARD_AGG.
  PERFORM FETCH_MSKA_AGG.

  " Open orders & WIP-from-components via 261-262
  PERFORM FETCH_OPEN_ORDERS.
  PERFORM FETCH_WIP_FROM_AUFM.

  PERFORM ASSEMBLE_ROWS.

  IF P_DOWN = ABAP_TRUE.
    PERFORM DOWNLOAD_FILE.
  ELSE.
    PERFORM DISPLAY_SALV.
  ENDIF.

*---------------------------------------------------------------------*
* Fetch materials (+ text)
*---------------------------------------------------------------------*
FORM FETCH_MATERIALS.
  DATA LT_MAT TYPE STANDARD TABLE OF TY_MAT.

  IF S_MATNR IS INITIAL AND S_MTART IS INITIAL.
    SELECT A~MATNR, A~MEINS, A~MTART, B~MAKTX
      FROM MARA AS A
      INNER JOIN MARC AS C ON C~MATNR = A~MATNR AND C~WERKS = @P_WERKS
      LEFT OUTER JOIN MAKT AS B ON B~MATNR = A~MATNR AND B~SPRAS = @C_LANG
      INTO TABLE @LT_MAT.
  ELSEIF S_MATNR IS INITIAL.
    SELECT A~MATNR, A~MEINS, A~MTART, B~MAKTX
      FROM MARA AS A
      INNER JOIN MARC AS C ON C~MATNR = A~MATNR AND C~WERKS = @P_WERKS
      LEFT OUTER JOIN MAKT AS B ON B~MATNR = A~MATNR AND B~SPRAS = @C_LANG
      INTO TABLE @LT_MAT
      WHERE A~MTART IN @S_MTART.
  ELSEIF S_MTART IS INITIAL.
    SELECT A~MATNR, A~MEINS, A~MTART, B~MAKTX
      FROM MARA AS A
      INNER JOIN MARC AS C ON C~MATNR = A~MATNR AND C~WERKS = @P_WERKS
      LEFT OUTER JOIN MAKT AS B ON B~MATNR = A~MATNR AND B~SPRAS = @C_LANG
      INTO TABLE @LT_MAT
      WHERE A~MATNR IN @S_MATNR.
  ELSE.
    SELECT A~MATNR, A~MEINS, A~MTART, B~MAKTX
      FROM MARA AS A
      INNER JOIN MARC AS C ON C~MATNR = A~MATNR AND C~WERKS = @P_WERKS
      LEFT OUTER JOIN MAKT AS B ON B~MATNR = A~MATNR AND B~SPRAS = @C_LANG
      INTO TABLE @LT_MAT
      WHERE A~MATNR IN @S_MATNR
        AND A~MTART IN @S_MTART.
  ENDIF.

  SORT LT_MAT BY MATNR.
  DELETE ADJACENT DUPLICATES FROM LT_MAT COMPARING MATNR.
  GT_MAT = LT_MAT.
ENDFORM.

FORM FETCH_MARC.
  IF S_MATNR IS INITIAL.
    SELECT MATNR, EISBE
      FROM MARC
      INTO TABLE @GT_MARC
      WHERE WERKS = @P_WERKS.
  ELSE.
    SELECT MATNR, EISBE
      FROM MARC
      INTO TABLE @GT_MARC
      WHERE WERKS = @P_WERKS
        AND MATNR IN @S_MATNR.
  ENDIF.
ENDFORM.

FORM FETCH_MBEW.
  IF S_MATNR IS INITIAL.
    SELECT MATNR, VPRSV, VERPR, STPRS
      FROM MBEW
      INTO TABLE @GT_MBEW
      WHERE BWKEY = @P_WERKS.
  ELSE.
    SELECT MATNR, VPRSV, VERPR, STPRS
      FROM MBEW
      INTO TABLE @GT_MBEW
      WHERE BWKEY = @P_WERKS
        AND MATNR IN @S_MATNR.
  ENDIF.
ENDFORM.

FORM FETCH_MOQ.
  IF S_MATNR IS INITIAL.
    SELECT EINA~MATNR AS MATNR, MAX( EINE~MINBM ) AS MINBM
      FROM EINE
      INNER JOIN EINA ON EINA~INFNR = EINE~INFNR
      GROUP BY EINA~MATNR
      INTO TABLE @GT_MOQ.
  ELSE.
    SELECT EINA~MATNR AS MATNR, MAX( EINE~MINBM ) AS MINBM
      FROM EINE
      INNER JOIN EINA ON EINA~INFNR = EINE~INFNR
      WHERE EINA~MATNR IN @S_MATNR
      GROUP BY EINA~MATNR
      INTO TABLE @GT_MOQ.
  ENDIF.
ENDFORM.

FORM FETCH_MSLB.
  IF S_MATNR IS INITIAL.
    SELECT MATNR, SUM( LBLAB ) AS SBCNTR
      FROM MSLB
      WHERE WERKS = @P_WERKS
      GROUP BY MATNR
      INTO TABLE @GT_MSLB.
  ELSE.
    SELECT MATNR, SUM( LBLAB ) AS SBCNTR
      FROM MSLB
      WHERE WERKS = @P_WERKS
        AND MATNR IN @S_MATNR
      GROUP BY MATNR
      INTO TABLE @GT_MSLB.
  ENDIF.
ENDFORM.

FORM FETCH_MARD_AGG.
  IF S_MATNR IS INITIAL.
    SELECT MATNR, LGORT,
           SUM( LABST ) AS LABST,
           SUM( INSME ) AS INSME
      FROM MARD
      WHERE WERKS = @P_WERKS
        AND DISKZ <> '1'
        AND LGORT NOT IN @GR_EXCL_LGORT
      GROUP BY MATNR, LGORT
      INTO TABLE @GT_MARD_SUM.
  ELSE.
    SELECT MATNR, LGORT,
           SUM( LABST ) AS LABST,
           SUM( INSME ) AS INSME
      FROM MARD
      WHERE WERKS = @P_WERKS
        AND MATNR IN @S_MATNR
        AND DISKZ <> '1'
        AND LGORT NOT IN @GR_EXCL_LGORT
      GROUP BY MATNR, LGORT
      INTO TABLE @GT_MARD_SUM.
  ENDIF.
ENDFORM.

FORM FETCH_MSKA_AGG.
  IF S_MATNR IS INITIAL.
    SELECT MATNR,
           WERKS,
           LGORT,
           VBELN,
           POSNR,
           KALAB,
           KAINS
      FROM MSKA
      WHERE WERKS = @P_WERKS
        AND LGORT NOT IN @GR_EXCL_LGORT
      INTO TABLE @GT_MSKA_SUM.
  ELSE.
    SELECT MATNR,
           WERKS,
           LGORT,
           VBELN,
           POSNR,
           KALAB,
           KAINS
      FROM MSKA
      WHERE WERKS = @P_WERKS
        AND MATNR IN @S_MATNR
        AND LGORT NOT IN @GR_EXCL_LGORT
      INTO TABLE @GT_MSKA_SUM.
  ENDIF.

  IF GT_MSKA_SUM IS NOT INITIAL.
    SELECT * FROM EBEW
             INTO TABLE GT_EBEW
             FOR ALL ENTRIES IN GT_MSKA_SUM
             WHERE MATNR = GT_MSKA_SUM-MATNR AND
                   BWKEY = GT_MSKA_SUM-WERKS AND
                   VBELN = GT_MSKA_SUM-VBELN AND
                   POSNR = GT_MSKA_SUM-POSNR.

  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
* Open production orders (ABAP-side filter: wemng < psmng)
*---------------------------------------------------------------------*
FORM FETCH_OPEN_ORDERS.
  TYPES: BEGIN OF TY_AFPO,
           AUFNR TYPE AFPO-AUFNR,
           WERKS TYPE AFPO-PWERK,
           WEMNG TYPE AFPO-WEMNG,
           PSMNG TYPE AFPO-PSMNG,
         END OF TY_AFPO.
  DATA: LT_AFPO TYPE STANDARD TABLE OF TY_AFPO,
        LS_AFPO TYPE TY_AFPO.

  CLEAR GT_OPEN_ORD.

  SELECT A~AUFNR,
         A~PWERK,
         A~WEMNG,
         A~PSMNG
    FROM AFPO AS A
    INNER JOIN AUFK AS B
    ON A~AUFNR = B~AUFNR
    WHERE A~PWERK = @P_WERKS AND
          B~IDAT2 IS INITIAL
    INTO TABLE @LT_AFPO.

  LOOP AT LT_AFPO INTO LS_AFPO.
    IF LS_AFPO-WEMNG < LS_AFPO-PSMNG.
      INSERT VALUE #( AUFNR = LS_AFPO-AUFNR ) INTO TABLE GT_OPEN_ORD.
    ENDIF.
  ENDLOOP.
  " Do NOT SORT here; gt_open_ord is a SORTED TABLE already.
ENDFORM.


*---------------------------------------------------------------------*
* WIP from issued components (AUFM): net = SUM(261) - SUM(262)
* No GROUP BY (aggregate in ABAP for broader compatibility)
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* WIP from issued components (AUFM): net = SUM(261) - SUM(262)
* No GROUP BY and no WITH ... syntax — aggregate via COLLECT
*---------------------------------------------------------------------*
FORM FETCH_WIP_FROM_AUFM.
  DATA: LT_OPEN_AUFNR TYPE STANDARD TABLE OF AUFNR,
        LV_AUFNR      TYPE AUFNR.

  CLEAR GT_WIP_SUM.
  IF GT_OPEN_ORD IS INITIAL.
    RETURN.
  ENDIF.

  " Build AUFNR list for FOR ALL ENTRIES
  LOOP AT GT_OPEN_ORD INTO DATA(LS_O).
    LV_AUFNR = LS_O-AUFNR.
    APPEND LV_AUFNR TO LT_OPEN_AUFNR.
  ENDLOOP.
  IF LT_OPEN_AUFNR IS INITIAL.
    RETURN.
  ENDIF.

  " Raw movements (no GROUP BY)
  TYPES: BEGIN OF TY_AUFM_ROW,
           MATNR TYPE AUFM-MATNR,
           MENGE TYPE AUFM-MENGE,
           BWART TYPE AUFM-BWART,
           AUFNR TYPE AUFM-AUFNR,
         END OF TY_AUFM_ROW.
  DATA: LT_AUFM TYPE STANDARD TABLE OF TY_AUFM_ROW,
        LS_AUFM TYPE TY_AUFM_ROW.

  SELECT MATNR,
         MENGE,
         BWART,
         AUFNR
    FROM AUFM
    INTO TABLE @LT_AUFM
    FOR ALL ENTRIES IN @LT_OPEN_AUFNR
    WHERE AUFNR = @LT_OPEN_AUFNR-TABLE_LINE
      AND WERKS = @P_WERKS
      AND BWART IN ( '261', '262' )
      AND MATNR IS NOT NULL.

  " Net in ABAP
  TYPES: BEGIN OF TY_SUM,
           MATNR TYPE MATNR,
           QTY   TYPE MENGE_D,
         END OF TY_SUM.
* DATA: lt_net TYPE STANDARD TABLE OF ty_sum WITH UNIQUE KEY matnr.
  DATA: LT_NET TYPE HASHED TABLE OF TY_SUM WITH UNIQUE KEY MATNR.
  DATA: LS_NET TYPE TY_SUM.
  DATA: LV_SIGN TYPE I.

  LOOP AT LT_AUFM INTO LS_AUFM.
    IF LS_AUFM-BWART = '261'.
      LV_SIGN = +1.
    ELSEIF LS_AUFM-BWART = '262'.
      LV_SIGN = -1.
    ELSE.
      CONTINUE.
    ENDIF.

    CLEAR LS_NET.
    LS_NET-MATNR = LS_AUFM-MATNR.
    LS_NET-QTY   = LV_SIGN * LS_AUFM-MENGE.
    COLLECT LS_NET INTO LT_NET.  " sums qty by key matnr
  ENDLOOP.

  " Move non-zero nets to gt_wip_sum
  CLEAR GT_WIP_SUM.
  LOOP AT LT_NET INTO LS_NET.
    IF LS_NET-QTY IS NOT INITIAL.
      INSERT VALUE #( MATNR = LS_NET-MATNR QTY = LS_NET-QTY )
             INTO TABLE GT_WIP_SUM.
    ENDIF.
  ENDLOOP.
ENDFORM.


*---------------------------------------------------------------------*
* Assemble rows (16 fields only; WIP via AUFM netting)
*---------------------------------------------------------------------*
FORM ASSEMBLE_ROWS.
  DATA LS_MAT  TYPE TY_MAT.
  DATA LS_MARC TYPE TY_MARC.
  DATA LS_MBEW TYPE TY_MBEW.
  DATA LS_EBEW TYPE EBEW.
  DATA LS_MOQ  TYPE TY_MOQ.
  DATA LS_MSLB TYPE TY_MSLB.
  DATA LS_OUT  TYPE TY_OUT.
  DATA LS_WIP  TYPE TY_WIP.

  DATA: LV_OWN_UNRST TYPE MENGE_D VALUE 0,
        LV_OWN_INSME TYPE INSME   VALUE 0,
        LV_K_UNRST   TYPE MENGE_D VALUE 0,
        LV_K_INSME   TYPE INSME   VALUE 0,
        LV_FRINV     TYPE MENGE_D VALUE 0.

  DATA: LV_OWN_UNRST_VAL TYPE P DECIMALS 2,
        LV_OWN_INSME_VAL TYPE P DECIMALS 2, "VERPR,
        LV_K_UNRST_VAL   TYPE P DECIMALS 2, "VERPR,
        LV_K_INSME_VAL   TYPE P DECIMALS 2. "VERPR.

  LOOP AT GT_MAT INTO LS_MAT.
    CLEAR: LS_OUT, LS_WIP, LV_OWN_UNRST, LV_OWN_INSME, LV_K_UNRST, LV_K_INSME, LV_FRINV.
    LS_OUT-WERKS = P_WERKS.
    LS_OUT-MATNR = LS_MAT-MATNR.
    LS_OUT-MAKTX = LS_MAT-MAKTX.
    LS_OUT-MEINS = LS_MAT-MEINS.
    LS_OUT-MTART = LS_MAT-MTART. "added by farhan

    READ TABLE GT_MARC WITH KEY MATNR = LS_MAT-MATNR INTO LS_MARC.


    READ TABLE GT_MBEW WITH KEY MATNR = LS_MAT-MATNR INTO LS_MBEW.
    IF SY-SUBRC = 0.
      IF LS_MBEW-VPRSV = 'V'.
        LS_OUT-ZRATE = LS_MBEW-VERPR.
      ELSEIF LS_MBEW-VPRSV = 'S'.
        LS_OUT-ZRATE = LS_MBEW-STPRS.
      ELSE.
        LS_OUT-ZRATE = 0.
      ENDIF.
    ENDIF.

    READ TABLE GT_MOQ  WITH KEY MATNR = LS_MAT-MATNR INTO LS_MOQ.
    IF SY-SUBRC = 0. LS_OUT-MINBM = LS_MOQ-MINBM. ENDIF.

    READ TABLE GT_MSLB WITH KEY MATNR = LS_MAT-MATNR INTO LS_MSLB.
    IF SY-SUBRC = 0. LS_OUT-SBCN_QTY = LS_MSLB-SBCNTR. ENDIF.


    CLEAR: LV_OWN_UNRST_VAL.CLEAR: LV_OWN_INSME_VAL .
    LOOP AT GT_MARD_SUM ASSIGNING FIELD-SYMBOL(<M>) WHERE MATNR = LS_MAT-MATNR.
      LV_OWN_UNRST = LV_OWN_UNRST + <M>-LABST.
      LV_OWN_INSME = LV_OWN_INSME + <M>-INSME.
    ENDLOOP.

    LV_OWN_UNRST_VAL = LV_OWN_UNRST * LS_OUT-ZRATE.
    LV_OWN_INSME_VAL = LV_OWN_INSME * LS_OUT-ZRATE.

    " Sales Order Qty & Rate UNrestricted
    LOOP AT GT_MSKA_SUM ASSIGNING FIELD-SYMBOL(<K>) WHERE MATNR = LS_MAT-MATNR AND KALAB NE '0.000'.
      LV_K_UNRST = LV_K_UNRST + <K>-KALAB.
      LS_MAT-WERKS = <K>-WERKS.
      READ TABLE GT_EBEW  INTO LS_EBEW WITH KEY MATNR = LS_MAT-MATNR
                                                BWKEY = LS_MAT-WERKS
                                                VBELN = <K>-VBELN
                                                POSNR = <K>-POSNR.
      IF SY-SUBRC = 0.
        IF LS_EBEW-VPRSV = 'V'.
          LV_OWN_UNRST_VAL = LV_OWN_UNRST_VAL + ( <K>-KALAB * LS_EBEW-VERPR ).
        ELSEIF LS_EBEW-VPRSV = 'S'.
          LV_OWN_UNRST_VAL = LV_OWN_UNRST_VAL + ( <K>-KALAB * LS_EBEW-STPRS ).
        ELSE.
          LV_OWN_UNRST_VAL = 0.
        ENDIF.
      ENDIF.
    ENDLOOP.

    " Sales Order Qty & Rate UNrestricted
    LOOP AT GT_MSKA_SUM ASSIGNING <K> WHERE MATNR = LS_MAT-MATNR AND KAINS NE '0.000'.
      LV_K_INSME = LV_K_INSME + <K>-KAINS.
      LS_MAT-WERKS = <K>-WERKS.
      READ TABLE GT_EBEW  INTO LS_EBEW WITH KEY MATNR = LS_MAT-MATNR
                                                BWKEY = LS_MAT-WERKS
                                                VBELN = <K>-VBELN
                                                POSNR = <K>-POSNR.
      IF SY-SUBRC = 0.
        IF LS_EBEW-VPRSV = 'V'.
          LV_OWN_INSME_VAL = LV_OWN_INSME_VAL + ( <K>-KAINS * LS_EBEW-VERPR ).
        ELSEIF LS_EBEW-VPRSV = 'S'.
          LV_OWN_INSME_VAL = LV_OWN_INSME_VAL + ( <K>-KAINS * LS_EBEW-STPRS ).
        ELSE.
          LV_OWN_INSME_VAL = 0.
        ENDIF.
      ENDIF.
    ENDLOOP.

*      LV_K_UNRST_VAL = LV_K_UNRST * LS_OUT-ZSORATE.
*      LV_K_INSME_VAL = LV_K_INSME * LS_OUT-ZSORATE.
    LS_OUT-INSME   = LV_OWN_INSME + LV_K_INSME.
    LS_OUT-TOTSTCK = LV_OWN_UNRST + LV_K_UNRST.


    " Requirements (unchanged)
    IF P_TREQFM = ABAP_TRUE AND LS_OUT-TOTSTCK > 0.
      DATA LT_MDPS TYPE TABLE OF MDPS.
      DATA LS_MDPS TYPE MDPS.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          MATNR = LS_MAT-MATNR
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

    " WIP: net 261 - 262 issues for open orders
    READ TABLE GT_WIP_SUM WITH KEY MATNR = LS_MAT-MATNR INTO LS_WIP.
    IF SY-SUBRC = 0 AND LS_WIP-QTY > 0.
      LS_OUT-WIP_QTY = LS_WIP-QTY.
    ELSE.
      LS_OUT-WIP_QTY = 0.
    ENDIF.

    " Values
    LS_OUT-TOTSTCK_VAL = LV_OWN_UNRST_VAL."LV_OWN_UNRST_VAL +  LV_K_UNRST_VAL .
    LS_OUT-WIP_VAL     = LS_OUT-WIP_QTY * LS_OUT-ZRATE.
    LS_OUT-QA_QTY      = LS_OUT-INSME.
    LS_OUT-QA_VAL      = LV_OWN_INSME_VAL."LV_OWN_INSME_VAL +  LV_K_INSME_VAL.
    LS_OUT-SBCN_VAL    = LS_OUT-SBCN_QTY * LS_OUT-ZRATE.

    " Free inventory
    LV_FRINV = ( LS_OUT-TOTSTCK + LS_OUT-WIP_QTY + LS_OUT-QA_QTY + LS_OUT-SBCN_QTY ) - LS_OUT-TOTREQ.
    IF LV_FRINV < 0.
      LV_FRINV = 0.
    ENDIF.

    LS_OUT-FREE_QTY = LV_FRINV.
    LS_OUT-FREE_VAL = LS_OUT-FREE_QTY * LS_OUT-ZRATE.

    " Build download row (16 fields)
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
    LS_FINAL-MTART                   = |{ LS_OUT-MTART }|.    "added by farhan

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

    IF LS_OUT-FREE_QTY <> 0.
      APPEND LS_FINAL TO LT_FINAL.
      APPEND LS_OUT TO GT_OUT.
    ENDIF.

  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
* Display SALV (16 columns, full headers; helpers hidden)
*---------------------------------------------------------------------*
FORM DISPLAY_SALV.
  DATA LO_ALV  TYPE REF TO CL_SALV_TABLE.
  DATA LO_COLS TYPE REF TO CL_SALV_COLUMNS_TABLE.
  DATA LO_FUNCS TYPE REF TO CL_SALV_FUNCTIONS_LIST.

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
      CASE IV_NAME.
        WHEN 'WERKS'.
          LO_C->SET_OUTPUT_LENGTH( 6 ).
        WHEN 'MATNR'.
          LO_C->SET_OUTPUT_LENGTH( 18 ).
        WHEN 'MAKTX'.
          LO_C->SET_OUTPUT_LENGTH( 32 ).
        WHEN 'MEINS'.
          LO_C->SET_OUTPUT_LENGTH( 6 ).
        WHEN 'MINBM'.
          LO_C->SET_OUTPUT_LENGTH( 20 ).
        WHEN 'TOTREQ'.
          LO_C->SET_OUTPUT_LENGTH( 20 ).
        WHEN 'TOTSTCK'.
          LO_C->SET_OUTPUT_LENGTH( 22 ).
        WHEN 'TOTSTCK_VAL'.
          LO_C->SET_OUTPUT_LENGTH( 20 ).
        WHEN 'WIP_QTY'.
          LO_C->SET_OUTPUT_LENGTH( 15 ).
        WHEN 'WIP_VAL'.
          LO_C->SET_OUTPUT_LENGTH( 15 ).
        WHEN 'QA_QTY'.
          LO_C->SET_OUTPUT_LENGTH( 20 ).
        WHEN 'QA_VAL'.
          LO_C->SET_OUTPUT_LENGTH( 18 ).
        WHEN 'SBCN_QTY'.
          LO_C->SET_OUTPUT_LENGTH( 30 ).
        WHEN 'SBCN_VAL'.
          LO_C->SET_OUTPUT_LENGTH( 26 ).
        WHEN 'FREE_QTY'.
          LO_C->SET_OUTPUT_LENGTH( 20 ).
        WHEN 'FREE_VAL'.
          LO_C->SET_OUTPUT_LENGTH( 18 ).
      ENDCASE.
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.
ENDFORM.

*---------------------------------------------------------------------*
* Download (exact 16 headers, tab-separated)
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
  LV_FILE = 'ZMM_INVENTORY_NEWV2.TXT'.
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

FORM CVS_HEADER  USING    P_HD_CSV.
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
