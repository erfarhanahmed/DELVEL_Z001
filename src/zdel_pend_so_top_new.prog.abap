*&---------------------------------------------------------------------*
*&  Include           ZSD_PEND_SO_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSD_PENDING_SO_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_data,
          vbeln TYPE vbeln,
          posnr TYPE posnr,
          matnr TYPE matnr,    "edited by PJ 16-08-21
          lgort TYPE vbap-lgort,     "Added by Pranit 10.06.2024
          lfsta TYPE vbap-lfsta,
          lfgsa TYPE vbap-lfgsa,
*          FKSTA TYPE VBUP-FKSTA,
          absta TYPE vbap-absta,
          gbsta TYPE vbap-gbsta,
*         WERKS TYPE WERKS,
        END OF ty_data.

TYPES : BEGIN OF ty_cdhdr,
          objectclas TYPE cdhdr-objectclas,
          objectid   TYPE cdhdr-objectid,
          udate      TYPE cdhdr-udate,
          tcode      TYPE cdhdr-tcode,
        END OF ty_cdhdr.
TYPES : BEGIN OF output,
          werks           TYPE werks_ext,
          auart           TYPE vbak-auart,
          bstkd           TYPE vbkd-bstkd,
          name1           TYPE kna1-name1,
          vkbur           TYPE vbak-vkbur,
          vbeln           TYPE vbak-vbeln,
          erdat           TYPE vbak-erdat,
          vdatu           TYPE vbak-vdatu,
          status          TYPE text30,
          holddate        TYPE vbap-holddate,
          reldate         TYPE vbap-holdreldate,
          canceldate      TYPE vbap-canceldate,
          deldate         TYPE vbap-deldate,
*          tag_req      TYPE char20,
          tag_req         TYPE char50,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          tpi             TYPE char50,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          ld_txt          TYPE char50,           "changed by sr on 03.05.2021
          zldperweek      TYPE zldperweek1,
          zldmax          TYPE vbak-zldmax,
          zldfromdate     TYPE vbak-zldfromdate,

********
          matnr           TYPE vbap-matnr,
          posnr           TYPE vbap-posnr,
          arktx           TYPE vbap-arktx,
          kwmeng          TYPE vbap-kwmeng,
          stock_qty       TYPE mska-kalab,
*          kalab       TYPE mska-kalab,
          lfimg           TYPE lips-lfimg,
          fkimg           TYPE vbrp-fkimg,
          pnd_qty         LIKE vbrp-fkimg,
          ettyp           TYPE vbep-ettyp,
          mrp_dt          TYPE udate,
          edatu           TYPE vbep-edatu,
          kbetr           TYPE prcd_elements-kbetr, "KONV-KBETR,
          waerk           TYPE vbap-waerk,
          curr_con        TYPE ukursp,
          so_exc          TYPE ukursp,
          amont           TYPE char15,             "kbetr,
          ordr_amt        TYPE char15,             "kbetr,
*          KURSK         TYPE VBKD-KURSK,
          in_price        TYPE prcd_elements-kbetr,
          in_pr_dt        TYPE prcd_elements-kdatu,
          est_cost        TYPE prcd_elements-kbetr,
          latst_cost      TYPE prcd_elements-kbetr,
          st_cost         TYPE mbew-stprs,
          zseries         TYPE mara-zseries,
          zsize           TYPE mara-zsize,
          brand           TYPE mara-brand,
          moc             TYPE mara-moc,
          type            TYPE mara-type,

          """"""""   Added By KD 04.05.2017    """""""
          dispo           TYPE marc-dispo,
          wip             TYPE vbrp-fkimg,
          mtart           TYPE mara-mtart,
          kdmat           TYPE vbap-kdmat,
          kunnr           TYPE kna1-kunnr,
          qmqty           TYPE mska-kains,
          mattxt          TYPE text100,
          itmtxt          TYPE char255,
          etenr           TYPE vbep-etenr,
          schid           TYPE string,
          zterm           TYPE vbkd-zterm,
          text1           TYPE t052u-text1,
          inco1           TYPE vbkd-inco1,
          inco2           TYPE vbkd-inco2,
          ofm             TYPE char50,
          ofm_date        TYPE char50,
*          spl           type char255,
          custdeldate     TYPE vbap-custdeldate,
          ref_dt          TYPE sy-datum,

          """"""""""""""""""""""""""""""""""""""""""""
          abgru           TYPE  vbap-abgru,            " avinash bhagat 20.12.2018
          bezei           TYPE  tvagt-bezei,         " avinash bhagat 20.12.2018
          wrkst           TYPE  mara-wrkst,
          cgst(4)         TYPE  c,
*          cgst_val(15) TYPE  c,
          sgst(4)         TYPE  c,
*          sgst_val(15) TYPE  c,
          igst(4)         TYPE  c,
*          igst_val(15) TYPE  c,
          ship_kunnr      TYPE kunnr,            "ship to party code
          ship_kunnr_n    TYPE ad_name1,         "ship to party desctiption
          ship_reg_n      TYPE bezei,            ""ship to party gst region description
          sold_reg_n      TYPE bezei,             "sold to party gst region description
          normt           TYPE mara-normt,
          ship_land       TYPE vbpa-land1,
          s_land_desc     TYPE t005t-landx50,
          sold_land       TYPE vbpa-land1,
          posex           TYPE vbap-posex,
          bstdk           TYPE vbak-bstdk,
          lifsk           TYPE vbak-lifsk,
          vtext           TYPE tvlst-vtext,
          insur           TYPE char250,
          pardel          TYPE char250,
          gad             TYPE char50,
          us_cust         TYPE char250,
          tcs(11)         TYPE p DECIMALS 3,
          tcs_amt         TYPE konv-kwert,
          spl             TYPE char255,
          po_del_date     TYPE vbap-custdeldate,
          ofm_no          TYPE char128,
          ctbg            TYPE char10,            "added by sr on 03.05.2021 ctbgi details
          certif          TYPE char255,             "added by sr on 03.05.2021 certification details
*          knumv        type konv-knumv,             " added by pankaj 28.01.2022

