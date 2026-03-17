*&---------------------------------------------------------------------*
*& Report ZPP_SOS01
*&---------------------------------------------------------------------*
*&After action date issue resolved
*&---------------------------------------------------------------------*
REPORT ZPP_SOS04_IND_BOM_WIP_N_SAN_V1.


*>>
TABLES: VBAP, MARA, VBAK.

*>>
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

       DATA: lv_VBELN    TYPE VBAP-VBELN,
      lv_POSNR    TYPE char6.

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
*>>
DATA GT_MAIN   TYPE TABLE OF TY_MAIN.
DATA GT_COMPS  TYPE TABLE OF TY_MAIN.
DATA GT_OUTPUT TYPE TABLE OF TY_MAIN.
DATA GS_OUTPUT TYPE  TY_MAIN.
DATA GT_OUTPUT_DWN TYPE TABLE OF TY_MAIN_DWN.
DATA GT_DWN TYPE TABLE OF TY_MAIN_DWN.
DATA GS_OUTPUT_DWN TYPE  TY_MAIN_DWN.
DATA GS_DWN TYPE  TY_MAIN_DWN.
DATA GT_LIST   TYPE TABLE OF TY_MAIN.
DATA GT_WIP1   TYPE TABLE OF TY_MAIN.
DATA GT_WIP2   TYPE TABLE OF TY_MAIN.
*DATA gt_out2   TYPE TABLE OF ty_main.
DATA GT_UNS1   TYPE TABLE OF TY_MAIN.


DATA : E_MT61D TYPE  MT61D,
       E_MDKP  TYPE  MDKP,
       E_CM61M TYPE  CM61M,
       E_MDSTA TYPE  MDSTA,
       E_ERGBZ TYPE  SFILT-ERGBZ,
       E_CM61W TYPE  CM61W,
       MDSUX   TYPE TABLE OF MDSU.

DATA: WA_ZSAL TYPE ZSALES_SHORTAGE.
DATA: LV_BEGDA TYPE P0001-BEGDA.

DATA GV_MAXLVL(2) TYPE N VALUE '00'.
*DATA lv_old.  " VALUE 'X'.
DATA : IT_LINE TYPE TABLE OF TLINE WITH HEADER LINE .

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
    PARAMETERS      P_WERKS TYPE MARC-WERKS DEFAULT 'PL01' ."MEMORY ID mat.
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

AT SELECTION-SCREEN OUTPUT.
*LOOP AT SCREEN.
*   IF screen-name = 'P_WERKS'.
*      screen-input = '0'.
*       MODIFY SCREEN.
*       ENDIF.
*        ENDLOOP.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM SET_DATA.
  EXPORT GT_OUTPUT_DWN[] TO MEMORY ID 'ZSOS_PRIMUS_NEW'.

  IF P_NOZERO IS NOT INITIAL.
    DELETE GT_OUTPUT WHERE OMENG = 0.
  ENDIF.

  SORT GT_OUTPUT BY VBELN POSNR LEVEL.

  IF P_DOWN IS INITIAL.
    PERFORM VIV_DATA.
  ELSE.
    PERFORM DOWN_SET TABLES GT_OUTPUT_DWN USING P_FOLDER.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT A~VBELN A~POSNR A~MATNR A~LFSTA
         A~ARKTX A~WERKS A~MEINS A~DELDATE A~RECEIPT_DATE A~LGORT  "LGORT ADDED BY JYOTI ON 11.06.2024
         D~EDATU D~WMENG D~ETENR "C~LFSTA
         F~OMENG
         G~PLIFZ
     INTO CORRESPONDING FIELDS OF TABLE GT_MAIN   ##TOO_MANY_ITAB_FIELDS
     FROM VBAP AS A
*     JOIN VBUP AS C ON C~VBELN = A~VBELN
*                   AND C~POSNR = A~POSNR
     JOIN VBEP AS D ON A~VBELN = D~VBELN
                   AND A~POSNR = D~POSNR
     JOIN VBBE AS F ON A~VBELN = F~VBELN
                   AND A~POSNR = F~POSNR
                   AND D~ETENR = F~ETENR
     JOIN MARC AS G ON A~MATNR = G~MATNR
     WHERE A~VBELN IN S_VBELN
       AND A~WERKS = P_WERKS
       AND A~LFSTA NE 'C'
       AND A~MATNR IN S_MATNR
       AND D~EDATU IN S_EDATU
       AND D~WMENG NE 0
       AND D~ETTYP = 'CP'
       AND G~WERKS = P_WERKS.

*       AND g~werks = p_werks.
*       AND g~werks = p_werks.
  SORT GT_MAIN BY VBELN POSNR MATNR.
  DELETE ADJACENT DUPLICATES FROM GT_MAIN COMPARING ALL FIELDS.



*      AND c~lfgsa  IN s_lfgsa
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_DATA .

  DATA: LS_COMPS TYPE TY_MAIN.
  DATA: LT_VBAK TYPE TABLE OF VBAK,
        LS_VBAK TYPE VBAK.
  DATA: LS_LIST1 TYPE TY_MAIN.

*>
  SELECT * FROM VBAK INTO TABLE LT_VBAK
    FOR ALL ENTRIES IN GT_MAIN
  WHERE VBELN = GT_MAIN-VBELN.

  LOOP AT GT_MAIN INTO LS_COMPS.

    LS_COMPS-IDNRK = LS_COMPS-MATNR.
    LS_COMPS-LGORT = LS_COMPS-LGORT."added by jyoti on 11.06.2024


*    CONCATENATE LS_COMPS-VBELN LS_COMPS-POSNR LS_COMPS-ETENR
*      INTO LS_COMPS-SCHID.
CLEAR:LV_VBELN,lv_POSNR.
LV_VBELN = |{ LS_COMPS-VBELN  ALPHA = OUT }|.
lv_posnr = |{ ls_comps-posnr ALPHA = OUT }|.
  CONCATENATE LV_VBELN '-' lv_POSNR
      INTO LS_COMPS-SCHID.

    CONCATENATE LS_COMPS-VBELN LS_COMPS-POSNR
      INTO LS_COMPS-EXTRA SEPARATED BY '/'.
    READ TABLE LT_VBAK INTO LS_VBAK
      WITH KEY VBELN = LS_COMPS-VBELN.

    LS_COMPS-KUNNR = LS_VBAK-KUNNR.
    SELECT SINGLE NAME1 INTO LS_COMPS-NAME1 FROM KNA1 WHERE KUNNR = LS_COMPS-KUNNR.
    LS_COMPS-VKBUR = LS_VBAK-VKBUR.
    LS_COMPS-BOMLV = '00'.

    PERFORM HDR_CALC USING LS_COMPS.
    LS_COMPS-SHRTQ = LS_COMPS-OMENG - ( LS_COMPS-UNSTK + LS_COMPS-QMSTK ).
    LS_COMPS-INDQT = LS_COMPS-SHRTQ .

*---------Added By Snehal Rajale On 27.01.2021-----------------------*
    CLEAR WA_ZSAL.
    SELECT * FROM ZSALES_SHORTAGE INTO WA_ZSAL
    WHERE VBELN = LS_COMPS-VBELN.
    ENDSELECT.

    IF WA_ZSAL IS NOT INITIAL.
**lv_begda = ls_comps-edatu.
      LV_BEGDA = SY-DATUM + WA_ZSAL-ZDAYS_SO.
      LS_COMPS-EDATU = LV_BEGDA.
    ENDIF.
*---------Ended By Snehal Rajale On 27.01.2021-----------------------*

    LS_COMPS-REQDT = LS_COMPS-EDATU.
    LS_COMPS-ACTDT = LS_COMPS-REQDT - LS_COMPS-PLIFZ.

    APPEND LS_COMPS TO GT_COMPS.
    LS_LIST1-IDNRK = LS_COMPS-MATNR.
    LS_LIST1-BOMLV = '00'.    "identify headers
    COLLECT LS_LIST1 INTO GT_LIST.

    PERFORM GET_COMPS USING LS_COMPS-MATNR LS_COMPS.
  ENDLOOP.

*  PERFORM line_calc.

  PERFORM NET_CALC.

  PERFORM WIP_TOTALS.

  PERFORM GET_MAT_DATA.

  IF P_HDONLY IS NOT INITIAL.
    DELETE GT_COMPS WHERE BOMLV IS NOT INITIAL.
  ENDIF.

  SORT GT_COMPS BY EDATU VBELN MATNR LEVEL POSNR. "Added By Snehal Rajale On 28.01.2021

  PERFORM ALL_CALC.

  PERFORM VEND.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VIV_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM VIV_DATA .

  DATA:
    LT_FCAT  TYPE SLIS_T_FIELDCAT_ALV,
    LS_LAYO  TYPE SLIS_LAYOUT_ALV,
    LV_REPID TYPE SY-REPID,
    LT_SORT  TYPE SLIS_T_SORTINFO_ALV.

*  gt_output[] = gt_comps[].

  IF NOT GT_OUTPUT IS INITIAL.
    PERFORM SET_FCAT CHANGING LT_FCAT.
    PERFORM SET_LAYO CHANGING LS_LAYO.
*    PERFORM set_sort CHANGING lt_sort.

    LV_REPID = SY-REPID.

    PERFORM GT_OUTPUT1.



    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK        = ' '
*       I_BYPASSING_BUFFER       = ' '
*       I_BUFFER_ACTIVE          = ' '
        I_CALLBACK_PROGRAM       = LV_REPID
        I_CALLBACK_PF_STATUS_SET = 'PF_STATUS_SET'
*       i_callback_user_command  = 'USER_COMMAND'
*       i_callback_top_of_page   = 'TOP_OF_PAGE'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME         =
*       I_BACKGROUND_ID          = ' '
*       I_GRID_TITLE             =
*       I_GRID_SETTINGS          =
        IS_LAYOUT                = LS_LAYO
        IT_FIELDCAT              = LT_FCAT
*       IT_EXCLUDING             =
*       IT_SPECIAL_GROUPS        =
        IT_SORT                  = LT_SORT
