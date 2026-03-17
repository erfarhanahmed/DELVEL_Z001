*&---------------------------------------------------------------------*
*& Report ZPP_SOS01
*&---------------------------------------------------------------------*
*&After action date issue resolved
*&---------------------------------------------------------------------*
REPORT zpp_sos04_ind_bom_wip_n_san_p1.

*>>
TABLES: vbap, mara, vbak.

*>>
TYPES: BEGIN OF ty_main,
         idnrk    TYPE stpox-idnrk,       "component
         vbeln    TYPE vbap-vbeln,        "Sales Document
         posnr    TYPE vbap-posnr,        "Sales Document Item
         etenr    TYPE vbep-etenr,        "Delivery Schedule Line Number
*         idtxt    TYPE makt-maktx,        "Component
         idtxt    TYPE char255,            "Component       :: Added By KD on 01.06.2017
         matnr    TYPE vbap-matnr,        "Material Number
*         arktx    TYPE vbap-arktx,        "Short text for sales order item
         arktx    TYPE char255,           "Short text for sales order item    :: Added By KD on 02.06.2017
         werks    TYPE vbap-werks,        "Plant
         lfsta    TYPE vbup-lfsta,        "Delivery status
         edatu    TYPE vbep-edatu,        "Requested delivery date
         edatuf   TYPE char12,
         deldate  TYPE vbap-deldate,      "Delivery Date
         deldatef TYPE char12,
         actdt    TYPE mdps-dat00,        "Action Date
         actdtf   TYPE char12,
         reqdt    TYPE sy-datum,          "Requirement Date
         reqdtf   TYPE char12,
         schid    TYPE char25,            "Schedule ID
         kunnr    TYPE vbak-kunnr,        "Customer code
         vkbur    TYPE vbak-vkbur,        "Branch
         meins    TYPE vbap-meins,        "Unit of Measurement
         wmeng    TYPE vbep-wmeng,        "Cumulative Order Quantity in Sales Units
         omeng    TYPE vbbe-omeng,        "Open SO Quantity   "Open Qty in Stockkeeping Units for Transfer of Reqmts to MRP
         wipqt    TYPE mng01,             "WIP Stock
         wipot    TYPE mng01,             "WIP Other
         witot    TYPE mng01,             "WIP Total
         unst1    TYPE mng01,             "SO Unrestricted Stock
         unstk    TYPE mng01,             "Other Unrestricted Stock
         untot    TYPE mng01,             "Tot Unrestricted Stock
         qmstk    TYPE mng01,             "Quality Stock
         qmtot    TYPE mng01,
         shrtq    TYPE mng01,             "Shortage Quantity
         vnstk    TYPE mng01,             "Vendor Stock
         vntot    TYPE mng01,             "total Vendor Stock
         asnqty   TYPE mng01,             "PO Quantity
         asntot   TYPE mng01,             "PO Total
         poqty    TYPE mng01,             "PO Quantity
         potot    TYPE mng01,             "PO Total
         indqt    TYPE mng01,             "Net Indent
         verpr    TYPE mbew-verpr,        "Moving Average Price
         plifz    TYPE marc-plifz,        "Lead time
         ekgrp    TYPE marc-ekgrp,        "Purchasing group
         dispo    TYPE marc-dispo,        "MRP Controller
         brand    TYPE mara-brand,        "Brand
         zseries  TYPE mara-zseries,      "Series
         zsize    TYPE mara-zsize,        "Size
         moc      TYPE mara-moc,          "MOC
         type     TYPE mara-type,         "Type
         bomlv(2) TYPE n,                 "BOM Level
         mtart    TYPE mara-mtart,        "Material type
         bismt    TYPE mara-bismt,        "Old Mat No.
         beskz    TYPE marc-beskz,        "Procurement Type
         sobsl    TYPE marc-sobsl,        "Special procurement type
         extra    TYPE mdez-extra,        "MRP element data
         labst    TYPE mard-labst,        "Valuated Unrestricted-Use Stock
         uplvl    TYPE char40,
         level    TYPE char40,
         name1    TYPE kna1-name1,
         stprs    TYPE mbew-stprs,
         zeinr    TYPE mara-zeinr,
         parent   TYPE stpox-idnrk,  "added By Pankaj on 09.02.2023
         refdt    TYPE char12,
*         REMARKS  TYPE CHAR18,
         verprn   TYPE char16,
         stprsn   TYPE char16,
         wmengn   TYPE char16,
         omengn   TYPE char16,
         wipqtn   TYPE char16,
         wipotn   TYPE char16,
         witotn   TYPE char16,
         unst1n   TYPE char16,
         unstkn   TYPE char16,
         untotn   TYPE char16,
         qmstkn   TYPE char16,
         qmtotn   TYPE char16,
         shrtqn   TYPE char16,
         vnstkn   TYPE char16,
         vntotn   TYPE char16,
         asnqtyn  TYPE char16,
         asntotn  TYPE char16,
         poqtyn   TYPE char16,
         pototn   TYPE char16,
         indqtn   TYPE char16,
         andat    TYPE char16, "addded by primus jyoti on 01.12.2023
         annam    TYPE char16, "addded by primus jyoti on 01.12.2023
         aedat    TYPE char16, "addded by primus jyoti on 01.12.2023
         aenam    TYPE char16, "addded by primus jyoti on 01.12.2023
         lgort    TYPE vbap-lgort, "ADDED BY JYOTI ON 11.06.2024
         req_qty  TYPE char16,  "ADDED BY JYOTI ON 08.04.2025
*         RECEIPT_DATE  TYPE VBAP-RECEIPT_DATE,"addded by primus jyoti on 20.12.2023
*         RECEIPTDATE TYPE CHAR12,
       END OF ty_main.

TYPES: BEGIN OF ty_main_dwn,
         idnrk    TYPE stpox-idnrk,       "component
         vbeln    TYPE vbap-vbeln,        "Sales Document
         posnr    TYPE vbap-posnr,        "Sales Document Item
         etenr    TYPE vbep-etenr,        "Delivery Schedule Line Number
*         idtxt    TYPE makt-maktx,        "Component
         idtxt    TYPE char255,            "Component       :: Added By KD on 01.06.2017
         matnr    TYPE vbap-matnr,        "Material Number
*         arktx    TYPE vbap-arktx,        "Short text for sales order item
         arktx    TYPE char255,           "Short text for sales order item    :: Added By KD on 02.06.2017
         werks    TYPE vbap-werks,        "Plant
         lfsta    TYPE vbup-lfsta,        "Delivery status
*         EDATU    TYPE VBEP-EDATU,        "Requested delivery date
         edatuf   TYPE char12,
*         DELDATE  TYPE VBAP-DELDATE,      "Delivery Date
         deldatef TYPE char12,
*         ACTDT    TYPE MDPS-DAT00,        "Action Date
         actdtf   TYPE char12,
*         REQDT    TYPE SY-DATUM,          "Requirement Date
         reqdtf   TYPE char12,
         schid    TYPE char25,            "Schedule ID
         kunnr    TYPE vbak-kunnr,        "Customer code
         vkbur    TYPE vbak-vkbur,        "Branch
         meins    TYPE vbap-meins,        "Unit of Measurement
         wmengn   TYPE char16,
         omengn   TYPE char16,
         wipqtn   TYPE char16,
         wipotn   TYPE char16,
         witotn   TYPE char16,
         unst1n   TYPE char16,
         unstkn   TYPE char16,
         untotn   TYPE char16,
         qmstkn   TYPE char16,
         qmtotn   TYPE char16,
         shrtqn   TYPE char16,
         vnstkn   TYPE char16,
         vntotn   TYPE char16,
         asnqtyn  TYPE char16,
         asntotn  TYPE char16,
         poqtyn   TYPE char16,
         pototn   TYPE char16,
         indqtn   TYPE char16,
         verprn   TYPE char16,        "Moving Average Price
         plifz    TYPE marc-plifz,        "Lead time
         ekgrp    TYPE marc-ekgrp,        "Purchasing group
         dispo    TYPE marc-dispo,        "MRP Controller
         brand    TYPE mara-brand,        "Brand
         zseries  TYPE mara-zseries,      "Series
         zsize    TYPE mara-zsize,        "Size
         moc      TYPE mara-moc,          "MOC
         type     TYPE mara-type,         "Type
         bomlv(2) TYPE n,                 "BOM Level
         mtart    TYPE mara-mtart,        "Material type
         bismt    TYPE mara-bismt,        "Old Mat No.
         beskz    TYPE marc-beskz,        "Procurement Type
         sobsl    TYPE marc-sobsl,        "Special procurement type
         extra    TYPE mdez-extra,        "MRP element data
         labst    TYPE mard-labst,        "Valuated Unrestricted-Use Stock
         uplvl    TYPE char40,
         level    TYPE char40,
         name1    TYPE kna1-name1,
         stprsn   TYPE char16,
         zeinr    TYPE mara-zeinr,
         refdt    TYPE char12,
