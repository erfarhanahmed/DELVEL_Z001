CLASS ZCL_INV_AGEING_REPORT DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES IF_AMDP_MARKER_HDB.
    CLASS-METHODS GET_DATA FOR TABLE FUNCTION ZINV_AGEING_TF_INVAGEDET.
ENDCLASS.

CLASS ZCL_INV_AGEING_REPORT IMPLEMENTATION.
  METHOD GET_DATA
    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING
      MATDOC
      NSDM_V_MARD       " entity for view NSDM_V_MARD
      NSDM_V_MSKA       " entity for view NSDM_V_MSKA
      MBEW              " entity for view MBV_MBEW
      EBEW
      QAMB
      MKPF
      MARA
      EKKN
      AUFK.

    /* -----------------------------
       1) UR Receipts (non-SO)
    ------------------------------*/
    LT_RECEIPTS_UR =
      SELECT M.MBLNR, M.MJAHR, M.ZEILE, M.BWART, M.MATNR, M.WERKS, M.LGORT,
             M.LIFNR, M.MENGE, M.BUDAT
        FROM MATDOC AS M
       WHERE M.MANDT = :P_CLIENT
         AND ( :P_BUKRS IS NULL OR :P_BUKRS = '' OR M.BUKRS = :P_BUKRS )
         AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR M.WERKS = :P_WERKS )
         AND ( :P_LGORT IS NULL OR :P_LGORT = '' OR M.LGORT = :P_LGORT )
         AND ( M.SOBKZ IS NULL OR M.SOBKZ <> 'E' )
         AND M.SHKZG = 'S'
         AND M.BWART IN ( '101','105','561','309','311','321','411','412','501','531',
                          '653','701','Z11','542','262','602','301','413','344','Z42',
                          '202','343','312','544','166' )
         AND NOT ( M.BWART = '321'
                   AND EXISTS ( SELECT 1
                                 FROM MATDOC AS X
                                WHERE X.MANDT = :P_CLIENT
                                  AND X.BWART = '322'
                                  AND X.SMBLN = M.MBLNR ) )
         AND NOT ( M.BWART = '321'
                   AND EXISTS ( SELECT 1
                                 FROM QAMB AS Q1
                                WHERE Q1.MBLNR = M.MBLNR
                                  AND Q1.ZEILE = M.ZEILE
                                  AND EXISTS ( SELECT 1
                                                 FROM QAMB AS Q2
                                                WHERE Q2.PRUEFLOS = Q1.PRUEFLOS
                                                  AND Q2.TYP <> '3' ) ) );

    /* -----------------------------
       2) SO Receipts (SPECIAL STOCK 'E')
    ------------------------------*/
