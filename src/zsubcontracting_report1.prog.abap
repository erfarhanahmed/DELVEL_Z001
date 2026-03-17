*&---------------------------------------------------------------------*
*& Report ZORDER_CONFIRM_PROG                                                *
*&*&* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : SUBCONTRACTING REPORT DEVLOPMENT
* 3.PROGRAM NAME            : ZSUBCONTRACTING_REPORT                           *
* 4.TRANS CODE              :                                    *
* 5.MODULE NAME             : MM.                                 *
* 6.REQUEST NO              : DEVK905132 PRIMUS:ABAP:AB:NEW REPORT DEVLOPMENT SUBCONTRACTING :06.12.2018                               *
* 7.CREATION DATE           : 14 .12.2018.                              *
* 8.CREATED BY              : AVINASH BHAGAT.                          *
* 9.FUNCTIONAL CONSULTANT   : ANUJ DESHPANDE.                                   *
* 10.BUSINESS OWNER         : DELVAL.                                *
*&---------------------------------------------------------------------*

REPORT ZSUBCONTRACTING_REPORT1.

TABLES : EKKO, MSEG,J_1IG_SUBCON,RESB,MARA.

DATA : GV_MATNR TYPE RESB-MATNR,
       GV_LIFNR TYPE EKKO-LIFNR,
       GV_EBELN TYPE EKKO-EBELN,
       GV_AEDAT TYPE EKKO-AEDAT,
       GV_EKGRP TYPE EKKO-EKGRP,
       GV_EKORG TYPE EKKO-EKORG.

TYPES : BEGIN OF T_PUR_DOC_ITEM,

          EBELN TYPE EKKO-EBELN,
          LIFNR TYPE EKKO-LIFNR,
          AEDAT TYPE EKKO-AEDAT,
          EKGRP TYPE EKKO-EKGRP,
          FRGKE TYPE EKKO-FRGKE,
          EKORG TYPE EKKO-EKORG,
        END OF T_PUR_DOC_ITEM.

DATA : GT_PUR_DOC_ITEM TYPE STANDARD TABLE OF T_PUR_DOC_ITEM,
       GS_PUR_DOC_ITEM TYPE T_PUR_DOC_ITEM.

TYPES : BEGIN OF T_VENDOR_NAME,

          LIFNR TYPE LFA1-LIFNR,
          NAME1 TYPE LFA1-NAME1,
        END OF T_VENDOR_NAME.

DATA : GT_VENDOR_NAME TYPE STANDARD TABLE OF T_VENDOR_NAME,
       GS_VENDOR_NAME TYPE T_VENDOR_NAME.

TYPES : BEGIN OF T_DOC_SEG_MAT,
          MBLNR      TYPE MSEG-MBLNR,
          MJAHR      TYPE MSEG-MJAHR,
          ZEILE      TYPE MSEG-ZEILE,
          EBELN      TYPE MSEG-EBELN,
          EBELP      TYPE MSEG-EBELP,
          BWART      TYPE MSEG-BWART,
          XAUTO      TYPE MSEG-XAUTO,
          BUDAT_MKPF TYPE MSEG-BUDAT_MKPF,
          MENGE      TYPE MSEG-MENGE,
          MATNR      TYPE MSEG-MATNR,
          SMBLN      TYPE MSEG-SMBLN,
          LGORT      TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
        END OF T_DOC_SEG_MAT.

DATA : GT_DOC_SEG_MAT TYPE STANDARD TABLE OF T_DOC_SEG_MAT,
       GS_DOC_SEG_MAT TYPE T_DOC_SEG_MAT.

TYPES : BEGIN OF T_SUBCONT_DOC_REF,
          BUKRS    TYPE  J_1IG_SUBCON-BUKRS,
          MBLNR    TYPE  J_1IG_SUBCON-MBLNR,
          MJAHR    TYPE  J_1IG_SUBCON-MJAHR,
          ZEILE    TYPE  J_1IG_SUBCON-ZEILE,
          SEQ_NO   TYPE  J_1IG_SUBCON-SEQ_NO,
          CHLN_INV TYPE  J_1IG_SUBCON-CHLN_INV,
          ITEM     TYPE  J_1IG_SUBCON-ITEM,
          MATNR    TYPE  J_1IG_SUBCON-MATNR,
          MENGE    TYPE  J_1IG_SUBCON-MENGE,
        END OF T_SUBCONT_DOC_REF.

DATA : GT_SUBCONT_DOC_REF TYPE STANDARD TABLE OF T_SUBCONT_DOC_REF,
       GS_SUBCONT_DOC_REF TYPE T_SUBCONT_DOC_REF.

