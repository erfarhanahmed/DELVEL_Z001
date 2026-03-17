*&---------------------------------------------------------------------*
*& Report ZUS_SHORTFALL_TRANSIT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_SHORTFALL_TRANSIT_REPORT_1.

TABLES:VBAK.


TYPES: BEGIN OF TY_VBAK,
       VBELN    TYPE VBAK-VBELN,
       ERDAT    TYPE VBAK-ERDAT,
       AUDAT    TYPE VBAK-AUDAT,
       VBTYP    TYPE VBAK-VBTYP,
       AUART    TYPE VBAK-AUART,
       VKORG    TYPE VBAK-VKORG,
       KUNNR    TYPE VBAK-KUNNR,
       POSNR    TYPE VBAP-POSNR,
       MATNR    TYPE VBAP-MATNR,
       KWMENG   TYPE VBAP-KWMENG,
       WERKS    TYPE VBAP-WERKS,
       END OF TY_VBAK,

       BEGIN OF TY_VBAP,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       MATNR    TYPE VBAP-MATNR,
       KWMENG   TYPE VBAP-KWMENG,
       CUSTDELDATE  TYPE VBAP-CUSTDELDATE,
       END OF TY_VBAP,

       BEGIN OF TY_VBKD,
       VBELN    TYPE VBKD-VBELN,
       POSNR    TYPE VBKD-POSNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE VBKD-BSTDK,
       END OF TY_VBKD,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
         LABST TYPE mard-LABST,
         INSME TYPE mard-INSME,
       END OF ty_mard,

       BEGIN OF ty_lips,
       vbeln TYPE lips-vbeln,
       posnr TYPE lips-posnr,
       WERKS TYPE lips-WERKS,
       LFIMG TYPE lips-LFIMG,
       VGBEL TYPE lips-VGBEL,
       VGPOS TYPE lips-VGPOS,
       END OF ty_lips,

       BEGIN OF TY_FINAL,
       KUNNR    TYPE VBAK-KUNNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE VBKD-BSTDK,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       AUDAT    TYPE VBAK-AUDAT,
       MATNR    TYPE VBAP-MATNR,
       WRKST    TYPE MARA-WRKST,
       MAKTX    TYPE MAKT-MAKTX,
       CUSTDELDATE  TYPE VBAP-CUSTDELDATE,
       KWMENG   TYPE VBAP-KWMENG,
       PND_SO   TYPE VBAP-KWMENG,
       SO_SRT   TYPE VBAP-KWMENG,
       TRNST    TYPE VBAP-KWMENG,
       alloc    TYPE VBAP-KWMENG,
       lfimg    TYPE lips-lfimg,
       ind      TYPE char50,
       zseries  TYPE mara-zseries,
       zsize    TYPE mara-zsize,
       brand    TYPE mara-brand,
       moc      TYPE mara-moc,
       type     TYPE mara-type,
       END OF TY_FINAL,

       BEGIN OF ty_down,
       KUNNR    TYPE VBAK-KUNNR,
       BSTKD    TYPE VBKD-BSTKD,
       BSTDK    TYPE char15,
       VBELN    TYPE VBAP-VBELN,
       POSNR    TYPE VBAP-POSNR,
       AUDAT    TYPE char15,
       MATNR    TYPE VBAP-MATNR,
       WRKST    TYPE MARA-WRKST,
       MAKTX    TYPE MAKT-MAKTX,
       CUSTDELDATE  TYPE char15,
       KWMENG   TYPE char15,
       SO_SRT   TYPE char15,
       PND_SO   TYPE char15,
       alloc    TYPE char15,
       ref      TYPE char15,
       ind      TYPE char50,
       zseries  TYPE mara-zseries,
       zsize    TYPE mara-zsize,
       brand    TYPE mara-brand,
       moc      TYPE mara-moc,
       type     TYPE mara-type,
       END OF ty_down.

*****************************************TRANSIT REPORT
TYPES:BEGIN OF ty_mara,
        matnr   TYPE mara-matnr,
        wrkst   TYPE mara-wrkst,
        zseries TYPE mara-zseries,
        zsize   TYPE mara-zsize,
        brand   TYPE mara-brand,
        moc     TYPE mara-moc,
        type    TYPE mara-type,
      END OF ty_mara,

      BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF ty_makt,

      BEGIN OF ty_ekpo,
        ebeln TYPE vbak-bstnk, "ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        werks TYPE ekpo-werks,
        menge TYPE ekpo-menge,
        matnr TYPE ekpo-matnr,
      END OF ty_ekpo,

      BEGIN OF ty_ekko,
        ebeln TYPE vbak-bstnk, "ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        aedat TYPE ekko-aedat,
        bedat TYPE ekko-bedat,
        lifnr TYPE ekko-lifnr,
      END OF ty_ekko,


