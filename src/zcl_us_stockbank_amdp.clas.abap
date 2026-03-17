CLASS zcl_us_stockbank_amdp DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    "===== Output type (LT_SORT equivalent) =====
    TYPES: BEGIN OF ty_sort,
             matnr           TYPE mara-matnr,
             wrkst           TYPE mara-wrkst,
             mattxt          TYPE text100,
             ersda           TYPE mara-ersda,

             open_qty        TYPE p LENGTH 16 DECIMALS 0,
             open_qty_v      TYPE p LENGTH 16 DECIMALS 2,
             price           TYPE p LENGTH 16 DECIMALS 2,
             un_qty          TYPE p LENGTH 16 DECIMALS 0,
             un_val          TYPE p LENGTH 16 DECIMALS 2,

             labst           TYPE p LENGTH 16 DECIMALS 0,
             labst_v         TYPE p LENGTH 16 DECIMALS 2,
             kulab           TYPE p LENGTH 16 DECIMALS 0,
             kulab_v         TYPE p LENGTH 16 DECIMALS 2,
             tran_qty_new    TYPE p LENGTH 16 DECIMALS 0,
             tran_qty_v_new  TYPE p LENGTH 16 DECIMALS 2,
             free_stock      TYPE p LENGTH 16 DECIMALS 0,
             free_stock_v    TYPE p LENGTH 16 DECIMALS 2,
             pend_po_qty     TYPE p LENGTH 16 DECIMALS 0,

             so_fall_qty     TYPE p LENGTH 16 DECIMALS 0,
             so_fall_qty_v   TYPE p LENGTH 16 DECIMALS 2,
             open_inv        TYPE p LENGTH 16 DECIMALS 0,
             amount          TYPE p LENGTH 16 DECIMALS 2,
             value           TYPE p LENGTH 16 DECIMALS 2,

             zseries         TYPE mara-zseries,
             mtart           TYPE mara-mtart,
             bklas           TYPE mbew-bklas,
             brand           TYPE mara-brand,
             moc             TYPE mara-moc,
             zsize           TYPE mara-zsize,
             type            TYPE mara-type,
             menge_104       TYPE p LENGTH 16 DECIMALS 2,
             qty_104_val     TYPE p LENGTH 16 DECIMALS 2,
             po_value        TYPE p LENGTH 16 DECIMALS 2,

           END OF ty_sort.

    TYPES tt_sort TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY.

   CLASS-METHODS get_lt_sort
      IMPORTING
        VALUE(it_matnr) TYPE ztt_matnr_key
        VALUE(it_werks) TYPE ztt_werks_key
      EXPORTING
        VALUE(et_sort)  TYPE tt_sort
      RAISING cx_amdp_execution_failed.

ENDCLASS.



CLASS zcl_us_stockbank_amdp IMPLEMENTATION.

  METHOD get_lt_sort
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT

    OPTIONS READ-ONLY
    USING mara  makt mbew
          vbup vbap vbak prcd_elements lips
          NSDM_V_MSKU ekpo eket mseg NSDM_V_MARD NSDM_V_MSKA           acdoca_m_extract.

    /*****************************************************************
      0) Material base (restrict to requested materials)
    *****************************************************************/
    mat_base =
      SELECT
        m.matnr,
        m.wrkst,
        m.brand,
        m.zseries,
        m.zsize,
        m.moc,
        m.type,
        m.ersda,
        m.mtart
      FROM mara AS m
      WHERE m.mandt = SESSION_CONTEXT('CLIENT')
        AND m.matnr IN ( SELECT matnr FROM :it_matnr );

    /*****************************************************************
      1) Moving price / UN_VAL from MBEW
    *****************************************************************/
*    mbew_pick =
*      SELECT matnr, bwkey AS werks, bklas, salk3, vprsv, verpr, stprs
*      FROM (
*        SELECT
*          matnr,
*          bwkey,
*          bklas,
*          salk3,
*          vprsv,
*          verpr,
*          stprs,
*          ROW_NUMBER() OVER (
*            PARTITION BY matnr, bwkey
*            ORDER BY
*              CASE WHEN COALESCE(bwtar,'') = '' THEN 0 ELSE 1 END,
*              COALESCE(bwtar,'')
*          ) AS rn
*        FROM MBEW
*        WHERE mandt = SESSION_CONTEXT('CLIENT')
*          AND matnr IN ( SELECT matnr FROM :it_matnr )
*          AND bwkey IN ( SELECT werks FROM :it_werks )
*      )
*      WHERE rn = 1;
 mbew_pick = SELECT  m.matnr,
        m.bwkey AS werks,
        m.bklas,