*         REMARKS  TYPE CHAR18,
         andat    TYPE char16, "addded by primus jyoti on 01.12.2023
         annam    TYPE char16, "addded by primus jyoti on 01.12.2023
         aedat    TYPE char16, "addded by primus jyoti on 01.12.2023
         aenam    TYPE char16, "addded by primus jyoti on 01.12.2023
         lgort    TYPE vbap-lgort, "ADDED BY JYOTI ON 11.06.2024
         req_qty  TYPE char16,  "ADDED BY JYOTI ON 08.04.2025
*         RECEIPT_DATE    TYPE CHAR12,"addded by primus jyoti on 20.12.2023
*         RECEIPTDATE TYPE CHAR12,
       END OF ty_main_dwn.
*>>
TYPES GT_COMPS_tab TYPE TABLE OF ty_main.
TYPES GT_LIST_tab TYPE TABLE OF ty_main.
TYPES GT_WIP2_tab TYPE TABLE OF ty_main.
TYPES GT_WIP1_tab TYPE TABLE OF ty_main.
TYPES GT_OUTPUT_DWN_tab TYPE TABLE OF ty_main_dwn.
TYPES GT_UNS1_tab TYPE TABLE OF ty_main.

DATA gt_main   TYPE TABLE OF ty_main.
DATA gt_comps  TYPE TABLE OF ty_main.
DATA gt_output TYPE TABLE OF ty_main.
DATA gs_output TYPE  ty_main.
DATA gt_output_dwn TYPE TABLE OF ty_main_dwn.
DATA gt_dwn TYPE TABLE OF ty_main_dwn.
DATA gs_output_dwn TYPE  ty_main_dwn.
DATA gs_dwn TYPE  ty_main_dwn.
DATA gt_list   TYPE TABLE OF ty_main.
DATA wa_LIST_AP   TYPE ty_main.
DATA gt_list_ap   TYPE TABLE OF ty_main.
DATA gt_list_ap1   TYPE TABLE OF ty_main.
DATA gt_wip1   TYPE TABLE OF ty_main.
DATA gt_wip2   TYPE TABLE OF ty_main.
*DATA gt_out2   TYPE TABLE OF ty_main.
DATA gt_uns1   TYPE TABLE OF ty_main.


DATA : e_mt61d TYPE  mt61d,
       e_mdkp  TYPE  mdkp,
       e_cm61m TYPE  cm61m,
       e_mdsta TYPE  mdsta,
       e_ergbz TYPE  sfilt-ergbz,
       e_cm61w TYPE  cm61w,
       mdsux   TYPE TABLE OF mdsu.

DATA: wa_zsal TYPE zsales_shortage.
DATA: lv_begda TYPE p0001-begda.

DATA gv_maxlvl(2) TYPE n VALUE '00'.
*DATA lv_old.  " VALUE 'X'.
DATA : it_line TYPE TABLE OF tline WITH HEADER LINE .
DATA: fs_comps TYPE ty_main.
DATA:  fs_list TYPE ty_main.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
    PARAMETERS      p_werks TYPE marc-werks DEFAULT 'PL01' ."MEMORY ID mat.
    SELECT-OPTIONS: s_vbeln FOR vbap-vbeln,
                    s_matnr FOR mara-matnr,
                    s_edatu FOR vbak-vdatu.
  SELECTION-SCREEN END OF BLOCK b2.
  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME.
    PARAMETERS: p_hdonly AS CHECKBOX.
    PARAMETERS: p_nozero AS CHECKBOX.
    PARAMETERS  p_hidden TYPE char8 NO-DISPLAY.
  SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.  "H:\planning\actuator'  ##NO_TEXT
  .
SELECTION-SCREEN END OF BLOCK b5.

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
  PERFORM get_data.
  PERFORM set_data.
***SOC by farhan on dated 24.06.2025
*  EXPORT GT_OUTPUT_DWN[] TO MEMORY ID 'ZSOS_PRIMUS_NEW'.

  IF p_hidden IS INITIAL.
    PERFORM complete_data USING p_werks p_hidden CHANGING gt_list[]  gt_output_dwn[]  gt_comps gt_wip1[] .
***EOC by farhan on dated 24.06.2025



    IF p_nozero IS NOT INITIAL.
      DELETE gt_output WHERE omeng = 0.
    ENDIF.

    SORT gt_output BY vbeln posnr level.

    IF p_down IS INITIAL.
      PERFORM viv_data.
    ELSE.
      PERFORM down_set TABLES gt_output_dwn USING p_folder.
    ENDIF.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT a~vbeln a~posnr a~matnr a~lfsta
         a~arktx a~werks a~meins a~deldate a~receipt_date a~lgort  "LGORT ADDED BY JYOTI ON 11.06.2024
         d~edatu d~wmeng d~etenr "C~LFSTA
         f~omeng
         g~plifz
     INTO CORRESPONDING FIELDS OF TABLE gt_main   ##TOO_MANY_ITAB_FIELDS
     FROM vbap AS a
*     JOIN VBUP AS C ON C~VBELN = A~VBELN
*                   AND C~POSNR = A~POSNR
     JOIN vbep AS d ON a~vbeln = d~vbeln
                   AND a~posnr = d~posnr
     JOIN vbbe AS f ON a~vbeln = f~vbeln
                   AND a~posnr = f~posnr
                   AND d~etenr = f~etenr
     JOIN marc AS g ON a~matnr = g~matnr
     WHERE a~vbeln IN s_vbeln
       AND a~werks = p_werks
       AND a~lfsta NE 'C'
       AND a~matnr IN s_matnr
       AND d~edatu IN s_edatu
       AND d~wmeng NE 0
       AND d~ettyp = 'CP'
       AND g~werks = p_werks.

*       AND g~werks = p_werks.
*       AND g~werks = p_werks.
  SORT gt_main BY vbeln posnr matnr.
  DELETE ADJACENT DUPLICATES FROM gt_main COMPARING ALL FIELDS.



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
FORM set_data .

  DATA: ls_comps TYPE ty_main.
  DATA: lt_vbak TYPE TABLE OF vbak,
        ls_vbak TYPE vbak.
  DATA: ls_list1 TYPE ty_main.
  DATA: ls_list1_t1 TYPE ty_main.
  DATA: ls_list1_t2 TYPE ty_main.

*>
  SELECT * FROM vbak INTO TABLE lt_vbak
    FOR ALL ENTRIES IN gt_main
  WHERE vbeln = gt_main-vbeln.

  LOOP AT gt_main INTO ls_comps.

    ls_comps-idnrk = ls_comps-matnr.
    ls_comps-lgort = ls_comps-lgort."added by jyoti on 11.06.2024


    CONCATENATE ls_comps-vbeln ls_comps-posnr ls_comps-etenr
      INTO ls_comps-schid.
    CONCATENATE ls_comps-vbeln ls_comps-posnr
      INTO ls_comps-extra SEPARATED BY '/'.
    READ TABLE lt_vbak INTO ls_vbak
      WITH KEY vbeln = ls_comps-vbeln.

    ls_comps-kunnr = ls_vbak-kunnr.
    SELECT SINGLE name1 INTO ls_comps-name1 FROM kna1 WHERE kunnr = ls_comps-kunnr.
    ls_comps-vkbur = ls_vbak-vkbur.
    ls_comps-bomlv = '00'.

    PERFORM hdr_calc USING ls_comps.
    ls_comps-shrtq = ls_comps-omeng - ( ls_comps-unstk + ls_comps-qmstk ).
    ls_comps-indqt = ls_comps-shrtq .

*---------Added By Snehal Rajale On 27.01.2021-----------------------*
    CLEAR wa_zsal.
    SELECT * FROM zsales_shortage INTO wa_zsal
    WHERE vbeln = ls_comps-vbeln.
    ENDSELECT.

    IF wa_zsal IS NOT INITIAL.
