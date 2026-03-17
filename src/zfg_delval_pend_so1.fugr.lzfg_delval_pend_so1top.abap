FUNCTION-POOL zfg_delval_pend_so1.          "MESSAGE-ID ..

* INCLUDE LZFG_DELVAL_PEND_SO1D...           " Local class definition

TYPES : BEGIN OF output,
          werks         TYPE werks_ext,
          auart         TYPE vbak-auart,
*          vkorg         type vbak-vkorg,      "added by aakashk 19.08.2024    eveng
*          vtweg         type vbak-vtweg,      "added by aakashk 19.08.2024
*          spart         type vbak-spart,      "added by aakashk 19.08.2024
          bstkd         TYPE vbkd-bstkd,
          name1         TYPE kna1-name1,
          vkbur         TYPE vbak-vkbur,
          vbeln         TYPE vbak-vbeln,
          erdat         TYPE vbak-erdat,
          vdatu         TYPE vbak-vdatu,
          status        TYPE text30,
          holddate      TYPE vbap-holddate,
          reldate       TYPE vbap-holdreldate,
          canceldate    TYPE vbap-canceldate,
          deldate       TYPE vbap-deldate,
*          tag_req      TYPE char20,
          tag_req       TYPE char250,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          tpi           TYPE char250,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          ld_txt        TYPE char250,           "changed by sr on 03.05.2021
          zldperweek    TYPE zldperweek1,
          zldmax        TYPE vbak-zldmax,
          zldfromdate   TYPE vbak-zldfromdate,

********
          matnr         TYPE vbap-matnr,
          posnr         TYPE vbap-posnr,
          arktx         TYPE vbap-arktx,
          kwmeng        TYPE vbap-kwmeng,
          stock_qty     TYPE mska-kalab,
*          kalab       TYPE mska-kalab,
          lfimg         TYPE lips-lfimg,
          fkimg         TYPE vbrp-fkimg,
          pnd_qty       LIKE vbrp-fkimg,
          ettyp         TYPE vbep-ettyp,
          mrp_dt        TYPE udate,
          edatu         TYPE vbep-edatu,
          kbetr         TYPE prcd_elements-kbetr,
          waerk         TYPE vbap-waerk,
          curr_con      TYPE ukursp,
*          amont         TYPE char250,             "kbetr,
          amont         TYPE char70,             "kbetr,
*          ordr_amt      TYPE char250,             "kbetr,
          ordr_amt      TYPE char70,             "kbetr,
          in_price      TYPE prcd_elements-kbetr,
          in_pr_dt      TYPE prcd_elements-kdatu,
          est_cost      TYPE prcd_elements-kbetr,
          latst_cost    TYPE prcd_elements-kbetr,
          st_cost       TYPE mbew-stprs,
          zseries       TYPE mara-zseries,
          zsize         TYPE mara-zsize,
          brand         TYPE mara-brand,
          moc           TYPE mara-moc,
          type          TYPE mara-type,

          """"""""   Added By KD 04.05.2017    """""""
          dispo         TYPE marc-dispo,
          wip           TYPE vbrp-fkimg,
          mtart         TYPE mara-mtart,
          kdmat         TYPE vbap-kdmat,
          kunnr         TYPE kna1-kunnr,
          qmqty         TYPE mska-kains,
          mattxt        TYPE text100,
          itmtxt        TYPE char255,
          etenr         TYPE vbep-etenr,
          schid         TYPE string,       "added by aakashk 20.08.2024
