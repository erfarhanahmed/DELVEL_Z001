*&---------------------------------------------------------------------*
*& Report ZVA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVA02_NEW.
*ALV
* Types Pools
TYPE-POOLS:
   slis.
* Types
TYPES:
   t_fieldcat         TYPE slis_fieldcat_alv,
   t_events           TYPE slis_alv_event,
   t_layout           TYPE slis_layout_alv.
* Workareas
DATA:
   w_fieldcat         TYPE t_fieldcat,
   w_events           TYPE t_events,
   w_layout           TYPE t_layout,
   gt_events TYPE t_events,
      ls_event TYPE t_events.
* Internal Tables
DATA:
   i_fieldcat         TYPE STANDARD TABLE OF t_fieldcat,
   i_events           TYPE STANDARD TABLE OF t_events.
*ALV
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
DATA: lt_order_text TYPE STANDARD TABLE OF BAPISDTEXT, "bapisditxt,
      wa_order_text TYPE BAPISDTEXT, "bapisditxt,
      lv_tdline     TYPE tdline.
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
       f_date(10) type c,
       n_pric like vbap-NETWR,
       ofm_srno(2) type n,      "Should confirm
       BSTKD like vbkd-BSTKD,
       NTGEW like vbap-NTGEW,
       BRGEW like vbap-BRGEW,
       ZINS_LOC like vbap-ZINS_LOC,
       del_dt(10) type c,
       cust_dl_dt(10) type c,
       ofm_dl_dt(10)  type c,
       tr_mrp_dt(10)  type c,
       exp_mrp_dt(10) type c,
       gd_r(1)        type c,
       remark(70) type c,
       end of i_tab.
data : wa_tab like i_tab.
data : i_tab1 like TABLE OF i_tab,
       wa_tab1 like i_tab.


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
*****
DATA:   lv_mestext TYPE char100.
DATA : filename TYPE string.
DATA : lv_fname TYPE localfile.
DATA : it_excel TYPE TABLE OF alsmex_tabline.
DATA : wa_excel TYPE alsmex_tabline.

DATA : lin_count(002), in_count(003).
DATA : x1(015),x2(015),x3(015),x4(015).
*****
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: p_file   TYPE localfile OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.
START-OF-SELECTION.
  PERFORM upload_file.

loop at i_tab into wa_tab.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = wa_tab-vbeln
  IMPORTING
    output = wa_tab-vbeln.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = wa_tab-posnr
  IMPORTING
    output = wa_tab-posnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = wa_tab-matnr
  IMPORTING
    output = wa_tab-matnr.
 modify i_tab from wa_tab.
 clear : wa_tab.
endloop.
  i_tab1[] = i_tab[].
  perform data_process.
  PERFORM build_fieldcatlog.
  PERFORM build_events.
  PERFORM build_layout.
  PERFORM list_display.

*&---------------------------------------------------------------------*
*& Form upload_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM UPLOAD_FILE .
 lv_fname = p_file.
* Make to usable content
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_fname
      i_begin_col             = '1'
      i_begin_row             = '3'
      i_end_col               = '19'
      i_end_row               = '9999'
    TABLES
      intern                  = it_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA : lv_count(006) TYPE c.
  CLEAR lv_count.
   LOOP AT it_excel INTO wa_excel.

    CASE wa_excel-col.

      WHEN '0001'. wa_tab-vbeln      = wa_excel-value.
      WHEN '0002'. wa_tab-posnr      = wa_excel-value.
      WHEN '0003'. wa_tab-matnr      = wa_excel-value.
      WHEN '0004'. wa_tab-menge      = wa_excel-value.
      WHEN '0005'. wa_tab-arktx      = wa_excel-value.
      WHEN '0006'. wa_tab-kdmat      = wa_excel-value.
      WHEN '0007'. wa_tab-f_date     = wa_excel-value.
      WHEN '0008'. wa_tab-n_pric     = wa_excel-value.
      WHEN '0009'. wa_tab-ofm_srno   = wa_excel-value.
      WHEN '0010'. wa_tab-bstkd      = wa_excel-value.
      WHEN '0011'. wa_tab-ntgew      = wa_excel-value.
      WHEN '0012'. wa_tab-brgew      = wa_excel-value.
      WHEN '0013'. wa_tab-zins_loc   = wa_excel-value.
      WHEN '0014'. wa_tab-del_dt     = wa_excel-value.
      WHEN '0015'. wa_tab-cust_dl_dt = wa_excel-value.
      WHEN '0016'. wa_tab-ofm_dl_dt  = wa_excel-value.
      WHEN '0017'. wa_tab-tr_mrp_dt  = wa_excel-value.
      WHEN '0018'. wa_tab-exp_mrp_dt = wa_excel-value.
      WHEN '0019'. wa_tab-gd_r       = wa_excel-value.