*       IT_FILTER                =
*       IS_SEL_HIDE              =
*       I_DEFAULT                = 'X'
*       I_SAVE                   = ' '
*       IS_VARIANT               =
*       it_events                = lt_evts
*       IT_EVENT_EXIT            =
*       IS_PRINT                 =
*       IS_REPREP_ID             =
*       I_SCREEN_START_COLUMN    = 0
*       I_SCREEN_START_LINE      = 0
*       I_SCREEN_END_COLUMN      = 0
*       I_SCREEN_END_LINE        = 0
*       I_HTML_HEIGHT_TOP        = 0
*       I_HTML_HEIGHT_END        = 0
*       IT_ALV_GRAPHICS          =
*       IT_HYPERLINK             =
*       IT_ADD_FIELDCAT          =
*       IT_EXCEPT_QINFO          =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER  =
*       ES_EXIT_CAUSED_BY_USER   =
      TABLES
        T_OUTTAB                 = GT_OUTPUT
      EXCEPTIONS
        PROGRAM_ERROR            = 1
        OTHERS                   = 2.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
FORM PF_STATUS_SET   ##CALLED
   USING RT_EXTAB    ##NEEDED
     TYPE SLIS_T_EXTAB.
  SET PF-STATUS 'MAIN'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
FORM SET_FCAT  CHANGING PT_FCAT TYPE SLIS_T_FIELDCAT_ALV.

  DEFINE ADD_FCAT.
    CLEAR ps_fieldcatalog.
    lv_pos = lv_pos + 1.
    ps_fieldcatalog-col_pos    = lv_pos.
    ps_fieldcatalog-tabname    = 'GT_OUTPUT'.
    ps_fieldcatalog-fieldname  = &1. "Field of the structure.
    ps_fieldcatalog-seltext_m  = &2. "Med. Header text for the column.
    ps_fieldcatalog-seltext_l  = &2. "Long. Header text for the column.
    ps_fieldcatalog-key = &3.

    IF &1 = 'KUNNR'.
      ps_fieldcatalog-ref_fieldname = 'KUNNR'.
      ps_fieldcatalog-ref_tabname = 'KNA1'.
    ENDIF.

    IF &1 = 'MATNR'.
      ps_fieldcatalog-ref_fieldname = 'MATNR'.
      ps_fieldcatalog-ref_tabname = 'MARA'.
    ENDIF.

    IF &1 = 'IDNRK'.
      ps_fieldcatalog-ref_fieldname = 'MATNR'.
      ps_fieldcatalog-ref_tabname = 'MARA'.
    ENDIF.
*    IF &1 = 'DIFF'.
*      ps_fieldcatalog-DO_SUM = 'C'.
*    ENDIF.
    APPEND ps_fieldcatalog TO pt_fcat.

  END-OF-DEFINITION.

  DATA: PS_FIELDCATALOG TYPE SLIS_FIELDCAT_ALV,
        LV_POS          TYPE I.

  ADD_FCAT :
         'SCHID'   'Schedule_ID' 'X',   ##NO_TEXT
         'VBELN'   'Sales Doc' '',      ##NO_TEXT
         'POSNR'   'Item' '',           ##NO_TEXT
         'MATNR'   'Header' '',         ##NO_TEXT
         'ARKTX'   'Header Text' '',    ##NO_TEXT
         'IDNRK'   'Component' '',      ##NO_TEXT
         'IDTXT'   'Component Text' '', ##NO_TEXT
*         'ETENR'   'Delivery Schedule Line Number' '',  ##NO_TEXT
         'WERKS'   'Plant' '',          ##NO_TEXT
*         'EDATU'   'Prod. date' '',     ##NO_TEXT
         'EDATUF'   'Prod. date' '',     ##NO_TEXT
*         'LFSTA'   'Delivery status' '',  ##NO_TEXT
*         'DELDATE' 'Delivery Dt' '',       ##NO_TEXT
         'DELDATEF' 'Delivery Dt' '',       ##NO_TEXT
         'KUNNR'   'Cust No' '',           ##NO_TEXT
         'VKBUR'   'Branch' '',            ##NO_TEXT
*         'REQDT'   'Req.Date' '',          ##NO_TEXT
         'REQDTF'   'Req.Date' '',          ##NO_TEXT
         'PLIFZ'   'Lead time' '',         ##NO_TEXT
*         'ACTDT'   'Action Date' '',       ##NO_TEXT
         'ACTDTF'   'Action Date' '',       ##NO_TEXT
*         'WMENG'   'Order Qty' '',         ##NO_TEXT
*         'OMENG'   'Open SO Qty' '',       ##NO_TEXT
*         'WIPQT'   'SO WIP Stock' '',      ##NO_TEXT
*         'WIPOT'   'Other WIP Stock' '',   ##NO_TEXT
*         'WITOT'   'Tot Oth. WIP' '',      ##NO_TEXT
*         'UNST1'   'SO Unrest Stk' '',     ##NO_TEXT
*         'UNSTK'   'Unrest Stk' '',
*         'UNTOT'   'Tot Unrest Stk'        ##NO_TEXT
*                    '',
*         'QMSTK'   'Quality Stk'           ##NO_TEXT
*                    '',
*         'QMTOT'   'Tot Qual Stk'          ##NO_TEXT
*                    '',
*         'SHRTQ'   'Shortage Qty'          ##NO_TEXT
*                    '',
*         'VNSTK'   'Vendor Stock'          ##NO_TEXT
*                    '',
*         'VNTOT'   'Tot Vendor Stk' '',    ##NO_TEXT
*         'ASNQTY'   'ASN Quantity' '',       ##NO_TEXT
*         'ASNTOT'   'Tot. ASN Qty' '',       ##NO_TEXT
*         'POQTY'   'PO Quantity' '',       ##NO_TEXT
*         'POTOT'   'Tot. PO Qty' '',       ##NO_TEXT
*         'INDQT'   'Net Indent' '',        ##NO_TEXT
          'WMENGN'   'Order Qty' '',         ##NO_TEXT
         'OMENGN'   'Open SO Qty' '',       ##NO_TEXT
         'WIPQTN'   'SO WIP Stock' '',      ##NO_TEXT
         'WIPOTN'   'Other WIP Stock' '',   ##NO_TEXT
         'WITOTN'   'Tot Oth. WIP' '',      ##NO_TEXT
         'UNST1N'   'SO Unrest Stk' '',     ##NO_TEXT
         'UNSTKN'   'Unrest Stk' '',
         'UNTOTN'   'Tot Unrest Stk'        ##NO_TEXT
                    '',
         'QMSTKN'   'Quality Stk'           ##NO_TEXT
                    '',
         'QMTOTN'   'Tot Qual Stk'          ##NO_TEXT
                    '',
         'SHRTQN'   'Shortage Qty'          ##NO_TEXT
                    '',
         'VNSTKN'   'Vendor Stock'          ##NO_TEXT
                    '',
         'VNTOTN'   'Tot Vendor Stk' '',    ##NO_TEXT
         'ASNQTYN'   'ASN Quantity' '',       ##NO_TEXT
         'ASNTOTN'   'Tot. ASN Qty' '',       ##NO_TEXT
         'POQTYN'   'PO Quantity' '',       ##NO_TEXT
         'POTOTN'   'Tot. PO Qty' '',       ##NO_TEXT
         'INDQTN'   'Net Indent' '',        ##NO_TEXT

         'MEINS'   'UoM' '',               ##NO_TEXT
*         'VERPR'   'Moving Average Price' '',    ##NO_TEXT
         'VERPRN'   'Moving Average Price' '',    ##NO_TEXT
         'EKGRP'   'Purch Grp' '',         ##NO_TEXT
         'DISPO'   'MRP Contr' '',         ##NO_TEXT
         'BRAND'   'Brand' '',             ##NO_TEXT
         'ZSERIES' 'Series' '',            ##NO_TEXT
         'ZSIZE'   'Size' '',              ##NO_TEXT
         'MOC'     'MOC' '',               ##NO_TEXT
         'TYPE'    'Type' '',              ##NO_TEXT
         'BOMLV'   'BOM Level' '',         ##NO_TEXT
         'MTART'   'Mat type' '',          ##NO_TEXT
         'BISMT'   'Old Mat No.' '',       ##NO_TEXT
         'BESKZ'   'Proc Type' '',         ##NO_TEXT
         'SOBSL'   'Spl proc type' '',     ##NO_TEXT
         'UPLVL'   'Upper' '',             ##NO_TEXT
         'LEVEL'   'Cur Level' '',         ##NO_TEXT
         'NAME1'   'Customer Name' '',         ##NO_TEXT
*         'STPRS'   'Standard price' '',         ##NO_TEXT
         'STPRSN'   'Standard price' '',         ##NO_TEXT
         'ZEINR'   'Drawing No.' '',         ##NO_TEXT
         'REFDT'   'Refresh Dt.' '',         ##NO_TEXT
*         'REMARKS'   'Remarks' ''.         ##NO_TEXT
         'ANDAT'   'Date record created on' '',        ##NO_TEXT "ADDED BY PRIMUS JYOTI ON 01.12.2023
         'ANNAM'   'User who created record' '',         ##NO_TEXT "ADDED BY PRIMUS JYOTI ON 01.12.2023
         'AEDAT'   'Date of Last Change' '',         ##NO_TEXT "ADDED BY PRIMUS JYOTI ON 01.12.2023
         'AENAM'   'Name of person who changed object' '',  ##NO_TEXT "ADDED BY PRIMUS JYOTI ON 01.12.2023
         'LGORT'   'Storage Location' '',
         'REQ_QTY'   'Required Quantity' ''. "added by jyoti on 0804.2025
*         'RECEIPTDATE'   'Code Receipt Date' ''.  ##NO_TEXT "ADDED BY PRIMUS JYOTI ON 01.12.2023

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYO
*&---------------------------------------------------------------------*
FORM SET_LAYO  CHANGING PS_LAYO TYPE SLIS_LAYOUT_ALV.
  PS_LAYO-ZEBRA  = 'X'.
  PS_LAYO-COLWIDTH_OPTIMIZE  = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_COMPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_COMPS  text