**lv_begda = ls_comps-edatu.
      lv_begda = sy-datum + wa_zsal-zdays_so.
      ls_comps-edatu = lv_begda.
    ENDIF.
*---------Ended By Snehal Rajale On 27.01.2021-----------------------*

    ls_comps-reqdt = ls_comps-edatu.
    ls_comps-actdt = ls_comps-reqdt - ls_comps-plifz.

    APPEND ls_comps TO gt_comps.
    ls_list1-idnrk = ls_comps-matnr.
    ls_list1-bomlv = '00'.    "identify headers
    COLLECT ls_list1 INTO gt_list.
    ls_list1_t1 = ls_list1.

*    ls_list1_t1-vbeln = ls_comps-vbeln.
*    ls_list1_t1-posnr = ls_comps-posnr.
*    ls_list1_t1-matnr = ls_comps-matnr.
    APPEND  ls_list1_t1 TO gt_list_ap.

    PERFORM get_comps USING ls_comps-matnr ls_comps.
  ENDLOOP.

*  LOOP AT gt_list_ap INTO DATA(wa_gt_list_ap).
*collect wa_gt_list_ap into gt_list_ap1.
*CLEAR:wa_gt_list_ap.
*ENDLOOP.
*  PERFORM line_calc.
************SOC by farhan on dated 24.06.2025
  EXPORT gt_list[] TO MEMORY ID 'GT_LIST'.
  EXPORT gt_comps[] TO MEMORY ID 'GT_COMPS'.
  EXPORT gt_wip1[] TO MEMORY ID 'GT_WIP1'.
  export gt_list_ap to MEMORY id 'GT_LIST_AP'.
*  PERFORM NET_CALC.
*
*  PERFORM WIP_TOTALS.
*
*  PERFORM GET_MAT_DATA.
*
*  IF P_HDONLY IS NOT INITIAL.
*    DELETE GT_COMPS WHERE BOMLV IS NOT INITIAL.
*  ENDIF.
*
*  SORT GT_COMPS BY EDATU VBELN MATNR LEVEL POSNR. "Added By Snehal Rajale On 28.01.2021
*
*  PERFORM ALL_CALC.
*
*  PERFORM VEND.

****EOC by farhan on dated 24.06.2025

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VIV_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM viv_data .

  DATA:
    lt_fcat  TYPE slis_t_fieldcat_alv,
    ls_layo  TYPE slis_layout_alv,
    lv_repid TYPE sy-repid,
    lt_sort  TYPE slis_t_sortinfo_alv.

*  gt_output[] = gt_comps[].

  IF NOT gt_output IS INITIAL.
    PERFORM set_fcat CHANGING lt_fcat.
    PERFORM set_layo CHANGING ls_layo.
*    PERFORM set_sort CHANGING lt_sort.

    lv_repid = sy-repid.

    PERFORM gt_output1.



    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK        = ' '
*       I_BYPASSING_BUFFER       = ' '
*       I_BUFFER_ACTIVE          = ' '
        i_callback_program       = lv_repid
        i_callback_pf_status_set = 'PF_STATUS_SET'
*       i_callback_user_command  = 'USER_COMMAND'
*       i_callback_top_of_page   = 'TOP_OF_PAGE'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME         =
*       I_BACKGROUND_ID          = ' '
*       I_GRID_TITLE             =
*       I_GRID_SETTINGS          =
        is_layout                = ls_layo
        it_fieldcat              = lt_fcat
*       IT_EXCLUDING             =
*       IT_SPECIAL_GROUPS        =
        it_sort                  = lt_sort
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
        t_outtab                 = gt_output
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
FORM pf_status_set   ##CALLED
   USING rt_extab    ##NEEDED
     TYPE slis_t_extab.
  SET PF-STATUS 'MAIN'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
FORM set_fcat  CHANGING pt_fcat TYPE slis_t_fieldcat_alv.

  DEFINE add_fcat.
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

  DATA: ps_fieldcatalog TYPE slis_fieldcat_alv,
        lv_pos          TYPE i.

  add_fcat :
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
FORM set_layo  CHANGING ps_layo TYPE slis_layout_alv.
  ps_layo-zebra  = 'X'.
  ps_layo-colwidth_optimize  = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_COMPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_COMPS  text
*----------------------------------------------------------------------*
FORM get_comps  USING pv_matnr TYPE matnr
                      ps_comps TYPE ty_main.

  DATA: lt_stb TYPE TABLE OF stpox,
        ls_stb TYPE stpox.
  DATA: lv_emeng TYPE stko-bmeng.
  DATA: ls_list2 TYPE ty_main.
  DATA: ls_list1_t2 TYPE ty_main.
  DATA: lv_lvitm(2) TYPE n.
*  DATA: lv_level TYPE ty_main-level.
*  DATA: lv_bomlv TYPE ty_main-bomlv.

  DATA: ls_comps TYPE ty_main.

  ls_comps = ps_comps.

*  lv_emeng = ps_comps-indqt.  "ps_comps-omeng.  - removed - even level 1 open so calculated in all_calc
  lv_emeng = 0.

  CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
    EXPORTING
      capid                 = 'PP01'
      datuv                 = sy-datum
      emeng                 = lv_emeng
*     mehrs                 = 'X'
      mtnrv                 = pv_matnr
      stpst                 = 0
      svwvo                 = 'X'
      werks                 = p_werks
      vrsvo                 = 'X'
    TABLES
      stb                   = lt_stb
    EXCEPTIONS
      alt_not_found         = 1
      call_invalid          = 2
      material_not_found    = 3
      missing_authorization = 4
      no_bom_found          = 5
      no_plant_data         = 6
      no_suitable_bom_found = 7
      conversion_error      = 8
      OTHERS                = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.

*below values should not be passed to components
    CLEAR:  ls_comps-unstk, ls_comps-qmstk, ls_comps-indqt, ls_comps-shrtq, ls_comps-unst1.

*> Requirement date of component = Action date of header
    ls_comps-reqdt = ps_comps-actdt.
    ls_comps-uplvl = ps_comps-level.
    ls_comps-bomlv = ps_comps-bomlv + 1.

    IF gv_maxlvl < ls_comps-bomlv.
      gv_maxlvl = ls_comps-bomlv.
    ENDIF.

    CLEAR:  ls_comps-actdt, ls_comps-plifz, ls_comps-level.

    lv_lvitm = '01'.

    LOOP AT lt_stb INTO ls_stb.
      ls_comps-idnrk = ls_stb-idnrk.
