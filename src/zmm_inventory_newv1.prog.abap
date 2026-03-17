REPORT zmm_inventory_newv1 NO STANDARD PAGE HEADING.
*----------------------------------------------------------------------
* Selection
*----------------------------------------------------------------------
TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_mtart FOR mara-mtart.
PARAMETERS: p_werks  TYPE werks_d OBLIGATORY,
            p_age    TYPE abap_bool DEFAULT abap_true,   " aging via MATDOC
            p_ageday TYPE i         DEFAULT 540,        " keep original name
            p_treqfm TYPE abap_bool DEFAULT abap_true, " MD_STOCK_REQUIREMENTS_LIST_API
            p_down   AS CHECKBOX,
            p_file   TYPE rlgrap-filename DEFAULT '/Delval/India'. " 'C:\temp\ZMM_INVENTORY_S4.txt'.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-010.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-011.
SELECTION-SCREEN: END OF BLOCK b3.

CONSTANTS: c_lang TYPE spras VALUE 'E'.

*----------------------------------------------------------------------
* Exclusions / Ranges
*----------------------------------------------------------------------
TYPES: r_lgort TYPE RANGE OF lgort_d.
DATA:  gr_excl_lgort TYPE r_lgort.

TYPES: r_bwart TYPE RANGE OF bwart.
DATA:  gr_bwart TYPE r_bwart.

INITIALIZATION.
  gr_excl_lgort = VALUE r_lgort(
    ( sign = 'I' option = 'EQ' low = 'RJ01' )
    ( sign = 'I' option = 'EQ' low = 'SCR1' )
    ( sign = 'I' option = 'EQ' low = 'SRN1' )
    ( sign = 'I' option = 'EQ' low = 'VLD1' )
    ( sign = 'I' option = 'EQ' low = 'SLR1' )
    ( sign = 'I' option = 'EQ' low = 'SPC1' )
    ( sign = 'I' option = 'EQ' low = 'KRJ0' )
    ( sign = 'I' option = 'EQ' low = 'KSCR' )
    ( sign = 'I' option = 'EQ' low = 'KSRN' )
    ( sign = 'I' option = 'EQ' low = 'KVLD' )
    ( sign = 'I' option = 'EQ' low = 'KSLR' ) ).     " :contentReference[oaicite:0]{index=0}

  gr_bwart = VALUE r_bwart(
    ( sign = 'I' option = 'EQ' low = '101' )
    ( sign = 'I' option = 'EQ' low = '561' )
    ( sign = 'I' option = 'EQ' low = '531' )
    ( sign = 'I' option = 'EQ' low = '309' )
    ( sign = 'I' option = 'EQ' low = '311' )
    ( sign = 'I' option = 'EQ' low = '411' )
    ( sign = 'I' option = 'EQ' low = '501' )
    ( sign = 'I' option = 'EQ' low = '653' )
    ( sign = 'I' option = 'EQ' low = '701' )
    ( sign = 'I' option = 'EQ' low = 'Z11' )
    ( sign = 'I' option = 'EQ' low = '542' )
    ( sign = 'I' option = 'EQ' low = '301' )
    ( sign = 'I' option = 'EQ' low = '413' )
    ( sign = 'I' option = 'EQ' low = '344' )
    ( sign = 'I' option = 'EQ' low = 'Z42' )
    ( sign = 'I' option = 'EQ' low = '343' ) ).      " :contentReference[oaicite:1]{index=1}

*----------------------------------------------------------------------
* SLoc → bucket (kept as-is; excluded SLocs stay 0 in output)
*----------------------------------------------------------------------
FORM map_lgort_to_bucket  USING    iv_lgort TYPE lgort_d
                          CHANGING ev_bucket TYPE i.
  ev_bucket = 0.
  CASE iv_lgort.
      " Non-K
    WHEN 'FG01'. ev_bucket = 1.
    WHEN 'PRD1'. ev_bucket = 2.
*   'RJ01' → SL3, but excluded upstream; will remain 0 in output
    WHEN 'RM01'. ev_bucket = 4.
    WHEN 'RWK1'. ev_bucket = 5.
    WHEN 'SC01'. ev_bucket = 6.
*   'SCR1' → SL7, excluded; remains 0
    WHEN 'SFG1'. ev_bucket = 8.
*   'SLR1' → SL9, excluded; remains 0
*   'SPC1' → SL10, excluded; remains 0
    WHEN 'SRN1'. ev_bucket = 11.
    WHEN 'TPI1'. ev_bucket = 12.
    WHEN 'VLD1'. ev_bucket = 13.
    WHEN 'TR01'. ev_bucket = 14.
    WHEN 'PLG1'. ev_bucket = 15.
    WHEN 'SAN1'. ev_bucket = 16.
    WHEN 'MCN1'. ev_bucket = 17.
      " K*
    WHEN 'KFG0'. ev_bucket = 18.
    WHEN 'KPRD'. ev_bucket = 19.
    WHEN 'KRM0'. ev_bucket = 20.
    WHEN 'KRWK'. ev_bucket = 21.
    WHEN 'KSC0'. ev_bucket = 22.
    WHEN 'KSCR'. ev_bucket = 23.   " excluded; remains 0
    WHEN 'KSFG'. ev_bucket = 24.
    WHEN 'KSLR'. ev_bucket = 25.   " excluded; remains 0
    WHEN 'KSPC'. ev_bucket = 26.
    WHEN 'KSRN'. ev_bucket = 27.   " excluded; remains 0
    WHEN 'KTPI'. ev_bucket = 28.
    WHEN 'KVLD'. ev_bucket = 29.   " excluded; remains 0
    WHEN 'KPR1'. ev_bucket = 30.
  ENDCASE.
ENDFORM.                                                    " :contentReference[oaicite:2]{index=2}