*----------------------------------------------------------------------*
FORM GET_COMPS  USING PV_MATNR TYPE MATNR
                      PS_COMPS TYPE TY_MAIN.

  DATA: LT_STB TYPE TABLE OF STPOX,
        LS_STB TYPE STPOX.
  DATA: LV_EMENG TYPE STKO-BMENG.
  DATA: LS_LIST2 TYPE TY_MAIN.
  DATA: LV_LVITM(2) TYPE N.
*  DATA: lv_level TYPE ty_main-level.
*  DATA: lv_bomlv TYPE ty_main-bomlv.

  DATA: LS_COMPS TYPE TY_MAIN.

  LS_COMPS = PS_COMPS.

*  lv_emeng = ps_comps-indqt.  "ps_comps-omeng.  - removed - even level 1 open so calculated in all_calc
  LV_EMENG = 0.

  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      CAPID                 = 'PP01'
      DATUV                 = SY-DATUM
      EMENG                 = LV_EMENG
*     mehrs                 = 'X'
      MTNRV                 = PV_MATNR
      STPST                 = 0
      SVWVO                 = 'X'
      WERKS                 = P_WERKS
      VRSVO                 = 'X'
    TABLES
      STB                   = LT_STB
    EXCEPTIONS
      ALT_NOT_FOUND         = 1
      CALL_INVALID          = 2
      MATERIAL_NOT_FOUND    = 3
      MISSING_AUTHORIZATION = 4
      NO_BOM_FOUND          = 5
      NO_PLANT_DATA         = 6
      NO_SUITABLE_BOM_FOUND = 7
      CONVERSION_ERROR      = 8
      OTHERS                = 9.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ELSE.

*below values should not be passed to components
    CLEAR:  LS_COMPS-UNSTK, LS_COMPS-QMSTK, LS_COMPS-INDQT, LS_COMPS-SHRTQ, LS_COMPS-UNST1.

*> Requirement date of component = Action date of header
    LS_COMPS-REQDT = PS_COMPS-ACTDT.
    LS_COMPS-UPLVL = PS_COMPS-LEVEL.
    LS_COMPS-BOMLV = PS_COMPS-BOMLV + 1.

    IF GV_MAXLVL < LS_COMPS-BOMLV.
      GV_MAXLVL = LS_COMPS-BOMLV.
    ENDIF.

    CLEAR:  LS_COMPS-ACTDT, LS_COMPS-PLIFZ, LS_COMPS-LEVEL.

    LV_LVITM = '01'.

    LOOP AT LT_STB INTO LS_STB.
      LS_COMPS-IDNRK = LS_STB-IDNRK.
