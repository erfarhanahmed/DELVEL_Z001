CLASS zcl_bom_explosion_NEW DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    "=== Original BOM type (AMDP output) =================================
    TYPES:
      BEGIN OF ty_bom_item,
        root_matnr   TYPE abomitems-billofmaterialcomponent,
        parent_matnr TYPE abomitems-billofmaterialcomponent,
        matnr        TYPE abomitems-billofmaterialcomponent,
        bom          TYPE mast-stlnr,
        bom_level    TYPE i,
        isassembly   TYPE abomitems-isassembly,
        posnr        TYPE stpo-posnr,
        zeinr        TYPE mara-zeinr,
        menge        TYPE stpo-menge,
        meins        TYPE stpo-meins,
        mtart        TYPE mara-mtart,
        verpr        TYPE mbew-verpr,
      END OF ty_bom_item,
      tt_bom_item TYPE STANDARD TABLE OF ty_bom_item
                  WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_bom_item_mass,
        root_matnr   TYPE abomitems-billofmaterialcomponent,
        parent_matnr TYPE abomitems-billofmaterialcomponent,
        matnr        TYPE abomitems-billofmaterialcomponent,
        bom          TYPE mast-stlnr,
        bom_level    TYPE i,
        isassembly   TYPE abomitems-isassembly,
        posnr        TYPE stpo-posnr,
        zeinr        TYPE mara-zeinr,
        menge        TYPE stpo-menge,
        meins        TYPE stpo-meins,
        BILLOFMATERIALITEMCATEGORY        type stpo-POSTP,
        mtart        TYPE mara-mtart,
        verpr        TYPE mbew-verpr,
        refresh_date  TYPE char11,
      END OF ty_bom_item_mass,
       tt_bom_item_mass TYPE STANDARD TABLE OF ty_bom_item_mass
                  WITH EMPTY KEY.
    "=== Extended type: BOM + material long text =========================
    TYPES:
      BEGIN OF ty_bom_item_with_text,
        root_matnr    TYPE abomitems-billofmaterialcomponent,
        parent_matnr  TYPE abomitems-billofmaterialcomponent,
        matnr         TYPE abomitems-billofmaterialcomponent,
        bom           TYPE mast-stlnr,
        bom_level     TYPE i,
        isassembly    TYPE abomitems-isassembly,
        posnr         TYPE stpo-posnr,
        zeinr         TYPE mara-zeinr,
        menge         TYPE stpo-menge,
        meins         TYPE stpo-meins,
        mtart         TYPE mara-mtart,
        verpr         TYPE mbew-verpr,
        material_text TYPE string,
      END OF ty_bom_item_with_text,
      tt_bom_item_with_text TYPE STANDARD TABLE OF ty_bom_item_with_text
                            WITH EMPTY KEY.
          TYPES:
      BEGIN OF ty_bom_item_with_text_mass,
        root_matnr    TYPE abomitems-billofmaterialcomponent,
        parent_matnr  TYPE abomitems-billofmaterialcomponent,
        matnr         TYPE abomitems-billofmaterialcomponent,
        bom           TYPE mast-stlnr,
        bom_level     TYPE i,
        bom_level_v   TYPE char11,
        isassembly    TYPE abomitems-isassembly,
        posnr         TYPE stpo-posnr,
        zeinr         TYPE mara-zeinr,
        menge         TYPE stpo-menge,
        meins         TYPE stpo-meins,
         BILLOFMATERIALITEMCATEGORY        type stpo-POSTP,
        mtart         TYPE mara-mtart,
        verpr         TYPE mbew-verpr,
        material_text TYPE string,
        MATERIAL_TEXT_ES TYPE string,
        refresh_date TYPE char11,
      END OF ty_bom_item_with_text_mass,
      tt_bom_item_with_text_mass TYPE STANDARD TABLE OF ty_bom_item_with_text_mass
                            WITH EMPTY KEY.

TYPES:
  BEGIN OF ty_matnr_key,
    matnr TYPE mast-matnr,  "elementary
  END OF ty_matnr_key,
  tt_matnr TYPE STANDARD TABLE OF ty_matnr_key WITH EMPTY KEY.

    "=== AMDP: BOM explosion =============================================
    CLASS-METHODS explode_bom
      AMDP OPTIONS READ-ONLY
                   CDS SESSION CLIENT CURRENT
      IMPORTING
        VALUE(iv_matnr) TYPE mast-matnr
        VALUE(iv_werks) TYPE mast-werks
      EXPORTING
        VALUE(et_result) TYPE tt_bom_item
      RAISING
        cx_amdp_error.

    "=== Wrapper: BOM + material long text ==============================
    CLASS-METHODS explode_bom_with_text
      IMPORTING
        VALUE(iv_matnr) TYPE mast-matnr
        VALUE(iv_werks) TYPE mast-werks
      EXPORTING
        VALUE(et_result) TYPE tt_bom_item_with_text.

CLASS-METHODS explode_bom_mass
  AMDP OPTIONS READ-ONLY
               CDS SESSION CLIENT CURRENT
  IMPORTING
  VALUE(iv_use_open_so) TYPE abap_bool
    VALUE(it_matnr) TYPE tt_matnr
    VALUE(iv_werks) TYPE mast-werks
    VALUE(iv_andat)       TYPE mast-andat
  EXPORTING
    VALUE(et_result) TYPE tt_bom_item_mass
  RAISING
    cx_amdp_error.

