@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_PRICEAMOUNT1 as select from ZI_INV_PRICEAMOUNT as a
{
    
    key BillingDocument,
    key BillingDocumentItem,
    SalesDocumentType,
    BillingDocumentType,
     Division,
    SalesOrganization,
    DistributionChannel,  
    TransactionCurrency,
    PriceDetnExchangeRate as exchangerate,
    Product,
    ZPFO_Value,
    ZDIS_Value,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessibleValue,
    DisplayCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    Subtotal1Amount,
    case
    when a.AccessibleValue > 0
        then cast( a.Subtotal1Amount as abap.dec(15,2) )
             +  cast( a.AccessibleValue as abap.dec(15,2) )
    else
        cast( a.Subtotal1Amount as abap.dec(15,2) )
             + cast( a.AccessibleValue as abap.dec(15,2) )
end as AccessValue_WithDiscount
}
where
 

   not (
        SalesDocumentType      = 'ZOR'
    and Division = '30'
    and SalesOrganization     = '1000'
    and DistributionChannel   = '10'
  )
  
  and not (
        SalesDocumentType = 'ZSER'
    and Product = 'OTHER SERVICES'
)
  ;
