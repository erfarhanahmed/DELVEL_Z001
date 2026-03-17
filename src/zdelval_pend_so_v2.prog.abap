*&---------------------------------------------------------------------*
*& Report  ZSD_PEND_SO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zdelval_pend_so_v2.
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

TYPE-POOLS : slis.

* Types
TYPES : BEGIN OF ty_OUTPUT,
          werks           TYPE werks_ext,
          auart           TYPE vbak-auart,
          bstkd           TYPE vbkd-bstkd,
          name1           TYPE kna1-name1,
          vkbur           TYPE vbak-vkbur,
          vbeln           TYPE vbak-vbeln,
*          erdat           TYPE vbak-erdat,
*          vdatu           TYPE vbak-vdatu,
          erdat           TYPE char11,
          vdatu           TYPE char11,
          status          TYPE text30,
*          holddate        TYPE vbap-holddate,
*          reldate         TYPE vbap-holdreldate,
*          canceldate      TYPE vbap-canceldate,
*          deldate         TYPE vbap-deldate,
          holddate        TYPE char11,
          reldate         TYPE char11,
          canceldate      TYPE char11,
          deldate         TYPE char11,
          tag_req         TYPE char50,          "changed by sr on 03.05.2021
          tpi             TYPE char50,           "changed by sr on 03.05.2021
          ld_txt          TYPE char50,           "changed by sr on 03.05.2021
          zldperweek      TYPE zldperweek1,
          zldmax          TYPE vbak-zldmax,
*          zldfromdate     TYPE vbak-zldfromdate,
          zldfromdate     TYPE char11,

********
          matnr           TYPE vbap-matnr,
          posnr           TYPE vbap-posnr,
          arktx           TYPE vbap-arktx,
          kwmeng          TYPE vbap-kwmeng,
          stock_qty       TYPE mska-kalab,
          lfimg           TYPE lips-lfimg,
          fkimg           TYPE vbrp-fkimg,
          pnd_qty         LIKE vbrp-fkimg,
          ettyp           TYPE vbep-ettyp,
          mrp_dt          TYPE char11,
*          edatu           TYPE vbep-edatu,
          edatu           TYPE char11,
*          kbetr           TYPE prcd_elements-kbetr, "KONV-KBETR,
          kbetr           TYPE char25, "KONV-KBETR,
          waerk           TYPE vbap-waerk,
          curr_con        TYPE ukursp,
          so_exc          TYPE ukursp,
*          amont           TYPE char15,             "kbetr,
*          ordr_amt        TYPE char15,             "kbetr,
          amont           TYPE char25,          "kfpvtc19,            "length 19, dec 2,
          ordr_amt        TYPE char25,            "length 19, dec 2,
          in_price        TYPE char25,
*          in_pr_dt        TYPE prcd_elements-kdatu,
          in_pr_dt        TYPE char11,
          est_cost        TYPE char20,      "prcd_elements-kbetr,
          latst_cost      TYPE char20,      "prcd_elements-kbetr,
          st_cost         TYPE char20,      "mbew-stprs,
          zseries         TYPE zser_code,
          zsize           TYPE zsize,       " mara-zsize,
          brand           TYPE zbrand,      " mara-brand,
          moc             TYPE zmoc,        " mara-moc,
          type            TYPE ztyp,        " mara-type,
          dispo           TYPE marc-dispo,
          wip             TYPE vbrp-fkimg,
          mtart           TYPE mtart,
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
*          custdeldate     TYPE vbap-custdeldate,
          custdeldate     TYPE char11,
*          ref_dt          TYPE sy-datum,
          ref_dt          TYPE char11,
          abgru           TYPE  vbap-abgru,            " avinash bhagat 20.12.2018
          bezei           TYPE  tvagt-bezei,         " avinash bhagat 20.12.2018
          wrkst           TYPE  wrkst,
          cgst(5)         TYPE  c,
          sgst(5)         TYPE  c,
          igst(5)         TYPE  c,
          ship_kunnr      TYPE kunnr,            "ship to party code
          ship_kunnr_n    TYPE ad_name1,         "ship to party desctiption
          ship_reg_n      TYPE bezei,            ""ship to party gst region description
          sold_reg_n      TYPE bezei,             "sold to party gst region description
          normt           TYPE normt,
          ship_land       TYPE vbpa-land1,
          s_land_desc     TYPE t005t-landx50,
          sold_land       TYPE vbpa-land1,
          posex           TYPE vbap-posex,
*          bstdk           TYPE vbak-bstdk,
          bstdk           TYPE char11,
          lifsk           TYPE vbak-lifsk,
          vtext           TYPE tvlst-vtext,
          insur           TYPE text250,
          pardel          TYPE text250,
          gad             TYPE char50,
          us_cust         TYPE text250,
          tcs(11)         TYPE p DECIMALS 3,
          tcs_amt         TYPE konv-kwert,
          spl             TYPE char255,
*          po_del_date     TYPE vbap-custdeldate,
          po_del_date     TYPE char11,
          ofm_no          TYPE char128,
          ctbg            TYPE char10,            "added by sr on 03.05.2021 ctbgi details
          certif          TYPE char255,             "added by sr on 03.05.2021 certification details
          item_type       TYPE char1, " edited by PJ on 16-08-21
          ref_time        TYPE char10,          " edited by PJ on 08-09-21
          proj            TYPE char255,                         "added by pankaj 28.01.2022
          cond            TYPE char255,                       "added by pankaj 28.01.2022
*          receipt_date    TYPE vbap-receipt_date,          "added by pankaj 28.01.2022
          receipt_date    TYPE char11,          "added by pankaj 28.01.2022
          reason          TYPE char30,                "added by pankaj 28.01.2022
          ntgew           TYPE vbap-ntgew,          "added by pankaj 28.01.2022
*          zpr0            TYPE kwert,              "added by pankaj 28.01.2022
*          zpf0            TYPE kwert,              "added by pankaj 28.01.2022
*          zin1            TYPE kwert,              "added by pankaj 28.01.2022
*          zin2            TYPE kwert,             "added by pankaj 28.01.2022
*          joig            TYPE kwert,              "added by pankaj 28.01.2022
*          jocg            TYPE kwert,              "added by pankaj 28.01.2022
*          josg            TYPE kwert,                "added by pankaj 28.01.2022
*          dis_rate        TYPE p DECIMALS 2,
*          dis_amt         TYPE prcd_elements-kwert,        "Discount
*          dis_unit_rate   TYPE prcd_elements-kwert,
*          tot_ass         TYPE prcd_elements-kbetr,        "Discount
*          ass2_val        TYPE prcd_elements-kwert,
          zpr0            TYPE char17,              "added by pankaj 28.01.2022
          zpf0            TYPE char17,              "added by pankaj 28.01.2022
          zin1            TYPE char17,              "added by pankaj 28.01.2022
          zin2            TYPE char17,             "added by pankaj 28.01.2022
          joig            TYPE char17,              "added by pankaj 28.01.2022
          jocg            TYPE char17,              "added by pankaj 28.01.2022
          josg            TYPE char17,                "added by pankaj 28.01.2022
          dis_rate        TYPE char11,
          dis_amt         TYPE char15,        "Discount
          dis_unit_rate   TYPE char15,
          tot_ass         TYPE char15,        "Discount
          ass2_val        TYPE char17,
*          date            TYPE vbep-edatu,
          date            TYPE char11,
*          prsdt           TYPE vbkd-prsdt,
          prsdt           TYPE char11,
          packing_type    TYPE char255,
          ofm_date1       TYPE char11,  "vbap-ofm_date,
          mat_text        TYPE char15,
          infra           TYPE char255,         "added by pankaj 31.01.2022
          validation      TYPE char255,         "added by pankaj 31.01.2022
          review_date     TYPE char255,         "added by pankaj 31.01.2022   b
          diss_summary    TYPE char255,        "added by pankaj 31.01.2022
*          chang_so_date   TYPE vbap-erdat,
          chang_so_date   TYPE char11,
          port            TYPE adrc-name1,
          full_pmnt       TYPE char255,
          act_ass         TYPE tvktt-vtext,
          txt04           TYPE tj30t-txt04,
          freight         TYPE char128,
          po_sr_no        TYPE char128,

*          udate           TYPE sy-datum,            "cdhdr-udate,
          udate           TYPE char11,            "cdhdr-udate,
          bom             TYPE zbom,             " mara-bom,
          zpen_item       TYPE zpen_item,        " mara-zpen_item,
          zre_pen_item    TYPE zre_pen_item,     " mara-zre_pen_item,
          zins_loc        TYPE vbap-zins_loc,
          bom_exist       TYPE char5,
          posex1          TYPE vbap-posex, "ADDED BY JYOTI ON 16.04.2024
          lgort           TYPE vbap-lgort, ""Added by Pranit 10.06.2024
          quota_ref       TYPE char128, "added by jyoti on19.06.2024
          zmrp_date       TYPE char11, "added by jyoti on 02.07.2024
          vkorg           TYPE vbak-vkorg ,    " ADDED BY SUPRIYA ON 19.08.2024
          vtweg           TYPE vbak-vtweg ,  " ADDED BY SUPRIYA ON 19.08.2024
          spart           TYPE vbak-spart,     " ADDED BY SUPRIYA ON 19.08.2024
          zexp_mrp_date1  TYPE char11, "added by jyoti on 13.11.2024
          special_comm    TYPE text250,
          zcust_proj_name TYPE text250, "added by jyoti on 04.12.2024
          amendment_his   TYPE text250, "added by jyoti on 20.01.2025
          po_dis          TYPE text250, "added by jyoti on 20.01.2025
          hold_reason_n1  TYPE vbap-zhold_reason_n1 , "added by jyoti on 06.02.2025
          stock_qty_ktpi  TYPE mska-kalab, "ADDED BY JYOTI ON 28.03.2025
          stock_qty_tpi1  TYPE mska-kalab,   "ADDED BY JYOTI ON 28.03.2025
          kurst           TYPE knvv-kurst, "added by jypoti on 31.03.2025
          ofm_rec_date    TYPE char255,
          oss_rec_date    TYPE char255,
          source_rest     TYPE char255,
          suppl_rest      TYPE char255,

          cust_mat_desc   TYPE char255,
          cust_mat_Code   TYPE char40,    "Customer material code from text
        END OF ty_OUTPUT,
* Texts
        BEGIN OF ty_hdtext,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          obj   TYPE tdobject,
          id    TYPE tdid,
          name  TYPE tdname,
          text  TYPE text255,
        END   OF ty_hdtext,

        BEGIN OF ty_mattxt,
          matnr  TYPE matnr,
          mattxt TYPE tdline,
        END   OF ty_mattxt,

        BEGIN OF ty_so,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          matnr TYPE matnr,
        END   OF ty_so,

        BEGIN OF ty_text,
          vbeln           TYPE vbeln_va,
          posnr           TYPE posnr_va,

          tpi             TYPE text50,
          freight         TYPE text128,
          ofm             TYPE text50,
          packing_type    TYPE text255,
          ofm_date        TYPE text50,
          insur           TYPE text250,
          spl             TYPE text255,
          ld_txt          TYPE text50,
          tag_req         TYPE text50,
          pardel          TYPE text250,
          quota_ref       TYPE text128,
          zcust_proj_name TYPE text250,
          amendment_his   TYPE text250,
          po_dis          TYPE text250,
          full_pmnt       TYPE text255,
          proj            TYPE text255,
          cond            TYPE text255,
          infra           TYPE text255,
          validation      TYPE text255,
          review_date     TYPE text255,
          diss_summary    TYPE text255,
          ofm_no          TYPE text128,
          special_comm    TYPE text250,
          itmtxt          TYPE text255,
          mat_text        TYPE text100,
          po_sr_no        TYPE text128,
          cust_mat_Code   TYPE text40,

          ofm_rec_date    TYPE char255,
          oss_rec_date    TYPE char255,
          source_rest     TYPE char255,
          suppl_rest      TYPE char255,
          cust_mat_desc   TYPE char255,

        END   OF ty_text,

        BEGIN OF ty_BSTKD,
          bstkd   TYPE bstkd,
          us_cust TYPE text250,
        END   OF ty_BSTKD,

        tty_output TYPE STANDARD TABLE OF ty_output,
        tty_hdtext TYPE STANDARD TABLE OF ty_hdtext,
        tty_mattxt TYPE STANDARD TABLE OF ty_mattxt,

        tty_bstkd  TYPE STANDARD TABLE OF ty_bstkd,

        tty_so     TYPE STANDARD TABLE OF ty_so.
*        tty_text   type STANDARD TABLE OF ty_text.
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
    tag_req           TYPE char50,
    tpi               TYPE char50,           "changed by sr on 03.05.2021
    ld_txt            TYPE char50,           "changed by sr on 03.05.2021
    zldperweek        TYPE zldperweek1,
    zldmax            TYPE vbak-zldmax,
    zldfromdate       TYPE char11, "vbak-zldfromdate,

    matnr             TYPE vbap-matnr,
    posnr             TYPE vbap-posnr,
    arktx             TYPE vbap-arktx,
    kwmeng            TYPE char15, "vbap-kwmeng,
    kalab             TYPE char15, "mska-kalab,
    lfimg             TYPE char15, "lips-lfimg,
    fkimg             TYPE char15, "vbrp-fkimg,
    pnd_qty           TYPE char15, "vbrp-fkimg,
    ettyp             TYPE vbep-ettyp,
    mrp_dt            TYPE char11, "udate,
    edatu             TYPE char11, "vbep-edatu,
    kbetr             TYPE char25 , "prcd_elements-kbetr  , "konv-kbetr,
    waerk             TYPE vbap-waerk,
    curr_con          TYPE ukursp,
    amont             TYPE char25, "kbetr,
    ordr_amt          TYPE char25, "kbetr,
    in_price          TYPE char25, "konv-kbetr,
    in_pr_dt          TYPE char11, "konv-kdatu,
    est_cost          TYPE char25, "konv-kbetr,
    latst_cost        TYPE char25, "konv-kbetr,
    st_cost           TYPE char25, "mbew-stprs,
    zseries           TYPE zser_code,     "mara-zseries,
    zsize             TYPE zsize,         "mara-zsize,
    brand             TYPE zbrand,        "mara-brand,
    moc               TYPE zmoc,          "mara-moc,
    type              TYPE ztyp,          "mara-type,

    dispo             TYPE marc-dispo,
    wip               TYPE char15,
    mtart             TYPE mtart,
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
    wrkst             TYPE wrkst,
    cgst(4)           TYPE c, "konv-kbetr,
    sgst(4)           TYPE  c, "konv-kbetr,
    igst(4)           TYPE  c, "konv-kbetr,
    ship_kunnr        TYPE kunnr,            "ship to party code
    ship_kunnr_n      TYPE ad_name1,         "ship to party desctiption
    ship_reg_n        TYPE bezei,            ""ship to party gst region
    sold_reg_n        TYPE bezei,             "ship to party gst region description
    normt             TYPE normt,
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
    tcs               TYPE char20,
    tcs_amt           TYPE char20,
    spl               TYPE char255,
    po_del_date       TYPE char11,
    ofm_no            TYPE char128,
    ctbg              TYPE char10,            "added by sr on 03.05.2021
    certif            TYPE char255,             "added by sr on 03.05.2021 certification details
    item_type         TYPE char1,  "edited by PJ on 16-08-21
    ref_time          TYPE char10,  "edited by PJ on 08-09-21
    proj              TYPE char255,                         "added by pankaj 28.01.2022
    cond              TYPE char255,                       "added by pankaj 28.01.2022
    receipt_date      TYPE char20,              "vbap-receipt_date,          "added by pankaj 28.01.2022
    reason            TYPE char30,                "added by pankaj 28.01.2022
    ntgew             TYPE char25,             "added by pankaj 28.01.2022
    zpr0              TYPE char20,             "added by pankaj 28.01.2022
    zpf0              TYPE char20,              "added by pankaj 28.01.2022
    zin1              TYPE char20,               "added by pankaj 28.01.2022
    zin2              TYPE char20,                 "added by pankaj 28.01.2022
    joig              TYPE char20,                 "added by pankaj 28.01.2022
    jocg              TYPE char20,                 "added by pankaj 28.01.2022
    josg              TYPE char20,
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
    port              TYPE adrc-name1,          "added by pankaj 02.02.2022
    full_pmnt         TYPE char255,             "added by pankaj 02.02.2022
    act_ass           TYPE char255,  "tvktt-vtext,         "added by pankaj 02.02.2022
    txt04             TYPE char255,
    freight           TYPE char128,
    po_sr_no          TYPE char128,
    udate             TYPE char11,
    bom               TYPE zbom,      "mara-bom,
    zpen_item         TYPE zpen_item, "mara-zpen_item,
    zre_pen_item      TYPE zre_pen_item,  "mara-zre_pen_item,
    zins_loc          TYPE vbap-zins_loc,
    bom_exist         TYPE char5,
    posex1            TYPE vbap-posex, "ADDED BY JYOTI ON 16.04.2024
    lgort             TYPE vbap-lgort, "ADDED BY Pranit ON 10.06.2024
    quota_ref         TYPE char255 , "added by jyoti on19.06.2024
    zmrp_date         TYPE char11, "ADDED BY JYOTI ON 02.07.2024
    vkorg             TYPE vkorg,
    vtweg             TYPE vtweg,
    spart             TYPE spart,
    zexp_mrp_date1    TYPE char11, "ADDED BY JYOTI ON 13.11.2024
    special_comm      TYPE string,
    zcust_proj_name   TYPE string, "added by jyoti on 04.12.2024
    amendment_his     TYPE char250,
    po_dis            TYPE char250,
    hold_reason_n1    TYPE string , "added by jyoti on 06.02.2025
    stock_qty_ktpi    TYPE string,  "added by jyoti on 28.03.2025
    stock_qty_tpi1    TYPE string,  "added by jyoti on 28.03.2025
    kurst             TYPE char20,
    ofm_received_date TYPE char255, "added by jyoti on 07.04.2025
    oss_received_cell TYPE char255, "added by jyoti on 07.04.2025
    source_rest       TYPE char255,
    suppl_rest        TYPE char255,
    cust_mat_desc     TYPE char255,

    dis_rate          TYPE char17,
    dis_amt           TYPE char20,        "Discount
    dis_unit_rate     TYPE char17,

    cust_mat_Code     TYPE text40,
  END OF t_final,
  tt_final TYPE STANDARD TABLE OF t_final.
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
          tag_req         TYPE char50,          "changed by sr on 03.05.2021
          tpi             TYPE char50,           "changed by sr on 03.05.2021
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
          kbetr           TYPE char25, "prcd_elements-kbetr," CHAR15, "konv-kbetr,
          waerk           TYPE vbap-waerk,
          curr_con        TYPE ukursp,
          amont           TYPE char25,             "kbetr,
          ordr_amt        TYPE char25,             "kbetr,
          in_price        TYPE char26  ,  "CHAR15, "konv-kbetr,
