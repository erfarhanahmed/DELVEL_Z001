REPORT zfree_inv_report_oops NO STANDARD PAGE HEADING.

*---------------------------------------------------------------------*
* Selection
*---------------------------------------------------------------------*
TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_mtart FOR mara-mtart.

PARAMETERS: p_werks  TYPE werks_d OBLIGATORY,
            p_treqfm TYPE abap_bool DEFAULT abap_true NO-DISPLAY,
            p_down   AS CHECKBOX,
            p_file   TYPE rlgrap-filename DEFAULT '/Delval/India'.

SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE text-010.
  SELECTION-SCREEN  COMMENT /1(79) text-011.
  SELECTION-SCREEN  COMMENT /1(79) text-012.
  SELECTION-SCREEN  COMMENT /1(79) text-013.
SELECTION-SCREEN: END OF BLOCK b3.

TYPES: ty_r_matnr TYPE RANGE OF mara-matnr,
       ty_r_mtart TYPE RANGE OF mara-mtart.


CONSTANTS: c_lang TYPE spras VALUE 'E'.

*---------------------------------------------------------------------*
* Exclusions / Ranges
*---------------------------------------------------------------------*
TYPES: r_lgort TYPE RANGE OF lgort_d.
DATA:  gr_excl_lgort TYPE r_lgort.

INITIALIZATION.
  gr_excl_lgort = VALUE r_lgort(
    ( sign = 'I' option = 'EQ' low = 'RJ01' )
    ( sign = 'I' option = 'EQ' low = 'SCR1' )
    ( sign = 'I' option = 'EQ' low = 'SRN1' )
    ( sign = 'I' option = 'EQ' low = 'SPC1' )
    ( sign = 'I' option = 'EQ' low = 'KRJ0' )
    ( sign = 'I' option = 'EQ' low = 'KSCR' )
    ( sign = 'I' option = 'EQ' low = 'KSRN' )
  ).

