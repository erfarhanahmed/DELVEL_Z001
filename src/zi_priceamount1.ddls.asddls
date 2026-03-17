@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRICEAMOUNT1   as select distinct from ZI_PRICEAMOUNT as a
left outer join vbkd as b on a.SalesDocument = b.vbeln

  {
   
    key a.SalesDocument,
    key a.SalesDocumentItem,
      a.TransactionCurrency,
   b.kursk as Exchangerate,
  a.SalesDocumentType,
//    
   a. ZPFO_Value,
    a.ZDIS_Value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.AccessibleValue as assess,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Subtotal1Amount as AccessibleValue  ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
case
    when a.AccessibleValue > 0
        then cast( a.Subtotal1Amount as abap.dec(15,2) )
             +  cast( a.AccessibleValue as abap.dec(15,2) )
    else
        cast( a.Subtotal1Amount as abap.dec(15,2) )
             + cast( a.AccessibleValue as abap.dec(15,2) )
end as AccessValue_WithDiscount
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//  
//  (
//      cast( a.Subtotal1Amount as abap.dec(15,2) ) +
//      cast( a.AccessibleValue as abap.dec(15,2) )
//    ) * cast( a.exchangerate as abap.dec(15,5) )
//      as subtotal_amount_inr   
} 

    
group by 
    a.SalesDocument,
     a.SalesDocumentItem,
      a.TransactionCurrency,
   b.kursk ,
  a.SalesDocumentType,
//    
   a. ZPFO_Value,
    a.ZDIS_Value,
      a.AccessibleValue,
  
    a.Subtotal1Amount