TYPES : BEGIN OF T_PUR_DOC_ITEM_EKPO,

          EBELN TYPE EKPO-EBELN,
          EBELP TYPE EKPO-EBELP,
          LOEKZ TYPE EKPO-LOEKZ,
          ELIKZ TYPE EKPO-ELIKZ,
          bukrs type ekpo-bukrs,  "" naga
          werks type ekpo-werks,  "" naga
          LGORT TYPE EKPO-LGORT,
        END OF T_PUR_DOC_ITEM_EKPO.

DATA : GT_PUR_DOC_ITEM_EKPO TYPE STANDARD TABLE OF T_PUR_DOC_ITEM_EKPO,
       GS_PUR_DOC_ITEM_EKPO TYPE T_PUR_DOC_ITEM_EKPO.

TYPES : BEGIN OF T_MAT_DATA,

          MATNR   TYPE MARA-MATNR,
          BRAND   TYPE MARA-BRAND,
          ZSERIES TYPE MARA-ZSERIES,
          ZSIZE   TYPE MARA-ZSIZE,
          MOC     TYPE MARA-MOC,
          TYPE    TYPE MARA-TYPE,
        END OF T_MAT_DATA.

DATA : GT_MAT_DATA TYPE STANDARD TABLE OF T_MAT_DATA,
       GS_MAT_DATA TYPE T_MAT_DATA.

TYPES : BEGIN OF T_DEPENDANT_REQ,
          RSNUM TYPE RESB-RSNUM,
          RSPOS TYPE RESB-RSPOS,
          RSART TYPE RESB-RSART,
          EBELN TYPE RESB-EBELN,
          MATNR TYPE RESB-MATNR,
          BDMNG TYPE RESB-BDMNG,
          ENMNG TYPE RESB-ENMNG,
        END OF T_DEPENDANT_REQ.

DATA : GT_DEPENDANT_REQ TYPE STANDARD TABLE OF T_DEPENDANT_REQ,
       GS_DEPENDANT_REQ TYPE T_DEPENDANT_REQ.

TYPES : BEGIN OF T_MAT_DESCPT,

          MATNR TYPE MAKT-MATNR,
          MAKTX TYPE MAKT-MAKTX,
        END OF T_MAT_DESCPT.

DATA : GT_MAT_DESCPT TYPE STANDARD TABLE OF T_MAT_DESCPT,
       GS_MAT_DESCPT TYPE T_MAT_DESCPT.

TYPES : BEGIN OF TY_MSEG,
          MBLNR TYPE MSEG-MBLNR,
          MJAHR TYPE MSEG-MJAHR,
          ZEILE TYPE MSEG-ZEILE,
          SMBLN TYPE MSEG-SMBLN,
        END OF TY_MSEG.

DATA : GT_MSEG TYPE STANDARD TABLE OF TY_MSEG,
       GS_MSEG TYPE TY_MSEG.

TYPES : BEGIN OF TY_FINAL,

          EBELN              TYPE EKKO-EBELN,
          LIFNR              TYPE EKKO-LIFNR,
          AEDAT              TYPE EKKO-AEDAT,
          EKGRP              TYPE EKKO-EKGRP,
          FRGKE              TYPE EKKO-FRGKE,
          EKORG              TYPE EKKO-EKORG,

*  LIFNR TYPE LFA1-LIFNR,
          NAME1              TYPE LFA1-NAME1,

          MBLNR              TYPE MSEG-MBLNR,
          BWART              TYPE MSEG-BWART,
          XAUTO              TYPE MSEG-XAUTO,
          BUDAT_MKPF         TYPE MSEG-BUDAT_MKPF,
          MENGE              TYPE MSEG-MENGE,
          SMBLN              TYPE MSEG-SMBLN,

*  MBLNR               TYPE  J_1ig_subcon-MBLNR,
          CHLN_INV           TYPE  J_1IG_SUBCON-CHLN_INV,
          MATNR              TYPE  J_1IG_SUBCON-MATNR,
          MENGE_J_1IG_SUBCON TYPE  J_1IG_SUBCON-MENGE,

          EBELP              TYPE EKPO-EBELP,
          LOEKZ              TYPE EKPO-LOEKZ,
          ELIKZ              TYPE EKPO-ELIKZ,

          BRAND              TYPE MARA-BRAND,
          ZSERIES            TYPE MARA-ZSERIES,
          ZSIZE              TYPE MARA-ZSIZE,
          MOC                TYPE MARA-MOC,
          TYPE               TYPE MARA-TYPE,
          DELIVERY_TEXT      TYPE STRING,

          BDMNG              TYPE RESB-BDMNG,
          ENMNG              TYPE RESB-ENMNG,

          MAKTX              TYPE MAKT-MAKTX,

          YES                TYPE C LENGTH 3,

          PEND_CHLLN_QTY     TYPE MSEG-MENGE,

          MENGE1             TYPE MSEG-MENGE,
          MENGE2             TYPE MSEG-MENGE,
          MENGE3             TYPE MSEG-MENGE,
          QTY_RECV           TYPE MSEG-MENGE,

          DIFF               TYPE MSEG-MENGE,

          PENDING_PO         TYPE MSEG-MENGE,

          PO_STATUS          TYPE C LENGTH 5,

          DELIVEY_MENGE      TYPE MSEG-MENGE,
          LGORT              TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
