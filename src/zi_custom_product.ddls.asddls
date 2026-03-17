@AbapCatalog.sqlViewName: 'ZV_CUST_PROD'
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
                                      #SEARCHABLE_ENTITY,
                                      #ANALYTICAL_DIMENSION
                                      ]
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true
//@Metadata.ignorePropagatedAnnotations: true
//define view ZI_CUSTOM_PRODUCT as select from I_SalesOrderItem  as b
define view ZI_CUSTOM_PRODUCT as select from I_SalesDocumentItem  as b
//inner join i_productitemcube as c on c.salesorder
// inner join I_SalesOrder as c on c.SalesOrder = b.SalesOrder
inner  join I_Product as a on a.Product =  b.Product 
inner join I_ProductText as c on b.Product = c.Product and c.Language = 'E'
{
   key  b.SalesDocument as SalesOrder,
   key b.SalesDocumentItem as  SalesOrderItem,
   key  a.Product as Product,
      c.ProductName,
     a.material_type as Product_type,
    a.MOC as Moc,
    a.ZBRAND as ZBrand,
    a.zsize as ZSize ,
   a.ZSERIES as Series,
   a.bom as BOM
   
  
//     key  Product as Product,
//     material_type as Product_type,
//    MOC as Moc,
//    ZBRAND as ZBrand,
//    zsize as ZSize ,
//    ZSERIES as Series,
//    bom as BOM
    
   
}
where b.BaseUnit = 'NOS'
