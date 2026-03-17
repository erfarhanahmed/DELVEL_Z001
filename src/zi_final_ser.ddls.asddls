@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_FINAL_SER as select from ZI_INV_PRICEAMOUNT2
{
    
    
    
     key BillingDocument,
    key BillingDocumentItem,
    TransactionCurrency,
    exchangerate,
    Division,
    SalesOrganization,
    DistributionChannel,
    SalesDocumentType,
    BillingDocumentType,
    ZPFO_Value,
    ZDIS_Value,
//    AccessibleValue,
     DisplayCurrency as Disc,
    @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'TransactionCurrency'
    Subtotal1Amount, 
    @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessValue_WithDiscount,
    @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessValue_WithDiscount_INR
}
