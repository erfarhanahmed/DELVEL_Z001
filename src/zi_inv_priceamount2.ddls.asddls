@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inv Price amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_PRICEAMOUNT2 as select from ZI_INV_PRICEAMOUNT1
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
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessibleValue,
    
    DisplayCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    Subtotal1Amount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessValue_WithDiscount,
//    
//    cast( AccessValue_WithDiscount as abap.dec(15,2) )
//*
//cast( exchangerate as abap.dec(9,6) )
//as AccessValue_WithDiscount_INR,
case
    when exchangerate > 0
        then cast( AccessValue_WithDiscount as abap.dec(15,2) )
             * cast( exchangerate as abap.dec(9,6) )
    else
        cast( AccessValue_WithDiscount as abap.dec(15,2) )
end as AccessValue_WithDiscount_INR

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