*      ls_comps-bomlv = ls_stb-stufe.
      LS_COMPS-MEINS = LS_STB-MEINS.
      LS_COMPS-MTART = LS_STB-MTART.
      LS_COMPS-OMENG = LS_STB-MNGLG.
      LS_COMPS-REQ_QTY = LS_STB-MNGLG. "added by jyoti on 08.04.2025
      LS_COMPS-PARENT = PV_MATNR.    "added By Pankaj on 09.02.2023
      LS_COMPS-ANDAT = LS_STB-ANDAT. "added By JYOTI on 01.12.2023
      IF  LS_COMPS-ANDAT IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_COMPS-ANDAT
          IMPORTING
            OUTPUT = LS_COMPS-ANDAT.
        CONCATENATE  LS_COMPS-ANDAT+0(2)  LS_COMPS-ANDAT+2(3)  LS_COMPS-ANDAT+5(4)
                    INTO  LS_COMPS-ANDAT SEPARATED BY '-'.
      ELSE.
        LS_COMPS-ANDAT = ''.
      ENDIF.
      LS_COMPS-ANNAM = LS_STB-ANNAM."added By JYOTI on 01.12.2023
      LS_COMPS-AEDAT = LS_STB-AEDAT."added By JYOTI on 01.12.2023
      IF LS_COMPS-AEDAT = '00000000'.
        LS_COMPS-AEDAT = ''.
      ENDIF.
      IF LS_COMPS-AEDAT IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = LS_COMPS-AEDAT
          IMPORTING
            OUTPUT = LS_COMPS-AEDAT.
        CONCATENATE  LS_COMPS-AEDAT+0(2)  LS_COMPS-AEDAT+2(3)  LS_COMPS-AEDAT+5(4)
                    INTO  LS_COMPS-AEDAT SEPARATED BY '-'.
      ELSE.
        LS_COMPS-AEDAT = ''.
      ENDIF.

      LS_COMPS-AENAM = LS_STB-AENAM."added By JYOTI on 01.12.2023
      SELECT SINGLE PLIFZ INTO LS_COMPS-PLIFZ
        FROM MARC
        WHERE MATNR = LS_COMPS-IDNRK
      AND WERKS = P_WERKS.

      LS_COMPS-ACTDT = LS_COMPS-REQDT - LS_COMPS-PLIFZ.

      CONCATENATE LS_COMPS-UPLVL '.' LV_LVITM INTO LS_COMPS-LEVEL.

      """"""""""      Added By KD on 31.05.2017       """"""""
*      IF ls_comps-mtart NE 'FERT'.
*        CLEAR ls_comps-unst1 .
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""
      APPEND LS_COMPS TO GT_COMPS.
      LV_LVITM = LV_LVITM + 1.

      LS_LIST2-IDNRK = LS_STB-IDNRK.
      LS_LIST2-BOMLV = '01'.
      COLLECT LS_LIST2 INTO GT_LIST.

      PERFORM GET_COMPS USING LS_STB-IDNRK LS_COMPS.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NET_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NET_CALC .

  DATA: LT_MDPS TYPE TABLE OF MDPS,
        LS_MDPS TYPE MDPS,
        LT_MDEZ TYPE TABLE OF MDEZ,
        LS_MDEZ TYPE MDEZ.
*  DATA: ls_list TYPE ty_main.
*  DATA: lv_vbeln TYPE vbak-vbeln,
*        lv_aufnr TYPE afko-aufnr.
  DATA: "lt_order TYPE TABLE OF afko,
    LS_ORDER TYPE AFKO,
*    lt_resb  TYPE TABLE OF resb,
    LS_RESB  TYPE RESB.
  DATA  LS_WIP   TYPE TY_MAIN.
  DATA  LS_AFPO  TYPE AFPO.
  DATA  LS_UNS   TYPE TY_MAIN.

  FIELD-SYMBOLS <FS_LIST> TYPE TY_MAIN.
*  FIELD-SYMBOLS <fs_comps> TYPE ty_main.

*>
  SORT GT_COMPS BY IDNRK VBELN POSNR ETENR.
*BREAK-POINT.
  TYPES: BEGIN OF TY_VEND_QTY,
           MATNR TYPE MATNR,
           SLLAB TYPE LABST,
         END OF TY_VEND_QTY.
  DATA IT_VEND_TOT_UQTY TYPE TABLE OF TY_VEND_QTY.
  SELECT  * "matnr,
             "SLLAB
     FROM MSSL
     INTO TABLE @DATA(IT_VEND_QTY)
     FOR ALL ENTRIES IN @GT_LIST
     WHERE MATNR = @GT_LIST-IDNRK.
  SORT IT_VEND_QTY BY MATNR.

  LOOP AT GT_LIST ASSIGNING <FS_LIST>.
    CHECK <FS_LIST>-BOMLV NE '0'.
    REFRESH: LT_MDPS, LT_MDEZ.
    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        MATNR                    = <FS_LIST>-IDNRK
        WERKS                    = P_WERKS
        BERID                    = 'PL01'
      IMPORTING
        E_MT61D                  = E_MT61D
        E_MDKP                   = E_MDKP
        E_CM61M                  = E_CM61M
        E_MDSTA                  = E_MDSTA
        E_ERGBZ                  = E_ERGBZ
      TABLES
        MDPSX                    = LT_MDPS
        MDEZX                    = LT_MDEZ
        MDSUX                    = MDSUX
      EXCEPTIONS
        MATERIAL_PLANT_NOT_FOUND = 1
        PLANT_NOT_FOUND          = 2
        OTHERS                   = 3.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here

    ELSE.

      LOOP AT LT_MDEZ INTO LS_MDEZ WHERE DELKZ = 'WB'.
        <FS_LIST>-UNSTK = <FS_LIST>-UNSTK + LS_MDEZ-MNG01.
      ENDLOOP.

      SELECT SINGLE
             SUM( SLLAB ) AS VENDOR_QTY
             FROM @IT_VEND_QTY AS A
             WHERE MATNR = @<FS_LIST>-IDNRK
             INTO  @DATA(WA_VENDOR_QUAN) .
      IF SY-SUBRC = 0.
        <FS_LIST>-UNSTK = <FS_LIST>-UNSTK - WA_VENDOR_QUAN.
        CLEAR:WA_VENDOR_QUAN.
      ENDIF.
*      LOOP AT lt_mdez INTO ls_mdez WHERE delkz = 'KB'.
**        <fs_list>-unstk = <fs_list>-unstk + ls_mdez-mng01.
*
*
*      ENDLOOP.

      LOOP AT LT_MDPS INTO LS_MDPS.
        CASE LS_MDPS-DELKZ.
          WHEN 'LA'.
            DATA: LV_EBELN1 TYPE EKKO-EBELN.
            CLEAR: LV_EBELN1. "lv_ebelp, ls_ekpo.
            LV_EBELN1 = LS_MDPS-DELNR.    "extra+0(10).
            SELECT SINGLE EBELN FROM EKKO INTO LV_EBELN1
            WHERE EBELN = LV_EBELN1 AND FRGKE = '2'.
            IF  SY-SUBRC = 0.
*              IF ls_mdps-sobes = '0' .
              <FS_LIST>-ASNQTY = <FS_LIST>-ASNQTY + LS_MDPS-MNG01.
*              ELSE.
*                <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
*              ENDIF.
            ENDIF.

          WHEN 'BE'.
            DATA: LV_EBELN TYPE EKKO-EBELN.
            CLEAR: LV_EBELN. "lv_ebelp, ls_ekpo.
            LV_EBELN = LS_MDPS-DELNR.    "extra+0(10).
            SELECT SINGLE EBELN FROM EKKO INTO LV_EBELN
            WHERE EBELN = LV_EBELN AND FRGKE = '2'.
            IF  SY-SUBRC = 0.
              IF LS_MDPS-SOBES = '0' .
                <FS_LIST>-POQTY = <FS_LIST>-POQTY + LS_MDPS-MNG01.
              ELSE.
                <FS_LIST>-VNSTK = <FS_LIST>-VNSTK + LS_MDPS-MNG01.
              ENDIF.
            ENDIF.
          WHEN 'QM'.
            <FS_LIST>-QMSTK = <FS_LIST>-QMSTK + LS_MDPS-MNG01.

          WHEN 'KB'.
            CLEAR LS_UNS.
            LS_UNS-VBELN = LS_MDPS-KDAUF.   "ps_comps-vbeln.
            LS_UNS-POSNR = LS_MDPS-KDPOS.   "ps_comps-posnr.
            LS_UNS-MATNR = <FS_LIST>-IDNRK. "ps_comps-matnr.
            LS_UNS-IDNRK = <FS_LIST>-IDNRK.
            LS_UNS-UNST1 = LS_MDPS-MNG01.
            APPEND LS_UNS TO GT_UNS1.

          WHEN 'FE'.

            CLEAR LS_ORDER.
            IF LS_MDPS-KDAUF IS INITIAL.
              LS_ORDER-AUFNR = LS_MDPS-DEL12.
              CLEAR: LS_RESB, LS_AFPO.

              SELECT * FROM AFPO INTO LS_AFPO
                WHERE AUFNR = LS_ORDER-AUFNR.
                SELECT * FROM RESB INTO LS_RESB
                  WHERE AUFNR = LS_ORDER-AUFNR
*                    AND matnr = <fs_list>-idnrk
                    AND XLOEK <> 'X'              "
                    AND ENMNG > 0
                    AND SHKZG = 'H'.
                  CLEAR LS_WIP.
                  LS_WIP-IDNRK = LS_RESB-MATNR.
                  LS_WIP-WITOT =
                     ( LS_RESB-ENMNG - ( LS_AFPO-WEMNG * ( LS_RESB-BDMNG  / LS_AFPO-PSMNG ) ) ).
                  COLLECT LS_WIP INTO GT_WIP2.
                ENDSELECT.
              ENDSELECT.
            ELSE.   "ls_mdps-kdauf IS NOT INITIAL
*           BOM component is a FERT and has its own sales order associated Prod order.
              LS_ORDER-AUFNR = LS_MDPS-DEL12.
              CLEAR: LS_RESB, LS_AFPO.

              SELECT * FROM AFPO INTO LS_AFPO
                WHERE AUFNR = LS_ORDER-AUFNR.

                SELECT * FROM RESB INTO LS_RESB
                  WHERE AUFNR = LS_ORDER-AUFNR
*                    AND matnr = <fs_list>-idnrk
                    AND XLOEK <> 'X'              "
                    AND ENMNG > 0
                    AND SHKZG = 'H'.
                  CLEAR LS_WIP.
                  READ TABLE GT_WIP1 INTO DATA(WA_GT_WIP1) WITH  KEY VBELN = LS_MDPS-KDAUF
                                                                     POSNR = LS_MDPS-KDPOS
                                                                     MATNR = <FS_LIST>-IDNRK
                                                                     IDNRK = LS_RESB-MATNR.
                  IF SY-SUBRC <> 0.

                    LS_WIP-VBELN = LS_MDPS-KDAUF.   "ps_comps-vbeln.
                    LS_WIP-POSNR = LS_MDPS-KDPOS.   "ps_comps-posnr.
                    LS_WIP-MATNR = <FS_LIST>-IDNRK. "ps_comps-matnr.
                    LS_WIP-IDNRK = LS_RESB-MATNR.
                    LS_WIP-WIPQT =
                       ( LS_RESB-ENMNG - ( LS_AFPO-WEMNG * ( LS_RESB-BDMNG  / LS_AFPO-PSMNG ) ) ).
                    APPEND LS_WIP TO GT_WIP1.
                  ELSE.
                    READ TABLE GT_WIP1 ASSIGNING FIELD-SYMBOL(<FS_WIP>) WITH  KEY VBELN = LS_MDPS-KDAUF
                                                                                  POSNR = LS_MDPS-KDPOS
                                                                                  MATNR = <FS_LIST>-IDNRK
                                                                                  IDNRK = LS_RESB-MATNR.
                    <FS_WIP>-WIPQT = <FS_WIP>-WIPQT + ( LS_RESB-ENMNG - ( LS_AFPO-WEMNG * ( LS_RESB-BDMNG  / LS_AFPO-PSMNG ) ) ).

                  ENDIF.
                ENDSELECT.
              ENDSELECT.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      SELECT SUM( LABST ) FROM MARD INTO <FS_LIST>-LABST
        WHERE MATNR = <FS_LIST>-IDNRK
      AND WERKS = P_WERKS.

    ENDIF.
  ENDLOOP.


  LOOP AT GT_LIST ASSIGNING <FS_LIST>.
    IF <FS_LIST>-BOMLV EQ '0' AND <FS_LIST>-VNSTK IS  INITIAL.
*      CHECK <fs_list>-bomlv EQ '0'.
      REFRESH: LT_MDPS, LT_MDEZ.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          MATNR                    = <FS_LIST>-IDNRK
          WERKS                    = P_WERKS
        IMPORTING
          E_MT61D                  = E_MT61D
          E_MDKP                   = E_MDKP
          E_CM61M                  = E_CM61M
          E_MDSTA                  = E_MDSTA
          E_ERGBZ                  = E_ERGBZ
        TABLES
          MDPSX                    = LT_MDPS
          MDEZX                    = LT_MDEZ
          MDSUX                    = MDSUX
        EXCEPTIONS
          MATERIAL_PLANT_NOT_FOUND = 1
          PLANT_NOT_FOUND          = 2
          OTHERS                   = 3.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here

      ELSE.


        LOOP AT LT_MDPS INTO LS_MDPS.
          CASE LS_MDPS-DELKZ.
            WHEN 'LA'.
              CLEAR: LV_EBELN1. "lv_ebelp, ls_ekpo.
              LV_EBELN1 = LS_MDPS-DELNR.    "extra+0(10).
              SELECT SINGLE EBELN FROM EKKO INTO LV_EBELN1
              WHERE EBELN = LV_EBELN1 AND FRGKE = '2'.
              IF  SY-SUBRC = 0.
*                IF ls_mdps-sobes = '0' .
                <FS_LIST>-ASNQTY = <FS_LIST>-ASNQTY + LS_MDPS-MNG01.
*                ELSE.
*                  <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
*                ENDIF.
              ENDIF.

            WHEN 'BE'.
              CLEAR: LV_EBELN. "lv_ebelp, ls_ekpo.
              LV_EBELN = LS_MDPS-DELNR.    "extra+0(10).
              SELECT SINGLE EBELN FROM EKKO INTO LV_EBELN
              WHERE EBELN = LV_EBELN AND FRGKE = '2'.
              IF  SY-SUBRC = 0.
                IF LS_MDPS-SOBES = '0' .
                  <FS_LIST>-POQTY = <FS_LIST>-POQTY + LS_MDPS-MNG01.
                ELSE.
                  <FS_LIST>-VNSTK = <FS_LIST>-VNSTK + LS_MDPS-MNG01.
                ENDIF.
              ENDIF.
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MAT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_MAT_DATA .

  DATA: LT_MARA TYPE TABLE OF MARA,
        LS_MARA TYPE MARA,
        LT_MARC TYPE TABLE OF MARC,
        LS_MARC TYPE MARC,
*        lt_makt TYPE TABLE OF makt,
*        ls_makt TYPE makt,
        LT_MBEW TYPE TABLE OF MBEW,
        LS_MBEW TYPE MBEW.
  DATA LS_LIST TYPE TY_MAIN.
  DATA LS_WIP1 TYPE TY_MAIN.
*  DATA ls_wip2 TYPE ty_main.
  DATA LS_UNS1 TYPE TY_MAIN.

  FIELD-SYMBOLS <FS_COMPS> TYPE TY_MAIN.

  SELECT * FROM MARA INTO TABLE LT_MARA
    FOR ALL ENTRIES IN GT_COMPS
  WHERE MATNR = GT_COMPS-IDNRK.

  SELECT * FROM MARC INTO TABLE LT_MARC
    FOR ALL ENTRIES IN GT_COMPS
    WHERE MATNR = GT_COMPS-IDNRK
  AND WERKS = P_WERKS.

*  SELECT * FROM makt INTO TABLE lt_makt
*    FOR ALL ENTRIES IN gt_comps
*    WHERE matnr = gt_comps-idnrk
*      AND spras = sy-langu.

  SELECT * FROM MBEW INTO TABLE LT_MBEW
    FOR ALL ENTRIES IN GT_COMPS
    WHERE MATNR = GT_COMPS-IDNRK
  AND BWKEY = P_WERKS.

  LOOP AT GT_COMPS ASSIGNING <FS_COMPS>.
    CLEAR: LS_MARA, LS_MARC, LS_MBEW.   " ls_makt,
    READ TABLE LT_MARA INTO LS_MARA WITH KEY MATNR = <FS_COMPS>-IDNRK.
    READ TABLE LT_MARC INTO LS_MARC WITH KEY MATNR = <FS_COMPS>-IDNRK.
*    READ TABLE lt_makt INTO ls_makt WITH KEY matnr = <fs_comps>-idnrk.
    READ TABLE LT_MBEW INTO LS_MBEW WITH KEY MATNR = <FS_COMPS>-IDNRK.

    """""""       Added By KD on 01.06.2017     """"""""
    PERFORM GET_TEXT_MAT USING  <FS_COMPS>-IDNRK CHANGING <FS_COMPS>-IDTXT.
    PERFORM GET_TEXT_MAT USING  <FS_COMPS>-MATNR CHANGING <FS_COMPS>-ARKTX.
    """"""""""""""""""""""""""""""""""""""""""""""""""""