*          pend_po_qty type i,
          bukrs type ekpo-bukrs,  "" naga
          werks type ekpo-werks,  "" naga

        END OF TY_FINAL.

DATA : GT_FINAL TYPE TABLE OF TY_FINAL,
       GS_FINAL TYPE TY_FINAL.

"structure to download file on Application server.

TYPES : BEGIN OF TY_DOWN_FTP,
          NAME1                  TYPE LFA1-NAME1,
          LIFNR                  TYPE EKKO-LIFNR,
          EBELN                  TYPE EKKO-EBELN,
          AEDAT(11)              TYPE C,    "ekko-aedat,
          MBLNR                  TYPE MSEG-MBLNR,
          BUDAT_MKPF(11)         TYPE C,    " mseg-budat_mkpf,
          CHLN_INV               TYPE J_1IG_SUBCON-CHLN_INV,
          EKGRP                  TYPE EKKO-EKGRP,
          EBELP                  TYPE EKPO-EBELP,
          MATNR                  TYPE J_1IG_SUBCON-MATNR,
          MAKTX(40)              TYPE C, "makt-maktx,
          YES                    TYPE C LENGTH 3,
          BDMNG(15)              TYPE C, "resb-bdmng,
          DELIVEY_MENGE(15)      TYPE C, "mseg-menge,
          MENGE_J_1IG_SUBCON(15) TYPE C, " j_1ig_subcon-menge,
          PEND_CHLLN_QTY(15)     TYPE C, "mseg-menge,
          QTY_RECV(15)           TYPE C, "mseg-menge,
          DIFF(15)               TYPE C, "mseg-menge,
          PENDING_PO(15)         TYPE C, "mseg-menge,
          PO_STATUS              TYPE C LENGTH 5,
          BRAND                  TYPE MARA-BRAND,
          ZSERIES                TYPE MARA-ZSERIES,
          ZSIZE                  TYPE MARA-ZSIZE,
          MOC                    TYPE MARA-MOC,
          TYPE                   TYPE MARA-TYPE,
          DELIVERY_TEXT          TYPE STRING,
          REF_DT                 TYPE CHAR11,
          LGORT                  TYPE MSEG-LGORT, "added by jyoti on 17.06.2024
        END OF TY_DOWN_FTP.

DATA : GT_DOWN_FTP TYPE TABLE OF TY_DOWN_FTP,
       GS_DOWN_FTP TYPE TY_DOWN_FTP.

DATA  : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
        GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

DATA : PR_COUNT TYPE I.
DATA : PEND_PO_QTY TYPE I.

SELECTION-SCREEN : BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : MAT    FOR GV_MATNR,
                   VENDOR FOR GV_LIFNR,
                   PO     FOR GV_EBELN,
                   DATE   FOR GV_AEDAT,
                   PUORG  FOR GV_EKORG OBLIGATORY,
                   PUGRP  FOR GV_EKGRP.
*                 lgort  FOR mseg-lgort. "added by jyoti on 17.06.2024
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM PROCESS_DATA.
  PERFORM FCAT.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.   "Added by Harshal Patil date 28.02.2019 to make report download to ftp server.
  ELSE.
    PERFORM DISPLAY_DATA.
  ENDIF.


FORM GET_DATA .

*  BREAK primus.

  SELECT EBELN
        LIFNR
        AEDAT
        EKGRP
        FRGKE
        EKORG
    FROM  EKKO
    INTO TABLE GT_PUR_DOC_ITEM
    WHERE  EBELN IN PO
    AND    LIFNR IN VENDOR
    AND    AEDAT IN DATE
    AND    EKGRP IN PUGRP
    AND    EKORG IN PUORG.
  IF SY-SUBRC EQ 0.    " added by sakshi
    SORT GT_PUR_DOC_ITEM BY EBELN.
  ENDIF.

  IF GT_PUR_DOC_ITEM IS NOT INITIAL.

    SELECT LIFNR
          NAME1
      FROM LFA1
      INTO TABLE GT_VENDOR_NAME
      FOR ALL ENTRIES IN GT_PUR_DOC_ITEM
      WHERE LIFNR EQ GT_PUR_DOC_ITEM-LIFNR.
*    and   lifnr in vendor.
    IF SY-SUBRC EQ 0.   " added by sakshi
      SORT GT_VENDOR_NAME BY LIFNR.
    ENDIF.

  ENDIF.

  IF GT_PUR_DOC_ITEM IS NOT INITIAL.

    SELECT MBLNR
      MJAHR
      ZEILE
      EBELN
      EBELP
      BWART
      XAUTO
      BUDAT_MKPF
      MENGE
      MATNR
      SMBLN
      LGORT "added by jyoti on 17.06.2024
      FROM MSEG
      INTO TABLE GT_DOC_SEG_MAT
      FOR ALL ENTRIES IN GT_PUR_DOC_ITEM
      WHERE EBELN EQ GT_PUR_DOC_ITEM-EBELN
