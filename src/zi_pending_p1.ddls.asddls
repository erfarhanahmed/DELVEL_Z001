@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending sales order price'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PENDING_P1 as select from 
 ZI_PENDING_P  as a
{
  key a.SalesDocument,
    key a.SalesDocumentItem,
      a.TransactionCurrency,
//   b.kursk as Exchangerate,
  a.SalesDocumentType,
//    
   a. ZPFO_Value,
    a.ZDIS_Value,
      a.ZPR0_VALUE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.AccessibleValue as assess,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Subtotal1Amount as AccessibleValuesub ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    
    
    case
    when a.AccessibleValue > 0
        then cast( a.Subtotal1Amount as abap.dec(15,2) )
             +  cast( a.AccessibleValue as abap.dec(15,2) )
    else
        cast( a.Subtotal1Amount as abap.dec(15,2) )
             + cast( a.AccessibleValue as abap.dec(15,2) )
end as AccessValue_WithDiscount

//cast(
//      cast( a.ZPR0_VALUE as abap.dec(15,2) ) +
//      (
//        cast( a.ZPR0_VALUE as abap.dec(15,2) ) *
//        cast( a.AccessibleValue as abap.dec(15,2) ) / 100
//      )
//as abap.dec(15,2)) as AccessValue_WithDiscount

//case
//    when a.AccessibleValue > 0
//        then cast(
//                cast( a.ZPR0_VALUE as abap.dec(15,2) ) +
//                (
//                  cast( a.ZPR0_VALUE as abap.dec(15,2) ) *
//                  cast( a.AccessibleValue as abap.dec(15,2) ) / 100
//                )
//             as abap.dec(15,2) )
//    else
//        cast( a.ZPR0_VALUE as abap.dec(15,2) )
//end as AccessValue_WithDiscount


} 

    
group by 
    a.SalesDocument,
     a.SalesDocumentItem,
      a.TransactionCurrency,
//   b.kursk ,
  a.SalesDocumentType,
//    
   a. ZPFO_Value,
    a.ZDIS_Value,
      a.AccessibleValue,
      a.ZPR0_VALUE,
    a.Subtotal1Amount