*----------------------------------------------------------------------
* Types / Data (added missing columns only; no logic change)
*----------------------------------------------------------------------
TYPES: BEGIN OF ty_mat,
         matnr   TYPE matnr,
         meins   TYPE meins,
         mtart   TYPE mtart,
         zseries TYPE zser_code,
         zsize   TYPE zsize,
         brand   TYPE zbrand,
         moc     TYPE zmoc,
         type    TYPE ztyp,
         maktx   TYPE maktx,
       END OF ty_mat.
DATA: gt_mat TYPE SORTED TABLE OF ty_mat WITH UNIQUE KEY matnr.      " :contentReference[oaicite:3]{index=3}

TYPES: BEGIN OF ty_marc, matnr TYPE matnr, sfqty TYPE eisbe, END OF ty_marc.
DATA: gt_marc TYPE SORTED TABLE OF ty_marc WITH UNIQUE KEY matnr.    " :contentReference[oaicite:4]{index=4}

TYPES: BEGIN OF ty_mbew, matnr TYPE matnr, vprsv TYPE vprsv, verpr TYPE verpr, stprs TYPE stprs, END OF ty_mbew.
DATA: gt_mbew TYPE SORTED TABLE OF ty_mbew WITH UNIQUE KEY matnr.    " :contentReference[oaicite:5]{index=5}

TYPES: BEGIN OF ty_moq, matnr TYPE matnr, minbm TYPE minbm, END OF ty_moq.
DATA: gt_moq TYPE SORTED TABLE OF ty_moq WITH UNIQUE KEY matnr.      " :contentReference[oaicite:6]{index=6}

TYPES: BEGIN OF ty_mslb, matnr TYPE matnr, sbcntr TYPE labst, END OF ty_mslb.
DATA: gt_mslb TYPE SORTED TABLE OF ty_mslb WITH UNIQUE KEY matnr.    " :contentReference[oaicite:7]{index=7}

TYPES: BEGIN OF ty_mard_sum, matnr TYPE matnr, lgort TYPE lgort_d, labst TYPE labst, insme TYPE insme, speme TYPE speme, END OF ty_mard_sum.
DATA: gt_mard_sum TYPE STANDARD TABLE OF ty_mard_sum WITH DEFAULT KEY. " :contentReference[oaicite:8]{index=8}

TYPES: BEGIN OF ty_mska_sum, matnr TYPE matnr, lgort TYPE lgort_d, kalab TYPE labst, kains TYPE insme, kaspe TYPE speme, END OF ty_mska_sum.
DATA: gt_mska_sum TYPE STANDARD TABLE OF ty_mska_sum WITH DEFAULT KEY. " :contentReference[oaicite:9]{index=9}

TYPES: BEGIN OF ty_buckets,
         matnr TYPE matnr,
         sl1   TYPE menge_d,  sl2  TYPE menge_d,  sl3  TYPE menge_d,  sl4  TYPE menge_d,  sl5  TYPE menge_d,
         sl6   TYPE menge_d,  sl7  TYPE menge_d,  sl8  TYPE menge_d,  sl9  TYPE menge_d,  sl10 TYPE menge_d,
         sl11  TYPE menge_d,  sl12 TYPE menge_d,  sl13 TYPE menge_d,  sl14 TYPE menge_d,  sl15 TYPE menge_d,
         sl16  TYPE menge_d,  sl17 TYPE menge_d,  sl18 TYPE menge_d,  sl19 TYPE menge_d,  sl20 TYPE menge_d,
         sl21  TYPE menge_d,  sl22 TYPE menge_d,  sl23 TYPE menge_d,  sl24 TYPE menge_d,  sl25 TYPE menge_d,
         sl26  TYPE menge_d,  sl27 TYPE menge_d,  sl28 TYPE menge_d,  sl29 TYPE menge_d,  sl30 TYPE menge_d,
         unrst TYPE menge_d,
         insme TYPE insme,
         speme TYPE speme,
       END OF ty_buckets.
DATA: gt_buckets TYPE SORTED TABLE OF ty_buckets WITH UNIQUE KEY matnr. " :contentReference[oaicite:10]{index=10}

TYPES: BEGIN OF ty_mdoc_gr, budat TYPE budat, menge TYPE menge_d, END OF ty_mdoc_gr.
DATA: gt_mdoc_gr TYPE STANDARD TABLE OF ty_mdoc_gr WITH DEFAULT KEY.   " :contentReference[oaicite:11]{index=11}

" === OUTPUT: now includes all missing columns; sequence aligned ===
TYPES: BEGIN OF ty_out,
         " Identity
         werks      TYPE werks_d,
         matnr      TYPE matnr,
         maktx      TYPE maktx,
         meins      TYPE meins,
         mtart      TYPE mtart,
         minbm      TYPE minbm,
         sbcntr     TYPE menge_d,

         " Non-K buckets (SL1..SL17)
         sl1        TYPE menge_d,  " FG01
         sl2        TYPE menge_d,  " PRD1
         sl3        TYPE menge_d,  " RJ01 (excluded → stays 0)
         sl4        TYPE menge_d,  " RM01
         sl5        TYPE menge_d,  " RWK1
         sl6        TYPE menge_d,  " SC01
         sl7        TYPE menge_d,  " SCR1 (excluded → 0)
         sl8        TYPE menge_d,  " SFG1
         sl9        TYPE menge_d,  " SLR1 (excluded → 0)
         sl10       TYPE menge_d,  " SPC1 (excluded → 0)
         sl11       TYPE menge_d,  " SRN1
         sl12       TYPE menge_d,  " TPI1
         sl13       TYPE menge_d,  " VLD1
         sl14       TYPE menge_d,  " TR01
         sl15       TYPE menge_d,  " PLG1
         sl16       TYPE menge_d,  " SAN1
         sl17       TYPE menge_d,  " MCN1

         " KPR set (SL18..SL30)
         sl18       TYPE menge_d,  " KFG0
         sl19       TYPE menge_d,  " KPRD
         sl20       TYPE menge_d,  " KRM0
         sl21       TYPE menge_d,  " KRWK
         sl22       TYPE menge_d,  " KSC0
         sl23       TYPE menge_d,  " KSCR (excluded → 0)
         sl24       TYPE menge_d,  " KSFG
         sl25       TYPE menge_d,  " KSLR (excluded → 0)
         sl26       TYPE menge_d,  " KSPC
         sl27       TYPE menge_d,  " KSRN (excluded → 0)
         sl28       TYPE menge_d,  " KTPI
         sl29       TYPE menge_d,  " KVLD (excluded → 0)
         sl30       TYPE menge_d,  " KPR1

         " Totals
         unrst      TYPE menge_d,
         insme      TYPE insme,
         speme      TYPE speme,
         totstck    TYPE menge_d,
         sfqty      TYPE eisbe,
         totreq     TYPE menge_d,
         frinv      TYPE menge_d,

         " Price/Value
         zrate      TYPE verpr,
         value      TYPE stprs,

         " Ageing qty + values
         lt30       TYPE menge_d, vlt30      TYPE stprs,
         bt30_60    TYPE menge_d, vbt30_60   TYPE stprs,
         bt60_90    TYPE menge_d, vbt60_90   TYPE stprs,
         bt90_120   TYPE menge_d, vbt90_120  TYPE stprs,
         bt120_150  TYPE menge_d, vbt120_150 TYPE stprs,
         bt150_180  TYPE menge_d, vbt150_180 TYPE stprs,
         gt180      TYPE menge_d, vgt180     TYPE stprs,

         " Z-attributes
         zseries    TYPE zser_code,
         zsize      TYPE zsize,
         brand      TYPE zbrand,
         moc        TYPE zmoc,
         type       TYPE ztyp,

         " Dates / ref
         ref        TYPE char11,  " e.g., 19-AUG-2025
         budat_mkpf TYPE budat,   " last usage date (from aging)
       END OF ty_out.