*    and   ebeln eq po
      AND   ( BWART = '541' OR BWART = '542' OR BWART = '543' OR BWART = '544' )
      AND    XAUTO NE 'X'.
*       and lgort in lgort."added by jyoti on 17.06.2024
    IF SY-SUBRC EQ 0.         " added by sakshi
      SORT GT_DOC_SEG_MAT BY MBLNR MJAHR EBELN EBELP.
    ENDIF.

  ENDIF.

  SELECT
    MBLNR
    MJAHR
    ZEILE
    SMBLN
    FROM MSEG
    INTO TABLE GT_MSEG
    FOR ALL ENTRIES IN GT_DOC_SEG_MAT
    WHERE SMBLN = GT_DOC_SEG_MAT-MBLNR.
  IF SY-SUBRC EQ 0.      " added by sakshi
    SORT GT_MSEG BY MBLNR MJAHR.
  ENDIF.


  IF GT_DOC_SEG_MAT IS NOT INITIAL.

    SELECT
      BUKRS
      MBLNR
      MJAHR
      ZEILE
      SEQ_NO
      CHLN_INV
      ITEM
      MATNR
      MENGE
      FROM J_1IG_SUBCON
      INTO TABLE GT_SUBCONT_DOC_REF
      FOR ALL ENTRIES IN GT_DOC_SEG_MAT
      WHERE MBLNR EQ GT_DOC_SEG_MAT-MBLNR AND MJAHR EQ GT_DOC_SEG_MAT-MJAHR.
    IF SY-SUBRC EQ 0.    " added by sakshi
      SORT GT_DOC_SEG_MAT BY MBLNR MJAHR.
    ENDIF.

  ENDIF.



  IF GT_PUR_DOC_ITEM IS NOT INITIAL.
    SELECT
     EBELN
     EBELP
     LOEKZ
     ELIKZ
      bukrs
      werks   "" naga
     LGORT
     FROM EKPO
     INTO TABLE GT_PUR_DOC_ITEM_EKPO
     FOR ALL ENTRIES IN GT_PUR_DOC_ITEM
     WHERE EBELN EQ GT_PUR_DOC_ITEM-EBELN.
*      AND ebelp EQ gt_pur_doc_item-ebelp.
*  ENDIF.
    IF SY-SUBRC EQ 0.   " added by sakshi
      SORT GT_PUR_DOC_ITEM_EKPO BY EBELN EBELP.
    ENDIF.

  ENDIF.

  IF GT_PUR_DOC_ITEM IS NOT INITIAL.

    SELECT
      RSNUM
      RSPOS
      RSART
      EBELN
      MATNR
      BDMNG
      ENMNG
      FROM RESB
      INTO TABLE GT_DEPENDANT_REQ
      FOR ALL ENTRIES IN GT_PUR_DOC_ITEM
      WHERE  MATNR IN MAT
      AND EBELN = GT_PUR_DOC_ITEM-EBELN.
    IF SY-SUBRC EQ 0.   " added by sakshi
      SORT GT_DEPENDANT_REQ BY RSNUM RSPOS EBELN.
    ENDIF.

  ENDIF.

  IF GT_DEPENDANT_REQ IS NOT INITIAL.

    SELECT
      MATNR
      MAKTX
      FROM MAKT
      INTO TABLE GT_MAT_DESCPT
      FOR ALL ENTRIES IN GT_DEPENDANT_REQ
      WHERE MATNR = GT_DEPENDANT_REQ-MATNR.
    IF SY-SUBRC EQ 0.   " added by sakshi
      SORT GT_MAT_DESCPT BY MATNR.
    ENDIF.

  ENDIF.

  IF GT_DEPENDANT_REQ IS NOT INITIAL.

    SELECT MATNR
        BRAND
        ZSERIES
        ZSIZE
        MOC
        TYPE
      FROM MARA
      INTO TABLE GT_MAT_DATA
      FOR ALL ENTRIES IN GT_DEPENDANT_REQ
      WHERE MATNR EQ GT_DEPENDANT_REQ-MATNR.
    IF SY-SUBRC EQ 0.  " added by sakshi
      SORT GT_MAT_DATA BY MATNR.
    ENDIF.

  ENDIF.

ENDFORM.

FORM PROCESS_DATA .
*break primus.
  CLEAR GS_FINAL-PENDING_PO.
  LOOP AT GT_DEPENDANT_REQ INTO GS_DEPENDANT_REQ ."where ebeln = gs_final-ebeln or matnr in mat.