*      BEGIN OF ty_vbak,
*        vbeln TYPE vbak-vbeln,
*        bstnk TYPE vbak-bstnk,
*      END OF ty_vbak,

      BEGIN OF str_vbap,
        vbeln  TYPE vbap-vbeln,
        posnr  TYPE vbap-posnr,
        matnr  TYPE vbap-matnr,
        kwmeng TYPE vbap-kwmeng,
        POSEX  TYPE vbap-POSEX,
      END OF str_vbap,

      BEGIN OF ty_vbrp,
        vbeln TYPE vbrp-vbeln,
        posnr TYPE vbrp-posnr,
        fkimg TYPE vbrp-fkimg,
        VGBEL(16),
        VGPOS TYPE vbrp-vgpos,
        aubel TYPE vbrp-aubel,
        aupos TYPE vbrp-aupos,
        matnr TYPE vbrp-matnr,
        werks TYPE vbrp-werks,
      END OF ty_vbrp,

      BEGIN OF ty_vbrk,
        vbeln TYPE vbrk-vbeln,
        FKART TYPE vbrk-FKART,
        fkdat TYPE vbrk-fkdat,
        knumv TYPE vbrk-knumv,
        rfbsk TYPE vbrk-rfbsk,
        kunag TYPE vbrk-kunag,
        exnum TYPE vbrk-exnum,
        xblnr TYPE vbrk-xblnr,
        logsys TYPE vbrk-logsys,
        fksto TYPE vbrk-fksto,
      END OF ty_vbrk,

      BEGIN OF ty_vapma,
        matnr TYPE vapma-matnr,
        vkorg TYPE vapma-vkorg,
        bstnk TYPE vapma-bstnk,
        vbeln TYPE vapma-vbeln,
        posnr TYPE vapma-posnr,
        werks TYPE vapma-werks,
      END OF ty_vapma,




      BEGIN OF ty_eikp,
        exnum TYPE eikp-exnum,
        iever TYPE eikp-iever,
      END OF ty_eikp,

      BEGIN OF ty_mode,
        expvz TYPE ztransit-expvz,
        bezei TYPE ztransit-bezei,
        zdays TYPE ztransit-zdays,
      END OF ty_mode,

      BEGIN OF ty_konv,
        knumv TYPE PRCD_ELEMENTS-knumv,
        kposn TYPE PRCD_ELEMENTS-kposn,
        kschl TYPE PRCD_ELEMENTS-kschl,
        kbetr TYPE PRCD_ELEMENTS-kbetr,
        kwert TYPE PRCD_ELEMENTS-kwert,
      END OF ty_konv,

      BEGIN OF ty_kna1,
        kunnr TYPE kna1-kunnr,
        land1 TYPE kna1-land1,
        ort01 TYPE kna1-ort01,
        pstlz TYPE kna1-pstlz,
      END OF ty_kna1,

      BEGIN OF ty_t005t,
        spras TYPE t005t-spras,
        land1 TYPE t005t-land1,
        landx TYPE t005t-landx,
      END OF ty_t005t,





      BEGIN OF ty_likp,
        vbeln TYPE likp-vbeln,
        verur TYPE likp-verur,
      END OF ty_likp,


      BEGIN OF ty_t618t,
        spras TYPE t618t-spras,
        land1 TYPE t618t-land1,
        expvz TYPE t618t-expvz,
        bezei TYPE t618t-bezei,
      END OF ty_t618t,

      BEGIN OF ty_mseg,
        mblnr(16)," TYPE mseg-mblnr,
        mjahr TYPE mseg-mjahr,
        bwart TYPE mseg-bwart,
        matnr TYPE mseg-matnr,
        werks TYPE mseg-werks,
        smbln TYPE mseg-smbln,
        XBLNR_MKPF TYPE mseg-XBLNR_MKPF,
        VBELN_IM   TYPE mseg-VBELN_IM,
        VBELP_IM   TYPE mseg-VBELP_IM,
      END OF ty_mseg,

      BEGIN OF ty_bkpf,
      belnr TYPE bkpf-belnr,
      blart TYPE bkpf-blart,
      xblnr TYPE bkpf-xblnr,
      stblg TYPE bkpf-stblg,
      END OF ty_bkpf,

      BEGIN OF ty_marc,
      matnr TYPE marc-matnr,
      werks TYPE marc-werks,
      END OF ty_marc,


      BEGIN OF str_final,
        matnr    TYPE mara-matnr,
        wrkst    TYPE mara-wrkst,
        zseries  TYPE mara-zseries,
        zsize    TYPE mara-zsize,
        brand    TYPE mara-brand,
        moc      TYPE mara-moc,
        type     TYPE mara-type,
*      maktx       TYPE makt-maktx,
        desc     TYPE char100,
        ebeln    TYPE ekpo-ebeln,
        ebelp    TYPE ekpo-ebelp,
        menge    TYPE ekpo-menge,
        lifnr    TYPE lfa1-lifnr,
        name1    TYPE lfa1-name1,
        vbeln    TYPE vbap-vbeln,
        posnr    TYPE vbap-posnr,
        kwmeng   TYPE vbap-kwmeng,
        inv_no   TYPE vbrp-vbeln,
        inv_line TYPE vbrp-posnr,
        fkimg    TYPE vbrp-fkimg,
        fkdat    TYPE vbrk-fkdat,
        xblnr    TYPE vbrk-xblnr,
        kbetr    TYPE PRCD_ELEMENTS-kbetr,
        kwert    TYPE PRCD_ELEMENTS-kwert,
        pono     TYPE char15,
        bezei    TYPE ztransit-bezei,
        arrival  TYPE sy-datum,
        due      TYPE sy-datum,
        port     TYPE char100,
        place    TYPE string,
        stock    TYPE mard-labst,
        pend     TYPE vbrp-fkimg,
        mblnr    TYPE mseg-mblnr,
        VBELN_IM TYPE mseg-VBELN_IM,
        belnr    TYPE bkpf-belnr,
        werks    TYPE ekpo-werks,
      END OF str_final,

      BEGIN OF ty_trans,
      matnr TYPE mara-matnr,
      fkimg TYPE vbrp-fkimg,
      END OF ty_trans.

