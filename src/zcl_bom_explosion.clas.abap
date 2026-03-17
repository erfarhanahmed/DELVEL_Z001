CLASS zcl_bom_explosion DEFINITION
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

ENDCLASS.



CLASS zcl_bom_explosion IMPLEMENTATION.
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
  -- Level 1: explode header material iv_matnr
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
      AND m.matnr = :iv_matnr
      AND m.werks = :iv_werks;

  ----------------------------------------------------------------------
  -- Init empty result
  ----------------------------------------------------------------------
  lt_result =
    SELECT
      0 AS seq,
      root_matnr, parent_matnr, matnr, bom, bom_level,
      isassembly, posnr, menge, meins
    FROM :lt_level
    WHERE 1 = 0;

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

ENDCLASS.

