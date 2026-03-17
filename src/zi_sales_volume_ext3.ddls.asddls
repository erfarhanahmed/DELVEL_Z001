@AbapCatalog.sqlViewAppendName: 'ZI_VL3'
@EndUserText.label: 'Sales volume extension 3'
extend view  I_BillingDocItemAnalytics  with ZI_SALES_VOLUME_EXT3
{
    Item.SalesDocumentType
}
