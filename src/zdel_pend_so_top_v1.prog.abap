*&---------------------------------------------------------------------*
*&  Include           ZSD_PEND_SO_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSD_PENDING_SO_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF TY_DATA,
          VBELN TYPE VBELN,
          POSNR TYPE POSNR,
          MATNR TYPE MATNR,    "edited by PJ 16-08-21
          LGORT TYPE VBAP-LGORT,     "Added by Pranit 10.06.2024
          LFSTA TYPE VBAP-LFSTA,
          LFGSA TYPE VBAP-LFGSA,
*          FKSTA TYPE VBUP-FKSTA,
          ABSTA TYPE VBAP-ABSTA,
          GBSTA TYPE VBAP-GBSTA,
*         WERKS TYPE WERKS,
        END OF TY_DATA.

TYPES : BEGIN OF TY_CDHDR,
          OBJECTCLAS TYPE CDHDR-OBJECTCLAS,
          OBJECTID   TYPE CDHDR-OBJECTID,
          UDATE      TYPE CDHDR-UDATE,
          TCODE      TYPE CDHDR-TCODE,
        END OF TY_CDHDR.
TYPES : BEGIN OF OUTPUT,
          WERKS           TYPE WERKS_EXT,
          AUART           TYPE VBAK-AUART,
          BSTKD           TYPE VBKD-BSTKD,
          NAME1           TYPE KNA1-NAME1,
          VKBUR           TYPE VBAK-VKBUR,
          VBELN           TYPE VBAK-VBELN,
          ERDAT           TYPE VBAK-ERDAT,
          VDATU           TYPE VBAK-VDATU,
          STATUS          TYPE TEXT30,
          HOLDDATE        TYPE VBAP-HOLDDATE,
          RELDATE         TYPE VBAP-HOLDRELDATE,
          CANCELDATE      TYPE VBAP-CANCELDATE,
          DELDATE         TYPE VBAP-DELDATE,
*          tag_req      TYPE char20,
          TAG_REQ         TYPE CHAR50,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          TPI             TYPE CHAR50,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          LD_TXT          TYPE CHAR50,           "changed by sr on 03.05.2021
          ZLDPERWEEK      TYPE ZLDPERWEEK1,
          ZLDMAX          TYPE VBAK-ZLDMAX,
          ZLDFROMDATE     TYPE VBAK-ZLDFROMDATE,

********
          MATNR           TYPE VBAP-MATNR,
          POSNR           TYPE VBAP-POSNR,
          ARKTX           TYPE VBAP-ARKTX,
          KWMENG          TYPE VBAP-KWMENG,
          STOCK_QTY       TYPE MSKA-KALAB,
*          kalab       TYPE mska-kalab,
          LFIMG           TYPE LIPS-LFIMG,
          FKIMG           TYPE VBRP-FKIMG,
          PND_QTY         LIKE VBRP-FKIMG,
          ETTYP           TYPE VBEP-ETTYP,
          MRP_DT          TYPE UDATE,
          EDATU           TYPE VBEP-EDATU,
          KBETR           TYPE PRCD_ELEMENTS-KBETR, "KONV-KBETR,
          WAERK           TYPE VBAP-WAERK,
          CURR_CON        TYPE UKURSP,
          SO_EXC          TYPE UKURSP,
          AMONT           TYPE CHAR15,             "kbetr,
          ORDR_AMT        TYPE CHAR15,             "kbetr,
*          KURSK         TYPE VBKD-KURSK,
          IN_PRICE        TYPE PRCD_ELEMENTS-KBETR,
          IN_PR_DT        TYPE PRCD_ELEMENTS-KDATU,
          EST_COST        TYPE PRCD_ELEMENTS-KBETR,
          LATST_COST      TYPE PRCD_ELEMENTS-KBETR,
          ST_COST         TYPE MBEW-STPRS,
          ZSERIES         TYPE MARA-ZSERIES,
          ZSIZE           TYPE MARA-ZSIZE,
          BRAND           TYPE MARA-BRAND,
          MOC             TYPE MARA-MOC,
          TYPE            TYPE MARA-TYPE,

          """"""""   Added By KD 04.05.2017    """""""
          DISPO           TYPE MARC-DISPO,
          WIP             TYPE VBRP-FKIMG,
          MTART           TYPE MARA-MTART,
          KDMAT           TYPE VBAP-KDMAT,
          KUNNR           TYPE KNA1-KUNNR,
          QMQTY           TYPE MSKA-KAINS,
          MATTXT          TYPE TEXT100,
          ITMTXT          TYPE CHAR255,
          ETENR           TYPE VBEP-ETENR,
          SCHID           TYPE STRING,
          ZTERM           TYPE VBKD-ZTERM,
          TEXT1           TYPE T052U-TEXT1,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE VBKD-INCO2,
          OFM             TYPE CHAR50,
          OFM_DATE        TYPE CHAR50,
*          spl           type char255,
          CUSTDELDATE     TYPE VBAP-CUSTDELDATE,
          REF_DT          TYPE SY-DATUM,

          """"""""""""""""""""""""""""""""""""""""""""
          ABGRU           TYPE  VBAP-ABGRU,            " avinash bhagat 20.12.2018
          BEZEI           TYPE  TVAGT-BEZEI,         " avinash bhagat 20.12.2018
          WRKST           TYPE  MARA-WRKST,
          CGST(4)         TYPE  C,
*          cgst_val(15) TYPE  c,
          SGST(4)         TYPE  C,
*          sgst_val(15) TYPE  c,
          IGST(4)         TYPE  C,
*          igst_val(15) TYPE  c,
          SHIP_KUNNR      TYPE KUNNR,            "ship to party code
          SHIP_KUNNR_N    TYPE AD_NAME1,         "ship to party desctiption
          SHIP_REG_N      TYPE BEZEI,            ""ship to party gst region description
          SOLD_REG_N      TYPE BEZEI,             "sold to party gst region description
          NORMT           TYPE MARA-NORMT,
          SHIP_LAND       TYPE VBPA-LAND1,
          S_LAND_DESC     TYPE T005T-LANDX50,
          SOLD_LAND       TYPE VBPA-LAND1,
          POSEX           TYPE VBAP-POSEX,
          BSTDK           TYPE VBAK-BSTDK,
          LIFSK           TYPE VBAK-LIFSK,
          VTEXT           TYPE TVLST-VTEXT,
          INSUR           TYPE CHAR250,
          PARDEL          TYPE CHAR250,
          GAD             TYPE CHAR50,
          US_CUST         TYPE CHAR250,
          TCS(11)         TYPE P DECIMALS 3,
          TCS_AMT         TYPE KONV-KWERT,
          SPL             TYPE CHAR255,
          PO_DEL_DATE     TYPE VBAP-CUSTDELDATE,
          OFM_NO          TYPE CHAR128,
          CTBG            TYPE CHAR10,            "added by sr on 03.05.2021 ctbgi details
          CERTIF          TYPE CHAR255,             "added by sr on 03.05.2021 certification details
*          knumv        type konv-knumv,             " added by pankaj 28.01.2022

*          ctbg         TYPE char10,                     " added by ajay

          ITEM_TYPE       TYPE MARA-ITEM_TYPE, " edited by PJ on 16-08-21
          REF_TIME        TYPE CHAR10,          " edited by PJ on 08-09-21
          PROJ            TYPE CHAR255,                         "added by pankaj 28.01.2022
          COND            TYPE CHAR255,                       "added by pankaj 28.01.2022
          RECEIPT_DATE    TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
          REASON          TYPE CHAR30,                "added by pankaj 28.01.2022
          NTGEW           TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
          ZPR0            TYPE KWERT,              "added by pankaj 28.01.2022
          ZPF0            TYPE KWERT,              "added by pankaj 28.01.2022
          ZIN1            TYPE KWERT,              "added by pankaj 28.01.2022
          ZIN2            TYPE KWERT,             "added by pankaj 28.01.2022
          JOIG            TYPE KWERT,              "added by pankaj 28.01.2022
          JOCG            TYPE KWERT,              "added by pankaj 28.01.2022
          JOSG            TYPE KWERT,                "added by pankaj 28.01.2022
