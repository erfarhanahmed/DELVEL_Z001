
DATA : LV_UDATE TYPE CDHDR-UDATE,
       LV_zeivr TYPE CDPOS-VALUE_OLD,
       LV_zeivr1 TYPE CDPOS-VALUE_OLD,
       LV_CHANG TYPE CDHDR-CHANGENR.
DATA : IT_CDPOS TYPE STANDARD TABLE OF TY_CDPOS,
       WA_CDPOS TYPE TY_CDPOS.
DATA : IT_CDPOS1 TYPE STANDARD TABLE OF TY_CDPOS,
       WA_CDPOS1 TYPE TY_CDPOS.
DATA : IT_CDHDR TYPE STANDARD TABLE OF TY_CDHDR,
       WA_CDHDR TYPE TY_CDHDR.
DATA : wa_mseg TYPE t_mseg,
       "LT_MSEG    TYPE STANDARD TABLE OF T_MSEG,
       lt_makt TYPE STANDARD TABLE OF t_makt.

DATA : lwa_mseg    TYPE t_mseg,
       lwa_makt    TYPE t_makt,
       lwa_gr_item TYPE t_gr.

READ TABLE it_docs INTO ypm_gr_str INDEX 1.

SELECT zeile
       ebeln
       ebelp
       matnr
       lsmng
       lsmeh
       erfmg
       erfme
       bpmng
       bprme
       lifnr
       bwart
       lgort
       shkzg
       insmk
       aufnr
       mat_kdauf
       INTO TABLE lt_mseg FROM mseg
       WHERE mblnr = ypm_gr_str-mblnr
       AND   mjahr = ypm_gr_str-mjahr
       AND bwart = '101'.


SELECT aufnr
       kdauf
       kdpos
       FROM afpo
       INTO TABLE lt_afpo
       FOR ALL ENTRIES IN lt_mseg
       WHERE aufnr = lt_mseg-aufnr.

SORT lt_mseg BY matnr.
SELECT matnr maktx FROM makt
INTO TABLE lt_makt
FOR ALL ENTRIES IN lt_mseg
WHERE
matnr  =  lt_mseg-matnr AND
spras  =  sy-langu.

LOOP AT lt_mseg INTO lwa_mseg.
  IF sy-tabix = 1.
    SELECT SINGLE * FROM lfa1 INTO gv_lfa1 WHERE
    lifnr = lwa_mseg-lifnr.
    gv_mseg-mblnr = ypm_gr_str-mblnr.
    gv_mseg-mjahr = ypm_gr_str-mjahr.
* break primus.
    SELECT SINGLE * FROM vbak INTO gv_vbak WHERE
      vbeln = lwa_mseg-mat_kdauf.

* BREAK PRIMUS.
    SELECT SINGLE * FROM mkpf INTO gv_mkpf WHERE
    mblnr = ypm_gr_str-mblnr AND
    mjahr = ypm_gr_str-mjahr.
    SELECT SINGLE * FROM mseg INTO gv_mseg WHERE
    mblnr = ypm_gr_str-mblnr AND
    mjahr = ypm_gr_str-mjahr.

    SELECT SINGLE * FROM j_1igrxref INTO gv_1igrxref WHERE
    mblnr = ypm_gr_str-mblnr AND
    mjahr = ypm_gr_str-mjahr.
    SELECT SINGLE bedat waers  FROM ekko INTO (gv_podate,gv_waers ) WHERE
    ebeln = gv_mseg-ebeln.
  ENDIF.

  lwa_gr_item-zeile  = lwa_mseg-zeile.
  lwa_gr_item-matnr  = lwa_mseg-matnr.
  READ TABLE lt_makt INTO lwa_makt
  WITH KEY
  matnr  =   lwa_mseg-matnr.
  IF sy-subrc = 0.
    lwa_gr_item-maktx  = lwa_makt-maktx.
  ENDIF.
***<<<<PO QUANTITY
  SELECT SINGLE * FROM ekpo INTO wa_ekpo
  WHERE ebeln = lwa_mseg-ebeln AND
  ebelp = lwa_mseg-ebelp.

  CLEAR  lv_txt1.

  IF wa_ekpo-netpr <> 0.
    lv_txt1 = 'BILLABLE'.
  ELSE.
    lv_txt1 = 'NON BILLABLE'  .
  ENDIF.

  SELECT SINGLE * FROM ekko INTO wa_ekko
    WHERE ebeln = lwa_mseg-ebeln.

  SELECT kschl kawrt kwert FROM konv INTO CORRESPONDING FIELDS OF TABLE it_konv
    WHERE knumv = wa_ekko-knumv
    AND   ( kschl = 'FRA1' OR
            kschl = 'FRB1' OR
            kschl = 'FRC1' OR
            kschl = 'FRA2' OR
            kschl = 'FRB2' OR
            kschl = 'FRC2'  OR
            kschl = 'JOCM' ).

