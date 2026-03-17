CLASS zcl_multilevel_bom_explosion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_details.
*      AMDP OPTIONS READ-ONLY               " client-safe + read-only
*                   CDS SESSION CLIENT CURRENT
*      IMPORTING
*        VALUE(iv_matnr) TYPE idnrk
*      EXPORTING
*        VALUE(et_result) TYPE ztt_bom_final.

ENDCLASS.



CLASS ZCL_MULTILEVEL_BOM_EXPLOSION IMPLEMENTATION.


  METHOD get_details.
*      BY DATABASE PROCEDURE
*      FOR HDB
*      LANGUAGE SQLSCRIPT
*      OPTIONS READ-ONLY
*      USING .
*
*    DECLARE lt_result TABLE (
*        root_matnr      NVARCHAR(40),
*        parent_matnr    NVARCHAR(40),
*        matnr           NVARCHAR(40),
*        bom             NVARCHAR(40),
*        bom_level       INTEGER,
*        isassembly      NVARCHAR(1)
*    );
*
*    lt_result =
*        SELECT *
*        FROM (
*            WITH RECURSIVE bom_cte (
*                root_matnr,
*                parent_matnr,
*                matnr,
*                bom,
*                bom_level,
*                isassembly
*            ) AS (
*
*                -- Level 1
*                SELECT
*                    m.matnr AS root_matnr,
*                    m.matnr AS parent_matnr,
*                    a.billofmaterialcomponent AS matnr,
*                    a.billofmaterial AS bom,
*                    1 AS bom_level,
*                    a.isassembly AS isassembly
*                FROM mast AS m
*                INNER JOIN abomitems AS a
*                    ON a.mandt = m.mandt
*                    AND a.billofmaterial = m.stlnr
*                WHERE m.mandt = SESSION_CONTEXT('CLIENT')
*                  AND a.mandt = SESSION_CONTEXT('CLIENT')
*                  AND m.matnr = :iv_matnr
*
*                UNION ALL
*
*                -- Recursive
*                SELECT
*                    c.root_matnr,
*                    c.matnr AS parent_matnr,
*                    a2.billofmaterialcomponent,
*                    a2.billofmaterial,
*                    c.bom_level + 1,
*                    a2.isassembly
*                FROM bom_cte AS c
*                INNER JOIN mast AS m2
*                    ON m2.mandt = SESSION_CONTEXT('CLIENT')
*                    AND m2.matnr = c.matnr
*                INNER JOIN abomitems AS a2
*                    ON a2.mandt = m2.mandt
*                    AND a2.billofmaterial = m2.stlnr
*                WHERE c.isassembly = 'X'
*                  AND c.bom_level < 50
*            )
*            SELECT
*                root_matnr,
*                parent_matnr,
*                matnr,
*                bom,
*                bom_level,
*                isassembly
*            FROM bom_cte
*            ORDER BY bom_level, parent_matnr, matnr
*        ) AS sub;
*
*    et_result = :lt_result;

  ENDMETHOD.
ENDCLASS.
