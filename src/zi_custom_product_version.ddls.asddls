@AbapCatalog.sqlViewName: 'ZI_MARA'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Composite View for Material custom fields'
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY,
                                      #ANALYTICAL_DIMENSION
                                      ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #DIMENSION
//@Analytics.query: true

define view ZI_CUSTOM_PRODUCT_V1 as select from ZI_CUSTOM_PRODUCT
{
  // @AnalyticsDetails.query.axis: #ROWS
  key SalesOrder ,
  key  SalesOrderItem,
   //@AnalyticsDetails.query.axis: #ROWS
   key  Product,
        ProductName,
        Product_type,
        Moc,
       ZBrand,
       ZSize ,
       Series,
       BOM
    
}