"=== Wrapper: MASS BOM + material long text ============================
CLASS-METHODS explode_bom_mass_with_text
  IMPORTING
    VALUE(iv_use_open_so) TYPE abap_bool
    VALUE(it_matnr) TYPE tt_matnr
    VALUE(iv_werks) TYPE mast-werks
    VALUE(iv_andat)       TYPE mast-andat
  EXPORTING
    VALUE(et_result) TYPE tt_bom_item_with_text_MASS.


ENDCLASS.



CLASS zcl_bom_explosion_NEW IMPLEMENTATION.
METHOD explode_bom BY DATABASE PROCEDURE
                   FOR HDB
                   LANGUAGE SQLSCRIPT
                   OPTIONS READ-ONLY
                   USING mast abomitems stpo mara mbew.

  ----------------------------------------------------------------------
  -- Level table
  ----------------------------------------------------------------------
  DECLARE lt_level TABLE (
    root_matnr     "$ABAP.type( abomitems-billofmaterialcomponent )",
    parent_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr          "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom            "$ABAP.type( mast-stlnr )",
    bom_level      INT,
    isassembly     "$ABAP.type( abomitems-isassembly )",
    posnr          "$ABAP.type( stpo-posnr )",
    menge          "$ABAP.type( stpo-menge )",
    meins          "$ABAP.type( stpo-meins )"
  );

  ----------------------------------------------------------------------
  -- Result with internal sequence (NOT returned to ABAP)
  ----------------------------------------------------------------------
  DECLARE lt_result TABLE (
    seq           INT,
    root_matnr    "$ABAP.type( abomitems-billofmaterialcomponent )",
    parent_matnr  "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr         "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom           "$ABAP.type( mast-stlnr )",
    bom_level     INT,
    isassembly    "$ABAP.type( abomitems-isassembly )",
    posnr         "$ABAP.type( stpo-posnr )",
    menge         "$ABAP.type( stpo-menge )",
    meins         "$ABAP.type( stpo-meins )"
  );

  ----------------------------------------------------------------------
  -- Stack tables
  ----------------------------------------------------------------------
  DECLARE lt_stack TABLE (
    stack_pos      INT,
    root_matnr     "$ABAP.type( abomitems-billofmaterialcomponent )",
    parent_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr          "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom            "$ABAP.type( mast-stlnr )",
    bom_level      INT,
    isassembly     "$ABAP.type( abomitems-isassembly )",
    posnr          "$ABAP.type( stpo-posnr )",
    menge          "$ABAP.type( stpo-menge )",
    meins          "$ABAP.type( stpo-meins )"
  );

  DECLARE lt_curr TABLE (
    root_matnr     "$ABAP.type( abomitems-billofmaterialcomponent )",
    parent_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr          "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom            "$ABAP.type( mast-stlnr )",
    bom_level      INT,
    isassembly     "$ABAP.type( abomitems-isassembly )",
    posnr          "$ABAP.type( stpo-posnr )",
    menge          "$ABAP.type( stpo-menge )",
    meins          "$ABAP.type( stpo-meins )"
  );

  DECLARE lt_children TABLE (
    root_matnr     "$ABAP.type( abomitems-billofmaterialcomponent )",
    parent_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr          "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom            "$ABAP.type( mast-stlnr )",
    bom_level      INT,
    isassembly     "$ABAP.type( abomitems-isassembly )",
    posnr          "$ABAP.type( stpo-posnr )",
    menge          "$ABAP.type( stpo-menge )",
    meins          "$ABAP.type( stpo-meins )"
  );

  ----------------------------------------------------------------------
  -- Scalars
  ----------------------------------------------------------------------
  DECLARE lv_stack_pos  INT;
  DECLARE lv_max_pos    INT;
  DECLARE lv_isassembly "$ABAP.type( abomitems-isassembly )";
  DECLARE lv_bom_level  INT;
  DECLARE lv_seq        INT;

  ----------------------------------------------------------------------
  -- Level 1: explode INNERder material iv_matnr
  ----------------------------------------------------------------------
  lt_level =
    SELECT
      m.matnr                   AS root_matnr,
      m.matnr                   AS parent_matnr,
      a.billofmaterialcomponent AS matnr,
      a.billofmaterial          AS bom,
      1                         AS bom_level,
      a.isassembly              AS isassembly,
      s.posnr                   AS posnr,
      s.menge                   AS menge,
      s.meins                   AS meins
    FROM mast AS m
    INNER JOIN abomitems AS a
      ON a.mandt          = m.mandt
     AND a.billofmaterial = m.stlnr
    INNER JOIN stpo AS s
      ON s.mandt = a.mandt
     AND s.stlnr = a.billofmaterial
     AND s.idnrk = a.billofmaterialcomponent
    WHERE m.mandt = SESSION_CONTEXT( 'CLIENT' )
      AND a.mandt = SESSION_CONTEXT( 'CLIENT' )
      AND s.mandt = SESSION_CONTEXT( 'CLIENT' )
      AND m.matnr = :iv_matnr;
*     INNER AND m.werks = :iv_werks;

 ----------------------------------------------------------------------
  -- Init empty result
  ----------------------------------------------------------------------