*---------------------------------------------------------------------*
* OOPS Class
*---------------------------------------------------------------------*
CLASS lcl_app DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
it_s_matnr TYPE ty_r_matnr
it_s_mtart TYPE ty_r_mtart
          iv_werks      TYPE werks_d
          iv_treqfm     TYPE abap_bool
          iv_down       TYPE abap_bool
          iv_file       TYPE rlgrap-filename
          it_excl_lgort TYPE r_lgort,
      run.

  PRIVATE SECTION.

    "OO FIX: packed type must have explicit length in OO context
    TYPES ty_p2 TYPE p LENGTH 16 DECIMALS 2.

    "==================== ORIGINAL TYPES / DATA ===================="
    TYPES: BEGIN OF ty_mat,
             matnr TYPE matnr,
             meins TYPE meins,
             mtart TYPE mtart,
             maktx TYPE maktx,
             werks TYPE werks,
             lgort TYPE lgort_d,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
           END OF ty_mat.
    DATA: gt_mat TYPE SORTED TABLE OF ty_mat WITH UNIQUE KEY matnr.

    TYPES: BEGIN OF ty_marc, matnr TYPE matnr, eisbe TYPE eisbe, END OF ty_marc.
    DATA: gt_marc TYPE SORTED TABLE OF ty_marc WITH UNIQUE KEY matnr.

    TYPES: BEGIN OF ty_mbew, matnr TYPE matnr, vprsv TYPE vprsv, verpr TYPE verpr, stprs TYPE stprs, END OF ty_mbew.
    DATA: gt_mbew TYPE TABLE OF ty_mbew.

    TYPES: BEGIN OF ty_moq, matnr TYPE matnr, minbm TYPE minbm, END OF ty_moq.
    DATA: gt_moq TYPE SORTED TABLE OF ty_moq WITH UNIQUE KEY matnr.

    TYPES: BEGIN OF ty_mslb, matnr TYPE matnr, sbcntr TYPE labst, END OF ty_mslb.
    DATA: gt_mslb TYPE SORTED TABLE OF ty_mslb WITH UNIQUE KEY matnr.

    TYPES: BEGIN OF ty_mard_sum, matnr TYPE matnr, lgort TYPE lgort_d, labst TYPE labst, insme TYPE insme, END OF ty_mard_sum.
    DATA:  gt_mard_sum TYPE STANDARD TABLE OF ty_mard_sum WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_mska_sum,
             matnr TYPE matnr,
             werks TYPE werks_d,
             lgort TYPE lgort_d,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
             kalab TYPE labst,
             kains TYPE insme,
           END OF ty_mska_sum.
    DATA:  gt_mska_sum TYPE STANDARD TABLE OF ty_mska_sum WITH DEFAULT KEY.
    DATA:  gt_ebew TYPE STANDARD TABLE OF ebew.

    TYPES: BEGIN OF ty_aufnr, aufnr TYPE aufnr, END OF ty_aufnr.
    DATA:  gt_open_ord TYPE SORTED TABLE OF ty_aufnr WITH UNIQUE KEY aufnr.

    TYPES: BEGIN OF ty_wip, matnr TYPE matnr, qty TYPE menge_d, END OF ty_wip.
    DATA:  gt_wip_sum TYPE SORTED TABLE OF ty_wip WITH UNIQUE KEY matnr.

    TYPES: BEGIN OF ty_out,
             werks       TYPE werks_d,
             matnr       TYPE matnr,
             maktx       TYPE maktx,
             meins       TYPE meins,
             minbm       TYPE minbm,
             totreq      TYPE menge_d,
             totstck     TYPE menge_d,
             totstck_val TYPE stprs,
             wip_qty     TYPE menge_d,
             wip_val     TYPE stprs,
             qa_qty      TYPE menge_d,
             qa_val      TYPE stprs,
             sbcn_qty    TYPE menge_d,
             sbcn_val    TYPE stprs,
             free_qty    TYPE menge_d,
             free_val    TYPE stprs,
             zrate       TYPE verpr,
             zsorate     TYPE verpr,
             insme       TYPE insme,
             mtart       TYPE mtart,
           END OF ty_out.
    DATA: gt_out TYPE STANDARD TABLE OF ty_out WITH DEFAULT KEY.

    TYPES: BEGIN OF itab,
             plant                   TYPE string,
             material                TYPE string,
             material_description    TYPE string,
             unit                    TYPE string,
             minimum_order_qty       TYPE string,
             total_requirement       TYPE string,
             total_stock_qty         TYPE string,
             total_stock_value       TYPE string,
             wip_qty                 TYPE string,
             wip_value               TYPE string,
             qa_stock_qty            TYPE string,
             qa_stock_value          TYPE string,
             subcontract_stock_qty   TYPE string,
             subcontract_stock_value TYPE string,
             free_stock_qty          TYPE string,
             free_stock_value        TYPE string,
             mtart                   TYPE string,
             ref                     TYPE char15,
             time                    TYPE char15,
           END OF itab.
    DATA: lt_final TYPE TABLE OF itab,
          ls_final TYPE itab.

    "==================== INPUTS STORED ===================="
    DATA: mt_s_matnr    TYPE RANGE OF matnr,
          mt_s_mtart    TYPE RANGE OF mtart,
          mv_werks      TYPE werks_d,
          mv_treqfm     TYPE abap_bool,
          mv_down       TYPE abap_bool,
          mv_file       TYPE rlgrap-filename,
          mt_excl_lgort TYPE r_lgort.

    "==================== METHODS (FORM -> METHOD) ===================="
    METHODS:
      fetch_materials,
      fetch_marc,
      fetch_mbew,
      fetch_moq,
      fetch_mslb,
      fetch_mard_agg,
      fetch_mska_agg,
      fetch_open_orders,
      fetch_wip_from_aufm,
      assemble_rows,
      display_salv,
      set_col
        IMPORTING
          io_cols TYPE REF TO cl_salv_columns_table
          iv_name TYPE lvc_fname
          iv_text TYPE csequence,
      download_file,
      cvs_header
        CHANGING
          cv_hd_csv TYPE LINE OF truxs_t_text_data.

ENDCLASS.