*    <fs_comps>-idtxt = ls_makt-maktx.
    <FS_COMPS>-BRAND = LS_MARA-BRAND.
    <FS_COMPS>-ZSERIES = LS_MARA-ZSERIES.
    <FS_COMPS>-ZSIZE = LS_MARA-ZSIZE.
    <FS_COMPS>-MOC   = LS_MARA-MOC.
    <FS_COMPS>-TYPE  = LS_MARA-TYPE.
    <FS_COMPS>-MTART = LS_MARA-MTART.
    <FS_COMPS>-BISMT = LS_MARA-BISMT.
    <FS_COMPS>-ZEINR = LS_MARA-ZEINR.
*    <fs_comps>-plifz = ls_marc-plifz.
    <FS_COMPS>-EKGRP = LS_MARC-EKGRP.
    <FS_COMPS>-DISPO = LS_MARC-DISPO.
    <FS_COMPS>-BESKZ = LS_MARC-BESKZ.
    <FS_COMPS>-SOBSL = LS_MARC-SOBSL.
    <FS_COMPS>-VERPR = LS_MBEW-VERPR.        "Moving Average Price
    <FS_COMPS>-STPRS = LS_MBEW-STPRS.        "Standard price

    CLEAR LS_LIST.
    READ TABLE GT_LIST INTO LS_LIST WITH KEY IDNRK = <FS_COMPS>-IDNRK.
    <FS_COMPS>-QMTOT = LS_LIST-QMSTK.
    <FS_COMPS>-VNTOT = LS_LIST-VNSTK.
    <FS_COMPS>-ASNTOT = LS_LIST-ASNQTY.
    <FS_COMPS>-POTOT = LS_LIST-POQTY.
    <FS_COMPS>-UNTOT = LS_LIST-UNSTK.
    <FS_COMPS>-WITOT = LS_LIST-WITOT.

*Get SO related WIP stock
    "Jayant@Fujitsu Comment begins - Dt21.03.18
***    CLEAR ls_wip1.
***    READ TABLE gt_wip1 INTO ls_wip1 WITH KEY vbeln = <fs_comps>-vbeln
***                       posnr = <fs_comps>-posnr matnr = <fs_comps>-matnr
***                       idnrk = <fs_comps>-idnrk.
***    IF sy-subrc = 0.
***      <fs_comps>-wipqt = ls_wip1-wipqt.
***    ELSE.
***      READ TABLE gt_wip1 INTO ls_wip1 WITH KEY vbeln = <fs_comps>-vbeln
***                   posnr = <fs_comps>-posnr "matnr = <fs_comps>-matnr
***                   idnrk = <fs_comps>-idnrk.
***      <fs_comps>-wipqt = ls_wip1-wipqt.
***    ENDIF.
    "Jayant@Fujitsu Comment ends   - Dt21.03.18
    "Jayant@Fujitsu Insert begins - Dt21.03.18
    LOOP AT GT_WIP1 INTO LS_WIP1
      WHERE VBELN = <FS_COMPS>-VBELN
        AND POSNR = <FS_COMPS>-POSNR "matnr = <fs_comps>-matnr
        AND IDNRK = <FS_COMPS>-IDNRK..
      <FS_COMPS>-WIPQT = <FS_COMPS>-WIPQT + LS_WIP1-WIPQT.
    ENDLOOP.
    "Jayant@Fujitsu Insert ends   - Dt21.03.18
*Get non-header SO Unrestricted stock
    CLEAR LS_UNS1.
    READ TABLE GT_UNS1 INTO LS_UNS1 WITH KEY VBELN = <FS_COMPS>-VBELN
                       POSNR = <FS_COMPS>-POSNR "matnr = <fs_comps>-matnr
                       IDNRK = <FS_COMPS>-IDNRK.
    IF SY-SUBRC = 0.
      <FS_COMPS>-UNST1 = LS_UNS1-UNST1.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HDR_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_COMPS  text
*----------------------------------------------------------------------*
FORM HDR_CALC  USING    PS_COMPS TYPE TY_MAIN.

  DATA: LT_MDPS TYPE TABLE OF MDPS,
        LS_MDPS TYPE MDPS,
        LT_MDEZ TYPE TABLE OF MDEZ,
        LS_MDEZ TYPE MDEZ.
  DATA: LV_VBELN TYPE VBAK-VBELN.
  DATA: LT_ORDER TYPE TABLE OF AFKO,
        LS_ORDER TYPE AFKO,
*        lt_resb  TYPE TABLE OF resb,
        LS_RESB  TYPE RESB.
  DATA  LS_WIP   TYPE TY_MAIN.
  DATA  LS_AFPO  TYPE AFPO.

  REFRESH: LT_MDPS, LT_MDEZ.
  CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
    EXPORTING
      MATNR                    = PS_COMPS-IDNRK
      WERKS                    = P_WERKS
      BERID                    = 'PL01'
*     IMPORTING
*     E_MT61D                  =
*     E_MDKP                   =
*     E_CM61M                  =
*     E_MDSTA                  =
*     E_ERGBZ                  =
    TABLES
      MDPSX                    = LT_MDPS
      MDEZX                    = LT_MDEZ
*     MDSUX                    =
    EXCEPTIONS
      MATERIAL_PLANT_NOT_FOUND = 1
      PLANT_NOT_FOUND          = 2
      OTHERS                   = 3.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ELSE.

    "SO - Unristricted stock
    CLEAR LS_MDEZ.
    READ TABLE LT_MDEZ INTO LS_MDEZ WITH KEY EXTRA = PS_COMPS-EXTRA DELKZ = 'KB'.
    IF SY-SUBRC = 0.
      PS_COMPS-UNST1 = LS_MDEZ-MNG01.
    ENDIF.

    REFRESH LT_ORDER.
    LOOP AT LT_MDPS INTO LS_MDPS WHERE DELKZ = 'QM' OR DELKZ = 'FE'.

      IF LS_MDPS-KDAUF IS NOT INITIAL.
        CLEAR LV_VBELN.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = LS_MDPS-KDAUF
          IMPORTING
            OUTPUT = LV_VBELN.
        IF PS_COMPS-VBELN = LV_VBELN AND PS_COMPS-POSNR = LS_MDPS-KDPOS.
          CASE LS_MDPS-DELKZ.
            WHEN 'QM'.
              PS_COMPS-QMSTK = PS_COMPS-QMSTK + LS_MDPS-MNG01.

            WHEN 'FE'.
              LS_ORDER-AUFNR = LS_MDPS-DEL12.
              APPEND LS_ORDER TO LT_ORDER.
*        WHEN OTHERS.
          ENDCASE.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT LT_ORDER INTO LS_ORDER.

      CLEAR: LS_AFPO, LS_RESB.
      SELECT SINGLE * FROM AFPO     ##WARN_OK
        INTO LS_AFPO
      WHERE AUFNR = LS_ORDER-AUFNR.

      SELECT * FROM RESB INTO LS_RESB
        WHERE AUFNR = LS_ORDER-AUFNR
*              AND matnr = wa_idnrk-idnrk
          AND XLOEK <> 'X'
          AND ENMNG > 0
          AND SHKZG = 'H'.
        CLEAR LS_WIP.
        LS_WIP-VBELN = PS_COMPS-VBELN.
        LS_WIP-POSNR = PS_COMPS-POSNR.
        LS_WIP-MATNR = PS_COMPS-MATNR.
        LS_WIP-IDNRK = LS_RESB-MATNR.
        LS_WIP-WIPQT = LS_RESB-ENMNG - ( LS_AFPO-WEMNG * ( LS_RESB-BDMNG  / LS_AFPO-PSMNG ) ) .
*              wa_resb-wipqty = wa_resb-enmng - ( wa_afpo-wemng * ( wa_resb-bdmng
*                                 / wa_afpo-psmng ) ).
        APPEND LS_WIP TO GT_WIP1.
      ENDSELECT.
    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET TABLES GT_OUTPUT_DWN USING P_FOLDER .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING.