****  lt_result =
****    SELECT
****      0 AS seq,
****      root_matnr, parent_matnr, matnr, bom, bom_level,
****      isassembly, posnr, menge, meins
****    FROM :lt_level
****    INNERNERERE 1 = 0;

  ----------------------------------------------------------------------
  -- Push initial lt_level into stack (process lowest POSNR first)
  -- Pop uses MAX(stack_pos), so assign stack_pos by posnr DESC.
  ----------------------------------------------------------------------
  lt_stack =
    SELECT
      ROW_NUMBER() OVER (ORDER BY posnr DESC) AS stack_pos,
      root_matnr, parent_matnr, matnr, bom, bom_level,
      isassembly, posnr, menge, meins
    FROM :lt_level;

  ----------------------------------------------------------------------
  -- ABAP-like processing
  ----------------------------------------------------------------------
  WHILE record_count( :lt_stack ) > 0
  DO
    -- POP
    SELECT MAX(stack_pos)
      INTO lv_stack_pos
      FROM :lt_stack;

    lt_curr =
      SELECT
        root_matnr, parent_matnr, matnr, bom, bom_level,
        isassembly, posnr, menge, meins
      FROM :lt_stack
      WHERE stack_pos = :lv_stack_pos;

    lt_stack =
      SELECT * FROM :lt_stack
      WHERE stack_pos <> :lv_stack_pos;

    -- seq++ and append current row (always)
    SELECT COALESCE(MAX(seq), 0) + 1
      INTO lv_seq
      FROM :lt_result;

    lt_result =
      SELECT * FROM :lt_result
      UNION ALL
      SELECT
        :lv_seq AS seq,
        root_matnr, parent_matnr, matnr, bom, bom_level,
        isassembly, posnr, menge, meins
      FROM :lt_curr;

    -- flags
    SELECT TOP 1 COALESCE(isassembly,'')
      INTO lv_isassembly
      FROM :lt_curr;

    SELECT TOP 1 bom_level
      INTO lv_bom_level
      FROM :lt_curr;

    -- if assembly => explode children and push (deep before next sibling)
    IF lv_isassembly = 'X' AND lv_bom_level < 50 THEN

      lt_children =
        SELECT
          c.root_matnr               AS root_matnr,
          c.matnr                    AS parent_matnr,
          a2.billofmaterialcomponent AS matnr,
          a2.billofmaterial          AS bom,
          c.bom_level + 1            AS bom_level,
          a2.isassembly              AS isassembly,
          s2.posnr                   AS posnr,
          s2.menge                   AS menge,
          s2.meins                   AS meins
        FROM :lt_curr AS c
        INNER JOIN mast AS m2
          ON m2.mandt = SESSION_CONTEXT( 'CLIENT' )
         AND m2.matnr = c.matnr
         AND m2.werks = :iv_werks
        INNER JOIN abomitems AS a2
          ON a2.mandt          = m2.mandt
         AND a2.billofmaterial = m2.stlnr
        INNER JOIN stpo AS s2
          ON s2.mandt = a2.mandt
         AND s2.stlnr = a2.billofmaterial
         AND s2.idnrk = a2.billofmaterialcomponent
        WHERE a2.mandt = SESSION_CONTEXT( 'CLIENT' )
          AND s2.mandt = SESSION_CONTEXT( 'CLIENT' )
         AND COALESCE( a2.engineeringchangedocforedit, '' ) = '';
      SELECT COALESCE(MAX(stack_pos), 0)
        INTO lv_max_pos
        FROM :lt_stack;

      lt_stack =
        SELECT * FROM :lt_stack
        UNION ALL
        SELECT
          :lv_max_pos + ROW_NUMBER() OVER (ORDER BY posnr DESC) AS stack_pos,
          root_matnr, parent_matnr, matnr, bom, bom_level,
          isassembly, posnr, menge, meins
        FROM :lt_children;

    END IF;

  END WHILE;

  ----------------------------------------------------------------------
  -- Final output: header row first (seq=0) + all result rows (seq>=1)
  -- ORDER BY seq guarantees header is at the top.
  ----------------------------------------------------------------------
  et_result =
    SELECT
      r.root_matnr,
      r.parent_matnr,
      r.matnr,
      r.bom,
      r.bom_level,
      r.isassembly,
      r.posnr,
      ma.zeinr,
      r.menge,
      r.meins,
      ma.mtart,
      mb.verpr
    FROM (
        SELECT
          0         AS seq,
          :iv_matnr AS root_matnr,
          :iv_matnr AS parent_matnr,
          :iv_matnr AS matnr,
          ''        AS bom,
          0         AS bom_level,
          ''        AS isassembly,
          ''        AS posnr,
          0         AS menge,
          ''        AS meins
        FROM dummy

        UNION ALL

        SELECT
          seq,
          root_matnr,
          parent_matnr,
          matnr,
          bom,
          bom_level,
          isassembly,
          posnr,
          menge,
          meins
        FROM :lt_result
    ) AS r
    LEFT OUTER JOIN mara AS ma
      ON ma.mandt = SESSION_CONTEXT( 'CLIENT' )
     AND ma.matnr = r.matnr
    LEFT OUTER JOIN mbew AS mb
      ON mb.mandt = SESSION_CONTEXT( 'CLIENT' )
     AND mb.matnr = r.matnr
     AND mb.bwkey = :iv_werks
    ORDER BY r.seq;

