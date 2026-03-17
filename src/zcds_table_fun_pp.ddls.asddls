@EndUserText.label: 'Delivery date + 7 days'
define table function ZCDS_DELIV_PLUS7
returns
{
    mandt              : abap.clnt;
   SalesDocument      : abap.numc(10);
    SalesDocumentItem  : abap.numc(6);
    DeliveryDate       : abap.dats;
    DeliveryDatePlus7  : abap.dats;
}
implemented by method zcl_deliv_plus7=>calculate;
