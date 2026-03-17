*&---------------------------------------------------------------------*
*& Report zprd_qadata
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprd_qadata.

TYPE-POOLS:slis,
           ole2.

*******Temp Variable
DATA:
  tmp_budat TYPE mseg-budat_mkpf,
  tmp_kdauf TYPE mseg-kdauf,
  tmp_mat   TYPE mseg-matnr,
  tmp_dauat TYPE afpo-dauat,
  tmp_lgort TYPE mseg-lgort.


TYPES:
  BEGIN OF t_mat_doc,
    mblnr      TYPE mseg-mblnr,
    mjahr      TYPE mseg-mjahr,
    zeile      TYPE mseg-zeile,
    bwart      TYPE mseg-bwart,
    matnr      TYPE mseg-matnr,
    werks      TYPE mseg-werks,
    lgort      TYPE mseg-lgort,
    kunnr      TYPE mseg-kunnr,
    kdauf      TYPE mseg-kdauf,
    kdpos      TYPE mseg-kdpos,
    waers      TYPE mseg-waers,
    menge      TYPE mseg-menge,
    aufnr      TYPE mseg-aufnr,
    budat_mkpf TYPE mseg-budat_mkpf,
  END OF t_mat_doc,
  tt_mat_doc TYPE STANDARD TABLE OF t_mat_doc.

*TYPES: BEGIN OF TY_MSEG,
*         MBLNR      TYPE MSEG-MBLNR,
*         MJAHR      TYPE MSEG-MJAHR,
*         ZEILE      TYPE MSEG-ZEILE,
*         BWART      TYPE MSEG-BWART,
*         MATNR      TYPE MSEG-MATNR,
*         WERKS      TYPE MSEG-WERKS,
*         AUFNR      TYPE MSEG-AUFNR,
*         BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
*       END OF TY_MSEG.

DATA: it_mseg_261 TYPE TABLE OF t_mat_doc,
      wa_mseg_261 TYPE  t_mat_doc.

TYPES: BEGIN OF ty_aufm,
         mblnr TYPE aufm-mblnr,
         mjahr TYPE aufm-mjahr,
         zeile TYPE aufm-zeile,
         bwart TYPE aufm-bwart,
         matnr TYPE aufm-matnr,
         werks TYPE aufm-werks,
         aufnr TYPE aufm-aufnr,
         budat TYPE aufm-budat,
       END OF ty_aufm,
       tt_aufm TYPE STANDARD TABLE OF ty_aufm.

TYPES:
  BEGIN OF t_vbkd,
    vbeln TYPE vbkd-vbeln,
    posnr TYPE vbkd-posnr,
    kursk TYPE vbkd-kursk,
    bstkd TYPE vbkd-bstkd,    "ADDED BY JYOTI ON 27.03.2025 REQUESTED BY mR jOSHI
  END OF t_vbkd,
  tt_vbkd TYPE STANDARD TABLE OF t_vbkd.

TYPES:
  BEGIN OF t_coep,
    kokrs  TYPE coep-kokrs,
    belnr  TYPE coep-belnr,
    buzei  TYPE coep-buzei,
    wtgbtr TYPE coep-wtgbtr,
    objnr  TYPE coep-objnr,
  END OF t_coep,
  tt_coep TYPE STANDARD TABLE OF t_coep.