ENDMETHOD.





  METHOD explode_bom_with_text.

    TYPES: BEGIN OF ty_mat_text,
             matnr         TYPE matnr,
             material_text TYPE string,
           END OF ty_mat_text.
    TYPES: tt_mat_text TYPE HASHED TABLE OF ty_mat_text
                       WITH UNIQUE KEY matnr.

    DATA: lt_bom_base    TYPE tt_bom_item,
          lt_bom_full    TYPE tt_bom_item_with_text,
          lt_matnr_keys  TYPE SORTED TABLE OF matnr
                                     WITH UNIQUE KEY table_line,
          lt_texts       TYPE tt_mat_text,
          ls_text        TYPE ty_mat_text,
          ls_bom_base    TYPE ty_bom_item,
          ls_bom_full    TYPE ty_bom_item_with_text,
          lv_matnr       TYPE matnr,
          lv_matnr_alpha TYPE matnr,
          lt_lines       TYPE STANDARD TABLE OF tline,
          ls_line        TYPE tline,
          lv_text        TYPE string,
          lv_name        TYPE thead-tdname.

    "1) Call AMDP to get BOM details
    explode_bom(
      EXPORTING
        iv_matnr  = iv_matnr
        iv_werks  = iv_werks
      IMPORTING
        et_result = lt_bom_base ).

    "2) Collect distinct material numbers
    LOOP AT lt_bom_base INTO ls_bom_base.
      lv_matnr = ls_bom_base-matnr.
      INSERT lv_matnr INTO TABLE lt_matnr_keys.
    ENDLOOP.

    "3) Read GRUN long text once per material
    LOOP AT lt_matnr_keys INTO lv_matnr.

      CLEAR: lt_lines, lv_text, ls_text.

      lv_matnr_alpha = lv_matnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_matnr_alpha
        IMPORTING
          output = lv_matnr_alpha.

      lv_name = lv_matnr_alpha.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id       = 'GRUN'
          language = 'E'
          name     = lv_name
          object   = 'MATERIAL'
        TABLES
          lines    = lt_lines
        EXCEPTIONS
          id              = 1
          language        = 2
          name            = 3
          not_found       = 4
          object          = 5
          reference_check = 6
          OTHERS          = 7.

      IF sy-subrc = 0 AND lt_lines IS NOT INITIAL.
        LOOP AT lt_lines INTO ls_line.
          IF lv_text IS INITIAL.
            lv_text = ls_line-tdline.
          ELSE.
            CONCATENATE lv_text ls_line-tdline
                   INTO lv_text
                   SEPARATED BY space.
          ENDIF.
        ENDLOOP.
      ENDIF.

      ls_text-matnr         = lv_matnr.
      ls_text-material_text = lv_text.
      INSERT ls_text INTO TABLE lt_texts.

    ENDLOOP.

    "4) Merge BOM fields + material_text into final table
    CLEAR lt_bom_full.

    LOOP AT lt_bom_base INTO ls_bom_base.

      CLEAR ls_bom_full.

      "Explicit mapping of all BOM fields:
      ls_bom_full-root_matnr   = ls_bom_base-root_matnr.
      ls_bom_full-parent_matnr = ls_bom_base-parent_matnr.
      ls_bom_full-matnr        = ls_bom_base-matnr.
      ls_bom_full-bom          = ls_bom_base-bom.
      ls_bom_full-bom_level    = ls_bom_base-bom_level.
      ls_bom_full-isassembly   = ls_bom_base-isassembly.
      ls_bom_full-posnr        = ls_bom_base-posnr.
      ls_bom_full-zeinr        = ls_bom_base-zeinr.
      ls_bom_full-menge        = ls_bom_base-menge.
      ls_bom_full-meins        = ls_bom_base-meins.
      ls_bom_full-mtart        = ls_bom_base-mtart.
      ls_bom_full-verpr        = ls_bom_base-verpr.

      CLEAR ls_bom_full-material_text.
      READ TABLE lt_texts INTO ls_text
           WITH TABLE KEY matnr = ls_bom_base-matnr.
      IF sy-subrc = 0.
        ls_bom_full-material_text = ls_text-material_text.
      ENDIF.

      APPEND ls_bom_full TO lt_bom_full.

    ENDLOOP.

    et_result = lt_bom_full.

  ENDMETHOD.

