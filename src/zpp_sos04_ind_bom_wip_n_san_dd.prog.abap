*&---------------------------------------------------------------------*
*& Include          ZPP_SOS04_IND_BOM_WIP_N_SAN_DD
*&---------------------------------------------------------------------*
TABLES: VBAP, MARA, VBAK.

DATA: R_VBELN TYPE TABLE OF /CWM/R_VBELN WITH HEADER LINE.
DATA: s_mat TYPE TABLE OF rsmatnr WITH HEADER LINE.
DATA: IT_WPINFO TYPE TABLE OF  WPINFO.

DATA: LV_PER_CHUNK     TYPE I,
      SYSTEM           TYPE RZLLI_APCL,
      LV_INDEX         TYPE I VALUE 0,
      INDEX(3)         TYPE C,
      TASKNAME(10)      TYPE C,
      RCV_JOBS         TYPE I,
      SND_JOBS         TYPE I,
      FUNCTIONCALL1(1) TYPE C,
      LV_REMAINDER     TYPE I,
      EXC_FLAG         TYPE I,
      MESS             TYPE C LENGTH 80.
CONSTANTS: DONE(1) TYPE C VALUE 'X'.


      TYPES: BEGIN OF TY_MAIN,
         IDNRK    TYPE STPOX-IDNRK,       "component
         VBELN    TYPE VBAP-VBELN,        "Sales Document
         POSNR    TYPE VBAP-POSNR,        "Sales Document Item
         ETENR    TYPE VBEP-ETENR,        "Delivery Schedule Line Number
*         idtxt    TYPE makt-maktx,        "Component
         IDTXT    TYPE CHAR255,            "Component       :: Added By KD on 01.06.2017
         MATNR    TYPE VBAP-MATNR,        "Material Number
*         arktx    TYPE vbap-arktx,        "Short text for sales order item
         ARKTX    TYPE CHAR255,           "Short text for sales order item    :: Added By KD on 02.06.2017
         WERKS    TYPE VBAP-WERKS,        "Plant
         LFSTA    TYPE VBUP-LFSTA,        "Delivery status
         EDATU    TYPE VBEP-EDATU,        "Requested delivery date
         EDATUF   TYPE CHAR12,
         DELDATE  TYPE VBAP-DELDATE,      "Delivery Date
         DELDATEF TYPE CHAR12,
         ACTDT    TYPE MDPS-DAT00,        "Action Date
         ACTDTF   TYPE CHAR12,
         REQDT    TYPE SY-DATUM,          "Requirement Date
         REQDTF   TYPE CHAR12,
         SCHID    TYPE CHAR25,            "Schedule ID
         KUNNR    TYPE VBAK-KUNNR,        "Customer code
         VKBUR    TYPE VBAK-VKBUR,        "Branch
         MEINS    TYPE VBAP-MEINS,        "Unit of Measurement
         WMENG    TYPE VBEP-WMENG,        "Cumulative Order Quantity in Sales Units
         OMENG    TYPE VBBE-OMENG,        "Open SO Quantity   "Open Qty in Stockkeeping Units for Transfer of Reqmts to MRP
         WIPQT    TYPE MNG01,             "WIP Stock
         WIPOT    TYPE MNG01,             "WIP Other
         WITOT    TYPE MNG01,             "WIP Total
         UNST1    TYPE MNG01,             "SO Unrestricted Stock
         UNSTK    TYPE MNG01,             "Other Unrestricted Stock
         UNTOT    TYPE MNG01,             "Tot Unrestricted Stock
         QMSTK    TYPE MNG01,             "Quality Stock
         QMTOT    TYPE MNG01,
         SHRTQ    TYPE MNG01,             "Shortage Quantity
         VNSTK    TYPE MNG01,             "Vendor Stock
         VNTOT    TYPE MNG01,             "total Vendor Stock
         ASNQTY   TYPE MNG01,             "PO Quantity
         ASNTOT   TYPE MNG01,             "PO Total
         POQTY    TYPE MNG01,             "PO Quantity
         POTOT    TYPE MNG01,             "PO Total
         INDQT    TYPE MNG01,             "Net Indent
         VERPR    TYPE MBEW-VERPR,        "Moving Average Price
         PLIFZ    TYPE MARC-PLIFZ,        "Lead time
         EKGRP    TYPE MARC-EKGRP,        "Purchasing group
         DISPO    TYPE MARC-DISPO,        "MRP Controller
         BRAND    TYPE MARA-BRAND,        "Brand
         ZSERIES  TYPE MARA-ZSERIES,      "Series
         ZSIZE    TYPE MARA-ZSIZE,        "Size
         MOC      TYPE MARA-MOC,          "MOC
         TYPE     TYPE MARA-TYPE,         "Type
         BOMLV(2) TYPE N,                 "BOM Level
         MTART    TYPE MARA-MTART,        "Material type
         BISMT    TYPE MARA-BISMT,        "Old Mat No.
         BESKZ    TYPE MARC-BESKZ,        "Procurement Type
         SOBSL    TYPE MARC-SOBSL,        "Special procurement type
         EXTRA    TYPE MDEZ-EXTRA,        "MRP element data
         LABST    TYPE MARD-LABST,        "Valuated Unrestricted-Use Stock
         UPLVL    TYPE CHAR40,
         LEVEL    TYPE CHAR40,
         NAME1    TYPE KNA1-NAME1,
         STPRS    TYPE MBEW-STPRS,
         ZEINR    TYPE MARA-ZEINR,
         PARENT   TYPE STPOX-IDNRK,  "added By Pankaj on 09.02.2023
         REFDT    TYPE CHAR12,
