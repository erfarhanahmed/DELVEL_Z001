*&---------------------------------------------------------------------*
*& Include          ZUS_STOCKFI_NEW_AMDP_DATADEC
*&---------------------------------------------------------------------*


TABLES: mara, mard.
SELECT-OPTIONS : S_MATNR  FOR MARA-MATNR,  "OBLIGATORY,
                 S_werks  FOR mard-werks. " OBLIGATORY.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002 .
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/USA'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN COMMENT /1(70) TEXT-005.
SELECTION-SCREEN: END OF BLOCK B3.

DATA : PR_COUNT TYPE I.
DATA  : GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
        GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV.

  DATA: it_matnr TYPE ztt_matnr_key,
        it_werks TYPE ztt_werks_key,
        LT_ET_SORT TYPE zcl_us_stockbank_amdp=>tt_sort.




TYPES : BEGIN OF TY_FINAL_DOWNLOAD,
          MATNR         TYPE MARA-MATNR,
          MATTXT        TYPE TEXT100,
          WRKST         TYPE MARA-WRKST,
          BRAND         TYPE MARA-BRAND,
          ZSERIES       TYPE MARA-ZSERIES,
          ZSIZE         TYPE MARA-ZSIZE,
          MOC           TYPE MARA-MOC,
          TYPE          TYPE MARA-TYPE,
          OPEN_QTY      TYPE CHAR15,
          PRICE         TYPE CHAR15,
          UN_QTY        TYPE CHAR15,
          UN_VAL        TYPE CHAR15,
          OPEN_QTY_V    TYPE CHAR15,
          LABST         TYPE CHAR15,
          LABST_V       TYPE CHAR15,
          KULAB         TYPE CHAR15,
          KULAB_V       TYPE CHAR15,
          FREE_STOCK    TYPE CHAR15,
          FREE_STOCK_V  TYPE CHAR15,
*          TRAN_QTY     TYPE CHAR15,
*          TRAN_QTY_V   TYPE CHAR15,
          TRAN_QTY_NEW      TYPE CHAR15,
          TRAN_QTY_V_NEW    TYPE CHAR15,
          SO_FALL_QTY   TYPE CHAR15,
          SO_FALL_QTY_V TYPE CHAR15,
          PEND_PO_QTY   TYPE CHAR15,
          PO_VALUE      TYPE CHAR15,
*          indent_qty    TYPE char15,
*          INDENT_QTY_V  TYPE char15,
          OPEN_INV      TYPE CHAR15,
          AMOUNT        TYPE CHAR15,
          VALUE         TYPE CHAR15,
          REF           TYPE CHAR15,
          BKLAS         TYPE MBEW-BKLAS,
          MTART         TYPE MARA-MTART,
          ERSDA         TYPE CHAR15,
           MENGE_104    TYPE CHAR15,"ADDED BY JYOTI ON 28.06.2024
         QTY_104_VAL  type char15,"Added by jyoti on 28.06.2024
*           TRAN_QTY_new      TYPE CHAR15,"ADDED BY JYOTI ON 28.06.2024
*          TRAN_QTY_V_new    TYPE CHAR15,"ADDED BY JYOTI ON 28.06.2024

        END OF TY_FINAL_DOWNLOAD.
  DATA : LT_FINAL TYPE TABLE OF TY_FINAL_DOWNLOAD,
       LS_FINAL TYPE TY_FINAL_DOWNLOAD.