TYPES:
  BEGIN OF t_order_item,
    aufnr TYPE afpo-aufnr,
    posnr TYPE afpo-posnr,
    dauat TYPE afpo-dauat,
    psmng TYPE afpo-psmng,
    pwerk TYPE afpo-pwerk,
    objnr TYPE coep-objnr,
    lgort TYPE afpo-lgort,  """Added by Pranit 18.06.2024
  END OF t_order_item,
  tt_order_item TYPE STANDARD TABLE OF t_order_item.

TYPES:
  BEGIN OF t_order_hdr,
    aufnr TYPE afko-aufnr,
    ftrmi TYPE afko-ftrmi,
  END OF t_order_hdr,
  tt_order_hdr TYPE STANDARD TABLE OF t_order_hdr.

TYPES:
  BEGIN OF t_sales_ord_hdr,
    vbeln TYPE vbak-vbeln,
    audat TYPE vbak-audat,
    auart TYPE vbak-auart,
    vkbur TYPE vbak-vkbur,
    knumv TYPE vbak-knumv,
    kunnr TYPE vbak-kunnr,
    aedat TYPE vbak-aedat,
    waerk TYPE vbak-waerk,
  END OF t_sales_ord_hdr,
  tt_sales_ord_hdr TYPE STANDARD TABLE OF t_sales_ord_hdr.

TYPES:
  BEGIN OF t_sales_ord_item,
    vbeln   TYPE vbap-vbeln,
    posnr   TYPE vbap-posnr,
    matnr   TYPE vbap-matnr,
    kdmat   TYPE vbap-kdmat,
    kwmeng  TYPE vbap-kwmeng,
    deldate TYPE vbap-deldate,
    kzwi1   TYPE vbap-kzwi1,
    lgort   TYPE vbap-lgort,     " added by SG 20.06.2024
  END OF t_sales_ord_item,
  tt_sales_ord_item TYPE STANDARD TABLE OF t_sales_ord_item.

TYPES:
  BEGIN OF t_mat_mast,
    matnr   TYPE mara-matnr,
    zseries TYPE mara-zseries,
    zsize   TYPE mara-zsize,
    brand   TYPE mara-brand,
    moc     TYPE mara-moc,
    type    TYPE mara-type,
  END OF t_mat_mast,
  tt_mat_mast TYPE STANDARD TABLE OF t_mat_mast.

TYPES:
  BEGIN OF t_mat_desc,
    matnr TYPE makt-matnr,
    maktx TYPE makt-maktx,
  END OF t_mat_desc,
  tt_mat_desc TYPE STANDARD TABLE OF t_mat_desc.

TYPES:
  BEGIN OF t_vbep,
    vbeln TYPE vbep-vbeln,
    posnr TYPE vbep-posnr,
    edatu TYPE vbep-edatu,
  END OF t_vbep,
  tt_vbep TYPE STANDARD TABLE OF t_vbep.

TYPES:
  BEGIN OF t_cust_info,
    kunnr TYPE kna1-kunnr,
    name1 TYPE kna1-name1,
    stcd3 TYPE kna1-stcd3,
  END OF t_cust_info,
  tt_cust_info TYPE STANDARD TABLE OF t_cust_info.

TYPES:
  BEGIN OF t_marc,
    matnr TYPE marc-matnr,
    werks TYPE marc-werks,
    dispo TYPE marc-dispo,
  END OF t_marc,
  tt_marc TYPE STANDARD TABLE OF t_marc.

TYPES:
  BEGIN OF t_mbew,
    matnr TYPE mbew-matnr,
    bwkey TYPE mbew-bwkey,
    stprs TYPE mbew-stprs,
  END OF t_mbew,
  tt_mbew TYPE STANDARD TABLE OF t_mbew.

TYPES:
  BEGIN OF t_qamb,
    prueflos TYPE qamb-prueflos,
    typ      TYPE qamb-typ,
    mblnr    TYPE qamb-mblnr,
    mjahr    TYPE qamb-mjahr,
    zeile    TYPE qamb-zeile,
  END OF t_qamb,
  tt_qamb TYPE STANDARD TABLE OF t_qamb.

TYPES:
  BEGIN OF t_qals,
    prueflos TYPE qals-prueflos,
    aufnr    TYPE qals-aufnr,
    mjahr    TYPE qals-mjahr,
    mblnr    TYPE qals-mblnr,
  END OF t_qals,
  tt_qals TYPE STANDARD TABLE OF t_qals.

**TYPES:
**  BEGIN OF t_t005u,
**    land1 TYPE t005u-land1,
**    bland TYPE t005u-bland,
**    bezei TYPE t005u-bezei,
**  END OF t_t005u.

TYPES:
  BEGIN OF t_final,
    dispo     TYPE marc-dispo,
    brand     TYPE mara-brand,
    kdauf     TYPE mseg-kdauf,
    kdpos     TYPE mseg-kdpos,
    vkbur     TYPE vbak-vkbur,
    matnr     TYPE mseg-matnr,
    maktx     TYPE vbrp-arktx,
    long_txt  TYPE char100,
    dauat     TYPE afpo-dauat,
    name1     TYPE kna1-name1,
    edatu     TYPE char10, "vbep-edatu,
    kwmeng    TYPE vbap-kwmeng,
    deldate   TYPE char10, "vbap-deldate,
    kdmat     TYPE vbap-kdmat,
    aufnr     TYPE mseg-aufnr,
    menge     TYPE mseg-menge,
    budat_con TYPE char10, "mseg-budat_mkpf,
    budat_in  TYPE char10, "mseg-budat_mkpf,
    prd_amt   TYPE vbap-netwr,
    netpr     TYPE vbap-netpr,
    stprs     TYPE mbew-stprs,
    zseries   TYPE mara-zseries,
    zsize     TYPE char3, "mara-zsize,
    moc       TYPE mara-moc,
    type      TYPE mara-type,
    lgort     TYPE mseg-lgort,
    aedat     TYPE char10, "vbak-aedat,
    ftrmi     TYPE char10, "afko-ftrmi,
    waerk     TYPE vbak-waerk,
    kursk     TYPE vbkd-kursk,
    s_val     TYPE prcd_elements-kwert,
    s_val_lc  TYPE prcd_elements-kwert,
    auart     TYPE vbak-auart,
    so_curr   TYPE vbkd-kursk,
*    werks     TYPE mseg-werks,
*    kunnr     TYPE mseg-kunnr,
*    stcd3     TYPE kna1-stcd3,
*    kzwi1     TYPE vbap-kzwi1,
    curr_date TYPE sy-datum,
    fst_ish   TYPE char11,
    lst_ish   TYPE char11,
    del_dat   TYPE char11,
*    lgort     TYPE afpo-LGORT,  "Added by Pranit  18.06.2024
    lgort1    TYPE vbap-lgort,  "added by SG.
    BSTKD      TYPE VBKD-BSTKD, "ADDED BY JYOTI ON 27.03.2025
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.


TYPES:
  BEGIN OF ty_final,
    dispo     TYPE char100,
    brand     TYPE char100,
    kdauf     TYPE char100,
    kdpos     TYPE char100,
    vkbur     TYPE char100,
    matnr     TYPE char100,
    maktx     TYPE vbrp-arktx,
    long_txt  TYPE char100,
    dauat     TYPE char100,
    name1     TYPE char100,
    edatu     TYPE char11, "vbep-edatu,
    kwmeng    TYPE char100,
    deldate   TYPE char11, "vbap-deldate,
    kdmat     TYPE char100,
    aufnr     TYPE char100,
    menge     TYPE char100,
    budat_con TYPE char11, "mseg-budat_mkpf,
    budat_in  TYPE char11, "mseg-budat_mkpf,
    prd_amt   TYPE char100,
    netpr     TYPE char100,
    stprs     TYPE char100,
    zseries   TYPE char100,
    zsize     TYPE char3, "mara-zsize,
    moc       TYPE char100,
    type      TYPE char100,
    lgort     TYPE char100,
    aedat     TYPE char11, "vbak-aedat,
    ftrmi     TYPE char11, "afko-ftrmi,
    waerk     TYPE char100,
    kursk     TYPE char100,
    s_val     TYPE char100,
    s_val_lc  TYPE char100,
    auart     TYPE char100,
    so_curr   TYPE char100,
*    werks     TYPE mseg-werks,
*    kunnr     TYPE mseg-kunnr,
*    stcd3     TYPE kna1-stcd3,
*    kzwi1     TYPE vbap-kzwi1,
    curr_date TYPE char11,
    fst_ish   TYPE char11,
    lst_ish   TYPE char11,
    del_dat   TYPE char11,
    lgort1    TYPE char100,
    BSTKD TYPE STRING, "ADDE BY JYOTI ON 27.03.2025
    ref_time TYPE string,"added by jyoti on 15.04.2025
  END OF ty_final.
*  tt_final TYPE STANDARD TABLE OF t_final.

DATA:
  gt_final TYPE tt_final,
  it_final TYPE TABLE OF ty_final.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
SELECT-OPTIONS: so_budat FOR tmp_budat OBLIGATORY DEFAULT '20170401' TO sy-datum,
                so_dauat FOR tmp_dauat NO INTERVALS,
                so_kdauf FOR tmp_kdauf,
                so_lgort FOR tmp_lgort NO INTERVALS,
                so_matnr FOR tmp_mat.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE abc .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder TYPE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK b3.

INITIALIZATION.
  xyz = 'Select Options'(tt1).
  abc = 'Download File'(tt2).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_folder.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_folder.

START-OF-SELECTION.
  PERFORM fetch_data CHANGING gt_final.
  PERFORM display USING gt_final.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM fetch_data  CHANGING ct_final TYPE tt_final.
  DATA:
    lt_mat_doc        TYPE tt_mat_doc,
    ls_mat_doc        TYPE t_mat_doc,
    lt_mat_doc_101    TYPE tt_mat_doc,
    ls_mat_doc_101    TYPE t_mat_doc,
    lt_order_item     TYPE tt_order_item,
    ls_order_item     TYPE t_order_item,
    lt_sales_ord_hdr  TYPE tt_sales_ord_hdr,
    ls_sales_ord_hdr  TYPE t_sales_ord_hdr,
    lt_sales_ord_item TYPE tt_sales_ord_item,
    ls_sales_ord_item TYPE t_sales_ord_item,
    lt_mat_mast       TYPE tt_mat_mast,
    ls_mat_mast       TYPE t_mat_mast,
    lt_mat_desc       TYPE tt_mat_desc,
    ls_mat_desc       TYPE t_mat_desc,
    lt_vbep           TYPE tt_vbep,
    ls_vbep           TYPE t_vbep,
    lt_cust_info      TYPE tt_cust_info,
    ls_cust_info      TYPE t_cust_info,
    lt_marc           TYPE tt_marc,
    ls_marc           TYPE t_marc,
    lt_mbew           TYPE tt_mbew,
    ls_mbew           TYPE t_mbew,
    lt_qamb           TYPE tt_qamb,
    ls_qamb           TYPE t_qamb,
    lt_qals           TYPE tt_qals,
    ls_qals           TYPE t_qals,
    lt_order_hdr      TYPE tt_order_hdr,
    ls_order_hdr      TYPE t_order_hdr,
    lt_coep           TYPE tt_coep,
    ls_coep           TYPE t_coep,
    lt_vbkd           TYPE tt_vbkd,
    ls_vbkd           TYPE t_vbkd,
    ls_final          TYPE t_final,
    wa_final          TYPE ty_final,
    lt_aufm           TYPE tt_aufm,
    ls_aufm           TYPE ty_aufm.

  DATA:
    lv_id        TYPE thead-tdname,
    lt_lines     TYPE STANDARD TABLE OF tline,
    ls_lines     TYPE tline,
    lv_index     TYPE sy-tabix,
    lv_cost      TYPE prcd_elements-kwert,
    ls_exch_rate TYPE bapi1093_0.

  DATA :
    gv_con_dat TYPE mkpf-budat,
    gv_fst_ish TYPE mkpf-budat,
    gv_lst_ish TYPE mkpf-budat.
"  BREAK-POINT.
  IF NOT so_dauat IS INITIAL.
    SELECT aufnr
           posnr
           dauat
           psmng
           pwerk
           lgort   """Added by Pranit 18.06.2024
      FROM afpo
      INTO TABLE lt_order_item
      WHERE dauat IN so_dauat
      AND pwerk = 'PL01'." ADDED BY MD

    IF NOT lt_order_item IS INITIAL.
      SELECT mblnr
             mjahr
             zeile
             bwart
             matnr
             werks
             lgort
             kunnr
             kdauf
             kdpos
             waers
             menge
             aufnr
             budat_mkpf
        FROM mseg
        INTO TABLE lt_mat_doc
        FOR ALL ENTRIES IN lt_order_item
        WHERE aufnr = lt_order_item-aufnr
        AND   budat_mkpf IN so_budat
        AND   bwart = '321'
        AND   xauto = 'X'
        AND   matnr IN so_matnr
        AND   lgort IN so_lgort
        AND   kdauf IN so_kdauf
        AND   werks = lt_order_item-pwerk." ADDED BY MD
    ENDIF.
  ELSE.
    SELECT mblnr
           mjahr
           zeile
           bwart
           matnr
           werks
           lgort
           kunnr
           kdauf
           kdpos
           waers
           menge
           aufnr
           budat_mkpf
      FROM mseg
      INTO TABLE lt_mat_doc
      WHERE budat_mkpf IN so_budat
      AND   bwart = '321'
      AND   xauto = 'X'
      AND   matnr IN so_matnr
      AND   lgort IN so_lgort
      AND   kdauf IN so_kdauf
      AND   aufnr NE space
      AND   werks = 'PL01'.  " ADDED BY MD


  ENDIF.
  IF lt_mat_doc IS INITIAL.
    MESSAGE 'Data Not Found' TYPE 'E'.
  ELSE.
    SELECT aufnr
           posnr
           dauat
           psmng
           lgort
      FROM afpo
      INTO TABLE lt_order_item
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE aufnr = lt_mat_doc-aufnr.

    IF NOT lt_order_item IS INITIAL.
      LOOP AT lt_order_item INTO ls_order_item.
        CONCATENATE 'OR' ls_order_item-aufnr INTO ls_order_item-objnr.
        MODIFY lt_order_item FROM ls_order_item TRANSPORTING objnr.
      ENDLOOP.

      SELECT aufnr
             ftrmi
        FROM afko
        INTO TABLE lt_order_hdr
        FOR ALL ENTRIES IN lt_order_item
        WHERE aufnr = lt_order_item-aufnr.

      SELECT kokrs
             belnr
             buzei
             wtgbtr
             objnr
        FROM coep
        INTO TABLE lt_coep
        FOR ALL ENTRIES IN lt_order_item
        WHERE objnr = lt_order_item-objnr
        AND   beknz = 'S'.
    ENDIF.
    SELECT vbeln
           audat
           auart
           vkbur
           knumv
           kunnr
           aedat
           waerk
      FROM vbak
      INTO TABLE lt_sales_ord_hdr
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE vbeln = lt_mat_doc-kdauf.

    SELECT vbeln
           posnr
           matnr
           kdmat
           kwmeng
           deldate
           kzwi1
           lgort
      FROM vbap
      INTO TABLE lt_sales_ord_item
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE vbeln = lt_mat_doc-kdauf
      AND   posnr = lt_mat_doc-kdpos.

    SELECT vbeln
           posnr
           kursk
           bstkd "added by jyoti on 27.03.2025 requested by Mr. Yjoshi
      FROM vbkd
      INTO TABLE lt_vbkd
      FOR ALL ENTRIES IN lt_sales_ord_item
      WHERE vbeln = lt_sales_ord_item-vbeln.

    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE lt_mat_mast
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE matnr = lt_mat_doc-matnr.

    SELECT matnr
           maktx
      FROM makt
      INTO TABLE lt_mat_desc
      FOR ALL ENTRIES IN lt_mat_mast
      WHERE matnr = lt_mat_mast-matnr
      AND   spras = sy-langu.

    SELECT vbeln
           posnr
           edatu
      FROM vbep
      INTO TABLE lt_vbep
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE vbeln = lt_mat_doc-kdauf
      AND   posnr = lt_mat_doc-kdpos.

    SELECT kunnr
           name1
           stcd3
      FROM kna1
      INTO TABLE lt_cust_info
      FOR ALL ENTRIES IN lt_sales_ord_hdr
      WHERE kunnr = lt_sales_ord_hdr-kunnr.

    SELECT matnr
           werks
           dispo
      FROM marc
      INTO TABLE lt_marc
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE matnr = lt_mat_doc-matnr.

    SELECT matnr
           bwkey
           stprs
      FROM mbew
      INTO TABLE lt_mbew
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE matnr = lt_mat_doc-matnr.

    SELECT prueflos
           typ
           mblnr
           mjahr
           zeile
      FROM qamb
      INTO TABLE lt_qamb
      FOR ALL ENTRIES IN lt_mat_doc
      WHERE mblnr = lt_mat_doc-mblnr
      AND   mjahr = lt_mat_doc-mjahr.