METHOD explode_bom_mass BY DATABASE PROCEDURE
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING mast abomitems stpo mara mbew
                        vbap mara STKO .

  ----------------------------------------------------------------------
  -- Declarations MUST be first in SQLScript
  ----------------------------------------------------------------------
  DECLARE lv_mandt NVARCHAR(3);

  DECLARE lt_input_matnr TABLE (
    matnr "$ABAP.type( mast-matnr )"
  );

  DECLARE lt_roots TABLE (
    root_matnr "$ABAP.type( mast-matnr )",
    root_ord   INT
  );

  DECLARE lt_mast TABLE (
    matnr "$ABAP.type( mast-matnr )",
    stlnr "$ABAP.type( mast-stlnr )"
  );

  DECLARE lt_edges TABLE (
    parent_matnr "$ABAP.type( mast-matnr )",
    matnr        "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom          "$ABAP.type( mast-stlnr )",
    bom_isassm   "$ABAP.type( abomitems-isassembly )",
    posnr        "$ABAP.type( stpo-posnr )",
    menge        "$ABAP.type( stpo-menge )",
    meins        "$ABAP.type( stpo-meins )",
    BILLOFMATERIALITEMCATEGORY  "$ABAP.type( stpo-POSTP )",
    ecd          NVARCHAR(60)
  );

  DECLARE lt_flat TABLE (
    root_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    root_ord     INT,
    parent_matnr "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr        "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom          "$ABAP.type( mast-stlnr )",
    bom_level    INT,
    isassembly   "$ABAP.type( abomitems-isassembly )",
    posnr        "$ABAP.type( stpo-posnr )",
    menge        "$ABAP.type( stpo-menge )",
    meins        "$ABAP.type( stpo-meins )",
    BILLOFMATERIALITEMCATEGORY  "$ABAP.type( stpo-POSTP )",
    sort_path    NVARCHAR(500),
    ecd          NVARCHAR(60),
    refresh_date "$ABAP.type( char11 )"
  );

  -- Iteration tables (same structure as lt_flat)
  DECLARE lt_curr TABLE (
    root_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    root_ord     INT,
    parent_matnr "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr        "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom          "$ABAP.type( mast-stlnr )",
    bom_level    INT,
    isassembly   "$ABAP.type( abomitems-isassembly )",
    posnr        "$ABAP.type( stpo-posnr )",
    menge        "$ABAP.type( stpo-menge )",
    meins        "$ABAP.type( stpo-meins )",
    BILLOFMATERIALITEMCATEGORY  "$ABAP.type( stpo-POSTP )",
    sort_path    NVARCHAR(500),
    ecd          NVARCHAR(60),
     refresh_date "$ABAP.type( char11 )"
  );

  DECLARE lt_next TABLE (
    root_matnr   "$ABAP.type( abomitems-billofmaterialcomponent )",
    root_ord     INT,
    parent_matnr "$ABAP.type( abomitems-billofmaterialcomponent )",
    matnr        "$ABAP.type( abomitems-billofmaterialcomponent )",
    bom          "$ABAP.type( mast-stlnr )",
    bom_level    INT,
    isassembly   "$ABAP.type( abomitems-isassembly )",
    posnr        "$ABAP.type( stpo-posnr )",
    menge        "$ABAP.type( stpo-menge )",
    meins        "$ABAP.type( stpo-meins )",
     BILLOFMATERIALITEMCATEGORY  "$ABAP.type( stpo-POSTP )",
    sort_path    NVARCHAR(500),
    ecd          NVARCHAR(60),
      refresh_date "$ABAP.type( char11 )"
  );

  ----------------------------------------------------------------------
  -- Executable statements
  ----------------------------------------------------------------------
  lv_mandt := SESSION_CONTEXT('CLIENT');

    IF :iv_use_open_so = 'X' THEN

    lt_input_matnr =
      SELECT DISTINCT
        vbap.matnr AS matnr
      FROM vbap
      inner join mara
      on mara.matnr = vbap.matnr
      WHERE vbap.mandt = :lv_mandt
        AND vbap.werks = :iv_werks
        AND COALESCE(vbap.abgru,'') = ''        -- not rejected
      AND COALESCE(vbap.gbsta,'') <> 'C'        -- item overall status not completed
        AND vbap.matnr IS NOT NULL
        AND vbap.matnr <> ''
        and mara.MTART = 'FERT';

  ELSE

    lt_input_matnr =
      SELECT DISTINCT matnr
      FROM :it_matnr
      WHERE matnr IS NOT NULL
        AND matnr <> '';

  END IF;



*lt_roots =
*    SELECT
*      matnr AS root_matnr,
*      ROW_NUMBER() OVER (ORDER BY matnr) AS root_ord
*    FROM :lt_input_matnr;

*  lt_mast =
*    SELECT mast.matnr, mast.stlnr
*    FROM mast
*    WHERE mast.mandt = :lv_mandt
*      AND werks = :iv_werks
*      ;


lt_mast =
  SELECT
    mst.matnr,
    mst.stlnr
  FROM mast AS mst
  WHERE mst.mandt = :lv_mandt
    AND mst.werks = :iv_werks
    and mst.ANDAT <= :iv_andat
    AND EXISTS (
      SELECT 1
      FROM stko AS k
      WHERE k.mandt = mst.mandt
        AND k.stlnr = mst.stlnr
        AND k.stlal = mst.stlal
        AND k.stlst = '01'          -- ACTIVE BOM
    );

lt_roots =
  SELECT
    i.matnr AS root_matnr,
    ROW_NUMBER() OVER (ORDER BY i.matnr) AS root_ord
  FROM :lt_input_matnr AS i
  INNER JOIN :lt_mast AS m
    ON m.matnr = i.matnr;



  lt_edges =
    SELECT
      m.matnr                   AS parent_matnr,
      a.billofmaterialcomponent AS matnr,
      a.billofmaterial          AS bom,
      a.isassembly              AS bom_isassm,
      s.posnr                   AS posnr,
      s.menge                   AS menge,
      s.meins                   AS meins,
      a.BILLOFMATERIALITEMCATEGORY as BILLOFMATERIALITEMCATEGORY,
      COALESCE(a.engineeringchangedocforedit, '') AS ecd
    FROM :lt_mast AS m
    INNER JOIN abomitems AS a
      ON a.mandt          = :lv_mandt
     AND a.billofmaterial = m.stlnr
    INNER JOIN stpo AS s
      ON s.mandt = :lv_mandt
     AND s.stlnr = a.billofmaterial
     AND s.idnrk = a.billofmaterialcomponent;

  ----------------------------------------------------------------------
  -- Level 1
  ----------------------------------------------------------------------
  lt_curr =
    SELECT
      r.root_matnr AS root_matnr,
      r.root_ord   AS root_ord,
      r.root_matnr AS parent_matnr,

      e.matnr      AS matnr,
      e.bom        AS bom,
      1            AS bom_level,
      e.bom_isassm AS isassembly,
      e.posnr      AS posnr,
      e.menge      AS menge,
      e.meins      AS meins,
      E.BILLOFMATERIALITEMCATEGORY  as  BILLOFMATERIALITEMCATEGORY,
      LPAD(CAST(r.root_ord AS NVARCHAR(10)), 10, '0')
        || '/' ||
      LPAD(CAST(e.posnr    AS NVARCHAR(10)), 4,  '0') AS sort_path,
      e.ecd        AS ecd,
