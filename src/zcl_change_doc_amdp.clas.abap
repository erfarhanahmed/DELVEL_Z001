class ZCL_CHANGE_DOC_AMDP definition
  public
  final
  create public .
  public section.


  types:
    BEGIN OF ZTY_CHANGES,
  OBJECTCLAS TYPE CDOBJECTCL,
  OBJECTID   TYPE CDOBJECTV,
  CHANGENR   TYPE CDCHANGENR,
  USERNAME   TYPE CDCHANGENR,
  UDATE      TYPE CDDATUM,
  UTIME      TYPE CDUZEIT,
  TCODE      TYPE CDTCODE,
  PLANCHNGNR TYPE PLANCHNGNR,
  ACT_CHNGNO TYPE CD_CHNGNO,
  WAS_PLANND TYPE CD_PLANNED,
  CHANGE_IND TYPE CDCHNGINDH,
  LANGU      TYPE LANGU,
  VERSION    TYPE CHAR3,

  TABNAME    TYPE TABNAME,
  TABKEY     TYPE CDTABKEY,
  FNAME      TYPE FIELDNAME,
  CHNGIND    TYPE CDCHNGIND,
  TEXT_CASE  TYPE CDXFELD,
  UNIT_OLD   TYPE CDUNIT,
  UNIT_NEW   TYPE CDUNIT,
  CUKY_OLD   TYPE CDCUKY,
  CUKY_NEW   TYPE CDCUKY,
  VALUE_NEW  TYPE CDFLDVALN,
  VALUE_OLD  TYPE CDFLDVALO,

       END OF ZTY_CHANGES .
  types:
    ZTt_CHANGES TYPE TABLE OF ZTY_CHANGES .

  INTERFACES if_amdp_marker_hdb .
*     EXPORTING et_changes    TYPE TABLE OF zty_changes.
  class-methods GET_CHANGES
    importing
*      value(IV_OBJECTCLAS) type CDOBJECTCL
*     value(IV_OBJECTID) type CDOBJECTV
      value(TABKEY) TYPE CDTABKEY
    exporting
      value(ET_CHANGES) type ZTT_CHANGES .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CHANGE_DOC_AMDP IMPLEMENTATION.


METHOD get_changes BY DATABASE PROCEDURE
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY USING CDHDR CDPOS.

    et_changes =
    SELECT  sub.OBJECTCLAS,
           sub.OBJECTID,
           sub.CHANGENR,
           sub.USERNAME,
           sub.UDATE,
           sub.UTIME,
           sub.TCODE,
           sub.PLANCHNGNR,
           sub.ACT_CHNGNO,
           sub.WAS_PLANND,
           sub.CHANGE_IND,
           sub.LANGU,
           sub.VERSION,
           sub.TABNAME,
           sub.TABKEY,
           sub.FNAME,
           sub.CHNGIND,
           sub.TEXT_CASE,
           sub.UNIT_OLD,
           sub.UNIT_NEW,
           sub.CUKY_OLD,
           sub.CUKY_NEW,
           sub.VALUE_NEW,
           sub.VALUE_OLD
      FROM (
        SELECT
          h.OBJECTCLAS,
          h.OBJECTID,
          h.CHANGENR,
          h.USERNAME,
          h.UDATE,
          h.UTIME,
          h.TCODE,
          h.PLANCHNGNR,
          h.ACT_CHNGNO,
          h.WAS_PLANND,
          h.CHANGE_IND,
          h.LANGU,
          h.VERSION,
          p.TABNAME,
          p.TABKEY,
          p.FNAME,
          p.CHNGIND,
          p.TEXT_CASE,
          p.UNIT_OLD,
          p.UNIT_NEW,
          p.CUKY_OLD,
          p.CUKY_NEW,
          p.VALUE_NEW,
          p.VALUE_OLD,
          ROW_NUMBER() OVER (
            PARTITION BY p.TABKEY, p.TABNAME, p.FNAME
            ORDER BY h.UDATE DESC, h.UTIME DESC, h.CHANGENR DESC
          ) AS RN
        FROM CDPOS AS p
        INNER JOIN CDHDR AS h
          ON p.OBJECTCLAS = h.OBJECTCLAS
         AND p.OBJECTID   = h.OBJECTID
         AND p.CHANGENR   = h.CHANGENR
        WHERE p.TABKEY  = :TABKEY
          AND p.TABNAME = 'VBEP'
          AND p.FNAME   = 'ETTYP'
      ) AS sub
     WHERE sub.RN = 1;

  ENDMETHOD.
ENDCLASS.