*      ls_comps-bomlv = ls_stb-stufe.
      ls_comps-meins = ls_stb-meins.
      ls_comps-mtart = ls_stb-mtart.
      ls_comps-omeng = ls_stb-mnglg.
      ls_comps-req_qty = ls_stb-mnglg. "added by jyoti on 08.04.2025
      ls_comps-parent = pv_matnr.    "added By Pankaj on 09.02.2023
      ls_comps-andat = ls_stb-andat. "added By JYOTI on 01.12.2023
      IF  ls_comps-andat IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_comps-andat
          IMPORTING
            output = ls_comps-andat.
        CONCATENATE  ls_comps-andat+0(2)  ls_comps-andat+2(3)  ls_comps-andat+5(4)
                    INTO  ls_comps-andat SEPARATED BY '-'.
      ELSE.
        ls_comps-andat = ''.
      ENDIF.
      ls_comps-annam = ls_stb-annam."added By JYOTI on 01.12.2023
      ls_comps-aedat = ls_stb-aedat."added By JYOTI on 01.12.2023
      IF ls_comps-aedat = '00000000'.
        ls_comps-aedat = ''.
      ENDIF.
      IF ls_comps-aedat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = ls_comps-aedat
          IMPORTING
            output = ls_comps-aedat.
        CONCATENATE  ls_comps-aedat+0(2)  ls_comps-aedat+2(3)  ls_comps-aedat+5(4)
                    INTO  ls_comps-aedat SEPARATED BY '-'.
      ELSE.
        ls_comps-aedat = ''.
      ENDIF.

      ls_comps-aenam = ls_stb-aenam."added By JYOTI on 01.12.2023
      SELECT SINGLE plifz INTO ls_comps-plifz
        FROM marc
        WHERE matnr = ls_comps-idnrk
      AND werks = p_werks.

      ls_comps-actdt = ls_comps-reqdt - ls_comps-plifz.

      CONCATENATE ls_comps-uplvl '.' lv_lvitm INTO ls_comps-level.

      """"""""""      Added By KD on 31.05.2017       """"""""
*      IF ls_comps-mtart NE 'FERT'.
*        CLEAR ls_comps-unst1 .
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""
      APPEND ls_comps TO gt_comps.
      lv_lvitm = lv_lvitm + 1.

      ls_list2-idnrk = ls_stb-idnrk.
      ls_list2-bomlv = '01'.
      COLLECT ls_list2 INTO gt_list.
         ls_list1_t2  = ls_list2.
       APPEND  ls_list2 TO gt_list_ap.
      PERFORM get_comps USING ls_stb-idnrk ls_comps.

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
FORM net_calc USING  p_werks CHANGING gt_list  TYPE GT_LIST_tab
                                      gt_comps TYPE GT_COMPS_tab
                                      gt_wip2  TYPE GT_WIP2_tab
                                      gt_uns1  TYPE GT_UNS1_tab
                                      gt_wip1  TYPE GT_WIP1_tab
                                      fs_list  TYPE ty_main.



  DATA: lt_mdps TYPE TABLE OF mdps,
        ls_mdps TYPE mdps,
        lt_mdez TYPE TABLE OF mdez,
        ls_mdez TYPE mdez.
*  DATA: ls_list TYPE ty_main.
*  DATA: lv_vbeln TYPE vbak-vbeln,
*        lv_aufnr TYPE afko-aufnr.
  DATA: "lt_order TYPE TABLE OF afko,
    ls_order TYPE afko,
*    lt_resb  TYPE TABLE OF resb,
    ls_resb  TYPE resb.
  DATA  ls_wip   TYPE ty_main.
  DATA  ls_afpo  TYPE afpo.
  DATA  ls_uns   TYPE ty_main.

  FIELD-SYMBOLS <fs_list> TYPE ty_main.
*  FIELD-SYMBOLS <fs_comps> TYPE ty_main.

*>
  SORT gt_comps BY idnrk vbeln posnr etenr.
*BREAK-POINT.
  LOOP AT gt_list ASSIGNING <fs_list>.
    CHECK <fs_list>-bomlv NE '0'.
    REFRESH: lt_mdps, lt_mdez.
    CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
      EXPORTING
        matnr                    = <fs_list>-idnrk
        werks                    = p_werks
        berid                    = 'PL01'
      IMPORTING
        e_mt61d                  = e_mt61d
        e_mdkp                   = e_mdkp
        e_cm61m                  = e_cm61m
        e_mdsta                  = e_mdsta
        e_ergbz                  = e_ergbz
      TABLES
        mdpsx                    = lt_mdps
        mdezx                    = lt_mdez
        mdsux                    = mdsux
      EXCEPTIONS
        material_plant_not_found = 1
        plant_not_found          = 2
        OTHERS                   = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here

    ELSE.

      LOOP AT lt_mdez INTO ls_mdez WHERE delkz = 'WB'.
        <fs_list>-unstk = <fs_list>-unstk + ls_mdez-mng01.
      ENDLOOP.

*      LOOP AT lt_mdez INTO ls_mdez WHERE delkz = 'KB'.
**        <fs_list>-unstk = <fs_list>-unstk + ls_mdez-mng01.
*
*
*      ENDLOOP.

      LOOP AT lt_mdps INTO ls_mdps.
        CASE ls_mdps-delkz.
          WHEN 'LA'.
            DATA: lv_ebeln1 TYPE ekko-ebeln.
            CLEAR: lv_ebeln1. "lv_ebelp, ls_ekpo.
            lv_ebeln1 = ls_mdps-delnr.    "extra+0(10).
            SELECT SINGLE ebeln FROM ekko INTO lv_ebeln1
            WHERE ebeln = lv_ebeln1 AND frgke = '2'.
            IF  sy-subrc = 0.
*              IF ls_mdps-sobes = '0' .
              <fs_list>-asnqty = <fs_list>-asnqty + ls_mdps-mng01.
*              ELSE.
*                <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
*              ENDIF.
            ENDIF.

          WHEN 'BE'.
            DATA: lv_ebeln TYPE ekko-ebeln.
            CLEAR: lv_ebeln. "lv_ebelp, ls_ekpo.
            lv_ebeln = ls_mdps-delnr.    "extra+0(10).
            SELECT SINGLE ebeln FROM ekko INTO lv_ebeln
            WHERE ebeln = lv_ebeln AND frgke = '2'.
            IF  sy-subrc = 0.
              IF ls_mdps-sobes = '0' .
                <fs_list>-poqty = <fs_list>-poqty + ls_mdps-mng01.
              ELSE.
                <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
              ENDIF.
            ENDIF.
          WHEN 'QM'.
            <fs_list>-qmstk = <fs_list>-qmstk + ls_mdps-mng01.

          WHEN 'KB'.
            CLEAR ls_uns.
            ls_uns-vbeln = ls_mdps-kdauf.   "ps_comps-vbeln.
            ls_uns-posnr = ls_mdps-kdpos.   "ps_comps-posnr.
            ls_uns-matnr = <fs_list>-idnrk. "ps_comps-matnr.
            ls_uns-idnrk = <fs_list>-idnrk.
            ls_uns-unst1 = ls_mdps-mng01.
            APPEND ls_uns TO gt_uns1.

          WHEN 'FE'.

            CLEAR ls_order.
            IF ls_mdps-kdauf IS INITIAL.
              ls_order-aufnr = ls_mdps-del12.
              CLEAR: ls_resb, ls_afpo.

              SELECT * FROM afpo INTO ls_afpo
                WHERE aufnr = ls_order-aufnr.
                SELECT * FROM resb INTO ls_resb
                  WHERE aufnr = ls_order-aufnr
*                    AND matnr = <fs_list>-idnrk
                    AND xloek <> 'X'              "
                    AND enmng > 0
                    AND shkzg = 'H'.
                  CLEAR ls_wip.
                  ls_wip-idnrk = ls_resb-matnr.
                  ls_wip-witot =
                     ( ls_resb-enmng - ( ls_afpo-wemng * ( ls_resb-bdmng  / ls_afpo-psmng ) ) ).
                  COLLECT ls_wip INTO gt_wip2.
                ENDSELECT.
              ENDSELECT.
            ELSE.   "ls_mdps-kdauf IS NOT INITIAL
*           BOM component is a FERT and has its own sales order associated Prod order.
              ls_order-aufnr = ls_mdps-del12.
              CLEAR: ls_resb, ls_afpo.

              SELECT * FROM afpo INTO ls_afpo
                WHERE aufnr = ls_order-aufnr.
                SELECT * FROM resb INTO ls_resb
                  WHERE aufnr = ls_order-aufnr
*                    AND matnr = <fs_list>-idnrk
                    AND xloek <> 'X'              "
                    AND enmng > 0
                    AND shkzg = 'H'.
                  CLEAR ls_wip.
                  ls_wip-vbeln = ls_mdps-kdauf.   "ps_comps-vbeln.
                  ls_wip-posnr = ls_mdps-kdpos.   "ps_comps-posnr.
                  ls_wip-matnr = <fs_list>-idnrk. "ps_comps-matnr.
                  ls_wip-idnrk = ls_resb-matnr.
                  ls_wip-wipqt =
                     ( ls_resb-enmng - ( ls_afpo-wemng * ( ls_resb-bdmng  / ls_afpo-psmng ) ) ).
                  APPEND ls_wip TO gt_wip1.
                ENDSELECT.
              ENDSELECT.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      SELECT SUM( labst ) FROM mard INTO <fs_list>-labst
        WHERE matnr = <fs_list>-idnrk
      AND werks = p_werks.

    ENDIF.
  ENDLOOP.


  LOOP AT gt_list ASSIGNING <fs_list>.
    IF <fs_list>-bomlv EQ '0' AND <fs_list>-vnstk IS  INITIAL.
*      CHECK <fs_list>-bomlv EQ '0'.
      REFRESH: lt_mdps, lt_mdez.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = <fs_list>-idnrk
          werks                    = p_werks
        IMPORTING
          e_mt61d                  = e_mt61d
          e_mdkp                   = e_mdkp
          e_cm61m                  = e_cm61m
          e_mdsta                  = e_mdsta
          e_ergbz                  = e_ergbz
        TABLES
          mdpsx                    = lt_mdps
          mdezx                    = lt_mdez
          mdsux                    = mdsux
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here

      ELSE.


        LOOP AT lt_mdps INTO ls_mdps.
          CASE ls_mdps-delkz.
            WHEN 'LA'.
              CLEAR: lv_ebeln1. "lv_ebelp, ls_ekpo.
              lv_ebeln1 = ls_mdps-delnr.    "extra+0(10).
              SELECT SINGLE ebeln FROM ekko INTO lv_ebeln1
              WHERE ebeln = lv_ebeln1 AND frgke = '2'.
              IF  sy-subrc = 0.
*                IF ls_mdps-sobes = '0' .
                <fs_list>-asnqty = <fs_list>-asnqty + ls_mdps-mng01.
*                ELSE.
*                  <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
*                ENDIF.
              ENDIF.

            WHEN 'BE'.
              CLEAR: lv_ebeln. "lv_ebelp, ls_ekpo.
              lv_ebeln = ls_mdps-delnr.    "extra+0(10).
              SELECT SINGLE ebeln FROM ekko INTO lv_ebeln
              WHERE ebeln = lv_ebeln AND frgke = '2'.
              IF  sy-subrc = 0.
                IF ls_mdps-sobes = '0' .
                  <fs_list>-poqty = <fs_list>-poqty + ls_mdps-mng01.
                ELSE.
                  <fs_list>-vnstk = <fs_list>-vnstk + ls_mdps-mng01.
                ENDIF.
              ENDIF.
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
  fs_list = <fs_list>.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MAT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_mat_data USING p_werks CHANGING gt_list  TYPE GT_LIST_tab
                           gt_comps TYPE GT_COMPS_tab
                           gt_uns1  TYPE GT_UNS1_tab
                           gt_wip1  TYPE GT_WIP1_tab
                           fs_comps TYPE ty_main.

  DATA: lt_mara TYPE TABLE OF mara,
        ls_mara TYPE mara,
        lt_marc TYPE TABLE OF marc,
        ls_marc TYPE marc,
*        lt_makt TYPE TABLE OF makt,
*        ls_makt TYPE makt,
        lt_mbew TYPE TABLE OF mbew,
        ls_mbew TYPE mbew.
  DATA ls_list TYPE ty_main.
  DATA ls_wip1 TYPE ty_main.
*  DATA ls_wip2 TYPE ty_main.
  DATA ls_uns1 TYPE ty_main.

  FIELD-SYMBOLS <fs_comps> TYPE ty_main.

  SELECT * FROM mara INTO TABLE lt_mara
    FOR ALL ENTRIES IN gt_comps
  WHERE matnr = gt_comps-idnrk.

  SELECT * FROM marc INTO TABLE lt_marc
    FOR ALL ENTRIES IN gt_comps
    WHERE matnr = gt_comps-idnrk
  AND werks = p_werks.

*  SELECT * FROM makt INTO TABLE lt_makt
*    FOR ALL ENTRIES IN gt_comps
*    WHERE matnr = gt_comps-idnrk
*      AND spras = sy-langu.

  SELECT * FROM mbew INTO TABLE lt_mbew
    FOR ALL ENTRIES IN gt_comps
    WHERE matnr = gt_comps-idnrk
  AND bwkey = p_werks.

  LOOP AT gt_comps ASSIGNING <fs_comps>.
    CLEAR: ls_mara, ls_marc, ls_mbew.   " ls_makt,
    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = <fs_comps>-idnrk.
    READ TABLE lt_marc INTO ls_marc WITH KEY matnr = <fs_comps>-idnrk.
*    READ TABLE lt_makt INTO ls_makt WITH KEY matnr = <fs_comps>-idnrk.
    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = <fs_comps>-idnrk.

    """""""       Added By KD on 01.06.2017     """"""""
    PERFORM get_text_mat USING  <fs_comps>-idnrk CHANGING <fs_comps>-idtxt.
    PERFORM get_text_mat USING  <fs_comps>-matnr CHANGING <fs_comps>-arktx.
    """"""""""""""""""""""""""""""""""""""""""""""""""""
