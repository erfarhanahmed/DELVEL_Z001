TYPES: gt_typesernr_prt LIKE komser OCCURS 0.

TYPES:BEGIN OF t_vepo,
        vbeln TYPE vepo-vbeln,
        posnr TYPE vepo-posnr,
        venum TYPE vepo-venum,
        vemng TYPE vepo-vemng,
      END OF t_vepo.

TYPES:BEGIN OF t_vekp,
        exidv    TYPE vekp-exidv,
        vhilm    TYPE vekp-vhilm,
        vhilm_ku TYPE vekp-vhilm_ku,
*BRGEW type vekp-BRGEW,
        ntgew    TYPE vekp-ntgew,
      END OF t_vekp.

TYPES:BEGIN OF t_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF t_makt.

TYPES: BEGIN OF ty_pack,
         vhilm TYPE vekp-vhilm,
         pkcnt TYPE i,
         maktx TYPE makt-maktx,
         groes TYPE mara-groes,
       END OF ty_pack.

TYPES: BEGIN OF ty_adr,
         line LIKE adrs-line0,
       END OF ty_adr.

TYPES: BEGIN OF ty_likp,
       VBELN TYPE likp-VBELN,
       VERUR TYPE likp-VERUR,
       ERDAT TYPE likp-ERDAT,
       END OF ty_likp.

*****       changes by shreya 18-11-2021*****
TYPES : BEGIN OF ty_vbfa,
        vbeln TYPE vbfa-vbeln,
        vbelv type vbfa-vbelv,
        end of ty_vbfa.

        TYPES : BEGIN OF ty_likp1,
ERDAT TYPE likp-ERDAT,
        end of ty_likp1.


*        TYPES :BEGIN OF TY_MATNR,
*               matnr  TYPE matnr ,
*               lfimg  TYPE lfimg ,
*               brgew  TYPE brgew ,
*               ntgew  TYPE ntgew ,
*               END OF TY_MATNR.


        TYPES :BEGIN OF TY_MATNR,
               lfimg TYPE lfimg ,
               brgew TYPE brgew ,
               ntgew TYPE ntgew ,
               vbelv TYPE vbelv ,
               posnv TYPE posnv ,
               matnr TYPE matnr ,
               item_type type mara-item_type,
               type type mara-type,
               MAKTX  TYPE MAKT-MAKTX,
               AUFNR  TYPE AUFM-aufnr,
               MENGE  TYPE AUFM-menge,
               VHILM_KU TYPE VEKP-vhilm_ku,
               SR_NO   TYPE STRING,
             END OF TY_MATNR.

        TYPES :BEGIN OF TY_FINAL,
               lfimg TYPE lfimg ,
               brgew TYPE brgew ,
               ntgew TYPE ntgew ,
               vbelv TYPE LIPS-vbelv ,
               posnv TYPE LIPS-posnv ,
               matnr TYPE MARA-matnr ,
               item_type type mara-item_type,
               type type mara-type,
                MAKTX  TYPE MAKT-MAKTX,
               AUFNR  TYPE AUFM-aufnr,
               MENGE  TYPE AUFM-menge,
               VHILM_KU TYPE VEKP-vhilm_ku,
               SR_NO   TYPE STRING,
             END OF TY_FINAL.