DATA: gt_out TYPE STANDARD TABLE OF ty_out WITH DEFAULT KEY.          " :contentReference[oaicite:12]{index=12}

*----------------------------------------------------------------------
* Main (unchanged flow)
*----------------------------------------------------------------------
START-OF-SELECTION.
  PERFORM fetch_materials.
  IF gt_mat IS INITIAL.
    MESSAGE 'No materials for plant/filters' TYPE 'S'. RETURN.
  ENDIF.
  PERFORM fetch_marc.
  PERFORM fetch_mbew.
  PERFORM fetch_moq.
  PERFORM fetch_mslb.
  PERFORM fetch_mard_agg.
  PERFORM fetch_mska_agg.
  PERFORM fold_buckets.
  PERFORM assemble_rows.

  IF p_down = abap_true.
    PERFORM download_file.
  ELSE.
    PERFORM display_salv.
  ENDIF.                                                           " :contentReference[oaicite:13]{index=13}

*----------------------------------------------------------------------
* Fetch materials (+ text) – unchanged logic
*----------------------------------------------------------------------
FORM fetch_materials.
  DATA lt_mat TYPE STANDARD TABLE OF ty_mat.

  IF s_matnr IS INITIAL AND s_mtart IS INITIAL.
    SELECT a~matnr, a~meins, a~mtart,
           a~zseries, a~zsize, a~brand, a~moc, a~type,
           b~maktx
      FROM mara AS a
      INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @p_werks
      LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
      INTO TABLE @lt_mat.
  ELSEIF s_matnr IS INITIAL.
    SELECT a~matnr, a~meins, a~mtart,
           a~zseries, a~zsize, a~brand, a~moc, a~type,
           b~maktx
      FROM mara AS a
      INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @p_werks
      LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
      INTO TABLE @lt_mat
      WHERE a~mtart IN @s_mtart.
  ELSEIF s_mtart IS INITIAL.
    SELECT a~matnr, a~meins, a~mtart,
           a~zseries, a~zsize, a~brand, a~moc, a~type,
           b~maktx
      FROM mara AS a
      INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @p_werks
      LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
      INTO TABLE @lt_mat
      WHERE a~matnr IN @s_matnr.
  ELSE.
    SELECT a~matnr, a~meins, a~mtart,
           a~zseries, a~zsize, a~brand, a~moc, a~type,
           b~maktx
      FROM mara AS a
      INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @p_werks
      LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
      INTO TABLE @lt_mat
      WHERE a~matnr IN @s_matnr
        AND a~mtart IN @s_mtart.
  ENDIF.

  SORT lt_mat BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING matnr.
  gt_mat = lt_mat.
ENDFORM.                                                          " :contentReference[oaicite:14]{index=14}

FORM fetch_marc.
  IF s_matnr IS INITIAL.
    SELECT matnr, eisbe AS sfqty
      FROM marc
      INTO TABLE @gt_marc
      WHERE werks = @p_werks.
  ELSE.
    SELECT matnr, eisbe AS sfqty
      FROM marc
      INTO TABLE @gt_marc
      WHERE werks = @p_werks
        AND matnr IN @s_matnr.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:15]{index=15}

FORM fetch_mbew.
  IF s_matnr IS INITIAL.
    SELECT matnr, vprsv, verpr, stprs
      FROM mbew
      INTO TABLE @gt_mbew
      WHERE bwkey = @p_werks.
  ELSE.
    SELECT matnr, vprsv, verpr, stprs
      FROM mbew
      INTO TABLE @gt_mbew
      WHERE bwkey = @p_werks
        AND matnr IN @s_matnr.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:16]{index=16}

FORM fetch_moq.
  IF s_matnr IS INITIAL.
    SELECT eina~matnr   AS matnr,
           MAX( eine~minbm ) AS minbm
      FROM eine
      INNER JOIN eina ON eina~infnr = eine~infnr
      GROUP BY eina~matnr
      INTO TABLE @gt_moq.
  ELSE.
    SELECT eina~matnr   AS matnr,
           MAX( eine~minbm ) AS minbm
      FROM eine
      INNER JOIN eina ON eina~infnr = eine~infnr
      WHERE eina~matnr IN @s_matnr
      GROUP BY eina~matnr
      INTO TABLE @gt_moq.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:17]{index=17}

