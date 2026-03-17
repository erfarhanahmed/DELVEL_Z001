class ZZ1_NEW_SETAPPROVALREQUESTREAS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SD_APM_SET_APPROVAL_REASON .
protected section.
private section.
ENDCLASS.



CLASS ZZ1_NEW_SETAPPROVALREQUESTREAS IMPLEMENTATION.


  method IF_SD_APM_SET_APPROVAL_REASON~SET_APPROVAL_REASON.

"" condition added by naga for idoc sales order
*IF sy-uname NE 'ALEUSER' OR sy-tcode NE 'BD87' or sy-tcode ne 'WE19'.

       data(lt_sales) = salesdocumentitem.
*       data lt_xvbkd type STANDARD BLE OF vbkd.

       delete lt_sales WHERE  netamount is  NOT INITIAL.
      DATA: lt_xvbap TYPE TABLE OF vbap,
      lt_xvbkd TYPE TABLE OF vbkd.



DATA: lt_vbap TYPE TABLE OF vbap.
DATA: lt_vbkd TYPE TABLE OF vbkd.
FIELD-SYMBOLS: <ft_xvbap> TYPE ANY TABLE,
               <ft_xvbkd> TYPE any TABLE.
* The names of these internal tables are usually XVBAP and XVBKD in program SAPMV45A.
ASSIGN ('(SAPMV45A)XVBAP[]') TO <ft_xvbap>.
ASSIGN ('(SAPMV45A)XVBKD[]') TO <ft_xvbkd>.


IF <ft_xvbap> IS ASSIGNED.
  lt_vbap = <ft_xvbap>.

ENDIF.

IF <ft_xvbkd> IS ASSIGNED.
  lt_vbkd = <ft_xvbkd>.
*  lt_vbkd1 = <ft_xvbkd>.
ENDIF.
*DELETE lt_vbap WHERE netpr is NOT INITIAL.

*DELETE lt_vbkd WHERE kurrf is NOT INITIAL.
*DELETE lt_vbkd1 WHERE bstdk is NOT INITIAL.
LOOP  at lt_vbap INTO DATA(ls_vbap).
  if ls_vbap-netpr is NOT INITIAL ." and ls_vbap-ntgew  is NOT INITIAL
*   and ls_vbap-brgew  is NOT INITIAL
*   and  ls_vbap-custdeldate is NOT INITIAL and ls_vbap-zmrp_date  is NOT INITIAL
*    and ls_vbap-zexp_mrp_date1 is NOT INITIAL.
    DELETE lt_vbap INDEX sy-tabix.
    ENDIF.
  ENDLOOP.
  LOOP AT  lt_vbkd INTO DATA(ls_vbkd).
*    if SALESDOCUMENT-transactioncurrency ne 'INR'.
*    IF ls_vbkd-kurrf is NOT INITIAL ."and ls_vbkd-bstdk is NOT INITIAL.
*      DELETE lt_vbkd INDEX sy-tabix.
*     endif.
*     else.
*          if ls_vbkd-bstdk is NOT INITIAL.
*      DELETE lt_vbkd INDEX sy-tabix.
*
**    ENDIF.
*    ENDIF.
*    ENDIF.

  ENDLOOP.



     if SALESDOCUMENT-totalnetamount is NOT  INITIAL and SALESDOCUMENT-totalnetamount ne '0.00'  and lt_sales is  INITIAL
         and lt_vbap is INITIAL. "and lt_vbkd is INITIAL.
   if salesdocument-salesdocumenttype = 'ZEXP'.
    if SALESDOCUMENT-transactioncurrency ne 'INR'.
         IF ls_vbkd-kurrf is NOT INITIAL .
           else.
             return.
           endif .
           endif.
           endif.












    cl_ble_badi_runtime=>if_ble_badi_runtime~open( iv_implementation = 'ZZ1_NEW_SETAPPROVALREQUESTREAS' ).
    TRY.