*    <fs_comps>-idtxt = ls_makt-maktx.
    <fs_comps>-brand = ls_mara-brand.
    <fs_comps>-zseries = ls_mara-zseries.
    <fs_comps>-zsize = ls_mara-zsize.
    <fs_comps>-moc   = ls_mara-moc.
    <fs_comps>-type  = ls_mara-type.
    <fs_comps>-mtart = ls_mara-mtart.
    <fs_comps>-bismt = ls_mara-bismt.
    <fs_comps>-zeinr = ls_mara-zeinr.
*    <fs_comps>-plifz = ls_marc-plifz.
    <fs_comps>-ekgrp = ls_marc-ekgrp.
    <fs_comps>-dispo = ls_marc-dispo.
    <fs_comps>-beskz = ls_marc-beskz.
    <fs_comps>-sobsl = ls_marc-sobsl.
    <fs_comps>-verpr = ls_mbew-verpr.        "Moving Average Price
    <fs_comps>-stprs = ls_mbew-stprs.        "Standard price

    CLEAR ls_list.
    READ TABLE gt_list INTO ls_list WITH KEY idnrk = <fs_comps>-idnrk.
    <fs_comps>-qmtot = ls_list-qmstk.
    <fs_comps>-vntot = ls_list-vnstk.
    <fs_comps>-asntot = ls_list-asnqty.
    <fs_comps>-potot = ls_list-poqty.
    <fs_comps>-untot = ls_list-unstk.
    <fs_comps>-witot = ls_list-witot.

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
    LOOP AT gt_wip1 INTO ls_wip1
      WHERE vbeln = <fs_comps>-vbeln
        AND posnr = <fs_comps>-posnr "matnr = <fs_comps>-matnr
        AND idnrk = <fs_comps>-idnrk..
      <fs_comps>-wipqt = <fs_comps>-wipqt + ls_wip1-wipqt.
    ENDLOOP.
    "Jayant@Fujitsu Insert ends   - Dt21.03.18
*Get non-header SO Unrestricted stock
    CLEAR ls_uns1.
    READ TABLE gt_uns1 INTO ls_uns1 WITH KEY vbeln = <fs_comps>-vbeln
                       posnr = <fs_comps>-posnr "matnr = <fs_comps>-matnr
                       idnrk = <fs_comps>-idnrk.
    IF sy-subrc = 0.
      <fs_comps>-unst1 = ls_uns1-unst1.
    ENDIF.

  ENDLOOP.
  fs_comps = <fs_comps>.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HDR_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_COMPS  text
*----------------------------------------------------------------------*
FORM hdr_calc  USING    ps_comps TYPE ty_main.

  DATA: lt_mdps TYPE TABLE OF mdps,
        ls_mdps TYPE mdps,
        lt_mdez TYPE TABLE OF mdez,
        ls_mdez TYPE mdez.
  DATA: lv_vbeln TYPE vbak-vbeln.
  DATA: lt_order TYPE TABLE OF afko,
        ls_order TYPE afko,
*        lt_resb  TYPE TABLE OF resb,
        ls_resb  TYPE resb.
  DATA  ls_wip   TYPE ty_main.
  DATA  ls_afpo  TYPE afpo.

  REFRESH: lt_mdps, lt_mdez.
  CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
    EXPORTING
      matnr                    = ps_comps-idnrk
      werks                    = p_werks
      berid                    = 'PL01'
*     IMPORTING
*     E_MT61D                  =
*     E_MDKP                   =
*     E_CM61M                  =
*     E_MDSTA                  =
*     E_ERGBZ                  =
    TABLES
      mdpsx                    = lt_mdps
      mdezx                    = lt_mdez