*          in_pr_dt        TYPE prcd_elements-kdatu  ,  "CHAR11, "konv-kdatu,
          in_pr_dt        TYPE char11 ,  "CHAR11, "konv-kdatu,
          est_cost        TYPE char36  ,  "CHAR15, "konv-kbetr,
          latst_cost      TYPE char36 , "PRCD_ELEMENTS-KBETR  ,  "CHAR15, "konv-kbetr,
          st_cost         TYPE char15, "mbew-stprs,
          zseries         TYPE zser_code,
          zsize           TYPE zsize,
          brand           TYPE zbrand,
          moc             TYPE zmoc,
          type            TYPE ztyp,

          """"""""   Added By KD 04.05.2017    """""""
          dispo           TYPE marc-dispo,
          wip             TYPE char15, "vbrp-fkimg,
          mtart           TYPE mtart,
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
          wrkst           TYPE  wrkst,
          cgst(4)         TYPE  c,
          sgst(4)         TYPE  c,
          igst(4)         TYPE  c,
          ship_kunnr      TYPE kunnr,            "ship to party code
          ship_kunnr_n    TYPE ad_name1,         "ship to party desctiption
          ship_reg_n      TYPE bezei,            ""ship to party gst region description
          sold_reg_n      TYPE bezei,             "sold to party gst region description
          normt           TYPE normt,
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
          item_type       TYPE char1, " edited by PJ on 16-08-21
          ref_time        TYPE char11,          " edited by PJ on 08-09-21
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
          ofm_date1       TYPE char11,  "vbap-ofm_date,
          mat_text        TYPE char15,
          infra           TYPE char255,         "added by pankaj 31.01.2022
          validation      TYPE char255,         "added by pankaj 31.01.2022
          review_date     TYPE char255,         "added by pankaj 31.01.2022   b
          diss_summary    TYPE char255,        "added by pankaj 31.01.2022
          chang_so_date   TYPE char11, "vbap-erdat,
          """""""" added by pankaj 04.02.2022
          port            TYPE adrc-name1,
          full_pmnt       TYPE char255,
          act_ass         TYPE char255, "tvktt-vtext,
          txt04           TYPE char255, "tj30t-txt04,
          freight         TYPE char128,
          po_sr_no        TYPE char128,
          udate           TYPE char11,            "cdhdr-udate,
          bom             TYPE zbom,          "mara-bom,
          zpen_item       TYPE zpen_item,     "mara-zpen_item,
          zre_pen_item    TYPE zre_pen_item,  "mara-zre_pen_item,
          zins_loc        TYPE vbap-zins_loc,
          bom_exist       TYPE char5,
          posex1          TYPE vbap-posex, "adde by jyoti on 16.04.2024
          lgort           TYPE vbap-lgort, "added by Pranit on 20.06.2024
          quota_ref       TYPE char128 , "added by jyoti on19.06.2024
          zmrp_date       TYPE char11, "ADDED BY JYOTI OM 02.07.2024
          vkorg           TYPE vbak-vkorg ,    " ADDED BY SUPRIYA ON 19.08.2024
          vtweg           TYPE vbak-vtweg ,  " ADDED BY SUPRIYA ON 19.08.2024
          spart           TYPE vbak-spart,     " ADDED BY SUPRIYA ON 19.08.2024

          zexp_mrp_date1  TYPE char11, "added by jyoti on 13.11.2024
          special_comm    TYPE string,
          zcust_proj_name TYPE string, "added by jyoti on 04.12.2024
          amendment_his   TYPE char250, "added by jyoti on 20.01.2025
          po_dis          TYPE char250, "added by jyoti on 20.01.2025
          hold_reason_n1  TYPE string , "added by jyoti on 06.02.2025
          stock_qty_ktpi  TYPE string, "ADDED BY JYOTI ON 28.03.2025
          stock_qty_tpi1  TYPE string, "ADDED BY JYOTI ON 28.03.2025
          kurst           TYPE string, "added by jypoti on 31.03.2025
          ofm_rec_date    TYPE char255,
          oss_rec_date    TYPE char255,
          source_rest     TYPE char255,
          suppl_rest      TYPE char255,
          cust_mat_desc   TYPE char255,
          dis_rate        TYPE char17,
          dis_amt         TYPE char20,        "Discount
          dis_unit_rate   TYPE char17,

          cust_mat_Code   TYPE text40,
        END OF output_new.


DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      fieldlayout  TYPE slis_layout_alv,

      it_fcat      TYPE slis_t_fieldcat_alv,
      wa_fcat      TYPE LINE OF slis_t_fieldcat_alv. " SLIS_T_FIELDCAT_ALV.

DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA

DATA: gv_matnr      TYPE vbap-matnr,
      gv_kunnr      TYPE vbak-kunnr,
      gv_vbeln      TYPE vbak-vbeln,
      gv_kschl      TYPE konv-kschl,
      gv_stat       TYPE jest1-stat,
      gt_output     TYPE tty_output,
*      gt_hdtext     TYPE HASHED TABLE OF ty_hdtext WITH UNIQUE KEY vbeln posnr obj id,
      gt_hdtext     TYPE SORTED TABLE OF ty_hdtext WITH NON-UNIQUE KEY vbeln posnr,
      gt_mattxt     TYPE tty_mattxt,
      gt_so         TYPE tty_so,
      GS_tEXT       TYPE ty_text,
      gt_Exchrate   TYPE STANDARD TABLE OF bapi1093_0,
      it_output_new TYPE STANDARD TABLE OF output_new,
      gt_final      TYPE tt_final,
      gt_htext      TYPE HASHED TABLE OF ty_text WITH UNIQUE KEY vbeln posnr,
      gt_itmtext    TYPE HASHED TABLE OF ty_text WITH UNIQUE KEY vbeln posnr.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
    SELECT-OPTIONS   :  s_date FOR sy-datum OBLIGATORY ,
                        s_matnr FOR gv_matnr,
                        s_kunnr FOR gv_kunnr,
                        s_vbeln FOR gv_vbeln.
  SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
  PARAMETERS open_so  RADIOBUTTON GROUP code DEFAULT 'X' USER-COMMAND codegen.
  PARAMETERS all_so  RADIOBUTTON GROUP code.
SELECTION-SCREEN END OF BLOCK b3.

SELECT-OPTIONS:  s_kschl   FOR  gv_kschl NO-DISPLAY .
SELECT-OPTIONS:  s_stat   FOR  gv_stat NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN COMMENT /1(70) TEXT-077.
  SELECTION-SCREEN COMMENT /1(70) TEXT-078.
  SELECTION-SCREEN COMMENT /1(70) TEXT-079.
SELECTION-SCREEN: END OF BLOCK b4.


INITIALIZATION.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM fill_stat_range.
  PERFORM fetch_Data.

  IF p_down IS   INITIAL.
    PERFORM display_alv.
  ELSE.
*  IF p_down IS   INITIAL.
    PERFORM download_file.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form fill_stat_range
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_stat_range .
  DATA wa_kschl LIKE s_kschl.
  DATA wa_jest LIKE s_stat.
  CLEAR: wa_kschl , wa_jest.

  wa_kschl-sign = 'I'.
  wa_kschl-option = 'EQ'.
  wa_kschl-low = 'ZPRO'.
  APPEND wa_kschl TO s_kschl.

  wa_kschl-sign = 'I'.
  wa_kschl-option = 'EQ'.
  wa_kschl-low = 'VPRS'.
  APPEND wa_kschl TO s_kschl.

  wa_jest-sign = 'I'.
  wa_jest-option = 'EQ'.
  wa_jest-low = 'E0001'.
  APPEND wa_jest TO s_stat.

  wa_jest-sign = 'I'.
  wa_jest-option = 'EQ'.
  wa_jest-low = 'E0002'.
  APPEND wa_jest TO s_stat.

  wa_jest-sign = 'I'.
  wa_jest-option = 'EQ'.
  wa_jest-low = 'E0003'.
  APPEND wa_jest TO s_stat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fetch_Data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fetch_Data .
  TYPES: BEGIN OF ty_knumv,
           knumv TYPE prcd_elements-knumv,
         END OF ty_knumv,
         tty_knumv TYPE STANDARD TABLE OF ty_knumv WITH KEY knumv,

         BEGIN OF ty_waerk,
           waerk TYPE vbak-waerk,
         END   OF ty_waerk,
         tty_waerk TYPE STANDARD TABLE OF ty_waerk,

         BEGIN OF ty_mska,
           vbeln          TYPE mska-vbeln,
           posnr          TYPE mska-posnr,
           matnr          TYPE mska-matnr,
           werks          TYPE mska-werks,

           stock_qty_ktpi TYPE mska-kalab,
           stock_qty_tpi1 TYPE mska-kalab,
           stock_Qty      TYPE mska-kalab,
           kains          TYPE mska-kains,

         END  OF ty_mska,
         tty_mska TYPE HASHED TABLE OF ty_mska WITH UNIQUE KEY vbeln posnr matnr werks.

  DATA: lt_knumv TYPE tty_knumv,
        lt_waerk TYPE TTY_wAERK,
        lt_mska  TYPE HASHED TABLE OF ty_mska WITH UNIQUE KEY vbeln posnr matnr werks.

  DATA:
    lr_lfsta TYPE RANGE OF vbap-lfsta,
    lr_lfgsa TYPE RANGE OF vbap-lfgsa,
    lr_gbsta TYPE RANGE OF vbap-gbsta.

* Regions from custom table
  SELECT * FROM zgst_region INTO TABLE @DATA(lt_zgst_region).
  LOOP AT lt_zgst_region ASSIGNING FIELD-SYMBOL(<f2>).
    DATA(lv_str_l) =  strlen( <f2>-region ).
    IF lv_str_l = 1.
      CONCATENATE '0' <f2>-region INTO <f2>-region.
    ENDIF.
  ENDLOOP.

  SORT lt_zgst_region BY region.

* fill in case of open sales orders
  IF open_so IS NOT INITIAL.
*    lr_lfsta = VALUE #( ( sign = 'I' option = 'NE' low = 'C' ) ).
*    lr_lfgsa = VALUE #( ( sign = 'I' option = 'NE' low = 'C' ) ).
*    lr_gbsta = VALUE #( ( sign = 'I' option = 'NE' low = 'C' ) ).
  ELSE.
* For all sales orders
    CLEAR: lr_lfsta, lr_lfgsa, lr_gbsta.
  ENDIF.
* Config data
  SELECT FROM tvktt AS a
      FIELDS
    a~ktgrd,
    a~vtext WHERE spras = @sy-langu
    INTO TABLE @DATA(lt_TVKTT).
  SORT lt_TVKTT BY ktgrd.

* Data fetch
  SELECT FROM  vbak AS a
      LEFT OUTER JOIN vbap AS b ON a~vbeln = b~vbeln
      LEFT OUTER JOIN mara AS c ON c~matnr = b~matnr
      LEFT OUTER JOIN kna1 AS d ON d~kunnr = a~kunnr
      LEFT OUTER JOIN dd07t AS e ON e~domname = 'ZREASON'
                                AND e~ddlanguage = @sy-langu
                                AND e~as4local = 'A'
                                AND e~domvalue_l = b~reason
      LEFT OUTER JOIN vbkd AS f ON f~vbeln = a~vbeln
                               AND f~posnr IS INITIAL
      LEFT OUTER JOIN t052u AS g ON g~spras = @sy-langu
                                AND g~zterm = f~zterm
                                AND g~ztagg = '00'
      LEFT OUTER JOIN vbep AS h ON h~vbeln = b~vbeln
                               AND h~posnr = b~posnr
                               AND h~etenr = '0001'
       LEFT OUTER JOIN marc AS i ON i~matnr = b~matnr
                                AND i~werks = b~werks
       LEFT OUTER JOIN tvagt AS j ON j~spras = @sy-langu
                                 AND j~abgru = b~abgru
       LEFT OUTER JOIN tvlst AS k ON k~spras = @sy-langu
                                 AND k~lifsp = a~lifsk
    FIELDS
          b~vbeln,
          b~posnr,
          b~matnr,
          b~werks,
          b~lgort,
          b~arktx,
          b~abgru,          "Rejection reason code
          j~bezei,          "Rejection code desc
          b~posex,
          b~posex AS posex1,
          b~kdmat,
          b~kwmeng,
          b~ntgew,

          b~lfsta,
          b~lfgsa,
          b~absta,
          b~gbsta,
          b~objnr,
          b~holddate,
          b~holdreldate AS reldate,
          b~canceldate,
          b~deldate,
          b~custdeldate AS custdeldate,
          b~custdeldate AS po_del_date,
          b~zmeng,
*            b~ZGAD,
          CAST( CASE WHEN b~zgad = 1 THEN 'Reference'
                     WHEN b~zgad = 2 THEN 'Approved'
                     WHEN b~zgad = 3 THEN 'Standard'
                     ELSE ' ' END
                AS CHAR( 15 ) ) AS gad,

          b~ctbg,
          b~receipt_date,
*            b~reason,
          CAST( e~ddtext AS CHAR( 30 ) ) AS reason,
          b~ofm_date AS ofm_date1,
          b~zins_loc,
          b~zmrp_date,
          b~zexp_mrp_date1,
          b~zhold_reason_n1,
          a~erdat,
          b~erdat AS chang_so_date,
          a~aedat AS udate,      "Last changed dt
*          CAST( ' ' AS CHAR( 11 ) ) AS udate,      "Last changed dt

          a~auart,
          a~lifsk,
          k~vtext,        "Del.block desc
          a~waerk,
          a~vkbur,
          a~knumv,
          a~vdatu,
          a~bstdk,
          a~kunnr,
          a~objnr AS objnr_ak ,
          a~zldfromdate,
          a~zldperweek,
          a~zldmax,
          a~faksk,
          a~vkorg ,
          a~vtweg,
          a~spart,
*            c~matnr,
          c~item_type,
          c~bom,
          c~zpen_item,
          c~zre_pen_item,
          c~zseries,
          c~zsize,
          c~brand,
          c~moc,
          c~type,
          c~mtart,
          c~wrkst,

          d~name1,
          d~adrnr,

* VBKD
          f~inco1,
          f~inco2,
          f~zterm,
          f~ktgrd,
          f~kursk AS so_exc,
          f~bstkd,
          f~prsdt,
          g~text1,
          h~etenr,      "Schedule line no
          h~ettyp,      "So Status
          h~edatu,      "delivary Date
          h~edatu AS date,      "delivary Date
          i~dispo,      "MRP controller
