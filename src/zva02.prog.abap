*&---------------------------------------------------------------------*
*& Report ZVA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVA02.
DATA:
  ls_order_header_in  TYPE BAPISDH1, "bapisdhead,
  ls_order_header_inx TYPE BAPISDH1X, "bapisdheax,
  lt_order_item_in    TYPE TABLE OF BAPISDITM, "bapisditm,
  ls_order_item_in    TYPE BAPISDITM, "bapisditm,
  lt_order_item_inx   TYPE TABLE OF BAPISDITMX, "bapisditmx,
  ls_order_item_inx   TYPE BAPISDITMX, "bapisditmx,
  lt_schedule_lines   TYPE TABLE OF bapischdl,
  ls_schedule_lines   TYPE bapischdl,
  lt_schedule_linesx  TYPE TABLE OF bapischdlx,
  ls_schedule_linesx  TYPE bapischdlx,
  lt_return           TYPE TABLE OF bapiret2,
  ls_return           TYPE bapiret2,
  lv_salesdocument    TYPE bapivbeln-vbeln,
  ls_bapi_te_vbak     TYPE bape_vbak.
*****
data: t_exten like bapiparex occurs 0 with header line.
data: t_extenx like bapiparex occurs 0 with header line.

data: mrp_date like vbap-zmrp_date.
data: bape_vbap like bape_vbap.

data: bape_vbapx like bape_vbapx.
*****
*******
*******
data : begin of i_tab occurs 0,
       vbeln like vbap-vbeln,
       posnr like vbap-posnr,
       matnr like vbap-matnr,
       menge like vbap-ZMENG,
       ARKTX like vbap-ARKTX,
       kdmat like vbap-kdmat,
       f_date(1) type c,
       n_pric like vbap-NETWR,
       ofm_srno(2) type n,      "Should confirm
       BSTKD like vbkd-BSTKD,
       NTGEW like vbap-NTGEW,
       BRGEW like vbap-BRGEW,
       ZINS_LOC like vbap-ZINS_LOC,
       del_dt(10) type c,
       cust_dl_dt(10) type c,
       tr_mrp_dt(10)  type c,
       exp_mrp_dt(10) type c,
       gd_r(1)        type c,
       end of i_tab.
data : wa_tab like i_tab.


data :lt_conditions_in TYPE TABLE OF bapicond,
      ls_conditions_in  TYPE bapicond,
      lt_conditions_inx TYPE table of bapicondx,
      ls_conditions_inx TYPE bapicondx,
      lt_extensionin  TYPE TABLE OF bapiparex,
      ls_extensionin  TYPE bapiparex,
      ls_bape_vbap    TYPE bape_vbap,
      ls_bape_vbapx   TYPE bape_vbapx,
      ls_logic_switch TYPE bapisdls.

DATA: lv_error TYPE abap_bool VALUE abap_false.

PARAMETERS : p_vbeln like vbak-vbeln.
BREAK-POINT.
lv_salesdocument = p_vbeln. "'0000001234'. " Your Sales Order Number

" Item Data
wa_tab-vbeln = p_vbeln.
wa_tab-posnr = '000010'.
wa_tab-matnr = 'CTBG BFV'.
wa_tab-menge = 10.
wa_tab-ARKTX = '50, 4" BFV CF8M-SS410-EPDM-LEVER'.
wa_tab-kdmat = 'ABC'.
wa_tab-f_date = '11.12.2025'.
wa_tab-n_pric = '1200.00'.
wa_tab-ofm_srno = '1'.
wa_tab-BSTKD    = '10'.
wa_tab-NTGEW    = 1.
wa_tab-BRGEW    = 1.
wa_tab-ZINS_LOC = 'NA'.
wa_tab-del_dt   = '01.04.2030'.
wa_tab-cust_dl_dt = '08.01.2026'.
wa_tab-tr_mrp_dt  = '10.12.2025'.
wa_tab-exp_mrp_dt = '10.12.2025'.
wa_tab-gd_r       = '1'. "(1)
append wa_tab to i_tab.