*        m.salk3,
        m.vprsv,
        m.verpr,
        m.stprs,
        COALESCE(a.hsl_sum, 0) AS salk3
FROM (
      SELECT matnr,
             bwkey,
             bklas,
             salk3,
             vprsv,
             verpr,
             stprs,
             ROW_NUMBER() OVER (
                 PARTITION BY matnr, bwkey
                 ORDER BY CASE WHEN COALESCE(bwtar,'')='' THEN 0 ELSE 1 END,
                          COALESCE(bwtar,'')
             ) AS rn
      FROM MBEW
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND bwkey IN ( SELECT werks FROM :it_werks )
     ) AS m
LEFT JOIN (
      SELECT matnr,
             bwkey,
             SUM(hsl) AS hsl_sum
      FROM ACDOCA_M_EXTRACT
      WHERE rclnt =  SESSION_CONTEXT('CLIENT')
         and matnr IN ( SELECT matnr FROM :it_matnr )
        AND bwkey IN ( SELECT werks FROM :it_werks )
        and
      fiscyearper            = '9999999'
  and ryear                  = '9999'
  and poper                  = '999'
  and ML_SOBKZ              <> 'E'
      GROUP BY matnr, bwkey
     ) AS a
ON m.matnr = a.matnr
AND m.bwkey = a.bwkey
WHERE m.rn = 1;



    mbew_werks =
      SELECT
        matnr,
        werks,
        MAX(bklas) AS bklas,
        SUM(salk3) AS un_val_werks,
        MAX(CASE WHEN vprsv = 'V' THEN verpr ELSE stprs END) AS value_werks
      FROM :mbew_pick
      GROUP BY matnr, werks;

    mbew_rowcnt =
      SELECT
        matnr,
        COUNT(*) AS rowcnt
      FROM mbew
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND bwkey IN ( SELECT werks FROM :it_werks )
      GROUP BY matnr;

    mbew_value_sum =
      SELECT
        matnr,
        SUM(value_werks) AS value_sum
      FROM :mbew_werks
      GROUP BY matnr;

    mbew_value_abap =
      SELECT
        s.matnr,
        CASE
          WHEN COALESCE(c.rowcnt,0) = 2 THEN s.value_sum / 2
          ELSE s.value_sum
        END AS value_abap
      FROM :mbew_value_sum AS s
      LEFT JOIN :mbew_rowcnt AS c
        ON c.matnr = s.matnr;

    bklas_mat =
      SELECT matnr, MAX(bklas) AS bklas_any
      FROM :mbew_werks
      GROUP BY matnr;

    /*****************************************************************
      2) LABST – stock in hand (MARD sum across ALL LGORT)
    *****************************************************************/
 stock_labst_mard =
  SELECT
    d.matnr,
    d.werks,
    SUM( COALESCE(d.labst, 0) ) AS labst_qty_mard
  FROM NSDM_V_MARD AS d
  WHERE d.mandt = SESSION_CONTEXT('CLIENT')
    AND d.matnr IN ( SELECT matnr FROM :it_matnr )
    AND d.werks IN ( SELECT werks FROM :it_werks )
  GROUP BY d.matnr, d.werks;

  stock_labst_mska =
  SELECT
    s.matnr,
    s.werks,
    SUM( COALESCE(s.kalab, 0) ) AS labst_qty_mska
  FROM NSDM_V_MSKA AS s
  WHERE s.mandt = SESSION_CONTEXT('CLIENT')
    AND s.matnr IN ( SELECT matnr FROM :it_matnr )
    AND s.werks IN ( SELECT werks FROM :it_werks )
  GROUP BY s.matnr, s.werks;