*          @sy-uzeit AS ref_time,   "Ref.Time
          CAST( concat( @sy-uzeit+0(2), concat( ':', @sy-uzeit+2(2) ) ) AS CHAR( 10 ) ) AS ref_time,   "Ref.Time
          CAST( '00000000' AS DATS ) AS mrp_dt,
          CAST( 0 AS DEC( 9, 5 ) ) AS curr_con,
          CAST( 0 AS DEC( 13, 2 ) ) AS stock_qty,
          CAST( 0 AS DEC( 13, 2 ) ) AS qmqty,
          CAST( 0 AS DEC( 13, 2 ) ) AS lfimg,
          CAST( 0 AS DEC( 13, 2 ) ) AS fkimg,
          CAST( 0 AS DEC( 13, 2 ) ) AS pnd_qty,

          CAST( 0 AS DEC( 15, 2 ) ) AS kbetr,
          CAST( 0 AS DEC( 15, 2 ) ) AS zpr0,
          CAST( 0 AS DEC( 15, 2 ) ) AS zpf0,
          CAST( 0 AS DEC( 15, 2 ) ) AS zin1,
          CAST( 0 AS DEC( 15, 2 ) ) AS zin2,
          CAST( 0 AS DEC( 15, 2 ) ) AS joig,
          CAST( 0 AS DEC( 15, 2 ) ) AS jocg,
          CAST( 0 AS DEC( 15, 2 ) ) AS josg,
          CAST( 0 AS DEC( 13, 2 ) ) AS dis_rate,
          CAST( 0 AS DEC( 13, 2 ) ) AS dis_amt,
          CAST( 0 AS DEC( 13, 2 ) ) AS dis_unit_rate,
          CAST( 0 AS DEC( 21, 4 ) ) AS amont,
          CAST( 0 AS DEC( 21, 4 ) ) AS ordr_amt,
          CAST( 0 AS DEC( 21, 9 ) ) AS in_price,
          CAST( '00000000' AS DATS ) AS in_pr_dt,
          CAST( 0 AS DEC( 11, 2 ) ) AS st_cost,
          CAST( 0 AS DEC( 11, 2 ) ) AS cgst,
          CAST( 0 AS DEC( 11, 2 ) ) AS sgst,
          CAST( 0 AS DEC( 11, 2 ) ) AS igst,
          CAST( 0 AS DEC( 9, 2 ) ) AS tcs,
          CAST( 0 AS DEC( 11, 2 ) ) AS tcs_amt,
          CAST( 0 AS DEC( 13, 2 ) ) AS wip,

* header text
          CAST( ' ' AS CHAR( 50 ) ) AS tpi,
          CAST( ' ' AS CHAR( 128 ) ) AS freight,
          CAST( ' ' AS CHAR( 50 ) ) AS ofm,
          CAST( ' ' AS CHAR( 50 ) ) AS ofm_date,
          CAST( ' ' AS CHAR( 250 ) ) AS insur,
          CAST( ' ' AS CHAR( 250 ) ) AS packing_type,
          CAST( ' ' AS CHAR( 255 ) ) AS spl,
          CAST( ' ' AS CHAR( 50 ) ) AS ld_txt,
          CAST( ' ' AS CHAR( 50 ) ) AS tag_req,
          CAST( ' ' AS CHAR( 250 ) ) AS pardel,
          CAST( ' ' AS CHAR( 128 ) ) AS quota_ref,
          CAST( ' ' AS CHAR( 250 ) ) AS zcust_proj_name,
          CAST( ' ' AS CHAR( 250 ) ) AS amendment_his,
          CAST( ' ' AS CHAR( 250 ) ) AS po_dis,
          CAST( ' ' AS CHAR( 255 ) ) AS full_pmnt,
          CAST( ' ' AS CHAR( 255 ) ) AS proj,
          CAST( ' ' AS CHAR( 255 ) ) AS cond,
          CAST( ' ' AS CHAR( 255 ) ) AS infra,
          CAST( ' ' AS CHAR( 255 ) ) AS validation,
          CAST( ' ' AS CHAR( 255 ) ) AS review_date,
          CAST( ' ' AS CHAR( 255 ) ) AS diss_summary,
          CAST( ' ' AS CHAR( 250 ) ) AS us_cust,
          CAST( ' ' AS CHAR( 20 ) ) AS act_ass,
* item
          CAST( ' ' AS CHAR( 128 ) ) AS ofm_no,
          CAST( ' ' AS CHAR( 250 ) ) AS special_comm,
          CAST( ' ' AS CHAR( 255 ) ) AS itmtxt,
          CAST( ' ' AS CHAR( 128 ) ) AS po_sr_no,
          CAST( ' ' AS CHAR( 100 ) ) AS mattxt,
          CAST( ' ' AS CHAR( 100 ) ) AS mat_text,
          CAST( ' ' AS CHAR( 17 ) ) AS schid,

          CAST( ' ' AS CHAR( 39 ) ) AS status,
          CAST( ' ' AS CHAR( 04 ) ) AS txt04,

* Partner details
          CAST( ' ' AS CHAR( 5 ) ) AS bom_exist,
          CAST( '0000000000' AS NUMC( 10 ) ) AS ship_kunnr,           "Ship-to Number
          CAST( ' ' AS CHAR( 3 ) )  AS ship_land,            "Ship-to land
          CAST( ' ' AS CHAR( 40 ) ) AS ship_kunnr_n,         "Ship-to name
          CAST( ' ' AS CHAR( 25 ) ) AS ship_reg_n,           "Region
          CAST( ' ' AS CHAR( 50 ) ) AS s_land_desc,          "Country name
          CAST( ' ' AS CHAR( 3 ) )  AS sold_land,
          CAST( ' ' AS CHAR( 25 ) ) AS sold_reg_n,
          CAST( ' ' AS CHAR( 40 ) ) AS port,
* Tabkey to get CDHDR/CDPOS data
          concat( h~mandt, concat( h~vbeln, concat( h~posnr, h~etenr ) ) ) AS tabkey,
          CAST( ' ' AS CHAR( 40 ) ) AS cust_mat_Code
   WHERE
*         a~erdat  IN @s_date
         b~erdat  IN @s_date
   AND   a~vbeln  IN @s_vbeln
*   AND   a~auart NOT IN ( 'ZESS', 'ZSER' )
   AND   b~matnr  IN @s_matnr
   AND   b~lfsta  IN @lr_lfsta
   AND   b~lfgsa  IN @lr_lfgsa
   AND   b~gbsta  IN @lr_gbsta
   AND  a~kunnr IN @s_kunnr
   AND  b~werks = 'PL01'
   INTO TABLE @DATA(it_itab).

  DELETE it_itab WHERE auart = 'ZESS' AND abgru <> space.
  DELETE it_itab WHERE auart = 'ZSER' AND abgru <> space.

* Further logic
  IF it_itab IS NOT INITIAL.

**    READ from cdhdr, cdpos
    SELECT FROM cdhdr AS a
    INNER JOIN cdpos AS b ON b~objectclas = a~objectclas
    AND b~objectid   = a~objectid
    AND b~changenr   = a~changenr
    AND b~tabname    = 'VBEP'
    AND b~fname      = 'ETTYP'
    AND b~value_new  = 'CP'
*                             and b~value_old = 'CN'
    INNER JOIN @it_itab AS c ON c~tabkey = b~tabkey
    FIELDS
    c~vbeln,
    c~posnr,
    a~udate
    WHERE a~objectclas = 'VERKBELEG'
    INTO TABLE @DATA(lt_cdpos).
    SORT lt_cdpos BY vbeln posnr.

* Read partners
    SELECT FROM vbpa AS a
        LEFT OUTER JOIN adrc AS b ON b~addrnumber = a~adrnr
                                 AND b~nation = @space
                                 AND b~daTe_to > @sy-datUm
        LEFT OUTER JOIN t005t AS c ON c~spras = @sy-langu
                                  AND c~land1 = a~land1
        LEFT OUTER JOIN t005u AS d ON d~spras = @sy-langu
                                  AND d~land1 = a~land1
                                  AND d~bland = b~region
      FIELDS
      a~vbeln,
      a~posnr,
      a~parvw,
      a~kunnr,
      a~adrnr,
      a~land1,
      a~assigned_bp,
      b~name1,
      b~city1,
      b~regioN,
      b~country,
      c~landx50,
      d~bezei
      FOR ALL ENTRIES IN @it_itab
      WHERE a~vbeln = @it_itab-vbeln
        AND a~parvw IN ( 'AG', 'WE' )
      INTO TABLE @DATA(lt_vbpa).
    SORT lt_vbpa BY vbeln posnr parvw.

* Read KURSF FROM KNVV.
    IF lt_vbpa IS NOT INITIAL.
      SELECT kunnr,
             kurst
        FROM knvv
          FOR ALL ENTRIES IN @lt_vbpa
        WHERE kunnr = @lt_vbpa-kunnr
        INTO TABLE @DATA(it_knvv).

      SORT It_knvv BY kunnr.
      DELETE ADJACENT DUPLICATES FROM It_knvv COMPARING kunnr.
    ENDIF.

* Exchange rates - Begin
    DATA: lt_fr_curr TYPE STANDARD TABLE OF bapi1093_3,
          lt_to_curr TYPE STANDARD TABLE OF bapi1093_4,
          lt_return  TYPE STANDARD TABLE OF bapiret1.

    LT_wAERK = CORRESPONDING #( it_itab MAPPING waerk = waerk  ).
    SORT lt_waerk BY waerk.
    DELETE ADJACENT DUPLICATES FROM LT_wAERK COMPARING waerk.
    IF LT_wAERK IS NOT INITIAL.
      lt_fr_curr = VALUE #( FOR ls IN lt_Waerk ( sign = 'I'
                                                 option = 'EQ'
                                                 low = ls-waerk ) ).
      lt_to_curr = VALUE #( ( sign = 'I' option = 'EQ' low = 'INR' ) ).

      CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
        EXPORTING
          date             = sy-datum
          date_type        = 'V'
          rate_type        = 'B'
        TABLES
          from_curr_range  = lt_fr_curr
          to_currncy_range = lt_to_curr
          exch_rate_list   = gt_exchrate
          return           = LT_return.
    ENDIF.
* Exchange rates - End

* Del Qty, Inv qty
    SELECT FROM lips AS a
      FIELDS
      a~vgbel,
      a~vgpos,
       a~lfimg

      FOR ALL ENTRIES IN @it_itab
      WHERE a~vgbel = @it_itab-vbeln
        AND a~vgpos = @it_itab-posnr
*      GROUP BY a~vgbel, a~vgpos
      INTO TABLE @DATA(lt_lips_t).
    IF lt_lips_t IS NOT INITIAL.
      SELECT FROM @lt_lips_t AS a
        FIELDS
        a~vgbel,
        a~vgpos,
        SUM( lfimg ) AS lfimg
        GROUP BY a~vgbel, a~vgpos
        INTO TABLE @DATA(lt_lips).

      SORT lt_lips BY vgbel vgpos.
    ENDIF.

    SELECT FROM wb2_v_vbrk_vbrp2 AS a
       FIELDS
       a~aubel_i,
       a~aupos_i,
       a~fkimg_i
       FOR ALL ENTRIES IN @it_itab
       WHERE a~aubel_i = @it_itab-vbeln
         AND a~aupos_i = @it_itab-posnr
         AND a~fksto = @space
       INTO TABLE @DATA(lt_vbrp_t).

    IF lt_vbrp_t IS NOT INITIAL.
      SELECT FROM @lt_vbrp_t AS a
        FIELDS
        a~aubel_i AS aubel,
        a~aupos_i AS aupos,
        SUM( fkimg_i ) AS fkimg
        GROUP BY a~aubel_i, a~aupos_i
        INTO TABLE @DATA(lt_vbrp).
      SORT lt_vbrp BY aubel aupos.
    ENDIF.
    CLEAR: lt_lips_t, lt_vbrp_t.

* Read status
    SELECT FROM jest AS a
        LEFT OUTER JOIN tj30t AS b ON b~stsma  = 'OR_ITEM'
                                  AND b~estat = a~stat
                                  AND spras  = @sy-langu
      FIELDS
      a~objnr,
      b~stsma,
      a~stat,
      b~txt04,
      b~txt30
      FOR ALL ENTRIES IN @it_itab
      WHERE a~objnr = @it_itab-objnr
        AND a~stat IN @s_stat
        AND inact NE 'X'
      INTO TABLE @DATA(lt_jest).

* Header status
    SELECT FROM jest AS a
        LEFT OUTER JOIN tj30t AS b ON b~stsma  = 'OR_HEADR'
                                  AND b~estat = a~stat
                                  AND spras  = @sy-langu
      FIELDS
      a~objnr,
      b~stsma,
      a~stat,
      b~txt04,
      b~txt30
      FOR ALL ENTRIES IN @it_itab
      WHERE a~objnr = @it_itab-objnr_ak
        AND a~stat IN @s_stat
        AND inact NE 'X'
      APPENDING TABLE @lt_jest.


    SORT lt_jest BY objnr stsma.

* Read mska
    SELECT FROM mska AS a
          INNER JOIN @it_itab AS b ON b~vbeln = a~vbeln
                                  AND b~posnr = a~posnr
                                  AND b~matnr = a~matnr
                                  AND b~werks = a~werks
      FIELDS
          a~vbeln,
          a~posnr,
          a~matnr,
          a~werks,
*          a~lgort,
*          SUM(  a~kalab ) as klab
          SUM( CASE a~lgort WHEN 'KTPI' THEN a~kalab
                            ELSE 0 END ) AS stock_qty_ktpi,
          SUM( CASE a~lgort WHEN 'TPI1' THEN a~kalab
                            ELSE 0 END ) AS stock_qty_tpi1,
          SUM( CASE a~lgort WHEN 'KTPI' THEN 0
                            WHEN 'TPI1' THEN 0
                            ELSE a~kalab END ) AS stock_Qty,

          SUM( a~kains ) AS kains

      GROUP BY a~matnr, a~werks,  a~vbeln, a~posnr  ", a~lgort
      INTO TABLE @DATA(lt_mska_tmp).
    SORT lt_mska_tmp BY vbeln posnr matnr werks.
    lt_mska = lt_mska_tmp.
    CLEAR: lt_mska_Tmp.

* unique sales orders
    gt_so = CORRESPONDING #( it_itab MAPPING vbeln = vbeln
                                             posnr = posnr ).
    SORT gt_so BY vbeln posnr.
*    DELETE ADJACENT DUPLICATES FROM gt_so COMPARING vbeln.
    PERFORM read_hdtext USING gt_so.

* MATERIAL TEXT
    gt_mattxt = CORRESPONDING #( it_itab MAPPING matnr = matnr  ).
    SORT gt_mattxt BY matnr.
    DELETE ADJACENT DUPLICATES FROM gt_mattxt COMPARING matnr.
    PERFORM read_matext CHANGING gt_mattxt.

* To read latest cost of material
    IF gt_mattxt IS NOT INITIAL.
*      SELECT * FROM KONH INTO TABLE IT_KONH WHERE KOTABNR = '508'
*                                              AND KSCHL  = 'ZESC'
**                                              AND vakey = wa_output-matnr     ""commented by sonu
*                                              AND KNUMH = WA_OUTPUT-MATNR
*                                              AND DATAB <= SY-DATUM
*                                              AND DATBI >= SY-DATUM .

    ENDIF.

* Check bom exists for those materials
    IF gt_mattxt IS NOT INITIAL.
      SELECT FROM @gt_maTtxt AS a
          INNER JOIN mast AS b ON b~matnr = a~matnr
                              AND b~werks = 'PL01'
      FIELDS
        a~matnr

        INTO TABLE @DATA(lt_mast).
      SORT lt_mast BY matnr.
      DELETE ADJACENT DUPLICATES FROM lt_mast COMPARING matnr.

    ENDIF.

* stock
    SELECT FROM mbew AS a
      FIELDS
      a~matnr,
      a~bwkey,
      a~laepr,
      a~stprs
      FOR ALL ENTRIES IN @it_itab
        WHERE a~matnr = @it_itab-matnr
          AND a~bwkey = @it_itab-werks
      INTO TABLE @DATA(lt_mbew).
    SORT lt_mbew BY matnr bwkey.

* WIP
*    gt_so
    SELECT FROM afpo AS a
        INNER JOIN caufv AS b ON b~aufnr = a~aufnr
                                  AND b~kdauf = a~kdauf
                                  AND b~kdpos = a~kdpos
                                  AND b~loekz = @space
      FIELDS
      a~kdauf,
      a~kdpos,
      a~aufnr,
      a~posnr,
      a~matnr,
      a~pgmng,
      a~psmng,
      a~wemng,
      b~objnr,
      b~igmng
      FOR ALL ENTRIES IN @gt_so
      WHERE a~kdauf = @gt_so-vbeln
        AND a~kdpos = @gt_so-posnr
*        AND a~matnr = @gt_so-matnr
      INTO TABLE @DATA(lt_afpo).

    SORT lt_afpo BY objnr.
    IF lt_afpo IS NOT INITIAL.
      SELECT FROM jest AS a
        FIELDS
        a~objnr,
        a~stat
        FOR ALL ENTRIES IN @lt_afpo
        WHERE a~objnr = @lt_afpo-objnr
          AND a~inact = ' '
        INTO TABLE @DATA(lt_afpojest).
      SORT lt_afpojest BY objnr stat.

    ENDIF.
    SORT lt_afpo BY kdauf kdpos matnr.
  ENDIF.

  CLEAR:gt_so.
* End mska

