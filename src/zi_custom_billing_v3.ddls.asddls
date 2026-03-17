@AbapCatalog.sqlViewName: 'ZI_CUSTOM'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'BILLING Item Details'
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY,
                                      #ANALYTICAL_DIMENSION
                                      ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true
define view ZI_CUSTOM_BILLING_V3 
 with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
as select distinct from ZI_CUSTOM_BILLING_V2 (

   P_ExchangeRateType : $parameters.P_ExchangeRateType,
      P_DisplayCurrency  : $parameters.P_DisplayCurrency )
{
    
     key SalesOrder as SalesDocument ,
  key  SalesOrderItem as SalesDocumentItem,
   //@AnalyticsDetails.query.axis: #ROWS
   key  Product,
   
        Product_type,
        Moc,
       ZBrand,
       ZSize ,
       Series,
       BOM ,
       StorageLocation ,
       StorageLocationName
}
