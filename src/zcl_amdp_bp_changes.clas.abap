CLASS ZCL_AMDP_BP_CHANGES DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES IF_AMDP_MARKER_HDB .

    TYPES: BEGIN OF ty_bp_range,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE bu_partner,
         high   TYPE bu_partner,
       END OF ty_bp_range.

TYPES tt_bp_range TYPE STANDARD TABLE OF ty_bp_range WITH EMPTY KEY.

TYPES: BEGIN OF ty_date_range,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE cddatum,
         high   TYPE cddatum,
       END OF ty_date_range.
TYPES tt_date_range TYPE STANDARD TABLE OF ty_date_range WITH EMPTY KEY.

    TYPES:BEGIN OF ty_out,
           objectid   TYPE cdobjectv,
             username   TYPE CDUSERNAME,
             udate      TYPE cddatum,
             utime      TYPE cduzeit,
             value_new  TYPE cdfldvaln,
             value_old  TYPE cdfldvalo,
             chngind    TYPE CHAR10,
             fname      type FIELDNAME,
          END OF TY_OUT.

  TYPES:TT_OUT TYPE STANDARD TABLE OF TY_OUT WITH EMPTY KEY.

  CLASS-METHODS get_bank_details
  IMPORTING
    VALUE(iv_client)    TYPE mandt
        VALUE(iv_bp_range)    TYPE TT_BP_RANGE
        VALUE(iv_date_range)  TYPE TT_DATE_RANGE
*        VALUE(iv_date_to)   TYPE cddatum
      EXPORTING
        VALUE(et_changes)   TYPE tt_out.

*  PROTECTED SECTION.
*  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AMDP_BP_CHANGES IMPLEMENTATION.

 METHOD get_bank_details
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING cdhdr cdpos.

   et_changes =
      SELECT
        hdr.objectid   AS objectid,
        hdr.username   AS username,
        hdr.udate      AS udate,
        hdr.utime      AS utime,
        pos.value_new  AS value_new,
        pos.value_old  AS value_old,
        pos.chngind    AS chngind,
        pos.fname      AS fname
      FROM cdhdr AS hdr
      INNER JOIN cdpos AS pos
        ON hdr.mandant     = pos.mandant
       AND hdr.changenr = pos.changenr
      WHERE hdr.mandant      = :iv_client
        AND hdr.objectclas = 'BUPA_BUP'
        AND (
        ( SELECT COUNT(*) FROM :iv_bp_range ) = 0
     OR hdr.objectid IN (
          SELECT low FROM :iv_bp_range
          WHERE sign = 'I' AND option = 'EQ'
        )
      )
        AND (
*        CARDINALITY(:iv_date_range) = 0
         ( SELECT COUNT(*) FROM :iv_date_range ) = 0
     OR EXISTS (
          SELECT 1 FROM :iv_date_range d
          WHERE d.sign = 'I'
            AND (
                 ( d.option = 'EQ' AND hdr.udate = d.low )
              OR ( d.option = 'BT' AND hdr.udate BETWEEN d.low AND d.high )
            )
        )
      )
        AND pos.objectclas = 'BUPA_BUP'
        AND pos.fname IN ('BANKN', 'BANKL', 'ACCNAME', 'KOINH','BKONT','BKEXT','BKREF')
        AND pos.chngind IN ('U', 'E', 'D');
  ENDMETHOD.
ENDCLASS.