*        lv_dat(10),
*        lv_tim(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
*     I_TAB_SAP_DATA       = GT_OUTPUT
      I_TAB_SAP_DATA       = GT_OUTPUT_DWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM CSV_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'SOSTEST.TXT'.
*  lv_file = 'SOS_DATE_CHNG.TXT'.
  LV_FILE = 'ZSOS_PRIMUS_NEW1.TXT'.   "Added By Nilay B. On 17.06.2023

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.
*   CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.

  WRITE: / 'NEW SOS for India Download started on'      ##NO_TEXT
           , SY-DATUM, 'at', SY-UZEIT.
  WRITE: / 'Plant'                   ##NO_TEXT
           , P_WERKS.
  WRITE: / 'Sales Order No. From', S_VBELN-LOW, 'To', S_VBELN-HIGH.
  WRITE: / 'Material code   From', S_MATNR-LOW, 'To', S_MATNR-HIGH.
  WRITE: / 'SO Date         From', S_EDATU-LOW, 'To', S_EDATU-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1266 TYPE STRING.
    DATA LV_CRLF_1266 TYPE STRING.
    LV_CRLF_1266 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1266 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1266 LV_CRLF_1266 WA_CSV INTO LV_STRING_1266.
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_1266 TO LV_FULLFILE.
*    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded'   ##NO_TEXT
      INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CSV_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CSV_HEADER  USING    PD_CSV TYPE ANY.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

  CONCATENATE
 'Component'
 'Sales Doc'
 'Item'
 'Sch Line No'
 'Component Text'
 'Header'
 'Header text'
 'Plant'
 'Delv .Stat'
 'Prod. Date'
 'Delv .Date'
 'Action Date'
 'Req.Date'
 'Schedule ID'
 'Customer'
 'Branch'
 'UoM'
 'Order Qty'
 'Open SO Qty'
 'SO WIP Qty'
 'Other WIP Stock'
 'Tot Oth. WIP'
 'SO Unrestr.Stk'
 'Other Unrestr.Stk'
 'Unrestr.Tot'
 'QM Qty'
 'QM Total'
 'Shortage Qty'
 'Vendor Stock'
 'Ven Stk Tot'
 'ASN Qty'
 'ASN Total Qty'
 'PO Qty'
 'PO Total Qty'
 'Net Indent'
 'Mov, Avg Price'
 'Leade Time'
 'Purch grp'
 'MRP Controller'
 'Brand'
 'Series'      ##NO_TEXT
 'Size'        ##NO_TEXT
 'MOC'         ##NO_TEXT
 'Type'        ##NO_TEXT
 'BOM Level'      ##NO_TEXT
 'Mat Type'       ##NO_TEXT
 'Old Mat No'     ##NO_TEXT
 'Proc. Type'     ##NO_TEXT
 'Spl. Proc'      ##NO_TEXT
 'MRP Element Data'      ##NO_TEXT
 'Valuated Unrestricted-Use Stock'      ##NO_TEXT
 'DO not use'      ##NO_TEXT
 'DO_not_use'      ##NO_TEXT
 'Customer Name'
 'Standard price'
 'Drawing No.'
 'Refresh Dt.'
* 'Remarks'
  'Date record created on'
 'User who created record'
 'Date of Last Change'
 'Name of person who changed object'
 'Storage Location'   "added by jyoti on 11.06.2024
 'Required Quantity'  "added byjyoti on 08.04.2025
 "'Code Receipt Date'                        Commented by Nilay B. on 16.01.2024

   INTO PD_CSV
   SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  WIP_TOTALS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM WIP_TOTALS .
  FIELD-SYMBOLS <FS_LIST> TYPE TY_MAIN.
*  DATA ls_list TYPE ty_main.
  DATA LS_WIP2 TYPE TY_MAIN.

  LOOP AT GT_LIST ASSIGNING <FS_LIST>. " WITH KEY idnrk = <fs_comps>-idnrk..
    CHECK <FS_LIST>-BOMLV > '00'.

    CLEAR LS_WIP2.
    READ TABLE GT_WIP2 INTO LS_WIP2 WITH KEY IDNRK = <FS_LIST>-IDNRK.
    <FS_LIST>-WITOT = LS_WIP2-WITOT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALL_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALL_CALC .
  FIELD-SYMBOLS <FS_COMPS> TYPE TY_MAIN.
  FIELD-SYMBOLS <FS_LIST>  TYPE TY_MAIN.

*  DATA: last_comp TYPE ty_main.
  DATA: LS_OUT1   TYPE TY_MAIN.
  DATA: LS_OUT2   TYPE TY_MAIN.
*    IF <fs_comps>-idnrk NE last_comp-idnrk.
*      CLEAR ls_list.
*      READ TABLE gt_list INTO ls_list WITH KEY idnrk = <fs_comps>-idnrk.
*    ENDIF.

  LOOP AT GT_COMPS ASSIGNING <FS_COMPS>.

    READ TABLE GT_LIST ASSIGNING <FS_LIST>
      WITH KEY IDNRK = <FS_COMPS>-IDNRK.
    <FS_COMPS>-VERPRN = <FS_COMPS>-VERPR.
    <FS_COMPS>-STPRSN = <FS_COMPS>-STPRS.
**>>Header Level
    SELECT SINGLE *
                FROM MARC
                INTO @DATA(wa_MARC)
                WHERE MATNR = @<FS_COMPS>-PARENT
                  and werks = @<FS_COMPS>-WERKS.

    IF <FS_COMPS>-BOMLV IS INITIAL AND 1 = 2.   "Header material/Material in Sales order
*Header - Calc Shortage quantity
      "Initial
      IF WA_MARC-BESKZ = 'F' AND WA_MARC-SOBSL = ''.
      ELSE.
        <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).
      ENDIF.

      IF <FS_COMPS>-SHRTQ LE 0.
        <FS_COMPS>-SHRTQ = 0.
      ELSE.


* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity

*First Unrestricted stock  ---  This piece of code may not be relevent for Header

          SELECT SUM( KALAB )
                         FROM MSKA
                         WHERE MATNR = @<FS_COMPS>-IDNRK
                           AND VBELN = @<FS_COMPS>-VBELN
                           AND POSNR = @<FS_COMPS>-POSNR INTO @DATA(KALAB).

        IF <FS_LIST>-UNSTK > 0.

         IF <FS_COMPS>-MTART = 'FERT'.
           <FS_COMPS>-UNSTK = KALAB.
         ELSE.

          IF <FS_LIST>-UNSTK GE <FS_COMPS>-SHRTQ.  "If tot unrst > comp shrt then, pass reqd unst to comp            .
            <FS_LIST>-UNSTK = <FS_LIST>-UNSTK - <FS_COMPS>-UNSTK.    "and subtract same from total
          ELSE.
            <FS_COMPS>-UNSTK = <FS_LIST>-UNSTK.    "Else assign whatever to comp-unrst
            CLEAR <FS_LIST>-UNSTK.
          ENDIF.
         ENDIF.
        ENDIF.
        "After assignment of Unrestricted stock
        IF WA_MARC-BESKZ = 'F' AND WA_MARC-SOBSL = ''.
        ELSE.
          <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).
        ENDIF.
*SO WIP qauntity calulation NOT required for Header

*Second QM Stock
        IF <FS_LIST>-QMSTK > 0.
          SELECT SUM( KAINS )
                         FROM MSKA

                         WHERE MATNR = @<FS_COMPS>-IDNRK
                           AND VBELN = @<FS_COMPS>-VBELN
                           AND POSNR = @<FS_COMPS>-POSNR INTO @DATA(KAINS1).
          <FS_COMPS>-QMSTK =  KAINS1.
          IF KAINS1 IS INITIAL.
            IF <FS_LIST>-QMSTK GE <FS_COMPS>-SHRTQ.
              <FS_COMPS>-QMSTK = <FS_COMPS>-SHRTQ.
              <FS_LIST>-QMSTK = <FS_LIST>-QMSTK - <FS_COMPS>-QMSTK.
            ELSE.
              <FS_COMPS>-QMSTK = <FS_LIST>-QMSTK.
              CLEAR <FS_LIST>-QMSTK.
            ENDIF.
          ENDIF.
*          IF <FS_LIST>-QMSTK GE <FS_COMPS>-SHRTQ.
*            <FS_COMPS>-QMSTK = <FS_COMPS>-SHRTQ.
*            <FS_LIST>-QMSTK = <FS_LIST>-QMSTK - <FS_COMPS>-QMSTK.
*          ELSE.
*            <FS_COMPS>-QMSTK = <FS_LIST>-QMSTK.
*            CLEAR <FS_LIST>-QMSTK.
*          ENDIF.
        ENDIF.
        "After assignment of Quality stock
        IF WA_MARC-BESKZ = 'F' AND WA_MARC-SOBSL = ''.
        ELSE.
          <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).
        ENDIF.
      ENDIF.
*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

      "Calculate Net Indent
      "Initial
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

      "First Vendor Stock
      IF  <FS_LIST>-VNSTK > 0.
        IF <FS_LIST>-VNSTK GE <FS_COMPS>-INDQT.
          <FS_COMPS>-VNSTK = <FS_COMPS>-INDQT.
          <FS_LIST>-VNSTK = <FS_LIST>-VNSTK - <FS_COMPS>-VNSTK.
        ELSE.
          <FS_COMPS>-VNSTK = <FS_LIST>-VNSTK.
          CLEAR <FS_LIST>-VNSTK.
        ENDIF.
      ENDIF.
      "After assignment of Vendor stock
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

      "Second ASN Quanity
      IF <FS_LIST>-ASNQTY > 0.
        IF <FS_LIST>-ASNQTY GE <FS_COMPS>-INDQT.
          <FS_COMPS>-ASNQTY = <FS_COMPS>-INDQT.
          <FS_LIST>-ASNQTY = <FS_LIST>-ASNQTY - <FS_COMPS>-ASNQTY.
        ELSE.
          <FS_COMPS>-ASNQTY = <FS_LIST>-ASNQTY.
          CLEAR <FS_LIST>-ASNQTY.
        ENDIF.
      ENDIF.
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).
      "Second PO Quanity
      IF <FS_LIST>-POQTY > 0.
        IF <FS_LIST>-POQTY GE <FS_COMPS>-INDQT.
          <FS_COMPS>-POQTY = <FS_COMPS>-INDQT.
          <FS_LIST>-POQTY = <FS_LIST>-POQTY - <FS_COMPS>-POQTY.
        ELSE.
          <FS_COMPS>-POQTY = <FS_LIST>-POQTY.
          CLEAR <FS_LIST>-POQTY.
        ENDIF.
      ENDIF.

      "Final indent quantity
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

    ENDIF.  "Header material/Material in Sales order