CLASS lcl_app IMPLEMENTATION.

  METHOD constructor.
    mt_s_matnr    = it_s_matnr.
    mt_s_mtart    = it_s_mtart.
    mv_werks      = iv_werks.
    mv_treqfm     = iv_treqfm.
    mv_down       = iv_down.
    mv_file       = iv_file.
    mt_excl_lgort = it_excl_lgort.
  ENDMETHOD.

  METHOD run.
    fetch_materials( ).
    IF gt_mat IS INITIAL.
      MESSAGE 'No materials for plant/filters' TYPE 'S'.
      RETURN.
    ENDIF.

    fetch_marc( ).
    fetch_mbew( ).
    fetch_moq( ).
    fetch_mslb( ).
    fetch_mard_agg( ).
    fetch_mska_agg( ).
    fetch_open_orders( ).
    fetch_wip_from_aufm( ).
    assemble_rows( ).

    IF mv_down = abap_true.
      download_file( ).
    ELSE.
      display_salv( ).
    ENDIF.
  ENDMETHOD.

*---------------------------------------------------------------------*
* Fetch materials (+ text) - ORIGINAL LOGIC
*---------------------------------------------------------------------*
  METHOD fetch_materials.
    DATA lt_mat TYPE STANDARD TABLE OF ty_mat.

    IF mt_s_matnr IS INITIAL AND mt_s_mtart IS INITIAL.
      SELECT a~matnr, a~meins, a~mtart, b~maktx
        FROM mara AS a
        INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @mv_werks
        LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
        INTO TABLE @lt_mat.
    ELSEIF mt_s_matnr IS INITIAL.
      SELECT a~matnr, a~meins, a~mtart, b~maktx
        FROM mara AS a
        INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @mv_werks
        LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
        INTO TABLE @lt_mat
        WHERE a~mtart IN @mt_s_mtart.
    ELSEIF mt_s_mtart IS INITIAL.
      SELECT a~matnr, a~meins, a~mtart, b~maktx
        FROM mara AS a
        INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @mv_werks
        LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
        INTO TABLE @lt_mat
        WHERE a~matnr IN @mt_s_matnr.
    ELSE.
      SELECT a~matnr, a~meins, a~mtart, b~maktx
        FROM mara AS a
        INNER JOIN marc AS c ON c~matnr = a~matnr AND c~werks = @mv_werks
        LEFT OUTER JOIN makt AS b ON b~matnr = a~matnr AND b~spras = @c_lang
        INTO TABLE @lt_mat
        WHERE a~matnr IN @mt_s_matnr
          AND a~mtart IN @mt_s_mtart.
    ENDIF.

    SORT lt_mat BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING matnr.
    gt_mat = lt_mat.
  ENDMETHOD.

  METHOD fetch_marc.
    IF mt_s_matnr IS INITIAL.
      SELECT matnr, eisbe
        FROM marc
        INTO TABLE @gt_marc
        WHERE werks = @mv_werks.
    ELSE.
      SELECT matnr, eisbe
        FROM marc
        INTO TABLE @gt_marc
        WHERE werks = @mv_werks
          AND matnr IN @mt_s_matnr.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_mbew.
    IF mt_s_matnr IS INITIAL.
      SELECT matnr, vprsv, verpr, stprs
        FROM mbew
        INTO TABLE @gt_mbew
        WHERE bwkey = @mv_werks.
    ELSE.
      SELECT matnr, vprsv, verpr, stprs
        FROM mbew
        INTO TABLE @gt_mbew
        WHERE bwkey = @mv_werks
          AND matnr IN @mt_s_matnr.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_moq.
    IF mt_s_matnr IS INITIAL.
      SELECT eina~matnr AS matnr, MAX( eine~minbm ) AS minbm
        FROM eine
        INNER JOIN eina ON eina~infnr = eine~infnr
        GROUP BY eina~matnr
        INTO TABLE @gt_moq.
    ELSE.
      SELECT eina~matnr AS matnr, MAX( eine~minbm ) AS minbm
        FROM eine
        INNER JOIN eina ON eina~infnr = eine~infnr
        WHERE eina~matnr IN @mt_s_matnr
        GROUP BY eina~matnr
        INTO TABLE @gt_moq.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_mslb.
    IF mt_s_matnr IS INITIAL.
      SELECT matnr, SUM( lblab ) AS sbcntr
        FROM mslb
        WHERE werks = @mv_werks
        GROUP BY matnr
        INTO TABLE @gt_mslb.
    ELSE.
      SELECT matnr, SUM( lblab ) AS sbcntr
        FROM mslb
        WHERE werks = @mv_werks
          AND matnr IN @mt_s_matnr
        GROUP BY matnr
        INTO TABLE @gt_mslb.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_mard_agg.
    IF mt_s_matnr IS INITIAL.
      SELECT matnr, lgort,
             SUM( labst ) AS labst,
             SUM( insme ) AS insme
        FROM mard
        WHERE werks = @mv_werks
          AND diskz <> '1'
          AND lgort NOT IN @mt_excl_lgort
        GROUP BY matnr, lgort
        INTO TABLE @gt_mard_sum.
    ELSE.
      SELECT matnr, lgort,
             SUM( labst ) AS labst,
             SUM( insme ) AS insme
        FROM mard
        WHERE werks = @mv_werks
          AND matnr IN @mt_s_matnr
          AND diskz <> '1'
          AND lgort NOT IN @mt_excl_lgort
        GROUP BY matnr, lgort
        INTO TABLE @gt_mard_sum.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_mska_agg.
    IF mt_s_matnr IS INITIAL.
      SELECT matnr, werks, lgort, vbeln, posnr, kalab, kains
        FROM mska
        WHERE werks = @mv_werks
          AND lgort NOT IN @mt_excl_lgort
        INTO TABLE @gt_mska_sum.
    ELSE.
      SELECT matnr, werks, lgort, vbeln, posnr, kalab, kains
        FROM mska
        WHERE werks = @mv_werks
          AND matnr IN @mt_s_matnr
          AND lgort NOT IN @mt_excl_lgort
        INTO TABLE @gt_mska_sum.
    ENDIF.

    IF gt_mska_sum IS NOT INITIAL.
      SELECT *
        FROM ebew
        INTO TABLE gt_ebew
        FOR ALL ENTRIES IN gt_mska_sum
        WHERE matnr = gt_mska_sum-matnr
          AND bwkey = gt_mska_sum-werks
          AND vbeln = gt_mska_sum-vbeln
          AND posnr = gt_mska_sum-posnr.
    ENDIF.
  ENDMETHOD.

  METHOD fetch_open_orders.
    TYPES: BEGIN OF ty_afpo,
             aufnr TYPE afpo-aufnr,
             werks TYPE afpo-pwerk,
             wemng TYPE afpo-wemng,
             psmng TYPE afpo-psmng,
           END OF ty_afpo.

    DATA: lt_afpo TYPE STANDARD TABLE OF ty_afpo,
          ls_afpo TYPE ty_afpo.

    CLEAR gt_open_ord.

    SELECT aufnr, pwerk, wemng, psmng
      FROM afpo
      INTO TABLE @lt_afpo
      WHERE pwerk = @mv_werks.

    LOOP AT lt_afpo INTO ls_afpo.
      IF ls_afpo-wemng < ls_afpo-psmng.
        INSERT VALUE #( aufnr = ls_afpo-aufnr ) INTO TABLE gt_open_ord.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD fetch_wip_from_aufm.
    DATA: lt_open_aufnr TYPE STANDARD TABLE OF aufnr,
          lv_aufnr      TYPE aufnr.

    CLEAR gt_wip_sum.
    IF gt_open_ord IS INITIAL.
      RETURN.
    ENDIF.

    DATA ls_open TYPE ty_aufnr.
    LOOP AT gt_open_ord INTO ls_open.
      lv_aufnr = ls_open-aufnr.
      APPEND lv_aufnr TO lt_open_aufnr.
    ENDLOOP.
    IF lt_open_aufnr IS INITIAL.
      RETURN.
    ENDIF.

    TYPES: BEGIN OF ty_aufm_row,
             matnr TYPE aufm-matnr,
             menge TYPE aufm-menge,
             bwart TYPE aufm-bwart,
             aufnr TYPE aufm-aufnr,
           END OF ty_aufm_row.

    DATA: lt_aufm TYPE STANDARD TABLE OF ty_aufm_row,
          ls_aufm TYPE ty_aufm_row.

    SELECT matnr, menge, bwart, aufnr
      FROM aufm
      INTO TABLE @lt_aufm
      FOR ALL ENTRIES IN @lt_open_aufnr
      WHERE aufnr = @lt_open_aufnr-table_line
        AND werks = @mv_werks
        AND bwart IN ( '261', '262' )
        AND matnr IS NOT NULL.

    TYPES: BEGIN OF ty_sum,
             matnr TYPE matnr,
             qty   TYPE menge_d,
           END OF ty_sum.

    DATA: lt_net TYPE HASHED TABLE OF ty_sum WITH UNIQUE KEY matnr,
          ls_net TYPE ty_sum,
          lv_sign TYPE i.

    LOOP AT lt_aufm INTO ls_aufm.
      IF ls_aufm-bwart = '261'.
        lv_sign = 1.
      ELSEIF ls_aufm-bwart = '262'.
        lv_sign = -1.
      ELSE.
        CONTINUE.
      ENDIF.

      CLEAR ls_net.
      ls_net-matnr = ls_aufm-matnr.
      ls_net-qty   = lv_sign * ls_aufm-menge.
      COLLECT ls_net INTO lt_net.
    ENDLOOP.

    DATA ls_outw TYPE ty_sum.
    LOOP AT lt_net INTO ls_outw.
      IF ls_outw-qty IS NOT INITIAL.
        INSERT VALUE #( matnr = ls_outw-matnr qty = ls_outw-qty )
          INTO TABLE gt_wip_sum.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*---------------------------------------------------------------------*