LT_RECEIPTS_SO =
  WITH BASE AS (
    SELECT
        M.MBLNR,
        M.MJAHR,
*       " SOC BY sanjay Func-Ashish 09.02.2026
*       M.KDAUF AS VBELN,
*        M.KDPOS AS POSNR,
       M.MAT_KDAUF AS VBELN,
       M.MAT_KDPOS AS POSNR,
* " EOC BY sanjay Func-Ashish 09.02.2026
        M.ZEILE,
        M.BWART,
        M.MATNR,
        M.WERKS,
        M.LGORT,
        M.LIFNR,
        M.MENGE,
        M.BUDAT,

        /* internal (not in final output) — needed to fetch SO from PO item */
        M.EBELN,
        M.EBELP,
        M.KZBEW,
        M.AUFNR
      FROM MATDOC AS M
     WHERE M.MANDT = :P_CLIENT
       AND ( :P_BUKRS IS NULL OR :P_BUKRS = '' OR M.BUKRS = :P_BUKRS )
       AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR M.WERKS = :P_WERKS )
       AND ( :P_LGORT IS NULL OR :P_LGORT = '' OR M.LGORT = :P_LGORT )
       --AND KDAUF <> ''
       AND M.SOBKZ = 'E'
       AND M.SHKZG = 'S'
       AND M.BWART IN ( '101','105','561','309','311','321','411','412','501','531',
                        '653','701','Z11','542','262','602','301','413','344','Z42',
                        '202','343','312','544','166' )
       AND NOT ( M.BWART = '321'
                 AND EXISTS ( SELECT 1
                                FROM MATDOC AS X
                               WHERE X.MANDT = :P_CLIENT
                                 AND X.BWART = '322'
                                 AND X.SMBLN = M.MBLNR ) )
       AND NOT ( M.BWART = '321'
                 AND EXISTS ( SELECT 1
                                FROM QAMB AS Q1
                               WHERE Q1.MBLNR = M.MBLNR
                                 AND Q1.ZEILE = M.ZEILE
                                 AND EXISTS ( SELECT 1
                                                FROM QAMB AS Q2
                                               WHERE Q2.PRUEFLOS = Q1.PRUEFLOS
                                                 AND Q2.TYP <> '3' ) ) )
  )

  /* Post-processing: override VBELN/POSNR from EKPO only for 101 against a PO */
  SELECT
      B.MBLNR,
      B.MJAHR,
      CASE
        WHEN B.BWART = '101' AND B.KZBEW = 'B'
         AND B.EBELN IS NOT NULL AND B.EBELN <> ''
        THEN COALESCE(E.VBELN, B.VBELN)

        WHEN B.BWART = '101' AND B.KZBEW = 'F'
        AND B.EBELN IS NOT NULL AND B.EBELN <> ''
        THEN COALESCE(AUFK.KDAUF, B.VBELN)

        ELSE B.VBELN
      END AS VBELN,

      CASE
        WHEN B.BWART = '101' AND B.KZBEW = 'B'
         AND B.EBELN IS NOT NULL AND B.EBELN <> ''
        THEN COALESCE(E.VBELP, B.POSNR)

        WHEN B.BWART = '101' AND B.KZBEW = 'F'
        AND B.EBELN IS NOT NULL AND B.EBELN <> ''
        THEN COALESCE(AUFK.KDPOS, B.POSNR)

        ELSE B.POSNR
      END AS POSNR,

      B.ZEILE,
      B.BWART,
      B.MATNR,
      B.WERKS,
      B.LGORT,
      B.LIFNR,
      B.MENGE,
      B.BUDAT

  FROM BASE AS B
  LEFT OUTER JOIN EKKN AS E
    ON  E.MANDT = :P_CLIENT
    AND E.EBELN = B.EBELN
    AND E.EBELP = B.EBELP
    LEFT OUTER JOIN AUFK AS AUFK
    ON  E.MANDT = :P_CLIENT
    AND AUFK.AUFNR = B.AUFNR;

    /* -----------------------------
       3) Current Stock
    ------------------------------*/
    STOCK_UR =
      SELECT MARD.MATNR, MARD.WERKS, MARD.LGORT,
             SUM( COALESCE(MARD.LABST,0) + COALESCE(MARD.INSME,0) ) AS STOCK_QTY
        FROM NSDM_V_MARD AS MARD
       WHERE MARD.MANDT = :P_CLIENT
         AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR MARD.WERKS = :P_WERKS )
         AND ( :P_LGORT IS NULL OR :P_LGORT = '' OR MARD.LGORT = :P_LGORT )
       GROUP BY MARD.MATNR, MARD.WERKS, MARD.LGORT;

    STOCK_SO =
      SELECT MSKA.MATNR,
             MSKA.WERKS,
             MSKA.LGORT,
             MSKA.VBELN,
             MSKA.POSNR,
             SUM( COALESCE(MSKA.KALAB,0) + COALESCE(MSKA.KAINS,0) ) AS STOCK_QTY
        FROM NSDM_V_MSKA AS MSKA
       WHERE MSKA.MANDT = :P_CLIENT
         AND MSKA.SOBKZ = 'E'
         AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR MSKA.WERKS = :P_WERKS )
         AND ( :P_LGORT IS NULL OR :P_LGORT = '' OR MSKA.LGORT = :P_LGORT )
       GROUP BY MSKA.MATNR,
                MSKA.WERKS,
                MSKA.LGORT,
                MSKA.VBELN,
                MSKA.POSNR;

    STOCK_SO_TMP =
      SELECT MSKA.MATNR,
             MSKA.WERKS,
             MSKA.LGORT,
             MSKA.VBELN,
             MSKA.POSNR,
             MSKA.KALAB,
             MSKA.KAINS
        FROM NSDM_V_MSKA AS MSKA
       WHERE MSKA.MANDT = :P_CLIENT
         AND MSKA.SOBKZ = 'E'
         AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR MSKA.WERKS = :P_WERKS )
         AND ( :P_LGORT IS NULL OR :P_LGORT = '' OR MSKA.LGORT = :P_LGORT )
         AND ( MSKA.KALAB > 0 or MSKA.KAINS > 0 );


    /* -----------------------------
       4) Valuation (non-AGGREGATED)
       Plant-LEVEL VALUATION, no split VALUATION
    ------------------------------*/
    -- MBEW (COMPATIBILITY VIEW)