DATA : it_trans TYPE TABLE OF ty_trans,
       wa_trans TYPE          ty_trans.

DATA :day TYPE i.

DATA: it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      lt_mara  TYPE TABLE OF ty_mara,
      ls_mara  TYPE          ty_mara,

      it_makt  TYPE TABLE OF ty_makt,
      wa_makt  TYPE          ty_makt,

      it_ekko  TYPE TABLE OF ty_ekko,
      wa_ekko  TYPE          ty_ekko,

      it_ekpo  TYPE TABLE OF ty_ekpo,
      wa_ekpo  TYPE          ty_ekpo,

      it_likp  TYPE TABLE OF ty_likp,
      wa_likp  TYPE          ty_likp,


      lt_vbap  TYPE TABLE OF str_vbap,
      ls_vbap  TYPE          str_vbap,

*      it_vbak  TYPE TABLE OF ty_vbak,
*      wa_vbak  TYPE          ty_vbak,

      it_vbrp  TYPE TABLE OF ty_vbrp,
      wa_vbrp  TYPE          ty_vbrp,

      it_vbrk  TYPE TABLE OF ty_vbrk,
      wa_vbrk  TYPE          ty_vbrk,

      it_vapma TYPE TABLE OF ty_vapma,
      wa_vapma TYPE          ty_vapma,

      it_eikp  TYPE TABLE OF ty_eikp,
      wa_eikp  TYPE          ty_eikp,

      it_t618t TYPE TABLE OF ty_t618t,
      wa_t618t TYPE          ty_t618t,

      it_mode  TYPE TABLE OF ty_mode,
      wa_mode  TYPE          ty_mode,

      it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg1  TYPE TABLE OF ty_mseg,
      wa_mseg1  TYPE          ty_mseg,

      it_bkpf  TYPE TABLE OF ty_bkpf,
      wa_bkpf  TYPE          ty_bkpf,

      it_bkpf1  TYPE TABLE OF ty_bkpf,
      wa_bkpf1  TYPE          ty_bkpf,

      it_rev   TYPE TABLE OF TY_mseg,
      wa_rev   TYPE          ty_mseg,

      it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE          ty_konv,

      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE          ty_kna1,

      it_t005t TYPE TABLE OF ty_t005t,
      wa_t005t TYPE          ty_t005t,

      it_marc TYPE TABLE OF ty_marc,
      wa_marc TYPE          ty_marc,

      it_transit TYPE TABLE OF str_final,
      wa_transit TYPE          str_final.


************************************************



DATA : IT_VBAK TYPE TABLE OF TY_VBAK,
       WA_VBAK TYPE          TY_VBAK,

       IT_VBAP TYPE TABLE OF TY_VBAP,
       WA_VBAP TYPE          TY_VBAP,

       IT_VBKD TYPE TABLE OF TY_VBKD,
       WA_VBKD TYPE          TY_VBKD,

       it_mard TYPE TABLE OF ty_mard,
       wa_mard TYPE          ty_mard,

       it_lips TYPE TABLE OF ty_lips,
       wa_lips TYPE          ty_lips,

       IT_FINAL TYPE TABLE OF TY_FINAL,
       WA_FINAL TYPE          TY_FINAL,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_fieldcat_alv.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_VBELN FOR VBAK-VBELN,
                   S_DATE  FOR VBAK-AUDAT.
  PARAMETERS :     P_VKORG TYPE VBAK-VKORG OBLIGATORY DEFAULT 'US00'.
*                   p_matnr TYPE vbap-matnr.
SELECTION-SCREEN: END OF BLOCK B1 .

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/USA'."USA'."usa'.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION .

PERFORM GET_TRANSIT.
PERFORM GET_DATA.
PERFORM SORT_DATA.
PERFORM get_fcat.
PERFORM display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
SELECT a~VBELN
       a~ERDAT
       a~AUDAT
       a~VBTYP
       a~AUART
       a~VKORG
       a~KUNNR
       b~posnr
       b~matnr
       b~kwmeng
       b~WERKS FROM VBAK AS a
       JOIN vbap AS b ON a~vbeln = b~vbeln
       JOIN vbup as c ON ( a~vbeln = c~vbeln and b~posnr = c~posnr ) INTO TABLE IT_VBAK
       WHERE a~VBELN IN S_VBELN
         AND a~AUDAT IN S_DATE
         AND a~VKORG = P_VKORG
*         AND b~matnr = p_matnr
         AND c~LFSTA  NE 'C'
         AND c~LFGSA  NE 'C'
         AND c~FKSTA  NE 'C'
         AND c~GBSTA  NE 'C'.




IF IT_VBAK IS NOT INITIAL.

SELECT matnr
       wrkst
       zseries
       zsize
       brand
       moc
       type    FROM mara INTO TABLE lt_mara
       FOR ALL ENTRIES IN it_vbak
       WHERE matnr = it_vbak-matnr.



SELECT VBELN
       POSNR
       MATNR
       KWMENG
       CUSTDELDATE FROM VBAP INTO TABLE IT_VBAP
       FOR ALL ENTRIES IN IT_VBAK
       WHERE VBELN = IT_VBAK-VBELN.


SELECT VBELN
       POSNR
       BSTKD
       BSTDK FROM VBKD INTO TABLE IT_VBKD
       FOR ALL ENTRIES IN IT_VBAK
       WHERE VBELN = IT_VBAK-VBELN.

SELECT matnr
       werks
       lgort
       LABST
       INSME FROM mard INTO TABLE it_mard
       FOR ALL ENTRIES IN it_vbak
       WHERE matnr = it_vbak-matnr
        AND  werks = it_vbak-werks.

