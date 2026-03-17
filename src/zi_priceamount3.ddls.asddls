@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priceamount3'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_priceamount3 as select from 
 ZI_PRICEAMOUNT1
{
    key SalesDocument,
    key SalesDocumentItem,
    TransactionCurrency,
    Exchangerate,
    ZPFO_Value,
    ZDIS_Value,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    assess,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessibleValue as subtotal1amount,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessValue_WithDiscount,
    @Semantics.amount.currencyCode: 'DisplayCurrency'
//cast( AccessValue_WithDiscount as abap.dec(15,2) )
//*
//cast( Exchangerate as abap.dec(9,6) )
//as AccessValue_WithDiscount_INR,


case
    when Exchangerate > 0
        then
            cast( AccessValue_WithDiscount as abap.dec(15,2) )
            *
            cast( Exchangerate as abap.dec(9,6) )
    else
            cast( AccessValue_WithDiscount as abap.dec(15,2) )
end as AccessValue_WithDiscount_INR,



cast( 'INR' as abap.cuky ) as DisplayCurrency
    
}