VAL_UR0 =
  SELECT MB.MATNR,
         MB.BWKEY  AS WERKS,
         MB.VPRSV,
         MB.VERPR,
         MB.STPRS
    FROM MBEW AS MB
   WHERE MB.MANDT = :P_CLIENT
     AND ( :P_WERKS IS NULL OR :P_WERKS = '' OR MB.BWKEY = :P_WERKS )
     AND ( MB.BWTAR = '' OR MB.BWTAR IS NULL );

VAL_UR =
  SELECT MATNR,
         WERKS,
         CASE WHEN VPRSV = 'V' THEN VERPR
              ELSE                 STPRS
         END AS RATE
    FROM :VAL_UR0;

    -- EBEW (SALES-ORDER SPECIAL STOCK 'E')
  val_so0 =
    WITH stock_so_tmp AS (
      SELECT
        MSKA.MATNR,
        MSKA.WERKS,
        MSKA.LGORT,
        MSKA.VBELN,
        MSKA.POSNR,
        MSKA.KALAB,
        MSKA.KAINS
      FROM NSDM_V_MSKA AS MSKA
      WHERE MSKA.MANDT = :p_client
        AND MSKA.SOBKZ = 'E'
        AND ( :p_werks IS NULL OR :p_werks = '' OR MSKA.WERKS = :p_werks )
        AND ( :p_lgort IS NULL OR :p_lgort = '' OR MSKA.LGORT = :p_lgort )
        AND MSKA.KALAB > 0 OR MSKA.KAINS > 0
    )
    SELECT
      EB.MATNR,
      EB.BWKEY    AS WERKS,
      EB.VBELN,
      EB.POSNR,
      EB.LBKUM,
      EB.SALK3
    FROM EBEW AS EB
    INNER        JOIN stock_so_tmp AS so_tmp
      ON  EB.MATNR = so_tmp.MATNR
      AND EB.BWKEY = so_tmp.WERKS
      AND EB.VBELN = so_tmp.VBELN
      AND EB.POSNR = so_tmp.POSNR
    WHERE EB.MANDT = :p_client
      AND EB.SOBKZ = 'E'
      AND ( :p_werks IS NULL OR :p_werks = '' OR EB.BWKEY = :p_werks )
      AND ( EB.BWTAR = '' OR EB.BWTAR IS NULL )
      AND EB.LBKUM > 0;

it_ebew = SELECT *
*      eb.mandt,
*      eb.sobkz,
*      eb.bwkey,
*      eb.bwtar,
*      eb.VMKUM,
*      EB.MATNR,
*      EB.BWKEY    AS WERKS,
*      EB.VBELN,
*      EB.POSNR,
*      EB.LBKUM,
*      EB.SALK3
    FROM EBEW AS EB
        WHERE