ls_order_item_in-target_qty = '10'.   " New target quantity
ls_order_item_in-material   = 'CTBG BFV'.
ls_order_item_in-CUST_MAT35 = 'ABC'.
ls_order_item_in-TARGET_QU  = 'NOS'.
ls_order_item_in-UNTOF_WGHT = 'KG'.
ls_order_item_in-SERV_DATE  = sy-datum.
ls_order_item_in-GROSS_WGHT = 1.
ls_order_item_in-NET_WEIGHT = 1.
APPEND ls_order_item_in TO lt_order_item_in.


ls_order_item_in-itm_number = '000010'. " Item number to change
ls_order_item_in-target_qty = '10'.   " New target quantity
ls_order_item_in-material   = 'CTBG BFV'.
ls_order_item_in-CUST_MAT35 = 'ABC'.
ls_order_item_in-TARGET_QU  = 'NOS'.
ls_order_item_in-UNTOF_WGHT = 'KG'.
ls_order_item_in-SERV_DATE  = sy-datum.
ls_order_item_in-GROSS_WGHT = 1.
ls_order_item_in-NET_WEIGHT = 1.
APPEND ls_order_item_in TO lt_order_item_in.

" Item Data 'X' structure
ls_order_item_inx-itm_number = '000010'.
ls_order_item_inx-updateflag = 'I'. " 'U' for update, 'I' for insert, 'D' for delete
ls_order_item_inx-target_qty = 'X'.
ls_order_item_inx-material   = 'X'.
ls_order_item_inx-CUST_MAT35 = 'X'.
ls_order_item_inx-TARGET_QU  = 'X'.
ls_order_item_inx-UNTOF_WGHT  = 'X'.
ls_order_item_inx-SERV_DATE  = 'X'.
ls_order_item_inx-GROSS_WGHT = 'X'.
ls_order_item_inx-NET_WEIGHT = 'X'.
APPEND ls_order_item_inx TO lt_order_item_inx.


ls_bape_vbap-vbeln          = p_vbeln. "lv_sales_document.
*lv_posnr                    = '000010'. " Item number you want to update
ls_bape_vbap-posnr          = '000010'. "lv_posnr.
ls_bape_vbap-CUSTDELDATE  = '20251231'. " Your custom date value
ls_bape_vbap-ZMRP_DATE     = '20251225'. " Your custom date value
ls_bape_vbap-zexp_mrp_date1 = '20260115'. " Your custom date value

" Move the populated structure into the EXTENSIONIN table structure
CLEAR ls_extensionin.
ls_extensionin-structure = 'BAPE_VBAP'.
" Use CALL METHOD CL_ABAP_CONTAINER_UTILITIES=>FILL_CONTAINER_C
" for robust Unicode compliance instead of direct move or offset assignment
CALL METHOD cl_abap_container_utilities=>fill_container_c
  EXPORTING
    im_value      = ls_bape_vbap
  IMPORTING
    ex_container  = ls_extensionin-valuepart1
  EXCEPTIONS
    OTHERS        = 0.
APPEND ls_extensionin TO lt_extensionin.
CLEAR ls_bape_vbap.

" --- Populate BAPE_VBAPX for the update flags ('X') ---
" Assuming the append structure in BAPE_VBAPX has fields named
" ZZCUSTDELDATE, ZZMRP_DATE, ZZEXP_MRP_DATE1 of type BAPIUPDATE

ls_bape_vbapx-vbeln          = p_vbeln. "lv_sales_document.
ls_bape_vbapx-posnr          = '000010'. "lv_posnr.
ls_bape_vbapx-custdeldate  = 'X'.
ls_bape_vbapx-zmrp_date     = 'X'.
ls_bape_vbapx-zexp_mrp_date1 = 'X'.