*        AND   zeile = lt_mat_doc-zeile.

    IF NOT lt_qamb IS INITIAL.

      SELECT prueflos
             aufnr
             mjahr
             mblnr
        FROM qals
        INTO TABLE lt_qals
        FOR ALL ENTRIES IN lt_qamb
        WHERE prueflos = lt_qamb-prueflos.

      IF NOT lt_qals IS INITIAL.
        SELECT mblnr
           mjahr
           zeile
           bwart
           matnr
           werks
           lgort
           kunnr
           kdauf
           kdpos
           waers
           menge
           aufnr
           budat_mkpf
      FROM mseg
      INTO TABLE lt_mat_doc_101
      FOR ALL ENTRIES IN lt_qals
      WHERE mblnr = lt_qals-mblnr
      AND   mjahr = lt_qals-mjahr
      AND   aufnr = lt_qals-aufnr
      AND   bwart = '101'.
      ENDIF.
    ENDIF.
  ENDIF.
  IF lt_mat_doc IS NOT INITIAL.

*    SELECT MBLNR
*           MJAHR
*           ZEILE
*           BWART
*           MATNR
*           WERKS
*           LGORT
*           KUNNR
*           KDAUF
*           KDPOS
*           WAERS
*           MENGE
*           AUFNR
*           BUDAT_MKPF FROM MSEG INTO TABLE IT_MSEG_261
*           FOR ALL ENTRIES IN LT_MAT_DOC
*           WHERE AUFNR = LT_MAT_DOC-AUFNR
*            AND  WERKS = LT_MAT_DOC-WERKS
*            AND  BWART = '261'.
    SELECT mblnr
           mjahr
           zeile
           bwart
           matnr
           werks
           aufnr
           budat
      FROM aufm INTO TABLE lt_aufm
    FOR ALL ENTRIES IN lt_mat_doc
    WHERE aufnr = lt_mat_doc-aufnr
    AND  werks  = lt_mat_doc-werks
    AND  bwart  = '261'.

  ENDIF.

  SORT lt_coep BY objnr.
  LOOP AT lt_mat_doc INTO ls_mat_doc.
    ls_final-kdauf    = ls_mat_doc-kdauf.
    ls_final-kdpos    = ls_mat_doc-kdpos.
