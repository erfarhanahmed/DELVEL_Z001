@AbapCatalog.sqlViewName: 'ZINVP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
                                      
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE                                 
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define view ZI_INV_PRICEAMOUNT3 as select from 

ZI_INV_SER3
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
//    ZPFO_Value,
//    ZDIS_Value,
//    AccessibleValue,
cast(0 as abap.dec(15,2)) as   ZPFO_Value,
cast(0 as abap.dec(15,2)) as    ZDIS_Value,
    @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'TransactionCurrency'
  AccessValue_WithDiscount,
      @DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'DisplayCurrency'
   AccessValue_WithDiscount_INR ,
    Disc as Disc,
//    @DefaultAggregation: #SUM
//@Semantics.amount.currencyCode: 'TransactionCurrency'
cast(0 as abap.dec(15,2)) as Subtotal1Amount,
//    @DefaultAggregation: #SUM
//@Semantics.amount.currencyCode: 'TransactionCurrency'
////    AccessValue_WithDiscount as AssessibleValue,
//     AssessibleValue1 as  AssessibleValue,
//    @DefaultAggregation: #SUM
//@Semantics.amount.currencyCode: 'DisplayCurrency'
////  cast( AccessValue_WithDiscount_INR as abap.dec(15,2) ) as AssessiblevalueInINR
//AssessibleValueINR as AssessiblevalueInINR



// Assessible Value
case 
    when BillingDocumentType = 'ZRE' 
      or BillingDocumentType = 'ZERO'
        then - AssessibleValue1
    else AssessibleValue1
end as AssessibleValue,

@DefaultAggregation: #SUM
@Semantics.amount.currencyCode: 'DisplayCurrency'

// Assessible Value in INR
case 
    when BillingDocumentType = 'ZRE' 
      or BillingDocumentType = 'ZERO'
        then - AssessibleValueINR
    else AssessibleValueINR
end as AssessiblevalueInINR

}
where (
      SalesDocumentType = 'ZESS'
   or SalesDocumentType = 'ZOR'
   or SalesDocumentType = 'ZEXP'    
   or SalesDocumentType = 'ZDEX'
   or SalesDocumentType = 'ZSER'
   or SalesDocumentType = 'ZRE'
   or SalesDocumentType = 'ZERO'
   or SalesDocumentType = 'ZESP'
)

/* -------------------------- */
/* Billing type exclusion */
/* -------------------------- */

and BillingDocumentType <> 'ZDC'
and BillingDocumentType <> 'ZS1'
and BillingDocumentType <> 'ZS2'
and BillingDocumentType <> 'ZS4'
and BillingDocumentType <> 'ZS5'
and BillingDocumentType <> 'ZF4'
and BillingDocumentType <> 'ZF5'
and BillingDocumentType <> 'ZF8'
  and SalesOrganization = '1000'

/* -------------------------- */
/* Exclude OTHER SERVICES for ZSER */
/* -------------------------- */

and not (
       SalesDocumentType = 'ZSER'
   and Product = 'OTHER SERVICES'
)

/* -------------------------- */
/* Scrap exclusion */
/* -------------------------- */

and not (
      SalesDocumentType = 'ZOR'
  and SalesOrganization = '1000'
  and DistributionChannel = '10'
  and Division = '30'
)