*          ctbg         TYPE char10,                     " added by ajay

          item_type       TYPE mara-item_type, " edited by PJ on 16-08-21
          ref_time        TYPE char10,          " edited by PJ on 08-09-21
          proj            TYPE char255,                         "added by pankaj 28.01.2022
          cond            TYPE char255,                       "added by pankaj 28.01.2022
          receipt_date    TYPE vbap-receipt_date,          "added by pankaj 28.01.2022
          reason          TYPE char30,                "added by pankaj 28.01.2022
          ntgew           TYPE vbap-ntgew,          "added by pankaj 28.01.2022
          zpr0            TYPE kwert,              "added by pankaj 28.01.2022
          zpf0            TYPE kwert,              "added by pankaj 28.01.2022
          zin1            TYPE kwert,              "added by pankaj 28.01.2022
          zin2            TYPE kwert,             "added by pankaj 28.01.2022
          joig            TYPE kwert,              "added by pankaj 28.01.2022
          jocg            TYPE kwert,              "added by pankaj 28.01.2022
          josg            TYPE kwert,                "added by pankaj 28.01.2022
*          DIS_RATE        TYPE KBETR,
          dis_rate        TYPE p DECIMALS 2,
          dis_amt         TYPE prcd_elements-kwert,        "Discount
          dis_unit_rate   TYPE prcd_elements-kwert,
          tot_ass         TYPE prcd_elements-kbetr,        "Discount
          ass2_val        TYPE prcd_elements-kwert,
          date            TYPE vbep-edatu,
          prsdt           TYPE vbkd-prsdt,
          packing_type    TYPE char255,
          ofm_date1       TYPE char12,  "vbap-ofm_date,
          mat_text        TYPE char15,
          infra           TYPE char255,         "added by pankaj 31.01.2022
          validation      TYPE char255,         "added by pankaj 31.01.2022
          review_date     TYPE char255,         "added by pankaj 31.01.2022   b
          diss_summary    TYPE char255,        "added by pankaj 31.01.2022
          chang_so_date   TYPE vbap-erdat,

          """""""" added by pankaj 04.02.2022
          port            TYPE adrc-name1,
          full_pmnt       TYPE char255,
          act_ass         TYPE tvktt-vtext,
          txt04           TYPE tj30t-txt04,
*          kwert         type konv-kwert,
          freight         TYPE char128,
          po_sr_no        TYPE char128,

          udate           TYPE char15,            "cdhdr-udate,
          bom             TYPE mara-bom,
          zpen_item       TYPE mara-zpen_item,
          zre_pen_item    TYPE mara-zre_pen_item,
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
          zins_loc        TYPE vbap-zins_loc,
          bom_exist       TYPE char5,
*          BSTKD1        TYPE VBKD-BSTKD,"ADDED BY JYOTI ON 16.04.2024
          posex1          TYPE vbap-posex, "ADDED BY JYOTI ON 16.04.2024
          lgort           TYPE vbap-lgort, ""Added by Pranit 10.06.2024
          quota_ref       TYPE char128, "added by jyoti on19.06.2024
          zmrp_date       TYPE vbap-zmrp_date, "added by jyoti on 02.07.2024

****************************************************************************
          vkorg           TYPE vbak-vkorg ,    " ADDED BY SUPRIYA ON 19.08.2024
          vtweg           TYPE vbak-vtweg ,  " ADDED BY SUPRIYA ON 19.08.2024
          spart           TYPE vbak-spart,     " ADDED BY SUPRIYA ON 19.08.2024
          zexp_mrp_date1  TYPE vbap-zexp_mrp_date1, "added by jyoti on 13.11.2024
          special_comm    TYPE char250,
          zcust_proj_name TYPE char250, "added by jyoti on 04.12.2024
          amendment_his   TYPE char250, "added by jyoti on 20.01.2025
          po_dis          TYPE char250, "added by jyoti on 20.01.2025
          hold_reason_n1  TYPE vbap-zhold_reason_n1 , "added by jyoti on 06.02.2025
        END OF output.

""""""""""    Added By KD 04.05.2017        """""""""""4
***********************added by jyoti on 26.04.2024*************************************
TYPES : BEGIN OF output_new,
          werks           TYPE werks_ext,
          auart           TYPE vbak-auart,
          bstkd           TYPE vbkd-bstkd,
          name1           TYPE kna1-name1,
          vkbur           TYPE vbak-vkbur,
          vbeln           TYPE vbak-vbeln,
          erdat           TYPE char11, "vbak-erdat,
          vdatu           TYPE char11, "vbak-vdatu,
          status          TYPE text30,
          holddate        TYPE char11, "vbap-holddate,
          reldate         TYPE char11, "vbap-holdreldate,
          canceldate      TYPE char11, "vbap-canceldate,
          deldate         TYPE char11, "vbap-deldate,
*          tag_req      TYPE char20,
          tag_req         TYPE char50,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          tpi             TYPE char50,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          ld_txt          TYPE char50,           "changed by sr on 03.05.2021
          zldperweek      TYPE zldperweek1,
          zldmax          TYPE vbak-zldmax,
          zldfromdate     TYPE char11, "vbak-zldfromdate,

********
          matnr           TYPE vbap-matnr,
          posnr           TYPE vbap-posnr,
          arktx           TYPE vbap-arktx,
          kwmeng          TYPE char15, "vbap-kwmeng,
          stock_qty       TYPE char15, "mska-kalab,