*    ls_final-waers    = ls_mat_doc-waers.
    ls_final-aufnr    = ls_mat_doc-aufnr.

    IF NOT ls_mat_doc-budat_mkpf IS INITIAL.

      CONCATENATE ls_mat_doc-budat_mkpf+6(2) ls_mat_doc-budat_mkpf+4(2) ls_mat_doc-budat_mkpf+0(4)
              INTO ls_final-budat_in SEPARATED BY '-'.
    ELSE.
      ls_final-budat_in = 'NULL'.
    ENDIF.

*    SORT IT_MSEG_261 BY BUDAT_MKPF ASCENDING .
*    READ TABLE IT_MSEG_261 INTO WA_MSEG_261 WITH KEY AUFNR = LS_FINAL-AUFNR.
*    IF NOT WA_MSEG_261-BUDAT_MKPF IS INITIAL.
*      GV_FST_ISH = WA_MSEG_261-BUDAT_MKPF .
*      CONCATENATE WA_MSEG_261-BUDAT_MKPF+6(2) WA_MSEG_261-BUDAT_MKPF+4(2) WA_MSEG_261-BUDAT_MKPF+0(4)
*      INTO LS_FINAL-FST_ISH SEPARATED BY '-'.
*    ELSE.
*      LS_FINAL-FST_ISH = 'NULL'.
*    ENDIF.

    SORT lt_aufm BY budat ASCENDING .
    READ TABLE lt_aufm INTO ls_aufm WITH KEY aufnr = ls_final-aufnr.
    IF NOT ls_aufm-budat IS INITIAL.
      gv_fst_ish = ls_aufm-budat.
      CONCATENATE ls_aufm-budat+6(2) ls_aufm-budat+4(2) ls_aufm-budat+0(4)
      INTO ls_final-fst_ish SEPARATED BY '-'.
    ELSE.
      ls_final-fst_ish = 'NULL'.
    ENDIF.