*     MDSUX                    =
    EXCEPTIONS
      material_plant_not_found = 1
      plant_not_found          = 2
      OTHERS                   = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.

    "SO - Unristricted stock
    CLEAR ls_mdez.
    READ TABLE lt_mdez INTO ls_mdez WITH KEY extra = ps_comps-extra delkz = 'KB'.
    IF sy-subrc = 0.
      ps_comps-unst1 = ls_mdez-mng01.
    ENDIF.

    REFRESH lt_order.
    LOOP AT lt_mdps INTO ls_mdps WHERE delkz = 'QM' OR delkz = 'FE'.

      IF ls_mdps-kdauf IS NOT INITIAL.
        CLEAR lv_vbeln.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_mdps-kdauf
          IMPORTING
            output = lv_vbeln.
        IF ps_comps-vbeln = lv_vbeln AND ps_comps-posnr = ls_mdps-kdpos.
          CASE ls_mdps-delkz.
            WHEN 'QM'.
              ps_comps-qmstk = ps_comps-qmstk + ls_mdps-mng01.

            WHEN 'FE'.
              ls_order-aufnr = ls_mdps-del12.
              APPEND ls_order TO lt_order.
*        WHEN OTHERS.
          ENDCASE.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_order INTO ls_order.

      CLEAR: ls_afpo, ls_resb.
      SELECT SINGLE * FROM afpo     ##WARN_OK
        INTO ls_afpo
      WHERE aufnr = ls_order-aufnr.

      SELECT * FROM resb INTO ls_resb
        WHERE aufnr = ls_order-aufnr
*              AND matnr = wa_idnrk-idnrk
          AND xloek <> 'X'
          AND enmng > 0
          AND shkzg = 'H'.
        CLEAR ls_wip.
        ls_wip-vbeln = ps_comps-vbeln.
        ls_wip-posnr = ps_comps-posnr.
        ls_wip-matnr = ps_comps-matnr.
        ls_wip-idnrk = ls_resb-matnr.
        ls_wip-wipqt = ls_resb-enmng - ( ls_afpo-wemng * ( ls_resb-bdmng  / ls_afpo-psmng ) ) .
*              wa_resb-wipqty = wa_resb-enmng - ( wa_afpo-wemng * ( wa_resb-bdmng
*                                 / wa_afpo-psmng ) ).
        APPEND ls_wip TO gt_wip1.
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
FORM down_set TABLES gt_output_dwn USING p_folder .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string.
*        lv_dat(10),
*        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
*     I_TAB_SAP_DATA       = GT_OUTPUT
      i_tab_sap_data       = gt_output_dwn
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  PERFORM csv_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*  lv_file = 'SOSTEST.TXT'.
*  lv_file = 'SOS_DATE_CHNG.TXT'.
  lv_file = 'ZSOS_PRIMUS_NEW_PL.TXT'.   "Added By Nilay B. On 17.06.2023

  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.
*   CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.

  WRITE: / 'NEW SOS for India Download started on'      ##NO_TEXT
           , sy-datum, 'at', sy-uzeit.
  WRITE: / 'Plant'                   ##NO_TEXT
           , p_werks.
  WRITE: / 'Sales Order No. From', s_vbeln-low, 'To', s_vbeln-high.
  WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
  WRITE: / 'SO Date         From', s_edatu-low, 'To', s_edatu-high.
  WRITE: / 'Dest. File:', lv_fullfile.

  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_1266 TYPE string.
    DATA lv_crlf_1266 TYPE string.
    lv_crlf_1266 = cl_abap_char_utilities=>cr_lf.
    lv_string_1266 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_1266 lv_crlf_1266 wa_csv INTO lv_string_1266.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_1266 TO lv_fullfile.
*    CLOSE DATASET LV_FULLFILE.
    CONCATENATE 'File' lv_fullfile 'downloaded'   ##NO_TEXT
      INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CSV_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM csv_header  USING    pd_csv TYPE any.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

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

   INTO pd_csv
   SEPARATED BY l_field_seperator.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  WIP_TOTALS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM wip_totals CHANGING gt_list  TYPE GT_LIST_tab
                         gt_wip2 TYPE GT_WIP2_tab
                          fs_list  TYPE ty_main.
  FIELD-SYMBOLS <fs_list> TYPE ty_main.
*  DATA ls_list TYPE ty_main.
  DATA ls_wip2 TYPE ty_main.
  ASSIGN  fs_list  TO <fs_list>.

  LOOP AT gt_list ASSIGNING <fs_list>. " WITH KEY idnrk = <fs_comps>-idnrk..
    CHECK <fs_list>-bomlv > '00'.

    CLEAR ls_wip2.
    READ TABLE gt_wip2 INTO ls_wip2 WITH KEY idnrk = <fs_list>-idnrk.
    <fs_list>-witot = ls_wip2-witot.
  ENDLOOP.
  fs_list = <fs_list>.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALL_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM all_calc CHANGING gt_list        TYPE  GT_LIST_tab
                       gt_comps       TYPE GT_COMPS_tab
                       gt_output_dwn  TYPE GT_OUTPUT_DWN_tab
                       fs_comps TYPE ty_main
                       fs_list  TYPE ty_main.
  FIELD-SYMBOLS <fs_comps> TYPE ty_main.
  FIELD-SYMBOLS <fs_list>  TYPE ty_main.

*  DATA: last_comp TYPE ty_main.
  DATA: ls_out1   TYPE ty_main.
  DATA: ls_out2   TYPE ty_main.
*    IF <fs_comps>-idnrk NE last_comp-idnrk.
*      CLEAR ls_list.
*      READ TABLE gt_list INTO ls_list WITH KEY idnrk = <fs_comps>-idnrk.
*    ENDIF.
  ASSIGN fs_comps TO <fs_comps>.
  ASSIGN  fs_list TO <fs_list> .
  LOOP AT gt_comps ASSIGNING <fs_comps>.

    READ TABLE gt_list ASSIGNING <fs_list>
      WITH KEY idnrk = <fs_comps>-idnrk.
    <fs_comps>-verprn = <fs_comps>-verpr.
    <fs_comps>-stprsn = <fs_comps>-stprs.
**>>Header Level
    IF <fs_comps>-bomlv IS INITIAL AND 1 = 2.   "Header material/Material in Sales order
*Header - Calc Shortage quantity
      "Initial
      <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      IF <fs_comps>-shrtq LE 0.
        <fs_comps>-shrtq = 0.
      ELSE.


* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity

*First Unrestricted stock  ---  This piece of code may not be relevent for Header
        IF <fs_list>-unstk > 0.
          IF <fs_list>-unstk GE <fs_comps>-shrtq.  "If tot unrst > comp shrt then, pass reqd unst to comp
            <fs_comps>-unstk = <fs_comps>-shrtq.
            <fs_list>-unstk = <fs_list>-unstk - <fs_comps>-unstk.    "and subtract same from total
          ELSE.
            <fs_comps>-unstk = <fs_list>-unstk.    "Else assign whatever to comp-unrst
            CLEAR <fs_list>-unstk.
          ENDIF.
        ENDIF.
        "After assignment of Unrestricted stock
        <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

*SO WIP qauntity calulation NOT required for Header

*Second QM Stock
        IF <fs_list>-qmstk > 0.
          IF <fs_list>-qmstk GE <fs_comps>-shrtq.
            <fs_comps>-qmstk = <fs_comps>-shrtq.
            <fs_list>-qmstk = <fs_list>-qmstk - <fs_comps>-qmstk.
          ELSE.
            <fs_comps>-qmstk = <fs_list>-qmstk.
            CLEAR <fs_list>-qmstk.
          ENDIF.
        ENDIF.
        "After assignment of Quality stock
        <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      ENDIF.
*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

      "Calculate Net Indent
      "Initial
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

      "First Vendor Stock
      IF  <fs_list>-vnstk > 0.
        IF <fs_list>-vnstk GE <fs_comps>-indqt.
          <fs_comps>-vnstk = <fs_comps>-indqt.
          <fs_list>-vnstk = <fs_list>-vnstk - <fs_comps>-vnstk.
        ELSE.
          <fs_comps>-vnstk = <fs_list>-vnstk.
          CLEAR <fs_list>-vnstk.
        ENDIF.
      ENDIF.
      "After assignment of Vendor stock
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

      "Second ASN Quanity
      IF <fs_list>-asnqty > 0.
        IF <fs_list>-asnqty GE <fs_comps>-indqt.
          <fs_comps>-asnqty = <fs_comps>-indqt.
          <fs_list>-asnqty = <fs_list>-asnqty - <fs_comps>-asnqty.
        ELSE.
          <fs_comps>-asnqty = <fs_list>-asnqty.
          CLEAR <fs_list>-asnqty.
        ENDIF.
      ENDIF.
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).
      "Second PO Quanity
      IF <fs_list>-poqty > 0.
        IF <fs_list>-poqty GE <fs_comps>-indqt.
          <fs_comps>-poqty = <fs_comps>-indqt.
          <fs_list>-poqty = <fs_list>-poqty - <fs_comps>-poqty.
        ELSE.
          <fs_comps>-poqty = <fs_list>-poqty.
          CLEAR <fs_list>-poqty.
        ENDIF.
      ENDIF.

      "Final indent quantity
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

    ENDIF.  "Header material/Material in Sales order