SELECT vbeln
       posnr
       WERKS
       LFIMG
       VGBEL
       VGPOS FROM lips INTO TABLE it_lips
       FOR ALL ENTRIES IN it_vbak
       WHERE vgbel = it_vbak-vbeln
         AND vgpos = it_vbak-posnr.

ENDIF.


DELETE it_vbak WHERE auart = 'US04' . "'US05' , 'US06' , 'US09' ,'US10', 'US11', 'US12' ).
DELETE it_vbak WHERE auart = 'US05' .
DELETE it_vbak WHERE auart = 'US06' .
DELETE it_vbak WHERE auart = 'US09' .
DELETE it_vbak WHERE auart = 'US10' .
DELETE it_vbak WHERE auart = 'US11' .
DELETE it_vbak WHERE auart = 'US12' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
DATA:STOCK TYPE MARD-LABST.
DATA:alloc TYPE MARD-LABST.
DATA:qty_al TYPE MARD-LABST.
DATA:tran_st  TYPE vbrp-fkimg.
DATA:mb52 TYPE MARD-LABST.
DATA:short TYPE MARD-LABST.
SORT it_vbak BY matnr audat.
*BREAK primus.
LOOP AT IT_VBAK INTO WA_VBAK.

  WA_FINAL-VBELN    =  WA_VBAK-VBELN  .
  WA_FINAL-POSNR    =  WA_VBAK-POSNR  .
  WA_FINAL-MATNR    =  WA_VBAK-MATNR  .
  WA_FINAL-KWMENG   =  WA_VBAK-KWMENG .
  WA_FINAL-KUNNR    =  WA_VBAK-KUNNR .
  WA_FINAL-AUDAT    =  WA_VBAK-AUDAT .




ON CHANGE OF WA_VBAK-MATNR.
CLEAR :STOCK,short,tran_st,mb52.
LOOP AT IT_MARD INTO WA_MARD WHERE MATNR = WA_VBAK-MATNR.
STOCK = STOCK + WA_MARD-LABST.
STOCK = STOCK + WA_MARD-INSME.
ENDLOOP.
mb52 = stock.
READ TABLE it_trans INTO wa_trans WITH KEY matnr = wa_vbak-matnr.
IF sy-subrc = 0.
tran_st = wa_trans-fkimg.
*stock = stock + wa_trans-fkimg.
ENDIF.

ENDON.

LOOP AT it_lips INTO wa_lips WHERE vgbel = wa_vbak-vbeln AND vgpos = wa_vbak-posnr.
wa_final-lfimg = wa_final-lfimg + wa_lips-lfimg .
ENDLOOP.
  WA_final-pnd_so = WA_VBAK-KWMENG - wa_final-lfimg.
  WA_VBAK-KWMENG = WA_final-pnd_so.



  IF stock GE WA_VBAK-KWMENG .
    wa_final-alloc = WA_VBAK-KWMENG.
    STOCK = STOCK - WA_VBAK-KWMENG.
  ELSEIF stock LE WA_VBAK-KWMENG ."AND STOCK GE 0 .
    IF stock > 0.
      wa_final-alloc = stock."WA_VBAK-KWMENG - STOCK.
      short = STOCK - WA_VBAK-KWMENG.
      IF short < 0.
        WA_FINAL-SO_SRT = short * -1.
      ELSE.
        WA_FINAL-SO_SRT = short.
      ENDIF.
*      WA_FINAL-SO_SRT = STOCK - WA_VBAK-KWMENG.
    ELSE.

      short = WA_VBAK-KWMENG.
      WA_FINAL-SO_SRT = short.
*      WA_FINAL-SO_SRT = WA_VBAK-KWMENG.

     short = short * -1.
*      WA_FINAL-SO_SRT = WA_FINAL-SO_SRT * -1.
    ENDIF.


    STOCK = short.
*    STOCK = WA_FINAL-SO_SRT.

  ENDIF.
*tran_st
*BREAK primus.
CLEAR :alloc,qty_al.
DATA qty TYPE char10.
DATA: s TYPE char50,
      t TYPE char50.
CLEAR:S,T.
alloc = wa_final-alloc.
IF wa_final-alloc IS NOT INITIAL.
  IF mb52 GE alloc.
    CLEAR:qty.
    qty = alloc.
    qty_al = alloc.
    CONCATENATE 'S' qty INTO s SEPARATED BY '-'.
    CONDENSE s.
    alloc = alloc - mb52.
*    IF alloc > 0.
      mb52 = mb52 - qty_al.
*    ENDIF.


  ELSEIF mb52 > 0.
    CLEAR:qty.
    qty_al = alloc.
    alloc = alloc - mb52.
    qty = mb52.
    CONCATENATE 'S' qty INTO s SEPARATED BY '-'.
    CONDENSE s.
    mb52 = mb52 - qty_al.
  ENDIF.


  IF alloc > 0.

   IF tran_st GE alloc.
     CLEAR:qty.
     qty = alloc.
     qty_al = alloc.
     CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
     CONDENSE t.
     alloc = alloc - tran_st .
     tran_st = tran_st - qty_al.
   ELSEIF tran_st > 0 .
     CLEAR:qty.

     qty = tran_st.
     qty_al = alloc.
     alloc = alloc - tran_st .
     CONCATENATE  'T' qty INTO t SEPARATED BY '-'.
     CONDENSE t.

       tran_st = tran_st - qty_al.


   ENDIF.
  ENDIF.