*         REMARKS  TYPE CHAR18,
         VERPRN   TYPE CHAR16,
         STPRSN   TYPE CHAR16,
         WMENGN   TYPE CHAR16,
         OMENGN   TYPE CHAR16,
         WIPQTN   TYPE CHAR16,
         WIPOTN   TYPE CHAR16,
         WITOTN   TYPE CHAR16,
         UNST1N   TYPE CHAR16,
         UNSTKN   TYPE CHAR16,
         UNTOTN   TYPE CHAR16,
         QMSTKN   TYPE CHAR16,
         QMTOTN   TYPE CHAR16,
         SHRTQN   TYPE CHAR16,
         VNSTKN   TYPE CHAR16,
         VNTOTN   TYPE CHAR16,
         ASNQTYN  TYPE CHAR16,
         ASNTOTN  TYPE CHAR16,
         POQTYN   TYPE CHAR16,
         POTOTN   TYPE CHAR16,
         INDQTN   TYPE CHAR16,
         ANDAT    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         ANNAM    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         AEDAT    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         AENAM    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         LGORT    TYPE VBAP-LGORT, "ADDED BY JYOTI ON 11.06.2024
         REQ_QTY  TYPE CHAR16,  "ADDED BY JYOTI ON 08.04.2025
*         RECEIPT_DATE  TYPE VBAP-RECEIPT_DATE,"addded by primus jyoti on 20.12.2023
*         RECEIPTDATE TYPE CHAR12,
       END OF TY_MAIN.
TYPES: BEGIN OF TY_MAIN_DWN,
         IDNRK    TYPE STPOX-IDNRK,       "component
         VBELN    TYPE VBAP-VBELN,        "Sales Document
         POSNR    TYPE VBAP-POSNR,        "Sales Document Item
         ETENR    TYPE VBEP-ETENR,        "Delivery Schedule Line Number
*         idtxt    TYPE makt-maktx,        "Component
         IDTXT    TYPE CHAR255,            "Component       :: Added By KD on 01.06.2017
         MATNR    TYPE VBAP-MATNR,        "Material Number
*         arktx    TYPE vbap-arktx,        "Short text for sales order item
         ARKTX    TYPE CHAR255,           "Short text for sales order item    :: Added By KD on 02.06.2017
         WERKS    TYPE VBAP-WERKS,        "Plant
         LFSTA    TYPE VBUP-LFSTA,        "Delivery status
*         EDATU    TYPE VBEP-EDATU,        "Requested delivery date
         EDATUF   TYPE CHAR12,
*         DELDATE  TYPE VBAP-DELDATE,      "Delivery Date
         DELDATEF TYPE CHAR12,
*         ACTDT    TYPE MDPS-DAT00,        "Action Date
         ACTDTF   TYPE CHAR12,