FORM fetch_mslb.
  IF s_matnr IS INITIAL.
    SELECT matnr, SUM( lblab ) AS sbcntr
      FROM mslb
      WHERE werks = @p_werks
      GROUP BY matnr
      INTO TABLE @gt_mslb.
  ELSE.
    SELECT matnr, SUM( lblab ) AS sbcntr
      FROM mslb
      WHERE werks = @p_werks
        AND matnr IN @s_matnr
      GROUP BY matnr
      INTO TABLE @gt_mslb.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:18]{index=18}

FORM fetch_mard_agg.
  IF s_matnr IS INITIAL.
    SELECT matnr, lgort,
           SUM( labst ) AS labst,
           SUM( insme ) AS insme,
           SUM( speme ) AS speme
      FROM mard
      WHERE werks = @p_werks
        AND diskz <> '1'
        AND lgort NOT IN @gr_excl_lgort
      GROUP BY matnr, lgort
      INTO TABLE @gt_mard_sum.
  ELSE.
    SELECT matnr, lgort,
           SUM( labst ) AS labst,
           SUM( insme ) AS insme,
           SUM( speme ) AS speme
      FROM mard
      WHERE werks = @p_werks
        AND matnr IN @s_matnr
        AND diskz <> '1'
        AND lgort NOT IN @gr_excl_lgort
      GROUP BY matnr, lgort
      INTO TABLE @gt_mard_sum.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:19]{index=19}

FORM fetch_mska_agg.
  IF s_matnr IS INITIAL.
    SELECT matnr, lgort,
           SUM( kalab ) AS kalab,
           SUM( kains ) AS kains,
           SUM( kaspe ) AS kaspe
      FROM mska
      WHERE werks = @p_werks
        AND lgort NOT IN @gr_excl_lgort
      GROUP BY matnr, lgort
      INTO TABLE @gt_mska_sum.
  ELSE.
    SELECT matnr, lgort,
           SUM( kalab ) AS kalab,
           SUM( kains ) AS kains,
           SUM( kaspe ) AS kaspe
      FROM mska
      WHERE werks = @p_werks
        AND matnr IN @s_matnr
        AND lgort NOT IN @gr_excl_lgort
      GROUP BY matnr, lgort
      INTO TABLE @gt_mska_sum.
  ENDIF.
ENDFORM.                                                          " :contentReference[oaicite:20]{index=20}

*----------------------------------------------------------------------
* Merge buckets (unchanged, now copies to full SL1..SL30)
*----------------------------------------------------------------------
FORM fold_buckets.
  DATA ls_mard TYPE ty_mard_sum.
  DATA ls_mska TYPE ty_mska_sum.
  DATA ls_buck TYPE ty_buckets.
  DATA lv_b    TYPE i.

  LOOP AT gt_mard_sum INTO ls_mard.
    READ TABLE gt_buckets WITH KEY matnr = ls_mard-matnr INTO ls_buck.
    IF sy-subrc <> 0.
      CLEAR ls_buck.
      ls_buck-matnr = ls_mard-matnr.
    ENDIF.

    PERFORM map_lgort_to_bucket USING ls_mard-lgort CHANGING lv_b.
*    IF lv_b BETWEEN 1 AND 30.
    IF lv_b BETWEEN 2 AND 30.
      ASSIGN COMPONENT lv_b OF STRUCTURE ls_buck TO FIELD-SYMBOL(<f>).
      IF <f> IS ASSIGNED. <f> = <f> + ls_mard-labst. ENDIF.
    ENDIF.

    ls_buck-unrst = ls_buck-unrst + ls_mard-labst.
    ls_buck-insme = ls_buck-insme + ls_mard-insme.
    ls_buck-speme = ls_buck-speme + ls_mard-speme.

    MODIFY TABLE gt_buckets FROM ls_buck.
    IF sy-subrc = 4.
      INSERT ls_buck INTO TABLE gt_buckets.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_mska_sum INTO ls_mska.
    READ TABLE gt_buckets WITH KEY matnr = ls_mska-matnr INTO ls_buck.
    IF sy-subrc <> 0.
      CLEAR ls_buck.
      ls_buck-matnr = ls_mska-matnr.
    ENDIF.

    PERFORM map_lgort_to_bucket USING ls_mska-lgort CHANGING lv_b.
    IF lv_b BETWEEN 2 AND 30.
      ASSIGN COMPONENT lv_b OF STRUCTURE ls_buck TO FIELD-SYMBOL(<g>).
      IF <g> IS ASSIGNED. <g> = <g> + ls_mska-kalab. ENDIF.
    ENDIF.

    ls_buck-unrst = ls_buck-unrst + ls_mska-kalab.
    ls_buck-insme = ls_buck-insme + ls_mska-kains.
    ls_buck-speme = ls_buck-speme + ls_mska-kaspe.

    MODIFY TABLE gt_buckets FROM ls_buck.
  ENDLOOP.
ENDFORM.                                                          " :contentReference[oaicite:21]{index=21}

