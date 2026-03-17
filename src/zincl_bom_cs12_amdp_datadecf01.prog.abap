*&---------------------------------------------------------------------*
*& Include          ZINCL_BOM_CS12_AMDP_DATADECF01
*&---------------------------------------------------------------------*


TABLES: MARA, MAST.

*&*--------------------------------------------------------------------*
*&* SELECTION SCREEN
*&*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
  SELECT-OPTIONS : S_MATNR  FOR MARA-MATNR  NO INTERVALS OBLIGATORY.
*                   S_STLAN for MAST-STLAN no INTERVALS NO-EXTENSION.

  PARAMETERS     : PM_WERKS LIKE MARC-WERKS OBLIGATORY,
                   PM_DATUV LIKE STKO-DATUV DEFAULT SY-DATUM,
                   PM_STLAN LIKE STZU-STLAN,
                   PM_STLAL LIKE STKO-STLAL,
                   PM_CAPID LIKE TC04-CAPID,
                   CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK B1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.
PARAMETERS  P_HIDDEN TYPE CHAR8 NO-DISPLAY.
****_---------------------------------------------------------------------
PARAMETERS: P_VAR TYPE DISVARIANT-VARIANT.
PARAMETERS: p_BG TYPE abap_bool AS CHECKBOX DEFAULT abap_false.

*PARAMETERS:
DATA:
  P_MATNR TYPE MAST-MATNR, " OBLIGATORY,
  P_WERKS TYPE MAST-WERKS. "OBLIGATORY.




TYPES:
  BEGIN OF TY_FINAL,
    BOM_LEVEL_V                  TYPE char11,
    POSNR                      TYPE STPO-POSNR,
    MATNR                      TYPE ABOMITEMS-BILLOFMATERIALCOMPONENT,
    MATERIAL_TEXT              TYPE STRING,
    ZEINR                      TYPE MARA-ZEINR,
    MENGE                      TYPE STPO-MENGE,
    MEINS                      TYPE STPO-MEINS,
    BILLOFMATERIALITEMCATEGORY TYPE STPO-POSTP,
    AUSNM                      TYPE AUSNM,   "Exception'
    SGT_RCAT                   TYPE SGT_RCAT, "Requirement Segment'
    SGT_SCAT                   TYPE SGT_SCAT, "Stock Segment
    VERPR                      TYPE MBEW-VERPR,
    MTART                      TYPE MARA-MTART, "Material Long Text EN'
    MATERIAL_TEXT_ES             TYPE string,
*    ZZTEXT_SP                  TYPE CHAR250, "Material Long Text SP
    REFRESH_DATE                     TYPE CHAR11, "'Refreshed On'
  END OF TY_FINAL.
DATA: IT_FINAL1 TYPE TABLE OF  TY_FINAL.

TYPES:
  BEGIN OF TY_FINAL1,
    BOM_LEVEL_V                  TYPE char11,
    POSNR                      TYPE STPO-POSNR,
    MATNR                      TYPE ABOMITEMS-BILLOFMATERIALCOMPONENT,
    MATERIAL_TEXT              TYPE STRING,
    ZEINR                      TYPE MARA-ZEINR,
    MENGE                      TYPE char15, "STPO-MENGE,
    MEINS                      TYPE STPO-MEINS,
    BILLOFMATERIALITEMCATEGORY TYPE STPO-POSTP,
    AUSNM                      TYPE AUSNM,   "Exception'
    SGT_RCAT                   TYPE SGT_RCAT, "Requirement Segment'
    SGT_SCAT                   TYPE SGT_SCAT, "Stock Segment
    VERPR                      TYPE char25, "MBEW-VERPR,
    MTART                      TYPE string, "MARA-MTART, "Material Long Text EN'
    REFRESH_DATE                     TYPE CHAR11 , "'Refreshed On'
    MATERIAL_TEXT_ES             TYPE string,
*    ZZTEXT_SP                  TYPE CHAR250, "Material Long Text SP

  END OF TY_FINAL1.
DATA: wa_FINAL_download TYPE ty_final1,
      IT_FINAL_download TYPE TABLE OF  TY_FINAL1.

DATA:
  LT_BOM       TYPE ZCL_BOM_EXPLOSION=>TT_BOM_ITEM_WITH_TEXT,
  LT_BOM_FINAL TYPE ZCL_BOM_EXPLOSION_NEW=>TT_BOM_ITEM_WITH_TEXT_MASS, "tt_bom_item, ""zcl_bom_explosion=>tt_bom_item_with_text,
  LX_AMDP      TYPE REF TO CX_AMDP_ERROR.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT,
      POS     TYPE I VALUE 0.
TYPES: BEGIN OF ZST_STLAN_RANGE,
         SIGN   TYPE C LENGTH 1,
         OPTION TYPE C LENGTH 2,
         LOW    TYPE MAST-STLAN,
         HIGH   TYPE MAST-STLAN,
       END OF ZST_STLAN_RANGE.

TYPES: BEGIN OF ZST_STLAL_RANGE,
         SIGN   TYPE C LENGTH 1,    " 'I' / 'E'
         OPTION TYPE C LENGTH 2,    " 'EQ', 'BT', etc.
         LOW    TYPE MAST-STLAL,
         HIGH   TYPE MAST-STLAL,
       END OF ZST_STLAL_RANGE.

TYPES: TT_ZST_STLAN_RANGE TYPE TABLE OF ZST_STLAN_RANGE WITH EMPTY KEY,
       TT_ZST_STLAL_RANGE TYPE TABLE OF ZST_STLAL_RANGE WITH EMPTY KEY.

DATA: IT_STLAN           TYPE TT_ZST_STLAN_RANGE,
      WA_ZST_STLAN_RANGE TYPE  ZST_STLAN_RANGE,
      IT_STLAL           TYPE  TT_ZST_STLAL_RANGE,
      WA_STLAL           TYPE ZST_STLAL_RANGE.