*          DIS_RATE        TYPE KBETR,
*          DIS_RATE        TYPE P DECIMALS 2,
*          DIS_AMT         TYPE PRCD_ELEMENTS-KWERT,        "Discount
*          DIS_UNIT_RATE   TYPE PRCD_ELEMENTS-KWERT,
*          TOT_ASS         TYPE PRCD_ELEMENTS-KBETR,        "Discount
*          ASS2_VAL        TYPE PRCD_ELEMENTS-KWERT,
          DATE            TYPE VBEP-EDATU,
          PRSDT           TYPE VBKD-PRSDT,
          PACKING_TYPE    TYPE CHAR255,
          OFM_DATE1       TYPE CHAR12,  "vbap-ofm_date,
          MAT_TEXT        TYPE CHAR15,
          INFRA           TYPE CHAR255,         "added by pankaj 31.01.2022
          VALIDATION      TYPE CHAR255,         "added by pankaj 31.01.2022
          REVIEW_DATE     TYPE CHAR255,         "added by pankaj 31.01.2022   b
          DISS_SUMMARY    TYPE CHAR255,        "added by pankaj 31.01.2022
          CHANG_SO_DATE   TYPE VBAP-ERDAT,

          """""""" added by pankaj 04.02.2022
          PORT            TYPE ADRC-NAME1,
          FULL_PMNT       TYPE CHAR255,
          ACT_ASS         TYPE TVKTT-VTEXT,
          TXT04           TYPE TJ30T-TXT04,
*          kwert         type konv-kwert,
          FREIGHT         TYPE CHAR128,
          PO_SR_NO        TYPE CHAR128,

          UDATE           TYPE CHAR15,            "cdhdr-udate,
          BOM             TYPE MARA-BOM,
          ZPEN_ITEM       TYPE MARA-ZPEN_ITEM,
          ZRE_PEN_ITEM    TYPE MARA-ZRE_PEN_ITEM,
* Commented by Dhanashree because this fields shows in downloaded excel
**          ktgrd         TYPE char255,
**          objnr         TYPE char255,
**          stat          TYPE char255,
**          stsma         TYPE char255,
**          adrnr         TYPE vbpa-adrnr,
**          spras         type tvktt-spras,
**          kwert         type konv-kwert,

*          objectclas    type cdhdr-objectclas,
*          objectid      type cdhdr-objectid,
*
*          tcode         type cdhdr-tcode,
*

*          faksk         type vbak-faksk,
*          vtext1        type tvfst-vtext,
          ZINS_LOC        TYPE VBAP-ZINS_LOC,
          BOM_EXIST       TYPE CHAR5,
*          BSTKD1        TYPE VBKD-BSTKD,"ADDED BY JYOTI ON 16.04.2024
          POSEX1          TYPE VBAP-POSEX, "ADDED BY JYOTI ON 16.04.2024
          LGORT           TYPE VBAP-LGORT, ""Added by Pranit 10.06.2024
          QUOTA_REF       TYPE CHAR128, "added by jyoti on19.06.2024
          ZMRP_DATE       TYPE VBAP-ZMRP_DATE, "added by jyoti on 02.07.2024

****************************************************************************
          VKORG           TYPE VBAK-VKORG ,    " ADDED BY SUPRIYA ON 19.08.2024
          VTWEG           TYPE VBAK-VTWEG ,  " ADDED BY SUPRIYA ON 19.08.2024
          SPART           TYPE VBAK-SPART,     " ADDED BY SUPRIYA ON 19.08.2024
          ZEXP_MRP_DATE1  TYPE VBAP-ZEXP_MRP_DATE1, "added by jyoti on 13.11.2024
          SPECIAL_COMM    TYPE CHAR250,
          ZCUST_PROJ_NAME TYPE CHAR250, "added by jyoti on 04.12.2024
          AMENDMENT_HIS   TYPE CHAR250, "added by jyoti on 20.01.2025
          PO_DIS          TYPE CHAR250, "added by jyoti on 20.01.2025
          HOLD_REASON_N1  TYPE VBAP-ZHOLD_REASON_N1 , "added by jyoti on 06.02.2025
        END OF OUTPUT.

""""""""""    Added By KD 04.05.2017        """""""""""4
***********************added by jyoti on 26.04.2024*************************************
TYPES : BEGIN OF OUTPUT_NEW,
          WERKS           TYPE WERKS_EXT,
          AUART           TYPE VBAK-AUART,
          BSTKD           TYPE VBKD-BSTKD,
          NAME1           TYPE KNA1-NAME1,
          VKBUR           TYPE VBAK-VKBUR,
          VBELN           TYPE VBAK-VBELN,
          ERDAT           TYPE CHAR11, "vbak-erdat,
          VDATU           TYPE CHAR11, "vbak-vdatu,
          STATUS          TYPE TEXT30,
          HOLDDATE        TYPE CHAR11, "vbap-holddate,
          RELDATE         TYPE CHAR11, "vbap-holdreldate,
          CANCELDATE      TYPE CHAR11, "vbap-canceldate,
          DELDATE         TYPE CHAR11, "vbap-deldate,
*          tag_req      TYPE char20,
          TAG_REQ         TYPE CHAR50,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          TPI             TYPE CHAR50,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          LD_TXT          TYPE CHAR50,           "changed by sr on 03.05.2021
          ZLDPERWEEK      TYPE ZLDPERWEEK1,
          ZLDMAX          TYPE VBAK-ZLDMAX,
          ZLDFROMDATE     TYPE CHAR11, "vbak-zldfromdate,

********
          MATNR           TYPE VBAP-MATNR,
          POSNR           TYPE VBAP-POSNR,
          ARKTX           TYPE VBAP-ARKTX,
          KWMENG          TYPE CHAR15, "vbap-kwmeng,
          STOCK_QTY       TYPE CHAR15, "mska-kalab,