ENDIF.
CONCATENATE s t INTO wa_final-ind SEPARATED BY ','.

IF s IS INITIAL.
  REPLACE ',' WITH ' ' INTO wa_final-ind.
ENDIF.

IF t IS INITIAL.
  REPLACE ',' WITH ' ' INTO wa_final-ind.
ENDIF.

REPLACE '.000' WITH ' ' INTO wa_final-ind.
REPLACE '.000' WITH ' ' INTO wa_final-ind.

READ TABLE lt_mara INTO ls_mara WITH KEY matnr = wa_vbak-matnr.
IF sy-subrc = 0.
  wa_final-zseries    =  ls_mara-zseries.
  wa_final-zsize      =  ls_mara-zsize  .
  wa_final-brand      =  ls_mara-brand  .
  wa_final-moc        =  ls_mara-moc    .
  wa_final-type       =  ls_mara-type   .
ENDIF.

 READ TABLE IT_VBAP INTO WA_VBAP WITH KEY VBELN = WA_VBAK-VBELN POSNR = WA_VBAK-POSNR.
 IF SY-SUBRC = 0.
  WA_FINAL-CUSTDELDATE  =  WA_VBAP-CUSTDELDATE.
 ENDIF.

 READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAK-VBELN.
  IF SY-SUBRC = 0.
    WA_FINAL-BSTKD  =  WA_VBKD-BSTKD .
    WA_FINAL-BSTDK  =  WA_VBKD-BSTDK .
  ENDIF.


SELECT SINGLE MAKTX INTO WA_FINAL-MAKTX FROM MAKT WHERE MATNR = WA_VBAK-MATNR.
SELECT SINGLE WRKST INTO WA_FINAL-WRKST FROM MARA WHERE MATNR = WA_VBAK-MATNR.


 APPEND WA_FINAL TO IT_FINAL.
 CLEAR: WA_FINAL.
ENDLOOP.

SORT IT_FINAL BY VBELN POSNR.

IF p_down = 'X'.
  LOOP AT IT_FINAL INTO WA_FINAL.
    WA_DOWN-KUNNR   = WA_FINAL-KUNNR  .
    WA_DOWN-BSTKD   = WA_FINAL-BSTKD  .
*    WA_DOWN-BSTDK   = WA_FINAL-BSTDK  .

    IF WA_FINAL-BSTDK IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-BSTDK
        IMPORTING
          OUTPUT = WA_DOWN-BSTDK.

      CONCATENATE WA_DOWN-BSTDK+0(2) WA_DOWN-BSTDK+2(3) WA_DOWN-BSTDK+5(4)
                      INTO WA_DOWN-BSTDK SEPARATED BY '-'.

    ENDIF.




    WA_DOWN-VBELN   = WA_FINAL-VBELN  .
    WA_DOWN-POSNR   = WA_FINAL-POSNR  .
*    WA_DOWN-AUDAT   = WA_FINAL-AUDAT  .

    IF WA_FINAL-AUDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-AUDAT
        IMPORTING
          OUTPUT = WA_DOWN-AUDAT.

      CONCATENATE WA_DOWN-AUDAT+0(2) WA_DOWN-AUDAT+2(3) WA_DOWN-AUDAT+5(4)
                      INTO WA_DOWN-AUDAT SEPARATED BY '-'.

    ENDIF.


    WA_DOWN-MATNR   = WA_FINAL-MATNR  .
    WA_DOWN-WRKST   = WA_FINAL-WRKST  .
    WA_DOWN-MAKTX   = WA_FINAL-MAKTX  .

    WA_DOWN-zseries   = WA_FINAL-zseries  .
    WA_DOWN-zsize     = WA_FINAL-zsize    .
    WA_DOWN-brand     = WA_FINAL-brand    .
    WA_DOWN-moc       = WA_FINAL-moc      .
    WA_DOWN-type      = WA_FINAL-type     .
    WA_DOWN-IND     = WA_FINAL-IND  .