* Assemble rows - ORIGINAL LOGIC + OO packed-length fix
*---------------------------------------------------------------------*
  METHOD assemble_rows.
    DATA ls_mat  TYPE ty_mat.
    DATA ls_marc TYPE ty_marc.
    DATA ls_mbew TYPE ty_mbew.
    DATA ls_ebew TYPE ebew.
    DATA ls_moq  TYPE ty_moq.
    DATA ls_mslb TYPE ty_mslb.
    DATA ls_out  TYPE ty_out.
    DATA ls_wip  TYPE ty_wip.

    DATA: lv_own_unrst TYPE menge_d VALUE 0,
          lv_own_insme TYPE insme   VALUE 0,
          lv_k_unrst   TYPE menge_d VALUE 0,
          lv_k_insme   TYPE insme   VALUE 0,
          lv_frinv     TYPE menge_d VALUE 0.

    " OO FIX: use explicit packed type with length
    DATA: lv_own_unrst_val TYPE ty_p2,
          lv_own_insme_val TYPE ty_p2,
          lv_k_unrst_val   TYPE ty_p2,
          lv_k_insme_val   TYPE ty_p2.

    CLEAR: gt_out, lt_final.

    LOOP AT gt_mat INTO ls_mat.
      CLEAR: ls_out, ls_wip,
             lv_own_unrst, lv_own_insme, lv_k_unrst, lv_k_insme, lv_frinv,
             lv_own_unrst_val, lv_own_insme_val, lv_k_unrst_val, lv_k_insme_val.

      ls_out-werks = mv_werks.
      ls_out-matnr = ls_mat-matnr.
      ls_out-maktx = ls_mat-maktx.
      ls_out-meins = ls_mat-meins.
      ls_out-mtart = ls_mat-mtart.

      READ TABLE gt_marc WITH KEY matnr = ls_mat-matnr INTO ls_marc.

      READ TABLE gt_mbew WITH KEY matnr = ls_mat-matnr INTO ls_mbew.
      IF sy-subrc = 0.
        IF ls_mbew-vprsv = 'V'.
          ls_out-zrate = ls_mbew-verpr.
        ELSEIF ls_mbew-vprsv = 'S'.
          ls_out-zrate = ls_mbew-stprs.
        ELSE.
          ls_out-zrate = 0.
        ENDIF.
      ENDIF.

      READ TABLE gt_moq WITH KEY matnr = ls_mat-matnr INTO ls_moq.
      IF sy-subrc = 0.
        ls_out-minbm = ls_moq-minbm.
      ENDIF.

      READ TABLE gt_mslb WITH KEY matnr = ls_mat-matnr INTO ls_mslb.
      IF sy-subrc = 0.
        ls_out-sbcn_qty = ls_mslb-sbcntr.
      ENDIF.

      LOOP AT gt_mard_sum ASSIGNING FIELD-SYMBOL(<m>) WHERE matnr = ls_mat-matnr.
        lv_own_unrst = lv_own_unrst + <m>-labst.
        lv_own_insme = lv_own_insme + <m>-insme.
      ENDLOOP.

      lv_own_unrst_val = lv_own_unrst * ls_out-zrate.
      lv_own_insme_val = lv_own_insme * ls_out-zrate.

      LOOP AT gt_mska_sum ASSIGNING FIELD-SYMBOL(<k>) WHERE matnr = ls_mat-matnr AND kalab NE '0.000'.
        lv_k_unrst = lv_k_unrst + <k>-kalab.
        READ TABLE gt_ebew INTO ls_ebew WITH KEY matnr = ls_mat-matnr
                                                bwkey = <k>-werks
                                                vbeln = <k>-vbeln
                                                posnr = <k>-posnr.
        IF sy-subrc = 0.
          IF ls_ebew-vprsv = 'V'.
            lv_own_unrst_val = lv_own_unrst_val + ( <k>-kalab * ls_ebew-verpr ).
          ELSEIF ls_ebew-vprsv = 'S'.
            lv_own_unrst_val = lv_own_unrst_val + ( <k>-kalab * ls_ebew-stprs ).
          ELSE.
            lv_own_unrst_val = 0.
          ENDIF.
        ENDIF.
      ENDLOOP.

      LOOP AT gt_mska_sum ASSIGNING <k> WHERE matnr = ls_mat-matnr AND kains NE '0.000'.
        lv_k_insme = lv_k_insme + <k>-kains.
        READ TABLE gt_ebew INTO ls_ebew WITH KEY matnr = ls_mat-matnr
                                                bwkey = <k>-werks
                                                vbeln = <k>-vbeln
                                                posnr = <k>-posnr.
        IF sy-subrc = 0.
          IF ls_ebew-vprsv = 'V'.
            lv_own_insme_val = lv_own_insme_val + ( <k>-kains * ls_ebew-verpr ).
          ELSEIF ls_ebew-vprsv = 'S'.
            lv_own_insme_val = lv_own_insme_val + ( <k>-kains * ls_ebew-stprs ).
          ELSE.
            lv_own_insme_val = 0.
          ENDIF.
        ENDIF.
      ENDLOOP.

      ls_out-insme   = lv_own_insme + lv_k_insme.
      ls_out-totstck = lv_own_unrst + lv_k_unrst.

      IF mv_treqfm = abap_true AND ls_out-totstck > 0.
        DATA lt_mdps TYPE TABLE OF mdps.
        DATA ls_mdps TYPE mdps.

        CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
          EXPORTING
            matnr = ls_mat-matnr
            werks = mv_werks
          TABLES
            mdpsx = lt_mdps.

        LOOP AT lt_mdps INTO ls_mdps.
          IF ls_mdps-delkz = 'VC' OR ls_mdps-delkz = 'SB'
           OR ls_mdps-delkz = 'U1' OR ls_mdps-delkz = 'U2'
           OR ls_mdps-delkz = 'PP'
           OR ( ls_mdps-delkz = 'BB' AND ls_mdps-plaab <> 26 )
           OR ( ls_mdps-delkz = 'AR' AND ls_mdps-plumi <> '+' )
           OR ( ls_mdps-delkz = 'KB' AND ls_mdps-plumi <> 'B' ).
            ls_out-totreq = ls_out-totreq + ls_mdps-mng01.
          ENDIF.
        ENDLOOP.
      ENDIF.

      READ TABLE gt_wip_sum WITH KEY matnr = ls_mat-matnr INTO ls_wip.
      IF sy-subrc = 0 AND ls_wip-qty > 0.
        ls_out-wip_qty = ls_wip-qty.
      ELSE.
        ls_out-wip_qty = 0.
      ENDIF.

      ls_out-totstck_val = lv_own_unrst_val.
      ls_out-wip_val     = ls_out-wip_qty * ls_out-zrate.
      ls_out-qa_qty      = ls_out-insme.
      ls_out-qa_val      = lv_own_insme_val.
      ls_out-sbcn_val    = ls_out-sbcn_qty * ls_out-zrate.

      lv_frinv = ( ls_out-totstck + ls_out-wip_qty + ls_out-qa_qty + ls_out-sbcn_qty ) - ls_out-totreq.
      IF lv_frinv < 0.
        lv_frinv = 0.
      ENDIF.

      ls_out-free_qty = lv_frinv.
      ls_out-free_val = ls_out-free_qty * ls_out-zrate.

      CLEAR ls_final.
      ls_final-plant                   = |{ ls_out-werks }|.
      ls_final-material                = |{ ls_out-matnr }|.
      ls_final-material_description    = |{ ls_out-maktx }|.
      ls_final-unit                    = |{ ls_out-meins }|.
      ls_final-minimum_order_qty       = |{ ls_out-minbm }|.
      ls_final-total_requirement       = |{ ls_out-totreq }|.
      ls_final-total_stock_qty         = |{ ls_out-totstck }|.
      ls_final-total_stock_value       = |{ ls_out-totstck_val }|.
      ls_final-wip_qty                 = |{ ls_out-wip_qty }|.
      ls_final-wip_value               = |{ ls_out-wip_val }|.
      ls_final-qa_stock_qty            = |{ ls_out-qa_qty }|.
      ls_final-qa_stock_value          = |{ ls_out-qa_val }|.
      ls_final-subcontract_stock_qty   = |{ ls_out-sbcn_qty }|.
      ls_final-subcontract_stock_value = |{ ls_out-sbcn_val }|.
      ls_final-free_stock_qty          = |{ ls_out-free_qty }|.
      ls_final-free_stock_value        = |{ ls_out-free_val }|.
      ls_final-mtart                   = |{ ls_out-mtart }|.

      ls_final-ref = sy-datum.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-ref
        IMPORTING
          output = ls_final-ref.

      CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
        INTO ls_final-ref SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO ls_final-time SEPARATED BY ':'.

      IF ls_out-free_qty <> 0.
        APPEND ls_final TO lt_final.
        APPEND ls_out   TO gt_out.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