*stock_labst_MSKU =
*  selECT
*      ku.matnr,
*      ku.werks,
*      SUM( COALESCE(ku.KULAB, 0) ) AS labst_qty_msku
*      from NSDM_V_MSKU as ku
*        WHERE ku.mandt = SESSION_CONTEXT('CLIENT')
*    AND ku.matnr IN ( SELECT matnr FROM :it_matnr )
*    AND ku.werks IN ( SELECT werks FROM :it_werks )
*  GROUP BY ku.matnr, ku.werks;


    stock_labst =
      SELECT
        d.matnr,
        d.werks,
        SUM(COALESCE(d.labst,0)) AS labst_qty
*          SUM ( labst ) AS labst_qty
      FROM NSDM_V_MARD AS d
      WHERE d.mandt = SESSION_CONTEXT('CLIENT')
        AND d.matnr IN ( SELECT matnr FROM :it_matnr )
        AND d.werks IN ( SELECT werks FROM :it_werks )
      GROUP BY d.matnr, d.werks;

*stock_labst =
*  SELECT
*    COALESCE(m.matnr, k.matnr, u.matnr) AS matnr,
*    COALESCE(m.werks, k.werks, u.werks) AS werks,
*    (
*      COALESCE(m.labst_qty_mard, 0)
**    + COALESCE(k.labst_qty_mska, 0)
**    + COALESCE(u.labst_qty_msku, 0)
*    ) AS labst_qty
*  FROM :stock_labst_mard AS m
*  FULL OUTER JOIN :stock_labst_mska AS k
*    ON k.matnr = m.matnr
*   AND k.werks = m.werks;
**  FULL OUTER JOIN :stock_labst_msku AS u
**    ON u.matnr = COALESCE(m.matnr, k.matnr)
**   AND u.werks = COALESCE(m.werks, k.werks);

*mard = select *
*              from NSDM_V_MARD
*              wHERE mandt = '060'
*              and matnr = '210075TA878BTF91S'
*              and werks = 'US01';
    /*****************************************************************
      3) Consignment KULAB per MATNR+WERKS
    *****************************************************************/
    cons_kulab =
      SELECT
        matnr,
        werks,
        SUM(COALESCE(kulab,0)) AS kulab_qty
*      FROM msku
from NSDM_V_MSKU
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND werks IN ( SELECT werks FROM :it_werks )
      GROUP BY matnr, werks;


