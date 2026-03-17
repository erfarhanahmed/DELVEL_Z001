@AbapCatalog.sqlViewName: 'ZCUSTOM_BILLING'
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
define view ZI_CUSTOM_BILLING_V2 
with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
 as select from I_BillingDocumentItemCube(
              P_ExchangeRateType : $parameters.P_ExchangeRateType,
              P_DisplayCurrency  : $parameters.P_DisplayCurrency )
    as d


  inner join 
//   I_SalesOrderItem  as b on b.SalesOrder = d.SalesDocument and b.SalesOrderItem = d.SalesDocumentItem
    I_SalesDocumentItem  as b on b.SalesDocument = d.SalesDocument and b.SalesDocumentItem = d.SalesDocumentItem
      inner join I_SalesDocument as c on c.SalesDocument = b.SalesDocument
//inner join i_productitemcube as c on c.salesorder
inner  join I_Product as a on a.Product =  b.Product
{
   key  b.SalesDocument as SalesOrder,
   key b.SalesDocumentItem as  SalesOrderItem,
   key  a.Product as Product,
        c.SalesDocumentType,
        c.DistributionChannel,
        c.OrganizationDivision as Division,
        c.SalesOrganization,
     a.material_type as Product_type,
    a.MOC as Moc,
    a.ZBRAND as ZBrand,
    a.zsize as ZSize ,
   a.ZSERIES as Series,
   a.bom as BOM,
   d.StorageLocation,
//   d.StorageLocationName
case 
    when d.StorageLocation like 'K%' 
        then concat('Kapurhol ', d.StorageLocationName)
    else
        concat('Shirwal-', d.StorageLocationName)
end as StorageLocationName

  
}
where c.SalesOrganization = '1000' and 
 not (
        c.SalesDocumentType      = 'ZOR'
    and c.OrganizationDivision           = '30'
    and c.SalesOrganization   = '1000'
    and c.DistributionChannel = '10'
);
