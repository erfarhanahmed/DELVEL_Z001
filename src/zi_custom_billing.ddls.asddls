@AbapCatalog.sqlViewName: 'ZV_CUST_BILL'
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
//define view ZI_CUSTOM_BILLING as select from    I_SalesOrderItem  as b
define view ZI_CUSTOM_BILLING as select from    I_SalesDocumentItem  as b
//      inner join I_SalesOrder as c on c.SalesOrder = b.SalesOrder
      inner join I_SalesDocument  as c on c.SalesDocument = b.SalesDocument
//inner join i_productitemcube as c on c.salesorder
inner  join I_Product as a on a.Product =  b.Product
{
   key  b.SalesDocument as SalesOrder,
   key b.SalesDocumentItem as  SalesOrderItem,
   key  b.Product as Product,
        c.SalesDocumentType,
        c.DistributionChannel,
        c.OrganizationDivision as Division,
        c.SalesOrganization,
     a.material_type as Product_type,
    a.MOC as Moc,
    a.ZBRAND as ZBrand,
    a.zsize as ZSize ,
   a.ZSERIES as Series,
   a.bom as BOM
  
}
where not (
        c.SalesDocumentType      = 'ZOR'
    and c.OrganizationDivision           = '30'
    and c.SalesOrganization   = '1000'
    and c.DistributionChannel = '10'
);