*    SORT IT_MSEG_261 BY BUDAT_MKPF DESCENDING .
*    READ TABLE IT_MSEG_261 INTO WA_MSEG_261 WITH KEY AUFNR = LS_FINAL-AUFNR.
*    IF NOT WA_MSEG_261-BUDAT_MKPF IS INITIAL.
*      GV_LST_ISH = WA_MSEG_261-BUDAT_MKPF.
*      CONCATENATE WA_MSEG_261-BUDAT_MKPF+6(2) WA_MSEG_261-BUDAT_MKPF+4(2) WA_MSEG_261-BUDAT_MKPF+0(4)
*      INTO LS_FINAL-LST_ISH SEPARATED BY '-'.
*    ELSE.
*      LS_FINAL-LST_ISH = 'NULL'.
*    ENDIF.
    SORT lt_aufm BY budat DESCENDING .
    READ TABLE lt_aufm INTO ls_aufm WITH KEY aufnr = ls_final-aufnr.
    IF NOT ls_aufm-budat IS INITIAL.
      gv_lst_ish = ls_aufm-budat.
      CONCATENATE ls_aufm-budat+6(2) ls_aufm-budat+4(2) ls_aufm-budat+0(4)
      INTO ls_final-lst_ish SEPARATED BY '-'.
    ELSE.
      ls_final-lst_ish = 'NULL'.
    ENDIF.



    ls_final-matnr    = ls_mat_doc-matnr.
*    ls_final-werks    = ls_mat_doc-werks.
    ls_final-lgort    = ls_mat_doc-lgort.
*    ls_final-kunnr    = ls_mat_doc-kunnr.
    ls_final-menge    = ls_mat_doc-menge.

    READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_mat_doc-matnr
                                             werks = ls_mat_doc-werks.
    IF sy-subrc IS INITIAL.
      ls_final-dispo  = ls_marc-dispo.
    ENDIF.
    READ TABLE lt_order_item INTO ls_order_item WITH KEY aufnr = ls_mat_doc-aufnr.
    IF sy-subrc IS INITIAL.
      ls_final-dauat  = ls_order_item-dauat.
    ENDIF.
    READ TABLE lt_coep INTO ls_coep WITH KEY objnr = ls_order_item-objnr.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.
      LOOP AT lt_coep INTO ls_coep FROM lv_index.
        IF ls_coep-objnr = ls_order_item-objnr .
          lv_cost = lv_cost + ls_coep-wtgbtr.
        ELSE.
          EXIT.
        ENDIF.

      ENDLOOP.
    ENDIF.
    ls_final-prd_amt = ( lv_cost / ls_order_item-psmng )  * ls_final-menge.
    READ TABLE lt_order_hdr INTO ls_order_hdr WITH KEY aufnr = ls_order_item-aufnr.
    IF sy-subrc IS INITIAL.

      IF NOT ls_order_hdr-ftrmi IS INITIAL.

        CONCATENATE ls_order_hdr-ftrmi+6(2) ls_order_hdr-ftrmi+4(2) ls_order_hdr-ftrmi+0(4)
                INTO ls_final-ftrmi SEPARATED BY '-'.
      ELSE.
        ls_final-ftrmi = 'NULL'.
      ENDIF.
    ELSE.
      ls_final-ftrmi = 'NULL'.
    ENDIF.
    READ TABLE lt_sales_ord_item INTO ls_sales_ord_item WITH KEY vbeln = ls_mat_doc-kdauf
                                                                 posnr = ls_mat_doc-kdpos.
    IF sy-subrc IS INITIAL.
      ls_final-kdmat   = ls_sales_ord_item-kdmat.
      ls_final-kwmeng  = ls_sales_ord_item-kwmeng.
      ls_final-lgort1  = ls_sales_ord_item-lgort.  "ADDED BY SG.
      IF NOT ls_sales_ord_item-deldate IS INITIAL.

        CONCATENATE ls_sales_ord_item-deldate+6(2) ls_sales_ord_item-deldate+4(2) ls_sales_ord_item-deldate+0(4)
                INTO ls_final-deldate SEPARATED BY '-'.
      ELSE.
        ls_final-deldate = 'NULL'.
      ENDIF.