*    WA_DOWN-DELDATE = WA_FINAL-DELDATE.

    IF WA_FINAL-CUSTDELDATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_FINAL-CUSTDELDATE
        IMPORTING
          OUTPUT = WA_DOWN-CUSTDELDATE.

      CONCATENATE WA_DOWN-CUSTDELDATE+0(2) WA_DOWN-CUSTDELDATE+2(3) WA_DOWN-CUSTDELDATE+5(4)
                      INTO WA_DOWN-CUSTDELDATE SEPARATED BY '-'.

    ENDIF.

    WA_DOWN-KWMENG  = ABS( WA_FINAL-KWMENG ) .
    WA_DOWN-SO_SRT  = ABS( WA_FINAL-SO_SRT ).
    WA_DOWN-PND_SO  = ABS( WA_FINAL-PND_SO ).
    WA_DOWN-alloc   = ABS( wa_final-alloc ).

   IF WA_FINAL-KWMENG < 0.
     CONDENSE WA_DOWN-KWMENG.
     CONCATENATE '-' WA_DOWN-KWMENG INTO WA_DOWN-KWMENG.
   ENDIF.

   IF WA_FINAL-alloc < 0.
     CONDENSE WA_DOWN-alloc.
     CONCATENATE '-' WA_DOWN-alloc INTO WA_DOWN-alloc.
   ENDIF.


   IF WA_FINAL-SO_SRT < 0.
     CONDENSE WA_DOWN-SO_SRT.
     CONCATENATE '-' WA_DOWN-SO_SRT INTO WA_DOWN-SO_SRT.
   ENDIF.

   IF WA_FINAL-PND_SO < 0.
     CONDENSE WA_DOWN-PND_SO.
     CONCATENATE '-' WA_DOWN-PND_SO INTO WA_DOWN-PND_SO.
   ENDIF.

   CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF.

      CONCATENATE WA_DOWN-REF+0(2) WA_DOWN-REF+2(3) WA_DOWN-REF+5(4)
                      INTO WA_DOWN-REF SEPARATED BY '-'.

   APPEND WA_DOWN TO IT_DOWN.
   CLEAR WA_DOWN.
  ENDLOOP.
ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .
PERFORM fcat USING : '1'   'KUNNR'           'IT_FINAL'      'Customer'                 '15',
                     '2'   'BSTKD'           'IT_FINAL'      'Customer Po'                      '15' ,
                     '3'   'BSTDK'           'IT_FINAL'      'Cust.Po.Dt'                      '15' ,
                     '4'   'VBELN'           'IT_FINAL'      'Sales Order'                      '15' ,
                     '5'   'POSNR'           'IT_FINAL'      'SO Line Item'                      '15' ,
                     '6'   'AUDAT'           'IT_FINAL'      'SO Date'                      '15' ,
                     '7'   'MATNR'           'IT_FINAL'      'Material'                      '20' ,
                     '8'   'WRKST'           'IT_FINAL'      'USA Code'                      '15' ,
                     '9'   'MAKTX'           'IT_FINAL'      'Material Desc'                      '15' ,
                    '10'   'CUSTDELDATE'     'IT_FINAL'      'CDD'                      '15' ,
                    '11'   'KWMENG'          'IT_FINAL'      'SO Quantity'                      '15' ,
                    '12'   'PND_SO'          'IT_FINAL'      'Pend So Qty'                      '15' ,
                    '13'   'ALLOC'           'IT_FINAL'      'Allocation'                      '15' ,
                    '14'   'SO_SRT'          'IT_FINAL'      'Shortfall Quantity'                      '15' ,
                    '15'   'IND'             'IT_FINAL'      'Allocation Detail'                      '15' ,
                    '16'   'ZSERIES'         'IT_FINAL'      'Series '                      '15' ,
                    '17'   'ZSIZE'           'IT_FINAL'      'Size'                      '15' ,
                    '18'   'BRAND'           'IT_FINAL'      'BRAND'                      '15' ,
                    '19'   'MOC'             'IT_FINAL'      'MOC'                      '15' ,
                    '20'   'TYPE'            'IT_FINAL'      'TYPE'                      '15' .

*                    '14'   'TRAN_QTY'        'IT_FINAL'      'Transir Qty'                      '15' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0380   text
*      -->P_0381   text
*      -->P_0382   text
*      -->P_0383   text
*      -->P_0384   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                 VALUE(p2)
                 VALUE(p3)
                 VALUE(p4)
                 VALUE(p5).
*                 VALUE(p6).

  ls_fcat-col_pos       = p1.
  ls_fcat-fieldname     = p2.
  ls_fcat-tabname       = p3.
  ls_fcat-seltext_l     = p4.
  ls_fcat-outputlen     = p5.
*  ls_fcat-ref_fieldname = p6.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = lt_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



IF p_down = 'X'.

    PERFORM download.

ENDIF.

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
      i_tab_sap_data       = it_down
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


    lv_file = 'ZUS_SHORTFALL_TRANSIT_1.TXT'.


  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_982 TYPE string.
DATA lv_crlf_982 TYPE string.
lv_crlf_982 = cl_abap_char_utilities=>cr_lf.
lv_string_982 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_982 lv_crlf_982 wa_csv INTO lv_string_982.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_982 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
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


    lv_file = 'ZUS_SHORTFALL_TRANSIT_1.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_SHORTFALL REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1019 TYPE string.
DATA lv_crlf_1019 TYPE string.
lv_crlf_1019 = cl_abap_char_utilities=>cr_lf.
lv_string_1019 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1019 lv_crlf_1019 wa_csv INTO lv_string_1019.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1019 TO lv_fullfile.
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
FORM cvs_header  USING    PD_CSV.         "p_hd_csv.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Customer'
              'Customer Po'
              'Cust.Po.Dt'
              'Sales Order'
              'SO Line Item'
              'SO Date'
              'Material'
              'USA Code'
              'Material Desc'
              'CDD'
              'SO Quantity'
              'Shortfall Quantity'
              'Pend So Qty'
              'Allocation'
              'Refreshable Date'
              'Allocation Detail'
              'Series '
              'Size'
              'BRAND'
              'MOC'
              'TYPE'
              INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TRANSIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_transit .

SELECT vbeln
       FKART
       fkdat
       knumv
       rfbsk
       kunag
       exnum
       xblnr
       logsys
       fksto FROM vbrk INTO TABLE it_vbrk
       WHERE "vbeln IN inv
         "AND fkdat IN date
          kunag = '0000300000'
         AND fksto NE 'X'
         AND FKART NE 'ZS1'  AND FKART NE 'ZF5'
         AND logsys NE ' '.


IF it_vbrk IS NOT INITIAL.
SELECT vbeln
       posnr
       fkimg
       VGBEL
       VGPOS
       aubel
       aupos
       matnr
       werks FROM vbrp INTO TABLE it_vbrp
       FOR ALL ENTRIES IN it_vbrk
       WHERE vbeln = it_vbrk-vbeln.


