*&---------------------------------------------------------------------*
*& Report ZMIRO_AUTOMATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMIRO_AUTOMATE.
*DATA: ls_headerdata TYPE bapist01. " Structure for header data
*DATA: lt_itemdata   TYPE TABLE OF bapist02. " Structure for item data
*DATA: lt_accountingdata TYPE TABLE OF bapist04. " Structure for account assignment
*DATA: lt_return       TYPE TABLE OF bapiret2. " Table to hold return messages
* DATA: ls_itemdata TYPE bapist02.
*
*ls_headerdata-invoice_ind = 'X'. " Indicates posting of an invoice/credit memo
*  ls_headerdata-doc_date = sy-datum. " Document Date
*  ls_headerdata-pstng_date = sy-datum. " Posting Date
*  ls_headerdata-comp_code = '1000'. " Company Code
*  ls_headerdata-currency = 'EUR'.  " Currency
*  ls_headerdata-gross_amount = '1190.00'. " Total gross amount of the invoice
*  ls_headerdata-calc_tax_ind = 'X'. " Automatically calculate tax
*  ls_headerdata-pmnttrms = '0001'.  " Payment Terms
*
*
*  ls_itemdata-invoice_doc_item = '000001'. " Item number in the invoice document
*  ls_itemdata-po_number = '4500000191'.  " Purchase Order Number
*  ls_itemdata-po_item = '00010'.      " Purchase Order Item
*  ls_itemdata-item_amount = '1190.00'.  " Amount for the item
*  ls_itemdata-quantity = '10'.         " Quantity
*  ls_itemdata-tax_code = 'V1'.         " Tax Code
*  APPEND ls_itemdata TO lt_itemdata.
*
* CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE'
*    EXPORTING
*      headerdata = ls_headerdata
*    TABLES
*      itemdata   = lt_itemdata
*      return     = lt_return.
*
*   LOOP AT lt_return INTO DATA(ls_return).
*    IF ls_return-type = 'E'. " Error
*      " Handle error
*    ELSEIF ls_return-type = 'S'. " Success
*      " Invoice created successfully, get document number
*      DATA(lv_invoicedocnumber) = ls_return-message_v1.
*      DATA(lv_fiscalyear) = ls_return-message_v2.
*      " Commit the transaction
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*    ENDIF.
*  ENDLOOP.
**DATA:
**  ls_headerdata       TYPE bapi_incinv_create_header,
**  lt_itemdata         TYPE TABLE OF bapi_incinv_create_item,
**  ls_itemdata         TYPE bapi_incinv_create_item,
**  lt_return           TYPE TABLE OF bapiret2,
**  ls_return           TYPE bapiret2,
**  lv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no,
**  lv_fiscalyear       TYPE bapi_incinv_fld-fisc_year,
**  lv_ref_doc_no       TYPE bapi_incinv_create_header-ref_doc_no.
**
***--- Invoice Header Data ---*
*** Fill the header structure with required details.
**ls_headerdata-invoice_ind   = 'X'.                  " Post an invoice
**ls_headerdata-doc_type      = 'RE'.                 " Document type for invoice receipt
**ls_headerdata-doc_date      = sy-datum.             " Document date
**ls_headerdata-pstng_date    = sy-datum.             " Posting date
**ls_headerdata-comp_code     = '1000'.               " Company Code (adjust as needed)
**ls_headerdata-currency      = 'USD'.                " Currency Key (adjust as needed)
**ls_headerdata-gross_amount  = '116.00'.             " Gross amount of the invoice
**ls_headerdata-calc_tax_ind  = 'X'.                  " Calculate tax automatically
**ls_headerdata-pmnttrms      = '0001'.               " Payment Terms
**
*** You must provide a reference document number, like a vendor's invoice number
*** or a generated number, to avoid runtime errors.
**lv_ref_doc_no = 'INV-123456'.
**ls_headerdata-ref_doc_no = lv_ref_doc_no.
**
***--- Invoice Item Data (for a Purchase Order) ---*
*** Populate the item table with purchase order details.
**ls_itemdata-invoice_doc_item = '000001'.            " Sequential item number
**ls_itemdata-po_number        = '4500000001'.        " Your Purchase Order Number
**ls_itemdata-po_item          = '00010'.             " Your PO Item
**ls_itemdata-tax_code         = 'V1'.                " Tax Code
**ls_itemdata-item_amount      = '100.00'.            " Net Item amount
**ls_itemdata-quantity         = '10'.                " Quantity
**ls_itemdata-po_unit          = 'PC'.                " Purchase Order Unit
**
**APPEND ls_itemdata TO lt_itemdata.
**
*** Add more items to lt_itemdata if needed.
**
***--- Call the BAPI to create the invoice ---*
**CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE'
**  EXPORTING
**    headerdata       = ls_headerdata
**  IMPORTING
**    invoicedocnumber = lv_invoicedocnumber
**    fiscalyear       = lv_fiscalyear
**  TABLES
**    itemdata         = lt_itemdata
**    return           = lt_return.
**
***--- Handle BAPI results ---*
*** Check the return table for any errors or messages.
**LOOP AT lt_return INTO ls_return WHERE type = 'E' OR type = 'A'.
**  " An error occurred. Handle the error (e.g., display message).
**  WRITE: / 'Error:', ls_return-message.
**ENDLOOP.
**
*** If no errors, commit the transaction.
**IF lt_return IS INITIAL.
**  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
**    EXPORTING
**      wait = 'X'.
**  WRITE: / 'Invoice', lv_invoicedocnumber, 'created successfully.'.
**ELSE.
**  " Rollback the transaction on error.
**  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
**  WRITE: / 'Invoice creation failed.'.
**ENDIF.