*          kalab       TYPE mska-kalab,
          LFIMG           TYPE CHAR15, "lips-lfimg,
          FKIMG           TYPE CHAR15, "vbrp-fkimg,
          PND_QTY         TYPE CHAR15, "vbrp-fkimg,
          ETTYP           TYPE VBEP-ETTYP,
          MRP_DT          TYPE CHAR11, "udate,
          EDATU           TYPE CHAR11, "vbep-edatu,
          KBETR           TYPE CHAR256, "prcd_elements-kbetr," CHAR15, "konv-kbetr,
          WAERK           TYPE VBAP-WAERK,
          CURR_CON        TYPE UKURSP,
          AMONT           TYPE CHAR15,             "kbetr,
          ORDR_AMT        TYPE CHAR15,             "kbetr,
          IN_PRICE        TYPE CHAR36  ,  "CHAR15, "konv-kbetr,
          IN_PR_DT        TYPE PRCD_ELEMENTS-KDATU  ,  "CHAR11, "konv-kdatu,
          EST_COST        TYPE CHAR36  ,  "CHAR15, "konv-kbetr,
          LATST_COST      TYPE CHAR36 , "PRCD_ELEMENTS-KBETR  ,  "CHAR15, "konv-kbetr,
          ST_COST         TYPE CHAR15, "mbew-stprs,
          ZSERIES         TYPE MARA-ZSERIES,
          ZSIZE           TYPE MARA-ZSIZE,
          BRAND           TYPE MARA-BRAND,
          MOC             TYPE MARA-MOC,
          TYPE            TYPE MARA-TYPE,

          """"""""   Added By KD 04.05.2017    """""""
          DISPO           TYPE MARC-DISPO,
          WIP             TYPE CHAR15, "vbrp-fkimg,
          MTART           TYPE MARA-MTART,
          KDMAT           TYPE VBAP-KDMAT,
          KUNNR           TYPE KNA1-KUNNR,
          QMQTY           TYPE CHAR15, "mska-kains,
          MATTXT          TYPE TEXT100,
          ITMTXT          TYPE CHAR255,
          ETENR           TYPE VBEP-ETENR,
          SCHID           TYPE      STRING,
          SO_EXC          TYPE UKURSP,
          ZTERM           TYPE VBKD-ZTERM,
          TEXT1           TYPE CHAR50, "t052u-text1,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE CHAR13, "vbkd-inco2,
          OFM             TYPE CHAR50,
          OFM_DATE        TYPE CHAR50,
          CUSTDELDATE     TYPE CHAR11, "vbap-custdeldate,
          REF_DT          TYPE CHAR11, "sy-datum,

          """"""""""""""""""""""""""""""""""""""""""""
          ABGRU           TYPE  VBAP-ABGRU,            " avinash bhagat 20.12.2018
          BEZEI           TYPE  TVAGT-BEZEI,         " avinash bhagat 20.12.2018
          WRKST           TYPE  MARA-WRKST,
          CGST(4)         TYPE  C,
          SGST(4)         TYPE  C,
          IGST(4)         TYPE  C,
          SHIP_KUNNR      TYPE KUNNR,            "ship to party code
          SHIP_KUNNR_N    TYPE AD_NAME1,         "ship to party desctiption
          SHIP_REG_N      TYPE BEZEI,            ""ship to party gst region description
          SOLD_REG_N      TYPE BEZEI,             "sold to party gst region description
          NORMT           TYPE MARA-NORMT,
          SHIP_LAND       TYPE VBPA-LAND1,
          SOLD_LAND       TYPE VBPA-LAND1,
          POSEX           TYPE VBAP-POSEX,
          S_LAND_DESC     TYPE CHAR50, "t005t-landx50,
          BSTDK           TYPE CHAR11, "vbak-bstdk,
          LIFSK           TYPE CHAR10, "vbak-lifsk,
          VTEXT           TYPE CHAR20, "tvlst-vtext,
          INSUR           TYPE CHAR250,
          PARDEL          TYPE CHAR250,
          GAD             TYPE CHAR50,
          US_CUST         TYPE CHAR250,
          TCS             TYPE CHAR15, "p DECIMALS 3,
          TCS_AMT         TYPE CHAR15, "konv-kwert,
          SPL             TYPE CHAR255,
          PO_DEL_DATE     TYPE CHAR11, ",vbap-custdeldate,
          OFM_NO          TYPE CHAR128,
          CTBG            TYPE CHAR10,            "added by sr on 03.05.2021 ctbgi details
          CERTIF          TYPE CHAR255,             "added by sr on 03.05.2021 certification details
          ITEM_TYPE       TYPE MARA-ITEM_TYPE, " edited by PJ on 16-08-21
          REF_TIME        TYPE CHAR10,          " edited by PJ on 08-09-21
          PROJ            TYPE CHAR255,                         "added by pankaj 28.01.2022
          COND            TYPE CHAR255,                       "added by pankaj 28.01.2022
          RECEIPT_DATE    TYPE CHAR20, "vbap-receipt_date,          "added by pankaj 28.01.2022
          REASON          TYPE CHAR30,                "added by pankaj 28.01.2022
          NTGEW           TYPE CHAR25, "vbap-ntgew,          "added by pankaj 28.01.2022
          ZPR0            TYPE CHAR15, ""kwert,              "added by pankaj 28.01.2022
          ZPF0            TYPE CHAR15, "kwert,              "added by pankaj 28.01.2022
          ZIN1            TYPE CHAR15, "kwert,              "added by pankaj 28.01.2022
          ZIN2            TYPE CHAR15, "kwert,             "added by pankaj 28.01.2022
          JOIG            TYPE CHAR15, "kwert,              "added by pankaj 28.01.2022
          JOCG            TYPE CHAR15, "kwert,              "added by pankaj 28.01.2022
          JOSG            TYPE CHAR15, "kwert,                "added by pankaj 28.01.2022
          DATE            TYPE CHAR15, "vbep-edatu,
          PRSDT           TYPE CHAR15, "vbkd-prsdt,
          PACKING_TYPE    TYPE CHAR15,
          OFM_DATE1       TYPE CHAR50,  "vbap-ofm_date,
          MAT_TEXT        TYPE CHAR15,
          INFRA           TYPE CHAR255,         "added by pankaj 31.01.2022
          VALIDATION      TYPE CHAR255,         "added by pankaj 31.01.2022
          REVIEW_DATE     TYPE CHAR255,         "added by pankaj 31.01.2022   b
          DISS_SUMMARY    TYPE CHAR255,        "added by pankaj 31.01.2022
          CHANG_SO_DATE   TYPE CHAR255, "vbap-erdat,
          """""""" added by pankaj 04.02.2022
          PORT            TYPE ADRC-NAME1,
          FULL_PMNT       TYPE CHAR255,
          ACT_ASS         TYPE CHAR255, "tvktt-vtext,
          TXT04           TYPE CHAR255, "tj30t-txt04,
          FREIGHT         TYPE CHAR128,
          PO_SR_NO        TYPE CHAR128,
          UDATE           TYPE CHAR11,            "cdhdr-udate,
          BOM             TYPE MARA-BOM,
          ZPEN_ITEM       TYPE MARA-ZPEN_ITEM,
          ZRE_PEN_ITEM    TYPE MARA-ZRE_PEN_ITEM,
          ZINS_LOC        TYPE VBAP-ZINS_LOC,
          BOM_EXIST       TYPE CHAR5,
          POSEX1          TYPE VBAP-POSEX, "adde by jyoti on 16.04.2024
          LGORT           TYPE VBAP-LGORT, "added by Pranit on 20.06.2024
          QUOTA_REF       TYPE CHAR128 , "added by jyoti on19.06.2024
          ZMRP_DATE       TYPE CHAR11, "ADDED BY JYOTI OM 02.07.2024
***************************************************************************
          VKORG           TYPE VBAK-VKORG ,    " ADDED BY SUPRIYA ON 19.08.2024
          VTWEG           TYPE VBAK-VTWEG ,  " ADDED BY SUPRIYA ON 19.08.2024
          SPART           TYPE VBAK-SPART,     " ADDED BY SUPRIYA ON 19.08.2024
*************************************************************************
          ZEXP_MRP_DATE1  TYPE CHAR11, "added by jyoti on 13.11.2024
          SPECIAL_COMM    TYPE STRING,
          ZCUST_PROJ_NAME TYPE STRING, "added by jyoti on 04.12.2024
          AMENDMENT_HIS   TYPE CHAR250, "added by jyoti on 20.01.2025
          PO_DIS          TYPE CHAR250, "added by jyoti on 20.01.2025
          HOLD_REASON_N1  TYPE STRING , "added by jyoti on 06.02.2025
        END OF OUTPUT_NEW.

