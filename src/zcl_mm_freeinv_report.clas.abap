CLASS ZCL_MM_FREEINV_REPORT DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES IF_AMDP_MARKER_HDB.

    CLASS-METHODS GET_BASE
        FOR TABLE FUNCTION ZTF_MM_FREEINV_REPORT.

ENDCLASS.



CLASS ZCL_MM_FREEINV_REPORT IMPLEMENTATION.

  METHOD GET_BASE
    BY DATABASE FUNCTION FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY
    USING MARA MARC MAKT MBEW EINA EINE NSDM_V_MARD NSDM_V_MSLB NSDM_V_MSKA EBEW AFPO AUFM AUFK.

    /************************************************************
     * Excluded SLocs (SAME list as ABAP)
     ************************************************************/
    LT_EXCL =
      SELECT * FROM (
        SELECT 'RJ01' AS LGORT  FROM dummy
        UNION ALL SELECT 'SCR1' FROM dummy
        UNION ALL SELECT 'SRN1' FROM dummy
        UNION ALL SELECT 'SPC1' FROM dummy
        UNION ALL SELECT 'KRJ0' FROM dummy
        UNION ALL SELECT 'KSCR' FROM dummy
        UNION ALL SELECT 'KSRN' FROM dummy
      );

    /************************************************************
     * 1) Material set (MARA + MARC PLANT + MAKT TEXT)
     ************************************************************/
    LT_MAT =
      SELECT
        A.MANDT               AS MANDT,
        c.WERKS               AS WERKS,
        A.MATNR               AS MATNR,
        A.MEINS               AS MEINS,
        A.MTART               AS MTART,
        COALESCE(T.MAKTX, '') AS MAKTX
      FROM MARA AS A
      INNER JOIN MARC AS c
        ON  c.MANDT = A.MANDT
        AND c.MATNR = A.MATNR
        AND c.WERKS = :P_WERKS
      LEFT OUTER JOIN MAKT AS T
        ON  T.MANDT = A.MANDT
        AND T.MATNR = A.MATNR
        AND T.SPRAS = :P_LANGU
      WHERE A.MANDT = :P_CLNT;

    /************************************************************
     * 2) Rate from MBEW (PICK 1 row PER MATNR)
     ************************************************************/
    LT_MBEW_RANK =
      SELECT
        MATNR,
        VPRSV,
        VERPR,
        STPRS,
        BWTAR,
        ROW_NUMBER() OVER(
          PARTITION BY MATNR
          ORDER BY CASE WHEN BWTAR = '' THEN 0 ELSE 1 END, BWTAR
        ) AS RN
      FROM MBEW
      WHERE MANDT = :P_CLNT
        AND BWKEY = :P_WERKS
        AND MATNR IN ( SELECT MATNR FROM :LT_MAT );

    LT_RATE =
      SELECT
        MATNR,
        CASE VPRSV
          WHEN 'V' THEN VERPR
          WHEN 'S' THEN STPRS
          ELSE 0
        END AS ZRATE
      FROM :LT_MBEW_RANK
      WHERE RN = 1;

    /************************************************************
     * 3) MOQ = MAX(EINE-MINBM) PER MATNR
     ************************************************************/
    LT_MOQ =
      SELECT
        i.MATNR      AS MATNR,
        MAX(e.MINBM) AS MINBM
      FROM EINA AS i
      INNER JOIN EINE AS e
        ON  e.MANDT = i.MANDT
        AND e.INFNR = i.INFNR
      WHERE i.MANDT = :P_CLNT
        AND i.MATNR IN ( SELECT MATNR FROM :LT_MAT )
      GROUP BY i.MATNR;

    /************************************************************
     * 4) Own STOCK (MARD) AGGREGATION
     * ABAP-EQUIVALENT: APPLY EXCLUSIONS via CASE, NOT via WHERE
     ************************************************************/
    LT_OWN =
      SELECT
        MATNR,
        SUM(
          CASE
            WHEN COALESCE(DISKZ,'') = '1' THEN 0
            WHEN COALESCE(LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE LABST
          END
        ) AS OWN_UNRST_QTY,
        SUM(
          CASE
            WHEN COALESCE(DISKZ,'') = '1' THEN 0
            WHEN COALESCE(LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE INSME
          END
        ) AS OWN_QA_QTY
      FROM NSDM_V_MARD
      WHERE MANDT = :P_CLNT
        AND WERKS = :P_WERKS
        AND MATNR IN ( SELECT MATNR FROM :LT_MAT )
      GROUP BY MATNR;

    /************************************************************
     * 5) Subcontract STOCK (MSLB)
     ************************************************************/
    LT_SBCN =
      SELECT
        MATNR,
        SUM(LBLAB) AS SBCN_QTY
      FROM NSDM_V_MSLB
      WHERE MANDT = :P_CLNT
        AND WERKS = :P_WERKS
        AND MATNR IN ( SELECT MATNR FROM :LT_MAT )
      GROUP BY MATNR;

    /************************************************************
     * 6) EBEW PICK (1 row PER MATNR/BWKEY/VBELN/POSNR)
     ************************************************************/
    LT_EBEW_RANK =
      SELECT
        MATNR,
        BWKEY,
        VBELN,
        POSNR,
        VPRSV,
        VERPR,
        STPRS,
        BWTAR,
        ROW_NUMBER() OVER(
          PARTITION BY MATNR, BWKEY, VBELN, POSNR
          ORDER BY CASE WHEN BWTAR = '' THEN 0 ELSE 1 END, BWTAR
        ) AS RN
      FROM EBEW
      WHERE MANDT = :P_CLNT
        AND BWKEY = :P_WERKS
        AND MATNR IN ( SELECT MATNR FROM :LT_MAT );

    LT_EBEW =
      SELECT MATNR, BWKEY, VBELN, POSNR, VPRSV, VERPR, STPRS
      FROM :LT_EBEW_RANK
      WHERE RN = 1;

    /************************************************************
     * 7) SO STOCK + VALUATION (MSKA)
     * ABAP-EQUIVALENT: EXCLUSIONS via CASE
     ************************************************************/
    LT_SO =
      SELECT
        K.MATNR AS MATNR,

        SUM(
          CASE
            WHEN COALESCE(K.LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE K.KALAB
          END
        ) AS SO_UNRST_QTY,

        SUM(
          CASE
            WHEN COALESCE(K.LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE K.KAINS
          END
        ) AS SO_QA_QTY,

        SUM(
          CASE
            WHEN COALESCE(K.LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE
              CASE e.VPRSV
                WHEN 'V' THEN K.KALAB * e.VERPR
                WHEN 'S' THEN K.KALAB * e.STPRS
                ELSE 0
              END
          END
        ) AS SO_UNRST_VAL_RAW,

        SUM(
          CASE
            WHEN COALESCE(K.LGORT,'') IN ( SELECT LGORT FROM :LT_EXCL ) THEN 0
            ELSE
              CASE e.VPRSV
                WHEN 'V' THEN K.KAINS * e.VERPR
                WHEN 'S' THEN K.KAINS * e.STPRS
                ELSE 0
              END
          END
        ) AS SO_QA_VAL_RAW

      FROM NSDM_V_MSKA AS K
      LEFT OUTER JOIN :LT_EBEW AS e
        ON  e.MATNR = K.MATNR
        AND e.BWKEY = K.WERKS
        AND e.VBELN = K.VBELN
        AND e.POSNR = K.POSNR
      WHERE K.MANDT = :P_CLNT
        AND K.WERKS = :P_WERKS
        AND K.MATNR IN ( SELECT MATNR FROM :LT_MAT )
      GROUP BY K.MATNR;

    /************************************************************
     * 8) Open ORDERS (AFPO): WEMNG < PSMNG
     ************************************************************/
    LT_OPEN =
      SELECT DISTINCT A.AUFNR
      FROM AFPO as A
      inNER jOIN Aufk as B
       on A.AUFNR = B.AUFNR
      WHERE A.MANDT = :P_CLNT
        AND A.PWERK = :P_WERKS
        AND A.WEMNG < A.PSMNG
        AND B.IDAT2 = '00000000' or B.IDAT2 = ' ' ;

    /************************************************************
     * 9) WIP from AUFM: SUM(261) - SUM(262) for open ORDERS
     ************************************************************/
    LT_WIP_RAW =
      SELECT
        m.MATNR AS MATNR,
        SUM(
          CASE m.BWART
            WHEN '261' THEN m.MENGE
            WHEN '262' THEN -M.MENGE
            ELSE 0
          END
        ) AS WIP_QTY_RAW
      FROM AUFM AS m
      INNER JOIN :LT_OPEN AS o
        ON o.AUFNR = m.AUFNR
      WHERE m.MANDT = :P_CLNT
        AND m.WERKS = :P_WERKS
        AND m.BWART IN ('261','262')
        AND m.MATNR IS NOT NULL
        AND m.MATNR IN ( SELECT MATNR FROM :LT_MAT )
      GROUP BY m.MATNR;

    LT_WIP =
      SELECT
        MATNR,
        CASE WHEN WIP_QTY_RAW > 0 THEN WIP_QTY_RAW ELSE 0 END AS WIP_QTY
      FROM :LT_WIP_RAW;

    /************************************************************
     * 10) Final return (TOTREQ/FREE PLACEHOLDERS = 0)
     *     ADDED: early filter EQUIVALENT to
     *     IF (TOTSTCK + WIP_QTY + QA_QTY + SBCN_QTY) <= 0. CONTINUE.
     ************************************************************/
    RETURN
      SELECT
        :P_CLNT AS MANDT,

        m.WERKS AS WERKS,
        m.MATNR AS MATNR,
        m.MAKTX AS MAKTX,
        m.MEINS AS MEINS,
        COALESCE(Q.MINBM, 0) AS MINBM,

        CAST(0 AS DECIMAL(13,3)) AS TOTREQ,

        CAST(COALESCE(o.OWN_UNRST_QTY,0) + COALESCE(S.SO_UNRST_QTY,0) AS DECIMAL(13,3)) AS TOTSTCK,

        CAST(
          ROUND(
            ROUND(COALESCE(o.OWN_UNRST_QTY,0) * COALESCE(R.ZRATE,0), 2)
            + ROUND(COALESCE(S.SO_UNRST_VAL_RAW,0), 2),
          2)
          AS DECIMAL(15,2)
        ) AS TOTSTCK_VAL,

        CAST(COALESCE(W.WIP_QTY,0) AS DECIMAL(13,3)) AS WIP_QTY,
        CAST(ROUND(COALESCE(W.WIP_QTY,0) * COALESCE(R.ZRATE,0), 2) AS DECIMAL(15,2)) AS WIP_VAL,

        CAST(COALESCE(o.OWN_QA_QTY,0) + COALESCE(S.SO_QA_QTY,0) AS DECIMAL(13,3)) AS QA_QTY,

        CAST(
          ROUND(
            ROUND(COALESCE(o.OWN_QA_QTY,0) * COALESCE(R.ZRATE,0), 2)
            + ROUND(COALESCE(S.SO_QA_VAL_RAW,0), 2),
          2)
          AS DECIMAL(15,2)
        ) AS QA_VAL,

        CAST(COALESCE(SB.SBCN_QTY,0) AS DECIMAL(13,3)) AS SBCN_QTY,
        CAST(ROUND(COALESCE(SB.SBCN_QTY,0) * COALESCE(R.ZRATE,0), 2) AS DECIMAL(15,2)) AS SBCN_VAL,

        CAST(0 AS DECIMAL(13,3)) AS FREE_QTY,
        CAST(0 AS DECIMAL(15,2)) AS FREE_VAL,

        CAST(COALESCE(R.ZRATE,0) AS DECIMAL(15,2)) AS ZRATE,
        CAST(COALESCE(o.OWN_QA_QTY,0) + COALESCE(S.SO_QA_QTY,0) AS DECIMAL(13,3)) AS INSME,

        m.MTART AS MTART

      FROM :LT_MAT  AS m
      LEFT OUTER JOIN :LT_RATE AS R ON R.MATNR = m.MATNR
      LEFT OUTER JOIN :LT_MOQ  AS Q ON Q.MATNR = m.MATNR
      LEFT OUTER JOIN :LT_OWN  AS o ON o.MATNR = m.MATNR
      LEFT OUTER JOIN :LT_SO   AS S ON S.MATNR = m.MATNR
      LEFT OUTER JOIN :LT_SBCN AS SB ON SB.MATNR = m.MATNR
      LEFT OUTER JOIN :LT_WIP  AS W ON W.MATNR = m.MATNR
      WHERE
        (
          COALESCE(o.OWN_UNRST_QTY,0) + COALESCE(S.SO_UNRST_QTY,0)
          + COALESCE(W.WIP_QTY,0)
          + COALESCE(o.OWN_QA_QTY,0) + COALESCE(S.SO_QA_QTY,0)
          + COALESCE(SB.SBCN_QTY,0)
        ) > 0;

  ENDMETHOD.

ENDCLASS.