* To read pricing.
  lt_knumv = CORRESPONDING #( it_itab MAPPING knumv = knumv ).
  SORT lt_knumv BY knumv.
  DELETE ADJACENT DUPLICATES FROM lt_knumv COMPARING knumv.
  IF lt_knumv IS NOT INITIAL.
    SELECT FROM  prcd_elements AS a
          INNER JOIN @lt_knumv AS b ON b~knumv = a~knumv
      FIELDS
       a~knumv,
       a~kposn,
       SUM( CAST( CASE WHEN a~kschl = 'ZPR0' THEN a~kbetr
             ELSE 0 END AS DEC( 15, 2 ) ) ) AS zpr0,
       SUM( CASE WHEN a~kschl = 'ZPF0' THEN a~kwert
             ELSE 0 END ) AS zpf0,
       SUM( CASE WHEN a~kschl = 'ZIN1' THEN a~kwert
             ELSE 0 END ) AS zin1,
       SUM( CASE WHEN a~kschl = 'ZIN2' THEN a~kwert
             ELSE 0 END ) AS zin2,
       SUM( CASE WHEN a~kschl = 'JOIG' THEN a~kwert
             ELSE 0 END ) AS joig,
       SUM( CASE WHEN a~kschl = 'JOCG' THEN a~kwert
             ELSE 0 END ) AS jocg,
       SUM( CASE WHEN a~kschl = 'JOSG' THEN a~kwert
             ELSE 0 END ) AS josg,
       CAST( SUM( CASE WHEN a~kschl = 'ZDIS' THEN a~kbetr
             ELSE 0 END ) AS DEC( 11, 2 ) ) AS dis_rate,
       SUM( CASE WHEN a~kschl = 'ZDIS' THEN a~kwert
*             ELSE 0 END ) AS dis_rate_amt,
             ELSE 0 END ) AS dis_amt,
       CAST( SUM( CASE WHEN a~kschl = 'VPRS' THEN a~kbetr
             ELSE 0 END ) AS DEC( 17, 4 ) ) AS in_price,
       CAST( SUM( CASE WHEN a~kschl = 'ZESC' THEN a~kbetr
             ELSE 0 END ) AS DEC( 17, 4 ) ) AS est_cost,
* Tax percentage %
       CAST( SUM( CASE WHEN a~kschl = 'JOCG' THEN a~kbetr
             ELSE 0 END ) AS DEC( 9, 2 ) ) AS cgst,
       CAST( SUM( CASE WHEN a~kschl = 'JOSG' THEN a~kbetr
             ELSE 0 END ) AS DEC( 9, 2 ) ) AS sgst,
       CAST( SUM( CASE WHEN a~kschl = 'JOIG' THEN a~kbetr
             ELSE 0 END ) AS DEC( 9, 2 ) ) AS igst,
       CAST( SUM( CASE WHEN a~kschl = 'JTC1' THEN a~kbetr
             ELSE 0 END ) AS DEC( 9, 2 ) ) AS tcs,
       CAST( SUM( CASE WHEN a~kschl = 'JTC1' THEN a~kwert
             ELSE 0 END ) AS DEC( 11, 2 ) ) AS tcs_amt

       WHERE a~kinak = @space
       GROUP BY a~knumv, kposn
       INTO TABLE @DATA(lt_konv1).
    SORT lt_konv1 BY knumv kposn.
    CLEAR: lt_knumv.
  ENDIF.
* End of pricing.

  DATA: ls_TEXT   TYPE ty_TEXT,
        lt_bstkd  TYPE tty_bstkd,
        ls_output TYPE ty_output.

* Read US Customer name from text
  lt_bstkd = CORRESPONDING #( it_itab MAPPING bstkd = bstkd ).
  SORT lt_bstkd BY bstkd.
  DELETE ADJACENT DUPLICATES FROM lt_bstkd COMPARING bstkd.

  PERFORM read_bstkd_Text CHANGING lt_bstkd.
* End of reading US Customer name

*  DATA: lv_kbetr TYPE prcd_elements-kbetr.
  DATA: lv_kbetr TYPE vfprc_element_value.

  SORT it_itab BY vbeln posnr.
*    write:/'Loop Start: ', sy-uzeit.
  LOOP AT it_itab ASSIGNING FIELD-SYMBOL(<f1>).
    CLEAR: ls_output.
    DATA(ls_konv) = VALUE #( lt_konv1[ knumv = <f1>-knumv
                                       kposn = <f1>-posnr ] OPTIONAL ).

    MOVE-CORRESPONDING ls_konv TO <f1>.
* Stock qty
*    DATA(lt_mska_tmp) = lt_mska.
*    DELETE lt_mska_tmp WHERE vbeln <> <f1>-vbeln.
*    DELETE lt_mska_tmp WHERE posnr <> <f1>-posnr.

*    LOOP AT lt_mska_tmp INTO DATA(ls_mska) WHERE vbeln = <f1>-vbeln
*                                             AND posnr = <f1>-posnr
*                                             AND matnr = <f1>-matnr
*                                             AND werks = <f1>-werks.
*      CASE ls_mska-lgort.
*        WHEN 'KTPI'.  ls_OUTPUT-stock_qty_ktpi = ls_OUTPUT-stock_qty_ktpi + ls_MSKA-kalab.
*        WHEN 'TPI1'.  ls_OUTPUT-stock_qty_tpi1 = ls_OUTPUT-stock_qty_tpi1 + ls_MSKA-kalab.
*        WHEN OTHERS.  ls_output-stock_Qty = ls_output-stock_Qty + ls_MSKA-kalab.
*      ENDCASE.
*
*      ls_output-qmqty = ls_output-qmqty + ls_mska-kains.
*    ENDLOOP.

    DATA(ls_mska) = VALUE #( lt_mska[ vbeln = <f1>-vbeln
                                      posnr = <f1>-posnr
                                      matnr = <f1>-matnr
                                      werks = <f1>-werks ] OPTIONAL  ).
    ls_OUTPUT-stock_qty_ktpi = ls_mska-stock_qty_ktpi.
    ls_OUTPUT-stock_qty_tpi1 = ls_mska-stock_qty_tpi1.
    ls_OUTPUT-stock_Qty = ls_mska-stock_Qty.
    ls_OUTPUT-qmqty = ls_mska-kains.
    CLEAR: ls_mska.
** Fill text
*    PERFORM fill_text USING <f1>-vbeln <f1>-posnr CHANGING ls_TEXT.
*    MOVE-CORRESPONDING ls_TEXT TO <f1>.


*    begin of code Added by sagar darade on 16/03/2026 to get target qty based on type zess or zser
    IF <f1>-auart = 'ZESS' OR <f1>-auart = 'ZSER' .
      <f1>-kwmeng = <f1>-zmeng.
    ENDIF.
*    end of code Added by sagar darade on 16/03/2026

    <f1>-mattxt = VALUE #( Gt_mattxt[ matnr = <f1>-matnr ]-mattxt OPTIONAL ).
    <f1>-status = VALUE #( lt_jest[ objnr = <f1>-objnr
                                    stsma  = 'OR_ITEM' ]-txt30 OPTIONAL ).
    <f1>-txt04 = VALUE #( lt_jest[ objnr = <f1>-objnr_ak
                                    stsma  = 'OR_HEADR' ]-txt04 OPTIONAL ).

    <f1>-lfimg = VALUE #( lt_lips[ vgbel = <f1>-vbeln
                                   vgpos = <f1>-posnr ]-lfimg OPTIONAL ).

    <f1>-fkimg = VALUE #( lt_vbrp[ aubel = <f1>-vbeln
                                   aupos = <f1>-posnr ]-fkimg OPTIONAL ).
    <f1>-pnd_qty = <f1>-kwmeng - <f1>-fkimg.
    MOVE-CORRESPONDING ls_konv TO <f1>.
    <f1>-kbetr = ls_konv-zpr0.    "Rate

    IF <f1>-waerk = 'INR'.
      <f1>-curr_con = 1.
    ELSE.
      <f1>-curr_con = VALUE #( gt_exchrate[ rate_TYPE = 'B'
                                            from_curr = <f1>-waerk ]-exch_rate  OPTIONAL ).
    ENDIF.

*    <f1>-dis_unit_rate = ls_konv-zpr0 - ( - ls_konv-dis_amt ).
    <f1>-dis_rate = abs( ls_konv-dis_rate ).
    lv_kbetr = ( ls_konv-zpr0 * ls_konv-dis_rate ) / 100.
    <f1>-dis_amt = abs( lv_kbetr ).
    <f1>-dis_unit_rate = lv_kbetr - ( - ls_konv-zpr0 ).

    <f1>-amont = <f1>-pnd_qty * <f1>-dis_unit_rate * <f1>-curr_con.
    <f1>-ordr_amt = <f1>-kwmeng * <f1>-dis_unit_rate * <f1>-curr_con.

* Internal price date & Standard cost
    <f1>-in_pr_dt = VALUE #( lt_mbew[ matnr = <f1>-matnr
                                      bwkey = <f1>-werks ]-laepr OPTIONAL ).
    <f1>-st_cost = VALUE #( lt_mbew[ matnr = <f1>-matnr
                                     bwkey = <f1>-werks ]-stprs OPTIONAL ).

    <f1>-schid = |{ <f1>-vbeln ALPHA = OUT }-{ <f1>-posnr ALPHA = OUT }|.
* Ship-to party details
    DATA(ls_vbpa) = VALUE #( lt_vbpa[ vbeln = <f1>-vbeln posnr = <f1>-posnr parvw = 'WE' ] OPTIONAL ).
    IF ls_vbpa IS INITIAL.
      ls_vbpa = VALUE #( lt_vbpa[ vbeln = <f1>-vbeln parvw = 'WE' ] OPTIONAL ).
    ENDIF.
    <f1>-ship_kunnr = ls_vbpa-kunnr.
    <f1>-ship_land = ls_vbpa-land1.
    <f1>-ship_kunnr_n = ls_vbpa-name1.
    <f1>-s_land_desc = ls_vbpa-landx50.
    <f1>-ship_reg_n = ls_vbpa-bezei.
    ls_output-kurst = VALUE #( it_knvv[ kunnr = ls_vbpa-kunnr ]-kurst OPTIONAL ).
*    <f1>-ship_reg_n = VALUE #( lt_zgst_region[ region = ls_vbpa-region ]-bezei OPTIONAL ) .
    CLEAR: ls_vbpa.
    ls_vbpa = VALUE #( lt_vbpa[ vbeln = <f1>-vbeln parvw = 'AG' ] OPTIONAL ).
    <f1>-sold_land = ls_vbpa-land1.
    <f1>-sold_reg_n = ls_vbpa-bezei.
    <f1>-port   = ls_vbpa-name1.
*    <f1>-sold_reg_n = VALUE #( lt_zgst_region[ region = ls_vbpa-region ]-bezei OPTIONAL ) .

* MRP Date
    <f1>-mrp_dt = VALUE #( lt_cdpos[ vbeln = <f1>-vbeln
                                     posnr = <f1>-posnr ]-udate OPTIONAL ).

* Account assignment group text
    <f1>-act_ass = VALUE #( lT_TVKTT[ ktgrd = <f1>-ktgrd ]-vtext OPTIONAL ).

* BOM Exists
    <f1>-bom_exist  = COND #( WHEN <f1>-matnr = VALUE #( lt_mast[ matnr = <f1>-matnr ]-matnr OPTIONAL ) THEN 'Yes'
                              ELSE 'No' ).
* US Customer name
    <f1>-us_cust = VALUE #( lt_bstkd[ bstkd = <f1>-bstkd ]-us_cust OPTIONAL ).

*    PERFORM change_Date_format USING <f1>-aedat1 CHANGING <f1>-udate.

* WIP
    CLEAR: <f1>-wip.
    READ TABLE lt_afpo INTO DATA(ls_afpo) WITH KEY kdauf = <f1>-vbeln
                                                   kdpos = <f1>-posnr
                                                   matnr = <f1>-matnr BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      DATA(lv_idx) = sy-tabix.
    ENDIF.

    LOOP AT lt_afpo INTO ls_afpo FROM lv_idx.
      IF    ls_afpo-kdauf = <f1>-vbeln
        AND ls_afpo-kdpos = <f1>-posnr
        AND ls_afpo-matnr = <f1>-matnr.
      ELSE.
        EXIT.
      ENDIF.
*    LOOP AT lt_afpo INTO DATA(ls_afpo) WHERE kdauf = <f1>-vbeln
*                                         AND kdpos = <f1>-posnr
*                                         AND matnr = <f1>-matnr.
      DATA(ls_jest) = VALUE #( lt_afpojest[ objnr = ls_afpo-objnr stat = 'I0012' ] OPTIONAL ).
      IF ls_jest IS INITIAL.
        ls_jest = VALUE #( lt_afpojest[ objnr = ls_afpo-objnr stat = 'I0009' ] OPTIONAL ).
        IF ls_jest IS INITIAL.
          ls_jest = VALUE #( lt_afpojest[ objnr = ls_afpo-objnr stat = 'I0002' ] OPTIONAL ).
          IF ls_jest IS NOT INITIAL.
            <f1>-wip =  <f1>-wip + ls_afpo-psmng - ls_afpo-igmng.
          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR: ls_jest.
    ENDLOOP.
    CLEAR: lv_idx.

* Fill GT_output.
    MOVE-CORRESPONDING <f1> TO ls_output.
*    ls_output = CORRESPONDING #( <f1> ).
    WRITE <f1>-zpr0     TO ls_output-zpr0 NO-GROUPING.
    WRITE <f1>-zpf0     TO ls_output-zpf0       NO-GROUPING.
    WRITE <f1>-zin1     TO ls_output-zin1       NO-GROUPING.
    WRITE <f1>-zin2     TO ls_output-zin2       NO-GROUPING.
    WRITE <f1>-joig     TO ls_output-joig       NO-GROUPING.
    WRITE <f1>-jocg     TO ls_output-jocg       NO-GROUPING.
    WRITE <f1>-josg     TO ls_output-josg       NO-GROUPING.
    WRITE <f1>-dis_rate TO ls_output-dis_rate      NO-GROUPING.
    WRITE <f1>-dis_amt          TO ls_output-dis_amt      NO-GROUPING.
    WRITE <f1>-dis_unit_rate    TO ls_output-dis_unit_rate NO-GROUPING.

    WRITE <f1>-kbetr            TO ls_output-kbetr NO-GROUPING. CONDENSE ls_output-kbetr.
    WRITE <f1>-amont            TO ls_output-amont NO-GROUPING.
    WRITE <f1>-ordr_amt         TO ls_output-ordr_amt NO-GROUPING.
    WRITE <f1>-in_price         TO ls_output-in_price NO-GROUPING.
    WRITE ls_konv-est_cost      TO ls_output-est_cost NO-GROUPING.
*    WRITE <f1>-latst_cost   TO ls_output-latst_cost NO-GROUPING.
    WRITE <f1>-st_cost          TO ls_output-st_cost NO-GROUPING.
*    WRITE <f1>-tot_ass        TO ls_output-tot_ass NO-GROUPING.
*    WRITE <f1>-ass2_val        TO ls_output-ass2_val NO-GROUPING.
*    WRITE <f1>-stock_Qty     TO ls_output-stock_Qty NO-GROUPING.
* Remove thousand separator
* To remove any empty spaces
    CONDENSE: ls_output-zpr0, ls_output-zpf0, ls_output-zin1, ls_output-zin2, ls_output-joig,
              ls_output-jocg, ls_output-josg, ls_output-dis_rate, ls_output-dis_amt, ls_output-dis_unit_rate,
              ls_output-kbetr,ls_output-amont, ls_output-ordr_amt,ls_output-in_price,ls_output-est_cost, ls_output-st_cost.
* Date conversion
    PERFORM change_Date_format USING <f1>-erdat CHANGING ls_output-erdat.
    PERFORM change_Date_format USING <f1>-vdatu CHANGING ls_output-vdatu.
    PERFORM change_Date_format USING <f1>-holddate CHANGING ls_output-holddate.
    PERFORM change_Date_format USING <f1>-reldate CHANGING ls_output-reldate.
    PERFORM change_Date_format USING <f1>-canceldate CHANGING ls_output-canceldate.
    PERFORM change_Date_format USING <f1>-deldate CHANGING ls_output-deldate.
    PERFORM change_Date_format USING <f1>-edatu CHANGING ls_output-edatu.
    PERFORM change_Date_format USING <f1>-ofm_date1 CHANGING ls_output-ofm_date1.
    PERFORM change_Date_format USING <f1>-custdeldate CHANGING ls_output-custdeldate.
    PERFORM change_Date_format USING sy-datum CHANGING ls_output-ref_dt.
    PERFORM change_Date_format USING <f1>-bstdk CHANGING ls_output-bstdk.
    PERFORM change_Date_format USING <f1>-po_del_date CHANGING ls_output-po_del_date.
    PERFORM change_Date_format USING <f1>-date CHANGING ls_output-date.
    PERFORM change_Date_format USING <f1>-prsdt CHANGING ls_output-prsdt.
    PERFORM change_Date_format USING <f1>-chang_so_date CHANGING ls_output-chang_so_date.
    PERFORM change_Date_format USING <f1>-udate CHANGING ls_output-udate.
    PERFORM change_Date_format USING <f1>-zmrp_date CHANGING ls_output-zmrp_date.
    PERFORM change_Date_format USING <f1>-zexp_mrp_date1 CHANGING ls_output-zexp_mrp_date1.

    PERFORM change_Date_format USING <f1>-zldfromdate CHANGING ls_output-zldfromdate.
    PERFORM change_Date_format USING <f1>-in_pr_dt CHANGING ls_output-in_pr_dt.
    PERFORM change_Date_format USING <f1>-mrp_dt CHANGING ls_output-mrp_dt.