*    IF sy-subrc = 0.
    GS_FINAL-EBELN = GS_DEPENDANT_REQ-EBELN.
    GS_FINAL-MATNR = GS_DEPENDANT_REQ-MATNR.
    GS_FINAL-BDMNG = GS_DEPENDANT_REQ-BDMNG.
    GS_FINAL-ENMNG = GS_DEPENDANT_REQ-ENMNG.

    GS_FINAL-PENDING_PO = GS_FINAL-BDMNG - GS_FINAL-ENMNG.

    CLEAR GS_FINAL-MENGE1 .
    CLEAR GS_FINAL-MENGE2.
    CLEAR GS_FINAL-MENGE3.
    CLEAR GS_DOC_SEG_MAT.
    CLEAR GS_FINAL-DELIVEY_MENGE.

    LOOP AT  GT_DOC_SEG_MAT INTO GS_DOC_SEG_MAT WHERE EBELN = GS_FINAL-EBELN AND MATNR = GS_FINAL-MATNR.
      CLEAR GS_MSEG.
      READ TABLE GT_MSEG INTO GS_MSEG WITH KEY SMBLN = GS_DOC_SEG_MAT-MBLNR.

      IF GS_MSEG-SMBLN NE GS_DOC_SEG_MAT-MBLNR.

        IF GS_DOC_SEG_MAT-SMBLN IS INITIAL.

          IF GS_DOC_SEG_MAT-BWART = '541'.
            GS_FINAL-MBLNR       =  GS_DOC_SEG_MAT-MBLNR   .
            GS_FINAL-BWART       =  GS_DOC_SEG_MAT-BWART     .
            GS_FINAL-XAUTO       =  GS_DOC_SEG_MAT-XAUTO    .
            GS_FINAL-BUDAT_MKPF  =  GS_DOC_SEG_MAT-BUDAT_MKPF.
            GS_FINAL-DELIVEY_MENGE       = GS_FINAL-DELIVEY_MENGE + GS_DOC_SEG_MAT-MENGE  .
*            gs_final-lgort      = gs_doc_seg_mat-lgort."added by jyoti on 17.06.2024
          ENDIF.
          IF GS_DOC_SEG_MAT-BWART = '542' .
            GS_FINAL-MENGE1       =   GS_FINAL-MENGE1 + GS_DOC_SEG_MAT-MENGE  .
          ENDIF.

          IF   GS_DOC_SEG_MAT-BWART = '543'.
            GS_FINAL-MENGE2       =   GS_FINAL-MENGE2 + GS_DOC_SEG_MAT-MENGE  .
          ENDIF.

          IF GS_DOC_SEG_MAT-BWART = '544'.
            GS_FINAL-MENGE3       =  GS_FINAL-MENGE3 +  GS_DOC_SEG_MAT-MENGE  .
          ENDIF.
        ENDIF.
      ENDIF.

*      BREAK PRIMUS.

      IF GS_DOC_SEG_MAT-BWART = '541'.
        READ TABLE  GT_SUBCONT_DOC_REF INTO GS_SUBCONT_DOC_REF WITH KEY MBLNR = GS_DOC_SEG_MAT-MBLNR MATNR = GS_FINAL-MATNR.
        IF SY-SUBRC = 0.
          GS_FINAL-MBLNR              = GS_SUBCONT_DOC_REF-MBLNR   .
          GS_FINAL-CHLN_INV           = GS_SUBCONT_DOC_REF-CHLN_INV.
          GS_FINAL-MENGE_J_1IG_SUBCON = GS_SUBCONT_DOC_REF-MENGE .
        ENDIF.
      ENDIF.


    ENDLOOP.
    CLEAR GS_PUR_DOC_ITEM-FRGKE.
    READ TABLE GT_PUR_DOC_ITEM INTO GS_PUR_DOC_ITEM WITH KEY EBELN = GS_FINAL-EBELN .
    IF SY-SUBRC = 0.
      GS_FINAL-EBELN = GS_PUR_DOC_ITEM-EBELN.
      GS_FINAL-LIFNR = GS_PUR_DOC_ITEM-LIFNR.
      GS_FINAL-AEDAT = GS_PUR_DOC_ITEM-AEDAT.
      GS_FINAL-EKGRP = GS_PUR_DOC_ITEM-EKGRP.
      GS_FINAL-EKORG = GS_PUR_DOC_ITEM-EKORG.

      IF GS_PUR_DOC_ITEM-FRGKE = '2'.
        GS_FINAL-YES = 'YES'.
      ELSEIF GS_PUR_DOC_ITEM-FRGKE = 'X'.
        GS_FINAL-YES = 'NO'.
      ENDIF.
    ENDIF.
    READ TABLE GT_VENDOR_NAME INTO GS_VENDOR_NAME WITH KEY LIFNR = GS_FINAL-LIFNR .
    IF SY-SUBRC = 0.
      GS_FINAL-NAME1 = GS_VENDOR_NAME-NAME1.
    ENDIF.

    READ TABLE GT_PUR_DOC_ITEM_EKPO INTO GS_PUR_DOC_ITEM_EKPO WITH KEY EBELN = GS_FINAL-EBELN.