*      ls_final-kzwi1   = ls_sales_ord_item-kzwi1.
      ls_final-netpr   = ls_sales_ord_item-kzwi1 / ls_sales_ord_item-kwmeng.
      ls_final-s_val = ls_final-netpr * ls_final-menge.
    ELSE.
      ls_final-deldate = 'NULL'.
*    ls_final-so_amt  =
    ENDIF.
    READ TABLE lt_vbkd INTO ls_vbkd WITH KEY vbeln = ls_sales_ord_item-vbeln.
    IF sy-subrc IS INITIAL.
      ls_final-so_curr    = ls_vbkd-kursk.
      ls_final-BSTKD    = ls_vbkd-bstkd.
    ENDIF.
    READ TABLE lt_sales_ord_hdr INTO ls_sales_ord_hdr WITH KEY vbeln = ls_sales_ord_item-vbeln.
    IF sy-subrc IS INITIAL.
      ls_final-waerk   = ls_sales_ord_hdr-waerk.
      ls_final-vkbur   = ls_sales_ord_hdr-vkbur.
      ls_final-auart = ls_sales_ord_hdr-auart.


      CALL FUNCTION 'BAPI_EXCHANGERATE_GETDETAIL'
        EXPORTING
          rate_type  = 'M'
          from_curr  = ls_final-waerk
          to_currncy = 'INR'
          date       = sy-datum
        IMPORTING
          exch_rate  = ls_exch_rate
*         RETURN     =
        .

      ls_final-kursk    = ls_exch_rate-exch_rate.
      ls_final-s_val_lc = ls_final-s_val * ls_exch_rate-exch_rate.


      IF NOT ls_sales_ord_hdr-aedat IS INITIAL.

        CONCATENATE ls_sales_ord_hdr-aedat+6(2) ls_sales_ord_hdr-aedat+4(2) ls_sales_ord_hdr-aedat+0(4)
                INTO ls_final-aedat SEPARATED BY '-'.
      ELSE.
        ls_final-aedat = 'NULL'.
      ENDIF.

    ELSE.
      ls_final-aedat = 'NULL'.
    ENDIF.
    READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = ls_mat_doc-kdauf
                                             posnr = ls_mat_doc-kdpos.
    IF sy-subrc IS INITIAL.
      IF NOT ls_vbep-edatu IS INITIAL.

        CONCATENATE ls_vbep-edatu+6(2) ls_vbep-edatu+4(2) ls_vbep-edatu+0(4)
                INTO ls_final-edatu SEPARATED BY '-'.
      ELSE.
        ls_final-edatu = 'NULL'.
      ENDIF.
    ELSE.
      ls_final-edatu = 'NULL'.
    ENDIF.
    READ TABLE lt_cust_info INTO ls_cust_info WITH KEY kunnr = ls_sales_ord_hdr-kunnr.
    IF sy-subrc IS INITIAL.
      ls_final-name1 = ls_cust_info-name1.
*      ls_final-stcd3 = ls_cust_info-stcd3.
    ENDIF.
    READ TABLE lt_mat_mast INTO ls_mat_mast WITH KEY matnr = ls_final-matnr.
    IF sy-subrc IS INITIAL.
      ls_final-zseries = ls_mat_mast-zseries.
      ls_final-zsize   = ls_mat_mast-zsize.
      ls_final-brand   = ls_mat_mast-brand.
      ls_final-moc     = ls_mat_mast-moc.
      ls_final-type    = ls_mat_mast-type.
    ENDIF.
    READ TABLE lt_mat_desc INTO ls_mat_desc WITH KEY matnr = ls_final-matnr.
    IF sy-subrc IS INITIAL.
      ls_final-maktx   = ls_mat_desc-maktx.

    ENDIF.
    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_final-matnr.
    IF sy-subrc IS INITIAL.
      ls_final-stprs   = ls_mbew-stprs.
    ENDIF.
    READ TABLE lt_qamb INTO ls_qamb WITH KEY mblnr = ls_mat_doc-mblnr
                                             mjahr = ls_mat_doc-mjahr.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_qals INTO ls_qals WITH KEY prueflos = ls_qamb-prueflos.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_mat_doc_101 INTO ls_mat_doc_101 WITH KEY mblnr = ls_qals-mblnr
                                                               mjahr = ls_qals-mjahr.
        IF sy-subrc IS INITIAL.
          IF NOT ls_mat_doc_101-budat_mkpf IS INITIAL.
            gv_con_dat = ls_mat_doc_101-budat_mkpf.
            CONCATENATE ls_mat_doc_101-budat_mkpf+6(2) ls_mat_doc_101-budat_mkpf+4(2) ls_mat_doc_101-budat_mkpf+0(4)
                    INTO ls_final-budat_con SEPARATED BY '-'.
          ELSE.
            ls_final-budat_con = 'NULL'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    ls_final-del_dat = gv_con_dat - gv_lst_ish .

    "Material Long Text
    lv_id = ls_final-matnr.
    CLEAR: lt_lines,ls_lines.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_id
        object                  = 'MATERIAL'
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF NOT lt_lines IS INITIAL.
      LOOP AT lt_lines INTO ls_lines.
        IF NOT ls_lines-tdline IS INITIAL.
          CONCATENATE ls_final-long_txt ls_lines-tdline INTO ls_final-long_txt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE ls_final-long_txt.
    ENDIF.
    ls_final-curr_date = sy-datum.
*BREAK PRIMUS.

***************************************************new file download******************************


    IF ls_vbep-edatu IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_vbep-edatu
        IMPORTING
          output = wa_final-edatu.
      CONCATENATE wa_final-edatu+0(2) wa_final-edatu+2(3) wa_final-edatu+5(4)
                      INTO wa_final-edatu SEPARATED BY '-'.