*cons_kulab =
*  SELECT
*    matnr,
*    werks,
*    SUM(stock_qty) AS kulab_qty
*  FROM (
*        SELECT
*          s.matnr,
*          s.werks,
*          COALESCE(s.kalab, 0) AS stock_qty
*        FROM NSDM_V_MSKA AS s
*        WHERE s.mandt = SESSION_CONTEXT('CLIENT')
*          AND s.matnr IN ( SELECT matnr FROM :it_matnr )
*          AND s.werks IN ( SELECT werks FROM :it_werks )
*
*        UNION ALL
*
*        SELECT
*          k.matnr,
*          k.werks,
*          COALESCE(k.kulab, 0) AS stock_qty
*        FROM NSDM_V_MSKU AS k
*        WHERE k.mandt = SESSION_CONTEXT('CLIENT')
*          AND k.matnr IN ( SELECT matnr FROM :it_matnr )
*          AND k.werks IN ( SELECT werks FROM :it_werks )
*       ) t
*  GROUP BY matnr, werks;


    /*****************************************************************
      4) OPEN_QTY and PRICE (Pending SO value) – ABAP equivalent
    *****************************************************************/
    vbup_open =
      SELECT vbeln, posnr
      FROM vbup
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND lfsta <> 'C';

    so_items =
      SELECT
        a.vbeln,
        a.posnr,
        a.matnr,
        a.werks,
        a.kwmeng,
        a.pstyv
      FROM vbap AS a
      INNER JOIN :vbup_open AS u
        ON u.vbeln = a.vbeln
       AND u.posnr = a.posnr
      WHERE a.mandt = SESSION_CONTEXT('CLIENT')
        AND a.werks IN ( SELECT werks FROM :it_werks )
        AND a.abgru = ''
        AND a.matnr IN ( SELECT matnr FROM :it_matnr );

    vbak_ok =
      SELECT vbeln, knumv
      FROM vbak
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND vbtyp IN ( 'C', 'I', 'H' )
        AND vbeln IN ( SELECT DISTINCT vbeln FROM :so_items );

    zpr0_pick =
      SELECT knumv, kposn, kbetr
      FROM (
        SELECT
          knumv,
          kposn,
          kbetr,
          ROW_NUMBER() OVER (
            PARTITION BY knumv, kposn
            ORDER BY COALESCE(stunr,0), COALESCE(zaehk,0)
          ) AS rn
        FROM prcd_elements
        WHERE kschl = 'ZPR0'
          AND knumv IN ( SELECT DISTINCT knumv FROM :vbak_ok )
      )
      WHERE rn = 1;

    deliv_item =
      SELECT
        s.vbeln,
        s.posnr,
        SUM(COALESCE(l.lfimg,0)) AS del_qty
      FROM :so_items AS s
      LEFT JOIN lips AS l
        ON l.mandt = SESSION_CONTEXT('CLIENT')
       AND l.vgbel = s.vbeln
       AND l.vgpos = s.posnr
      GROUP BY s.vbeln, s.posnr;

    so_item_calc =
      SELECT
        s.matnr,
        s.werks,

        CASE WHEN h.vbeln IS NOT NULL THEN s.kwmeng ELSE 0 END AS vbap_qty_item,
        COALESCE(d.del_qty,0) AS lips_qty_item,

        CASE
          WHEN s.pstyv <> 'ZKLN'
          THEN
            (
              (CASE WHEN h.vbeln IS NOT NULL THEN s.kwmeng ELSE 0 END)
              - COALESCE(d.del_qty,0)
            ) * COALESCE(z.kbetr,0)
          ELSE 0
        END AS pending_val_item

      FROM :so_items AS s
      LEFT JOIN :vbak_ok AS h
        ON h.vbeln = s.vbeln
      LEFT JOIN :deliv_item AS d
        ON d.vbeln = s.vbeln AND d.posnr = s.posnr
      LEFT JOIN :zpr0_pick AS z
        ON z.knumv = h.knumv AND z.kposn = s.posnr;

    so_calc =
      SELECT
        matnr,
        werks,
        SUM(vbap_qty_item)    AS vbap_qty,
        SUM(lips_qty_item)    AS lips_qty,
        SUM(pending_val_item) AS pending_so_val
      FROM :so_item_calc
      GROUP BY matnr, werks;

    /*****************************************************************
      5) Open invoice qty
    *****************************************************************/
    open_inv =
      SELECT
        a.matnr,
        a.werks,
        SUM(a.lfimg) AS open_inv_qty
      FROM lips AS a
      INNER JOIN vbup AS b
        ON b.mandt = a.mandt
       AND b.vbeln = a.vbeln
       AND b.posnr = a.posnr
      WHERE a.mandt = SESSION_CONTEXT('CLIENT')
        AND a.matnr IN ( SELECT matnr FROM :it_matnr )
        AND a.werks IN ( SELECT werks FROM :it_werks )
        AND a.vkbur IN ( 'US01', 'US02', 'US03' )
        AND b.fksta <> 'C'
      GROUP BY a.matnr, a.werks;

    /*****************************************************************
      6) GRN: last price + GRN value (reversal exclusion)
    *****************************************************************/
    grn_base =
      SELECT
        matnr, werks, mblnr, menge, dmbtr
      FROM mseg
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND werks IN ( SELECT werks FROM :it_werks )
        AND bwart IN ( '101', '105' )
        AND kzbew <> 'F';

   grn_value =
      SELECT
        g.matnr,
        g.werks,
        SUM(g.dmbtr) AS grn_value
      FROM :grn_base AS g
      WHERE NOT EXISTS (
        SELECT 1
        FROM mseg AS r
        WHERE r.mandt = SESSION_CONTEXT('CLIENT')
          AND r.smbln = g.mblnr
          AND r.matnr = g.matnr
      )
      GROUP BY g.matnr, g.werks;

grn_last_price =
      SELECT
        x.matnr,
        x.werks,
        MAX(x.last_price) AS last_price
      FROM (
        SELECT
          g.matnr,
          g.werks,
          CASE WHEN g.menge <> 0 THEN g.dmbtr / g.menge ELSE 0 END AS last_price,
          ROW_NUMBER() OVER (PARTITION BY g.matnr, g.werks ORDER BY g.mblnr DESC) AS rn
        FROM :grn_base AS g
      ) AS x
      WHERE x.rn = 1
      GROUP BY x.matnr, x.werks;