*----------------------------------------------------------------------
* Assemble rows + aging (kept same; just filling new fields)
*----------------------------------------------------------------------
FORM assemble_rows.
  DATA ls_mat   TYPE ty_mat.
  DATA ls_marc  TYPE ty_marc.
  DATA ls_mbew  TYPE ty_mbew.
  DATA ls_moq   TYPE ty_moq.
  DATA ls_mslb  TYPE ty_mslb.
  DATA ls_buck  TYPE ty_buckets.
  DATA ls_out   TYPE ty_out.
  DATA lv_rate  TYPE verpr.
  DATA lv_treq  TYPE menge_d.

  LOOP AT gt_mat INTO ls_mat.
    CLEAR: ls_out, lv_rate, lv_treq.
    ls_out-werks   = p_werks.
    ls_out-matnr   = ls_mat-matnr.
    ls_out-maktx   = ls_mat-maktx.
    ls_out-meins   = ls_mat-meins.
    ls_out-mtart   = ls_mat-mtart.
    ls_out-zseries = ls_mat-zseries.
    ls_out-zsize   = ls_mat-zsize.
    ls_out-brand   = ls_mat-brand.
    ls_out-moc     = ls_mat-moc.
    ls_out-type    = ls_mat-type.

    READ TABLE gt_marc WITH KEY matnr = ls_mat-matnr INTO ls_marc.
    IF sy-subrc = 0. ls_out-sfqty = ls_marc-sfqty. ENDIF.

    READ TABLE gt_mbew WITH KEY matnr = ls_mat-matnr INTO ls_mbew.
    IF sy-subrc = 0.
      IF ls_mbew-vprsv = 'V'.
        lv_rate = ls_mbew-verpr.
      ELSEIF ls_mbew-vprsv = 'S'.
        lv_rate = ls_mbew-stprs.
      ELSE.
        lv_rate = 0.
      ENDIF.
    ENDIF.
    ls_out-zrate = lv_rate.

    READ TABLE gt_moq WITH KEY matnr = ls_mat-matnr INTO ls_moq.
    IF sy-subrc = 0. ls_out-minbm = ls_moq-minbm. ENDIF.

    READ TABLE gt_mslb WITH KEY matnr = ls_mat-matnr INTO ls_mslb.
    IF sy-subrc = 0. ls_out-sbcntr = ls_mslb-sbcntr. ENDIF.

    READ TABLE gt_buckets WITH KEY matnr = ls_mat-matnr INTO ls_buck.
    IF sy-subrc = 0.
      " copy ALL SL1..SL30
      ls_out-sl1  = ls_buck-sl1.
      ls_out-sl2  = ls_buck-sl2.
      ls_out-sl3  = ls_buck-sl3.
      ls_out-sl4  = ls_buck-sl4.
      ls_out-sl5  = ls_buck-sl5.
      ls_out-sl6  = ls_buck-sl6.
      ls_out-sl7  = ls_buck-sl7.
      ls_out-sl8  = ls_buck-sl8.
      ls_out-sl9  = ls_buck-sl9.
      ls_out-sl10 = ls_buck-sl10.
      ls_out-sl11 = ls_buck-sl11.
      ls_out-sl12 = ls_buck-sl12.
      ls_out-sl13 = ls_buck-sl13.
      ls_out-sl14 = ls_buck-sl14.
      ls_out-sl15 = ls_buck-sl15.
      ls_out-sl16 = ls_buck-sl16.
      ls_out-sl17 = ls_buck-sl17.
      ls_out-sl18 = ls_buck-sl18.
      ls_out-sl19 = ls_buck-sl19.
      ls_out-sl20 = ls_buck-sl20.
      ls_out-sl21 = ls_buck-sl21.
      ls_out-sl22 = ls_buck-sl22.
      ls_out-sl23 = ls_buck-sl23.
      ls_out-sl24 = ls_buck-sl24.
      ls_out-sl25 = ls_buck-sl25.
      ls_out-sl26 = ls_buck-sl26.
      ls_out-sl27 = ls_buck-sl27.
      ls_out-sl28 = ls_buck-sl28.
      ls_out-sl29 = ls_buck-sl29.
      ls_out-sl30 = ls_buck-sl30.

      ls_out-unrst = ls_buck-unrst.
      ls_out-insme = ls_buck-insme.
      ls_out-speme = ls_buck-speme.
    ENDIF.

    ls_out-totstck = ls_out-sbcntr + ls_out-unrst + ls_out-insme.

    IF p_treqfm = abap_true AND ls_out-totstck > 0.
      DATA lt_mdps TYPE TABLE OF mdps.
      DATA ls_mdps TYPE mdps.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr = ls_mat-matnr
          werks = p_werks
        TABLES
          mdpsx = lt_mdps.
      IF lt_mdps IS NOT INITIAL.
        LOOP AT lt_mdps INTO ls_mdps.
          IF ls_mdps-delkz = 'VC' OR ls_mdps-delkz = 'SB'
           OR ls_mdps-delkz = 'U1' OR ls_mdps-delkz = 'U2'
           OR ls_mdps-delkz = 'PP'
           OR ( ls_mdps-delkz = 'BB' AND ls_mdps-plaab <> 26 )
           OR ( ls_mdps-delkz = 'AR' AND ls_mdps-plumi <> '+' )
           OR ( ls_mdps-delkz = 'KB' AND ls_mdps-plumi <> 'B' ).
            lv_treq = lv_treq + ls_mdps-mng01.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    ls_out-totreq = lv_treq.
    ls_out-frinv  = ls_out-totstck - ls_out-totreq.
    IF ls_out-frinv < 0. ls_out-frinv = 0. ENDIF.

    IF p_age = abap_true AND ls_out-frinv > 0.
      PERFORM compute_aging USING    ls_mat-matnr p_werks ls_out-frinv
                            CHANGING ls_out-lt30 ls_out-bt30_60 ls_out-bt60_90
                                     ls_out-bt90_120 ls_out-bt120_150 ls_out-bt150_180
                                     ls_out-gt180 ls_out-budat_mkpf.   " use as last-usage date
      ls_out-vlt30      = ls_out-zrate * ls_out-lt30.
      ls_out-vbt30_60   = ls_out-zrate * ls_out-bt30_60.
      ls_out-vbt60_90   = ls_out-zrate * ls_out-bt60_90.
      ls_out-vbt90_120  = ls_out-zrate * ls_out-bt90_120.
      ls_out-vbt120_150 = ls_out-zrate * ls_out-bt120_150.
      ls_out-vbt150_180 = ls_out-zrate * ls_out-bt150_180.
      ls_out-vgt180     = ls_out-zrate * ls_out-gt180.
    ENDIF.

    ls_out-value = ls_out-zrate * ls_out-frinv.

    " REF date (DD-MMM-YYYY)
    DATA lv_ref TYPE string.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = sy-datum
      IMPORTING
        output = lv_ref.
    TRANSLATE lv_ref TO UPPER CASE.
    CONCATENATE lv_ref+0(2) lv_ref+2(3) lv_ref+5(4)
      INTO ls_out-ref SEPARATED BY '-'.

    APPEND ls_out TO gt_out.
  ENDLOOP.