*    PERFORM change_Date_format USING <f1>-ofm_date1 CHANGING ls_output-ofm_date1.
    PERFORM change_Date_format USING <f1>-receipt_date CHANGING ls_output-receipt_date.
*    PERFORM change_Date_format USING <f1>-review_date CHANGING ls_output-review_date.

* Header text
    ls_text = VALUE #( gt_htext[ vbeln = <f1>-vbeln posnr = '000000' ] OPTIONAL ).
    MOVE-CORRESPONDING ls_TEXT TO ls_output.
    CLEAR: ls_text.
* Item text
    ls_text = VALUE #( gt_itmtext[ vbeln = <f1>-vbeln posnr = <f1>-posnr ] OPTIONAL ).
    MOVE-CORRESPONDING ls_TEXT TO ls_output.

    ls_output-vbeln = <f1>-vbeln.
    ls_output-posnr = <f1>-posnr.
    APPEND ls_output TO gt_output.
*Clear
    CLEAR: ls_konv, ls_mska, ls_TEXT, ls_vbpa, lv_kbetr, ls_output.
  ENDLOOP.
*    write:/'Loop ends: ', sy-uzeit.
  UNASSIGN <f1>.

*  gt_output = CORRESPONDING #( it_itab ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  PERFORM stp3_eventtab_build   CHANGING gt_events[].
  PERFORM comment_build         CHANGING i_list_top_of_page[].
  PERFORM top_of_page.
  PERFORM layout_build          CHANGING wa_layout.
****************************************************************************************

  PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
  PERFORM build_fieldcat USING 'AUART'          'X' '2'   'Order Type'(004)               '15'.
  PERFORM build_fieldcat USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15'.
  PERFORM build_fieldcat USING 'NAME1'          'X' '4'   'Customer'(006)                 '15'.
  PERFORM build_fieldcat USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15'.
  PERFORM build_fieldcat USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15'.
  PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15'.
  PERFORM build_fieldcat USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15'."(010).
  PERFORM build_fieldcat USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15'.
  PERFORM build_fieldcat USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15'.
  PERFORM build_fieldcat USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15'.
  PERFORM build_fieldcat USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15'.
  PERFORM build_fieldcat USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15'. "(015)
  PERFORM build_fieldcat USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '50'.
  PERFORM build_fieldcat USING 'TPI'            'X' '15'  'TPI Required'(044)             '50'.
  PERFORM build_fieldcat USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '50'.
  PERFORM build_fieldcat USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15'.
  PERFORM build_fieldcat USING 'ZLDMAX'        'X' '18'  'LD % Max'(047)                  '15'.
  PERFORM build_fieldcat USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'.
*  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).
*  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
  PERFORM build_fieldcat USING 'MATNR'          'X' '20'   'Item Code'(016)               '18'.
*  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
  PERFORM build_fieldcat USING 'POSNR'          'X' '21'   'Line Item'(017)               '15'.
  PERFORM build_fieldcat USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20'.
  PERFORM build_fieldcat USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15'.
*  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
  PERFORM build_fieldcat USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15'.
  PERFORM build_fieldcat USING 'LFIMG'          'X' '25'   'Delivary Qty'(021)            '15'.
  PERFORM build_fieldcat USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15'.
  PERFORM build_fieldcat USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15'.
  PERFORM build_fieldcat USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15'.
  PERFORM build_fieldcat USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15'.
  PERFORM build_fieldcat USING 'EDATU'          'X' '30'   'Production date'              '15'.   "'Posting Date'(025).
  PERFORM build_fieldcat USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'.
  PERFORM build_fieldcat USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'.
  PERFORM build_fieldcat USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15'.
  PERFORM build_fieldcat USING 'SO_EXC'       'X' '34'   'SO Exchange Rate'(051)          '15'.
  PERFORM build_fieldcat USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15'.
  PERFORM build_fieldcat USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15'.
*  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
  PERFORM build_fieldcat USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15'.
  PERFORM build_fieldcat USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15'.
  PERFORM build_fieldcat USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'.
  PERFORM build_fieldcat USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'.
  PERFORM build_fieldcat USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'.
  PERFORM build_fieldcat USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15'.
  PERFORM build_fieldcat USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15'.
  PERFORM build_fieldcat USING 'BRAND'           'X' '44'   'Brand'(039)                  '15'.
  PERFORM build_fieldcat USING 'MOC'             'X' '45'   'MOC'(040)                    '15'.
  PERFORM build_fieldcat USING 'TYPE'            'X' '46'   'Type'(041)                   '15'.
  """"""""""""'   Added By KD on 04.05.2017    """""""
  PERFORM build_fieldcat USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15'.
  PERFORM build_fieldcat USING 'WIP'              'X' '48'   'WIP'(052)                   '15'.
  PERFORM build_fieldcat USING 'MTART'            'X' '49'   'MAT TYPE'                   '15'.
  PERFORM build_fieldcat USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15'.
  PERFORM build_fieldcat USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15'.
  PERFORM build_fieldcat USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'.
  PERFORM build_fieldcat USING 'MATTXT'           'X' '53'   'Material Text'              '20'.
  PERFORM build_fieldcat USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50'.
  PERFORM build_fieldcat USING 'ETENR'            'X' '55'   'Schedule_no'                '15'.
  PERFORM build_fieldcat USING 'SCHID'            'X' '56'   'Schedule_id'                'string'.
  PERFORM build_fieldcat USING 'ZTERM'            'X' '57'   'Payment Terms'              '15'.
  PERFORM build_fieldcat USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15'.
  PERFORM build_fieldcat USING 'INCO1'            'X' '59'   'Inco Terms'                 '15'.
  PERFORM build_fieldcat USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15'.
  PERFORM build_fieldcat USING 'OFM'              'X' '61'   'OFM No.'                    '15'.
  PERFORM build_fieldcat USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15'.
  PERFORM build_fieldcat USING 'SPL'              'X' '63'   'Special Instruction'        '15'.
  PERFORM build_fieldcat USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15'.   "(015).
  PERFORM build_fieldcat USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM build_fieldcat USING 'WRKST'            'X' '67'  'USA Item Code'                '15'.
  PERFORM build_fieldcat USING 'CGST'             'X' '68'  'CGST%'                        '15'.
*  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
  PERFORM build_fieldcat USING 'SGST'             'X' '70'  'SGST%'                        '15'.
*  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
  PERFORM build_fieldcat USING 'IGST'              'X' '72'  'IGST%'                       '15'.
*  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15'.
  PERFORM build_fieldcat USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15'.
  PERFORM build_fieldcat USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15'.
  PERFORM build_fieldcat USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15'.
*  perform build_fieldcat using 'NORMT'              'X' '77'       'Industry Std Desc.'           '15'.
  PERFORM build_fieldcat USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15'.
  PERFORM build_fieldcat USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15'.
  PERFORM build_fieldcat USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15'.
  PERFORM build_fieldcat USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15'.
  PERFORM build_fieldcat USING 'BSTDK'              'X' '82' 'PO Date'                        '15'.
  PERFORM build_fieldcat USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'.
  PERFORM build_fieldcat USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15'.
  PERFORM build_fieldcat USING 'INSUR'              'X' '85' 'Insurance'               '15'.
  PERFORM build_fieldcat USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15'.
  PERFORM build_fieldcat USING 'GAD'                'X' '87' 'GAD'               '15'.
  PERFORM build_fieldcat USING 'US_CUST'            'X' '88' 'USA Customer Name'               '15'.
  PERFORM build_fieldcat USING 'TCS'                'X' '89' 'TCS Rate'               '15'.
  PERFORM build_fieldcat USING 'TCS_AMT'            'X' '90' 'TCS Amount'               '15'.
  PERFORM build_fieldcat USING 'PO_DEL_DATE'        'X' '91' 'PO_Delivery_Date'               '15'.
  PERFORM build_fieldcat USING 'OFM_NO'             'X' '92' 'OFM SR. NO.'               '15'.
  PERFORM build_fieldcat USING 'CTBG'              'X' '93' 'CTBG Item Details'               '20'.
  PERFORM build_fieldcat USING 'CERTIF'             'X' '94' 'Certificate Details'             '20'.
  PERFORM build_fieldcat USING 'ITEM_TYPE'             'X' '95' 'Item Type'             '20'. "edited by PJ on16-08-21
  PERFORM build_fieldcat USING 'REF_TIME'             'X' '96' 'Ref. Time'             '15'. "edited by PJ on 08-09-21
*  PERFORM build_fieldcat USING 'CTBG'             'X' '94' 'CTBG Details'             '10'.

  """""""""""""""" "added by pankaj 28.01.2022""""""""""""""""

  PERFORM build_fieldcat USING 'PROJ'               'X' '97' 'Project Owner Details'             '15'.
  PERFORM build_fieldcat USING 'COND'               'X' '98' 'Condition Delivery Date'             '15'.
  PERFORM build_fieldcat USING 'RECEIPT_DATE'       'X' '99' 'Code Receipt Date'             '15'.
  PERFORM build_fieldcat USING 'REASON'             'X' '100' 'Reason'             '15'.
  PERFORM build_fieldcat USING 'NTGEW'             'X' '101' 'Net Weight'             '15'.
  PERFORM build_fieldcat USING 'ZPR0'             'X' '102' 'Condition ZPR0'           '15'.
  PERFORM build_fieldcat USING 'ZPF0'             'X' '103' 'Condition ZPF0'           '15'.
  PERFORM build_fieldcat USING 'ZIN1'               'X' '104' 'Condition ZIN1'           '15'.
  PERFORM build_fieldcat USING 'ZIN2'               'X' '105' 'Condition ZIN2'           '15'.
  PERFORM build_fieldcat USING 'JOIG'               'X' '106' 'Condition JOIG'           '15'.
  PERFORM build_fieldcat USING 'JOCG'               'X' '107' 'Condition JOCG'           '15'.
  PERFORM build_fieldcat USING 'JOSG'               'X' '108' 'Condition JOSG'           '15'.
  PERFORM build_fieldcat USING 'DATE'               'X' '109' 'Schedule line del.Date'  '15'.
  PERFORM build_fieldcat USING 'PRSDT'               'X' '110' 'Pricing Date'            '15'.
  PERFORM build_fieldcat USING 'PACKING_TYPE'               'X' '111' 'Packing Type'            '15'.
  PERFORM build_fieldcat USING 'OFM_DATE1'               'X' '112' 'OFM Delivery Date'            '15'.
  PERFORM build_fieldcat USING 'MAT_TEXT'               'X' '113' 'Material Sales Text'            '15'.
  "PERFORM build_fieldcat USING 'ERDAT1'               'X' '113' 'SO Change Date '            '15'.

  """""""""""""""""""""""" ended """"""""""""""""""""""""""""""""""'
*infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary
  """"""""""""""""""""""""Coded added by pankaj 31.01.2022  """"""""""""""""""""""""""""

  PERFORM build_fieldcat USING 'INFRA'                    'X' '114' 'Infrastructure Required'            '15'.
  PERFORM build_fieldcat USING 'VALIDATION'               'X' '115' 'Validation Plan Refrence'            '15'.
  PERFORM build_fieldcat USING 'REVIEW_DATE'              'X' '116' 'Review Date'            '15'.
  PERFORM build_fieldcat USING 'DISS_SUMMARY'             'X' '117' 'Discussion Summary'            '15'.
  PERFORM build_fieldcat USING 'CHANG_SO_DATE'            'X' '118' 'Changed SO Date'            '15'.

  """"""" added by pankaj 04.02.2022"""""""""""""""

  PERFORM build_fieldcat USING 'PORT'                     'X'       '119' 'Port'                         '15'.
  PERFORM build_fieldcat USING 'FULL_PMNT'                'X'       '120' 'Full Payment Desc'            '15'.
  PERFORM build_fieldcat USING 'ACT_ASS'                  'X'       '121' 'Act Assignments'            '15'.
  PERFORM build_fieldcat USING 'TXT04'                    'X'       '122' 'User Status'            '15'.
*  perform build_fieldcat using 'KWERT'                    'X'       '123' 'Condition Value ZPR0'            '15'.
  PERFORM build_fieldcat USING 'FREIGHT'                  'X'       '124' 'Freight'            '15'.
  " PERFORM build_fieldcat USING 'OFM_SR_NO'               'X'       '125' 'OFM SR NO'            '15'.
  PERFORM build_fieldcat USING 'PO_SR_NO'                 'X'       '126' 'PO SR NO TEXT'            '15'.

  PERFORM build_fieldcat USING 'UDATE'                    'X'         '127' 'Last changed date'        '15'.
  PERFORM build_fieldcat USING 'BOM'                      'X'         '128' 'BOM Status'        '15'.
  PERFORM build_fieldcat USING 'ZPEN_ITEM'                      'X'         '129' 'Pending Items'        '15'.
  PERFORM build_fieldcat USING 'ZRE_PEN_ITEM'                      'X'         '130' 'Reason for Pending Items'        '15'.
*  perform build_fieldcat using 'VTEXT1'                      'X'         '131' 'Billing Block'        '15'.
  PERFORM build_fieldcat USING 'ZINS_LOC'                      'X'         '131' 'Installation Location'        '15'.
  PERFORM build_fieldcat USING 'BOM_EXIST'                      'X'         '132' 'BOM EXISTS '        '15'.
*   perform build_fieldcat using 'BSTKD1'          'X' '133'   'Line Item Wise PO No'    '15'."ADDED BY JYOTI ON 16.04.2024
  PERFORM build_fieldcat USING 'POSEX1'              'X' '134' 'PO Item No'               '15'."ADDED BY JYOTI ON 16.04.2024
  PERFORM build_fieldcat USING 'LGORT'              'X' '135' 'Storage Location'               '15'."ADDED BY Pranit ON 10.04.2024
  PERFORM build_fieldcat USING 'QUOTA_REF'              'X' '136' 'QT Reference No.'               '15'."ADDED BY jyoti ON 19.06.2024
  PERFORM build_fieldcat USING 'ZMRP_DATE'              'X' '137' 'DV_PLMRPDATE'               '15'."ADDED BY jyoti ON 02.07.2024


*********************************************************************************
  PERFORM build_fieldcat USING 'VKORG' 'X'  '138' 'Sales Organization'   '4'. " ADD BY SUPRIYA ON 19.08.2024
  PERFORM build_fieldcat USING 'VTWEG' 'X' '139'  'Distribution Channel' '2'." ADD BY SUPRIYA ON 19.08.2024
  PERFORM build_fieldcat USING 'SPART' 'X' '140'  'Division' '2'.               " ADD BY SUPRIYA ON 19.08.2024

