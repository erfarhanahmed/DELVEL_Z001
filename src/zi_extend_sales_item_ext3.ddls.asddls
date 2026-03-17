@AbapCatalog.sqlViewAppendName: 'ZI_EXT3'
@EndUserText.label: 'EXtended View for Sales Order'
extend view I_SalesOrderItemCube with ZI_EXTEND_SALES_ITEM_EXT3
{
    SDIA.CTBG_Details,
    SDIA.CustomerDelivery_Date,
    SDIA.Delivery_Date,
    SDIA.Amendment_Reason
}