ENDFORM.                                                          " :contentReference[oaicite:22]{index=22}

*----------------------------------------------------------------------
* Aging via MATDOC (kept same; just writes budat to budat_mkpf)
*----------------------------------------------------------------------
FORM compute_aging  USING    iv_matnr      TYPE matnr
                             iv_werks      TYPE werks_d
                             iv_req_qty    TYPE menge_d
                    CHANGING ev_lt30       TYPE menge_d
                             ev_bt30_60    TYPE menge_d
                             ev_bt60_90    TYPE menge_d
                             ev_bt90_120   TYPE menge_d
                             ev_bt120_150  TYPE menge_d
                             ev_bt150_180  TYPE menge_d
                             ev_gt180      TYPE menge_d
                             ev_last_budat TYPE budat.

  DATA: lv_from TYPE budat,
        ls_row  TYPE ty_mdoc_gr,
        lv_take TYPE menge_d,
        lv_days TYPE i,
        lv_left TYPE menge_d.

  CLEAR: ev_lt30, ev_bt30_60, ev_bt60_90, ev_bt90_120, ev_bt120_150, ev_bt150_180, ev_gt180, ev_last_budat.
  lv_left = iv_req_qty.
  lv_from = sy-datum - p_ageday.

  REFRESH gt_mdoc_gr.

  SELECT budat,
         SUM( CASE WHEN shkzg = 'H' THEN - menge ELSE menge END ) AS menge
    FROM matdoc
    WHERE matnr = @iv_matnr
      AND werks = @iv_werks
      AND budat >= @lv_from
      AND bwart IN @gr_bwart
    GROUP BY budat
    ORDER BY budat DESCENDING
    INTO TABLE @gt_mdoc_gr.

  LOOP AT gt_mdoc_gr INTO ls_row.
    IF lv_left <= 0. EXIT. ENDIF.
    IF ls_row-menge <= 0. CONTINUE. ENDIF.

    lv_take = ls_row-menge.
    IF lv_take > lv_left. lv_take = lv_left. ENDIF.

    IF ev_last_budat IS INITIAL AND lv_take > 0.
      ev_last_budat = ls_row-budat.
    ENDIF.

    lv_days = sy-datum - ls_row-budat.
    IF lv_days < 30.
      ev_lt30 = ev_lt30 + lv_take.
    ELSEIF lv_days BETWEEN 30 AND 60.
      ev_bt30_60 = ev_bt30_60 + lv_take.
    ELSEIF lv_days BETWEEN 60 AND 90.
      ev_bt60_90 = ev_bt60_90 + lv_take.
    ELSEIF lv_days BETWEEN 90 AND 120.
      ev_bt90_120 = ev_bt90_120 + lv_take.
    ELSEIF lv_days BETWEEN 120 AND 150.
      ev_bt120_150 = ev_bt120_150 + lv_take.
    ELSEIF lv_days BETWEEN 150 AND 180.
      ev_bt150_180 = ev_bt150_180 + lv_take.
    ELSE.
      ev_gt180 = ev_gt180 + lv_take.
    ENDIF.

    lv_left = lv_left - lv_take.
  ENDLOOP.
ENDFORM.                                                          " :contentReference[oaicite:23]{index=23}