*******************************************************************************
  PERFORM build_fieldcat USING 'ZEXP_MRP_DATE1'              'X' '141' 'Expected MRP Date'               '15'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'SPECIAL_COMM'                'X' '142' 'Special Comments'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'ZCUST_PROJ_NAME'                'X' '143' 'Customer Project NAme'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'AMENDMENT_HIS'                'X' '144' 'Amendment_history'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'PO_DIS'                'X' '145' 'Po Discrepancy'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'HOLD_REASON_N1'                'X' '146' 'Hold Reason'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM build_fieldcat USING 'DIS_RATE'                'X' '147' 'Dis %'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
  PERFORM build_fieldcat USING 'DIS_AMT'                'X' '148' 'Discount Amount'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
  PERFORM build_fieldcat USING 'DIS_UNIT_RATE'                'X' '149' 'Discount Unit Rate'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
  PERFORM build_fieldcat USING 'CUST_MAT_CODE'      'X' '150' 'Customer Material Code'     '40'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'OUTPUT'
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
*     it_sort            = i_sort
*     i_default          = 'A'
*     i_save             = 'A'
      i_save             = 'X'
      it_events          = gt_events[]
    TABLES
      t_outtab           = gT_OUTPUT
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  REFRESH gt_output.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

  DATA: lf_event TYPE slis_alv_event. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = p_gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  MOVE c_formname_top_of_page TO lf_event-form.
  MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
  DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR lf_line.
  lf_line-typ  = c_h.
  lf_line-info =  ''.
  APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
  CLEAR lf_line.
  lf_line-typ  = c_s.
  lf_line-key  = TEXT-043.
  lf_line-info = sy-datum.
  WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
  APPEND lf_line TO i_list_top_of_page.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_list_top_of_page[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

  wa_layout-colwidth_optimize = 'X'.
  wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.

ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
*  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
  wa_fcat-col_pos     =  v3.

  CASE v1.
    WHEN 'KWMENG'   OR 'STOCK_QTY' OR 'LFIMG' OR 'FKIMG'
      OR 'PND_QTY'  OR 'AMONT'
      OR 'KBETR'    OR 'ORDR_AMT'
      OR 'IN_PRICE' OR 'ST_COST'   OR 'NTGEW' OR 'ZPR0'
      OR 'DIS_RATE' OR 'DIS_AMT'   OR 'DIS_UNIT_RATE'.
*      wa_fcat-edit_mask = '==FLTPC' .       "To remove thousand separator, if -ve value then gives dump
      wa_fcat-edit_mask = '==DECZE'.         "To remove thousand separator, Handles -ve values
*    WHEN 'PND_QTY' OR 'AMONT'.
      wa_fcat-edit_mask = '==DECZE'.
    WHEN OTHERS.
  ENDCASE.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.

" BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*& Form read_hdtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SO
*&---------------------------------------------------------------------*
FORM read_hdtext  USING   put_so TYPE tty_so.
  TYPES:BEGIN OF ty_hdid,
          id TYPE tdid,
        END   OF ty_hdid,
        tty_hdid TYPE STANDARD TABLE OF ty_hdid.

  DATA: lt_hdid    TYPE tty_hdid,
        lv_name    TYPE thead-tdname,
        Lt_LINES   TYPE STANDARD TABLE OF tline,
        ls_hdtext  TYPE ty_hdtext,
        lt_so      TYPE tty_so,
        lt_hdtext  TYPE tty_hdtext,
        ls_text    TYPE ty_text,
        lt_htext   TYPE STANDARD TABLE OF ty_text,
        lt_itmtext TYPE STANDARD TABLE OF ty_text.

  CLEAR: gt_hdtext, gt_htext, gt_itmtext.
  lt_hdid = VALUE #( ( id = 'Z999' )    "WA_OUTPUT-TPI (50)
                     ( id = 'Z005' )    "WA_OUTPUT-FREIGHT (128)
                     ( id = 'Z012' )    "WA_OUTPUT-PACKING_TYPE (255)
                     ( id = 'Z015' )    "WA_OUTPUT-OFM (50)
                     ( id = 'Z016' )    "WA_OUTPUT-OFM_DATE (50)
                     ( id = 'Z017' )    "WA_OUTPUT-INSUR (250)
                     ( id = 'Z020' )    "WA_OUTPUT-SPL (255)
                     ( id = 'Z038' )    "WA_OUTPUT-LD_TXT (50)
                     ( id = 'Z039' )    "WA_OUTPUT-TAG_REQ (50)
                     ( id = 'Z047' )    "WA_OUTPUT-PARDEL (250)
                     ( id = 'Z062' )    "WA_OUTPUT-QUOTA_REF (128)
                     ( id = 'Z063' )    "WA_OUTPUT-ZCUST_PROJ_NAME (250)
                     ( id = 'Z064' )    "WA_OUTPUT-AMENDMENT_HIS (250)
                     ( id = 'Z065' )    "WA_OUTPUT-PO_DIS (250)
                     ( id = 'Z066' )    "OFM_REC_DATE
                     ( id = 'Z067' )    "OSS_REC_DATE
                     ( id = 'Z068' )    "SOURCE_REST
                     ( id = 'Z069' )    "SUPPL_REST
                     ( id = 'Z101' )    "WA_OUTPUT-FULL_PMNT (255)
                     ( id = 'Z102' )    "WA_OUTPUT-PROJ (255)
                     ( id = 'Z103' )    "WA_OUTPUT-COND (255)
                     ( id = 'Z104' )    "WA_OUTPUT-INFRA (255)
                     ( id = 'Z105' )    "WA_OUTPUT-VALIDATION (255)
                     ( id = 'Z106' )    "WA_OUTPUT-REVIEW_DATE (255)
                     ( id = 'Z107' )    "WA_OUTPUT-DISS_SUMMARY (255)
                   ).

  SORT lt_hdid BY id.

  lt_so = CORRESPONDING #( put_so ).

  SORT lt_so BY vbeln.
  DELETE ADJACENT DUPLICATES FROM lt_so COMPARING vbeln.

* For header text
  LOOP AT LT_so INTO DATA(ls_so).
    CLEAR: ls_text.
    lv_name = ls_so-vbeln.
    LOOP AT lt_hdid INTO DATA(ls_hdid).

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
*         id                      = 'Z999'
          id                      = ls_hdid-id
          language                = 'E'
          name                    = lv_name
          object                  = 'VBBK'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*         USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
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
*    READ TABLE lt_lines INTO wa_lines INDEX 1.

      ls_hdtext-vbeln = ls_so-vbeln.
      IF lt_lines IS NOT INITIAL.
        LOOP AT lt_lines INTO DATA(ls_line).
          CONCATENATE ls_hdtext-text ls_line-tdline INTO ls_hdtext-text SEPARATED BY space.
        ENDLOOP.
*        ls_hdtext-posnr = '000000'.
*        ls_hdtext-obj = 'VBBK'.
*        ls_hdtext-id = ls_hdid-id.
*        ls_hdtext-name = lv_name.
*        APPEND ls_hdtext TO lt_hdtext.
      ENDIF.

* New tab
      IF ls_hdtext-text IS NOT INITIAL.
        CASE ls_hdid-id.
          WHEN  'Z999' .      ls_Text-tpi           = ls_hdtext-text.
          WHEN  'Z005' .      ls_Text-freight       = ls_hdtext-text.
          WHEN  'Z012' .      ls_Text-packing_type  = ls_hdtext-text.
          WHEN  'Z015' .      ls_Text-ofm           = ls_hdtext-text.
          WHEN  'Z016' .      ls_Text-ofm_date      = ls_hdtext-text.
          WHEN  'Z017' .      ls_Text-insur         = ls_hdtext-text.
          WHEN  'Z020' .      ls_Text-spl           = ls_hdtext-text.
          WHEN  'Z038' .      ls_Text-ld_txt        = ls_hdtext-text.
          WHEN  'Z039' .      ls_Text-tag_req       = ls_hdtext-text.
          WHEN  'Z047' .      ls_Text-pardel        = ls_hdtext-text.
          WHEN  'Z062' .      ls_Text-quota_ref     = ls_hdtext-text.
          WHEN  'Z063' .      ls_Text-zcust_proj_name   = ls_hdtext-text.
          WHEN  'Z064' .      ls_Text-amendment_his = ls_hdtext-text.
          WHEN  'Z065' .      ls_Text-po_dis        = ls_hdtext-text.
          WHEN  'Z066' .      ls_Text-ofm_rec_date  = ls_hdtext-text.
          WHEN  'Z067' .      ls_Text-oss_rec_date  = ls_hdtext-text.
          WHEN  'Z068' .      ls_Text-source_rest   = ls_hdtext-text.
          WHEN  'Z069' .      ls_Text-suppl_rest    = ls_hdtext-text.
          WHEN  'Z101' .      ls_Text-full_pmnt     = ls_hdtext-text.
          WHEN  'Z102' .      ls_Text-proj          = ls_hdtext-text.
          WHEN  'Z103' .      ls_Text-cond          = ls_hdtext-text.
          WHEN  'Z104' .      ls_Text-infra         = ls_hdtext-text.
          WHEN  'Z105' .      ls_Text-validation    = ls_hdtext-text.
          WHEN  'Z106' .      ls_Text-review_date   = ls_hdtext-text.
          WHEN  'Z107' .      ls_Text-diss_summary  = ls_hdtext-text.

          WHEN OTHERS.
        ENDCASE.
      ENDIF.

      CLEAR: lt_lines, ls_hdtext.
    ENDLOOP.
    IF ls_Text IS NOT INITIAL.
      ls_text-vbeln = ls_so-vbeln.
      ls_text-posnr = '000000'.
      APPEND ls_Text TO lt_hText.
    ENDIF.
  ENDLOOP.

* For item text
  CLEAR: lt_hdid.
  lt_hdid = VALUE #( ( id = 'Z102' )    "WA_OUTPUT-OFM_NO (128)
                     ( id = 'Z888' )    "WA_OUTPUT-SPECIAL_COMM (250)
                     ( id = '0001' )    "WA_OUTPUT-ITMTXT (255), WA_OUTPUT-MAT_TEXT (15)
                     ( id = '0010' )    "WA_OUTPUT-ITMTXT (255), WA_OUTPUT-MAT_TEXT (15)
*                     ( id = 'Z061' )    "Not using
                     ( id = 'Z110' )    "CUST_MAT_DESC
                     ( id = 'Z103' )    "WA_OUTPUT-PO_SR_NO (128)
                   ).

  SORT lt_hdid BY id.

  lt_so = CORRESPONDING #( put_so ).

  SORT lt_so BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM lt_so COMPARING vbeln posnr.

  LOOP AT LT_so INTO ls_so.
    CLEAR: ls_Text.
    CONCATENATE ls_so-vbeln ls_so-posnr INTO lv_name.
    LOOP AT lt_hdid INTO ls_hdid.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = ls_hdid-id
          language                = 'E'
          name                    = lv_name
          object                  = 'VBBP'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*         USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
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
*    READ TABLE lt_lines INTO wa_lines INDEX 1.

      ls_hdtext-vbeln = ls_so-vbeln.
      IF lt_lines IS NOT INITIAL.
        LOOP AT lt_lines INTO ls_line.
          CONCATENATE ls_hdtext-text ls_line-tdline INTO ls_hdtext-text SEPARATED BY space.
        ENDLOOP.
*        ls_hdtext-posnr = ls_so-posnr.
*        ls_hdtext-obj = 'VBBP'.
*        ls_hdtext-id = ls_hdid-id.
*        ls_hdtext-name = lv_name.
*        APPEND ls_hdtext TO lt_hdtext.
      ENDIF.
* New tab
      IF ls_hdtext-text IS NOT INITIAL.
        CASE ls_hdid-id.
          WHEN  'Z102' .      ls_Text-ofm_no         = ls_hdtext-text.
          WHEN  'Z888' .      ls_Text-special_comm   = ls_hdtext-text.
          WHEN  '0001' .
            ls_Text-itmtxt    = ls_hdtext-text.
            ls_Text-mat_text  = ls_hdtext-text.
          WHEN  '0010' .      ls_Text-cust_mat_Code  = ls_hdtext-text.
          WHEN  'Z110' .      ls_Text-cust_mat_desc  = ls_hdtext-text.
          WHEN  'Z103' .      ls_Text-po_sr_no       = ls_hdtext-text.

          WHEN OTHERS.
        ENDCASE.
      ENDIF.

      CLEAR: lt_lines, ls_hdtext.
    ENDLOOP.
    IF ls_Text IS NOT INITIAL.
      ls_text-vbeln = ls_so-vbeln.
      ls_text-posnr = ls_so-posnr.
      APPEND ls_Text TO lt_itmText.
    ENDIF.
  ENDLOOP.

  SORT lt_htext BY vbeln posnr.
  gt_htext = lt_htext.
  SORT lt_itmtext BY vbeln posnr.
  gt_itmtext = lt_itmtext.

  SORT lt_hdtext BY vbeln posnr obj id.
  gt_hdtext = lt_hdtext.
  CLEAR: lt_hdtext, lt_lines, lt_htext, lt_itmtext..
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fill_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <F1>_VBELN
*&      --> <F1>_POSNR
*&      <-- LS_OUTPUT
*&---------------------------------------------------------------------*
FORM fill_text  USING    pu_vbeln TYPE vbeln_va
                         pu_posnr TYPE posnr_Va
                CHANGING Cs_output TYPE TY_tEXT.

*  DATA: lt_hdtext TYPE tty_hdtext.
  DATA: lt_hdtext  TYPE HASHED TABLE OF ty_hdtext WITH UNIQUE KEY vbeln posnr obj id,
        lt_itmtext TYPE HASHED TABLE OF ty_hdtext WITH UNIQUE KEY vbeln posnr obj id.


  lt_hdtext = FILTER #( gt_hdtext WHERE vbeln = pu_vbeln ).

  lt_itmtext = lt_hdtext.
  DELETE lt_hdtext WHERE posnr <> '000000'.

* Header text
  LOOP AT lt_hdtext INTO DATA(ls_hdtext) WHERE obj = 'VBBK'
                                           AND posnr = '000000'.
    CASE ls_hdtext-id.
      WHEN  'Z999' .      cs_output-tpi           = ls_hdtext-text.
      WHEN  'Z005' .      cs_output-freight       = ls_hdtext-text.
      WHEN  'Z012' .      cs_output-packing_type  = ls_hdtext-text.
      WHEN  'Z015' .      cs_output-ofm           = ls_hdtext-text.
      WHEN  'Z016' .      cs_output-ofm_date      = ls_hdtext-text.
      WHEN  'Z017' .      cs_output-insur         = ls_hdtext-text.
      WHEN  'Z020' .      cs_output-spl           = ls_hdtext-text.
      WHEN  'Z038' .      cs_output-ld_txt        = ls_hdtext-text.
      WHEN  'Z039' .      cs_output-tag_req       = ls_hdtext-text.
      WHEN  'Z047' .      cs_output-pardel        = ls_hdtext-text.
      WHEN  'Z062' .      cs_output-quota_ref     = ls_hdtext-text.
      WHEN  'Z063' .      cs_output-zcust_proj_name   = ls_hdtext-text.
      WHEN  'Z064' .      cs_output-amendment_his = ls_hdtext-text.
      WHEN  'Z065' .      cs_output-po_dis        = ls_hdtext-text.
      WHEN  'Z066' .      cs_output-ofm_rec_date  = ls_hdtext-text.
      WHEN  'Z067' .      cs_output-oss_rec_date  = ls_hdtext-text.
      WHEN  'Z068' .      cs_output-source_rest   = ls_hdtext-text.
      WHEN  'Z069' .      cs_output-suppl_rest    = ls_hdtext-text.
      WHEN  'Z101' .      cs_output-full_pmnt     = ls_hdtext-text.
      WHEN  'Z102' .      cs_output-proj          = ls_hdtext-text.
      WHEN  'Z103' .      cs_output-cond          = ls_hdtext-text.
      WHEN  'Z104' .      cs_output-infra         = ls_hdtext-text.
      WHEN  'Z105' .      cs_output-validation    = ls_hdtext-text.
      WHEN  'Z106' .      cs_output-review_date   = ls_hdtext-text.
      WHEN  'Z107' .      cs_output-diss_summary  = ls_hdtext-text.

      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

* ITEM text
  DELETE lt_itmtext WHERE posnr <> pu_posnr.
  DELETE gt_hdtext WHERE vbeln = pu_vbeln AND posnr = pu_posnr.

  LOOP AT lt_itmtext INTO ls_hdtext WHERE obj = 'VBBP'
                                   AND posnr = pu_posnr..
    CASE ls_hdtext-id.
      WHEN  'Z102' .      cs_output-ofm_no   = ls_hdtext-text.
      WHEN  'Z110' .      cs_output-ofm_no   = ls_hdtext-text.
      WHEN  'Z888' .      cs_output-cust_mat_desc   = ls_hdtext-text.
      WHEN  '0001' .
        cs_output-itmtxt   = ls_hdtext-text.
        cs_output-mat_text = ls_hdtext-text.
      WHEN  '0010' .
        cs_output-cust_mat_Code  = ls_hdtext-text.
      WHEN  'Z103' .
        cs_output-po_sr_no   = ls_hdtext-text.
      WHEN OTHERS.
    ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form READ_MATEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_MATTXT
*&---------------------------------------------------------------------*
FORM read_matext  CHANGING Ct_mattxt TYPE tty_mattxt.
  DATA: lt_lines TYPE STANDARD TABLE OF tline,
        lv_name  TYPE thead-tdname.

  LOOP AT ct_mattxt ASSIGNING FIELD-SYMBOL(<f1>).

    lv_name = <f1>-matnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*       USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
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
    IF lt_lines IS NOT INITIAL.
      <f1>-mattxt = VALUE #( lt_lines[ 1 ]-tdline OPTIONAL ).
    ENDIF.
    CLEAR: lt_lines.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM download_file .
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

  PERFORM new_file_1.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_output_new "it_output
*     i_tab_sap_data       = gt_output
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

* Header row with column names
  PERFORM cvs_header USING hd_csv.

  IF open_so IS NOT INITIAL.
    lv_file = 'ZDELPENDSO_2.TXT'.
    WRITE: / 'ZPENDSO_2 Download started on', sy-datum, 'at', sy-uzeit.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    lv_file = 'ZDELPENDSOALL_2.TXT'.
    WRITE: / 'ZDELPENDSO Download started on', sy-datum, 'at', sy-uzeit.
    WRITE: / 'All Sales Orders'.
  ENDIF.

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
     INTO lv_fullfile.

  WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'Dest. File:', lv_fullfile.

*Common code
  OPEN DATASET lv_fullfile
      FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_1362 TYPE string.
    DATA lv_crlf_1362 TYPE string.
    lv_crlf_1362 = cl_abap_char_utilities=>cr_lf.
    lv_string_1362 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1362 lv_crlf_1362 wa_csv INTO lv_string_1362.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_1362 TO lv_fullfile.

    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
*  CLOSE DATASET lv_fullfile.