*
*DATA : GV_KBETR2 TYPE PRCD_ELEMENTS-KBETR.
*DATA : GV_KBETR3 TYPE PRCD_ELEMENTS-KBETR.
*DATA : GV_KBETR TYPE PRCD_ELEMENTS-KBETR.
*DATA : GV_KWERT TYPE PRCD_ELEMENTS-KWERT.
*DATA : GV_KWERT2 TYPE PRCD_ELEMENTS-KWERT.


TYPES : BEGIN OF TY_TVAGT,
          SPRAS TYPE  TVAGT-SPRAS,
          ABGRU TYPE  TVAGT-ABGRU,
          BEZEI TYPE  TVAGT-BEZEI,
        END OF TY_TVAGT.

DATA : IT_TVAGT TYPE STANDARD TABLE OF TY_TVAGT,
       WA_TVAGT TYPE TY_TVAGT.
DATA : LV_CGST      TYPE KBETR,
       LV_CGST_TEMP TYPE STRING.

TYPES : BEGIN OF TY_AFPO,
          AUFNR TYPE AFPO-AUFNR,
          POSNR TYPE AFPO-POSNR,
          KDAUF TYPE AFPO-KDAUF,
          KDPOS TYPE AFPO-KDPOS,
          MATNR TYPE AFPO-MATNR,
          PGMNG TYPE AFPO-PGMNG,
          PSMNG TYPE AFPO-PSMNG,
          WEMNG TYPE AFPO-WEMNG,
        END OF TY_AFPO.

TYPES : BEGIN OF TY_CAUFV,
          AUFNR TYPE CAUFV-AUFNR,
          OBJNR TYPE CAUFV-OBJNR,
          KDAUF TYPE CAUFV-KDAUF,
          KDPOS TYPE CAUFV-KDPOS,
          IGMNG TYPE CAUFV-IGMNG,
        END OF TY_CAUFV .

TYPES : BEGIN OF TY_JEST,
          OBJNR TYPE JEST-OBJNR,
          STAT  TYPE JEST-STAT,
        END OF TY_JEST.

TYPES : BEGIN OF TY_TJ02T,
          ISTAT TYPE TJ02T-ISTAT,
          TXT04 TYPE TJ02T-TXT04,
        END OF TY_TJ02T.

TYPES : BEGIN OF TY_MAST,
          MATNR TYPE MAST-MATNR,
          WERKS TYPE MAST-WERKS,
          STLAN TYPE MAST-STLAN,
          STLNR TYPE MAST-STLNR,
          STLAL TYPE MAST-STLAL,
        END OF TY_MAST.

TYPES : BEGIN OF TY_STKO,
          STLTY TYPE STKO-STLTY,
          STLNR TYPE STKO-STLNR,
          STLAL TYPE STKO-STLAL,
          STKOZ TYPE STKO-STKOZ,
        END OF TY_STKO.

TYPES : BEGIN OF TY_STPO,
          STLTY TYPE STPO-STLTY,
          STLNR TYPE STPO-STLNR,
          STLKN TYPE STPO-STLKN,
          STPOZ TYPE STPO-STPOZ,
          IDNRK TYPE STPO-IDNRK,
        END OF TY_STPO.

TYPES:
  BEGIN OF T_RESB,
    RSNUM TYPE RESB-RSNUM,
    RSPOS TYPE RESB-RSPOS,
    RSART TYPE RESB-RSART,
    BDMNG TYPE RESB-BDMNG,
    ENMNG TYPE RESB-ENMNG,
    AUFNR TYPE RESB-AUFNR,
    KDAUF TYPE RESB-KDAUF,
    KDPOS TYPE RESB-KDPOS,
  END OF T_RESB,
  TT_RESB TYPE STANDARD TABLE OF T_RESB.


TYPES:
  BEGIN OF T_FINAL    ,
    WERKS             TYPE WERKS_EXT,
    AUART             TYPE VBAK-AUART,
    BSTKD             TYPE VBKD-BSTKD,
    NAME1             TYPE KNA1-NAME1,
    VKBUR             TYPE VBAK-VKBUR,
    VBELN             TYPE VBAK-VBELN,
    ERDAT             TYPE CHAR11, "vbak-erdat,
    VDATU             TYPE CHAR11, "vbak-vdatu,
    STATUS            TYPE TEXT30,
    HOLDDATE          TYPE CHAR11, "vbap-holddate,
    RELDATE           TYPE CHAR11, "vbap-holdreldate,
    CANCELDATE        TYPE CHAR11, "vbap-canceldate,
    DELDATE           TYPE CHAR11, "vbap-deldate,
*    tag_req      TYPE char20,
    TAG_REQ           TYPE CHAR50,
*         ld 5 fields
*    tpi          TYPE char20,
    TPI               TYPE CHAR50,           "changed by sr on 03.05.2021
*    ld_txt       TYPE char20,
    LD_TXT            TYPE CHAR50,           "changed by sr on 03.05.2021
    ZLDPERWEEK        TYPE ZLDPERWEEK1,
    ZLDMAX            TYPE VBAK-ZLDMAX,
    ZLDFROMDATE       TYPE CHAR11, "vbak-zldfromdate,

********
    MATNR             TYPE VBAP-MATNR,
    POSNR             TYPE VBAP-POSNR,
    ARKTX             TYPE VBAP-ARKTX,
    KWMENG            TYPE CHAR256, "vbap-kwmeng,
    KALAB             TYPE CHAR256, "mska-kalab,
*    stock_qty   TYPE mska-kalab,
    LFIMG             TYPE CHAR15, "lips-lfimg,
    FKIMG             TYPE CHAR15, "vbrp-fkimg,
    PND_QTY           TYPE CHAR15, "vbrp-fkimg,
    ETTYP             TYPE VBEP-ETTYP,
    MRP_DT            TYPE CHAR11, "udate,
    EDATU             TYPE CHAR11, "vbep-edatu,
*    kbetr           TYPE char15, "konv-kbetr,
    KBETR             TYPE CHAR256 , "prcd_elements-kbetr  , "konv-kbetr,
    WAERK             TYPE VBAP-WAERK,
    CURR_CON          TYPE UKURSP,
    AMONT             TYPE CHAR256, "kbetr,
    ORDR_AMT          TYPE CHAR256, "kbetr,
*          KURSK         TYPE VBKD-KURSK,
    IN_PRICE          TYPE CHAR256, "konv-kbetr,
    IN_PR_DT          TYPE CHAR256, "konv-kdatu,
    EST_COST          TYPE CHAR256, "konv-kbetr,
    LATST_COST        TYPE CHAR256, "konv-kbetr,
    ST_COST           TYPE CHAR256, "mbew-stprs,
    ZSERIES           TYPE MARA-ZSERIES,
    ZSIZE             TYPE MARA-ZSIZE,
    BRAND             TYPE MARA-BRAND,
    MOC               TYPE MARA-MOC,
    TYPE              TYPE MARA-TYPE,

    """"""""   Added By KD 04.05.2017    """""""
    DISPO             TYPE MARC-DISPO,
    WIP               TYPE CHAR15,
    MTART             TYPE MARA-MTART,
    KDMAT             TYPE VBAP-KDMAT,
    KUNNR             TYPE KNA1-KUNNR,
    QMQTY             TYPE CHAR15, "mska-kains,
    MATTXT            TYPE CHAR100,
    ITMTXT            TYPE CHAR255,
    ETENR             TYPE VBEP-ETENR,
    SCHID             TYPE STRING,    "add by supriya on 2024.08.20
    SO_EXC            TYPE UKURSP,
    ZTERM             TYPE VBKD-ZTERM,
    TEXT1             TYPE CHAR50,
    INCO1             TYPE VBKD-INCO1,
    INCO2             TYPE CHAR30,
    OFM               TYPE CHAR50,
    OFM_DATE          TYPE CHAR50,
    CUSTDELDATE       TYPE CHAR11, "vbap-deldate,
    REF_DT            TYPE CHAR11,
    ABGRU             TYPE  VBAP-ABGRU,
    BEZEI             TYPE  TVAGT-BEZEI,
    WRKST             TYPE MARA-WRKST,
    CGST(4)           TYPE C, "konv-kbetr,