*      CURRENT_DATE AS refresh_date
*      LOWER( TO_VARCHAR( CURRENT_DATE, 'DDMONYYYY' ) ) AS refresh_date
LPAD(TO_VARCHAR(DAYOFMONTH(CURRENT_DATE)), 2, '0')
|| '-' ||
CASE MONTH(CURRENT_DATE)
  WHEN 1  THEN 'jan' WHEN 2  THEN 'feb' WHEN 3  THEN 'mar'
  WHEN 4  THEN 'apr' WHEN 5  THEN 'may' WHEN 6  THEN 'jun'
  WHEN 7  THEN 'jul' WHEN 8  THEN 'aug' WHEN 9  THEN 'sep'
  WHEN 10 THEN 'oct' WHEN 11 THEN 'nov' WHEN 12 THEN 'dec'
END
|| '-' ||
TO_VARCHAR(YEAR(CURRENT_DATE))  AS refresh_date

    FROM :lt_roots AS r
    INNER JOIN :lt_edges AS e
      ON e.parent_matnr = r.root_matnr;

  -- Init flat result with level 1 (or empty)
  lt_flat = SELECT * FROM :lt_curr;

  ----------------------------------------------------------------------
  -- Expand children level-by-level (no recursive CTE => no BOM_TREE)
  ----------------------------------------------------------------------
  WHILE record_count(:lt_curr) > 0 DO

    lt_next =
      SELECT
        t.root_matnr AS root_matnr,
        t.root_ord   AS root_ord,
        t.matnr      AS parent_matnr,
        e.matnr      AS matnr,
        e.bom        AS bom,
        t.bom_level + 1 AS bom_level,
        e.bom_isassm AS isassembly,
        e.posnr      AS posnr,
        e.menge      AS menge,
        e.meins      AS meins,
         E.BILLOFMATERIALITEMCATEGORY  as  BILLOFMATERIALITEMCATEGORY,
        t.sort_path || '/' || LPAD(CAST(e.posnr AS NVARCHAR(10)), 4, '0') AS sort_path,
        e.ecd        AS ecd,
*         CURRENT_DATE AS refresh_date
LPAD(TO_VARCHAR(DAYOFMONTH(CURRENT_DATE)), 2, '0')
|| '-' ||
CASE MONTH(CURRENT_DATE)
  WHEN 1  THEN 'jan' WHEN 2  THEN 'feb' WHEN 3  THEN 'mar'
  WHEN 4  THEN 'apr' WHEN 5  THEN 'may' WHEN 6  THEN 'jun'
  WHEN 7  THEN 'jul' WHEN 8  THEN 'aug' WHEN 9  THEN 'sep'
  WHEN 10 THEN 'oct' WHEN 11 THEN 'nov' WHEN 12 THEN 'dec'
END
|| '-' ||
TO_VARCHAR(YEAR(CURRENT_DATE))  AS refresh_date
      FROM :lt_curr AS t
      INNER JOIN :lt_edges AS e
        ON e.parent_matnr = t.matnr
      WHERE t.isassembly = 'X'
        AND t.bom_level < 50
        AND COALESCE(e.ecd, '') = '';

    -- Append next level into flat
    lt_flat =
      SELECT * FROM :lt_flat
      UNION ALL
      SELECT * FROM :lt_next;

    -- Move forward
    lt_curr = SELECT * FROM :lt_next;

  END WHILE;

  ----------------------------------------------------------------------
  -- Final output (header row per root + exploded rows)
  ----------------------------------------------------------------------
  et_result =
    SELECT
      r.root_matnr,
      r.parent_matnr,
      r.matnr,
      r.bom,
      r.bom_level,
      r.isassembly,
      r.posnr,
      ma.zeinr,
      r.menge,
      r.meins,
      r.BILLOFMATERIALITEMCATEGORY  as  BILLOFMATERIALITEMCATEGORY,
      ma.mtart,
      mb.verpr,
      r.refresh_date
    FROM (
      -- header row per root
      SELECT
        root_ord,
        0 AS seq,
        root_matnr AS root_matnr,
        root_matnr AS parent_matnr,
        root_matnr AS matnr,
        '' AS bom,
        0  AS bom_level,
        '' AS isassembly,
        '' AS posnr,
        0  AS menge,
        '' AS meins,
        '' as BILLOFMATERIALITEMCATEGORY,
*        '' as refresh_date
  LPAD(TO_VARCHAR(DAYOFMONTH(CURRENT_DATE)), 2, '0')
  || '-' ||
  CASE MONTH(CURRENT_DATE)
    WHEN 1  THEN 'jan' WHEN 2  THEN 'feb' WHEN 3  THEN 'mar'
    WHEN 4  THEN 'apr' WHEN 5  THEN 'may' WHEN 6  THEN 'jun'
    WHEN 7  THEN 'jul' WHEN 8  THEN 'aug' WHEN 9  THEN 'sep'
    WHEN 10 THEN 'oct' WHEN 11 THEN 'nov' WHEN 12 THEN 'dec'
  END
  || '-' ||
  TO_VARCHAR(YEAR(CURRENT_DATE)) AS refresh_date
      FROM :lt_roots

      UNION ALL

      -- exploded rows
      SELECT
        root_ord,
        ROW_NUMBER() OVER (PARTITION BY root_matnr ORDER BY sort_path) AS seq,
        root_matnr,
        parent_matnr,
        matnr,
        bom,
        bom_level,
        isassembly,
        posnr,
        menge,
        meins,
        BILLOFMATERIALITEMCATEGORY,
        refresh_date
      FROM :lt_flat
    ) AS r
    LEFT OUTER JOIN mara AS ma
      ON ma.mandt = :lv_mandt
     AND ma.matnr = r.matnr
    LEFT OUTER JOIN mbew AS mb
      ON mb.mandt = :lv_mandt
     AND mb.matnr = r.matnr
     AND mb.bwkey = :iv_werks
    ORDER BY r.root_ord, r.seq;