* 2nd file
  PERFORM new_file.
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
  IF open_so IS NOT INITIAL.
    lv_file = 'ZDELPENDSO_2.TXT'.
    WRITE: / 'ZPENDSO_2 Download started on', sy-datum, 'at', sy-uzeit.
  ELSE.
    lv_file = 'ZDELPENDSOALL_2.TXT'.
    WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
  ENDIF.

  CONCATENATE p_folder '/' lv_file INTO lv_fullfile.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_1365 TYPE string.
    DATA lv_crlf_1365 TYPE string.
    lv_crlf_1365 = cl_abap_char_utilities=>cr_lf.
    lv_string_1365 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1365 lv_crlf_1365 wa_csv INTO lv_string_1365.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_1365 TO lv_fullfile.

    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
  CLOSE DATASET lv_fullfile.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CVS_HEADER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
           'PLANT'
           'ORDER TYPE'
           'CUST REF NO'
           'CUSTOMER NAME'
           'SALES OFFICE'
           'SALES DOC NO'
           'SO DATE'
           'REQUIRED DELIVERY DATE'
           'HOLD/UNHOLD'
           'HOLD DATE'
           'REL DATE'
           'CANCEL DATE'
           'DELV DATE'
           'TAG_REQD'
           'TPI REQD'
           'LD REQD'
           'LD PER WEEK'
           'LD MAX'
           'LD FROM DATE'
           'MAT NR'
           'POS NR'
           'DESCRIPTION'
           'SO QTY'
           'STOCK QTY'
           'DELIVARY QTY'
           'INVOICE QUANTITY'
           'PENDING QTY'
           'SO STATUS'
           'MRP DATE'
           'PRODUCTION DATE'
           'RATE'
           'CURRENCY'
           'CURRENCY CONV'
*           'SO Exchange Rate'         "missed
           'PENDING SO AMOUNT'
           'ORDER AMOUNT'
           'INTERNAL PRICE'
           'INTERNAL PRICE DATE'
           'ESTIMATED COST'
           'LATEST ESTIMATED COST'
           'STANDARD COST'
           'SERIES'
           'SIZE'
           'BRAND'
           'MOC'
           'TYPE'
           'MRP CONTROLLER'
           'WIP'
           'MAT TYPE'
           'CUST MAT NO'
           'CUSTOMER'
           'QM QTY'
           'Description Long'
           'MATTXT'              "'Sales Text'
           'SCHD NO'
           'SCHEDULE_ID'
           'SO Exchange Rate'
           'Payment Terms'
           'Payment Terms Text'
           'Inco Terms'
           'Inco Terms Descr'
           'OFM No.'
           'OFM Date'
           'CUSTOMER DEL DATE'
           'File Created Date'
           'Rejection Reason Code'
           'Rejection Reason Description'
           'USA Item Code'
           'CGST%'
*          'CGST'
           'SGST%'
*          'SGST'
           'IGST%'
*          'IGST'
           'Ship To Party'
           'Ship To Party Description'
           'Ship To Party State'
           'Sold To Party State'
           'Industry Std Desc.'
           'Ship To Party Country Key'
           'Sold To Party Country Key'
           'Purchase Order Item'
           'Ship To Party Country Desc'
           'PO Date'
           'Delivery Block(Header Loc)'
           'Delivery Block Txt'
            'Insurance'
           'Partial Delivery'
           'GAD'
           'USA Customer Name'
           'TCS Rate'
           'TCS Amount'
           'Special Instruction'
           'PO_Delivery_Date'
           'OFM SR. NO.'
           'CTBG Item Details'
           'Certificate Details'
           'Item Type' "  edited by PJ on 16-08-21
           'Ref. Time' "  edited by PJ on 08-09-21
*          'CTBG Details'
           'Project Ownwer Name'            "added by pankaj 28.01.2022
           'Condition Delivery Date'        "added by pankaj 28.01.2022
           'Code Receipt Date'              "added by pankaj 28.01.2022
           'Reason'                         "added by pankaj 28.01.2022
           'Net Weight'                         "added by pankaj 28.01.2022
           'Condition ZPR0'
           'Condition ZPF0'
           'Condition ZIN1'
           'Condition ZIN2'
           'Condition JOIG'
           'Condition JOCG'
           'Condition JOSG'
           'Schedule line del.Dat'
           'Pricing Date'
           'Packing Type'
           'OFM Delivery Date'
           'Material Sales Text'
           'Infrastructure required'        "added by pankaj 31.01.2022
           'Validation Plan Refrence'          "added by pankaj 31.01.2022
           'Review Date'                      "added by pankaj 31.01.2022
           'Discussion Summary'                "added by pankaj 31.01.2022
           'Changed SO Date'
           'Port'                                   "added by pankaj 04.02.2022
           'Full Payment Desc'                     "added by pankaj 04.02.2022
           'Act Assignments'                       "added by pankaj 04.02.2022
           'User Status'                             "added by pankaj 04.02.2022
           'Freight'
           "'OFM SR NO'
           'PO SR NO Text'
           'Last changed date'
           'BOM Status'
           'Pending Items'
           'Reason for Pending Items'
            'Installation Location'
            'BOM EXISTS '
            'Po Item No.'
*          'Billing Block'
            'Storage Location'
            'QT Reference No.'
            'DV_PLMRPDATE'
            'Sales Organization'
            'Distribution Channel'
            'Division'
            'Expected MRP Date'
            'Special Comments'
            'Customer Project Name'
            'Amendment_history'
            'Po Discrepancy'
            'Hold Reason'  "added by jyoti on 06.02.2024
            'Stock Qty KTPI'
            'Stock Qty TPI1'
            'Exchange Rate Type'
            'OFM Received date from pre-sales'
            'OSS Received from Technical Cell'
            'Sourcing restrictions'
            'Supplier restrictions'
            'Customer Material Description'
            'Dis %'               "added by mahadev 17.12.2025
            'Discount Amount'               "added by mahadev 17.12.2025
            'Discount Unit Rate'               "added by mahadev 17.12.2025
            'Customer Mat.Code'     "+++ 002
   INTO pd_csv
   SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form new_file_1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM new_file_1 .
  DATA: wa_output_new TYPE output_new.

  LOOP AT gT_OUTPUT INTO DATA(wa_output).
    wa_output_new-werks       = wa_output-werks.
    wa_output_new-auart       = wa_output-auart.
    wa_output_new-bstkd       = wa_output-bstkd.
    wa_output_new-name1       = wa_output-name1.
    wa_output_new-vkbur       = wa_output-vkbur.
    wa_output_new-vbeln       = wa_output-vbeln.
    wa_output_new-status      = wa_output-status.
    wa_output_new-tag_req     = wa_output-tag_req.
    wa_output_new-tpi         = wa_output-tpi.
    wa_output_new-ld_txt      = wa_output-ld_txt.
    wa_output_new-zldperweek  = wa_output-zldperweek.
    wa_output_new-zldmax      = wa_output-zldmax.
    wa_output_new-matnr       = wa_output-matnr.
    wa_output_new-posnr       = wa_output-posnr.
    wa_output_new-arktx       = wa_output-arktx.