*    grn_last_price =
*      SELECT matnr, werks,
*             MAX(last_price) AS last_price
*      FROM (
*        SELECT
*          matnr,
*          werks,
*          CASE WHEN menge <> 0 THEN dmbtr / menge ELSE 0 END AS last_price,
*          ROW_NUMBER() OVER (PARTITION BY matnr, werks ORDER BY mblnr DESC) AS rn
*        FROM :grn_base
*      )
*      WHERE rn = 1
*      GROUP BY matnr, werks;

    /*****************************************************************
      7) Pending PO qty and PO value
    *****************************************************************/
    po_norm =
      SELECT
        a.matnr,
        a.werks,
        SUM(CASE WHEN (a.elikz <> 'X' OR b.wemng <> 0) THEN a.menge ELSE 0 END) AS menge2,
        SUM(b.wemng) AS menge3,
        SUM(CASE WHEN (a.elikz <> 'X' OR b.wemng <> 0) THEN a.brtwr ELSE 0 END) AS po_val
      FROM ekpo AS a
      INNER JOIN eket AS b
        ON b.mandt = a.mandt
       AND b.ebeln = a.ebeln
       AND b.ebelp = a.ebelp
      WHERE a.mandt = SESSION_CONTEXT('CLIENT')
        AND a.matnr IN ( SELECT matnr FROM :it_matnr )
        AND a.werks IN ( SELECT werks FROM :it_werks )
        AND a.loekz <> 'L'
        AND a.retpo <> 'X'
      GROUP BY a.matnr, a.werks;

    po_ret =
      SELECT
        matnr,
        werks,
        SUM(menge) AS menge4,
        SUM(brtwr) AS po_val1
      FROM ekpo
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND werks IN ( SELECT werks FROM :it_werks )
        AND retpo = 'X'
      GROUP BY matnr, werks;

    po_calc =
      SELECT
        n.matnr,
        n.werks,
        GREATEST(COALESCE(n.menge2,0) - COALESCE(n.menge3,0) - COALESCE(r.menge4,0), 0) AS pend_po_qty,
        GREATEST((COALESCE(n.po_val,0) - COALESCE(r.po_val1,0)) - COALESCE(g.grn_value,0), 0) AS po_value
      FROM :po_norm AS n
      LEFT JOIN :po_ret AS r
        ON r.matnr = n.matnr AND r.werks = n.werks
      LEFT JOIN :grn_value AS g
        ON g.matnr = n.matnr AND g.werks = n.werks;

    /*****************************************************************
      8) Transit qty/value NEW (103 - 105 - 104)
    *****************************************************************/
    transit_po =
      SELECT ebeln, ebelp, matnr, werks, netpr
      FROM ekpo
      WHERE mandt = SESSION_CONTEXT('CLIENT')
        AND matnr IN ( SELECT matnr FROM :it_matnr )
        AND werks IN ( SELECT werks FROM :it_werks );

    mseg103 =
      SELECT t.ebeln, t.ebelp, m.matnr, m.werks, m.mblnr, SUM(m.menge) AS qty103
      FROM :transit_po AS t
      INNER JOIN mseg AS m
        ON m.mandt = SESSION_CONTEXT('CLIENT')
       AND m.ebeln = t.ebeln
       AND m.ebelp = t.ebelp
       AND m.matnr = t.matnr
       AND m.werks = t.werks
      WHERE m.bwart = '103'
        AND NOT EXISTS (
          SELECT 1 FROM mseg AS r
          WHERE r.mandt = SESSION_CONTEXT('CLIENT')
            AND r.smbln = m.mblnr
            AND r.matnr = m.matnr
        )
      GROUP BY t.ebeln, t.ebelp, m.matnr, m.werks, m.mblnr;

    mseg105 =
      SELECT t.ebeln, t.ebelp, m.matnr, m.werks, SUM(m.menge) AS qty105
      FROM :transit_po AS t
      INNER JOIN mseg AS m
        ON m.mandt = SESSION_CONTEXT('CLIENT')
       AND m.ebeln = t.ebeln
       AND m.ebelp = t.ebelp
       AND m.matnr = t.matnr
       AND m.werks = t.werks
      WHERE m.bwart = '105'
        AND NOT EXISTS (
          SELECT 1 FROM mseg AS r
          WHERE r.mandt = SESSION_CONTEXT('CLIENT')
            AND r.smbln = m.mblnr
            AND r.matnr = m.matnr
        )
      GROUP BY t.ebeln, t.ebelp, m.matnr, m.werks;

    mseg104 =
      SELECT
        t.ebeln,
        t.ebelp,
        m.matnr,
        m.werks,
        SUM(m.menge) AS qty104
      FROM :transit_po AS t
      INNER JOIN mseg AS m
        ON m.mandt = SESSION_CONTEXT('CLIENT')
       AND m.ebeln = t.ebeln
       AND m.ebelp = t.ebelp
       AND m.matnr = t.matnr
       AND m.werks = t.werks
      WHERE m.bwart = '104'
        AND COALESCE(m.smbln,'') = ''
        AND EXISTS (
          SELECT 1
          FROM :mseg103 AS x
          WHERE x.ebeln = t.ebeln
            AND x.ebelp = t.ebelp
            AND x.matnr = m.matnr
            AND x.werks = m.werks
            AND x.mblnr = m.lfbnr
        )
      GROUP BY t.ebeln, t.ebelp, m.matnr, m.werks;

    transit_calc =
      SELECT
        t.matnr,
        t.werks,
        SUM(COALESCE(x.qty103,0) - COALESCE(y.qty105,0) - COALESCE(z.qty104,0)) AS tran_qty_new,
        SUM((COALESCE(x.qty103,0) - COALESCE(y.qty105,0) - COALESCE(z.qty104,0)) * COALESCE(t.netpr,0)) AS tran_qty_v_new,
        SUM(COALESCE(z.qty104,0)) AS menge_104
      FROM :transit_po AS t
      LEFT JOIN (
        SELECT ebeln, ebelp, matnr, werks, SUM(qty103) AS qty103
        FROM :mseg103
        GROUP BY ebeln, ebelp, matnr, werks
      ) AS x
        ON x.ebeln = t.ebeln AND x.ebelp = t.ebelp AND x.matnr = t.matnr AND x.werks = t.werks
      LEFT JOIN :mseg105 AS y
        ON y.ebeln = t.ebeln AND y.ebelp = t.ebelp AND y.matnr = t.matnr AND y.werks = t.werks
      LEFT JOIN :mseg104 AS z
        ON z.ebeln = t.ebeln AND z.ebelp = t.ebelp AND z.matnr = t.matnr AND z.werks = t.werks
      GROUP BY t.matnr, t.werks;

    /*****************************************************************
      9) Per plant base
    *****************************************************************/
    per_werks =
      SELECT
        b.matnr,
        w.werks,

        COALESCE(sl.labst_qty,0) AS labst,
        COALESCE(ka.labst_qty_mska,0) AS labst_qty_mska,

        COALESCE(sk.kulab_qty,0) AS kulab,
        (COALESCE(so.vbap_qty,0) - COALESCE(so.lips_qty,0)) AS open_qty,
        COALESCE(so.pending_so_val,0) AS price,

        COALESCE(inv.open_inv_qty,0) AS open_inv,

        COALESCE(po.pend_po_qty,0) AS pend_po_qty,
        COALESCE(po.po_value,0) AS po_value,

        COALESCE(tr.tran_qty_new,0) AS tran_qty_new,
        COALESCE(tr.tran_qty_v_new,0) AS tran_qty_v_new,
        COALESCE(tr.menge_104,0) AS menge_104,

        COALESCE(mb.un_val_werks,0) AS un_val_werks,
        COALESCE(mb.value_werks,0)  AS value_werks,
        COALESCE(lp.last_price,0) AS amount

      FROM :mat_base AS b
      CROSS JOIN ( SELECT werks FROM :it_werks ) AS w
      LEFT JOIN :stock_labst AS sl
        ON sl.matnr = b.matnr AND sl.werks = w.werks
      LEFT JOIN :cons_kulab AS sk
        ON sk.matnr = b.matnr AND sk.werks = w.werks
       lEFT join :stock_labst_mska as KA
       on ka.matnr = b.matnr AND ka.werks = w.werks
      LEFT JOIN :so_calc AS so
        ON so.matnr = b.matnr AND so.werks = w.werks
      LEFT JOIN :open_inv AS inv
        ON inv.matnr = b.matnr AND inv.werks = w.werks
      LEFT JOIN :po_calc AS po
        ON po.matnr = b.matnr AND po.werks = w.werks
      LEFT JOIN :transit_calc AS tr
        ON tr.matnr = b.matnr AND tr.werks = w.werks
      LEFT JOIN :mbew_werks AS mb
        ON mb.matnr = b.matnr AND mb.werks = w.werks
      LEFT JOIN :grn_last_price AS lp
        ON lp.matnr = b.matnr AND lp.werks = w.werks;


   per_werks_calc =
  SELECT
    p.*,
    (COALESCE(p.kulab,0) * COALESCE(p.value_werks,0)) AS kulab_v_werks,