ENDMETHOD.

METHOD explode_bom_mass_with_text.

  TYPES: BEGIN OF ty_mat_text,
           matnr         TYPE matnr,
           material_text TYPE string,
           material_text_ES TYPE string,
         END OF ty_mat_text.
  TYPES tt_mat_text TYPE HASHED TABLE OF ty_mat_text
                    WITH UNIQUE KEY matnr.

  DATA: lt_bom_base    TYPE tt_bom_item_mass,
        lt_bom_full    TYPE tt_bom_item_with_text_mass,
        lt_matnr_keys  TYPE SORTED TABLE OF matnr WITH UNIQUE KEY table_line,
*        lt_matnr_keys  TYPE hASHED TABLE OF matnr WITH UNIQUE KEY table_line,
        lt_texts       TYPE tt_mat_text,
        ls_text        TYPE ty_mat_text,
        ls_bom_base    TYPE ty_bom_item_mass,
        ls_bom_full    TYPE ty_bom_item_with_text_mass,
        lv_matnr       TYPE matnr,
        lv_matnr_alpha TYPE matnr,
        lt_lines       TYPE STANDARD TABLE OF tline,
        lt_lines_ES   TYPE STANDARD TABLE OF tline,
        ls_line        TYPE tline,
        ls_line_ES        TYPE tline,
        lv_text        TYPE string,
        lv_text_ES        TYPE string,
        lv_tdname TYPE stxh-tdname,
        lt_tdname_keys TYPE SORTED TABLE OF stxh-tdname
                     WITH UNIQUE KEY table_line,
        lv_name        TYPE thead-tdname.
*        IT_STXH       TYPE TABLE OF STXH   .
types:bEGIN OF ty_stxh,
      TDNAME tyPE TDNAME,
      TDSPRAS tYPE TDSPRAS,
      enD OF ty_STXH.
*DATA: it_stxh TYPE sORTED TABLE OF ty_stxh
*             WITH UNIQUE KEY tdname TDSPRAS,
*     wa_stxh type ty_STXH.
DATA: t_matnr TYPE TABLE of FSH_S_MATNR.

TYPES: BEGIN OF ty_matnr,
       matnr TYPE TDOBNAME,
       END OF ty_matnr.
DATA: lt_matnr TYPE STANDARD TABLE OF ty_matnr.

  CLEAR et_result.
  IF it_matnr IS INITIAL.
    RETURN.
  ENDIF.

  "1) Call MASS AMDP to get BOM details for all roots
  explode_bom_mass(
    EXPORTING
    iv_use_open_so = iv_use_open_so
      it_matnr  = it_matnr
      iv_werks  = iv_werks
      iv_andat  = iv_andat
    IMPORTING
      et_result = lt_bom_base ).

*t_matnr = VALUE #(
*  FOR GROUPS g OF ls_bom IN lt_bom_base
*    GROUP BY ( matnr = ls_bom-matnr )
*  (
*    sign   = 'I'
*    option = 'EQ'
*    low    = |{ g-matnr ALPHA = IN }|
*    high   = ''
*  )
*).

lt_matnr = VALUE #(
  FOR GROUPS g OF ls_bom IN lt_bom_base
    GROUP BY ( matnr = ls_bom-matnr )
  ( |{ g-matnr ALPHA = IN }| )
).
IF lt_matnr[] IS NOT INITIAL.
*   SELECT  TDNAME,
*         TDSPRAS
*    FROM stxh
*    INTO TABLE @DATA(it_stxh)
*    WHERE tdobject = 'MATERIAL'
*      AND tdid     = 'GRUN'
*      AND tdname  in  @t_matnr.
  SELECT tdname,
         tdspras
    FROM stxh
    INTO TABLE @DATA(it_stxh)
    FOR ALL ENTRIES IN @lt_matnr
    WHERE tdobject = 'MATERIAL'
      AND tdid     = 'GRUN'
      AND tdname   = @lt_matnr-MATNR.
endif.
  "2) Collect distinct material numbers from result (includes header rows)
*  LOOP AT lt_bom_base INTO ls_bom_base.
*    IF ls_bom_base-matnr IS NOT INITIAL.
*      lv_matnr = ls_bom_base-matnr.
*       lv_tdname = ls_bom_base-matnr.
*      INSERT lv_matnr INTO TABLE lt_matnr_keys.
*       APPEND lv_tdname TO lt_tdname_keys.
*    ENDIF.
*  ENDLOOP.

  "3) Read GRUN long text once per material