*     WHEN '0019'. wa_tab-gd_r       = wa_excel-value.

    ENDCASE.
    AT END OF row.
      APPEND wa_tab TO i_tab.
      clear : wa_tab.
    ENDAT.
    clear : wa_excel.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH .
clear : ls_order_header_in,
        ls_order_header_inx.
refresh : lt_return[],
          lt_order_item_in[],
          lt_order_item_inx[],
          lt_conditions_in[],
          lt_conditions_inx[],
          lt_schedule_lines[],
          lt_schedule_linesx[],
          lt_extensionin[],
          lt_order_text[]..
clear : wa_tab , wa_tab1,wa_tab.
clear : lv_salesdocument.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_process
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DATA_PROCESS .
sort i_tab1 by vbeln.
data : wa_vbak like vbak.
delete ADJACENT DUPLICATES FROM i_tab1 COMPARING
                          vbeln.
EXPORT I_TAB TO MEMORY ID 'I_TAB'.
loop at i_tab1 into wa_tab1.
  move : wa_tab1-vbeln to lv_salesdocument.
loop at i_tab into wa_tab where
                   vbeln = wa_tab1-vbeln.
clear : wa_vbak.
select single * from vbak into wa_vbak where
                   vbeln = wa_tab-vbeln.
ls_order_item_in-itm_number = wa_tab-posnr.
ls_order_item_in-target_qty = wa_tab-menge. "'10'.   " New target quantity
ls_order_item_in-material   = wa_tab-matnr. "'CTBG BFV'.
ls_order_item_in-CUST_MAT35 = wa_tab-kdmat. "'ABC'.
if wa_tab-arktx ne ''.
ls_order_item_in-SHORT_TEXT = wa_tab-arktx.
else.
select single maktx into  ls_order_item_in-SHORT_TEXT
                  from makt where matnr = wa_tab-matnr.
endif.
concatenate WA_TAB-f_date+6(4) WA_TAB-f_date+3(2)
            WA_TAB-f_date+0(2) into  ls_order_item_in-FIX_VAL_DY.

ls_order_item_in-TARGET_QU  = 'NOS'.
ls_order_item_in-UNTOF_WGHT = 'KG'.
ls_order_item_in-SERV_DATE  = sy-datum.
ls_order_item_in-GROSS_WGHT = wa_tab-ntgew. "1.
ls_order_item_in-NET_WEIGHT = wa_tab-brgew. "1.
ls_order_item_in-PO_ITM_NO  = wa_tab-BSTKD.
APPEND ls_order_item_in TO lt_order_item_in.

ls_order_item_inx-itm_number = wa_tab-posnr. "'000010'.
ls_order_item_inx-updateflag = 'I'. " 'U' for update, 'I' for insert, 'D' for delete
ls_order_item_inx-target_qty = 'X'.
ls_order_item_inx-material   = 'X'.
ls_order_item_inx-SHORT_TEXT = 'X'.
ls_order_item_inx-CUST_MAT35 = 'X'.
ls_order_item_inx-FIX_VAL_DY = 'X'.
ls_order_item_inx-TARGET_QU  = 'X'.
ls_order_item_inx-UNTOF_WGHT  = 'X'.
ls_order_item_inx-SERV_DATE  = 'X'.
ls_order_item_inx-GROSS_WGHT = 'X'.
ls_order_item_inX-PO_ITM_NO  = 'X'.
ls_order_item_inx-NET_WEIGHT = 'X'.
APPEND ls_order_item_inx TO lt_order_item_inx.

***Pricing
ls_conditions_in-itm_number = wa_tab-posnr. "'000010'.   " Item number
ls_conditions_in-cond_type = 'ZPR0'.        " Condition type (e.g., Price)
ls_conditions_in-cond_value = wa_tab-n_pric." New price value
ls_conditions_in-currency = wa_vbak-WAERK. "'INR'.       " Currency
APPEND ls_conditions_in TO lt_conditions_in.

* Fill conditions checkbox table
ls_conditions_inx-itm_number = wa_tab-posnr. "'000010'.
ls_conditions_inx-updateflag = 'U'.
ls_conditions_inx-cond_type = 'X'.
ls_conditions_inx-cond_value = 'X'.
ls_conditions_inx-currency = 'X'.
*ls_conditions_inx-cond_st_no = 'X'.
*ls_conditions_inx-cond_count = 'X'.
APPEND ls_conditions_inx TO lt_conditions_inx.
***********

*SCHD
ls_schedule_lines-itm_number   = wa_tab-posnr. "'000010'. "Sales Order Item 10
ls_schedule_lines-sched_line   = '0001'. "First schedule line
ls_schedule_linesx-UPDATEFLAG = 'I'.
ls_schedule_lines-req_qty      = wa_tab-menge.
concatenate WA_TAB-f_date+6(4) WA_TAB-f_date+3(2)
            WA_TAB-f_date+0(2) into  ls_schedule_lines-req_date.

*ls_schedule_lines-req_date     = sy-datum + 7. "Requested delivery in 7 days
APPEND ls_schedule_lines TO lt_schedule_lines.