*    CASE
*      WHEN (COALESCE(p.un_val_werks,0) - (COALESCE(p.kulab,0) * COALESCE(p.value_werks,0))) < 0 THEN 0
*      ELSE (COALESCE(p.un_val_werks,0) - (COALESCE(p.kulab,0) * COALESCE(p.value_werks,0)))
*    END AS labst_v_werks
*(COALESCE(p.un_val_werks,0)) as labst_v_werks
*(COALESCE(p.labst,0))  * (COALESCE(p.VALUE_WERKS,0)) as labst_v_werks
 (COALESCE(p.un_val_werks,0) - (COALESCE(p.kulab,0) * COALESCE(p.value_werks,0))) as labst_v_werks
  FROM :per_werks AS p;


    /*****************************************************************
      10) Aggregate per MATNR (one row per material)
    *****************************************************************/
    agg =
      SELECT
        matnr,
        SUM(open_qty)       AS open_qty,
         SUM(open_qty * value_werks) AS open_qty_v,
        SUM(price)          AS price,
        SUM(labst)          AS labst,
        sum(labst_qty_mska) as labs_mska,
        SUM(kulab)          AS kulab,
        SUM(kulab_v_werks) AS kulab_v,

        SUM(un_val_werks)   AS un_val,
        SUM(labst_v_werks)  AS labst_v,
        SUM(open_inv)       AS open_inv,
        SUM(pend_po_qty)    AS pend_po_qty,
        SUM(po_value)       AS po_value,
        SUM(tran_qty_new)   AS tran_qty_new,
        SUM(tran_qty_v_new) AS tran_qty_v_new,
        SUM(amount)         AS amount,
        SUM(menge_104)      AS menge_104