******************************************************
  SELECT mblnr lmenge04 FROM qals
    INTO CORRESPONDING FIELDS OF TABLE it_qals
    WHERE mblnr = ypm_gr_str-mblnr.

  lwa_gr_item-menge_po   = wa_ekpo-menge.
  lwa_gr_item-meins_po   = lwa_mseg-bprme.

  lwa_gr_item-menge_ch   = lwa_mseg-lsmng.
  lwa_gr_item-meins_ch   = lwa_mseg-lsmeh.

  lwa_gr_item-menge_gr   = lwa_mseg-erfmg.
  lwa_gr_item-meins_gr   = lwa_mseg-erfme.

  lwa_gr_item-menge_df   = lwa_gr_item-menge_ch - lwa_gr_item-menge_gr.

  CLEAR  lv_txt.
  CASE gv_mseg-insmk.
    WHEN 'X'.
      lv_txt = 'YES'.
    WHEN OTHERS.
      lv_txt = 'NO'.
  ENDCASE.
**************AVINASH BHAGAT
*  select SINGLE UDATE from cdhdr INTO LV_UDATE WHERE OBJECTID = lwa_mseg-EBELN.
*  SELECT OBJECTID CHANGENR FROM CDPOS INTO TABLE IT_CDPOS WHERE OBJECTID = lwa_mseg-MATNR
*AND TABNAME = 'MARA' AND FNAME = 'ZEIVR'.
*    IF IT_CDPOS IS NOT INITIAL.
*    SELECT OBJECTID CHANGENR FROM cdhdr INTO TABLE IT_CDHDR FOR ALL ENTRIES IN IT_CDPOS  WHERE OBJECTID = lwa_mseg-MATNR
*      AND UDATE GE LV_UDATE AND CHANGENR = IT_CDPOS-CHANGENR .
*      SORT IT_CDHDR  ASCENDING BY CHANGENR.
*      READ TABLE IT_CDHDR INTO WA_CDHDR INDEX 1.
*      LV_CHANG = WA_CDHDR-CHANGENR.
*      ENDIF.
*      SELECT SINGLE VALUE_OLD FROM CDPOS INTO LV_zeivr WHERE OBJECTID = lwa_mseg-MATNR
*        AND TABNAME = 'MARA' AND FNAME = 'ZEIVR' AND CHANGENR = LV_CHANG.
*        IF LV_zeivr IS NOT INITIAL.
*          lv_zeivr1 =  LV_zeivr.
*          ELSE.
*            SELECT SINGLE zeivr FROM MARA INTO lv_zeivr1 WHERE MATNR = lwa_mseg-MATNR.
*            ENDIF.
*
*************  END AVINASH BHAGAT
  APPEND lwa_gr_item TO gt_gr_item.
  CLEAR : lwa_gr_item.

ENDLOOP.
SELECT matnr
       werks
       lgort
       lgpbe
  FROM mard
  INTO TABLE gt_mard
  FOR ALL ENTRIES IN lt_mseg
  WHERE matnr = lt_mseg-matnr
*  AND   werks = lt_mseg-werks
  AND   lgort = lt_mseg-lgort.


DATA : addrnumber TYPE adrc-addrnumber.
*>>> COMPANY CODE ADDRESS
SELECT SINGLE adrnr FROM t001
INTO addrnumber
WHERE bukrs = gv_mseg-bukrs.

SELECT SINGLE name1 name2 city1 name_co str_suppl1
str_suppl2 str_suppl3 street bezei landx post_code1
tel_number tel_extens fax_number fax_extens
FROM adrc AS a INNER JOIN t005t AS b
ON a~country = b~land1 INNER JOIN t005u AS c
ON a~country = c~land1 AND a~region = c~bland
INTO CORRESPONDING FIELDS OF wa_compadrc
WHERE addrnumber = addrnumber AND b~spras = 'E'
AND c~spras = 'E'.


SELECT mblnr mjahr vgart FROM mkpf
  INTO TABLE gt_mkpf
  FOR ALL ENTRIES IN it_docs
  WHERE mblnr = it_docs-mblnr
  AND   mjahr = it_docs-mjahr.


LOOP AT lt_mseg INTO wa_mseg1.

  SELECT ebeln pstyp FROM ekpo
    INTO TABLE gt_ekpo
    WHERE ebeln = wa_mseg1-ebeln.

ENDLOOP.



**SELECT SINGLE *  FROM MARA INTO WA_MARA
**       WHERE MATNR = WA_GR_ITEM-MATNR."LWA_MSEG-MATNR.
