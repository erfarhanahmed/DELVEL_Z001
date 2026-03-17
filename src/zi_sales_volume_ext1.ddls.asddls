@AbapCatalog.sqlViewAppendName: 'ZI_VL1'

@EndUserText.label: 'Sales volume extension 1'

extend view  I_BillingDocExtdItemBasic  with  ZI_SALES_VOLUME_EXT1
{
    _SalesDocument.SalesDocumentType
}