*      FROM :per_werks
      FROM :per_werks_calc
      GROUP BY matnr;

    /*****************************************************************
      11) FINAL OUTPUT (NO GROUP BY HERE)
          One mat_base row per MATNR + one agg row per MATNR
*    *****************************************************************/
    et_sort =
      SELECT
        m.matnr AS matnr,
        COALESCE(m.wrkst,'') AS wrkst,
        COALESCE(t.maktx,'') AS mattxt,
        m.ersda AS ersda,

        CAST(COALESCE(a.open_qty,0) AS DECIMAL(31,0)) AS open_qty,
*       CAST(COALESCE(a.open_qty,0) * COALESCE(v.value_abap,0) AS DECIMAL(31,2)) AS open_qty_v,
       CAST(COALESCE(a.open_qty_v,0) AS DECIMAL(31,2)) AS open_qty_v,


        CAST(COALESCE(a.price,0)    AS DECIMAL(31,2)) AS price,
        CAST(COALESCE(a.labst,0)  + COALESCE(a.kulab,0) AS DECIMAL(31,0))  AS un_qty,
*        CAST(COALESCE(a.labst,0) +  COALESCE(a.labs_mska,0) + COALESCE(a.kulab,0) AS DECIMAL(31,0))  AS un_qty,
*        CAST(COALESCE(a.labst,0)  AS DECIMAL(31,0)) AS un_qty,
        CAST(COALESCE(a.un_val,0) AS DECIMAL(31,2)) AS un_val,



        CAST(COALESCE(a.labst,0) AS DECIMAL(31,0)) AS labst,
        CAST(COALESCE(a.labst_v,0) AS DECIMAL(31,2)) AS labst_v,