*         REQDT    TYPE SY-DATUM,          "Requirement Date
         REQDTF   TYPE CHAR12,
         SCHID    TYPE CHAR25,            "Schedule ID
         KUNNR    TYPE VBAK-KUNNR,        "Customer code
         VKBUR    TYPE VBAK-VKBUR,        "Branch
         MEINS    TYPE VBAP-MEINS,        "Unit of Measurement
         WMENGN   TYPE CHAR16,
         OMENGN   TYPE CHAR16,
         WIPQTN   TYPE CHAR16,
         WIPOTN   TYPE CHAR16,
         WITOTN   TYPE CHAR16,
         UNST1N   TYPE CHAR16,
         UNSTKN   TYPE CHAR16,
         UNTOTN   TYPE CHAR16,
         QMSTKN   TYPE CHAR16,
         QMTOTN   TYPE CHAR16,
         SHRTQN   TYPE CHAR16,
         VNSTKN   TYPE CHAR16,
         VNTOTN   TYPE CHAR16,
         ASNQTYN  TYPE CHAR16,
         ASNTOTN  TYPE CHAR16,
         POQTYN   TYPE CHAR16,
         POTOTN   TYPE CHAR16,
         INDQTN   TYPE CHAR16,
         VERPRN   TYPE CHAR16,        "Moving Average Price
         PLIFZ    TYPE MARC-PLIFZ,        "Lead time
         EKGRP    TYPE MARC-EKGRP,        "Purchasing group
         DISPO    TYPE MARC-DISPO,        "MRP Controller
         BRAND    TYPE MARA-BRAND,        "Brand
         ZSERIES  TYPE MARA-ZSERIES,      "Series
         ZSIZE    TYPE MARA-ZSIZE,        "Size
         MOC      TYPE MARA-MOC,          "MOC
         TYPE     TYPE MARA-TYPE,         "Type
         BOMLV(2) TYPE N,                 "BOM Level
         MTART    TYPE MARA-MTART,        "Material type
         BISMT    TYPE MARA-BISMT,        "Old Mat No.
         BESKZ    TYPE MARC-BESKZ,        "Procurement Type
         SOBSL    TYPE MARC-SOBSL,        "Special procurement type
         EXTRA    TYPE MDEZ-EXTRA,        "MRP element data
         LABST    TYPE MARD-LABST,        "Valuated Unrestricted-Use Stock
         UPLVL    TYPE CHAR40,
         LEVEL    TYPE CHAR40,
         NAME1    TYPE KNA1-NAME1,
         STPRSN   TYPE CHAR16,
         ZEINR    TYPE MARA-ZEINR,
         REFDT    TYPE CHAR12,
*         REMARKS  TYPE CHAR18,
         ANDAT    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         ANNAM    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         AEDAT    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         AENAM    TYPE CHAR16, "addded by primus jyoti on 01.12.2023
         LGORT    TYPE VBAP-LGORT, "ADDED BY JYOTI ON 11.06.2024
         REQ_QTY  TYPE CHAR16,  "ADDED BY JYOTI ON 08.04.2025
*         RECEIPT_DATE    TYPE CHAR12,"addded by primus jyoti on 20.12.2023
*         RECEIPTDATE TYPE CHAR12,
       END OF TY_MAIN_DWN.
DATA GT_LIST   TYPE TABLE OF TY_MAIN.
DATA GT_LIST3   TYPE TABLE OF TY_MAIN.
DATA GT_LIST_AP   TYPE TABLE OF TY_MAIN.
DATA GT_LIST1   TYPE TABLE OF TY_MAIN.
DATA GT_LIST2   TYPE TABLE OF TY_MAIN.
DATA GT_LIST_AP1   TYPE TABLE OF TY_MAIN.
DATA GT_COMPS  TYPE TABLE OF TY_MAIN.
DATA GT_COMPS1  TYPE TABLE OF TY_MAIN.
DATA GT_WIP1 TYPE TABLE OF ty_main.
DATA GT_WIP1_1 TYPE TABLE OF ty_main.
DATA GT_OUTPUT_DWN TYPE TABLE OF TY_MAIN_DWN.


DATA: LV_XML TYPE STRING.
DATA: LV_XML_GT_COMPS TYPE STRING.
DATA: LV_JSON_GT_WIP1 TYPE STRING.
DATA: LV_JSON_GT_LIST_AP TYPE STRING.

DATA GT_MAIN   TYPE TABLE OF TY_MAIN.
DATA GT_MAIN_COPY   TYPE TABLE OF TY_MAIN.
