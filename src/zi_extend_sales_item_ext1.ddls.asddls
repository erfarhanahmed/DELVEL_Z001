@AbapCatalog.sqlViewAppendName: 'ZI_V_EXT1'
@EndUserText.label: 'Sales order item extension'
extend view I_SalesDocumentItem with ZI_EXTEND_SALES_ITEM_EXT1
{
    vbap.deldate as Delivery_Date,
    vbap.custdeldate as CustomerDelivery_Date,
    vbap.ctbg as CTBG_Details,
    vbap.reason as Amendment_Reason
}