*    cgst_val(15) TYPE c, " konv-kwert,
    SGST(4)           TYPE  C, "konv-kbetr,
*    sgst_val(15) TYPE c, " konv-kwert,
    IGST(4)           TYPE  C, "konv-kbetr,
*    igst_val(15) TYPE  c, "konv-kwert,
    SHIP_KUNNR        TYPE KUNNR,            "ship to party code
    SHIP_KUNNR_N      TYPE AD_NAME1,         "ship to party desctiption
    SHIP_REG_N        TYPE BEZEI,            ""ship to party gst region
    SOLD_REG_N        TYPE BEZEI,             "ship to party gst region description
    NORMT             TYPE MARA-NORMT,
    SOLD_LAND         TYPE VBPA-LAND1,
    SHIP_LAND         TYPE VBPA-LAND1,
    POSEX             TYPE VBAP-POSEX,
    S_LAND_DESC       TYPE CHAR50,
    BSTDK             TYPE CHAR11,
    LIFSK             TYPE CHAR10,
    VTEXT             TYPE CHAR20,
    INSUR             TYPE CHAR250,
    PARDEL            TYPE CHAR250,
    GAD               TYPE CHAR50,
    US_CUST           TYPE CHAR250,
    TCS               TYPE CHAR256,
    TCS_AMT           TYPE CHAR256,
    SPL               TYPE CHAR256,
    PO_DEL_DATE       TYPE CHAR11,
    OFM_NO            TYPE CHAR128,
    CTBG              TYPE CHAR10,            "added by sr on 03.05.2021
    CERTIF            TYPE CHAR255,             "added by sr on 03.05.2021 certification details
*    ctbg         TYPE char10,                "ADDED BY AJAY  11052021
    ITEM_TYPE         TYPE MARA-ITEM_TYPE,  "edited by PJ on 16-08-21
    REF_TIME          TYPE CHAR10,  "edited by PJ on 08-09-21

    PROJ              TYPE CHAR255,                         "added by pankaj 28.01.2022
    COND              TYPE CHAR255,                       "added by pankaj 28.01.2022
    RECEIPT_DATE      TYPE CHAR20,              "vbap-receipt_date,          "added by pankaj 28.01.2022
    REASON            TYPE CHAR30,                "added by pankaj 28.01.2022
    NTGEW             TYPE CHAR25,             "added by pankaj 28.01.2022
    ZPR0              TYPE CHAR255,             "added by pankaj 28.01.2022
    ZPF0              TYPE CHAR255,              "added by pankaj 28.01.2022
    ZIN1              TYPE CHAR255,               "added by pankaj 28.01.2022
    ZIN2              TYPE CHAR255,                 "added by pankaj 28.01.2022
    JOIG              TYPE CHAR255,                 "added by pankaj 28.01.2022
    JOCG              TYPE CHAR255,                 "added by pankaj 28.01.2022
    JOSG              TYPE CHAR255,
    DATE              TYPE CHAR15,
    PRSDT             TYPE CHAR15,
    PACKING_TYPE      TYPE CHAR15,
    OFM_DATE1         TYPE CHAR50,
    MAT_TEXT          TYPE CHAR15,
    INFRA             TYPE CHAR255,         "added by pankaj 31.01.2022
    VALIDATION        TYPE CHAR255,         "added by pankaj 31.01.2022
    REVIEW_DATE       TYPE CHAR255,         "added by pankaj 31.01.2022
    DISS_SUMMARY      TYPE CHAR255,        "added by pankaj 31.01.2022
    CHANG_SO_DATE     TYPE CHAR255,
    """""" added by pankaj 04.02.2022
    PORT              TYPE ADRC-NAME1,          "added by pankaj 02.02.2022
    FULL_PMNT         TYPE CHAR255,             "added by pankaj 02.02.2022
    ACT_ASS           TYPE CHAR255,  "tvktt-vtext,         "added by pankaj 02.02.2022
    TXT04             TYPE CHAR255,
    FREIGHT           TYPE CHAR128,
    PO_SR_NO          TYPE CHAR128,
    UDATE             TYPE CHAR11,
    BOM               TYPE MARA-BOM,
    ZPEN_ITEM         TYPE MARA-ZPEN_ITEM,
    ZRE_PEN_ITEM      TYPE MARA-ZRE_PEN_ITEM,
*    faksk         type vbak-faksk,
*    vtext1        type tvfst-vtext,
    ZINS_LOC          TYPE VBAP-ZINS_LOC,
    BOM_EXIST         TYPE CHAR5,
*    BSTKD1        TYPE VBKD-BSTKD,"ADDED BY JYOTI ON 16.04.2024
    POSEX1            TYPE VBAP-POSEX, "ADDED BY JYOTI ON 16.04.2024
    LGORT             TYPE VBAP-LGORT, "ADDED BY Pranit ON 10.06.2024
    QUOTA_REF         TYPE CHAR128 , "added by jyoti on19.06.2024
    ZMRP_DATE         TYPE CHAR11, "ADDED BY JYOTI ON 02.07.2024
    VKORG             TYPE CHAR15,
    VTWEG             TYPE CHAR15,
    SPART             TYPE CHAR15,
    ZEXP_MRP_DATE1    TYPE CHAR11, "ADDED BY JYOTI ON 13.11.2024
    SPECIAL_COMM      TYPE STRING,
    ZCUST_PROJ_NAME   TYPE STRING, "added by jyoti on 04.12.2024
    AMENDMENT_HIS     TYPE STRING,
    PO_DIS            TYPE STRING,
    HOLD_REASON_N1    TYPE STRING , "added by jyoti on 06.02.2025
    STOCK_QTY_KTPI    TYPE STRING,  "added by jyoti on 28.03.2025
    STOCK_QTY_TPI1    TYPE STRING,  "added by jyoti on 28.03.2025
    OFM_RECEIVED_DATE TYPE STRING, "added by jyoti on 07.04.2025
    OSS_RECEIVED_CELL TYPE STRING, "added by jyoti on 07.04.2025
    SOURCE_REST       TYPE CHAR255,
    SUPPL_REST        TYPE CHAR255,
    CUST_MAT_DESC     TYPE CHAR255,
  END OF T_FINAL,
  TT_FINAL TYPE STANDARD TABLE OF T_FINAL.


DATA : IT_AFPO  TYPE TABLE OF TY_AFPO,
       WA_AFPO  TYPE TY_AFPO,
       IT_CAUFV TYPE TABLE OF TY_CAUFV,
       WA_CAUFV TYPE TY_CAUFV,
       IT_JEST2 TYPE TABLE OF TY_JEST,
       WA_JEST2 TYPE TY_JEST,
       IT_TJ02T TYPE TABLE OF TY_TJ02T,
       WA_TJ02T TYPE TY_TJ02T,
       IT_MAST  TYPE TABLE OF MAST,
       WA_MAST  TYPE MAST,
       IT_STKO  TYPE TABLE OF TY_STKO,
       WA_STKO  TYPE TY_STKO,
       IT_STPO  TYPE TABLE OF TY_STPO,
       WA_STPO  TYPE TY_STPO.