CLEAR ls_extensionin.
ls_extensionin-structure = 'BAPE_VBAPX'.
CALL METHOD cl_abap_container_utilities=>fill_container_c
  EXPORTING
    im_value      = ls_bape_vbapx
  IMPORTING
    ex_container  = ls_extensionin-valuepart1
  EXCEPTIONS
    OTHERS        = 0.

APPEND ls_extensionin TO lt_extensionin.
CLEAR ls_bape_vbapx.

******
* Fill conditions table
ls_conditions_in-itm_number = '000010'.   " Item number
ls_conditions_in-cond_type = 'ZPR0'.    " Condition type (e.g., Price)
ls_conditions_in-cond_value = '150.00'.  " New price value
ls_conditions_in-currency = 'INR'.       " Currency
APPEND ls_conditions_in TO lt_conditions_in.

* Fill conditions checkbox table
ls_conditions_inx-itm_number = '000010'.
ls_conditions_inx-updateflag = 'I'.
ls_conditions_inx-cond_type = 'X'.
ls_conditions_inx-cond_value = 'X'.
ls_conditions_inx-currency = 'X'.
APPEND ls_conditions_inx TO lt_conditions_inx.
******

ls_schedule_lines-itm_number = '000010'. "Sales Order Item 10
ls_schedule_lines-sched_line = '0001'. "First schedule line
ls_schedule_linesx-UPDATEFLAG = 'I'.
ls_schedule_lines-req_qty = 10.
ls_schedule_lines-req_date = sy-datum + 7. "Requested delivery in 7 days
APPEND ls_schedule_lines TO lt_schedule_lines.

ls_schedule_linesx-itm_number = '000010'. "Sales Order Item 10
ls_schedule_linesx-sched_line = '0001'. "First schedule line
ls_schedule_linesx-UPDATEFLAG = 'I'.
ls_schedule_linesx-req_qty = 'X'. "10.
ls_schedule_linesx-req_date = 'X'. "sy-datum + 7. "Requested delivery in 7 days
APPEND ls_schedule_linesx TO lt_schedule_linesx.


" If changing schedule lines, populate lt_schedule_lines and lt_schedule_linesx.

BREAK-POINT.
*EXPORT itab TO MEMORY ID 'store_itab'.
 EXPORT lt_order_item_in TO MEMORY ID 'LT_ORDER_ITEM_IN'.
 EXPORT I_TAB TO MEMORY ID 'I_TAB'.
ls_order_header_inx-updateflag = 'U'.
ls_logic_switch-cond_handl = 'X'.
CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
  EXPORTING
    salesdocument      = lv_salesdocument
    order_header_in    = ls_order_header_in
    order_header_inx   = ls_order_header_inx
*   logic_switch       = ls_logic_switch
*   BEHAVE_WHEN_ERROR  = 'P' " Optional: How to handle errors
*   SIMULATION         = 'X' " Optional: For testing without saving
  TABLES
    return             = lt_return
    order_item_in      = lt_order_item_in
    order_item_inx     = lt_order_item_inx
    CONDITIONS_IN      = lt_conditions_in
    CONDITIONS_INX     = lt_conditions_inx
    schedule_lines     = lt_schedule_lines
    schedule_linesx    = lt_schedule_linesx
    extensionin                 = lt_extensionin.
*   EXTENSIONEX                 = T_EXTENX
*   partners           = lt_partners
*   partnerchanges     = lt_partnerchanges
*   extensionin        = lt_extensionin " For custom fields
    .

LOOP AT lt_return INTO ls_return.
  IF ls_return-type EQ 'E' OR ls_return-type EQ 'A'.
    " Handle error: e.g., display message, log error
    MESSAGE ls_return-message TYPE 'E'.
    lv_error = abap_true.
    EXIT.
  ENDIF.
ENDLOOP.
BREAK-POINT.
IF lv_error EQ abap_false.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
  MESSAGE 'Sales order updated successfully.' TYPE 'S'.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  MESSAGE 'Sales order update failed. Changes rolled back.' TYPE 'E'.
ENDIF.