*        "EB.MANDT = :p_client
*      AND EB.SOBKZ = 'E'
*      AND ( :p_werks IS NULL OR :p_werks = '' OR EB.BWKEY = :p_werks )
*      AND ( EB.BWTAR = '' OR EB.BWTAR IS NULL )
vbeln = '0030003050';
*       EB.matnr = '44100G-30003050-01';
*      AND EB.LBKUM > 0;

VAL_SO =
  SELECT
         MATNR,
         WERKS,
         VBELN,
         SUM(LBKUM) AS LBKUM,
         SUM(SALK3) AS SALK3,
         CASE
           WHEN SUM(LBKUM) <> 0
                THEN SUM(SALK3) / SUM(LBKUM)
           ELSE 0
         END AS RATE
  FROM :VAL_SO0
  GROUP BY MATNR, WERKS, VBELN;




    /* -----------------------------
       5) UR Allocation
    ------------------------------*/
    UR_ALLOC_BASE =
      SELECT R.*,
             S.STOCK_QTY,
             COALESCE(
               SUM(R.MENGE) OVER ( PARTITION BY R.MATNR, R.WERKS, R.LGORT
                                   ORDER BY R.MATNR DESC, R.BUDAT DESC, R.MJAHR DESC, R.MBLNR DESC, R.ZEILE DESC ), 0
             ) - R.MENGE AS CUM_PREV
        FROM :LT_RECEIPTS_UR AS R
        INNER JOIN :STOCK_UR AS S
          ON S.MATNR = R.MATNR
         AND S.WERKS = R.WERKS
         AND S.LGORT = R.LGORT;

    UR_ALLOC =
      SELECT MBLNR, MJAHR, ZEILE, BWART, MATNR, WERKS, LGORT, LIFNR, BUDAT,
             MENGE AS ORIG_QTY,
             CASE WHEN STOCK_QTY <= CUM_PREV THEN 0
                  ELSE LEAST( MENGE, STOCK_QTY - CUM_PREV ) END AS ALLOC_QTY
        FROM :UR_ALLOC_BASE
       WHERE STOCK_QTY > CUM_PREV;

    /* -----------------------------
       6) SO Allocation
    ------------------------------*/
    SO_ALLOC_BASE =
      SELECT R.*,
             S.STOCK_QTY,
             COALESCE(
               SUM(R.MENGE) OVER ( PARTITION BY R.MATNR, R.WERKS, R.LGORT, R.VBELN, R.POSNR
                                   ORDER BY R.MATNR DESC, R.BUDAT DESC, R.MJAHR DESC, R.MBLNR DESC, R.ZEILE DESC ), 0
             ) - R.MENGE AS CUM_PREV
        FROM :LT_RECEIPTS_SO AS R
        INNER JOIN :STOCK_SO AS S
          ON S.MATNR = R.MATNR
         AND S.WERKS = R.WERKS
         AND S.LGORT = R.LGORT
         AND S.VBELN = R.VBELN
         AND S.POSNR = R.POSNR;

    SO_ALLOC =
      SELECT MBLNR, MJAHR, VBELN, POSNR, ZEILE, BWART, MATNR, WERKS, LGORT, LIFNR, BUDAT,
             MENGE AS ORIG_QTY,
             CASE WHEN STOCK_QTY <= CUM_PREV THEN 0
                  ELSE LEAST( MENGE, STOCK_QTY - CUM_PREV ) END AS ALLOC_QTY
        FROM :SO_ALLOC_BASE
       WHERE STOCK_QTY > CUM_PREV;

    /* -----------------------------
       7) FINAL Output (UR ∪ SO)
    ------------------------------*/
    RETURN
      SELECT :P_CLIENT                                             AS CLNT,
             A.MBLNR, A.MJAHR, A.ZEILE, A.BWART, A.MATNR, A.WERKS, A.LGORT, A.LIFNR, A.BUDAT,
             COALESCE(K.BLDAT, A.BUDAT)                           AS DOCUMENTDATE,
             DAYS_BETWEEN(A.BUDAT, CURRENT_DATE)                  AS AGE_DAYS,
             'UR'                                                 AS ALLOC_CAT,
             CAST(A.ORIG_QTY  AS DECIMAL(15,3))                   AS QUANTITY,
             CAST(A.ALLOC_QTY AS DECIMAL(15,3))                   AS ALLOC_QTY,
             CAST(A.ALLOC_QTY * COALESCE(V.RATE,0) AS DECIMAL(23,2)) AS ALLOC_AMOUNT,
             CAST(COALESCE(V.RATE,0) AS DECIMAL(23,6))            AS RATE_USED,
             CAST(A.ALLOC_QTY AS DECIMAL(15,3))                   AS UR_ALLOC_QTY,
             CAST(0           AS DECIMAL(15,3))                   AS SO_ALLOC_QTY,
             CAST(A.ALLOC_QTY * COALESCE(V.RATE,0) AS DECIMAL(23,2)) AS UR_AMOUNT,
             CAST(0            AS DECIMAL(23,2))                  AS SO_AMOUNT,
             MA.WRKST                                             AS USACODE,