"""""""""""""""    end   04.05.2017  """""""""""""""""""""""""""""
TYPES : BEGIN OF TY_VBAK,
          VBELN       TYPE VBAK-VBELN,
          ERDAT       TYPE VBAK-ERDAT,
          AUART       TYPE VBAK-AUART,
          LIFSK       TYPE VBAK-LIFSK,
          WAERK       TYPE VBAK-WAERK,
          VKBUR       TYPE VBAK-VKBUR,
          KNUMV       TYPE VBAK-KNUMV,
          VDATU       TYPE VBAK-VDATU,
          BSTDK       TYPE VBAK-BSTDK,
          KUNNR       TYPE VBAK-KUNNR,
          OBJNR       TYPE VBAK-OBJNR,            "added by pankaj 04.02.2022
          ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
          ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
          ZLDMAX      TYPE VBAK-ZLDMAX,
          FAKSK       TYPE VBAK-FAKSK,
**********************************************************
          VKORG       TYPE VBAK-VKORG ,    " ADDED BY SUPRIYA ON 19.08.2024
          VTWEG       TYPE VBAK-VTWEG ,    " ADDED BY SUPRIYA ON 19.08.2024
          SPART       TYPE VBAK-SPART,     " ADDED BY SUPRIYA ON 19.08.2024
************************************************************
        END OF TY_VBAK,

        BEGIN OF TY_VBAP,
          VBELN           TYPE VBAP-VBELN,
          POSNR           TYPE VBAP-POSNR,
          MATNR           TYPE VBAP-MATNR,
          ARKTX           TYPE VBAP-ARKTX,
          ABGRU           TYPE VBAP-ABGRU,
          POSEX           TYPE VBAP-POSEX,
          KDMAT           TYPE VBAP-KDMAT,
          WAERK           TYPE VBAP-WAERK,
          KWMENG          TYPE VBAP-KWMENG,
          WERKS           TYPE VBAP-WERKS,
          NTGEW           TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
          OBJNR           TYPE VBAP-OBJNR,
          HOLDDATE        TYPE VBAP-HOLDDATE,
          HOLDRELDATE     TYPE VBAP-HOLDRELDATE,
          CANCELDATE      TYPE VBAP-CANCELDATE,
          DELDATE         TYPE VBAP-DELDATE,
          CUSTDELDATE     TYPE VBAP-CUSTDELDATE,
          ZGAD            TYPE VBAP-ZGAD,
          CTBG            TYPE VBAP-CTBG,  " ADDED BY AJAY
          RECEIPT_DATE    TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
          REASON          TYPE VBAP-REASON,                "added by pankaj 28.01.2022
          OFM_DATE        TYPE VBAP-OFM_DATE,                "added by pankaj 01.02.2022
          ERDAT           TYPE VBAP-ERDAT,
          ZINS_LOC        TYPE VBAP-ZINS_LOC,
          LGORT           TYPE VBAP-LGORT,     ""Added by Pranit 10.04.2024
          ZMRP_DATE       TYPE VBAP-ZMRP_DATE, "ADDED BY JYOTI ON 02.07.2024
          ZEXP_MRP_DATE1  TYPE VBAP-ZEXP_MRP_DATE1, "ADDED BY JYOTI ON 02.07.2024
          ZHOLD_REASON_N1 TYPE VBAP-ZHOLD_REASON_N1, "ADDED BY JYOTI ON 06.02.2025
        END OF TY_VBAP,

        BEGIN OF TY_VBAP2,
