@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending sales order price'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PENDING_P12 as select distinct from  I_SalesDocumentItemAnalytics as b
left outer join ZI_PENDING_P1 as a on a.SalesDocument = b.SalesDocument and b.SalesDocumentItem = a.SalesDocumentItem
 left outer join  ZI_ZSER1 as c   on b.SalesDocument = c.SalesDocument
  and b.SalesDocumentItem = c.SalesDocumentItem
{ 
key b.SalesDocument,
    key b.SalesDocumentItem,
      b.TransactionCurrency,
        @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
cast(case when b.OrderQuantity > 0 then b.OrderQuantity 
     else b.TargetQuantity end as abap.quan(15,3)) as Quantity,
 
  b.OrderQuantityUnit,
//   b.kursk as Exchangerate,
  a.SalesDocumentType,
//    
   a. ZPFO_Value,
    a.ZDIS_Value,
      a.ZPR0_VALUE,
     c.ZPR0_VALUE  as zpr0,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   a.assess,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
  a.AccessibleValuesub ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'

a.AccessValue_WithDiscount,
case
    when a.AccessValue_WithDiscount > 0
        then cast( a.AccessValue_WithDiscount as abap.dec(15,2) )
    else
        cast( c.ZPR0_VALUE as abap.dec(15,2) )
end as Final_Assessible_Value

}
group by 
    b.SalesDocument,
     b.SalesDocumentItem,
      b.TransactionCurrency,
//   b.kursk ,
  a.SalesDocumentType,
//    
  b.OrderQuantity,
   a. ZPFO_Value,
    a.ZDIS_Value,
     a.ZPR0_VALUE,
      c.ZPR0_VALUE ,
      a.assess,
      a.AccessibleValuesub ,
    a.AccessValue_WithDiscount,
     b.OrderQuantityUnit,
     b.TargetQuantity