*        CAST(
*          CASE
*            WHEN (COALESCE(a.un_val,0) - (COALESCE(a.kulab,0) * COALESCE(v.value_abap,0))) < 0 THEN 0
*            ELSE (COALESCE(a.un_val,0) - (COALESCE(a.kulab,0) * COALESCE(v.value_abap,0)))
*          END
*        AS DECIMAL(31,2)) AS labst_v,



        CAST(COALESCE(a.kulab,0) AS DECIMAL(31,0)) AS kulab,
        CAST(COALESCE(a.kulab_v,0) AS DECIMAL(31,2)) AS kulab_v,
*        CAST(COALESCE(a.kulab,0) * COALESCE(v.value_abap,0) AS DECIMAL(31,2)) AS kulab_v,


         CAST(COALESCE(a.tran_qty_new,0) AS DECIMAL(31,0)) AS tran_qty_new,
        CAST(COALESCE(a.tran_qty_v_new,0) AS DECIMAL(31,2)) AS tran_qty_v_new,

        CAST(
          CASE
            WHEN (COALESCE(a.labst,0) - COALESCE(a.open_qty,0)) < 0 THEN 0
            ELSE (COALESCE(a.labst,0) - COALESCE(a.open_qty,0))
          END
        AS DECIMAL(31,0)) AS free_stock,


*        CAST(
*          (CASE
*             WHEN (COALESCE(a.labst,0) - COALESCE(a.open_qty,0)) < 0 THEN 0
*             ELSE (COALESCE(a.labst,0) - COALESCE(a.open_qty,0))
*           END) * COALESCE(v.value_abap,0)
*        AS DECIMAL(31,2)) AS free_stock_v,

        CAST(
          (CASE
             WHEN (COALESCE(a.labst,0) - COALESCE(a.open_qty,0)) < 0 THEN 0
             ELSE (COALESCE(a.labst_V,0) - COALESCE(a.open_qty_V,0))
           END)
        AS DECIMAL(31,2)) AS free_stock_v,


       CAST(COALESCE(a.pend_po_qty,0) AS DECIMAL(31,0)) AS pend_po_qty,

        CAST(
          CASE
            WHEN (COALESCE(a.open_qty,0) - COALESCE(a.labst,0) - COALESCE(a.tran_qty_new,0)) < 0 THEN 0
            ELSE (COALESCE(a.open_qty,0) - COALESCE(a.labst,0) - COALESCE(a.tran_qty_new,0))
          END
        AS DECIMAL(31,0)) AS so_fall_qty,

        CAST(
          (CASE
             WHEN (COALESCE(a.open_qty,0) - COALESCE(a.labst,0) - COALESCE(a.tran_qty_new,0)) < 0 THEN 0
             ELSE (COALESCE(a.open_qty,0) - COALESCE(a.labst,0) - COALESCE(a.tran_qty_new,0))
           END) * COALESCE(v.value_abap,0)
        AS DECIMAL(31,2)) AS so_fall_qty_v,

        CAST(COALESCE(a.open_inv,0) AS DECIMAL(31,0)) AS open_inv,
        CAST(COALESCE(a.amount,0) AS DECIMAL(31,6)) AS amount,
        CAST(COALESCE(v.value_abap,0) AS DECIMAL(31,6)) AS value,

        COALESCE(m.zseries,'') AS zseries,
        m.mtart AS mtart,
        COALESCE(bk.bklas_any,'') AS bklas,
        COALESCE(m.brand,'') AS brand,
        COALESCE(m.moc,'') AS moc,
        COALESCE(m.zsize,'') AS zsize,
        COALESCE(m.type,'') AS type,

        CAST(COALESCE(a.menge_104,0) AS DECIMAL(31,3)) AS menge_104,
        CAST(COALESCE(a.menge_104,0) * COALESCE(v.value_abap,0) AS DECIMAL(31,2)) AS qty_104_val,

        CAST(COALESCE(a.po_value,0) AS DECIMAL(31,2)) AS po_value

      FROM :mat_base AS m
      LEFT JOIN makt AS t
        ON t.mandt = SESSION_CONTEXT('CLIENT')
       AND t.matnr = m.matnr
       AND t.spras = SESSION_CONTEXT('LOCALE_SAP')
      LEFT JOIN :agg AS a
        ON a.matnr = m.matnr
      LEFT JOIN :mbew_value_abap AS v
        ON v.matnr = m.matnr
      LEFT JOIN :bklas_mat AS bk
        ON bk.matnr = m.matnr;

  ENDMETHOD.

ENDCLASS.

