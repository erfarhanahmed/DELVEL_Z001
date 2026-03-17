*&---------------------------------------------------------------------*
*& Report Z_SUPPLIER_COUNT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SUPPLIER_COUNT.
TABLES: lfa1, dfkkbptaxnum.

TYPE-POOLS: slis.

*-----------------------*
* Selection Screen
*-----------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_ktokk FOR lfa1-ktokk OBLIGATORY.
SELECT-OPTIONS: s_alv FOR lfa1-name3 .
SELECTION-SCREEN END OF BLOCK b1.

*-----------------------*
* Data Declarations
*-----------------------*
TYPES: BEGIN OF ty_supplier_summary,
         ktokk        TYPE lfa1-ktokk,        "Supplier Account Group
         regio        TYPE lfa1-regio,        "Region
         taxtype      TYPE dfkkbptaxnum-TAXNUMXL, "Header/Tax Category
         critical     TYPE lfa1-J_1KFTBUS, "Critical-Type of Business
         supplier_cnt TYPE i,                 "Supplier Count
         TXT30        TYPE  T077Y-TXT30,
         BEZEI        TYPE T005U-BEZEI,
       END OF ty_supplier_summary.

DATA: it_summary TYPE STANDARD TABLE OF ty_supplier_summary,
      wa_summary TYPE ty_supplier_summary.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

DATA: v_repid TYPE sy-repid.



*-----------------------*
* Start of Selection
*-----------------------*
START-OF-SELECTION.

  PERFORM get_data.
  PERFORM build_fieldcat.
  PERFORM display_data.

*-----------------------*
* Form: GET_DATA
*-----------------------*
FORM get_data.
 SELECT
    lfa1~ktokk         AS ktokk,
    lfa1~regio         AS regio,
    lfa1~j_1kftbus     AS j_1kftbus,
    'Yes'              AS critical,
    ztax~taxnumxl      AS taxtype,
    COUNT( DISTINCT lfa1~lifnr ) AS supplier_cnt,
    t077y~txt30        AS txt30,
    t005u~bezei        AS bezei
  FROM lfa1
    INNER JOIN dfkkbptaxnum AS ztax
      ON lfa1~lifnr = ztax~partner
    LEFT JOIN t077y
      ON t077y~ktokk = lfa1~ktokk
     AND t077y~spras = 'E'
    LEFT JOIN t005u
      ON t005u~bland = lfa1~regio
     AND t005u~land1 = 'IN'
     AND t005u~spras = 'E'
  WHERE lfa1~j_1kftbus = 'Critical'
    AND ztax~taxtype = 'IN6'
    AND lfa1~ktokk IN @s_ktokk
    AND lfa1~name3 IN @s_alv
  GROUP BY
    lfa1~ktokk,
    lfa1~regio,
    lfa1~j_1kftbus,
    ztax~taxnumxl,
    t077y~txt30,
    t005u~bezei
  HAVING COUNT( DISTINCT lfa1~lifnr ) > 1
  INTO CORRESPONDING FIELDS OF TABLE @it_summary.

  "---- 2️⃣ Non-Critical Suppliers ----"
  SELECT
    lfa1~ktokk         AS ktokk,
    lfa1~regio         AS regio,
    lfa1~j_1kftbus     AS j_1kftbus,
    'No'               AS critical,
    ztax~taxnumxl      AS taxtype,
    COUNT( DISTINCT lfa1~lifnr ) AS supplier_cnt,
    t077y~txt30        AS txt30,
    t005u~bezei        AS bezei
  FROM lfa1
    INNER JOIN dfkkbptaxnum AS ztax
      ON lfa1~lifnr = ztax~partner
    LEFT JOIN t077y
      ON t077y~ktokk = lfa1~ktokk
     AND t077y~spras = 'E'
    LEFT JOIN t005u
      ON t005u~bland = lfa1~regio
     AND t005u~land1 = 'IN'
     AND t005u~spras = 'E'
  WHERE lfa1~j_1kftbus <> 'Critical'
    AND ztax~taxtype = 'IN6'
    AND lfa1~ktokk IN @s_ktokk
    AND lfa1~name3 IN @s_alv
  GROUP BY
    lfa1~ktokk,
    lfa1~regio,
    lfa1~j_1kftbus,
    ztax~taxnumxl,
    t077y~txt30,
    t005u~bezei
  HAVING COUNT( DISTINCT lfa1~lifnr ) > 1
  APPENDING CORRESPONDING FIELDS OF TABLE @it_summary.

  IF sy-subrc <> 0.
    MESSAGE 'No data found for given Account Group(s)' TYPE 'I'.
  ENDIF.
*  SELECT lfa1~ktokk         AS ktokk,
*         lfa1~regio         AS regio,
*         ztax~taxtype       AS taxtype,
*     CASE
*         WHEN lfa1~j_1kftbus = 'Critical' THEN 'Yes'
*         ELSE 'No'
*       END                AS critical,
*         COUNT( DISTINCT lfa1~lifnr ) AS supplier_cnt
*    INTO TABLE @it_summary
*    FROM lfa1
*     INNER JOIN dfkkbptaxnum AS ztax
*    ON lfa1~lifnr = ztax~partner
*  WHERE ( ( lfa1~ktokk IN @s_ktokk )
*       and ( lfa1~name3 IN @s_alv ) )
*    AND ztax~taxtype = 'IN6'
*    GROUP BY lfa1~ktokk,
*             lfa1~regio,
*             ztax~taxtype,
*             lfa1~J_1KFTBUS.
*
*  IF sy-subrc <> 0.
*    MESSAGE 'No data found for given Account Group(s)' TYPE 'I'.
*  ENDIF.

ENDFORM.

*-----------------------*
* Form: BUILD_FIELDCAT
*-----------------------*
FORM build_fieldcat.

  CLEAR it_fieldcat.

  PERFORM add_field USING 'KTOKK'       'Supplier Account Group'.
  PERFORM add_field USING 'TXT30'       'Supplier Acc DESC'.
  PERFORM add_field USING 'REGIO'       'Region'.
  PERFORM add_field USING 'BEZEI'       'REG desc'.
  PERFORM add_field USING 'TAXTYPE'     'Header/Tax Category'.
  PERFORM add_field USING 'CRITICAL'    'Critical-Type of Business'.
  PERFORM add_field USING 'SUPPLIER_CNT' 'Supplier Count'.

ENDFORM.

* Helper FORM for adding ALV columns
FORM add_field USING p_field p_text.
  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname = p_field.
  wa_fieldcat-seltext_l = p_text.
  APPEND wa_fieldcat TO it_fieldcat.
ENDFORM.

*-----------------------*
* Form: DISPLAY_DATA
*-----------------------*
FORM display_data.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  v_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = v_repid
      is_layout          = gs_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_summary
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE 'Error displaying ALV output' TYPE 'E'.
  ENDIF.
ENDFORM.
