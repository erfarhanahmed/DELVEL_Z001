CLASS zcl_bom_compo_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    TYPES: BEGIN OF ty_mast_makt,
             matnr TYPE mast-matnr,
             maktx TYPE makt-maktx,
             werks TYPE mast-werks,
             stlan TYPE mast-stlan,
             stlnr TYPE mast-stlnr,
             stlal TYPE mast-stlal,
             stlst TYPE stko-stlst,
           END OF ty_mast_makt,
           tt_mast_makt TYPE STANDARD TABLE OF ty_mast_makt WITH EMPTY KEY.

    TYPES: BEGIN OF ty_stko,
             stlnr TYPE stko-stlnr,
             stlty TYPE stko-stlty,
             bmein TYPE stko-bmein,
             bmeng TYPE stko-bmeng,
             stlst TYPE stko-stlst,
             stlal TYPE stko-stlal,
             annam TYPE stko-annam,
           END OF ty_stko,
           tt_stko TYPE STANDARD TABLE OF ty_stko WITH EMPTY KEY.

    TYPES: BEGIN OF ty_stas,
             stlty TYPE stas-stlty,
             stlnr TYPE stas-stlnr,
             stlal TYPE stas-stlal,
             stlkn TYPE stas-stlkn,
             stasz TYPE stas-stasz,
           END OF ty_stas,
           tt_stas TYPE STANDARD TABLE OF ty_stas WITH EMPTY KEY.

    TYPES: BEGIN OF ty_stpo,
             stlnr TYPE stpo-stlnr,
             stlkn TYPE stpo-stlkn,
             andat TYPE stpo-andat,
             aedat TYPE stpo-aedat,
             aenam TYPE stpo-aenam,
             stpoz TYPE stpo-stpoz,
             aennr TYPE stpo-aennr,
             vgknt TYPE stpo-vgknt,
             vgpzl TYPE stpo-vgpzl,
             idnrk TYPE stpo-idnrk,
             meins TYPE stpo-meins,
             menge TYPE stpo-menge,
             datuv TYPE stpo-datuv,
             postp TYPE stpo-postp,
             posnr TYPE stpo-posnr,
           END OF ty_stpo,
           tt_stpo TYPE STANDARD TABLE OF ty_stpo WITH EMPTY KEY.

    TYPES: BEGIN OF ty_marc,
             matnr TYPE marc-matnr,
             lvorm TYPE marc-lvorm,
           END OF ty_marc,
           tt_marc TYPE STANDARD TABLE OF ty_marc WITH EMPTY KEY.

 CLASS-METHODS get_data
  IMPORTING
    VALUE(iv_where)     TYPE string
  EXPORTING
    VALUE(et_mast_makt) TYPE tt_mast_makt
    VALUE(et_stko)      TYPE tt_stko
    VALUE(et_stas)      TYPE tt_stas
    VALUE(et_stpo)      TYPE tt_stpo
    VALUE(et_marc)      TYPE tt_marc.

ENDCLASS.


CLASS zcl_bom_compo_amdp IMPLEMENTATION.

  METHOD get_data
  BY DATABASE PROCEDURE FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING mast makt stko stas stpo marc.

  DECLARE lt_base TABLE (
    matnr NVARCHAR(18),
    maktx NVARCHAR(40),
    werks NVARCHAR(4),
    stlan NVARCHAR(1),
    stlnr NVARCHAR(8),
    stlal NVARCHAR(2),
    stlst NVARCHAR(2)
  );

  lt_base =
    SELECT
      mast.matnr AS matnr,
      makt.maktx AS maktx,
      mast.werks AS werks,
      mast.stlan AS stlan,
      mast.stlnr AS stlnr,
      mast.stlal AS stlal,
      stko.stlst AS stlst
    FROM mast
    INNER JOIN makt ON mast.matnr = makt.matnr
    INNER JOIN stko ON mast.stlnr = stko.stlnr;   -- keep same as report (no STLAL join)

  IF :iv_where IS NULL OR :iv_where = '' THEN
    et_mast_makt = SELECT * FROM :lt_base;
  ELSE
    et_mast_makt = APPLY_FILTER( :lt_base, :iv_where );
  END IF;

  et_stko =
    SELECT
      s.stlnr AS stlnr,
      s.stlty AS stlty,
      s.bmein AS bmein,
      s.bmeng AS bmeng,
      s.stlst AS stlst,
      s.stlal AS stlal,
      s.annam AS annam
    FROM stko AS s
    INNER JOIN (
      SELECT DISTINCT stlnr, stlal, stlst
      FROM :et_mast_makt
    ) AS k
      ON  s.stlnr = k.stlnr
      AND s.stlal = k.stlal
      AND s.stlst = k.stlst;

  et_stas =
    SELECT
      stlty AS stlty,
      stlnr AS stlnr,
      stlal AS stlal,
      stlkn AS stlkn,
      stasz AS stasz
    FROM stas
    WHERE stlnr IN ( SELECT DISTINCT stlnr FROM :et_stko );

  et_stpo =
    SELECT
      p.stlnr  AS stlnr,
      p.stlkn  AS stlkn,
      p.andat  AS andat,
      p.aedat  AS aedat,
      p.aenam  AS aenam,
      p.stpoz  AS stpoz,
      p.aennr  AS aennr,
      p.vgknt  AS vgknt,
      p.vgpzl  AS vgpzl,
      p.idnrk  AS idnrk,
      p.meins  AS meins,
      p.menge  AS menge,
      p.datuv  AS datuv,
      p.postp  AS postp,
      p.posnr  AS posnr
    FROM stpo AS p
    INNER JOIN :et_stko AS k
      ON  p.stlnr = k.stlnr
      AND p.stlty = k.stlty
    WHERE p.vgknt = ' '
      AND p.vgpzl = ' ';

  et_marc =
    SELECT
      m.matnr AS matnr,
      m.lvorm AS lvorm
    FROM marc AS m
    WHERE m.matnr IN ( SELECT DISTINCT idnrk FROM :et_stpo );

ENDMETHOD.


ENDCLASS.

