*&---------------------------------------------------------------------*
*& Report ZBOM_REPORTS_P
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_SOS04_IND_BOM_WIP_N_SAN_P.
TABLES: VBAP, MARA, VBAK.

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

TYPES: BEGIN OF TY_FINAL,
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
       END OF TY_FINAL.


DATA: LT_FINAL  TYPE TABLE OF TY_FINAL,
      LS_FINAL  TYPE          TY_FINAL,
      LT_FINAL1 TYPE TABLE OF TY_FINAL,
      LS_FINAL1 TYPE          TY_FINAL.

DATA GT_OUTPUT_DWN TYPE TABLE OF TY_MAIN_DWN.
DATA GS_OUTPUT_DWN TYPE  TY_MAIN_DWN.
DATA GT_OUTPUT_DWN1 TYPE TABLE OF TY_MAIN_DWN.
DATA GS_OUTPUT_DWN1 TYPE  TY_MAIN_DWN.

DATA : SYSTEM      TYPE RZLLI_APCL,
       TASKNAME(8) TYPE C,
       ASCI_TAB    TYPE TABLE OF ZZZ_ASCI_TAB,
       ASCI_TAB1   TYPE TABLE OF ZZZ_ASCI_TAB,
       WA_ASCI_TAB TYPE ZZZ_ASCI_TAB,
       INDEX(3)    TYPE C,
       INDEX1      TYPE I,
       SND_JOBS    TYPE I,
       RCV_JOBS    TYPE I,
       EXC_FLAG    TYPE I,
       MESS        TYPE C LENGTH 80.

DATA: LV_PER_CHUNK TYPE I,
      LV_INDEX     TYPE I VALUE 0,
      LV_REMAINDER TYPE I.

DATA: IT_WPINFO TYPE TABLE OF  WPINFO .

DATA: LV_XML TYPE STRING.
CONSTANTS: DONE(1) TYPE C VALUE 'X'.
DATA: FUNCTIONCALL1(1) TYPE C.


SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .

    PARAMETERS      P_WERKS TYPE MARC-WERKS DEFAULT 'PL01' .
    SELECT-OPTIONS: S_VBELN FOR VBAP-VBELN,
                    S_MATNR FOR MARA-MATNR,
                    S_EDATU FOR VBAK-VDATU.
  SELECTION-SCREEN END OF BLOCK B2.
  SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME.
    PARAMETERS: P_HDONLY AS CHECKBOX.
    PARAMETERS: P_NOZERO AS CHECKBOX.
  SELECTION-SCREEN END OF BLOCK B3.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.  "H:\planning\actuator'  ##NO_TEXT
  .
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.

CALL FUNCTION 'TH_WPINFO'
* EXPORTING
*   SRVNAME             = ' '
*   WITH_CPU            = 0
*   WITH_MTX_INFO       = 0
*   MAX_ELEMS           = 0
  TABLES
    WPLIST = IT_WPINFO
* EXCEPTIONS
*   SEND_ERROR          = 1
*   OTHERS = 2
  .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

DELETE IT_WPINFO WHERE WP_TYP <> 'BGD' OR WP_STATUS <> 'Waiting'.
DESCRIBE TABLE IT_WPINFO LINES DATA(LV_AVAILABLEWP).
LV_AVAILABLEWP = LV_AVAILABLEWP / 2.

SELECT  A~VBELN
        A~POSNR
        A~MATNR
        A~LFSTA
        A~WERKS
        B~EDATU
  INTO CORRESPONDING FIELDS OF TABLE LT_FINAL
  FROM VBAP AS A
  JOIN VBEP AS B ON A~VBELN = B~VBELN
                 AND A~POSNR = B~POSNR
   WHERE A~VBELN IN S_VBELN
     AND A~WERKS EQ P_WERKS
     AND A~MATNR IN S_MATNR
     AND B~EDATU IN S_EDATU.

DESCRIBE TABLE LT_FINAL LINES DATA(LV_LINES).
LV_PER_CHUNK = LV_LINES DIV 25. "LV_AVAILABLEWP.
LV_REMAINDER = LV_LINES MOD 25. "LV_AVAILABLEWP.
IF LV_PER_CHUNK = 0.
  LV_PER_CHUNK = 1.
ENDIF.


SYSTEM = 'ZSOS_parallel_generators'.

SORT LT_FINAL BY VBELN.
DELETE ADJACENT DUPLICATES FROM LT_FINAL COMPARING VBELN.
LOOP AT LT_FINAL ASSIGNING FIELD-SYMBOL(<FS_FINAL>).
  LV_INDEX =  LV_INDEX + 1.
  S_VBELN-SIGN = 'I'.
  S_VBELN-OPTION = 'EQ'.
  S_VBELN-LOW = <FS_FINAL>-VBELN.
  APPEND S_VBELN.

  IF ( LV_INDEX MOD LV_PER_CHUNK = 0 AND LV_INDEX < LV_LINES )  OR ( LV_INDEX = LV_LINES ).
    INDEX = INDEX + 1.
    CONCATENATE 'ZSOS' INDEX INTO TASKNAME.
    CALL FUNCTION 'ZFM_ZPP_SOS04_IND_BOM_WIP_N_SA'
      STARTING NEW TASK TASKNAME
      DESTINATION 'NONE'
      PERFORMING PROCESS_PARALLEL ON END OF TASK
      EXPORTING
        WERKS = P_WERKS
      TABLES
        VBELN = S_VBELN[]
        MATNR = S_MATNR[]
        EDATU = S_EDATU[].
    CASE SY-SUBRC.
      WHEN 0.
        SND_JOBS = SND_JOBS + 1.
      WHEN 1 OR 2.
        MESSAGE MESS TYPE 'I'.
      WHEN 3.
        IF SND_JOBS >= 1 AND
        EXC_FLAG = 0.
          EXC_FLAG = 1.
          WAIT UNTIL RCV_JOBS >= SND_JOBS UP TO 10 SECONDS.
        ENDIF.
        IF SY-SUBRC = 0.
          EXC_FLAG = 0.
        ELSE.
          MESSAGE 'Resource failure' TYPE 'I'.
        ENDIF.
      WHEN OTHERS.
        MESSAGE 'Other error' TYPE 'I'.
    ENDCASE.
    CLEAR:S_VBELN[].
  ENDIF.
ENDLOOP.

WAIT UNTIL RCV_JOBS >= SND_JOBS .
PERFORM DOWN_SET IN PROGRAM ZPP_SOS04_IND_BOM_WIP_N_SAN TABLES GT_OUTPUT_DWN[] USING P_FOLDER.

FORM PROCESS_PARALLEL USING TASKNAME.

  RCV_JOBS = RCV_JOBS + 1.

  RECEIVE RESULTS FROM FUNCTION 'ZFM_ZPP_SOS04_IND_BOM_WIP_N_SA'
  IMPORTING
   LV_JSON        =  LV_XML.

  FUNCTIONCALL1 = DONE.


  CALL TRANSFORMATION ID
    SOURCE XML LV_XML
    RESULT MY_TABLE = GT_OUTPUT_DWN1[] .
  APPEND LINES OF GT_OUTPUT_DWN1[] TO GT_OUTPUT_DWN[].
  CLEAR:GT_OUTPUT_DWN1[],LV_XML.
ENDFORM.