**>>BOM Level = 1
    IF <fs_comps>-bomlv = 1 AND 1 = 2.
      "Make OPen SO quantiy to zero if the header Indent Qty is zero
      "Get net indent qunatity of the 'Header level'
      CLEAR ls_out1.
      READ TABLE gt_comps
       INTO ls_out1
       WITH KEY vbeln = <fs_comps>-vbeln
                posnr = <fs_comps>-posnr
                level = <fs_comps>-uplvl.
      IF sy-subrc = 0.
        IF ls_out1-indqt = 0.
          <fs_comps>-omeng = 0.
          """"  Added  by KD on 31.05.2017     """""""
        ELSE.
**          <fs_comps>-omeng = ls_out1-indqt.   "Incorrect - this code overwriting correct values
          """""""      End 31.05.2017          """"""

          <fs_comps>-omeng = <fs_comps>-omeng * ls_out1-indqt.
        ENDIF.
      ENDIF.

*Level 1 - Calc Shortage quantity
      "Initial
      <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      IF <fs_comps>-shrtq LE 0.
        <fs_comps>-shrtq = 0.
      ELSE.

* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity

*Unrestricted stock
        IF <fs_list>-unstk > 0.
          IF <fs_list>-unstk GE <fs_comps>-shrtq.
            <fs_comps>-unstk = <fs_comps>-shrtq.
            <fs_list>-unstk = <fs_list>-unstk - <fs_comps>-unstk.
          ELSE.
            <fs_comps>-unstk = <fs_list>-unstk.
            CLEAR <fs_list>-unstk.
          ENDIF.
        ENDIF.
        <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

*SO related WIP quantity already assigned in WIPQTY

*NO SO WIP qauntity considered for Header and BOM level 1

*QM Stock
        IF <fs_list>-qmstk > 0.
          IF <fs_list>-qmstk GE <fs_comps>-shrtq.
            <fs_comps>-qmstk = <fs_comps>-shrtq.
            <fs_list>-qmstk = <fs_list>-qmstk - <fs_comps>-qmstk.
          ELSE.
            <fs_comps>-qmstk = <fs_list>-qmstk.
            CLEAR <fs_list>-qmstk.
          ENDIF.
        ENDIF.
        <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      ENDIF.
*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).
      IF  <fs_list>-vnstk > 0.
        IF <fs_list>-vnstk GE <fs_comps>-indqt.
          <fs_comps>-vnstk = <fs_comps>-indqt.
          <fs_list>-vnstk = <fs_list>-vnstk - <fs_comps>-vnstk.
        ELSE.
          <fs_comps>-vnstk = <fs_list>-vnstk.
          CLEAR <fs_list>-vnstk.
        ENDIF.

      ENDIF.

      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

      IF <fs_list>-asnqty > 0.
        IF <fs_list>-asnqty GE <fs_comps>-indqt.
          <fs_comps>-asnqty = <fs_comps>-indqt.
          <fs_list>-asnqty = <fs_list>-asnqty - <fs_comps>-asnqty.
        ELSE.
          <fs_comps>-asnqty = <fs_list>-asnqty.
          CLEAR <fs_list>-asnqty.
        ENDIF.
      ENDIF.
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

      IF <fs_list>-poqty > 0.
        IF <fs_list>-poqty GE <fs_comps>-indqt.
          <fs_comps>-poqty = <fs_comps>-indqt.
          <fs_list>-poqty = <fs_list>-poqty - <fs_comps>-poqty.
        ELSE.
          <fs_comps>-poqty = <fs_list>-poqty.
          CLEAR <fs_list>-poqty.
        ENDIF.
      ENDIF.

*   Final
      <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

    ENDIF.

**>>BOM Level > 1
*****    IF <fs_comps>-bomlv > 1.  TEMP CHANGE 19.02.2020

    "For calculating open order quantity of component
    "Get net indent qunatity of the 'Upper level'
    IF <fs_comps>-bomlv = 1 .

      CLEAR ls_out1.
      READ TABLE gt_comps
       INTO ls_out1
       WITH KEY vbeln = <fs_comps>-vbeln
                posnr = <fs_comps>-posnr
                level = <fs_comps>-uplvl.
      IF sy-subrc = 0.
        IF ls_out1-indqt = 0.
          <fs_comps>-omeng = 0.
          """"  Added  by KD on 31.05.2017     """""""
        ELSE.
