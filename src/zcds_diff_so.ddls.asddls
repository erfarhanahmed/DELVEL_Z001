@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sale order diff'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_DIFF_SO as select from ZCDS_DIFF
{
     
       key SalesOrderHeader,
         ManufacturingOrder,
       MfgOrderConfirmedEndDate,
//       ZBRAND,
//       InspectionLot,
//       Material,
//       InspectionLotOrigin,
//       manuf,
//       MatlDocLatestPostgDate,
//       InspLotIsStockPostingCompleted,
//       Product,
//       Brand,
//       SalesOrderHeader,
//       SalesOrganization,
//       DistributionChannel,
//       SoldToParty,
//       SalesOrderItem,
//       CommittedDeliveryDate,
//       SalesDocument,
//       SalesDocumentItem,
//       ScheduleLine,
//       DeliveryDate,
//       Delivery_year,
//       Del_month,
       DayDifference,
       Percentage 
}
where Percentage = 0