ls_schedule_linesx-itm_number = wa_tab-posnr. "'000010'. "Sales Order Item 10
ls_schedule_linesx-sched_line = '0001'. "First schedule line
ls_schedule_linesx-UPDATEFLAG = 'I'.
ls_schedule_linesx-req_qty    = 'X'. "10.
ls_schedule_linesx-req_date   = 'X'. "sy-datum + 7. "Requested delivery in 7 days
APPEND ls_schedule_linesx TO lt_schedule_linesx.

lv_tdline  = wa_tab-ofm_srno.
wa_order_text-DOC_NUMBER = wa_tab-vbeln.
wa_order_text-itm_number = wa_tab-posnr. " Item number (must be 6 digits)
wa_order_text-text_id    = 'Z102'.   " Text ID
wa_order_text-langu      = 'EN'.     " Language
wa_order_text-text_line  = lv_tdline.
APPEND wa_order_text TO lt_order_text.

clear : wa_tab,ls_order_item_in, ls_order_item_inx,
        ls_schedule_linesx,ls_conditions_inx,wa_order_text.
endloop.

*BAPI Runs,
ls_order_header_inx-updateflag = 'U'.
ls_logic_switch-pricing = 'C'.
ls_logic_switch-cond_handl = 'X'.
CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
  EXPORTING
    salesdocument      = lv_salesdocument
    order_header_in    = ls_order_header_in
    order_header_inx   = ls_order_header_inx
*    logic_switch       = ls_logic_switch
  TABLES
    return             = lt_return
    order_item_in      = lt_order_item_in
    order_item_inx     = lt_order_item_inx
    CONDITIONS_IN      = lt_conditions_in
    CONDITIONS_INX     = lt_conditions_inx
    schedule_lines     = lt_schedule_lines
    schedule_linesx    = lt_schedule_linesx
    order_text         = lt_order_text
    extensionin        = lt_extensionin.

LOOP AT lt_return INTO ls_return.
  IF ls_return-type EQ 'E' OR ls_return-type EQ 'A'.
    " Handle error: e.g., display message, log error
    MESSAGE ls_return-message TYPE 'E'.
    lv_error = abap_true.
    EXIT.
  ENDIF.
ENDLOOP.

IF lv_error EQ abap_false.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
  MESSAGE 'Sales order updated successfully.' TYPE 'S'.
  move : 'SO Updated Succusfully' to wa_tab1-remark.
  modify i_tab1 from wa_tab1.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  MESSAGE 'Sales order update failed. Changes rolled back.' TYPE 'E'.
  move :  'SO Updated Failed. Changes rolled back.' to wa_tab1-remark.
ENDIF.
perform refresh.
endloop.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_fieldcatlog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BUILD_FIELDCATLOG .
CLEAR:w_fieldcat,i_fieldcat[].

  PERFORM build_fcatalog USING:
           'VBELN' 'I_TAB1' 'VBELN',
           'REMARK' 'I_TAB1' 'REMARK'.
*           'ORT01' 'I_T001' 'ORT01',
*           'LAND1' 'I_T001' 'LAND1'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_events
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BUILD_EVENTS .
CLEAR :
  w_events, i_events[].
  w_events-name = 'TOP_OF_PAGE'."Event Name
  w_events-form = 'TOP_OF_PAGE'."Callback event subroutine
  APPEND w_events TO i_events.
  CLEAR  w_events.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BUILD_LAYOUT .
 w_layout-colwidth_optimize = 'X'.
  w_layout-zebra             = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form list_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM LIST_DISPLAY .
DATA: l_program TYPE sy-repid.
      l_program = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = l_program
      is_layout          = w_layout
      i_callback_user_command = 'HANDLE_DOUBLE_CLICK'
      it_fieldcat        = i_fieldcat
      it_events          = i_events
    TABLES
      t_outtab           = i_tab1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_fcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM build_fcatalog USING l_field l_tab l_text.

  w_fieldcat-fieldname      = l_field.
  w_fieldcat-tabname        = l_tab.
  w_fieldcat-seltext_m      = l_text.

  APPEND w_fieldcat TO i_fieldcat.
  CLEAR w_fieldcat.

ENDFORM.

FORM handle_double_click USING r_ucomm LIKE sy-ucomm
                            rs_selfield TYPE slis_selfield.

CASE r_ucomm.
    WHEN '&IC1'. " Standard function code for double-click (F2)
      READ TABLE i_tab1 INTO wa_tab1 INDEX rs_selfield-tabindex.
     IF sy-subrc = 0.
        " Example: Display Document (FB03) for BELNR field
        IF rs_selfield-fieldname = 'VBELN'. " Check if double-click was on 'BELNR'
          SET PARAMETER ID 'AUN' FIELD wa_tab1-vbeln. " Set Parameter ID for transaction
          CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN. " Call transaction
        ENDIF.
     endif.
endcase.
endform.
