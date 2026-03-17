@AbapCatalog.sqlViewAppendName: 'ZI_EXT2'
@EndUserText.label: 'Sales order item extension'
extend view I_SalesDocumentItemAnalytics with ZI_EXTEND_SALES_ITEM_EXT2
{
    SDI.CTBG_Details,
    SDI.Delivery_Date,
    SDI.CustomerDelivery_Date,
    SDI.Amendment_Reason
    
}
