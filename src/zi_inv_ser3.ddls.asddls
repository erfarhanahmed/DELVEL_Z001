@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Service'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_SER3 as select distinct from I_BillingDocItemAnalytics as a
left outer join vbrk as c on a.BillingDocument = c.vbeln
left outer join ZI_FINAL_SER as b on a.BillingDocument = b.BillingDocument and a.BillingDocumentItem = b.BillingDocumentItem
left outer join  ZI_INV_ZSER2  as d on d.BillingDocument = a.BillingDocument and d.BillingDocumentItem = a.BillingDocumentItem
{
    key a.BillingDocument,
    key a.BillingDocumentItem,
        c.spart as Division,
    c.vkorg as SalesOrganization,
    c.vtweg as DistributionChannel,
    a.Product as Product,
    a.TransactionCurrency,
   a.PriceDetnExchangeRate as exchangerate,
    a.SalesDocumentType,
    a.BillingDocumentType,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   b. AccessValue_WithDiscount,
    @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'Disc'
    b.AccessValue_WithDiscount_INR,
    
    
    
     d.assessiblevalue,
//    ZDIS_Value,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//    AccessibleValue,
//  @Semantics.currencyCode: true
cast('INR' as abap.cuky) as Disc,     
 @Semantics.amount.currencyCode: 'Disc'
      
d.AssessibleValue_with_inr,

cast(
    case 
        when b.AccessValue_WithDiscount > 0 
            then b.AccessValue_WithDiscount
        else 
            d.assessiblevalue
    end 
as abap.dec(15,2)) as AssessibleValue1,

@DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'Disc' // Note: Ensure 'Disc' is a valid currency field/variable
cast(
    case 
        when b.AccessValue_WithDiscount_INR > 0 
            then b.AccessValue_WithDiscount_INR
        else 
           d.AssessibleValue_with_inr
    end 
as abap.dec(15,2)) as AssessibleValueINR
 
}