SELECT knumv
       kposn
       kschl
       kbetr
       kwert FROM PRCD_ELEMENTS INTO TABLE it_konv
       FOR ALL ENTRIES IN it_vbrk
       WHERE knumv = it_vbrk-knumv
         AND kschl = 'ZPR0'.


SELECT exnum
       iever FROM eikp INTO TABLE it_eikp
       FOR ALL ENTRIES IN it_vbrk
       WHERE exnum = it_vbrk-exnum.


*SELECT kunnr
*       land1
*       ort01
*       pstlz FROM kna1 INTO TABLE it_kna1
*       FOR ALL ENTRIES IN it_vbrk
*       WHERE kunnr = it_vbrk-kunag.

ENDIF.


IF it_eikp IS NOT INITIAL.

  SELECT spras
         land1
         expvz
         bezei FROM t618t INTO TABLE it_t618t
         FOR ALL ENTRIES IN it_eikp
         WHERE expvz = it_eikp-iever
          AND  spras = 'EN'
          AND  land1 = 'IN'.


  SELECT expvz
         bezei
         zdays FROM ztransit INTO TABLE it_mode
         FOR ALL ENTRIES IN it_eikp
         WHERE expvz = it_eikp-iever.

ENDIF.

IF it_vbrp IS NOT INITIAL.

  SELECT matnr
         vkorg
         bstnk
         vbeln
         posnr
         werks FROM vapma INTO TABLE it_vapma
         FOR ALL ENTRIES IN it_vbrp
         WHERE vbeln = it_vbrp-aubel
           AND posnr = it_vbrp-aupos.

*  SELECT vbeln
*         verur FROM likp INTO TABLE it_likp
*         FOR ALL ENTRIES IN it_vbrp
*         WHERE VERUR = it_vbrp-VGBEL.




SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_mseg
       FOR ALL ENTRIES IN it_vbrp
       WHERE XBLNR_MKPF = it_vbrp-VGBEL
*         AND VBELP_IM = it_vbrp-posnr
         AND bwart = '103'.


SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_rev
       FOR ALL ENTRIES IN it_vbrp
       WHERE XBLNR_MKPF = it_vbrp-VGBEL
*       AND VBELP_IM = it_vbrp-posnr
       AND bwart = '105' .







ENDIF.
IF it_vapma IS NOT INITIAL.
  SELECT vbeln
         posnr
         matnr
         kwmeng
         POSEX FROM vbap INTO TABLE lt_vbap
         FOR ALL ENTRIES IN it_vapma
         WHERE vbeln = it_vapma-vbeln
           AND posnr = it_vapma-posnr.


  SELECT ebeln
         ebelp
         werks
         menge
         matnr FROM ekpo INTO TABLE it_ekpo
         FOR ALL ENTRIES IN it_vapma
         WHERE ebeln = it_vapma-bstnk+0(10).



ENDIF.

*IF it_kna1 IS NOT INITIAL.
*  SELECT spras
*         land1
*         landx FROM t005t INTO TABLE it_t005t
*         FOR ALL ENTRIES IN it_kna1
*         WHERE spras = 'EN'
*          AND  land1 = it_kna1-land1.
*
*
*ENDIF.

*IF it_ekpo IS NOT INITIAL.
*  SELECT matnr
*         wrkst
*         zseries
*         zsize
*         brand
*         moc
*         type   FROM mara INTO TABLE it_mara
*         FOR ALL ENTRIES IN it_ekpo
*         WHERE matnr = it_ekpo-matnr.
*
*ENDIF.

IF it_mseg IS NOT INITIAL.
*  BREAK PRIMUSUSA.
SELECT belnr
       blart
       xblnr
       stblg FROM bkpf INTO TABLE it_bkpf
       FOR ALL ENTRIES IN it_mseg
       WHERE xblnr = it_mseg-mblnr
         AND blart = 'TR'.



SELECT mblnr
       mjahr
       bwart
       matnr
       werks
       smbln
       XBLNR_MKPF
       VBELN_IM
       VBELP_IM FROM mseg INTO TABLE it_mseg1
       FOR ALL ENTRIES IN it_mseg
       WHERE smbln = it_mseg-mblnr+0(10).


ENDIF.

IF it_bkpf IS NOT INITIAL.

SELECT belnr
       blart
       xblnr
       stblg FROM bkpf INTO TABLE it_bkpf1
       FOR ALL ENTRIES IN it_bkpf
       WHERE stblg = it_bkpf-belnr.
*         AND blart = 'TR'.





ENDIF.

LOOP AT it_vbrp INTO wa_vbrp WHERE vgbel NE space.

wa_transit-inv_no = wa_vbrp-vbeln.
wa_transit-inv_line = wa_vbrp-posnr.
wa_transit-fkimg = wa_vbrp-fkimg.

*SELECT SINGLE vbeln INTO wa_final-VBELN_IM FROM likp WHERE verur = wa_vbrp-vgbel.

  SELECT vbeln
         verur FROM likp INTO TABLE it_likp
         WHERE VERUR = wa_vbrp-VGBEL.


SORT it_likp DESCENDING BY vbeln.

READ TABLE it_likp INTO wa_likp INDEX 1.
IF sy-subrc = 0.

  wa_transit-VBELN_IM = wa_likp-vbeln.

ENDIF.

READ TABLE it_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.
IF sy-subrc = 0.
   wa_transit-fkdat = wa_vbrk-fkdat.
   wa_transit-xblnr = wa_vbrk-xblnr.

ENDIF.