*          kalab       TYPE mska-kalab,
          lfimg           TYPE char15, "lips-lfimg,
          fkimg           TYPE char15, "vbrp-fkimg,
          pnd_qty         TYPE char15, "vbrp-fkimg,
          ettyp           TYPE vbep-ettyp,
          mrp_dt          TYPE char11, "udate,
          edatu           TYPE char11, "vbep-edatu,
          kbetr           TYPE char256, "prcd_elements-kbetr," CHAR15, "konv-kbetr,
          waerk           TYPE vbap-waerk,
          curr_con        TYPE ukursp,
          amont           TYPE char15,             "kbetr,
          ordr_amt        TYPE char15,             "kbetr,
          in_price        TYPE char36  ,  "CHAR15, "konv-kbetr,
          in_pr_dt        TYPE prcd_elements-kdatu  ,  "CHAR11, "konv-kdatu,
          est_cost        TYPE char36  ,  "CHAR15, "konv-kbetr,
          latst_cost      TYPE char36 , "PRCD_ELEMENTS-KBETR  ,  "CHAR15, "konv-kbetr,
          st_cost         TYPE char15, "mbew-stprs,
          zseries         TYPE mara-zseries,
          zsize           TYPE mara-zsize,
          brand           TYPE mara-brand,
          moc             TYPE mara-moc,
          type            TYPE mara-type,

          """"""""   Added By KD 04.05.2017    """""""
          dispo           TYPE marc-dispo,
          wip             TYPE char15, "vbrp-fkimg,
          mtart           TYPE mara-mtart,
          kdmat           TYPE vbap-kdmat,
          kunnr           TYPE kna1-kunnr,
          qmqty           TYPE char15, "mska-kains,
          mattxt          TYPE text100,
          itmtxt          TYPE char255,
          etenr           TYPE vbep-etenr,
          schid           TYPE      string,
          so_exc          TYPE ukursp,
          zterm           TYPE vbkd-zterm,
          text1           TYPE char50, "t052u-text1,
          inco1           TYPE vbkd-inco1,
          inco2           TYPE char13, "vbkd-inco2,
          ofm             TYPE char50,
          ofm_date        TYPE char50,
          custdeldate     TYPE char11, "vbap-custdeldate,
          ref_dt          TYPE char11, "sy-datum,

          """"""""""""""""""""""""""""""""""""""""""""
          abgru           TYPE  vbap-abgru,            " avinash bhagat 20.12.2018
          bezei           TYPE  tvagt-bezei,         " avinash bhagat 20.12.2018
          wrkst           TYPE  mara-wrkst,
          cgst(4)         TYPE  c,
          sgst(4)         TYPE  c,
          igst(4)         TYPE  c,
          ship_kunnr      TYPE kunnr,            "ship to party code
          ship_kunnr_n    TYPE ad_name1,         "ship to party desctiption
          ship_reg_n      TYPE bezei,            ""ship to party gst region description
          sold_reg_n      TYPE bezei,             "sold to party gst region description
          normt           TYPE mara-normt,
          ship_land       TYPE vbpa-land1,
          sold_land       TYPE vbpa-land1,
          posex           TYPE vbap-posex,
          s_land_desc     TYPE char50, "t005t-landx50,
          bstdk           TYPE char11, "vbak-bstdk,
          lifsk           TYPE char10, "vbak-lifsk,
          vtext           TYPE char20, "tvlst-vtext,
          insur           TYPE char250,
          pardel          TYPE char250,
          gad             TYPE char50,
          us_cust         TYPE char250,
          tcs             TYPE char15, "p DECIMALS 3,
          tcs_amt         TYPE char15, "konv-kwert,
          spl             TYPE char255,
          po_del_date     TYPE char11, ",vbap-custdeldate,
          ofm_no          TYPE char128,
          ctbg            TYPE char10,            "added by sr on 03.05.2021 ctbgi details
          certif          TYPE char255,             "added by sr on 03.05.2021 certification details
          item_type       TYPE mara-item_type, " edited by PJ on 16-08-21
          ref_time        TYPE char10,          " edited by PJ on 08-09-21
          proj            TYPE char255,                         "added by pankaj 28.01.2022
          cond            TYPE char255,                       "added by pankaj 28.01.2022
          receipt_date    TYPE char20, "vbap-receipt_date,          "added by pankaj 28.01.2022
          reason          TYPE char30,                "added by pankaj 28.01.2022
          ntgew           TYPE char25, "vbap-ntgew,          "added by pankaj 28.01.2022
          zpr0            TYPE char15, ""kwert,              "added by pankaj 28.01.2022
          zpf0            TYPE char15, "kwert,              "added by pankaj 28.01.2022
          zin1            TYPE char15, "kwert,              "added by pankaj 28.01.2022
          zin2            TYPE char15, "kwert,             "added by pankaj 28.01.2022
          joig            TYPE char15, "kwert,              "added by pankaj 28.01.2022
          jocg            TYPE char15, "kwert,              "added by pankaj 28.01.2022
          josg            TYPE char15, "kwert,                "added by pankaj 28.01.2022
          date            TYPE char15, "vbep-edatu,
          prsdt           TYPE char15, "vbkd-prsdt,
          packing_type    TYPE char15,
          ofm_date1       TYPE char50,  "vbap-ofm_date,
          mat_text        TYPE char15,
          infra           TYPE char255,         "added by pankaj 31.01.2022
          validation      TYPE char255,         "added by pankaj 31.01.2022
          review_date     TYPE char255,         "added by pankaj 31.01.2022   b
          diss_summary    TYPE char255,        "added by pankaj 31.01.2022
          chang_so_date   TYPE char255, "vbap-erdat,
          """""""" added by pankaj 04.02.2022
          port            TYPE adrc-name1,
          full_pmnt       TYPE char255,
          act_ass         TYPE char255, "tvktt-vtext,
          txt04           TYPE char255, "tj30t-txt04,
          freight         TYPE char128,
          po_sr_no        TYPE char128,
          udate           TYPE char11,            "cdhdr-udate,
          bom             TYPE mara-bom,
          zpen_item       TYPE mara-zpen_item,
          zre_pen_item    TYPE mara-zre_pen_item,
          zins_loc        TYPE vbap-zins_loc,
          bom_exist       TYPE char5,
          posex1          TYPE vbap-posex, "adde by jyoti on 16.04.2024
          lgort           TYPE vbap-lgort, "added by Pranit on 20.06.2024
          quota_ref       TYPE char128 , "added by jyoti on19.06.2024
          zmrp_date       TYPE char11, "ADDED BY JYOTI OM 02.07.2024
***************************************************************************
          vkorg           TYPE vbak-vkorg ,    " ADDED BY SUPRIYA ON 19.08.2024
          vtweg           TYPE vbak-vtweg ,  " ADDED BY SUPRIYA ON 19.08.2024
          spart           TYPE vbak-spart,     " ADDED BY SUPRIYA ON 19.08.2024