DATA:
  ls_header        TYPE bapi_incinv_create_header,
  lt_item          TYPE TABLE OF bapi_incinv_create_item,
  ls_item          TYPE bapi_incinv_create_item,
  lt_return        TYPE TABLE OF bapiret2,
  ls_return        TYPE bapiret2,
  lv_invoicedoc    TYPE RBKP-belnr, "bapi_incinv_create_header-invoicedocnumber,
  lv_fiscalyear    TYPE rbkp-gjahr. "bapi_incinv_create_header-fiscalyear.
  BREAK-POINT.
* Parameters for the GR document
CONSTANTS:
  gc_gr_doc_num    TYPE mblnr VALUE '5000368316', " Example: Goods Receipt Document Number
  gc_gr_doc_year   TYPE gjahr VALUE '2025',       " Example: Goods Receipt Fiscal Year
  gc_po_num        TYPE ebeln VALUE '1710103372', " Example: Purchase Order Number
  gc_po_item       TYPE ebelp VALUE '00010'.      " Example: Purchase Order Item
*
*
START-OF-SELECTION.

  " 1. Populate header data
  ls_header-invoice_ind   = 'X'.                " 'X' for Invoice (leave initial for Credit Memo)
  ls_header-doc_date      = sy-datum.           " Invoice Date
  ls_header-pstng_date    = sy-datum.           " Posting Date
  ls_header-comp_code     = '1000'.             " Company Code
  ls_header-BUSINESS_PLACE = 'PUNE'.
  ls_header-gross_amount  = '236.00'.           " Gross amount of the invoice
  ls_header-currency      = 'INR'.              " Currency
  ls_header-calc_tax_ind  = 'X'.                " Calculate tax automatically
  ls_header-pmnttrms      = '0001'.             " Payment Terms

  " 2. Populate item data
  CLEAR ls_item.
  ls_item-invoice_doc_item = '0001'.           " Invoice Item Number (can be assigned freely)
  ls_item-po_number        = gc_po_num.        " Purchase Order Number
  ls_item-po_item          = gc_po_item.       " Purchase Order Item
  ls_item-item_amount      = '200.00'.         " Item Amount
  ls_item-quantity         = '1'.             " Quantity
  ls_item-po_unit          = 'NOS'.             " Unit of Measure
  ls_item-tax_code         = 'M4'.             " Tax Code
  ls_item-ref_doc          = gc_gr_doc_num.    " Goods Receipt Document Number
  LS_ITEM-INVOICE_DOC_ITEM = '0002'.
  ls_item-ref_doc_year     = gc_gr_doc_year.   " Goods Receipt Document Year
  ls_item-ref_doc_it       = '0001'.           " Goods Receipt Document Item

  APPEND ls_item TO lt_item.

  " 3. Call the BAPI
  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE'
    EXPORTING
      headerdata     = ls_header
    IMPORTING
      invoicedocnumber = lv_invoicedoc
      fiscalyear       = lv_fiscalyear
    TABLES
      itemdata       = lt_item
      return         = lt_return.

  " 4. Process results and commit/rollback
  READ TABLE lt_return WITH KEY type = 'E' INTO ls_return.
*                                type = 'A' INTO ls_return.
  IF sy-subrc = 0.
    " An error occurred. Roll back the changes.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    WRITE: / 'Invoice creation failed.'.
    LOOP AT lt_return INTO ls_return.
      WRITE: / ls_return-message.
    ENDLOOP.
  ELSE.
    " No errors, commit the changes to the database.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    WRITE: / 'Invoice', lv_invoicedoc, 'created successfully.'.
  ENDIF.
