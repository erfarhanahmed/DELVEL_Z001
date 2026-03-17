@AbapCatalog.sqlViewAppendName: 'ZI_VL2'
@EndUserText.label: 'Sales volume extension 2'
extend view  I_BillingDocExtdItem with ZI_SALES_VOLUME_EXT2
{
    I_BillingDocExtdItemBasic.SalesDocumentType
}