*---------------------------------------------------------------------*
* Display SALV (ORIGINAL)
*---------------------------------------------------------------------*
  METHOD display_salv.
    DATA lo_alv   TYPE REF TO cl_salv_table.
    DATA lo_cols  TYPE REF TO cl_salv_columns_table.
    DATA lo_funcs TYPE REF TO cl_salv_functions_list.

    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = lo_alv
          CHANGING  t_table      = gt_out ).

        lo_funcs = lo_alv->get_functions( ).
        lo_funcs->set_all( abap_true ).

        lo_alv->get_columns( )->set_optimize( abap_false ).
        lo_cols = lo_alv->get_columns( ).

        set_col( io_cols = lo_cols iv_name = 'WERKS'       iv_text = 'Plant' ).
        set_col( io_cols = lo_cols iv_name = 'MATNR'       iv_text = 'Material' ).
        set_col( io_cols = lo_cols iv_name = 'MAKTX'       iv_text = 'Material Description' ).
        set_col( io_cols = lo_cols iv_name = 'MEINS'       iv_text = 'Unit' ).
        set_col( io_cols = lo_cols iv_name = 'MINBM'       iv_text = 'Minimum Order Qty' ).
        set_col( io_cols = lo_cols iv_name = 'TOTREQ'      iv_text = 'Total Requirement' ).
        set_col( io_cols = lo_cols iv_name = 'TOTSTCK'     iv_text = 'Total Stock Quantity' ).
        set_col( io_cols = lo_cols iv_name = 'TOTSTCK_VAL' iv_text = 'Total Stock Value' ).
        set_col( io_cols = lo_cols iv_name = 'WIP_QTY'     iv_text = 'WIP Quantity' ).
        set_col( io_cols = lo_cols iv_name = 'WIP_VAL'     iv_text = 'WIP Value' ).
        set_col( io_cols = lo_cols iv_name = 'QA_QTY'      iv_text = 'QA Stock Quantity' ).
        set_col( io_cols = lo_cols iv_name = 'QA_VAL'      iv_text = 'QA Stock Value' ).
        set_col( io_cols = lo_cols iv_name = 'SBCN_QTY'    iv_text = 'SubContract Stock Quantity' ).
        set_col( io_cols = lo_cols iv_name = 'SBCN_VAL'    iv_text = 'SubContract Stock Value' ).
        set_col( io_cols = lo_cols iv_name = 'FREE_QTY'    iv_text = 'Free Stock Quantity' ).
        set_col( io_cols = lo_cols iv_name = 'FREE_VAL'    iv_text = 'Free Stock Value' ).

        TRY. lo_cols->get_column( 'ZRATE' )->set_visible( abap_false ). CATCH cx_salv_not_found. ENDTRY.
        TRY. lo_cols->get_column( 'INSME' )->set_visible( abap_false ). CATCH cx_salv_not_found. ENDTRY.

        lo_alv->display( ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDMETHOD.

  METHOD set_col.
    DATA lo_c TYPE REF TO cl_salv_column_table.
    DATA lv_s TYPE scrtext_s.
    DATA lv_m TYPE scrtext_m.
    DATA lv_l TYPE scrtext_l.

    lv_l = iv_text.
    lv_m = iv_text.
    lv_s = iv_text.

    TRY.
        lo_c ?= io_cols->get_column( iv_name ).
        lo_c->set_short_text(  lv_s ).
        lo_c->set_medium_text( lv_m ).
        lo_c->set_long_text(   lv_l ).
        lo_c->set_visible( abap_true ).
      CATCH cx_salv_not_found.
    ENDTRY.
  ENDMETHOD.

*---------------------------------------------------------------------*
* Download (ORIGINAL)
*---------------------------------------------------------------------*
  METHOD download_file.
    DATA: it_csv TYPE truxs_t_text_data,
          wa_csv TYPE LINE OF truxs_t_text_data,
          hd_csv TYPE LINE OF truxs_t_text_data.

    REFRESH it_csv.

    CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
      EXPORTING
        i_field_seperator    = 'X'
      TABLES
        i_tab_sap_data       = lt_final
      CHANGING
        i_tab_converted_data = it_csv
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    DATA: lv_file     TYPE string,
          lv_fullfile TYPE string.

    cvs_header( CHANGING cv_hd_csv = hd_csv ).
    lv_file = 'ZMM_INVENTORY_NEWV2.TXT'.
    CONCATENATE mv_file '/' lv_file INTO lv_fullfile.

    OPEN DATASET lv_fullfile FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      DATA lv_crlf TYPE string.
      DATA lv_str  TYPE string.

      lv_crlf = cl_abap_char_utilities=>cr_lf.
      lv_str  = hd_csv.

      LOOP AT it_csv INTO wa_csv.
        CONCATENATE lv_str lv_crlf wa_csv INTO lv_str.
        CLEAR wa_csv.
      ENDLOOP.

      TRANSFER lv_str TO lv_fullfile.
      CLOSE DATASET lv_fullfile.
      MESSAGE |File { lv_fullfile } downloaded| TYPE 'S'.
    ELSE.
      MESSAGE 'Cannot open file for output' TYPE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD cvs_header.
    DATA l_tab TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.
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
      INTO cv_hd_csv SEPARATED BY l_tab.
  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* Main
*---------------------------------------------------------------------*
START-OF-SELECTION.

  "Keep original behavior: exclude UNBW
  s_mtart-sign   = 'I'.
  s_mtart-option = 'NE'.
  s_mtart-low    = 'UNBW'.
  APPEND s_mtart.

  DATA lo_app TYPE REF TO lcl_app.

  CREATE OBJECT lo_app
    EXPORTING
      it_s_matnr    = s_matnr[]
      it_s_mtart    = s_mtart[]
      iv_werks      = p_werks
      iv_treqfm     = p_treqfm
      iv_down       = p_down
      iv_file       = p_file
      it_excl_lgort = gr_excl_lgort.

  lo_app->run( ).