*              // "added by sanjay func-ashish 11.03.2026
             cast( 0 as NVARCHAR(10) ) as sales_order,
             cast( 0 as NVARCHAR(6) ) as sales_item
*              "added by sanjay func-ashish 11.03.2026
        FROM :UR_ALLOC AS A
        LEFT OUTER JOIN :VAL_UR AS V
          ON V.MATNR = A.MATNR
         AND V.WERKS = A.WERKS
        LEFT OUTER JOIN MKPF AS K
          ON K.MANDT = :P_CLIENT
         AND K.MBLNR = A.MBLNR
         AND K.MJAHR = A.MJAHR
        LEFT OUTER JOIN MARA AS MA
          ON MA.MANDT = :P_CLIENT
         AND MA.MATNR = A.MATNR

      UNION ALL

      SELECT :P_CLIENT                                             AS CLNT,
             A.MBLNR, A.MJAHR, A.ZEILE, A.BWART, A.MATNR, A.WERKS, A.LGORT, A.LIFNR, A.BUDAT,
             COALESCE(K.BLDAT, A.BUDAT)                           AS DOCUMENTDATE,
             DAYS_BETWEEN(A.BUDAT, CURRENT_DATE)                  AS AGE_DAYS,
             'SO'                                                 AS ALLOC_CAT,
             CAST(A.ORIG_QTY  AS DECIMAL(15,3))                   AS QUANTITY,
             CAST(0           AS DECIMAL(15,3))                   AS ALLOC_QTY,
             CAST(0           AS DECIMAL(23,2))                   AS ALLOC_AMOUNT,
             CAST(COALESCE(V.RATE,0) AS DECIMAL(23,6))            AS RATE_USED,
             CAST(0           AS DECIMAL(15,3))                   AS UR_ALLOC_QTY,
             CAST(A.ALLOC_QTY AS DECIMAL(15,3))                   AS SO_ALLOC_QTY,
             CAST(0           AS DECIMAL(23,2))                   AS UR_AMOUNT,
             CAST(A.ALLOC_QTY * COALESCE(V.RATE,0) AS DECIMAL(23,2)) AS SO_AMOUNT,
             MA.WRKST                                             AS USACODE,
             a.VBELN as sales_order,
             a.POSNR as sales_item
        FROM :SO_ALLOC AS A
        LEFT OUTER JOIN :VAL_SO AS V
          ON V.MATNR = A.MATNR
         AND V.WERKS = A.WERKS
         AND V.VBELN = A.VBELN
        -- AND V.POSNR = A.POSNR
        LEFT OUTER JOIN MKPF AS K
          ON K.MANDT = :P_CLIENT
         AND K.MBLNR = A.MBLNR
         AND K.MJAHR = A.MJAHR
        LEFT OUTER JOIN MARA AS MA
          ON MA.MANDT = :P_CLIENT
         AND MA.MATNR = A.MATNR;

  ENDMETHOD.
ENDCLASS.

