*&---------------------------------------------------------------------*
*& Include          ZUS_MATERIAL_EXTENSION_TOP
*&---------------------------------------------------------------------*
TABLES : sscrfields.

TYPE-POOLS ole2 .

DATA: application TYPE ole2_object,
      workbook    TYPE ole2_object,
      sheet       TYPE ole2_object,
      cells       TYPE ole2_object,
      cell1       TYPE ole2_object,
      cell2       TYPE ole2_object,
      range       TYPE ole2_object,
      font        TYPE ole2_object,
      column      TYPE ole2_object,
      shading     TYPE ole2_object,
      border      TYPE ole2_object.

CONSTANTS: row_max TYPE i VALUE 256.
DATA: index TYPE i.
DATA: ld_colindx TYPE i,   "COLUMN INDEX
      ld_rowindx TYPE i.   "ROW INDEX

TYPES:BEGIN OF t_data,
        field1  TYPE string,
        field2  TYPE string,
        field3  TYPE string,
        field4  TYPE string,
        field5  TYPE string,
        field6  TYPE string,
        field7  TYPE string,
        field8  TYPE string,
        field9  TYPE string,
        field10 TYPE string,
        field11 TYPE string,
        field12 TYPE string,
        field13 TYPE string,
        field14 TYPE string,
        field15 TYPE string,
        field16 TYPE string,
        field17 TYPE string,
        field18 TYPE string,
        field19 TYPE string,
        field20 TYPE string,
        field21 TYPE string,
        field22 TYPE string,
        field23 TYPE string,
        field24 TYPE string,
        field25 TYPE string,
        field26 TYPE string,
        field27 TYPE string,
        field28 TYPE string,
        field29 TYPE string,
        field30 TYPE string,
        field31 TYPE string,
        field32 TYPE string,
        field33 TYPE string,
        field34 TYPE string,
        field35 TYPE string,
        field36 TYPE string,

      END OF t_data.

DATA: it_data TYPE STANDARD TABLE OF t_data,
      ls_data LIKE LINE OF it_data.

FIELD-SYMBOLS: <fs>.

TYPES: trux_t_text_data(4096) TYPE c OCCURS 0.
DATA : it_raw TYPE trux_t_text_data.
*
*TYPES : BEGIN OF str,
*          matnr(30),
*        END OF str.

TYPES:BEGIN OF ty_final,
        matnr      TYPE matnr,
        ind_sector TYPE mbrsh,
        matl_type  TYPE mtart,
        plant      TYPE werks_d,
        pur_group  TYPE ekgrp,
        mrp_profile TYPE DISPR,
        mrp_type   TYPE dismm,
        mrp_ctrler TYPE dispo,
        plnd_delry TYPE plifz,
        gr_pr_time TYPE WEBAZ,
        period_ind TYPE perkz,
        lotsizekey TYPE disls,
        proc_type  TYPE beskz,
        sm_key     TYPE FHORI,
        availcheck TYPE mtvfp,
        profit_ctr TYPE prctr,
        stge_loc   TYPE lgort_d,
        price_ctrl TYPE vprsv,
        moving_pr  TYPE verpr_bapi,
        std_price  TYPE stprs_bapi,
        price_unit TYPE peinh,
        val_class  TYPE bklas,
        MOV_PR_PP TYPE VMVER_BAPI,
        STD_PR_PP type VMSTP_BAPI,
        pr_unit_pp TYPE VMPEI,
        sales_org  TYPE vkorg,
        distr_chan TYPE vtweg,
         MIN_order Type	MINAU,
        MIN_DELY Type	MINLF,
        MIN_MTO	 Type	MINEF,
        DELY_UNIT Type  SCHRT,
        matl_desc  TYPE maktx,
      END OF ty_final.


DATA : itab TYPE TABLE OF ty_final,
       wa   TYPE ty_final.

DATA : lw_header               TYPE bapimathead,
       lv_plantdata            TYPE bapi_marc,
       lv_plantdatax           TYPE bapi_marcx,
       lv_planningdata         TYPE bapi_mpgd,
       lv_planningdatax        TYPE bapi_mpgdx,
       lv_storagelocationdata  TYPE bapi_mard,
       lv_storagelocationdatax TYPE bapi_mardx,
       lv_valuationdata        TYPE bapi_mbew,
       lv_valuationdatax       TYPE bapi_mbewx,
       lv_salesdata            TYPE bapi_mvke,
       lv_salesdatax           TYPE bapi_mvkex,
       lt_materialdescription  TYPE STANDARD TABLE OF bapi_makt WITH HEADER LINE,
       ret                     TYPE STANDARD TABLE OF bapiret2 WITH HEADER LINE,
       retmat                  TYPE STANDARD TABLE OF bapi_matreturn2 WITH HEADER LINE.


TYPES : BEGIN OF str_log,
          matnr(18),        " MATERIAL NO
          maktx(40),        " DESCRIPTION
          werks(4),         " PLANT
          lgort(4),          " STORAGE LOCATION
          status(100),     " status
        END OF str_log.
DATA : it_log TYPE TABLE OF str_log,
       wa_log TYPE str_log.

DATA : it_fcat TYPE slis_t_fieldcat_alv,
       wa_fcat TYPE slis_fieldcat_alv.