*          schid(25),
          so_exc        TYPE ukursp,
          zterm         TYPE vbkd-zterm,
          text1         TYPE t052u-text1,
          inco1         TYPE vbkd-inco1,
          inco2         TYPE vbkd-inco2,
          ofm           TYPE char50,
          ofm_date      TYPE char50,
          custdeldate   TYPE vbap-custdeldate,
          ref_dt        TYPE sy-datum,

          """"""""""""""""""""""""""""""""""""""""""""
          abgru         TYPE  vbap-abgru,            " avinash bhagat 20.12.2018
          bezei         TYPE  tvagt-bezei,         " avinash bhagat 20.12.2018
          wrkst         TYPE  mara-wrkst,
          cgst       TYPE  CHAR250,
          sgst       TYPE  CHAR250,
          igst       TYPE  CHAR250,
          ship_kunnr    TYPE kunnr,            "ship to party code
          ship_kunnr_n  TYPE ad_name1,         "ship to party desctiption
          ship_reg_n    TYPE bezei,            ""ship to party gst region description
          sold_reg_n    TYPE bezei,             "sold to party gst region description
          normt         TYPE mara-normt,
            ship_land     TYPE vbpa-land1,
             s_land_desc   TYPE t005t-landx50,
          sold_land     TYPE vbpa-land1,
          posex         TYPE vbap-posex,
          bstdk         TYPE ChaR11,"vbak-bstdk,
          lifsk         TYPE vbak-lifsk,
          vtext         TYPE tvlst-vtext,
          insur         TYPE char250,
          pardel        TYPE char250,
          gad           TYPE char250,
          us_cust       TYPE char250,
          tcs(11)       TYPE p DECIMALS 3,
          tcs_amt       TYPE prcd_elements-kwert,
          spl           TYPE char255,
          po_del_date   TYPE CHAR11,",vbap-custdeldate,
          ofm_no        TYPE char128,
          ctbg          TYPE char10,            "added by sr on 03.05.2021 ctbgi details
          certif        TYPE char255,             "added by sr on 03.05.2021 certification details
          item_type     TYPE mara-item_type, " edited by PJ on 16-08-21
          ref_time      TYPE char250,          " edited by PJ on 08-09-21
          proj          TYPE char255,                         "added by pankaj 28.01.2022
          cond          TYPE char255,                       "added by pankaj 28.01.2022
          receipt_date  TYPE vbap-receipt_date,          "added by pankaj 28.01.2022
          reason        TYPE CHAR30,                "added by pankaj 28.01.2022
          ntgew         TYPE vbap-ntgew,          "added by pankaj 28.01.2022
          zpr0          TYPE kwert,              "added by pankaj 28.01.2022
          zpf0          TYPE kwert,              "added by pankaj 28.01.2022
          zin1          TYPE kwert,              "added by pankaj 28.01.2022
          zin2          TYPE kwert,             "added by pankaj 28.01.2022
          joig          TYPE kwert,              "added by pankaj 28.01.2022
          jocg          TYPE kwert,              "added by pankaj 28.01.2022
          josg          TYPE kwert,                "added by pankaj 28.01.2022
          date          TYPE vbep-edatu,
          prsdt         TYPE vbkd-prsdt,
          packing_type  TYPE char255,
          ofm_date1     TYPE char250,  "vbap-ofm_date,
          mat_text      TYPE char15,
          infra         TYPE char255,         "added by pankaj 31.01.2022
          validation    TYPE char255,         "added by pankaj 31.01.2022
          review_date   TYPE char255,         "added by pankaj 31.01.2022   b
          diss_summary  TYPE char255,        "added by pankaj 31.01.2022
          chang_so_date TYPE vbap-erdat,
          """""""" added by pankaj 04.02.2022
          port          TYPE adrc-name1,
          full_pmnt     TYPE char255,
          act_ass       TYPE tvktt-vtext,
          txt04         TYPE tj30t-txt04,
          freight       TYPE char128,
          po_sr_no      TYPE char128,
          udate         TYPE char15,            "cdhdr-udate,
          bom           TYPE mara-bom,
          zpen_item     TYPE mara-zpen_item,
          zre_pen_item  TYPE mara-zre_pen_item,
           zins_loc      type VBAP-zins_loc,
          BOM_EXIST TYPE CHAR5,
          posEx1 type vbap-posex,"adde by jyoti on 16.04.2024
          lgort   type vbap-lgort,"aded by jyoti 11.06.2024
          quota_ref    type CHAR128, "added by jyoti on19.06.2024
          zmrp_Date TYPE vbap-zmrp_date, "Added by jyoti on 02.07.2024
          VKORG     TYPE VBAK-VKORG,    "ADDED BY AAKASHK 19.08.2024
          VTWEG     TYPE VBAK-VTWEG,    "ADDED BY AAKASHK 19.08.2024
          SPART     TYPE VBAK-SPART,     "ADDED BY AAKASHK 19.08.2024
          ZEXP_MRP_DATE1 TYPE vbap-ZEXP_MRP_DATE1, "Added by jyoti on 13.11.2024
          special_comm   TYPE char250,
          zcust_proj_name type char250, "added by jyoti on 04.12.2024
          Amendment_his TYPE char250,"added by jyoti on 20.01.2025
          po_dis TYPE char250,"added by jyoti on 20.01.2025
          zhold_reason_n1 TYPE vbap-zhold_reason_n1,"added by jyoti on 06.02.2025
        END OF output.

DATA:  it_output      TYPE STANDARD TABLE OF output.
