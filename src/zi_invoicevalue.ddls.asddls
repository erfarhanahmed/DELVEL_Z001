@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Value'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INVOICEVALUE
 
 as select from    I_BillingDocItemAnalytics as a
 
 
{
     @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BillingDocumentBasicStdVH', element: 'BillingDocument' } } ]
  key a.BillingDocument,
  key a.BillingDocumentItem,
  
 cast( 'INR' as abap.cuky) as Currency,
  cast(
      a.PriceDetnExchangeRate *
      cast( a.ItemNetAmountOfBillingDoc_2 as abap.dec(23,2) )
      as abap.dec(23,2)
  ) as InvoiceAmount

 
    
}