if salesdocument-sddocumentcategory = 'C'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
   ( salesdocument-salesdocumenttype = 'ZOR' or salesdocument-salesdocumenttype = 'ZASH' or
*  Or salesdocument-salesdocumenttype = 'ZASH'
   salesdocument-salesdocumenttype = 'ZASS' or
   salesdocument-salesdocumenttype = 'ZCER' or
*  salesdocument-salesdocumenttype = 'ZCR' or
  salesdocument-salesdocumenttype = 'ZDC' or
  salesdocument-salesdocumenttype = 'ZDEX' or
*  salesdocument-salesdocumenttype = 'ZDR' or
  salesdocument-salesdocumenttype = 'ZED' or
*  salesdocument-salesdocumenttype = 'ZEDR' or
*  salesdocument-salesdocumenttype = 'ZERO'  or
  salesdocument-salesdocumenttype = 'ZESP'  or
*  salesdocument-salesdocumenttype = 'ZESS'  or
  salesdocument-salesdocumenttype = 'ZEXP'  or
  salesdocument-salesdocumenttype = 'ZFER'  or
  salesdocument-salesdocumenttype = 'ZFEX'  or
*  salesdocument-salesdocumenttype = 'ZFOC'  or
  salesdocument-salesdocumenttype = 'ZFER'  or
  salesdocument-salesdocumenttype = 'ZFRE'  or
*  salesdocument-salesdocumenttype = 'ZIN'  or
*  salesdocument-salesdocumenttype = 'ZLIS'  or
  salesdocument-salesdocumenttype = 'ZOR'  or
*  salesdocument-salesdocumenttype = 'ZQT'  or
  salesdocument-salesdocumenttype = 'ZREP'  or
  salesdocument-salesdocumenttype = 'ZROW'  or
  salesdocument-salesdocumenttype = 'ZSEZ'  or
  salesdocument-salesdocumenttype = 'ZSO'   ) and
   "Internal Key values are available in the Badi (TA and not OR)
*   salesdocument-TOTALNETAMOUNT  le '2000000.00' and
   salesdocument-salesorganization = '1000'.
   salesdocapprovalreason = 'Z001'.


   return.
   ELSEIF  salesdocument-sddocumentcategory = 'H'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
   ( salesdocument-salesdocumenttype = 'ZRE' or
     salesdocument-salesdocumenttype = 'ZERO' or salesdocument-salesdocumenttype = 'ZEDR'  ) and "Internal Key values are available in the Badi (TA and not OR)
*   salesdocument-TOTALNETAMOUNT  gt '2000000.00' and
   salesdocument-salesorganization = '1000'.
   salesdocapprovalreason = 'Z001'.
*
     return.

       ELSEIF  salesdocument-sddocumentcategory = 'K'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
   ( salesdocument-salesdocumenttype = 'ZCR' or
     salesdocument-salesdocumenttype = 'ZSPL' or salesdocument-salesdocumenttype = 'ZSUP'  ) and "Internal Key values are available in the Badi (TA and not OR)
*   salesdocument-TOTALNETAMOUNT  gt '2000000.00' and
   salesdocument-salesorganization = '1000'.
   salesdocapprovalreason = 'Z001'.
*
     return.

         ELSEIF  salesdocument-sddocumentcategory = 'L'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
   ( salesdocument-salesdocumenttype = 'ZSER' or
     salesdocument-salesdocumenttype = 'ZLIS' or salesdocument-salesdocumenttype = 'ZESS'  or
           salesdocument-salesdocumenttype = 'ZDR') and "Internal Key values are available in the Badi (TA and not OR)
*   salesdocument-TOTALNETAMOUNT  gt '2000000.00' and
   salesdocument-salesorganization = '1000'.
   salesdocapprovalreason = 'Z001'.


      ELSEIF  salesdocument-sddocumentcategory = 'I'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
    salesdocument-salesdocumenttype = 'ZFOC'
     and "Internal Key values are available in the Badi (TA and not OR)
*   salesdocument-TOTALNETAMOUNT  gt '2000000.00' and
   salesdocument-salesorganization = '1000'.
   salesdocapprovalreason = 'Z001'.
*
     return.