*----------------------------------------------------------------------
* Display SALV with proper labels (no metadata junk)
*----------------------------------------------------------------------
FORM display_salv.
  DATA lo_alv  TYPE REF TO cl_salv_table.
  DATA lo_cols TYPE REF TO cl_salv_columns_table.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_out ).

      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_columns( )->set_optimize( abap_true ).

      lo_cols = lo_alv->get_columns( ).

      " Identity
      PERFORM set_col USING lo_cols 'WERKS'      'Plant'     'Plant'                 'Plant'.
      PERFORM set_col USING lo_cols 'MATNR'      'Material'  'Material'              'Material'.
      PERFORM set_col USING lo_cols 'MAKTX'      'Desc'      'Description'           'Material Description'.
      PERFORM set_col USING lo_cols 'MEINS'      'UoM'       'Base UoM'              'Base Unit of Measure'.
      PERFORM set_col USING lo_cols 'MTART'      'Mat Type'  'Material Type'         'Material Type'.
      PERFORM set_col USING lo_cols 'MINBM'      'Min PO Qty' 'Minimum PO Qty'        'Minimum Purchase Order Qty'.
      PERFORM set_col USING lo_cols 'SBCNTR'     'Subcon'    'Subcontractor'         'Subcontractor Stock'.

      " Non-K SLoc buckets (SL1..SL17)
      PERFORM set_col USING lo_cols 'SL1'        'FG01'      'Finished Goods'        'FG01 (Finished Goods)'.
      PERFORM set_col USING lo_cols 'SL2'        'PRD1'      'Production'            'PRD1 (Production)'.
      PERFORM set_col USING lo_cols 'SL3'        'RJ01'      'Rejection'             'RJ01 (Rejection)'.
      PERFORM set_col USING lo_cols 'SL4'        'RM01'      'Raw Materials'         'RM01 (Raw Materials)'.
      PERFORM set_col USING lo_cols 'SL5'        'RWK1'      'Rework'                'RWK1 (Rework)'.
      PERFORM set_col USING lo_cols 'SL6'        'SC01'      'Subcon SLoc'           'SC01 (Subcon Storage Location)'.
      PERFORM set_col USING lo_cols 'SL7'        'SCR1'      'Scrap'                 'SCR1 (Scrap)'.
      PERFORM set_col USING lo_cols 'SL8'        'SFG1'      'WIP Assembled'         'SFG1 (WIP Assembled)'.
      PERFORM set_col USING lo_cols 'SL9'        'SLR1'      'FG Sales Ret'          'SLR1 (FG Sales Return)'.
      PERFORM set_col USING lo_cols 'SL10'       'SPC1'      'Spares & Cons'         'SPC1 (Spares & Consumables)'.
      PERFORM set_col USING lo_cols 'SL11'       'SRN1'      'SRN Stores'            'SRN1 (SRN Stores)'.
      PERFORM set_col USING lo_cols 'SL12'       'TPI1'      'Third Party'           'TPI1 (Third Party Insp)'.
      PERFORM set_col USING lo_cols 'SL13'       'VLD1'      'Validation'            'VLD1 (Validation)'.
      PERFORM set_col USING lo_cols 'SL14'       'TR01'      'QA OK Stock'           'TR01 (QA OK Stock)'.
      PERFORM set_col USING lo_cols 'SL15'       'PLG1'      'Planning'              'PLG1 (Planning)'.
      PERFORM set_col USING lo_cols 'SL16'       'SAN1'      'Sangavi'               'SAN1 (Sangavi Stock)'.
      PERFORM set_col USING lo_cols 'SL17'       'MCN1'      'Machine'               'MCN1 (Machine Stock)'.

      " KPR set (SL18..SL30)
      PERFORM set_col USING lo_cols 'SL18'       'KFG0'      'KPR FG'                'KFG0 (KPR FG)'.
      PERFORM set_col USING lo_cols 'SL19'       'KPRD'      'KPR Prod'              'KPRD (KPR Production)'.
      PERFORM set_col USING lo_cols 'SL20'       'KRM0'      'KPR RawMat'            'KRM0 (KPR Raw Materials)'.
      PERFORM set_col USING lo_cols 'SL21'       'KRWK'      'KPR Rework'            'KRWK (KPR Rework)'.
      PERFORM set_col USING lo_cols 'SL22'       'KSC0'      'KPR Subcon'            'KSC0 (KPR Subcon SLoc)'.
      PERFORM set_col USING lo_cols 'SL23'       'KSCR'      'KPR Scrap'             'KSCR (KPR Scrap)'.
      PERFORM set_col USING lo_cols 'SL24'       'KSFG'      'KPR WIP'               'KSFG (KPR WIP Assembled)'.
      PERFORM set_col USING lo_cols 'SL25'       'KSLR'      'KPR FG Ret'            'KSLR (KPR FG Sales Return)'.
      PERFORM set_col USING lo_cols 'SL26'       'KSPC'      'KPR Spares'            'KSPC (KPR Spares & Cons)'.
      PERFORM set_col USING lo_cols 'SL27'       'KSRN'      'KPR SRN'               'KSRN (KPR SRN Stores)'.
      PERFORM set_col USING lo_cols 'SL28'       'KTPI'      'KPR Third P'           'KTPI (KPR Third Party Insp)'.
      PERFORM set_col USING lo_cols 'SL29'       'KVLD'      'KPR Valid'             'KVLD (KPR Validation)'.
      PERFORM set_col USING lo_cols 'SL30'       'KPR1'      'KPR1'                  'KPR1'.

      " Totals
      PERFORM set_col USING lo_cols 'UNRST'      'Unrestr'   'Unrestricted'          'Unrestricted Stock'.
      PERFORM set_col USING lo_cols 'INSME'      'Qual Insp' 'Quality Inspection'    'Stock in Quality Inspection'.
      PERFORM set_col USING lo_cols 'SPEME'      'Blocked'   'Blocked'               'Blocked Stock'.
      PERFORM set_col USING lo_cols 'TOTSTCK'    'Total Stk' 'Total Stock'           'Total Stock'.
      PERFORM set_col USING lo_cols 'SFQTY'      'Safety'    'Safety Stock'          'Safety Stock'.
      PERFORM set_col USING lo_cols 'TOTREQ'     'Total Req' 'Total Requirement'     'Total Requirement'.
      PERFORM set_col USING lo_cols 'FRINV'      'Free Inv'  'Free Inventory'        'Free Inventory'.
      PERFORM set_col USING lo_cols 'ZRATE'      'Rate'      'Rate'                  'Valuation Rate'.
      PERFORM set_col USING lo_cols 'VALUE'      'Value'     'Value'                 'Total Value'.

      " Ageing (qty + value)
      PERFORM set_col USING lo_cols 'LT30'       '<30D'      '< 30 Days'             'Less than 30 Days'.
      PERFORM set_col USING lo_cols 'VLT30'      'Val <30'   'Value < 30'            'Value < 30 Days'.
      PERFORM set_col USING lo_cols 'BT30_60'    '30-60'     '30–60 Days'            'Between 30 and 60 Days'.
      PERFORM set_col USING lo_cols 'VBT30_60'   'Val 30-60' 'Value 30–60'           'Value 30–60 Days'.
      PERFORM set_col USING lo_cols 'BT60_90'    '60-90'     '60–90 Days'            'Between 60 and 90 Days'.
      PERFORM set_col USING lo_cols 'VBT60_90'   'Val 60-90' 'Value 60–90'           'Value 60–90 Days'.
      PERFORM set_col USING lo_cols 'BT90_120'   '90-120'    '90–120 Days'           'Between 90 and 120 Days'.
      PERFORM set_col USING lo_cols 'VBT90_120'  'Val 90-120' 'Value 90–120'          'Value 90–120 Days'.
      PERFORM set_col USING lo_cols 'BT120_150'  '120-150'   '120–150 Days'          'Between 120 and 150 Days'.

      PERFORM set_col USING lo_cols 'VBT120_150'  '120-150' 'Value 120–150' 'Value 120–150 Days'.

      PERFORM set_col USING lo_cols 'BT150_180'  '150-180'   '150–180 Days'          'Between 150 and 180 Days'.
      PERFORM set_col USING lo_cols 'VBT150_180' '150-180' 'Value 150–180'        'Value 150–180 Days'.
      PERFORM set_col USING lo_cols 'GT180'      '>180'      '> 180 Days'            'Greater than 180 Days'.
      PERFORM set_col USING lo_cols 'VGT180'     'Val >180'  'Value > 180'           'Value > 180 Days'.

      " Z-attributes & dates (if present)
      PERFORM set_col USING lo_cols 'ZSERIES'    'Series'    'Series'                'Series'.
      PERFORM set_col USING lo_cols 'ZSIZE'      'Size'      'Size'                  'Size'.
      PERFORM set_col USING lo_cols 'BRAND'      'Brand'     'Brand'                 'Brand'.
      PERFORM set_col USING lo_cols 'MOC'        'MOC'       'MOC'                   'MOC'.
      PERFORM set_col USING lo_cols 'TYPE'       'Type'      'Type'                  'Type'.
      PERFORM set_col USING lo_cols 'REF'        'Ref Date'  'Refresh Date'          'Refresh Date'.
      PERFORM set_col USING lo_cols 'BUDAT_MKPF' 'LastUsage' 'Last Usage Date'       'Last Usage Posting Date'.

      lo_alv->display( ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDFORM.

FORM set_col USING io_cols TYPE REF TO cl_salv_columns_table
                    iv_name TYPE lvc_fname
                    iv_s    TYPE scrtext_s
                    iv_m    TYPE scrtext_m
                    iv_l    TYPE scrtext_l.
  DATA lo_c TYPE REF TO cl_salv_column_table.
  TRY.
      lo_c ?= io_cols->get_column( iv_name ).
      lo_c->set_short_text(  iv_s ).
      lo_c->set_medium_text( iv_m ).
      lo_c->set_long_text(   iv_l ).
    CATCH cx_salv_not_found.  " column not in GT_OUT – ignore
  ENDTRY.
ENDFORM.                                                     " :contentReference[oaicite:24]{index=24}

*----------------------------------------------------------------------
* Download (unchanged)
*----------------------------------------------------------------------
FORM download_file.
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      filename              = p_file
*      filetype              = 'ASC'
*      write_field_separator = 'X'
*    TABLES
*      data_tab              = gt_out.

***------------------------------------------------------
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.


  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  REFRESH it_csv.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    EXPORTING
      i_field_seperator    = 'X'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = gt_out    "it_rslt                  "LT_FINAL
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  lv_file = 'ZMM_FRINVENTORY_NEWV1.TXT'.
      CONCATENATE p_file '/' LV_FILE
    INTO LV_FULLFILE.
  WRITE: / 'ZMM_FRINVENTORY started on', sy-datum, 'at', sy-uzeit.


  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT .  "ENCODING UTF-8.                 "ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_1581 TYPE string.
    DATA lv_crlf_1581 TYPE string.
    lv_crlf_1581 = cl_abap_char_utilities=>cr_lf.
    lv_string_1581 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1581 lv_crlf_1581 wa_csv INTO lv_string_1581.
      CLEAR: wa_csv.
    ENDLOOP.
*TRANSFER lv_string_2634 TO lv_fullfile.
*TRANSFER lv_string_1332 TO lv_fullfile.
*TRANSFER lv_string_1332 TO lv_fullfile.
*TRANSFER lv_string_734 TO lv_fullfile.
    TRANSFER lv_string_1581 TO lv_fullfile.
  ENDIF.
  CLOSE DATASET lv_fullfile.
  CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
  MESSAGE lv_msg TYPE 'S'.

ENDFORM.                                                          " :contentReference[oaicite:25]{index=25}
*&---------------------------------------------------------------------*
*& Form CVS_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE   'Plant'                      "1
                'Material'                   "2
                'Material Description'       "3
                'Unit'                       "4
                'Minimum Order Qty'          "5
                'Total Requirement'          "6
                'Subcontractor Stck.'        "7
*              'Stor. Loc.'                 "8
                'Matl Type'                  "9
                'FINISHED GOODS'        "sl1 "10
                'PRODUCTION'
*                'REJECTION'
                'RAW MATERIALS'         "sl2  11
                'REWORK'                "sl3  12
                'Subcon Stk Loc'        "sl4  13
*                'SCRAP'
                'WIP ASSEMBLED'         "sl5  14
                'FG Sales Return'       "sl6  15
                'SPARES & CONSUM'
                'SRN STORES'
                'THIRD PARTY INSP'      "sl7  16

                'VALIDATION'
                'QA OK STOCK SL'                                       " 25/05/2018
                'Planning'                                             " 25/05/2018
                'Unrestricted Stock'          " 17
                'In Quality Insp.'            "18
                'Total Stock'                 " 19
                'Safety stock'                "20
                'Free Inventory'              "21
                'Rate'                           "24 45
                '< 30 Days'                      "46
                'Value'                          "47
                'Btwn 30-60 Days'                "48
                'Value'                           "49
                'Btwn 60-90 Days'                "50
                'Value'                          "51
                'Btwn 90-120 Days'               "52
                'Value'                          "53
                'Btwn 120-150 Days'              "54
                'Value'                          "55
                'Btwn 150-180 Days'              "56
                'Value'                          "57
                '> 180 Days'                     "58
                'Value'                          "59
                'Value'                          "60
                'seri code'                      "61
                'size'                           "62
                'Brand'                          "63
                'MOC'                            "64
                'Type'                           "65
                'Refresh Date'                   "66
                'Last usage date'                     " 67
                'Blocked Stock'                     " 68
                'Sangavi Stock'                " 68
                'Machine Stock'                " 68
*********************ADDED BY JYTO ION 05.07.2024*******************
                 'KPR FINISHED GOODS'
                 'KPR PRODUCTION'
                 'KPR RAW MATERIALS'
                 'KPR REWORK'
                 'KPR Subcon Stk Loc'
                 'KPR WIP ASSEMBLED'
                 'KPR FG Sales Return'
                 'KPR SPARES & CONSUM'
                 'KPR SRN STORES'
                 'KPR THIRD PARTY INSP'
                 'KPR VALIDATION'
                 'KPR1'
                 'TYPE'
                 'REF Date'
                 'last usage date'

**********************************************************************
                INTO p_hd_csv
                SEPARATED BY l_field_seperator.
ENDFORM.