*CONCATENATE WA_FINAL-EDATU

    ENDIF.

    IF ls_sales_ord_item-deldate IS NOT INITIAL.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_sales_ord_item-deldate
        IMPORTING
          output = wa_final-deldate.
      CONCATENATE wa_final-deldate+0(2) wa_final-deldate+2(3) wa_final-deldate+5(4)
                      INTO wa_final-deldate SEPARATED BY '-'.
    ENDIF.

    IF ls_mat_doc_101-budat_mkpf IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_mat_doc_101-budat_mkpf
        IMPORTING
          output = wa_final-budat_con.

      CONCATENATE wa_final-budat_con+0(2) wa_final-budat_con+2(3) wa_final-budat_con+5(4)
                      INTO wa_final-budat_con SEPARATED BY '-'.
    ENDIF.

    IF ls_mat_doc-budat_mkpf IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_mat_doc-budat_mkpf
        IMPORTING
          output = wa_final-budat_in.

      CONCATENATE wa_final-budat_in+0(2) wa_final-budat_in+2(3) wa_final-budat_in+5(4)
                      INTO wa_final-budat_in SEPARATED BY '-'.

    ENDIF.
*break primus.
    IF ls_sales_ord_hdr-aedat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_sales_ord_hdr-aedat
        IMPORTING
          output = wa_final-aedat.

      CONCATENATE wa_final-aedat+0(2) wa_final-aedat+2(3) wa_final-aedat+5(4)
                      INTO wa_final-aedat SEPARATED BY '-'.
    ENDIF.

    IF ls_order_hdr-ftrmi IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_order_hdr-ftrmi
        IMPORTING
          output = wa_final-ftrmi.

      CONCATENATE wa_final-ftrmi+0(2) wa_final-ftrmi+2(3) wa_final-ftrmi+5(4)
                      INTO wa_final-ftrmi SEPARATED BY '-'.

    ENDIF.


    IF ls_final-curr_date IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = ls_final-curr_date
        IMPORTING
          output = wa_final-curr_date.

      CONCATENATE wa_final-curr_date+0(2) wa_final-curr_date+2(3) wa_final-curr_date+5(4)
                      INTO wa_final-curr_date SEPARATED BY '-'.

    ENDIF.

    wa_final-dispo = ls_final-dispo.

    wa_final-brand = ls_final-brand.

    wa_final-kdauf = ls_final-kdauf.

    wa_final-kdpos = ls_final-kdpos.

    wa_final-auart = ls_final-auart.

    wa_final-vkbur = ls_final-vkbur.

    wa_final-matnr = ls_final-matnr.

    wa_final-prd_amt = ls_final-prd_amt.

    wa_final-netpr = ls_final-netpr.

    wa_final-stprs = ls_final-stprs.

    wa_final-s_val = ls_final-s_val.

    wa_final-s_val_lc = ls_final-s_val_lc.

    wa_final-maktx = ls_final-maktx.

    wa_final-long_txt = ls_final-long_txt.

    wa_final-dauat = ls_final-dauat.

    wa_final-name1 = ls_final-name1.

    wa_final-kwmeng = ls_final-kwmeng.

    wa_final-kdmat = ls_final-kdmat.

    wa_final-aufnr = ls_final-aufnr.

    wa_final-menge = ls_final-menge.

    wa_final-waerk = ls_final-waerk.

    wa_final-so_curr = ls_final-so_curr.

    wa_final-bstkd = ls_final-bstkd. "added by jyoti on 27.03.2025

    wa_final-kursk = ls_final-kursk.

    wa_final-zseries = ls_final-zseries.

    wa_final-zsize = ls_final-zsize.

    wa_final-type = ls_final-type.

    wa_final-moc = ls_final-moc.

    wa_final-lgort = ls_final-lgort.
    wa_final-lgort1 = ls_final-lgort1.  "ADDED BY SG
*********ADDED BY SNEHAL*****
*WA_FINAL-FST_ISH = LS_FINAL-FST_ISH.

    IF gv_fst_ish IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = gv_fst_ish
        IMPORTING
          output = wa_final-fst_ish.

      CONCATENATE wa_final-fst_ish+0(2) wa_final-fst_ish+2(3) wa_final-fst_ish+5(4)
                      INTO wa_final-fst_ish SEPARATED BY '-'.
    ENDIF.

    IF gv_lst_ish IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = gv_lst_ish
        IMPORTING
          output = wa_final-lst_ish.

      CONCATENATE wa_final-lst_ish+0(2) wa_final-lst_ish+2(3) wa_final-lst_ish+5(4)
                      INTO wa_final-lst_ish SEPARATED BY '-'.
    ENDIF.

*WA_FINAL-LST_ISH = LS_FINAL-LST_ISH.

    wa_final-del_dat = ls_final-del_dat.
    CONDENSE wa_final-del_dat.
*   IF WA_FINAL-DEL_DAT < 0.
*      CONCATENATE '-' WA_FINAL-DEL_DAT INTO WA_FINAL-DEL_DAT.
*    ENDIF.
"    BREAK primus.
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = wa_final-del_dat.


    CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO wa_final-ref_time.



********************************
    APPEND wa_final TO it_final.

    APPEND ls_final TO ct_final.
    CLEAR: ls_final,ls_mat_doc,ls_mat_doc_101,ls_qals,ls_qamb,ls_mbew,ls_mat_mast,ls_cust_info,ls_vbep,ls_sales_ord_hdr,ls_sales_ord_item,
           ls_order_item,ls_order_hdr,ls_coep,ls_vbkd,lv_cost,gv_lst_ish,gv_con_dat,gv_fst_ish,wa_final.
  ENDLOOP.

  SORT ct_final BY aufnr.
