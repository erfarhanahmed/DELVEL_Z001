CLASS zcl_amdp_supp_doc DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION ZTF_SUPP_MATDOC.
ENDCLASS.

CLASS zcl_amdp_supp_doc IMPLEMENTATION.


METHOD get_data
  BY DATABASE FUNCTION FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING ekko ekpo dfkkbptaxnum matdoc eina .

  RETURN
  SELECT
    :p_client                     AS mandt,
    CAST(K.lifnr AS NVARCHAR(10))  AS supplier,
    CAST(F.mblnr AS NVARCHAR(10))  AS materialdocument,
    CAST(F.zeile AS NVARCHAR(6))   AS materialdocumentitem,
    CAST(F.ebeln AS NVARCHAR(10))  AS purchaseorder,
    CAST(F.ebelp AS NVARCHAR(5))   AS purchaseorderitem,
    CAST(F.bwart AS NVARCHAR(3))   AS goodsmovementtype,
    CAST(F.matnr AS NVARCHAR(40))  AS material,
    CAST(F.werks AS NVARCHAR(4))   AS plant,
    F.budat                       AS postingdate,
    CAST(F.menge AS DECIMAL(13,3)) AS quantityinbaseunit,
    k.ekgrp                       AS purchasinggroup,
    b.infnr                       AS infnr,
    B.urzzt                       AS urzzt,
    t.taxnum as taxnumber,
    f.bukrs as bukrs,
    f.lfbnr
  FROM matdoc AS F
  INNER JOIN ekko AS K
     ON K.mandt = :p_client
    AND K.ebeln = F.ebeln
    AND K.bsart IN ('ZIMP','NB')

  INNER JOIN ekpo AS P
     ON P.mandt = :p_client
    AND P.ebeln = K.ebeln
    AND P.ebelp = F.ebelp
    AND P.loekz = ''
  INNER JOIN dfkkbptaxnum AS T
     ON T.partner = K.lifnr
    AND T.taxtype = 'IN4'
*  inner JOIN eine AS E
*     ON E.mandt = :p_client
*    AND E.ekgrp = K.ekgrp
  inner JOIN eina AS B
     ON B.mandt = :p_client
*    AND B.infnr = E.infnr
    AND B.lifnr = f.lifnr
    and b.matnr = f.matnr

  WHERE F.mandt = :p_client
  and   f.budat BETWEEN :p_date_low AND :p_date_high
  and b.urzzt is noT NULL  and  B.urzzt <> ' ' and t.taxnum is nOT NULL and t.taxnum <> ' ' and f.bwart = '101'  and f.cancelled <> 'X'
    -- Dynamic Filter using LOCATE (Standard SQLScript)
    AND ( :p_ekgrp_str = '' OR LOCATE(',' || :p_ekgrp_str || ',', ',' || k.ekgrp || ',') > 0 )
*    AND ( :p_lifnr_str = '' OR LOCATE(',' || :p_lifnr_str || ',', ',' || K.lifnr || ',') > 0 )
     AND ( :p_lifnr_str = ''
      OR LOCATE(',' || LTRIM(k.lifnr,'0') || ',', ',' || :p_lifnr_str || ',') > 0 )

    AND ( :p_werks_str = '' OR LOCATE(',' || :p_werks_str || ',', ',' || F.werks || ',') > 0 )
    AND ( :p_bukrs_str = '' OR LOCATE(',' || :p_bukrs_str || ',', ',' || K.bukrs || ',') > 0 );

ENDMETHOD.

ENDCLASS.