endif.
*
*"" eoc naga
**if salesdocument-sddocumentcategory = 'H'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZRED'  and "Internal Key values are available in the Badi (TA and not OR)
**   salesdocument-salesorganization = '1100'.
**   salesdocapprovalreason = 'Z010'.
**   return.
**   ENDIF.
**.
**  if salesdocument-sddocumentcategory = 'C'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZO10'  and "Internal Key values are available in the Badi (TA and not OR)
**   salesdocument-salesorganization = '1100'.
**   salesdocapprovalreason = 'Z010'.
**  ENDIF.
**  if salesdocument-sddocumentcategory = 'C'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZO51'  and "Internal Key values are available in the Badi (TA and not OR)
**   salesdocument-salesorganization = '1500'.
**   salesdocapprovalreason = 'Z020'.
**   return.
**  ENDIF.
** if salesdocument-sddocumentcategory = 'C'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZO70'  and "Internal Key values are available in the Badi (TA and not OR)
**   salesdocument-salesorganization = '1500'.
**   salesdocapprovalreason = 'Z020'.
**   return.
**  ENDIF.
**   if salesdocument-sddocumentcategory = 'H'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZREX'  and "Internal Key values are available in the Badi (TA and not OR)
**  salesdocument-salesorganization = '1500'.
**   salesdocapprovalreason = 'Z020'.
**   return.
**  ENDIF.
**     if salesdocument-sddocumentcategory = 'C'  and "Sales Order document category is "C"; Beware Sales Order without charge is "I"
**   salesdocument-salesdocumenttype = 'ZO53'  and "Internal Key values are available in the Badi (TA and not OR)
**  salesdocument-salesorganization = '1500'.
**   salesdocapprovalreason = 'Z020'.
**   return.
**  ENDIF.
**endif.
*** Example 2: All sales quotations containing a customer with a specific customer abc classification
*** shall trigger a workflow by setting approval request reason ZQT1.
**
**    data lv_customerabcclassification type if_cmd_validate_customer=>ty_bp_sales-customerabcclassification.
**    if salesdocument-sddocumentcategory = 'B'. "Sales quotations
***   As the customer abc classification is not availble directly in the importing parameter we need to
***   select the customer classification from released CDS view I_CustomerSalesArea
**      select single customerabcclassification from i_customersalesarea into @lv_customerabcclassification
**         where customer            = @salesdocument-soldtoparty and
**               salesorganization   = @salesdocument-salesorganization and
**               distributionchannel = @salesdocument-distributionchannel and
**               division            = @salesdocument-organizationdivision.
**      if lv_customerabcclassification = 'A'.
**        salesdocapprovalreason = 'ZQT1'.
**        return.
**      endif.
**    endif.
**
*** Example 3: All sales orders with order type “Standard Order”, for which the terms of payment have been changed
*** from a non-initial value shall trigger a workflow by setting approval request reason ZOR2.
*** As you already see here the Example 1 and Example 3 could intersect in conditions.Kindly take care
*** of this in the real implementation.
**
**    data lv_customerpaymentterms type dzterm.
**
**    if  salesdocument-sddocumentcategory = 'C'.  "Sales Orders
**      select single customerpaymentterms from i_salesorder into @lv_customerpaymentterms where salesorder = @salesdocument-salesdocument.
**      if lv_customerpaymentterms is not initial and "Check for non-initial
**         lv_customerpaymentterms ne  salesdocument-customerpaymentterms. "Check for value change
**        salesdocapprovalreason = 'ZOR2'.
**        return.
**      endif.
**    endif.
**
**
*** Example 4: All sales documents of type credit memo request independent of the credit memo request data
*** like credit memo request type, sold-to party, order reason, etc. shall trigger a workflow by setting
*** approval request reason ZCR1.
**if  salesdocument-sddocumentcategory = 'K'.  "Credit Memo request
**   salesdocapprovalreason = 'ZCR1'.
**   return.
**endif.
**
*** Example 5: A sales quotation which is status "not relevant" could be approval relevance because of some changes;
*** like the net amount is decreased signficiantly and the sales manager needs to be made aware of the change.
*** Here we have approval process for 2 scenarios. Either incase the sales quotation net amount is greater than
*** 10000 EUR or 12000 USD (assuming business is done only in these currencies) or incase the the net value
*** reduces by 50%. These cases shall trigger a workflow by setting approval request reason ZQT2 (NetValue related approval)
**
**    data lv_totalnetamount like salesdocument-totalnetamount.
**    if salesdocument-sddocumentcategory = 'B'. "Sales quotations
**      select single totalnetamount from i_salesquotation into @lv_totalnetamount where salesquotation = @salesdocument-salesdocument.
**      if sy-subrc = 0.
**        if lv_totalnetamount > 0.
**          if ( ( lv_totalnetamount - salesdocument-totalnetamount ) / lv_totalnetamount ) * 100 > 50. " Reduced greater than 50%
**            salesdocapprovalreason = 'ZQT2'.
**            return.
**          endif.
**        endif.
**      else. " New Quotation.
**        if  ( salesdocument-totalnetamount > 10000 and salesdocument-transactioncurrency = 'EUR' ) or
**            ( salesdocument-totalnetamount > 12000 and salesdocument-transactioncurrency = 'USD' ).
**          salesdocapprovalreason = 'ZQT2'.
**          return.
**        endif.
**      endif.
**    endif.
*** Example 6: If the flag 'deferpurreqcreation' is set from the parameter 'salesdoccontrolsettings' then the creation
*** of Purchase Requisition will be deferred.
**    if salesdocument-sddocumentcategory = 'C' and
**      salesdocument-salesdocumenttype = 'TA'  and
**      salesdocument-salesorganization = '1010'.
**      salesdoccontrolsettings-deferpurreqncreation = abap_true.
**    endif.
*
*        " ------------------------------
*        " end of payload
*        " ------------------------------
      CATCH BEFORE UNWIND cx_no_check cx_static_check cx_dynamic_check INTO DATA(lx_no_handler).
        cl_ble_badi_runtime=>if_ble_badi_runtime~handle_exception( exception = lx_no_handler caller = me ).
    ENDTRY.
    cl_ble_badi_runtime=>if_ble_badi_runtime~close( ).
endif.
*endif.
  endmethod.
ENDCLASS.
