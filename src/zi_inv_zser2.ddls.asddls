@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice services'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_ZSER2 as select from 
 ZI_INV_ZSER1 as a
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
    ZPR0_Value as assessiblevalue,
//    ZDIS_Value,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//    AccessibleValue,
   DisplayCurrency,
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      case
    when exchangerate > 0
        then cast( ZPR0_Value as abap.dec(15,2) )
             * cast( exchangerate as abap.dec(9,6) )
    else
        cast( ZPR0_Value as abap.dec(15,2) )
end as AssessibleValue_with_inr

    
}