**>>BOM Level = 1
    IF <FS_COMPS>-BOMLV = 1 AND 1 = 2.
      "Make OPen SO quantiy to zero if the header Indent Qty is zero
      "Get net indent qunatity of the 'Header level'
      CLEAR LS_OUT1.
      READ TABLE GT_COMPS
       INTO LS_OUT1
       WITH KEY VBELN = <FS_COMPS>-VBELN
                POSNR = <FS_COMPS>-POSNR
                LEVEL = <FS_COMPS>-UPLVL.
      IF SY-SUBRC = 0.
        IF LS_OUT1-INDQT = 0.
          <FS_COMPS>-OMENG = 0.
          """"  Added  by KD on 31.05.2017     """""""
        ELSE.
**          <fs_comps>-omeng = ls_out1-indqt.   "Incorrect - this code overwriting correct values
          """""""      End 31.05.2017          """"""

          <FS_COMPS>-OMENG = <FS_COMPS>-OMENG * LS_OUT1-INDQT.
        ENDIF.
      ENDIF.

*Level 1 - Calc Shortage quantity
      "Initial
      <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).

      IF <FS_COMPS>-SHRTQ LE 0.
        <FS_COMPS>-SHRTQ = 0.
      ELSE.

* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity

*Unrestricted stock
        IF <FS_LIST>-UNSTK > 0.
                   IF <FS_COMPS>-MTART = 'FERT'.
           <FS_COMPS>-UNSTK = KALAB.
         ELSE.


          IF <FS_LIST>-UNSTK GE <FS_COMPS>-SHRTQ.
            <FS_COMPS>-UNSTK = <FS_COMPS>-SHRTQ.
            <FS_LIST>-UNSTK = <FS_LIST>-UNSTK - <FS_COMPS>-UNSTK.
          ELSE.
            <FS_COMPS>-UNSTK = <FS_LIST>-UNSTK.
            CLEAR <FS_LIST>-UNSTK.
          ENDIF.
        ENDIF.
       ENDIF.
        <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).

*SO related WIP quantity already assigned in WIPQTY

*NO SO WIP qauntity considered for Header and BOM level 1

*QM Stock
        IF <FS_LIST>-QMSTK > 0.
          SELECT SUM( KAINS )
                         FROM MSKA

                         WHERE MATNR = @<FS_COMPS>-IDNRK
                           AND VBELN = @<FS_COMPS>-VBELN
                           AND POSNR = @<FS_COMPS>-POSNR INTO @DATA(KAINS).
          <FS_COMPS>-QMSTK =  KAINS.
          IF KAINS IS INITIAL.
            IF <FS_LIST>-QMSTK GE <FS_COMPS>-SHRTQ.
              <FS_COMPS>-QMSTK = <FS_COMPS>-SHRTQ.
              <FS_LIST>-QMSTK = <FS_LIST>-QMSTK - <FS_COMPS>-QMSTK.
            ELSE.
              <FS_COMPS>-QMSTK = <FS_LIST>-QMSTK.
              CLEAR <FS_LIST>-QMSTK.
            ENDIF.
          ENDIF.
*          IF <FS_LIST>-QMSTK GE <FS_COMPS>-SHRTQ.
*            <FS_COMPS>-QMSTK = <FS_COMPS>-SHRTQ.
*            <FS_LIST>-QMSTK = <FS_LIST>-QMSTK - <FS_COMPS>-QMSTK.
*          ELSE.
*            <FS_COMPS>-QMSTK = <FS_LIST>-QMSTK.
*            CLEAR <FS_LIST>-QMSTK.
*          ENDIF.
*
        ENDIF.
        <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).

      ENDIF.
*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).
      IF  <FS_LIST>-VNSTK > 0.
        IF <FS_LIST>-VNSTK GE <FS_COMPS>-INDQT.
          <FS_COMPS>-VNSTK = <FS_COMPS>-INDQT.
          <FS_LIST>-VNSTK = <FS_LIST>-VNSTK - <FS_COMPS>-VNSTK.
        ELSE.
          <FS_COMPS>-VNSTK = <FS_LIST>-VNSTK.
          CLEAR <FS_LIST>-VNSTK.
        ENDIF.

      ENDIF.

      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

      IF <FS_LIST>-ASNQTY > 0.
        IF <FS_LIST>-ASNQTY GE <FS_COMPS>-INDQT.
          <FS_COMPS>-ASNQTY = <FS_COMPS>-INDQT.
          <FS_LIST>-ASNQTY = <FS_LIST>-ASNQTY - <FS_COMPS>-ASNQTY.
        ELSE.
          <FS_COMPS>-ASNQTY = <FS_LIST>-ASNQTY.
          CLEAR <FS_LIST>-ASNQTY.
        ENDIF.
      ENDIF.
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

      IF <FS_LIST>-POQTY > 0.
        IF <FS_LIST>-POQTY GE <FS_COMPS>-INDQT.
          <FS_COMPS>-POQTY = <FS_COMPS>-INDQT.
          <FS_LIST>-POQTY = <FS_LIST>-POQTY - <FS_COMPS>-POQTY.
        ELSE.
          <FS_COMPS>-POQTY = <FS_LIST>-POQTY.
          CLEAR <FS_LIST>-POQTY.
        ENDIF.
      ENDIF.

*   Final
      <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

    ENDIF.

**>>BOM Level > 1
*****    IF <fs_comps>-bomlv > 1.  TEMP CHANGE 19.02.2020

    "For calculating open order quantity of component
    "Get net indent qunatity of the 'Upper level'
    IF <FS_COMPS>-BOMLV = 1 .

      CLEAR LS_OUT1.
      READ TABLE GT_COMPS
       INTO LS_OUT1
       WITH KEY VBELN = <FS_COMPS>-VBELN
                POSNR = <FS_COMPS>-POSNR
                LEVEL = <FS_COMPS>-UPLVL.
      IF SY-SUBRC = 0.
        IF LS_OUT1-INDQT = 0.
          <FS_COMPS>-OMENG = 0.
          """"  Added  by KD on 31.05.2017     """""""
        ELSE.
