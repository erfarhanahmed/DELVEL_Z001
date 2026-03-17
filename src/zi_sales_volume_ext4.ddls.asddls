@AbapCatalog.sqlViewAppendName: 'ZI_VL4'
@EndUserText.label: 'Sales volume extension 4'
extend view I_BillingDocumentItemCube with ZI_SALES_VOLUME_EXT4
{
    Item.SalesDocumentType as SalesOrderType
}
