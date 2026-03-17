REPORT ZVEND_BANK_UPD.



*----------------------------------------------------------------------
* TYPES for Excel
*----------------------------------------------------------------------
TYPES: BEGIN OF ty_excel,
        bp_number   TYPE bu_partner,
        bank_ctry   TYPE banks,
        bank_key    TYPE bankl,
        bank_acct   TYPE bankn,
        acct_holder TYPE char100,
      END OF ty_excel.
data : begin of i_tab occurs 0,
       kunnr like kna1-kunnr,
       remark(50) type c,
       end of i_tab.
data : wa_tab like i_tab.

*----------------------------------------------------------------------
* DATA
*----------------------------------------------------------------------
DATA: lt_raw   TYPE STANDARD TABLE OF alsmex_tabline,
     ls_raw   TYPE alsmex_tabline,
     lt_excel TYPE STANDARD TABLE OF ty_excel,
     ls_excel TYPE ty_excel.
"Your required variables
DATA: BUSINESSPARTNER_1 LIKE  BAPIBUS1006_HEAD-BPARTNER,
     BANKDETAILID      TYPE  BAPIBUS1006_HEAD-BANKDETAILID,
     BANKDETAILDATA_1  TYPE  BAPIBUS1006_BANKDETAIL,
     RETURN5           TYPE  TABLE OF BAPIRET2,
     ls_return         TYPE  BAPIRET2.
*----------------------------------------------------------------------
* PARAMETERS
*----------------------------------------------------------------------
PARAMETERS p_file TYPE rlgrap-filename OBLIGATORY.
*----------------------------------------------------------------------
* F4 Help
*----------------------------------------------------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
 CALL FUNCTION 'F4_FILENAME'
   IMPORTING
     file_name = p_file.
*----------------------------------------------------------------------
* START
*----------------------------------------------------------------------
START-OF-SELECTION.
*----------------------------------------------------------------------
* Read Excel using ALSM
*----------------------------------------------------------------------
 CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
   EXPORTING
     filename                = p_file
     i_begin_col             = 1
     i_begin_row             = 2
     i_end_col               = 100
     i_end_row               = 9999
   TABLES
     intern                  = lt_raw
   EXCEPTIONS
     inconsistent_parameters = 1
     upload_ole              = 2
     OTHERS                  = 3.
 IF sy-subrc <> 0.
   MESSAGE 'Error reading Excel file' TYPE 'E'.
 ENDIF.
*----------------------------------------------------------------------
* Convert raw Excel into structured internal table
*----------------------------------------------------------------------
 CLEAR ls_excel.
 LOOP AT lt_raw INTO ls_raw.
   CASE ls_raw-col.
     WHEN 1. ls_excel-bp_number   = ls_raw-value.
     WHEN 2. ls_excel-bank_ctry   = ls_raw-value.
     WHEN 3. ls_excel-bank_key    = ls_raw-value.
     WHEN 4. ls_excel-bank_acct   = ls_raw-value.
     WHEN 5. ls_excel-acct_holder = ls_raw-value.
   ENDCASE.
   IF ls_raw-col = 5.
     APPEND ls_excel TO lt_excel.
     CLEAR ls_excel.
   ENDIF.
 ENDLOOP.
*----------------------------------------------------------------------
* MAIN LOOP: Call BAPI for each row
*----------------------------------------------------------------------
 LOOP AT lt_excel INTO ls_excel.
   CLEAR: BUSINESSPARTNER_1,
          BANKDETAILID,
          BANKDETAILDATA_1,
          RETURN5.
*----------------------------------------------------------------------
* Fill your variables
*----------------------------------------------------------------------
   BUSINESSPARTNER_1 = ls_excel-bp_number.
   BANKDETAILDATA_1-bank_ctry   = ls_excel-bank_ctry.
   BANKDETAILDATA_1-bank_key    = ls_excel-bank_key.
   BANKDETAILDATA_1-bank_acct   = ls_excel-bank_acct.
   BANKDETAILDATA_1-accountholder = ls_excel-acct_holder.
*----------------------------------------------------------------------
* Call BAPI
*----------------------------------------------------------------------
CALL FUNCTION 'BAPI_BUPA_BANKDETAIL_ADD'
  EXPORTING
    businesspartner       = BUSINESSPARTNER_1
   BANKDETAILID          = BANKDETAILID
    bankdetaildata        = BANKDETAILDATA_1
* IMPORTING
*   BANKDETAILIDOUT       =
 TABLES
   RETURN                = RETURN5
          .
*----------------------------------------------------------------------
* Output Messages
*----------------------------------------------------------------------

   clear : wa_tab.
     if RETURN5[] is INITIAL.
     move : BUSINESSPARTNER_1 to wa_tab-kunnr,
             'Created'        to wa_tab-remark.
      append wa_tab to i_tab.
   else.

   LOOP AT RETURN5 INTO ls_return.
*     WRITE: / BUSINESSPARTNER_1,
*              ls_return-type,
*              ls_return-message.
     move : BUSINESSPARTNER_1 to wa_tab-kunnr,
            LS_RETURN-MESSAGE to wa_tab-remark.
            append wa_tab to i_tab.
   ENDLOOP.
   endif.
*----------------------------------------------------------------------
* Commit
*----------------------------------------------------------------------
   READ TABLE RETURN5 INTO ls_return WITH KEY type = 'E'.
   IF sy-subrc = 0.
     CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

   ELSE.
     CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
       EXPORTING wait = 'X'.
   ENDIF.
 ENDLOOP.

 loop at i_tab into wa_tab.
 write : wa_tab-kunnr, 25 wa_tab-remark.
 skip .
 endloop.
*WRITE: / '--- Upload Completed ---'.