**          <fs_comps>-omeng = ls_out1-indqt.   "Incorrect - this code overwriting correct values
          """""""      End 31.05.2017          """"""

          <FS_COMPS>-OMENG = <FS_COMPS>-OMENG * LS_OUT1-INDQT.
        ENDIF.
      ENDIF.

    ENDIF.


    IF <FS_COMPS>-BOMLV > 1.

      CLEAR LS_OUT1.
      READ TABLE GT_COMPS
       INTO LS_OUT1
       WITH KEY VBELN = <FS_COMPS>-VBELN
                POSNR = <FS_COMPS>-POSNR
                LEVEL = <FS_COMPS>-UPLVL
                IDNRK = <FS_COMPS>-PARENT.    "added By Pankaj on 09.02.2023
      IF SY-SUBRC = 0.
        <FS_COMPS>-OMENG = <FS_COMPS>-OMENG * LS_OUT1-INDQT.
      ENDIF.
    ENDIF.

*    "Added Sanjay 13.07.2023
*    IF <FS_COMPS>-BOMLV = 1.
*      CLEAR LS_OUT2.
*
*      READ TABLE GT_COMPS
*      INTO LS_OUT2
*      WITH KEY VBELN = <FS_COMPS>-VBELN
*               POSNR = <FS_COMPS>-POSNR
*               LEVEL = <FS_COMPS>-UPLVL
*               IDNRK = <FS_COMPS>-PARENT
*               BESKZ = <FS_COMPS>-BESKZ.
**                SOBSL = <FS_COMPS>-SOBSL.
*      IF SY-SUBRC = 0 AND <FS_COMPS>-SOBSL = '' AND ( <FS_COMPS>-MTART = 'ROH' OR <FS_COMPS>-MTART = 'HALB') AND  <FS_COMPS>-BESKZ = 'F'.
*        <FS_COMPS>-REMARKS = 'Do Not take Action'.
*      ENDIF.
*
*    ELSEIF <FS_COMPS>-BOMLV > 1.
*      CLEAR LS_OUT2.
*
*      READ TABLE GT_COMPS
*      INTO LS_OUT2
*      WITH KEY VBELN = <FS_COMPS>-VBELN
*               POSNR = <FS_COMPS>-POSNR
*               LEVEL = <FS_COMPS>-UPLVL
*               IDNRK = <FS_COMPS>-PARENT
*               BESKZ = <FS_COMPS>-BESKZ
*               SOBSL = <FS_COMPS>-SOBSL.
*      IF SY-SUBRC = 0 AND <FS_COMPS>-SOBSL = '' AND ( <FS_COMPS>-MTART = 'ROH' OR <FS_COMPS>-MTART = 'HALB') AND  <FS_COMPS>-BESKZ = 'F'.
*        <FS_COMPS>-REMARKS = 'Do Not take Action'.
*      ENDIF.
*
*    ENDIF.
*    "Ended Sanjay 07.07.2023


*Level = 2,3,.. - Calc Shortage quantity
    "Initial
*SELECT SINGLE *
*                FROM MARC
*                INTO @DATA(wa_MARC)
*                WHERE MATNR = @<FS_COMPS>-PARENT
*                  and werks = @<FS_COMPS>-WERKS.
    IF WA_MARC-BESKZ = 'F' AND WA_MARC-SOBSL = ''.

    ELSE.
      <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-WIPOT
                       + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).
    ENDIF.



    IF <FS_COMPS>-SHRTQ LE 0.
      <FS_COMPS>-SHRTQ = 0.
    ELSE.

* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity


*NON-SO linked WIP quantity only for BOM level > 1
      IF <FS_LIST>-WITOT > 0.
        IF <FS_LIST>-WITOT GE <FS_COMPS>-SHRTQ.
          <FS_COMPS>-WIPOT = <FS_COMPS>-SHRTQ.
          <FS_LIST>-WITOT = <FS_LIST>-WITOT - <FS_COMPS>-WIPOT.
        ELSE.
          <FS_COMPS>-WIPOT = <FS_LIST>-WITOT.
          CLEAR <FS_LIST>-WITOT.
        ENDIF.
      ENDIF.
      <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-WIPOT
                       + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).

      IF <FS_LIST>-UNSTK > 0.
        IF <FS_COMPS>-MTART = 'FERT'.
           <FS_COMPS>-UNSTK = KALAB.
         ELSE.
        IF <FS_LIST>-UNSTK GE <FS_COMPS>-SHRTQ.
          <FS_COMPS>-UNSTK = <FS_COMPS>-SHRTQ.
          <FS_LIST>-UNSTK = <FS_LIST>-UNSTK - <FS_COMPS>-UNSTK.
        ELSE.
          <FS_COMPS>-UNSTK = <FS_LIST>-UNSTK.
          CLEAR <FS_LIST>-UNSTK.
        ENDIF.
      ENDIF.
      ENDIF.
      <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-WIPOT
                       + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).

      IF <FS_LIST>-QMSTK > 0.
        SELECT SUM( KAINS )
                          FROM MSKA

                          WHERE MATNR = @<FS_COMPS>-IDNRK
                            AND VBELN = @<FS_COMPS>-VBELN
                            AND POSNR = @<FS_COMPS>-POSNR INTO @DATA(KAINS2).
        <FS_COMPS>-QMSTK =  KAINS2.
        IF KAINS2 IS INITIAL.
          IF <FS_LIST>-QMSTK GE <FS_COMPS>-SHRTQ.
            <FS_COMPS>-QMSTK = <FS_COMPS>-SHRTQ.
            <FS_LIST>-QMSTK = <FS_LIST>-QMSTK - <FS_COMPS>-QMSTK.
          ELSE.
            <FS_COMPS>-QMSTK = <FS_LIST>-QMSTK.
            CLEAR <FS_LIST>-QMSTK.
          ENDIF.
        ENDIF.

      ENDIF.
      <FS_COMPS>-SHRTQ = <FS_COMPS>-OMENG - ( <FS_COMPS>-WIPQT + <FS_COMPS>-WIPOT
                       + <FS_COMPS>-UNST1 + <FS_COMPS>-UNSTK + <FS_COMPS>-QMSTK ).
    ENDIF.

*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

    <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).
    IF  <FS_LIST>-VNSTK > 0.
      IF <FS_LIST>-VNSTK GE <FS_COMPS>-INDQT.
        <FS_COMPS>-VNSTK = <FS_COMPS>-INDQT.
        <FS_LIST>-VNSTK = <FS_LIST>-VNSTK - <FS_COMPS>-VNSTK.
      ELSE.
        <FS_COMPS>-VNSTK = <FS_LIST>-VNSTK.
        CLEAR <FS_LIST>-VNSTK.
      ENDIF.

    ENDIF.

    <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

    IF <FS_LIST>-ASNQTY > 0.
      IF <FS_LIST>-ASNQTY GE <FS_COMPS>-INDQT.
        <FS_COMPS>-ASNQTY = <FS_COMPS>-INDQT.
        <FS_LIST>-ASNQTY = <FS_LIST>-ASNQTY - <FS_COMPS>-ASNQTY.
      ELSE.
        <FS_COMPS>-ASNQTY = <FS_LIST>-ASNQTY.
        CLEAR <FS_LIST>-ASNQTY.
      ENDIF.
    ENDIF.
    <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

    IF <FS_LIST>-POQTY > 0.
      IF <FS_LIST>-POQTY GE <FS_COMPS>-INDQT.
        <FS_COMPS>-POQTY = <FS_COMPS>-INDQT.
        <FS_LIST>-POQTY = <FS_LIST>-POQTY - <FS_COMPS>-POQTY.
      ELSE.
        <FS_COMPS>-POQTY = <FS_LIST>-POQTY.
        CLEAR <FS_LIST>-POQTY.
      ENDIF.
    ENDIF.

*   Final
    <FS_COMPS>-INDQT = <FS_COMPS>-SHRTQ - ( <FS_COMPS>-VNSTK + <FS_COMPS>-ASNQTY + <FS_COMPS>-POQTY ).

    "Refresh Date
    <FS_COMPS>-REFDT = SY-DATUM.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = <FS_COMPS>-REFDT
      IMPORTING
        OUTPUT = <FS_COMPS>-REFDT.

    CONCATENATE <FS_COMPS>-REFDT+0(2) <FS_COMPS>-REFDT+2(3) <FS_COMPS>-REFDT+5(4)
                    INTO <FS_COMPS>-REFDT SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = <FS_COMPS>-REQDT
      IMPORTING
        OUTPUT = <FS_COMPS>-REQDTF.
    CONCATENATE <FS_COMPS>-REQDTF+0(2) <FS_COMPS>-REQDTF+2(3) <FS_COMPS>-REQDTF+5(4)
                INTO <FS_COMPS>-REQDTF SEPARATED BY '-'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = <FS_COMPS>-ACTDT
      IMPORTING
        OUTPUT = <FS_COMPS>-ACTDTF.
    CONCATENATE <FS_COMPS>-ACTDTF+0(2) <FS_COMPS>-ACTDTF+2(3) <FS_COMPS>-ACTDTF+5(4)
                INTO <FS_COMPS>-ACTDTF SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = <FS_COMPS>-EDATU
      IMPORTING
        OUTPUT = <FS_COMPS>-EDATUF.
    CONCATENATE <FS_COMPS>-EDATUF+0(2) <FS_COMPS>-EDATUF+2(3) <FS_COMPS>-EDATUF+5(4)
                INTO <FS_COMPS>-EDATUF SEPARATED BY '-'.
    IF <FS_COMPS>-DELDATE IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = <FS_COMPS>-DELDATE
        IMPORTING
          OUTPUT = <FS_COMPS>-DELDATEF.
      CONCATENATE <FS_COMPS>-DELDATEF+0(2) <FS_COMPS>-DELDATEF+2(3) <FS_COMPS>-DELDATEF+5(4)
                  INTO <FS_COMPS>-DELDATEF SEPARATED BY '-'.
    ELSE.
      <FS_COMPS>-DELDATEF = ''.
    ENDIF.

*    <FS_COMPS>-RECEIPT_DATE = <FS_COMPS>-RECEIPT_DATE.

*      IF  <FS_COMPS>-RECEIPT_DATE IS NOT INITIAL.
*       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        INPUT  =  <FS_COMPS>-RECEIPT_DATE
*      IMPORTING
*        OUTPUT =   <FS_COMPS>-RECEIPTDATE.
*    CONCATENATE   <FS_COMPS>-RECEIPTDATE+0(2)   <FS_COMPS>-RECEIPTDATE+2(3)   <FS_COMPS>-RECEIPTDATE+5(4)
*                INTO   <FS_COMPS>-RECEIPTDATE SEPARATED BY '-'.
*    ELSE.
*       <FS_COMPS>-RECEIPTDATE = ''.
*      endif.

    <FS_COMPS>-WMENGN = <FS_COMPS>-WMENG.
*DATA VALUE TYPE CLIKE.
    IF <FS_COMPS>-WMENGN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-WMENGN.
    ENDIF.

    <FS_COMPS>-OMENGN = <FS_COMPS>-OMENG.
    IF <FS_COMPS>-OMENGN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-OMENGN.
    ENDIF.

    <FS_COMPS>-REQ_QTY = <FS_COMPS>-REQ_QTY. "ADDDED BY JYOTI ON 08.04.2025

    IF <FS_COMPS>-REQ_QTY < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-REQ_QTY.
    ENDIF.
    <FS_COMPS>-REQ_QTY = <FS_COMPS>-REQ_QTY.

    <FS_COMPS>-WIPQTN = <FS_COMPS>-WIPQT.
    IF <FS_COMPS>-WIPQTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-WIPQTN.
    ENDIF.
    <FS_COMPS>-WIPOTN = <FS_COMPS>-WIPOT.
    IF <FS_COMPS>-WIPOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-WIPOTN.
    ENDIF.
    <FS_COMPS>-WITOTN = <FS_COMPS>-WITOT.
    IF <FS_COMPS>-WITOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-WITOTN.
    ENDIF.
    <FS_COMPS>-UNST1N = <FS_COMPS>-UNST1.
    IF <FS_COMPS>-UNST1N < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-UNST1N.
    ENDIF.
    <FS_COMPS>-UNSTKN = <FS_COMPS>-UNSTK.
    IF <FS_COMPS>-UNSTKN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-UNSTKN.
    ENDIF.
    <FS_COMPS>-UNTOTN = <FS_COMPS>-UNTOT.
    IF <FS_COMPS>-UNTOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-UNTOTN.
    ENDIF.
    <FS_COMPS>-QMSTKN = <FS_COMPS>-QMSTK.
    IF <FS_COMPS>-QMSTKN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-QMSTKN.
    ENDIF.
    <FS_COMPS>-QMTOTN = <FS_COMPS>-QMTOT.
    IF <FS_COMPS>-QMTOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-QMTOTN.
    ENDIF.
    <FS_COMPS>-SHRTQN = <FS_COMPS>-SHRTQ.
    IF <FS_COMPS>-SHRTQN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-SHRTQN.
    ENDIF.
    <FS_COMPS>-VNSTKN = <FS_COMPS>-VNSTK.
    IF <FS_COMPS>-VNSTKN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-VNSTKN.
    ENDIF.
    <FS_COMPS>-VNTOTN = <FS_COMPS>-VNTOT.
    IF <FS_COMPS>-VNTOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-VNTOTN.
    ENDIF.
    <FS_COMPS>-ASNQTYN = <FS_COMPS>-ASNQTY.
    IF <FS_COMPS>-ASNQTYN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-ASNQTYN.
    ENDIF.
    <FS_COMPS>-ASNTOTN = <FS_COMPS>-ASNTOT.
    IF <FS_COMPS>-ASNTOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-ASNTOTN.
    ENDIF.
    <FS_COMPS>-POQTYN = <FS_COMPS>-POQTY.
    IF <FS_COMPS>-POQTYN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-POQTYN.
    ENDIF.
    <FS_COMPS>-POTOTN = <FS_COMPS>-POTOT.
    IF <FS_COMPS>-POTOTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-POTOTN.
    ENDIF.
    <FS_COMPS>-INDQTN = <FS_COMPS>-INDQT.
    IF <FS_COMPS>-INDQTN < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          VALUE = <FS_COMPS>-INDQTN.
    ENDIF.
  ENDLOOP.

  GT_OUTPUT[] = GT_COMPS[].

  LOOP AT GT_OUTPUT INTO DATA(GS_OUTPUT).
    MOVE-CORRESPONDING  GS_OUTPUT TO GS_OUTPUT_DWN.
    APPEND GS_OUTPUT_DWN TO GT_OUTPUT_DWN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TEXT_MAT
*&---------------------------------------------------------------------*
FORM GET_TEXT_MAT USING M1 TYPE STPOX-IDNRK
                  CHANGING M2 TYPE CHAR255.

  DATA : NAME TYPE THEAD-TDNAME .
  REFRESH : IT_LINE , IT_LINE[] .
  CLEAR : NAME ,M2.
  NAME = M1 .
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      CLIENT                  = SY-MANDT
      ID                      = 'GRUN'
      LANGUAGE                = 'E'
      NAME                    = NAME
      OBJECT                  = 'MATERIAL'
    TABLES
      LINES                   = IT_LINE
    EXCEPTIONS
      ID                      = 1
      LANGUAGE                = 2
      NAME                    = 3
      NOT_FOUND               = 4
      OBJECT                  = 5
      REFERENCE_CHECK         = 6
      WRONG_ACCESS_TO_ARCHIVE = 7
      OTHERS                  = 8.
  IF SY-SUBRC = 0.
    LOOP AT IT_LINE.
      CONCATENATE M2 IT_LINE-TDLINE INTO M2 SEPARATED BY ' '.
    ENDLOOP.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GT_OUTPUT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GT_OUTPUT1 .
  SORT GT_OUTPUT BY VBELN POSNR MATNR OMENG .
  DELETE ADJACENT DUPLICATES FROM GT_OUTPUT COMPARING ALL FIELDS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VEND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM VEND .

ENDFORM.
