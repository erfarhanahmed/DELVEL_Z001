@AbapCatalog.sqlViewName: 'ZCDS_CONSUP'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sale order consuption'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CONSUMPTION as select from ZCDS_PP_INSP
{
     
         key SalesOrderHeader,
      
        key SalesOrderItem,
         ManufacturingOrder,     
        MfgOrderConfirmedEndDate,
        ZBRAND,
        InspectionLot,
        Material,
        InspectionLotOrigin,
        manuf,
        MatlDocLatestPostgDate,
        InspLotIsStockPostingCompleted,
        Product,
        Brand,
          SalesOrder,
//        SalesOrderHeader,
        TotalNetAmount,
        TransactionCurrency,
        SalesOrganization,
        DistributionChannel,
        SoldToParty,
               
@Aggregation.default: #SUM
        NetPriceAmount,     
@Aggregation.default: #SUM
        NetAmount,
        CommittedDeliveryDate,
        SalesDocument,
        SalesDocumentItem,
        ScheduleLine,
        DeliveryDate,
//        Delivery_year,
//        Del_month,
          OTD_Year,
          OTD_Month,
        DayDifference,
//        Percentage,
//@Aggregation.default: #SUM
//          OTD_Achievment,
//        final_per
@Aggregation.default: #SUM
    OTD_Percentage,
    @Aggregation.default: #SUM
    sale_order_Percentage      
}