*  LOOP AT lt_matnr_keys INTO lv_matnr.
SORT it_stxh by tdname tdspras.
  loop AT it_stxh into DATA(wa_stxh).
*    CLEAR: lt_lines, lv_text, ls_text.

*    lv_matnr_alpha = lv_matnr.
    lv_matnr_alpha = wa_stxh-TDNAME.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_matnr_alpha
      IMPORTING
        output = lv_matnr_alpha.

    lv_name = lv_matnr_alpha.

if  wa_stxh-TDSPRAS = 'E'.
    "Try logon language first, then fallback to 'E'
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'GRUN'
        language = sy-langu
        name     = lv_name
        object   = 'MATERIAL'
      TABLES
        lines    = lt_lines
      EXCEPTIONS
        OTHERS   = 1.

    IF sy-subrc <> 0 OR lt_lines IS INITIAL.
      CLEAR lt_lines.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id       = 'GRUN'
          language = 'E'
          name     = lv_name
          object   = 'MATERIAL'
        TABLES
          lines    = lt_lines
        EXCEPTIONS
          OTHERS   = 1.
    ENDIF.

    IF lt_lines IS NOT INITIAL.
      LOOP AT lt_lines INTO ls_line.
        IF lv_text IS INITIAL.
          lv_text = ls_line-tdline.
        ELSE.
          CONCATENATE lv_text ls_line-tdline INTO lv_text SEPARATED BY space.
        ENDIF.
      ENDLOOP.
    ENDIF.
       ENDIF.
********ES  Spanish
if wa_stxh-TDSPRAS = 'S'.
   CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id       = 'GRUN'
        language = 'S'
        name     = lv_name
        object   = 'MATERIAL'
      TABLES
        lines    =  lt_lines_ES
      EXCEPTIONS
        OTHERS   = 1.
       IF lt_lines_ES IS NOT INITIAL.
      LOOP AT lt_lines_ES INTO ls_line_ES.
        IF lv_text_ES IS INITIAL.
          lv_text_ES = ls_line_ES-tdline.
        ELSE.
          CONCATENATE lv_text_ES ls_line_ES-tdline INTO lv_text_ES  SEPARATED BY space.
        ENDIF.
      ENDLOOP.
    ENDIF.


endIF.

at END OF tdname.
    ls_text-matnr         = LV_NAME.
    ls_text-material_text = lv_text.
    ls_text-material_text_ES = lv_text_ES .
    INSERT ls_text INTO TABLE lt_texts.
    CLEAR:LV_TEXT,LV_TEXT_ES.
  FREE : lt_lines_ES, lt_lines.
ENDAT.

CLEAR:wa_stxh,lv_matnr_alpha,lv_name.
  ENDLOOP.


DATA:  anz_stufe(11)  TYPE c.
  "4) Merge BOM fields + material_text into final table (keep same order)
  LOOP AT lt_bom_base INTO ls_bom_base.

    CLEAR ls_bom_full.

    ls_bom_full-root_matnr   = ls_bom_base-root_matnr.
    ls_bom_full-parent_matnr = ls_bom_base-parent_matnr.
    ls_bom_full-matnr        = ls_bom_base-matnr.
    ls_bom_full-bom          = ls_bom_base-bom.
    ls_bom_full-bom_level    = ls_bom_base-bom_level.
*    ls_bom_full-BOM_LEVEL_V  = ls_bom_full-bom_level.
      anz_stufe = ls_bom_full-bom_level.
      TRANSLATE anz_stufe USING ' .'.
      anz_stufe+10(1) = ' '.
       IF ls_bom_base-bom_level < 9.
     ls_bom_full-BOM_LEVEL_V = 9 - ls_bom_full-bom_level.
    SHIFT anz_stufe BY ls_bom_full-BOM_LEVEL_V PLACES.
*    stb-stufe = 9 - stb-stufe.
   ls_bom_full-BOM_LEVEL_V   = anz_stufe.
  ENDIF.

    ls_bom_full-isassembly   = ls_bom_base-isassembly.
    ls_bom_full-posnr        = ls_bom_base-posnr.
    ls_bom_full-zeinr        = ls_bom_base-zeinr.
    ls_bom_full-menge        = ls_bom_base-menge.
    ls_bom_full-meins        = ls_bom_base-meins.
    ls_bom_full-mtart        = ls_bom_base-mtart.
    ls_bom_full-verpr        = ls_bom_base-verpr.
   ls_bom_full-BILLOFMATERIALITEMCATEGORY = ls_bom_base-BILLOFMATERIALITEMCATEGORY.
   if   ls_bom_base-REFRESH_DATE is NOT INITIAL.
*   ls_bom_full-REFRESH_DATE = |{ ls_bom_base-REFRESH_DATE+8(2) }-{ ls_bom_base-REFRESH_DATE+5(2) }-{ ls_bom_base-REFRESH_DATE+0(4) }| .
ls_bom_full-REFRESH_DATE =  ls_bom_base-REFRESH_DATE .
   endif.
    CLEAR ls_bom_full-material_text.
    READ TABLE lt_texts INTO ls_text WITH TABLE KEY matnr = ls_bom_base-matnr.
    IF sy-subrc = 0.
      ls_bom_full-material_text = ls_text-material_text.
      ls_bom_full-MATERIAL_TEXT_ES = ls_text-MATERIAL_TEXT_ES.
    ENDIF.

    APPEND ls_bom_full TO lt_bom_full.

  ENDLOOP.

  et_result = lt_bom_full.

ENDMETHOD.

ENDCLASS.