READ TABLE it_konv INTO wa_konv WITH KEY knumv = wa_vbrk-knumv kposn = wa_vbrp-posnr.
IF sy-subrc = 0.

  wa_transit-kbetr = wa_konv-kbetr.
  wa_transit-kwert = wa_konv-kwert.

ENDIF.


READ TABLE it_vapma INTO wa_vapma WITH KEY vbeln = wa_vbrp-aubel posnr = wa_vbrp-aupos.
IF sy-subrc = 0.
wa_transit-vbeln = wa_vapma-vbeln.
wa_transit-posnr = wa_vapma-posnr.

ENDIF.


READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = wa_vapma-vbeln posnr = wa_vapma-posnr.
IF sy-subrc = 0.
wa_transit-kwmeng = ls_vbap-kwmeng.
ENDIF.

READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_vapma-bstnk  matnr = wa_vapma-matnr ebelp = ls_vbap-POSEX.
IF sy-subrc = 0.
  wa_transit-ebeln = wa_ekpo-ebeln.
  wa_transit-ebelp = wa_ekpo-ebelp.
  wa_transit-matnr = wa_ekpo-matnr.
  wa_transit-menge = wa_ekpo-menge.
  wa_transit-werks = wa_ekpo-werks.

ENDIF.

*READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_ekpo-matnr.
*IF sy-subrc = 0.
*  wa_transit-wrkst     = wa_mara-wrkst.
*  wa_transit-zseries   = wa_mara-zseries.
*  wa_transit-zsize     = wa_mara-zsize.
*  wa_transit-brand     = wa_mara-brand.
*  wa_transit-moc       = wa_mara-moc.
*  wa_transit-type      = wa_mara-type   .
*
*ENDIF.





READ TABLE it_eikp INTO wa_eikp WITH KEY exnum = wa_vbrk-exnum.
IF sy-subrc = 0.

ENDIF.
READ TABLE it_t618t INTO wa_t618t WITH KEY expvz = wa_eikp-iever.
IF sy-subrc = 0.
  wa_transit-bezei = wa_t618t-bezei.

ENDIF.

*READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbrk-kunag.
*IF sy-subrc = 0.
*  READ TABLE it_t005t INTO wa_t005t WITH KEY spras = 'EN' land1 = wa_kna1-land1.
*  IF sy-subrc = 0.
*    CONCATENATE wa_kna1-ort01 wa_kna1-pstlz wa_t005t-landx INTO wa_transit-place SEPARATED BY ','.
*
*  ENDIF.
*
*ENDIF.

*    READ TABLE it_mode INTO wa_mode WITH KEY expvz = wa_eikp-iever.
*    IF sy-subrc = 0.
*      day = wa_mode-zdays.
*      CALL FUNCTION 'BKK_ADD_WORKINGDAY'
*        EXPORTING
*          i_date = wa_transit-fkdat
*          i_days = day
**         I_CALENDAR1       =
**         I_CALENDAR2       =
*        IMPORTING
*          e_date = wa_transit-arrival
**         E_RETURN          =
*        .
*
*    ENDIF.
*

*
*READ TABLE it_likp INTO wa_likp WITH KEY VERUR = wa_vbrp-VGBEL.
*IF sy-subrc = 0.
*wa_final-VBELN_IM = wa_likp-VBELN.
*ENDIF.

READ TABLE it_mseg INTO wa_mseg WITH KEY XBLNR_MKPF = wa_vbrp-VGBEL." VBELP_IM = wa_vbrp-posnr.
IF sy-subrc = 0.

  READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY smbln = wa_mseg-mblnr.
  IF sy-subrc = 4.
    wa_transit-mblnr = wa_mseg-mblnr.
  ENDIF.


ENDIF.
*BREAK PRIMUSUSA.
LOOP AT it_bkpf INTO wa_bkpf WHERE xblnr = wa_mseg-mblnr.
*IF sy-subrc = 0.
  READ TABLE it_bkpf1 INTO wa_bkpf1 WITH KEY stblg = wa_bkpf-belnr.
  IF sy-subrc = 4.
    wa_transit-belnr = wa_bkpf-belnr.
  ENDIF.

*ENDIF.
ENDLOOP.

READ TABLE it_rev INTO wa_rev WITH KEY XBLNR_MKPF = wa_vbrp-VGBEL." VBELP_IM = wa_vbrp-posnr.
IF sy-subrc = 4.
APPEND wa_transit TO it_transit.
ENDIF.


CLEAR:wa_transit,wa_mseg,wa_rev,wa_bkpf,wa_mseg1,wa_vbrp,wa_eikp,wa_mode,wa_kna1,wa_t005t,wa_vbrk,wa_t618t,wa_mara,wa_ekpo,
      ls_vbap,wa_vapma,wa_konv,wa_mseg1,wa_rev.
DELETE it_transit WHERE ebeln  = ' '.
DELETE it_transit WHERE VBELN_IM  = ' '.
ENDLOOP.

SELECT matnr
       werks FROM marc INTO TABLE it_marc
       FOR ALL ENTRIES IN it_transit
       WHERE matnr = it_transit-matnr
         AND werks = it_transit-werks.

LOOP AT it_marc INTO wa_marc.
wa_trans-matnr = wa_marc-matnr.

LOOP AT it_transit INTO wa_transit WHERE matnr = wa_marc-matnr.

wa_trans-fkimg = wa_trans-fkimg + wa_transit-fkimg.

ENDLOOP.

APPEND wa_trans TO it_trans.
CLEAR wa_trans.
ENDLOOP.


ENDFORM.
