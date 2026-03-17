@AbapCatalog.sqlViewName: 'ZINV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View of product custom fields'
//@ObjectModel.: true
//@Analytics:{
//    dataExtraction: {
//        enabled: true,
//        delta.changeDataCapture.automatic: true
//    }
//}
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                     
                                      ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define view ZC_INVOICEVALUE as select from ZI_INVOICEVALUE as a
{
    
    key a.BillingDocument,
  key a.BillingDocumentItem,
  
      Currency,
      @DefaultAggregation: #SUM
     InvoiceAmount
}