**          <fs_comps>-omeng = ls_out1-indqt.   "Incorrect - this code overwriting correct values
          """""""      End 31.05.2017          """"""

          <fs_comps>-omeng = <fs_comps>-omeng * ls_out1-indqt.
        ENDIF.
      ENDIF.

    ENDIF.


    IF <fs_comps>-bomlv > 1.

      CLEAR ls_out1.
      READ TABLE gt_comps
       INTO ls_out1
       WITH KEY vbeln = <fs_comps>-vbeln
                posnr = <fs_comps>-posnr
                level = <fs_comps>-uplvl
                idnrk = <fs_comps>-parent.    "added By Pankaj on 09.02.2023
      IF sy-subrc = 0.
        <fs_comps>-omeng = <fs_comps>-omeng * ls_out1-indqt.
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
    <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-wipot
                     + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).


    IF <fs_comps>-shrtq LE 0.
      <fs_comps>-shrtq = 0.
    ELSE.

* omeng "Open SO Quantity   wipqt "WIP Stock           unstk "Unrestricted Stock  untot "Tot Unrestricted Stock
* qmstk "Quality Stock      qmtot "Tot Quality Stock   shrtq "Shortage Quantity

*NON-SO linked WIP quantity only for BOM level > 1
      IF <fs_list>-witot > 0.
        IF <fs_list>-witot GE <fs_comps>-shrtq.
          <fs_comps>-wipot = <fs_comps>-shrtq.
          <fs_list>-witot = <fs_list>-witot - <fs_comps>-wipot.
        ELSE.
          <fs_comps>-wipot = <fs_list>-witot.
          CLEAR <fs_list>-witot.
        ENDIF.
      ENDIF.
      <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-wipot
                       + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      IF <fs_list>-unstk > 0.
        IF <fs_list>-unstk GE <fs_comps>-shrtq.
          <fs_comps>-unstk = <fs_comps>-shrtq.
          <fs_list>-unstk = <fs_list>-unstk - <fs_comps>-unstk.
        ELSE.
          <fs_comps>-unstk = <fs_list>-unstk.
          CLEAR <fs_list>-unstk.
        ENDIF.
      ENDIF.
      <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-wipot
                       + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).

      IF <fs_list>-qmstk > 0.
        IF <fs_list>-qmstk GE <fs_comps>-shrtq.
          <fs_comps>-qmstk = <fs_comps>-shrtq.
          <fs_list>-qmstk = <fs_list>-qmstk - <fs_comps>-qmstk.
        ELSE.
          <fs_comps>-qmstk = <fs_list>-qmstk.
          CLEAR <fs_list>-qmstk.
        ENDIF.
      ENDIF.
      <fs_comps>-shrtq = <fs_comps>-omeng - ( <fs_comps>-wipqt + <fs_comps>-wipot
                       + <fs_comps>-unst1 + <fs_comps>-unstk + <fs_comps>-qmstk ).
    ENDIF.

*  vnstk  "Vendor Stock   vntot
*  poqty  "PO Quantity    potot        *  indqt  "Net Indent

    <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).
    IF  <fs_list>-vnstk > 0.
      IF <fs_list>-vnstk GE <fs_comps>-indqt.
        <fs_comps>-vnstk = <fs_comps>-indqt.
        <fs_list>-vnstk = <fs_list>-vnstk - <fs_comps>-vnstk.
      ELSE.
        <fs_comps>-vnstk = <fs_list>-vnstk.
        CLEAR <fs_list>-vnstk.
      ENDIF.

    ENDIF.

    <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

    IF <fs_list>-asnqty > 0.
      IF <fs_list>-asnqty GE <fs_comps>-indqt.
        <fs_comps>-asnqty = <fs_comps>-indqt.
        <fs_list>-asnqty = <fs_list>-asnqty - <fs_comps>-asnqty.
      ELSE.
        <fs_comps>-asnqty = <fs_list>-asnqty.
        CLEAR <fs_list>-asnqty.
      ENDIF.
    ENDIF.
    <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

    IF <fs_list>-poqty > 0.
      IF <fs_list>-poqty GE <fs_comps>-indqt.
        <fs_comps>-poqty = <fs_comps>-indqt.
        <fs_list>-poqty = <fs_list>-poqty - <fs_comps>-poqty.
      ELSE.
        <fs_comps>-poqty = <fs_list>-poqty.
        CLEAR <fs_list>-poqty.
      ENDIF.
    ENDIF.

*   Final
    <fs_comps>-indqt = <fs_comps>-shrtq - ( <fs_comps>-vnstk + <fs_comps>-asnqty + <fs_comps>-poqty ).

    "Refresh Date
    <fs_comps>-refdt = sy-datum.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = <fs_comps>-refdt
      IMPORTING
        output = <fs_comps>-refdt.

    CONCATENATE <fs_comps>-refdt+0(2) <fs_comps>-refdt+2(3) <fs_comps>-refdt+5(4)
                    INTO <fs_comps>-refdt SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = <fs_comps>-reqdt
      IMPORTING
        output = <fs_comps>-reqdtf.
    CONCATENATE <fs_comps>-reqdtf+0(2) <fs_comps>-reqdtf+2(3) <fs_comps>-reqdtf+5(4)
                INTO <fs_comps>-reqdtf SEPARATED BY '-'.
    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = <fs_comps>-actdt
      IMPORTING
        output = <fs_comps>-actdtf.
    CONCATENATE <fs_comps>-actdtf+0(2) <fs_comps>-actdtf+2(3) <fs_comps>-actdtf+5(4)
                INTO <fs_comps>-actdtf SEPARATED BY '-'.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = <fs_comps>-edatu
      IMPORTING
        output = <fs_comps>-edatuf.
    CONCATENATE <fs_comps>-edatuf+0(2) <fs_comps>-edatuf+2(3) <fs_comps>-edatuf+5(4)
                INTO <fs_comps>-edatuf SEPARATED BY '-'.
    IF <fs_comps>-deldate IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = <fs_comps>-deldate
        IMPORTING
          output = <fs_comps>-deldatef.
      CONCATENATE <fs_comps>-deldatef+0(2) <fs_comps>-deldatef+2(3) <fs_comps>-deldatef+5(4)
                  INTO <fs_comps>-deldatef SEPARATED BY '-'.
    ELSE.
      <fs_comps>-deldatef = ''.
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

    <fs_comps>-wmengn = <fs_comps>-wmeng.
*DATA VALUE TYPE CLIKE.
    IF <fs_comps>-wmengn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-wmengn.
    ENDIF.

    <fs_comps>-omengn = <fs_comps>-omeng.
    IF <fs_comps>-omengn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-omengn.
    ENDIF.

    <fs_comps>-req_qty = <fs_comps>-req_qty. "ADDDED BY JYOTI ON 08.04.2025

    IF <fs_comps>-req_qty < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-req_qty.
    ENDIF.
    <fs_comps>-req_qty = <fs_comps>-req_qty.

    <fs_comps>-wipqtn = <fs_comps>-wipqt.
    IF <fs_comps>-wipqtn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-wipqtn.
    ENDIF.
    <fs_comps>-wipotn = <fs_comps>-wipot.
    IF <fs_comps>-wipotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-wipotn.
    ENDIF.
    <fs_comps>-witotn = <fs_comps>-witot.
    IF <fs_comps>-witotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-witotn.
    ENDIF.
    <fs_comps>-unst1n = <fs_comps>-unst1.
    IF <fs_comps>-unst1n < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-unst1n.
    ENDIF.
    <fs_comps>-unstkn = <fs_comps>-unstk.
    IF <fs_comps>-unstkn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-unstkn.
    ENDIF.
    <fs_comps>-untotn = <fs_comps>-untot.
    IF <fs_comps>-untotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-untotn.
    ENDIF.
    <fs_comps>-qmstkn = <fs_comps>-qmstk.
    IF <fs_comps>-qmstkn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-qmstkn.
    ENDIF.
    <fs_comps>-qmtotn = <fs_comps>-qmtot.
    IF <fs_comps>-qmtotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-qmtotn.
    ENDIF.
    <fs_comps>-shrtqn = <fs_comps>-shrtq.
    IF <fs_comps>-shrtqn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-shrtqn.
    ENDIF.
    <fs_comps>-vnstkn = <fs_comps>-vnstk.
    IF <fs_comps>-vnstkn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-vnstkn.
    ENDIF.
    <fs_comps>-vntotn = <fs_comps>-vntot.
    IF <fs_comps>-vntotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-vntotn.
    ENDIF.
    <fs_comps>-asnqtyn = <fs_comps>-asnqty.
    IF <fs_comps>-asnqtyn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-asnqtyn.
    ENDIF.
    <fs_comps>-asntotn = <fs_comps>-asntot.
    IF <fs_comps>-asntotn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-asntotn.
    ENDIF.
    <fs_comps>-poqtyn = <fs_comps>-poqty.
    IF <fs_comps>-poqtyn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-poqtyn.
    ENDIF.
    <fs_comps>-pototn = <fs_comps>-potot.
    IF <fs_comps>-pototn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-pototn.
    ENDIF.
    <fs_comps>-indqtn = <fs_comps>-indqt.
    IF <fs_comps>-indqtn < 0.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = <fs_comps>-indqtn.
    ENDIF.
  ENDLOOP.

  gt_output[] = gt_comps[].

  LOOP AT gt_output INTO DATA(gs_output).
    MOVE-CORRESPONDING  gs_output TO gs_output_dwn.
    APPEND gs_output_dwn TO gt_output_dwn.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TEXT_MAT
*&---------------------------------------------------------------------*
FORM get_text_mat USING m1 TYPE stpox-idnrk
                  CHANGING m2 TYPE char255.

  DATA : name TYPE thead-tdname .
  REFRESH : it_line , it_line[] .
  CLEAR : name ,m2.
  name = m1 .
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = 'GRUN'
      language                = 'E'
      name                    = name
      object                  = 'MATERIAL'
    TABLES
      lines                   = it_line
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc = 0.
    LOOP AT it_line.
      CONCATENATE m2 it_line-tdline INTO m2 SEPARATED BY ' '.
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
FORM gt_output1 .
  SORT gt_output BY vbeln posnr matnr omeng .
  DELETE ADJACENT DUPLICATES FROM gt_output COMPARING ALL FIELDS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VEND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM vend .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form complete_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_LIST[]
*&      <-- GT_OUTPUT_DWN[]
*&      <-- GT_COMPS
*&      --> P_WERKS
*&---------------------------------------------------------------------*
FORM complete_data USING  p_werks p_hidden CHANGING gt_list        TYPE GT_LIST_tab
                                                    gt_output_dwn  TYPE GT_OUTPUT_DWN_tab
                                                    gt_comps       TYPE GT_COMPS_tab
                                                    gt_wip1        TYPE gt_wip1_tab.

  IF p_hidden IS INITIAL.
    PERFORM net_calc USING  p_werks CHANGING gt_list[]
                                             gt_comps[]
                                             gt_wip2[]
                                             gt_uns1[]
                                             gt_wip1[]
                                             fs_list.

    PERFORM wip_totals CHANGING  gt_list[]
                                 gt_wip2[]
                                 fs_list.

    PERFORM get_mat_data USING p_werks CHANGING   gt_list[]
                                   gt_comps[]
                                   gt_uns1[]
                                   gt_wip1[]
                                   fs_comps.

    IF p_hdonly IS NOT INITIAL.
      DELETE gt_comps WHERE bomlv IS NOT INITIAL.
    ENDIF.

    SORT gt_comps BY edatu vbeln matnr level posnr. "Added By Snehal Rajale On 28.01.2021

    PERFORM all_calc CHANGING gt_list[]
                              gt_comps[]
                              gt_output_dwn
                              fs_comps
                              fs_list.

    PERFORM vend.
  ENDIF.
ENDFORM.
