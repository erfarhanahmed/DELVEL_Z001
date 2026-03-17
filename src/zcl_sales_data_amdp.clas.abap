CLASS zcl_sales_data_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  TYPES: BEGIN OF TY_VBAP,
*             VBELN TYPE VBELN_VA,
*             POSNR TYPE POSNR_VA,
*             MATNR TYPE MATNR,
*             LGORT TYPE LGORT_D,
*             LFSTA TYPE LFSTA,
*             LFGSA TYPE LFGSA,
*             ABSTA TYPE ABSTA_VB,
*             GBSTA TYPE GBSTA,
          VBELN TYPE VBELN,
          POSNR TYPE POSNR,
          MATNR TYPE MATNR,    "edited by PJ 16-08-21
          LGORT TYPE VBAP-LGORT,     "Added by Pranit 10.06.2024
          LFSTA TYPE VBAP-LFSTA,
          LFGSA TYPE VBAP-LFGSA,
*          FKSTA TYPE VBUP-FKSTA,
          ABSTA TYPE VBAP-ABSTA,
          GBSTA TYPE VBAP-GBSTA,
         END OF TY_VBAP,

    BEGIN OF TY_MARA,
             MATNR TYPE MATNR,
             ITEM_TYPE TYPE CHAR1,
             BOM TYPE ZBOM,
             ZPEN_ITEM TYPE ZPEN_ITEM,
             ZRE_PEN_ITEM TYPE ZRE_PEN_ITEM,
         END OF TY_MARA,
         BEGIN OF TY_VBAK,
             VBELN TYPE VBELN_VA,
             ERDAT TYPE ERDAT,
             AUART TYPE AUART,
             LIFSK TYPE LIFSK,
             WAERK TYPE WAERK,
             VKBUR TYPE VKBUR,
             KNUMV TYPE KNUMV,
             VDATU TYPE EDATU_VBAK,
             BSTDK TYPE BSTDK,
             KUNNR TYPE KUNAG,
             OBJNR TYPE OBJKO,
             ZLDFROMDATE TYPE ZLDFROMDATE,
             ZLDPERWEEK TYPE ZLDPERWEEK1,
             ZLDMAX TYPE ZLDMAX,
             FAKSK TYPE FAKSK,
             VKORG TYPE VKORG,
             VTWEG TYPE VTWEG,
             SPART TYPE SPART,
         END OF   TY_VBAK.

   types:
    TT_VBAP TYPE TABLE OF TY_VBAP,
    TT_MARA TYPE TABLE OF TY_MARA,
    tt_vbak TYPE TABLE of TY_VBAK.

    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_sales_data
      IMPORTING
        VALUE(iv_date_low)   TYPE erdat
        VALUE(iv_date_high)  TYPE erdat
        VALUE(it_matnr)      TYPE TYP_R_MATNR "STANDARD TABLE OF matnr WITH EMPTY KEY
        VALUE(it_vbeln)      TYPE TDT_RG_VBELN "STANDARD TABLE OF vbeln_va WITH EMPTY KEY
        VALUE(it_kunnr)      TYPE TDT_RG_KUNNR "STANDARD TABLE OF kunnr WITH EMPTY KEY
      EXPORTING
        VALUE(et_data)       TYPE  TT_VBAP  "CCGLD_VBAP "STANDARD TABLE OF vbap
        VALUE(et_mara)       TYPE TT_MARA   "CIF_MARA_IBP_TAB "STANDARD TABLE OF mara
        VALUE(ET_VBAK)       type tt_vbak.
ENDCLASS.


CLASS zcl_sales_data_amdp IMPLEMENTATION.

  METHOD get_sales_data
    BY DATABASE PROCEDURE
    FOR HDB
    LANGUAGE SQLSCRIPT
    OPTIONS READ-ONLY USING VBAP MARA VBAK .

    -- Step 1: Select VBAP with conditions
    et_data = SELECT vbeln,
           posnr,
           matnr,
           lgort,
           lfsta,
           lfgsa,
           absta,
           gbsta
      FROM vbap
     WHERE erdat BETWEEN :iv_date_low AND :iv_date_high
       AND (
             NOT EXISTS (SELECT 1 FROM :it_matnr)
             OR matnr IN (SELECT matnr FROM :it_matnr)
           )
       AND (
             NOT EXISTS (SELECT 1 FROM :it_vbeln)
             OR vbeln IN (SELECT vbeln FROM :it_vbeln)
           )
       AND lfsta <> 'C'
       AND lfgsa <> 'C'
       AND gbsta <> 'C';
*      SELECT VBELN,
*             POSNR,
*             MATNR,
*             LGORT,
*             LFSTA,
*             LFGSA,
**             FKSTA,
*             ABSTA,
*             GBSTA
*        FROM VBAP
*       WHERE ERDAT BETWEEN :iv_date_low AND :iv_date_high
*         AND MATNR IN (SELECT matnr FROM :it_matnr)
*         AND VBELN IN (SELECT vbeln FROM :it_vbeln)
*         AND LFSTA <> 'C'
*         AND LFGSA <> 'C'
*         AND GBSTA <> 'C';

    -- Step 2: Filter out rows where ABSTA = 'C' and all status fields empty
    et_data =
      SELECT *
        FROM :et_data
       WHERE NOT (
             ABSTA = 'C'
         AND COALESCE(LFSTA, '') = ''
         AND COALESCE(LFGSA, '') = ''
         AND COALESCE(GBSTA, '') = ''
       );

    -- Step 3: Get MARA details for MATNRs
    et_mara =
      SELECT MATNR,
             ITEM_TYPE,
             BOM,
             ZPEN_ITEM,
             ZRE_PEN_ITEM
        FROM MARA
       WHERE MATNR IN (SELECT DISTINCT MATNR FROM :et_data);

    -- Step 4: Get VBAK details for VBELNs
    et_vbak =
      SELECT VBELN,
             ERDAT,
             AUART,
             LIFSK,
             WAERK,
             VKBUR,
             KNUMV,
             VDATU,
             BSTDK,
             KUNNR,
             OBJNR,
             ZLDFROMDATE,
             ZLDPERWEEK,
             ZLDMAX,
             FAKSK,
             VKORG,
             VTWEG,
             SPART
        FROM VBAK
       WHERE VBELN IN (SELECT DISTINCT VBELN FROM :et_data)
         AND KUNNR IN (SELECT DISTINCT KUNNR FROM :it_kunnr);

  ENDMETHOD.

ENDCLASS.