*    READ TABLE gt_pur_doc_item_ekpo INTO gs_pur_doc_item_ekpo WITH KEY ebeln = gs_doc_seg_mat-ebeln
*                                                                       ebelp = gs_doc_seg_mat-ebelp.
    IF SY-SUBRC = 0.
      GS_FINAL-EBELP = GS_PUR_DOC_ITEM_EKPO-EBELP.
      GS_FINAL-bukrs = GS_PUR_DOC_ITEM_EKPO-bukrs.
      GS_FINAL-werks = GS_PUR_DOC_ITEM_EKPO-werks.
      GS_FINAL-LOEKZ = GS_PUR_DOC_ITEM_EKPO-LOEKZ.
      GS_FINAL-ELIKZ = GS_PUR_DOC_ITEM_EKPO-ELIKZ.
      GS_FINAL-LGORT = GS_PUR_DOC_ITEM_EKPO-LGORT."added by jyoti on 17.06.2024
    ENDIF.

    READ TABLE GT_MAT_DATA INTO GS_MAT_DATA WITH KEY MATNR = GS_FINAL-MATNR.
    IF SY-SUBRC = 0.
      GS_FINAL-BRAND     = GS_MAT_DATA-BRAND.
      GS_FINAL-ZSERIES   = GS_MAT_DATA-ZSERIES .
      GS_FINAL-ZSIZE     = GS_MAT_DATA-ZSIZE    .
      GS_FINAL-MOC       = GS_MAT_DATA-MOC     .
      GS_FINAL-TYPE      = GS_MAT_DATA-TYPE   .
    ENDIF.

    READ TABLE GT_MAT_DESCPT INTO GS_MAT_DESCPT WITH KEY MATNR = GS_DEPENDANT_REQ-MATNR.
    IF SY-SUBRC = 0.
      GS_FINAL-MAKTX = GS_MAT_DESCPT-MAKTX.
    ENDIF.
    CLEAR  GS_FINAL-QTY_RECV.
    CLEAR GS_FINAL-DIFF.
    CLEAR GS_FINAL-PEND_CHLLN_QTY.
    GS_FINAL-QTY_RECV = ( GS_FINAL-MENGE1 + GS_FINAL-MENGE2 ) - GS_FINAL-MENGE3.
    GS_FINAL-DIFF = GS_FINAL-DELIVEY_MENGE - GS_FINAL-QTY_RECV.
    GS_FINAL-PEND_CHLLN_QTY = GS_FINAL-DELIVEY_MENGE - GS_FINAL-MENGE_J_1IG_SUBCON.

    """""""""""""""'TEXT ID """""""""""""""'

    DATA : LV_TEXT_NAME TYPE THEAD-TDNAME.
    DATA : LT_LINE TYPE TABLE OF TLINE.
    DATA : LS_LINE TYPE TLINE.

    CONCATENATE GS_FINAL-EBELN GS_FINAL-EBELP INTO LV_TEXT_NAME.
    CONDENSE LV_TEXT_NAME.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        ID                      = 'F04'
        LANGUAGE                = 'E'
        NAME                    = LV_TEXT_NAME
        OBJECT                  = 'EKPO'
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*     IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
      TABLES
        LINES                   = LT_LINE[]
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    LOOP AT LT_LINE INTO LS_LINE.
      CONCATENATE GS_FINAL-DELIVERY_TEXT LS_LINE-TDLINE INTO GS_FINAL-DELIVERY_TEXT RESPECTING BLANKS.
    ENDLOOP.

    REFRESH LT_LINE.
    """""""""""""""""""""""""""""""""""""""

*break primus.
    IF GS_FINAL-LOEKZ EQ 'L' OR GS_FINAL-ELIKZ EQ 'X'.
      CLEAR GS_FINAL.
    ELSEIF GS_FINAL-LOEKZ NE 'L' OR GS_FINAL-ELIKZ NE 'X'.
      APPEND GS_FINAL TO GT_FINAL.
    ENDIF.
    CLEAR GS_FINAL.
*    CLEAR : gs_final-delivey_menge ,gs_final-menge1 , gs_final-menge2 , gs_final-menge3 ,gs_final-loekz ,gs_final-elikz ,gs_final-pending_po,gs_final-menge_j_1ig_subcon..
  ENDLOOP.
ENDFORM.


FORM FCAT .

  PERFORM BUILD_FC USING  '1' PR_COUNT 'NAME1'                'Vendor Name'             'GT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'LIFNR'                'Vendor Code'             'GT_FINAL'  '10' .
  PERFORM BUILD_FC USING  '1' PR_COUNT 'EBELN'                'PO Number'               'GT_FINAL'  '10'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'AEDAT'                'PO Date'                 'GT_FINAL'  '10'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MBLNR'                'Mat Doc No'              'GT_FINAL'  '10'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'BUDAT_MKPF'           'Mat Doc No Posting Date' 'GT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'CHLN_INV'             'Challan No'              'GT_FINAL'  '10'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'EKGRP'                'Purchasing Group'        'GT_FINAL'  '3'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'EBELP'                'PO Line No'              'GT_FINAL'  '3'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MATNR'                'Issue Item Code'         'GT_FINAL'  '3'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MAKTX'                'Issue Description'       'GT_FINAL'  '3'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'YES'                  'PO Release Status'       'GT_FINAL'  '3'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'BDMNG'                'Issue Code QTY In PO'    'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'DELIVEY_MENGE'        'Delivery Created'        'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MENGE_J_1IG_SUBCON'   'CH. Release QTY'         'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'PEND_CHLLN_QTY'       'Pend. CH. Rel QTY'       'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'QTY_RECV'             'QTY. Received'           'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'DIFF'                 'Diff'                    'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'PENDING_PO'           'Pending PO'              'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'PO_STATUS'            'PO Status Remark'        'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'BRAND'                'Brand'                   'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'ZSERIES'              'Series'                  'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'ZSIZE'                'Size'                    'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MOC'                  'MOC'                     'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'TYPE'                 'Type'                    'GT_FINAL'  '8'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'DELIVERY_TEXT'        'Issue Store Loaction'    'GT_FINAL'  '100'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'LGORT'                'Storage Loaction'        'GT_FINAL'  '100'."added by jyoti on 17.06.2024

ENDFORM.                    " fcat

FORM BUILD_FC  USING        PR_ROW TYPE I
                            PR_COUNT TYPE I
                            PR_FNAME TYPE STRING
                            PR_TITLE TYPE STRING
                            PR_TABLE TYPE SLIS_TABNAME
                            PR_LENGTH TYPE STRING.

  PR_COUNT = PR_COUNT + 1.
  GS_FIELDCAT-ROW_POS   = PR_ROW.
  GS_FIELDCAT-COL_POS   = PR_COUNT.
  GS_FIELDCAT-FIELDNAME = PR_FNAME.
  GS_FIELDCAT-SELTEXT_L = PR_TITLE.
  GS_FIELDCAT-TABNAME   = PR_TABLE.
  GS_FIELDCAT-OUTPUTLEN = PR_LENGTH.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

ENDFORM.

FORM DISPLAY_DATA.
**  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
**    EXPORTING
**      it_fieldcat = gt_fieldcat
**    TABLES
**      t_outtab    = gt_final
***   EXCEPTIONS
***     PROGRAM_ERROR                     = 1
***     OTHERS      = 2
**    .
**  IF sy-subrc <> 0.
*** Implement suitable error handling here
**  ENDIF.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      IT_FIELDCAT        = GT_FIELDCAT
      I_DEFAULT          = 'A'
      I_SAVE             = 'A'
    TABLES
      T_OUTTAB           = GT_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
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
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  PERFORM FILL_FTP_STR.

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_DOWN_FTP
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*

*lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZSUB.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZSUB Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_749 TYPE STRING.
    DATA LV_CRLF_749 TYPE STRING.
    LV_CRLF_749 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_749 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_749 LV_CRLF_749 WA_CSV INTO LV_STRING_749.
      CLEAR: WA_CSV.
    ENDLOOP.
*TRANSFER lv_string_297 TO lv_fullfile.
    TRANSFER LV_STRING_749 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.






ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FTP_STR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_FTP_STR .


  LOOP AT GT_FINAL INTO GS_FINAL.

    GS_DOWN_FTP-EBELN             = GS_FINAL-EBELN.
    GS_DOWN_FTP-LIFNR             = GS_FINAL-LIFNR.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' EXPORTING INPUT = GS_FINAL-AEDAT IMPORTING OUTPUT = GS_DOWN_FTP-AEDAT.
    GS_DOWN_FTP-EKGRP             = GS_FINAL-EKGRP.
    GS_DOWN_FTP-NAME1             = GS_FINAL-NAME1.
    GS_DOWN_FTP-MBLNR             = GS_FINAL-MBLNR.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' EXPORTING INPUT = GS_FINAL-BUDAT_MKPF IMPORTING OUTPUT = GS_DOWN_FTP-BUDAT_MKPF.
    GS_DOWN_FTP-CHLN_INV          = GS_FINAL-CHLN_INV.
    GS_DOWN_FTP-MATNR             = GS_FINAL-MATNR.
    GS_DOWN_FTP-MENGE_J_1IG_SUBCON = GS_FINAL-MENGE_J_1IG_SUBCON.
    GS_DOWN_FTP-EBELP             = GS_FINAL-EBELP.
    GS_DOWN_FTP-BRAND             = GS_FINAL-BRAND.
    GS_DOWN_FTP-ZSERIES           = GS_FINAL-ZSERIES.
    GS_DOWN_FTP-ZSIZE             = GS_FINAL-ZSIZE.
    GS_DOWN_FTP-MOC               = GS_FINAL-MOC.
    GS_DOWN_FTP-TYPE              = GS_FINAL-TYPE.
    GS_DOWN_FTP-DELIVERY_TEXT     = GS_FINAL-DELIVERY_TEXT.
    GS_DOWN_FTP-BDMNG             = GS_FINAL-BDMNG.
    GS_DOWN_FTP-MAKTX             = GS_FINAL-MAKTX.
    GS_DOWN_FTP-YES               = GS_FINAL-YES  .

    CONDENSE GS_DOWN_FTP-BDMNG NO-GAPS .
    CONDENSE GS_DOWN_FTP-MENGE_J_1IG_SUBCON NO-GAPS .
    GS_DOWN_FTP-PEND_CHLLN_QTY    = GS_FINAL-PEND_CHLLN_QTY.

    IF GS_FINAL-PEND_CHLLN_QTY < 0 .    """""""""" NC
      CONDENSE GS_DOWN_FTP-PEND_CHLLN_QTY  NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN GS_DOWN_FTP-PEND_CHLLN_QTY WITH SPACE .
      CONCATENATE '-' GS_DOWN_FTP-PEND_CHLLN_QTY  INTO GS_DOWN_FTP-PEND_CHLLN_QTY  .
    ENDIF.
     CONDENSE GS_DOWN_FTP-PEND_CHLLN_QTY  NO-GAPS  .
    GS_DOWN_FTP-QTY_RECV          = GS_FINAL-QTY_RECV.

    IF GS_FINAL-QTY_RECV < 0 .    """""""""" NC
      CONDENSE GS_DOWN_FTP-QTY_RECV  NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN GS_DOWN_FTP-QTY_RECV WITH SPACE .
      CONCATENATE '-' GS_DOWN_FTP-QTY_RECV  INTO GS_DOWN_FTP-QTY_RECV  .
    ENDIF.
     CONDENSE GS_DOWN_FTP-QTY_RECV  NO-GAPS  .


    GS_DOWN_FTP-DIFF              = GS_FINAL-DIFF.

     IF GS_FINAL-DIFF < 0 .    """""""""" NC
      CONDENSE GS_DOWN_FTP-DIFF  NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN GS_DOWN_FTP-DIFF WITH SPACE .
      CONCATENATE '-' GS_DOWN_FTP-DIFF  INTO GS_DOWN_FTP-DIFF  .
    ENDIF.
      CONDENSE GS_DOWN_FTP-DIFF  NO-GAPS  .

    GS_DOWN_FTP-PENDING_PO        = GS_FINAL-PENDING_PO.
     IF GS_FINAL-PENDING_PO < 0 .    """""""""" NC
      CONDENSE GS_DOWN_FTP-PENDING_PO  NO-GAPS  .
      REPLACE ALL OCCURRENCES OF '-' IN GS_DOWN_FTP-PENDING_PO WITH SPACE .
      CONCATENATE '-' GS_DOWN_FTP-PENDING_PO  INTO GS_DOWN_FTP-PENDING_PO  .
    ENDIF.
     CONDENSE GS_DOWN_FTP-PENDING_PO  NO-GAPS  .



    GS_DOWN_FTP-PO_STATUS         = GS_FINAL-PO_STATUS.
    GS_DOWN_FTP-DELIVEY_MENGE     = GS_FINAL-DELIVEY_MENGE.
    CONDENSE GS_DOWN_FTP-DELIVEY_MENGE NO-GAPS .
    GS_DOWN_FTP-LGORT             = GS_FINAL-LGORT.  "Added by jyoti on 17.06.2024
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT' EXPORTING INPUT = SY-DATUM IMPORTING OUTPUT = GS_DOWN_FTP-REF_DT.



    APPEND GS_DOWN_FTP TO GT_DOWN_FTP.

  ENDLOOP.


ENDFORM.

FORM CVS_HEADER  USING    PD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
  'Vendor Name'
  'Vendor Code'
  'PO Number'
  'PO Date'
  'Mat Doc No'
  'Mat Doc No Posting Date'
  'Challan No'
  'Purchasing Group'
  'PO Line No'
  'Issue Item Code'
  'Issue Description'
  'PO Release Status'
  'Issue Code QTY In PO'
  'Delivery Created'
  'CH. Release QTY'
  'Pend. CH. Rel QTY'
  'QTY. Received'
  'Diff'
  'Pending PO'
  'PO Status Remark'
  'Brand'
  'Series'
  'Size'
  'MOC'
  'Type'
  'Issue Store Loaction'
  'File Created Date'
  'Storage Location' "added by jyoti on17.06.2024
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