*************************************************************************
          zexp_mrp_date1  TYPE char11, "added by jyoti on 13.11.2024
          special_comm    TYPE string,
          zcust_proj_name TYPE string, "added by jyoti on 04.12.2024
          amendment_his   TYPE char250, "added by jyoti on 20.01.2025
          po_dis          TYPE char250, "added by jyoti on 20.01.2025
          hold_reason_n1  TYPE string , "added by jyoti on 06.02.2025
        END OF output_new.


DATA : gv_kbetr2 TYPE prcd_elements-kbetr.
DATA : gv_kbetr3 TYPE prcd_elements-kbetr.
DATA : gv_kbetr TYPE prcd_elements-kbetr.
DATA : gv_kwert TYPE prcd_elements-kwert.
DATA : gv_kwert2 TYPE prcd_elements-kwert.


TYPES : BEGIN OF ty_tvagt,
          spras TYPE  tvagt-spras,
          abgru TYPE  tvagt-abgru,
          bezei TYPE  tvagt-bezei,
        END OF ty_tvagt.

DATA : it_tvagt TYPE STANDARD TABLE OF ty_tvagt,
       wa_tvagt TYPE ty_tvagt.
DATA : lv_cgst      TYPE kbetr,
       lv_cgst_temp TYPE string.

TYPES : BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          posnr TYPE afpo-posnr,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
          matnr TYPE afpo-matnr,
          pgmng TYPE afpo-pgmng,
          psmng TYPE afpo-psmng,
          wemng TYPE afpo-wemng,
        END OF ty_afpo.

TYPES : BEGIN OF ty_caufv,
          aufnr TYPE caufv-aufnr,
          objnr TYPE caufv-objnr,
          kdauf TYPE caufv-kdauf,
          kdpos TYPE caufv-kdpos,
          igmng TYPE caufv-igmng,
        END OF ty_caufv .

TYPES : BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
        END OF ty_jest.

TYPES : BEGIN OF ty_tj02t,
          istat TYPE tj02t-istat,
          txt04 TYPE tj02t-txt04,
        END OF ty_tj02t.

TYPES : BEGIN OF ty_mast,
          matnr TYPE mast-matnr,
          werks TYPE mast-werks,
          stlan TYPE mast-stlan,
          stlnr TYPE mast-stlnr,
          stlal TYPE mast-stlal,
        END OF ty_mast.

TYPES : BEGIN OF ty_stko,
          stlty TYPE stko-stlty,
          stlnr TYPE stko-stlnr,
          stlal TYPE stko-stlal,
          stkoz TYPE stko-stkoz,
        END OF ty_stko.

TYPES : BEGIN OF ty_stpo,
          stlty TYPE stpo-stlty,
          stlnr TYPE stpo-stlnr,
          stlkn TYPE stpo-stlkn,
          stpoz TYPE stpo-stpoz,
          idnrk TYPE stpo-idnrk,
        END OF ty_stpo.

TYPES:
  BEGIN OF t_resb,
    rsnum TYPE resb-rsnum,
    rspos TYPE resb-rspos,
    rsart TYPE resb-rsart,
    bdmng TYPE resb-bdmng,
    enmng TYPE resb-enmng,
    aufnr TYPE resb-aufnr,
    kdauf TYPE resb-kdauf,
    kdpos TYPE resb-kdpos,
  END OF t_resb,
  tt_resb TYPE STANDARD TABLE OF t_resb.


TYPES:
  BEGIN OF t_final    ,
    werks             TYPE werks_ext,
    auart             TYPE vbak-auart,
    bstkd             TYPE vbkd-bstkd,
    name1             TYPE kna1-name1,
    vkbur             TYPE vbak-vkbur,
    vbeln             TYPE vbak-vbeln,
    erdat             TYPE char11, "vbak-erdat,
    vdatu             TYPE char11, "vbak-vdatu,
    status            TYPE text30,
    holddate          TYPE char11, "vbap-holddate,
    reldate           TYPE char11, "vbap-holdreldate,
    canceldate        TYPE char11, "vbap-canceldate,
    deldate           TYPE char11, "vbap-deldate,
*    tag_req      TYPE char20,
    tag_req           TYPE char50,
*         ld 5 fields
*    tpi          TYPE char20,
    tpi               TYPE char50,           "changed by sr on 03.05.2021
*    ld_txt       TYPE char20,
    ld_txt            TYPE char50,           "changed by sr on 03.05.2021
    zldperweek        TYPE zldperweek1,
    zldmax            TYPE vbak-zldmax,
    zldfromdate       TYPE char11, "vbak-zldfromdate,

********
    matnr             TYPE vbap-matnr,
    posnr             TYPE vbap-posnr,
    arktx             TYPE vbap-arktx,
    kwmeng            TYPE char256, "vbap-kwmeng,
    kalab             TYPE char256, "mska-kalab,
*    stock_qty   TYPE mska-kalab,
    lfimg             TYPE char15, "lips-lfimg,
    fkimg             TYPE char15, "vbrp-fkimg,
    pnd_qty           TYPE char15, "vbrp-fkimg,
    ettyp             TYPE vbep-ettyp,
    mrp_dt            TYPE char11, "udate,
    edatu             TYPE char11, "vbep-edatu,
*    kbetr           TYPE char15, "konv-kbetr,
    kbetr             TYPE char256 , "prcd_elements-kbetr  , "konv-kbetr,
    waerk             TYPE vbap-waerk,
    curr_con          TYPE ukursp,
    amont             TYPE char256, "kbetr,
    ordr_amt          TYPE char256, "kbetr,
*          KURSK         TYPE VBKD-KURSK,
    in_price          TYPE char256, "konv-kbetr,
    in_pr_dt          TYPE char256, "konv-kdatu,
    est_cost          TYPE char256, "konv-kbetr,
    latst_cost        TYPE char256, "konv-kbetr,
    st_cost           TYPE char256, "mbew-stprs,
    zseries           TYPE mara-zseries,
    zsize             TYPE mara-zsize,
    brand             TYPE mara-brand,
    moc               TYPE mara-moc,
    type              TYPE mara-type,

    """"""""   Added By KD 04.05.2017    """""""
    dispo             TYPE marc-dispo,
    wip               TYPE char15,
    mtart             TYPE mara-mtart,
    kdmat             TYPE vbap-kdmat,
    kunnr             TYPE kna1-kunnr,
    qmqty             TYPE char15, "mska-kains,
    mattxt            TYPE char100,
    itmtxt            TYPE char255,
    etenr             TYPE vbep-etenr,
    schid             TYPE string,    "add by supriya on 2024.08.20
    so_exc            TYPE ukursp,
    zterm             TYPE vbkd-zterm,
    text1             TYPE char50,
    inco1             TYPE vbkd-inco1,
    inco2             TYPE char30,
    ofm               TYPE char50,
    ofm_date          TYPE char50,
    custdeldate       TYPE char11, "vbap-deldate,
    ref_dt            TYPE char11,
    abgru             TYPE  vbap-abgru,
    bezei             TYPE  tvagt-bezei,
    wrkst             TYPE mara-wrkst,
    cgst(4)           TYPE c, "konv-kbetr,