*    wa_output_new-stock_qty   = abs( wa_output-stock_qty ).
*    wa_output_new-kwmeng      = abs( wa_output-kwmeng ).
*    wa_output_new-lfimg       = abs( wa_output-lfimg ).
*    wa_output_new-fkimg       = abs( wa_output-fkimg ).
*    wa_output_new-pnd_qty     = abs( wa_output-pnd_qty ).
    WRITE abs( wa_output-stock_qty )  TO wa_output_new-stock_qty NO-GROUPING.
    WRITE abs( wa_output-kwmeng ) TO wa_output_new-kwmeng NO-GROUPING.
    WRITE abs( wa_output-lfimg ) TO wa_output_new-lfimg NO-GROUPING.
    WRITE abs( wa_output-fkimg ) TO wa_output_new-fkimg NO-GROUPING.
    WRITE abs( wa_output-pnd_qty ) TO wa_output_new-pnd_qty NO-GROUPING.


    wa_output_new-ettyp       = wa_output-ettyp.
    wa_output_new-kbetr       = wa_output-kbetr.
    CONDENSE wa_output_new-kbetr.
    wa_output_new-waerk       = wa_output-waerk.
    wa_output_new-curr_con    = wa_output-curr_con.
    wa_output_new-amont       = abs( wa_output-amont ).
    wa_output_new-ordr_amt    = abs( wa_output-ordr_amt ).
    wa_output_new-in_price    = abs( wa_output-in_price ).
    wa_output_new-est_cost    = abs( wa_output-est_cost ).
    wa_output_new-latst_cost  = abs( wa_output-latst_cost ).
    wa_output_new-st_cost     = abs( wa_output-st_cost ).
    wa_output_new-zseries     = wa_output-zseries.
    wa_output_new-zsize       = wa_output-zsize.
    wa_output_new-brand       = wa_output-brand.
    wa_output_new-moc         = wa_output-moc.
    wa_output_new-type        = wa_output-type.
    wa_output_new-dispo       = wa_output-dispo.
    wa_output_new-wip         = wa_output-wip.
    wa_output_new-mtart       = wa_output-mtart.
    wa_output_new-kdmat       = wa_output-kdmat.
    wa_output_new-kunnr       = wa_output-kunnr.
    wa_output_new-qmqty       = abs( wa_output-qmqty ).
    wa_output_new-mattxt      = wa_output-mattxt.
    wa_output_new-us_cust      = wa_output-us_cust.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-mattxt WITH ' & '.
    wa_output_new-itmtxt      = wa_output-itmtxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-itmtxt WITH ' & '.
    wa_output_new-etenr       = wa_output-etenr.
    wa_output_new-schid       = wa_output-schid.
    wa_output_new-so_exc      = wa_output-so_exc.
    wa_output_new-zterm       = wa_output-zterm.
    wa_output_new-text1       = wa_output-text1.
    wa_output_new-inco1       = wa_output-inco1.
    wa_output_new-inco2       = wa_output-inco2.
    wa_output_new-ofm         = wa_output-ofm.
    wa_output_new-ofm_date    = wa_output-ofm_date.
    wa_output_new-spl         = wa_output-spl.
    wa_output_new-wrkst       = wa_output-wrkst.
    wa_output_new-abgru       = wa_output-abgru.
    wa_output_new-bezei       = wa_output-bezei.
    wa_output_new-cgst        = wa_output-cgst.
    IF  wa_output_new-cgst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-cgst INTO  wa_output_new-cgst.
    ENDIF.
    wa_output_new-sgst        = wa_output-sgst.
    IF  wa_output_new-sgst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-sgst INTO  wa_output_new-sgst.
    ENDIF.
    wa_output_new-igst        = wa_output-igst.
    IF  wa_output_new-igst IS INITIAL .
      CONCATENATE  '0'  wa_output_new-igst INTO  wa_output_new-igst.
    ENDIF.

    wa_output_new-ship_kunnr    = wa_output-ship_kunnr.
    wa_output_new-ship_kunnr_n  = wa_output-ship_kunnr_n.
    wa_output_new-ship_reg_n    = wa_output-ship_reg_n.
    wa_output_new-sold_reg_n    = wa_output-sold_reg_n.
    wa_output_new-ship_land     = wa_output-ship_land.
    wa_output_new-s_land_desc   = wa_output-s_land_desc.
    wa_output_new-sold_land     =  wa_output-sold_land.
    wa_output_new-posex          = wa_output-posex.

    wa_output_new-lifsk          = wa_output-lifsk.
    wa_output_new-vtext          = wa_output-vtext.
    wa_output_new-insur          = wa_output-insur .
    wa_output_new-pardel         = wa_output-pardel.
    wa_output_new-gad            = wa_output-gad.
    wa_output_new-tcs            = wa_output-tcs.
    wa_output_new-tcs_amt        = wa_output-tcs_amt.
    wa_output_new-special_comm   = wa_output-special_comm.

    wa_output_new-ctbg          = wa_output-ctbg.
    wa_output_new-certif        = wa_output-certif.
    wa_output_new-vkorg         = wa_output-vkorg.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-vtweg         = wa_output-vtweg.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-spart         = wa_output-spart.           "ADDED BY AAKASHK 19.08.2024 EVNG
    wa_output_new-kurst         = wa_output-kurst.

    wa_output_new-bstdk   = wa_output-bstdk.
    wa_output_new-erdat   = wa_output-erdat.
    wa_output_new-vdatu   = wa_output-vdatu.
    wa_output_new-holddate   = wa_output-holddate.
    wa_output_new-reldate    = wa_output-reldate.
    wa_output_new-canceldate = wa_output-canceldate.
    wa_output_new-deldate    = wa_output-deldate.
    wa_output_new-custdeldate = wa_output-custdeldate.
    wa_output_new-po_del_date = wa_output-po_del_date.
    wa_output_new-zldfromdate = wa_output-zldfromdate.
    wa_output_new-mrp_dt   = wa_output-mrp_dt.
    wa_output_new-edatu    = wa_output-edatu.
    wa_output_new-in_pr_dt = wa_output-in_pr_dt.
    wa_output_new-ref_dt   = wa_output-ref_dt.
    wa_output_new-zmrp_date   = wa_output-zmrp_date.
    wa_output_new-zexp_mrp_date1   = wa_output-zexp_mrp_date1.

    wa_output_new-ofm_no = wa_output-ofm_no .

    CONDENSE  wa_output_new-kwmeng.
    IF wa_output-kwmeng < 0.
      CONCATENATE '-'  wa_output_new-kwmeng INTO  wa_output_new-kwmeng.
    ENDIF.

    CONDENSE  wa_output_new-lfimg.
    IF wa_output-lfimg < 0.
      CONCATENATE '-'  wa_output_new-lfimg INTO wa_output_new-lfimg.
    ENDIF.

    CONDENSE  wa_output_new-fkimg.
    IF wa_output-fkimg < 0.
      CONCATENATE '-' wa_output_new-fkimg INTO wa_output_new-fkimg.
    ENDIF.

    CONDENSE wa_output_new-pnd_qty.
    IF wa_output-pnd_qty < 0.
      CONCATENATE '-' wa_output_new-pnd_qty INTO wa_output_new-pnd_qty.
    ENDIF.

    CONDENSE wa_output_new-qmqty.
    IF wa_output-qmqty < 0.
      CONCATENATE '-' wa_output_new-qmqty INTO wa_output_new-qmqty.
    ENDIF.

    CONDENSE wa_output_new-kbetr.
    IF wa_output-kbetr < 0.
      CONCATENATE '-' wa_output_new-kbetr INTO wa_output_new-kbetr.
    ENDIF.

    CONDENSE wa_output_new-amont.
    IF wa_output-amont < 0.
      CONCATENATE '-' wa_output_new-amont INTO wa_output_new-amont.
    ENDIF.

    CONDENSE wa_output_new-ordr_amt.
    IF wa_output-ordr_amt < 0.
      CONCATENATE '-' wa_output_new-ordr_amt INTO wa_output_new-ordr_amt.
    ENDIF.

    CONDENSE wa_output_new-in_price.
    IF wa_output-in_price < 0.
      CONCATENATE '-' wa_output_new-in_price INTO wa_output_new-in_price.
    ENDIF.

    CONDENSE wa_output_new-est_cost.
    IF wa_output-est_cost < 0.
      CONCATENATE '-' wa_output_new-est_cost INTO wa_output_new-est_cost.
    ENDIF.

    CONDENSE wa_output_new-latst_cost.
    IF wa_output-latst_cost < 0.
      CONCATENATE '-' wa_output_new-latst_cost INTO wa_output_new-latst_cost.
    ENDIF.

    CONDENSE wa_output_new-st_cost.
    IF wa_output-st_cost < 0.
      CONCATENATE '-' wa_output_new-st_cost INTO wa_output_new-st_cost.
    ENDIF.

    wa_output_new-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
    wa_output_new-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21

    wa_output_new-proj          = wa_output-proj .

    wa_output_new-cond          = wa_output-cond .
    wa_output_new-receipt_date  = wa_output-receipt_date .

    wa_output_new-reason      = wa_output-reason.
    wa_output_new-ntgew      = wa_output-ntgew.

    wa_output_new-zpr0        = wa_output-zpr0.
    wa_output_new-zpf0        = wa_output-zpf0.
    wa_output_new-zin1        = wa_output-zin1.
    wa_output_new-zin2        = wa_output-zin2.
    wa_output_new-joig        = wa_output-joig.
    wa_output_new-jocg        = wa_output-jocg.
    wa_output_new-josg        = wa_output-josg.
    wa_output_new-date        = wa_output-date.
    wa_output_new-prsdt       = wa_output-prsdt.

    wa_output_new-packing_type = wa_output-packing_type.

    wa_output_new-ofm_date1   = wa_output-ofm_date1.
    wa_output_new-mat_text    = wa_output-mat_text.
    wa_output_new-infra       = wa_output-infra.
    wa_output_new-validation  = wa_output-validation.
    wa_output_new-review_date = wa_output-review_date.

    wa_output_new-diss_summary  = wa_output-diss_summary .
    wa_output_new-chang_so_date = wa_output-chang_so_date.

    wa_output_new-port      = wa_output-port .
    wa_output_new-full_pmnt = wa_output-full_pmnt .
    wa_output_new-act_ass   = wa_output-act_ass .
    wa_output_new-txt04     = wa_output-txt04 .
    wa_output_new-freight   = wa_output-freight.
    wa_output_new-po_sr_no  = wa_output-po_sr_no.
    wa_output_new-udate     = wa_output-udate.
    wa_output_new-bom       = wa_output-bom.
    wa_output_new-zpen_item = wa_output-zpen_item.
    wa_output_new-zre_pen_item = wa_output-zre_pen_item.
    wa_output_new-zins_loc  = wa_output-zins_loc. "ADDED BY PRIMUS MA
    wa_output_new-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS MA
    wa_output_new-posex1    = wa_output-posex.
    wa_output_new-lgort     = wa_output-lgort.  "ADDED BY Pranit 10.06.2024
    wa_output_new-quota_ref = wa_output-quota_ref.  "ADDED BY jyoti 19.06.2024

    wa_output_new-zcust_proj_name = wa_output-zcust_proj_name.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-po_dis          = wa_output-po_dis.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-amendment_his   = wa_output-amendment_his.    """ ADDED BY SUPRIYA 19.08.2024
    wa_output_new-hold_reason_n1  = wa_output-hold_reason_n1."Added by jyoti on 06.02.2025
    wa_output_new-stock_qty_ktpi  = wa_output-stock_qty_ktpi.
    wa_output_new-stock_qty_tpi1  = wa_output-stock_qty_tpi1.
    wa_output_new-ofm_rec_date    = wa_output-ofm_rec_date.
    wa_output_new-oss_rec_date    = wa_output-oss_rec_date.
    wa_output_new-source_rest     = wa_output-source_rest.
    wa_output_new-suppl_rest      = wa_output-suppl_rest.
    wa_output_new-cust_mat_desc   = wa_output-cust_mat_desc.

* Customer material code from item texts
    wa_output_new-dis_rate = wa_output-dis_rate.
    wa_output_new-dis_amt = wa_output-dis_amt.
    wa_output_new-dis_unit_rate = wa_output-dis_unit_rate.

    wa_output_new-cust_mat_code = wa_output-cust_mat_code.

    APPEND wa_output_new TO it_output_new.
    CLEAR:
      wa_output_new,wa_output.
  ENDLOOP.

ENDFORM.

FORM new_file .
  DATA:
    ls_final TYPE t_final.

  LOOP AT gt_output INTO DATA(wa_output).
    ls_final-werks       = wa_output-werks.
    ls_final-auart       = wa_output-auart.
    ls_final-bstkd       = wa_output-bstkd.
    ls_final-name1       = wa_output-name1.
    ls_final-vkbur       = wa_output-vkbur.
    ls_final-vbeln       = wa_output-vbeln.
    ls_final-status      = wa_output-status.
    ls_final-tag_req     = wa_output-tag_req.
    ls_final-tpi         = wa_output-tpi.
    ls_final-ld_txt      = wa_output-ld_txt.
    ls_final-zldperweek  = wa_output-zldperweek.
    ls_final-zldmax      = wa_output-zldmax.
    ls_final-matnr       = wa_output-matnr.
    ls_final-posnr       = wa_output-posnr.
    ls_final-arktx       = wa_output-arktx.
*    ls_final-kalab       = abs( wa_output-stock_qty ).
*    ls_final-kwmeng      = abs( wa_output-kwmeng ).
*    ls_final-lfimg       = abs( wa_output-lfimg ).
*    ls_final-fkimg       = abs( wa_output-fkimg ).
*    ls_final-pnd_qty     = abs( wa_output-pnd_qty ).

    WRITE abs( wa_output-stock_qty ) TO ls_final-kalab NO-GROUPING.
    WRITE abs( wa_output-kwmeng ) TO ls_final-kwmeng NO-GROUPING.
    WRITE abs( wa_output-lfimg ) TO ls_final-lfimg NO-GROUPING.
    WRITE abs( wa_output-fkimg ) TO ls_final-fkimg NO-GROUPING.
    WRITE abs( wa_output-pnd_qty ) TO ls_final-pnd_qty NO-GROUPING.

    ls_final-ettyp       = wa_output-ettyp.
    ls_final-kbetr       = wa_output-kbetr.
    ls_final-waerk       = wa_output-waerk.
    ls_final-curr_con    = wa_output-curr_con.
    ls_final-so_exc      = wa_output-so_exc."ADDED BY JYOTI ON26.04.2024
    ls_final-amont       = abs( wa_output-amont ).
    ls_final-ordr_amt    = abs( wa_output-ordr_amt ).
    ls_final-in_price    = abs( wa_output-in_price ).
    ls_final-est_cost    = abs( wa_output-est_cost ).
    ls_final-latst_cost  = abs( wa_output-latst_cost ).
    ls_final-st_cost     = abs( wa_output-st_cost ).
    ls_final-zseries     = wa_output-zseries.
    ls_final-zsize       = wa_output-zsize.
    ls_final-brand       = wa_output-brand.
    ls_final-moc         = wa_output-moc.
    ls_final-type        = wa_output-type.
    ls_final-dispo       = wa_output-dispo.
    ls_final-wip         = wa_output-wip.
    ls_final-mtart       = wa_output-mtart.
    ls_final-kdmat       = wa_output-kdmat.
    ls_final-kunnr       = wa_output-kunnr.
    ls_final-qmqty       = abs( wa_output-qmqty ).
    ls_final-mattxt      = wa_output-mattxt.
    ls_final-us_cust      = wa_output-us_cust.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-mattxt WITH ' & '.
    ls_final-itmtxt      = wa_output-itmtxt.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-itmtxt WITH ' & '.
    ls_final-etenr       = wa_output-etenr.
    ls_final-schid       = wa_output-schid.
*    ls_final-so_exc      = wa_output-so_exc."COMMENTED BY JYOTI ON 26.04.2024
    ls_final-zterm       = wa_output-zterm.
    ls_final-text1       = wa_output-text1.
    ls_final-inco1       = wa_output-inco1.
    ls_final-inco2       = wa_output-inco2.
    ls_final-ofm         = wa_output-ofm.
    ls_final-ofm_date    = wa_output-ofm_date.
    ls_final-spl         = wa_output-spl.
    ls_final-wrkst       = wa_output-wrkst.
    ls_final-abgru       = wa_output-abgru.
    ls_final-bezei       = wa_output-bezei.
    ls_final-cgst        = wa_output-cgst.
    IF ls_final-cgst IS INITIAL .
      CONCATENATE  '0' ls_final-cgst INTO ls_final-cgst.
    ENDIF.
    ls_final-sgst        = wa_output-sgst.
    IF ls_final-sgst IS INITIAL .
      CONCATENATE  '0' ls_final-sgst INTO ls_final-sgst.
    ENDIF.
    ls_final-igst        = wa_output-igst.
    IF ls_final-igst IS INITIAL .
      CONCATENATE  '0' ls_final-igst INTO ls_final-igst.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    ls_final-ship_kunnr    = wa_output-ship_kunnr.
    ls_final-ship_kunnr_n  = wa_output-ship_kunnr_n.
    ls_final-ship_reg_n    = wa_output-ship_reg_n.
    ls_final-sold_reg_n    = wa_output-sold_reg_n.
    ls_final-ship_land     = wa_output-ship_land.
    ls_final-s_land_desc   = wa_output-s_land_desc.
    ls_final-sold_land     =  wa_output-sold_land.
*    ls_final-normt          = wa_output-normt.
    ls_final-posex          = wa_output-posex.

    ls_final-lifsk          = wa_output-lifsk.
    ls_final-vtext          = wa_output-vtext.
    ls_final-insur          = wa_output-insur .
    ls_final-pardel         = wa_output-pardel.
    ls_final-gad            = wa_output-gad.
    ls_final-tcs            = wa_output-tcs.
    ls_final-tcs_amt        = wa_output-tcs_amt.

    ls_final-ctbg          = wa_output-ctbg.
    ls_final-certif         = wa_output-certif.
    ls_final-special_comm   = wa_output-special_comm.
    ls_final-amendment_his   = wa_output-amendment_his.
*    ls_final-ctbg         = wa_output-ctbg.
    ls_final-bstdk   = wa_output-bstdk.
    ls_final-erdat   = wa_output-erdat.
    ls_final-vdatu   = wa_output-vdatu.
    ls_final-holddate   = wa_output-holddate.
    ls_final-reldate   = wa_output-reldate.
    ls_final-canceldate   = wa_output-canceldate.
    ls_final-deldate   = wa_output-deldate.
    ls_final-custdeldate   = wa_output-custdeldate.
    ls_final-po_del_date   = wa_output-po_del_date.
    ls_final-zldfromdate   = wa_output-zldfromdate.
    ls_final-mrp_dt   = wa_output-mrp_dt.
    ls_final-edatu   = wa_output-edatu.
    ls_final-in_pr_dt   = wa_output-in_pr_dt.
    ls_final-ref_dt   = wa_output-ref_dt.
    ls_final-zmrp_date   = wa_output-zmrp_date.
    ls_final-zexp_mrp_date1   = wa_output-zexp_mrp_date1.

    ls_final-ofm_no = wa_output-ofm_no .

    CONDENSE ls_final-kwmeng.
    IF wa_output-kwmeng < 0.
      CONCATENATE '-' ls_final-kwmeng INTO ls_final-kwmeng.
    ENDIF.

    CONDENSE ls_final-lfimg.
    IF wa_output-lfimg < 0.
      CONCATENATE '-' ls_final-lfimg INTO ls_final-lfimg.
    ENDIF.

    CONDENSE ls_final-fkimg.
    IF wa_output-fkimg < 0.
      CONCATENATE '-' ls_final-fkimg INTO ls_final-fkimg.
    ENDIF.

    CONDENSE ls_final-pnd_qty.
    IF wa_output-pnd_qty < 0.
      CONCATENATE '-' ls_final-pnd_qty INTO ls_final-pnd_qty.
    ENDIF.

    CONDENSE ls_final-qmqty.
    IF wa_output-qmqty < 0.
      CONCATENATE '-' ls_final-qmqty INTO ls_final-qmqty.
    ENDIF.
    CONDENSE ls_final-kbetr.

    IF wa_output-kbetr < 0.
      CONCATENATE '-' ls_final-kbetr INTO ls_final-kbetr.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE ls_final-amont.
    IF wa_output-amont < 0.
      CONCATENATE '-' ls_final-amont INTO ls_final-amont.
    ENDIF.

    CONDENSE ls_final-ordr_amt.
    IF wa_output-ordr_amt < 0.
      CONCATENATE '-' ls_final-ordr_amt INTO ls_final-ordr_amt.
    ENDIF.


    CONDENSE ls_final-in_price.
    IF wa_output-in_price < 0.
      CONCATENATE '-' ls_final-in_price INTO ls_final-in_price.
    ENDIF.

    CONDENSE ls_final-est_cost.
    IF wa_output-est_cost < 0.
      CONCATENATE '-' ls_final-est_cost INTO ls_final-est_cost.
    ENDIF.

    CONDENSE ls_final-latst_cost.
    IF wa_output-latst_cost < 0.
      CONCATENATE '-' ls_final-latst_cost INTO ls_final-latst_cost.
    ENDIF.

    CONDENSE ls_final-st_cost.
    IF wa_output-st_cost < 0.
      CONCATENATE '-' ls_final-st_cost INTO ls_final-st_cost.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    ls_final-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
    ls_final-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21

    ls_final-proj          = wa_output-proj .

    ls_final-cond          = wa_output-cond .

    ls_final-receipt_date   = wa_output-receipt_date.
    ls_final-reason      = wa_output-reason.

    ls_final-ntgew      = wa_output-ntgew.

    ls_final-zpr0        = wa_output-zpr0.
    ls_final-zpf0        = wa_output-zpf0.
    ls_final-zin1        = wa_output-zin1.
    ls_final-zin2        = wa_output-zin2.
    ls_final-joig        = wa_output-joig.
    ls_final-jocg        = wa_output-jocg.
    ls_final-josg        = wa_output-josg.

    ls_final-date   = wa_output-date.
    ls_final-prsdt   = wa_output-prsdt.


    ls_final-packing_type = wa_output-packing_type.

    ls_final-ofm_date1   = wa_output-ofm_date1.
    ls_final-mat_text = wa_output-mat_text.


    """"""" code added by pankaj 31.01.2022"""""""""

    ls_final-infra        = wa_output-infra.
    ls_final-validation   = wa_output-validation.

    ls_final-review_date = wa_output-review_date.

    ls_final-diss_summary = wa_output-diss_summary .
    ls_final-chang_so_date = wa_output-chang_so_date.

    ls_final-port      = wa_output-port .
    ls_final-full_pmnt = wa_output-full_pmnt .
    ls_final-act_ass   = wa_output-act_ass .
    ls_final-txt04     = wa_output-txt04 .
    ls_final-freight  = wa_output-freight.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    ls_final-po_sr_no = wa_output-po_sr_no.
    ls_final-udate = wa_output-udate.
    ls_final-bom = wa_output-bom.
    ls_final-zpen_item = wa_output-zpen_item.
    ls_final-zre_pen_item = wa_output-zre_pen_item.
    ls_final-zins_loc = wa_output-zins_loc. "ADDED BY PRIMUS JYOTI MAHAJAN
    ls_final-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS JYOTI MAHAJAN
*     ls_final-bstkd1       = wa_output-bstkd."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
    ls_final-posex1       = wa_output-posex1."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
*    ls_final-vtext1 = wa_output-vtext1.

    ls_final-lgort = wa_output-lgort. "Added by Pranit 10.06.2024
    ls_final-quota_ref = wa_output-quota_ref. "Added by jyoti  19.06.2024

    """"""" endded """""""""""""""""""
    ls_final-vkorg = wa_output-vkorg.
    ls_final-vtweg = wa_output-vtweg.
    ls_final-spart = wa_output-spart.
    ls_final-zcust_proj_name = wa_output-zcust_proj_name."Added by jyoti
    ls_final-amendment_his = wa_output-amendment_his."Added by jyoti
    ls_final-po_dis = wa_output-po_dis."Added by jyoti
    ls_final-hold_reason_n1 = wa_output-hold_reason_n1."Added by jyoti

    ls_final-stock_qty_ktpi   = wa_output-stock_qty_ktpi.
    ls_final-stock_qty_tpi1   = wa_output-stock_qty_tpi1.
    ls_final-kurst         = wa_output-kurst.
    ls_final-ofm_received_date    = wa_output-ofm_rec_date.
    ls_final-oss_received_cell    = wa_output-oss_rec_date.
    ls_final-source_rest     = wa_output-source_rest.
    ls_final-suppl_rest      = wa_output-suppl_rest.
    ls_final-cust_mat_desc   = wa_output-cust_mat_desc.

    ls_final-dis_rate = wa_output-dis_rate.
    ls_final-dis_amt = wa_output-dis_amt.
    ls_final-dis_unit_rate = wa_output-dis_unit_rate.
* Customer material code from item texts
    ls_final-cust_mat_code = wa_output-cust_mat_code.

    CONDENSE: ls_final-kbetr,ls_final-kwmeng,ls_final-kalab,ls_final-amont,ls_final-ordr_amt,ls_final-in_price.
    APPEND ls_final TO gt_final.
    CLEAR:
      ls_final,wa_output.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_bstkd_Text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_BSTKD
*&---------------------------------------------------------------------*
FORM read_bstkd_Text  CHANGING ct_bstkd TYPE tty_bstkd.
  DATA: lv_name  TYPE thead-tdname,
        lt_LINES TYPE STANDARD TABLE OF tline.

  LOOP AT ct_bstkd ASSIGNING FIELD-SYMBOL(<f1>).

    lv_name = <f1>-bstkd.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'F22'
        language                = sy-langu
        name                    = lv_name
        object                  = 'EKKO'
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*       USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
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
    CLEAR: <f1>-us_cust.
    LOOP AT lt_lines INTO DATA(ls_lines).
      CONCATENATE <f1>-us_cust ls_lines-tdline INTO <f1>-us_cust SEPARATED BY space.
    ENDLOOP.
    CLEAR: lt_lines.
  ENDLOOP.
  UNASSIGN <f1>.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_Date_format
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <F1>_AEDAT1
*&      <-- <F1>_UDATE
*&---------------------------------------------------------------------*
FORM change_Date_format  USING    pu_date TYPE sy-datum
                         CHANGING pc_udate TYPE char11.

  CLEAR: pc_udate.
  IF pu_Date = '00000000' OR pu_date IS INITIAL.
    RETURN.
  ENDIF.

  CHECK pu_date IS NOT INITIAL.
* To get in DDMMMYY format
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = pu_date
    IMPORTING
      output = pc_udate.

* To get in DD-MMM-YYYY format
  CONCATENATE  pc_udate+0(2)  pc_udate+2(3)  pc_udate+5(4)
                 INTO  pc_udate SEPARATED BY '-'.
ENDFORM.