*          vbeln        TYPE vbap-vbeln,
          VBELN        TYPE CDHDR-OBJECTID,
          POSNR        TYPE VBAP-POSNR,
          MATNR        TYPE VBAP-MATNR,
          ARKTX        TYPE VBAP-ARKTX,
          ABGRU        TYPE VBAP-ABGRU,
          POSEX        TYPE VBAP-POSEX,
          KDMAT        TYPE VBAP-KDMAT,
          WAERK        TYPE VBAP-WAERK,
          KWMENG       TYPE VBAP-KWMENG,
          WERKS        TYPE VBAP-WERKS,
          NTGEW        TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
          OBJNR        TYPE VBAP-OBJNR,
          HOLDDATE     TYPE VBAP-HOLDDATE,
          HOLDRELDATE  TYPE VBAP-HOLDRELDATE,
          CANCELDATE   TYPE VBAP-CANCELDATE,
          DELDATE      TYPE VBAP-DELDATE,
          CUSTDELDATE  TYPE VBAP-CUSTDELDATE,
          ZGAD         TYPE VBAP-ZGAD,
          CTBG         TYPE VBAP-CTBG,  " ADDED BY AJAY
          RECEIPT_DATE TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
          REASON       TYPE VBAP-REASON,                "added by pankaj 28.01.2022
          OFM_DATE     TYPE VBAP-OFM_DATE,                "added by pankaj 01.02.2022
          ERDAT        TYPE VBAP-ERDAT,
        END OF TY_VBAP2,

        BEGIN OF TY_VBEP,
          VBELN TYPE VBEP-VBELN,
          POSNR TYPE VBEP-POSNR,
          ETENR TYPE VBEP-ETENR,
          ETTYP TYPE VBEP-ETTYP,
          EDATU TYPE VBEP-EDATU,
        END OF TY_VBEP,

        BEGIN OF TY_VBPA,
          VBELN TYPE VBPA-VBELN,
          POSNR TYPE VBPA-POSNR,
          PARVW TYPE VBPA-PARVW,
          KUNNR TYPE VBPA-KUNNR,
          ADRNR TYPE VBPA-ADRNR,
          LAND1 TYPE VBPA-LAND1,
        END OF TY_VBPA,

        BEGIN OF TY_VBKD,
          VBELN TYPE VBKD-VBELN,
          POSNR TYPE VBKD-POSNR, "added by jyoti on 16.04.2024
          INCO1 TYPE VBKD-INCO1,
          INCO2 TYPE VBKD-INCO2,
          ZTERM TYPE VBKD-ZTERM,
          KTGRD TYPE VBKD-KTGRD,                  "added by pankaj 04.02.2022
          KURSK TYPE VBKD-KURSK,
          BSTKD TYPE VBKD-BSTKD,
          PRSDT TYPE VBKD-PRSDT,

        END OF TY_VBKD,

        BEGIN OF TY_T052U,
          SPRAS TYPE T052U-SPRAS,
          ZTERM TYPE T052U-ZTERM,
          TEXT1 TYPE T052U-TEXT1,
        END OF TY_T052U,

        BEGIN OF TY_MSKA,
          MATNR TYPE MSKA-MATNR,
          WERKS TYPE MSKA-WERKS,
          LGORT TYPE MSKA-LGORT,
          VBELN TYPE MSKA-VBELN,
          POSNR TYPE MSKA-POSNR,
          KALAB TYPE MSKA-KALAB,
          KAINS TYPE MSKA-KAINS,
        END OF TY_MSKA,

        BEGIN OF TY_KONV,
          KNUMV TYPE  PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE  PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE  PRCD_ELEMENTS-KSCHL,
          KBETR TYPE  PRCD_ELEMENTS-KBETR,
          WAERS TYPE  PRCD_ELEMENTS-WAERS,
          KWERT TYPE  PRCD_ELEMENTS-KWERT,
        END OF TY_KONV,

        BEGIN OF TY_VBFA,
          VBELV   TYPE VBFA-VBELV,
          POSNV   TYPE VBFA-POSNV,
          VBELN   TYPE VBFA-VBELN,
          VBTYP_N TYPE VBFA-VBTYP_N,
        END OF TY_VBFA,

        BEGIN OF TY_VBRK,
          VBELN TYPE VBRK-VBELN,
          FKART TYPE VBRK-FKART,
          FKTYP TYPE VBRK-FKTYP,
          VKORG TYPE VBRK-VKORG,
          VTWEG TYPE VBRK-VTWEG,
          FKDAT TYPE VBRK-FKDAT,
          FKSTO TYPE VBRK-FKSTO,
        END OF TY_VBRK,

        BEGIN OF TY_VBRP,
          VBELN TYPE VBRP-VBELN,
          POSNR TYPE VBRP-POSNR,
          FKIMG TYPE VBRP-FKIMG,
          AUBEL TYPE VBRP-AUBEL,
          AUPOS TYPE VBRP-AUPOS,
          MATNR TYPE VBRP-MATNR,
          WERKS TYPE VBRP-WERKS,
        END OF TY_VBRP,

        BEGIN OF TY_KNA1,
          KUNNR TYPE KNA1-KUNNR,
          NAME1 TYPE KNA1-NAME1,
          ADRNR TYPE KNA1-ADRNR,
        END OF TY_KNA1,

        BEGIN OF TY_VBAP1,
          VBELN    TYPE VBAP-VBELN,
          POSNR    TYPE VBAP-POSNR,
          ZIBR     TYPE VBAP-ZIBR,
          ZUL      TYPE VBAP-ZUL,
          ZSL      TYPE VBAP-ZSL,
          ZCE      TYPE VBAP-ZCE,
          ZAPI6D   TYPE VBAP-ZAPI6D,
          ZAPI60   TYPE VBAP-ZAPI60,
          ZATEX    TYPE VBAP-ZATEX,
          ZTRCU    TYPE VBAP-ZTRCU,
          ZCRN     TYPE VBAP-ZCRN,
          ZMARINE  TYPE VBAP-ZMARINE,
          OFM_DATE TYPE VBAP-OFM_DATE,
          ERDAT    TYPE VBAP-ERDAT,
        END OF TY_VBAP1,

        """""""""" added by pankaj 04.02.2022

        BEGIN OF TY_TVKTT,
          KTGRD TYPE TVKTT-KTGRD,
          VTEXT TYPE TVKTT-VTEXT,
          SPRAS TYPE TVKTT-SPRAS,
        END OF TY_TVKTT,


        BEGIN OF TY_JEST3,
          OBJNR TYPE JEST-OBJNR,
          STAT  TYPE JEST-STAT,
          INACT TYPE JEST-INACT,
        END OF TY_JEST3,

        BEGIN OF TY_TJ30,
          STSMA TYPE TJ30T-STSMA,
          ESTAT TYPE TJ30T-ESTAT,
          TXT04 TYPE TJ30T-TXT04,
        END OF TY_TJ30.

TYPES: BEGIN OF TY_TVFST,
         SPRAS TYPE TVFST-SPRAS,
         FAKSP TYPE TVFST-FAKSP,
         VTEXT TYPE TVFST-VTEXT,
       END OF TY_TVFST.

DATA: BEGIN OF IT_ZHOLD_REASON OCCURS 0,
        ZHOLD_KEY       TYPE ZHOLD_REASON-ZHOLD_KEY,
        ZHOLD_REASON_N1 TYPE ZHOLD_REASON-ZHOLD_REASON_N1,
      END OF IT_ZHOLD_REASON,
      LS_ZHOLD_REASON LIKE LINE OF IT_ZHOLD_REASON.

DATA : IT_TVKTT TYPE TABLE OF TY_TVKTT,
       WA_TVKTT TYPE TY_TVKTT,

       IT_JEST3 TYPE TABLE OF TY_JEST3,
       WA_JEST3 TYPE TY_JEST3,

       IT_TJ30  TYPE TABLE OF TY_TJ30,
       WA_TJ30  TYPE  TY_TJ30.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'


DATA : CERTIF_ZIBR    TYPE CHAR20,
       CERTIF_ZUL     TYPE CHAR20,
       CERTIF_ZSL     TYPE CHAR20,
       CERTIF_ZCE     TYPE CHAR20,
       CERTIF_ZAPI6D  TYPE CHAR20,
       CERTIF_ZAPI60  TYPE CHAR20,
       CERTIF_ZATEX   TYPE CHAR20,
       CERTIF_ZTRCU   TYPE CHAR20,
       CERTIF_ZCRN    TYPE CHAR20,
       CERTIF_ZMARINE TYPE CHAR20.



DATA: IT_VBAK  TYPE TABLE OF TY_VBAK,
      WA_VBAK  TYPE TY_VBAK,
      IT_VBAP  TYPE TABLE OF TY_VBAP,
      WA_VBAP  TYPE TY_VBAP,

      IT_VBAP2 TYPE TABLE OF TY_VBAP2,
      WA_VBAP2 TYPE TY_VBAP2,
*
*      it_zhold_reason TYPE TABLE OF ty_zhold_reason,
*      wa_zhold_reason TYPE ty_zhold_reason,

      IT_VBEP  TYPE TABLE OF TY_VBEP,
      WA_VBEP  TYPE TY_VBEP,
      LT_VBEP  TYPE TABLE OF TY_VBEP,
      LS_VBEP  TYPE TY_VBEP,
      LT_VBPA  TYPE TABLE OF TY_VBPA,
      LS_VBPA  TYPE TY_VBPA,

      IT_VBKD  TYPE TABLE OF TY_VBKD,
      WA_VBKD  TYPE  TY_VBKD,
      IT_T052U TYPE TABLE OF TY_T052U,
      WA_T052U TYPE  TY_T052U,
      IT_MSKA  TYPE TABLE OF TY_MSKA,
      WA_MSKA  TYPE  TY_MSKA,
      IT_KONV  TYPE TABLE OF TY_KONV,
      WA_KONV  TYPE  TY_KONV,
      IT_KONV1 TYPE TABLE OF TY_KONV,
      WA_KONV1 TYPE  TY_KONV,
      IT_VBFA  TYPE TABLE OF TY_VBFA,
      WA_VBFA  TYPE  TY_VBFA,
      IT_VBRK  TYPE TABLE OF TY_VBRK,
      WA_VBRK  TYPE  TY_VBRK,
      IT_VBRP  TYPE TABLE OF TY_VBRP,
      WA_VBRP  TYPE  TY_VBRP,
      IT_KNA1  TYPE TABLE OF TY_KNA1,
      WA_KNA1  TYPE  TY_KNA1,
      IT_VBAP1 TYPE TABLE OF TY_VBAP1,
      WA_VBAP1 TYPE          TY_VBAP1,

      IT_TVFST TYPE STANDARD TABLE OF TY_TVFST,
      WA_TVFST TYPE TY_TVFST.
*****************edited by PJ on 16-08-21******************
TYPES : BEGIN OF TY_MARA,
          MATNR        TYPE MARA-MATNR,
          ITEM_TYPE    TYPE MARA-ITEM_TYPE,
          BOM          TYPE MARA-BOM,
          ZPEN_ITEM    TYPE MARA-ZPEN_ITEM,
          ZRE_PEN_ITEM TYPE MARA-ZRE_PEN_ITEM,
        END OF TY_MARA.

DATA : IT1_MARA TYPE TABLE OF TY_MARA,
       WA1_MARA TYPE TY_MARA.
DATA : TZ TYPE TIMEZONE.
*****************end*****************************

DATA : QUOTE TYPE CHAR01 VALUE '"'.

DATA : LV_VBELN  TYPE CDHDR-OBJECTID,
       LV_VBELN2 TYPE VBAP-VBELN.

DATA: "it_vbak        TYPE STANDARD TABLE OF vbak,
  "wa_vbak        TYPE vbak,
  "it_vbap        TYPE STANDARD TABLE OF vbap,
  "wa_vbap        TYPE vbap,
*      it_vbkd        TYPE STANDARD TABLE OF vbkd,
*      wa_vbkd        TYPE vbkd,
*      it_t052u       TYPE STANDARD TABLE OF t052u,
*      wa_t052u       TYPE t052u,
*      it_kna1        TYPE STANDARD TABLE OF  kna1,
*      wa_kna1        TYPE kna1,
*      it_mska        TYPE STANDARD TABLE OF mska,
*      wa_mska        TYPE mska,
*      it_vbfa        TYPE STANDARD TABLE OF vbfa,
*      wa_vbfa        TYPE vbfa,
  IT_LIPS        TYPE STANDARD TABLE OF LIPS,
  WA_LIPS        TYPE LIPS,
  WA_LFIMG       TYPE LIPS-LFIMG,
  WA_LFIMG_SUM   TYPE LIPS-LFIMG,
*      it_vbrk        TYPE STANDARD TABLE OF vbrk,
*      wa_vbrk        TYPE vbrk,
*      it_vbrp        TYPE STANDARD TABLE OF vbrp,
*      wa_vbrp        TYPE vbrp,
  WA_FKIMG       TYPE LIPS-LFIMG,
  WA_FKIMG_SUM   TYPE LIPS-LFIMG,
*      it_vbep        TYPE STANDARD TABLE OF vbep,
*      wa_vbep        TYPE vbep,
*      lt_vbep        TYPE STANDARD TABLE OF vbep,
*      ls_vbep        TYPE vbep,
*      it_konv        TYPE STANDARD TABLE OF konv,
*      wa_konv        TYPE konv,
*      it_konv1       TYPE STANDARD TABLE OF konv,
*      wa_konv1       TYPE konv,
  IT_KONH        TYPE STANDARD TABLE OF KONH,
  WA_KONH        TYPE KONH,
  IT_KONP        TYPE STANDARD TABLE OF KONP,
  WA_KONP        TYPE KONP,
  IT_JEST        TYPE STANDARD TABLE OF JEST,
  WA_JEST1       TYPE JEST,
  IT_TJ30T       TYPE STANDARD TABLE OF TJ30T,
  WA_TJ30T       TYPE TJ30T,
***      it_a508    TYPE STANDARD TABLE OF a508,
***      wa_a508    TYPE a508,

  IT_CDHDR       TYPE STANDARD TABLE OF CDHDR,
  WA_CDHDR       TYPE CDHDR,

  IT_CDPOS       TYPE STANDARD TABLE OF CDPOS,
  WA_CDPOS       TYPE CDPOS,
  IT_OUTPUT      TYPE STANDARD TABLE OF OUTPUT,
  WA_OUTPUT      TYPE OUTPUT,
  IT_OUTPUT_NEW  TYPE STANDARD TABLE OF OUTPUT_NEW, "ADDED BY JYOTI ON 26.04.2024
  WA_OUTPUT_NEW  TYPE OUTPUT_NEW, "ADDED BY JYOTI ON 26.04.2024
  WA_MBEW        TYPE MBEW,
  WA_MARA        TYPE MARA,
  IT_OAUTO       TYPE STANDARD TABLE OF OUTPUT,
  WA_OAUTO       TYPE OUTPUT,
  IT_MARA        TYPE TABLE OF MARA,
  IT_MAKT        TYPE TABLE OF MAKT,
  WA_MAKT        TYPE MAKT,
*      lt_vbpa        TYPE TABLE OF vbpa,
*      ls_vbpa        TYPE vbpa,
  LT_ADRC        TYPE TABLE OF ADRC,
  LS_ADRC        TYPE ADRC,
  LT_ZGST_REGION TYPE TABLE OF ZGST_REGION,
  LS_ZGST_REGION TYPE ZGST_REGION.


DATA:
  LT_RESB TYPE TT_RESB,
  LS_RESB TYPE T_RESB.
DATA:
   GT_FINAL TYPE TT_FINAL.
DATA: IT_DATA           TYPE STANDARD TABLE OF TY_DATA,
      LS_DATA           TYPE TY_DATA,
      WA_DATA           TYPE TY_DATA,
      WA_DATA2          TYPE TY_DATA,
      LV_LINES          TYPE STANDARD TABLE OF TLINE,
      WA_LINES          LIKE TLINE,
      LS_LINES          LIKE TLINE,
      WA_LN_LD          LIKE TLINE,
      WA_TAG_RQ         LIKE TLINE,
      WA_CUST_PROJ_NAME TYPE TLINE , "ADDED BY JYOTI ON 04.12.2024
      WA_OFM_NO         LIKE TLINE,
      LV_NAME           TYPE THEAD-TDNAME,
      WA_TEXT           TYPE CHAR20,
      WA_TEXT1          TYPE CHAR50.
DATA LS_MATTXT  TYPE TLINE.
DATA LS_ITMTXT  TYPE TLINE.
DATA LS_CTBGI   TYPE TLINE.
*data for bapi to convert currency

DATA: BEGIN OF LS_FR_CURR OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_3.
DATA: END OF LS_FR_CURR.

DATA: BEGIN OF LS_TO_CURR OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_4.
DATA: END OF LS_TO_CURR.

DATA: BEGIN OF LS_EX_RATE OCCURS 0.
        INCLUDE STRUCTURE BAPI1093_0.
DATA: END OF LS_EX_RATE.

DATA: LV_EX_RATE TYPE BAPI1093_0.

DATA: BEGIN OF LS_RETURN OCCURS 0.
        INCLUDE STRUCTURE BAPIRET1.
DATA: END OF LS_RETURN.

LS_FR_CURR-SIGN   = 'I'.
LS_FR_CURR-OPTION = 'EQ'.
*LV_FR_CURR-LOW = 'EQ'.

LS_TO_CURR-SIGN   = 'I'.
LS_TO_CURR-OPTION = 'EQ'.
LS_TO_CURR-LOW = 'INR'.
APPEND LS_TO_CURR .


* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
TYPE-POOLS : SLIS.
DATA: FIELDCATALOG TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
      FIELDLAYOUT  TYPE SLIS_LAYOUT_ALV,

      IT_FCAT      TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT      TYPE LINE OF SLIS_T_FIELDCAT_ALV. " SLIS_T_FIELDCAT_ALV.

DATA: I_SORT             TYPE SLIS_T_SORTINFO_ALV, " SORT
      GT_EVENTS          TYPE SLIS_T_EVENT,        " EVENTS
      I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER,   " TOP-OF-PAGE
      WA_LAYOUT          TYPE  SLIS_LAYOUT_ALV..            " LAYOUT WORKAREA
************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  C_FORMNAME_TOP_OF_PAGE   TYPE SLIS_FORMNAME
                                   VALUE 'TOP_OF_PAGE',
  C_FORMNAME_PF_STATUS_SET TYPE SLIS_FORMNAME
                                 VALUE 'PF_STATUS_SET',
  C_S                      TYPE C VALUE 'S',
  C_H                      TYPE C VALUE 'H'.

INITIALIZATION.

  REFRESH : IT_VBAK, IT_VBAP, IT_VBKD, IT_MSKA,
         IT_VBRP, IT_VBEP, IT_KONV,IT_VBAP1.

  CLEAR  : WA_VBAK, WA_VBAP, WA_VBKD, WA_MSKA,
           WA_VBRP, WA_VBEP, WA_KONV,WA_VBAP1.


  """""""""""""""""""""""""""""""""""""" NC """"""""""""""""""""""""""""""""""""""""""""