*    cgst_val(15) TYPE c, " konv-kwert,
    sgst(4)           TYPE  c, "konv-kbetr,
*    sgst_val(15) TYPE c, " konv-kwert,
    igst(4)           TYPE  c, "konv-kbetr,
*    igst_val(15) TYPE  c, "konv-kwert,
    ship_kunnr        TYPE kunnr,            "ship to party code
    ship_kunnr_n      TYPE ad_name1,         "ship to party desctiption
    ship_reg_n        TYPE bezei,            ""ship to party gst region
    sold_reg_n        TYPE bezei,             "ship to party gst region description
    normt             TYPE mara-normt,
    sold_land         TYPE vbpa-land1,
    ship_land         TYPE vbpa-land1,
    posex             TYPE vbap-posex,
    s_land_desc       TYPE char50,
    bstdk             TYPE char11,
    lifsk             TYPE char10,
    vtext             TYPE char20,
    insur             TYPE char250,
    pardel            TYPE char250,
    gad               TYPE char50,
    us_cust           TYPE char250,
    tcs               TYPE char256,
    tcs_amt           TYPE char256,
    spl               TYPE char256,
    po_del_date       TYPE char11,
    ofm_no            TYPE char128,
    ctbg              TYPE char10,            "added by sr on 03.05.2021
    certif            TYPE char255,             "added by sr on 03.05.2021 certification details
*    ctbg         TYPE char10,                "ADDED BY AJAY  11052021
    item_type         TYPE mara-item_type,  "edited by PJ on 16-08-21
    ref_time          TYPE char10,  "edited by PJ on 08-09-21

    proj              TYPE char255,                         "added by pankaj 28.01.2022
    cond              TYPE char255,                       "added by pankaj 28.01.2022
    receipt_date      TYPE char20,              "vbap-receipt_date,          "added by pankaj 28.01.2022
    reason            TYPE char30,                "added by pankaj 28.01.2022
    ntgew             TYPE char25,             "added by pankaj 28.01.2022
    zpr0              TYPE char255,             "added by pankaj 28.01.2022
    zpf0              TYPE char255,              "added by pankaj 28.01.2022
    zin1              TYPE char255,               "added by pankaj 28.01.2022
    zin2              TYPE char255,                 "added by pankaj 28.01.2022
    joig              TYPE char255,                 "added by pankaj 28.01.2022
    jocg              TYPE char255,                 "added by pankaj 28.01.2022
    josg              TYPE char255,
    date              TYPE char15,
    prsdt             TYPE char15,
    packing_type      TYPE char15,
    ofm_date1         TYPE char50,
    mat_text          TYPE char15,
    infra             TYPE char255,         "added by pankaj 31.01.2022
    validation        TYPE char255,         "added by pankaj 31.01.2022
    review_date       TYPE char255,         "added by pankaj 31.01.2022
    diss_summary      TYPE char255,        "added by pankaj 31.01.2022
    chang_so_date     TYPE char255,
    """""" added by pankaj 04.02.2022
    port              TYPE adrc-name1,          "added by pankaj 02.02.2022
    full_pmnt         TYPE char255,             "added by pankaj 02.02.2022
    act_ass           TYPE char255,  "tvktt-vtext,         "added by pankaj 02.02.2022
    txt04             TYPE char255,
    freight           TYPE char128,
    po_sr_no          TYPE char128,
    udate             TYPE char11,
    bom               TYPE mara-bom,
    zpen_item         TYPE mara-zpen_item,
    zre_pen_item      TYPE mara-zre_pen_item,
*    faksk         type vbak-faksk,
*    vtext1        type tvfst-vtext,
    zins_loc          TYPE vbap-zins_loc,
    bom_exist         TYPE char5,
*    BSTKD1        TYPE VBKD-BSTKD,"ADDED BY JYOTI ON 16.04.2024
    posex1            TYPE vbap-posex, "ADDED BY JYOTI ON 16.04.2024
    lgort             TYPE vbap-lgort, "ADDED BY Pranit ON 10.06.2024
    quota_ref         TYPE char128 , "added by jyoti on19.06.2024
    zmrp_date         TYPE char11, "ADDED BY JYOTI ON 02.07.2024
    vkorg             TYPE char15,
    vtweg             TYPE char15,
    spart             TYPE char15,
    zexp_mrp_date1    TYPE char11, "ADDED BY JYOTI ON 13.11.2024
    special_comm      TYPE string,
    zcust_proj_name   TYPE string, "added by jyoti on 04.12.2024
    amendment_his     TYPE string,
    po_dis            TYPE string,
    hold_reason_n1    TYPE string , "added by jyoti on 06.02.2025
    stock_qty_ktpi    TYPE string,  "added by jyoti on 28.03.2025
    stock_qty_tpi1    TYPE string,  "added by jyoti on 28.03.2025
    ofm_received_date TYPE string, "added by jyoti on 07.04.2025
    oss_received_cell TYPE string, "added by jyoti on 07.04.2025
    source_rest       TYPE char255,
    suppl_rest        TYPE char255,
    cust_mat_desc     TYPE char255,
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.