*  APPEND LINES OF CT_FINAL TO IT_FINAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FINAL  text
*----------------------------------------------------------------------*
FORM display  USING    ct_final TYPE tt_final.
  DATA:
    lt_fieldcat     TYPE slis_t_fieldcat_alv,
    ls_alv_layout   TYPE slis_layout_alv,
    l_callback_prog TYPE sy-repid.

  l_callback_prog = sy-repid.


  PERFORM prepare_display CHANGING lt_fieldcat.
  CLEAR ls_alv_layout.
  ls_alv_layout-zebra = 'X'.
  ls_alv_layout-colwidth_optimize = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = l_callback_prog
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'UCOMM_ON_ALV'
*     I_CALLBACK_TOP_OF_PAGE  = ' '
      is_layout               = ls_alv_layout
      it_fieldcat             = lt_fieldcat
    TABLES
      t_outtab                = ct_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_display  CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA:
    gv_pos      TYPE i,
    ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH ct_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DISPO'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MRP Controller'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BRAND'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Brand'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDAUF'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Order No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDPOS'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Line Item'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUART'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Order Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'VKBUR'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Office'."(104).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MATNR'.
*  ls_fieldcat-outputlen = '18'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Material No.'."(105).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MAKTX'.
*  ls_fieldcat-outputlen = '40'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Item Description'."(106).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LONG_TXT'.
*  ls_fieldcat-outputlen = '40'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Long Description'."(127).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DAUAT'.
*  ls_fieldcat-outputlen = '21'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Production Order Type'."(107).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.


  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NAME1'.
*  ls_fieldcat-outputlen = '30'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Name'."(125).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'EDATU'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Production Date'."(126).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KWMENG'.
*  ls_fieldcat-outputlen = '7'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SO QTY.'."(108).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DELDATE'.
*  ls_fieldcat-outputlen = '13'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Delivery Date'."(109).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KDMAT'.
*  ls_fieldcat-outputlen = '18'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer Item Code'."(110).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AUFNR'.
*  ls_fieldcat-outputlen = '20'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Production Order No.'."(111).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MENGE'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'QTY.'."(112).
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BUDAT_CON'.
*  ls_fieldcat-outputlen = '17'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Confirmation Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FST_ISH'.
*  ls_fieldcat-outputlen = '17'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'First Issue Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LST_ISH'.
*  ls_fieldcat-outputlen = '17'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Last Issue Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'DEL_DAT'.
*  ls_fieldcat-outputlen = '17'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Delayed Days'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'BUDAT_IN'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Inspection Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'PRD_AMT'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Production Amt.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'S_VAL'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Value(DC)'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'WAERK'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Currency'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'SO_CURR'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SO Exchange Rate'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'KURSK'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Current Exchange Rate'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.
  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'S_VAL_LC'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Sales Value(LC)'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'NETPR'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Rate'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'STPRS'.
*  ls_fieldcat-outputlen = '13'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Standard Cost'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSERIES'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Series'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'ZSIZE'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Size'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'MOC'.
*  ls_fieldcat-outputlen = '8'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MOC'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'TYPE'.
*  ls_fieldcat-outputlen = '10'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Type'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'LGORT'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Storage Loc.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'AEDAT'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'MRP Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'FTRMI'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Order Create Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

  gv_pos = gv_pos + 1.
  ls_fieldcat-fieldname = 'CURR_DATE'.
*  ls_fieldcat-outputlen = '15'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'File Create Date'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat.

   gv_pos = gv_pos + 1.                        " ADDED BY SG.
  ls_fieldcat-fieldname = 'LGORT1'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'SO Storage Loc.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat."

   gv_pos = gv_pos + 1.                        " ADDED BY Jyoti MAhajan on 27.03.2025
  ls_fieldcat-fieldname = 'BSTKD'.
*  ls_fieldcat-outputlen = '12'.
  ls_fieldcat-tabname   = 'GT_FINAL'.
  ls_fieldcat-seltext_m = 'Customer PO No.'.
  ls_fieldcat-col_pos   = gv_pos.
*  ls_fieldcat-hotspot   = 'X'.
  APPEND ls_fieldcat TO ct_fieldcat.
  CLEAR ls_fieldcat."


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = gt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZPRD_QADATA.TXT'.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPRD Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1633 TYPE string.
DATA lv_crlf_1633 TYPE string.
lv_crlf_1633 = cl_abap_char_utilities=>cr_lf.
lv_string_1633 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1633 lv_crlf_1633 wa_csv INTO lv_string_1633.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1633 TO lv_fullfile.
*TRANSFER lv_string_1633 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

*************************************************SECOND FILE ***************************************


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZPRD_QADATA.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPRD Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1670 TYPE string.
DATA lv_crlf_1670 TYPE string.
lv_crlf_1670 = cl_abap_char_utilities=>cr_lf.
lv_string_1670 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1670 lv_crlf_1670 wa_csv INTO lv_string_1670.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1670 TO lv_fullfile.
*TRANSFER lv_string_1670 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'MRP Controller'
              'Brand'
              'Sales Order No.'
              'Line Item'
              'Sales Office'
              'Material No.'
              'Item Description'
              'Long Description'
              'Production Order Type'
              'Customer Name'
              'Production Date'
              'SO QTY.'
              'Delivery Date'
              'Customer Item Code'
              'Production Order No.'
              'QTY.'
              'Confirmation Date'
              'Inspection Date'
              'Production Amt.'
              'Rate'
              'Standard Cost'
              'Series'
              'Size'
              'MOC'
              'Type'
              'Storage Loc.'
              'MRP Date'
              'Order Release Date'
              'Currency'
              'Current Exchange Rate'
              'Sales Value(DC)'
              'Sales Value(LC)'
              'Sales Order Type'
              'SO Exchange Rate'
              'FILE CREATED DATE'
              'First Issue Date'
              'Last Issue Date'
              'Delayed Days'
              'SO Storage Loc.'
              'Customer PO No'   "added by jyoti on 27.03.2025
              'Refreshable Time' "added by jyoti on 15.04.2025
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