DATA : it_afpo  TYPE TABLE OF ty_afpo,
       wa_afpo  TYPE ty_afpo,
       it_caufv TYPE TABLE OF ty_caufv,
       wa_caufv TYPE ty_caufv,
       it_jest2 TYPE TABLE OF ty_jest,
       wa_jest2 TYPE ty_jest,
       it_tj02t TYPE TABLE OF ty_tj02t,
       wa_tj02t TYPE ty_tj02t,
       it_mast  TYPE TABLE OF mast,
       wa_mast  TYPE mast,
       it_stko  TYPE TABLE OF ty_stko,
       wa_stko  TYPE ty_stko,
       it_stpo  TYPE TABLE OF ty_stpo,
       wa_stpo  TYPE ty_stpo.

"""""""""""""""    end   04.05.2017  """""""""""""""""""""""""""""
TYPES : BEGIN OF ty_vbak,
          vbeln       TYPE vbak-vbeln,
          erdat       TYPE vbak-erdat,
          auart       TYPE vbak-auart,
          lifsk       TYPE vbak-lifsk,
          waerk       TYPE vbak-waerk,
          vkbur       TYPE vbak-vkbur,
          knumv       TYPE vbak-knumv,
          vdatu       TYPE vbak-vdatu,
          bstdk       TYPE vbak-bstdk,
          kunnr       TYPE vbak-kunnr,
          objnr       TYPE vbak-objnr,            "added by pankaj 04.02.2022
          zldfromdate TYPE vbak-zldfromdate,
          zldperweek  TYPE vbak-zldperweek,
          zldmax      TYPE vbak-zldmax,
          faksk       TYPE vbak-faksk,
**********************************************************
          vkorg       TYPE vbak-vkorg ,    " ADDED BY SUPRIYA ON 19.08.2024
          vtweg       TYPE vbak-vtweg ,    " ADDED BY SUPRIYA ON 19.08.2024
          spart       TYPE vbak-spart,     " ADDED BY SUPRIYA ON 19.08.2024
************************************************************
        END OF ty_vbak,

        BEGIN OF ty_vbap,
          vbeln           TYPE vbap-vbeln,
          posnr           TYPE vbap-posnr,
          matnr           TYPE vbap-matnr,
          arktx           TYPE vbap-arktx,
          abgru           TYPE vbap-abgru,
          posex           TYPE vbap-posex,
          kdmat           TYPE vbap-kdmat,
          waerk           TYPE vbap-waerk,
          kwmeng          TYPE vbap-kwmeng,
          werks           TYPE vbap-werks,
          ntgew           TYPE vbap-ntgew,          "added by pankaj 28.01.2022
          objnr           TYPE vbap-objnr,
          holddate        TYPE vbap-holddate,
          holdreldate     TYPE vbap-holdreldate,
          canceldate      TYPE vbap-canceldate,
          deldate         TYPE vbap-deldate,
          custdeldate     TYPE vbap-custdeldate,
          zgad            TYPE vbap-zgad,
          ctbg            TYPE vbap-ctbg,  " ADDED BY AJAY
          receipt_date    TYPE vbap-receipt_date,          "added by pankaj 28.01.2022
          reason          TYPE vbap-reason,                "added by pankaj 28.01.2022
          ofm_date        TYPE vbap-ofm_date,                "added by pankaj 01.02.2022
          erdat           TYPE vbap-erdat,
          zins_loc        TYPE vbap-zins_loc,
          lgort           TYPE vbap-lgort,     ""Added by Pranit 10.04.2024
          zmrp_date       TYPE vbap-zmrp_date, "ADDED BY JYOTI ON 02.07.2024
          zexp_mrp_date1  TYPE vbap-zexp_mrp_date1, "ADDED BY JYOTI ON 02.07.2024
          zhold_reason_n1 TYPE vbap-zhold_reason_n1, "ADDED BY JYOTI ON 06.02.2025
          aedat           TYPE vbap-aedat,
          item_type       TYPE mara-item_type,
          bom             TYPE mara-bom,
          zpen_item       TYPE mara-zpen_item,
          zre_pen_item    TYPE mara-zre_pen_item,
          zseries         TYPE mara-zseries,
          zsize           TYPE mara-zsize,
          brand           TYPE mara-brand,
          moc             TYPE mara-moc,
          type            TYPE mara-type,
          mtart           TYPE mara-mtart,
          wrkst           TYPE mara-wrkst,

          etenr           TYPE vbep-etenr,
          ettyp           TYPE vbep-ettyp,
          edatu           TYPE vbep-edatu,
        END OF ty_vbap,

        BEGIN OF ty_vbap2,
*          vbeln        TYPE vbap-vbeln,
          vbeln        TYPE cdhdr-objectid,
          posnr        TYPE vbap-posnr,
          matnr        TYPE vbap-matnr,
          arktx        TYPE vbap-arktx,
          abgru        TYPE vbap-abgru,
          posex        TYPE vbap-posex,
          kdmat        TYPE vbap-kdmat,
          waerk        TYPE vbap-waerk,
          kwmeng       TYPE vbap-kwmeng,
          werks        TYPE vbap-werks,
          ntgew        TYPE vbap-ntgew,          "added by pankaj 28.01.2022
          objnr        TYPE vbap-objnr,
          holddate     TYPE vbap-holddate,
          holdreldate  TYPE vbap-holdreldate,
          canceldate   TYPE vbap-canceldate,
          deldate      TYPE vbap-deldate,
          custdeldate  TYPE vbap-custdeldate,
          zgad         TYPE vbap-zgad,
          ctbg         TYPE vbap-ctbg,  " ADDED BY AJAY
          receipt_date TYPE vbap-receipt_date,          "added by pankaj 28.01.2022
          reason       TYPE vbap-reason,                "added by pankaj 28.01.2022
          ofm_date     TYPE vbap-ofm_date,                "added by pankaj 01.02.2022
          erdat        TYPE vbap-erdat,
        END OF ty_vbap2,

        BEGIN OF ty_vbep,
          vbeln TYPE vbep-vbeln,
          posnr TYPE vbep-posnr,
          etenr TYPE vbep-etenr,
          ettyp TYPE vbep-ettyp,
          edatu TYPE vbep-edatu,
        END OF ty_vbep,

        BEGIN OF ty_vbpa,
          vbeln TYPE vbpa-vbeln,
          posnr TYPE vbpa-posnr,
          parvw TYPE vbpa-parvw,
          kunnr TYPE vbpa-kunnr,
          adrnr TYPE vbpa-adrnr,
          land1 TYPE vbpa-land1,
        END OF ty_vbpa,

        BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          posnr TYPE vbkd-posnr, "added by jyoti on 16.04.2024
          inco1 TYPE vbkd-inco1,
          inco2 TYPE vbkd-inco2,
          zterm TYPE vbkd-zterm,
          ktgrd TYPE vbkd-ktgrd,                  "added by pankaj 04.02.2022
          kursk TYPE vbkd-kursk,
          bstkd TYPE vbkd-bstkd,
          prsdt TYPE vbkd-prsdt,

        END OF ty_vbkd,

        BEGIN OF ty_t052u,
          spras TYPE t052u-spras,
          zterm TYPE t052u-zterm,
          text1 TYPE t052u-text1,
        END OF ty_t052u,

        BEGIN OF ty_mska,
          matnr TYPE mska-matnr,
          werks TYPE mska-werks,
          lgort TYPE mska-lgort,
          vbeln TYPE mska-vbeln,
          posnr TYPE mska-posnr,
          kalab TYPE mska-kalab,
          kains TYPE mska-kains,
        END OF ty_mska,

        BEGIN OF ty_konv,
          knumv TYPE  prcd_elements-knumv,
          kposn TYPE  prcd_elements-kposn,
          kschl TYPE  prcd_elements-kschl,
          kbetr TYPE  prcd_elements-kbetr,
          waers TYPE  prcd_elements-waers,
          kwert TYPE  prcd_elements-kwert,
        END OF ty_konv,

        BEGIN OF ty_vbfa,
          vbelv   TYPE vbfa-vbelv,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          vbtyp_n TYPE vbfa-vbtyp_n,
        END OF ty_vbfa,

        BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          fkart TYPE vbrk-fkart,
          fktyp TYPE vbrk-fktyp,
          vkorg TYPE vbrk-vkorg,
          vtweg TYPE vbrk-vtweg,
          fkdat TYPE vbrk-fkdat,
          fksto TYPE vbrk-fksto,
        END OF ty_vbrk,

        BEGIN OF ty_vbrp,
          vbeln TYPE vbrp-vbeln,
          posnr TYPE vbrp-posnr,
          fkimg TYPE vbrp-fkimg,
          aubel TYPE vbrp-aubel,
          aupos TYPE vbrp-aupos,
          matnr TYPE vbrp-matnr,
          werks TYPE vbrp-werks,
        END OF ty_vbrp,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          adrnr TYPE kna1-adrnr,
        END OF ty_kna1,

        BEGIN OF ty_vbap1,
          vbeln    TYPE vbap-vbeln,
          posnr    TYPE vbap-posnr,
          zibr     TYPE vbap-zibr,
          zul      TYPE vbap-zul,
          zsl      TYPE vbap-zsl,
          zce      TYPE vbap-zce,
          zapi6d   TYPE vbap-zapi6d,
          zapi60   TYPE vbap-zapi60,
          zatex    TYPE vbap-zatex,
          ztrcu    TYPE vbap-ztrcu,
          zcrn     TYPE vbap-zcrn,
          zmarine  TYPE vbap-zmarine,
          ofm_date TYPE vbap-ofm_date,
          erdat    TYPE vbap-erdat,
        END OF ty_vbap1,

        """""""""" added by pankaj 04.02.2022

        BEGIN OF ty_tvktt,
          ktgrd TYPE tvktt-ktgrd,
          vtext TYPE tvktt-vtext,
          spras TYPE tvktt-spras,
        END OF ty_tvktt,


        BEGIN OF ty_jest3,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
          inact TYPE jest-inact,
        END OF ty_jest3,

        BEGIN OF ty_tj30,
          stsma TYPE tj30t-stsma,
          estat TYPE tj30t-estat,
          txt04 TYPE tj30t-txt04,
        END OF ty_tj30.

TYPES: BEGIN OF ty_tvfst,
         spras TYPE tvfst-spras,
         faksp TYPE tvfst-faksp,
         vtext TYPE tvfst-vtext,
       END OF ty_tvfst.

DATA: BEGIN OF it_zhold_reason OCCURS 0,
        zhold_key       TYPE zhold_reason-zhold_key,
        zhold_reason_n1 TYPE zhold_reason-zhold_reason_n1,
      END OF it_zhold_reason,
      ls_zhold_reason LIKE LINE OF it_zhold_reason.

DATA : it_tvktt TYPE TABLE OF ty_tvktt,
       wa_tvktt TYPE ty_tvktt,

       it_jest3 TYPE TABLE OF ty_jest3,
       wa_jest3 TYPE ty_jest3,

       it_tj30  TYPE TABLE OF ty_tj30,
       wa_tj30  TYPE  ty_tj30.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'


DATA : certif_zibr    TYPE char20,
       certif_zul     TYPE char20,
       certif_zsl     TYPE char20,
       certif_zce     TYPE char20,
       certif_zapi6d  TYPE char20,
       certif_zapi60  TYPE char20,
       certif_zatex   TYPE char20,
       certif_ztrcu   TYPE char20,
       certif_zcrn    TYPE char20,
       certif_zmarine TYPE char20.



DATA: it_vbak  TYPE TABLE OF ty_vbak,
      wa_vbak  TYPE ty_vbak,
      it_vbap  TYPE TABLE OF ty_vbap,
      wa_vbap  TYPE ty_vbap,

      it_vbap2 TYPE TABLE OF ty_vbap2,
      wa_vbap2 TYPE ty_vbap2,

      lt_vbpa  TYPE TABLE OF ty_vbpa,
      ls_vbpa  TYPE ty_vbpa,

      it_vbkd  TYPE TABLE OF ty_vbkd,
      wa_vbkd  TYPE  ty_vbkd,
      it_t052u TYPE TABLE OF ty_t052u,
      wa_t052u TYPE  ty_t052u,
      it_mska  TYPE TABLE OF ty_mska,
      wa_mska  TYPE  ty_mska,
      it_konv  TYPE TABLE OF ty_konv,
      wa_konv  TYPE  ty_konv,
      it_konv1 TYPE TABLE OF ty_konv,
      wa_konv1 TYPE  ty_konv,
      it_vbfa  TYPE TABLE OF ty_vbfa,
      wa_vbfa  TYPE  ty_vbfa,
      it_vbrk  TYPE TABLE OF ty_vbrk,
      wa_vbrk  TYPE  ty_vbrk,
      it_vbrp  TYPE TABLE OF ty_vbrp,
      wa_vbrp  TYPE  ty_vbrp,
      it_kna1  TYPE TABLE OF ty_kna1,
      wa_kna1  TYPE  ty_kna1,
      it_vbap1 TYPE TABLE OF ty_vbap1,
      wa_vbap1 TYPE          ty_vbap1,

      it_tvfst TYPE STANDARD TABLE OF ty_tvfst,
      wa_tvfst TYPE ty_tvfst.
*****************edited by PJ on 16-08-21******************
TYPES : BEGIN OF ty_mara,
          matnr        TYPE mara-matnr,
          item_type    TYPE mara-item_type,
          bom          TYPE mara-bom,
          zpen_item    TYPE mara-zpen_item,
          zre_pen_item TYPE mara-zre_pen_item,
        END OF ty_mara.

*DATA : it1_mara TYPE TABLE OF ty_mara,
*       wa1_mara TYPE ty_mara.
DATA : tz TYPE timezone.
*****************end*****************************

DATA : quote TYPE char01 VALUE '"'.

DATA : lv_vbeln  TYPE cdhdr-objectid,
       lv_vbeln2 TYPE vbap-vbeln.

DATA: "it_vbak        TYPE STANDARD TABLE OF vbak,

  it_lips        TYPE STANDARD TABLE OF lips,
  wa_lips        TYPE lips,
  wa_lfimg       TYPE lips-lfimg,
  wa_lfimg_sum   TYPE lips-lfimg,

  wa_fkimg       TYPE lips-lfimg,
  wa_fkimg_sum   TYPE lips-lfimg,

  it_konh        TYPE STANDARD TABLE OF konh,
  wa_konh        TYPE konh,
  it_konp        TYPE STANDARD TABLE OF konp,
  wa_konp        TYPE konp,
  it_jest        TYPE STANDARD TABLE OF jest,
  wa_jest1       TYPE jest,
  it_tj30t       TYPE STANDARD TABLE OF tj30t,
  wa_tj30t       TYPE tj30t,

*  IT_CDHDR       TYPE STANDARD TABLE OF CDHDR,
*  WA_CDHDR       TYPE CDHDR,
*
*  IT_CDPOS       TYPE STANDARD TABLE OF CDPOS,
*  WA_CDPOS       TYPE CDPOS,
  it_output      TYPE STANDARD TABLE OF output,
  wa_output      TYPE output,
  it_output_new  TYPE STANDARD TABLE OF output_new, "ADDED BY JYOTI ON 26.04.2024
  wa_output_new  TYPE output_new, "ADDED BY JYOTI ON 26.04.2024
  wa_mbew        TYPE mbew,
*  wa_mara        TYPE mara,
  it_oauto       TYPE STANDARD TABLE OF output,
  wa_oauto       TYPE output,
  it_mara        TYPE TABLE OF mara,
  it_makt        TYPE TABLE OF makt,
  wa_makt        TYPE makt,
  lt_adrc        TYPE TABLE OF adrc,
  ls_adrc        TYPE adrc,
  lt_zgst_region TYPE TABLE OF zgst_region,
  ls_zgst_region TYPE zgst_region.


DATA:
  lt_resb TYPE tt_resb,
  ls_resb TYPE t_resb.
DATA:
   gt_final TYPE tt_final.
DATA: it_data           TYPE STANDARD TABLE OF ty_data,
      ls_data           TYPE ty_data,
      wa_data           TYPE ty_data,
      wa_data2          TYPE ty_data,
      lv_lines          TYPE STANDARD TABLE OF tline,
      wa_lines          LIKE tline,
      ls_lines          LIKE tline,
      wa_ln_ld          LIKE tline,
      wa_tag_rq         LIKE tline,
      wa_cust_proj_name TYPE tline , "ADDED BY JYOTI ON 04.12.2024
      wa_ofm_no         LIKE tline,
      lv_name           TYPE thead-tdname,
      wa_text           TYPE char20,
      wa_text1          TYPE char50.
DATA ls_mattxt  TYPE tline.
DATA ls_itmtxt  TYPE tline.
DATA ls_ctbgi   TYPE tline.
*data for bapi to convert currency

DATA: BEGIN OF ls_fr_curr OCCURS 0.
        INCLUDE STRUCTURE bapi1093_3.
DATA: END OF ls_fr_curr.

DATA: BEGIN OF ls_to_curr OCCURS 0.
        INCLUDE STRUCTURE bapi1093_4.
DATA: END OF ls_to_curr.

DATA: BEGIN OF ls_ex_rate OCCURS 0.
        INCLUDE STRUCTURE bapi1093_0.
DATA: END OF ls_ex_rate.

DATA: lv_ex_rate TYPE bapi1093_0.

DATA: BEGIN OF ls_return OCCURS 0.
        INCLUDE STRUCTURE bapiret1.
DATA: END OF ls_return.

ls_fr_curr-sign   = 'I'.
ls_fr_curr-option = 'EQ'.
*LV_FR_CURR-LOW = 'EQ'.

ls_to_curr-sign   = 'I'.
ls_to_curr-option = 'EQ'.
ls_to_curr-low = 'INR'.
APPEND ls_to_curr .


* ALV RELATED DATA
*---------------------------------------------------------------------*
*     STRUCTURES, VARIABLES AND CONSTANTS FOR ALV
*---------------------------------------------------------------------*
TYPE-POOLS : slis.
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv,

      it_fcat      TYPE slis_t_fieldcat_alv,
      wa_fcat      TYPE LINE OF slis_t_fieldcat_alv. " SLIS_T_FIELDCAT_ALV.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
************************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H'.

INITIALIZATION.

  REFRESH : it_vbak, it_vbap, it_vbkd, it_mska,
         it_vbrp,  it_konv,it_vbap1.

  CLEAR  : wa_vbak, wa_vbap, wa_vbkd, wa_mska,
           wa_vbrp,  wa_konv,wa_vbap1.


  """""""""""""""""""""""""""""""""""""" NC """"""""""""""""""""""""""""""""""""""""""""
