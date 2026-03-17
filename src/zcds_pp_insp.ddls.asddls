
@AbapCatalog.sqlViewName: 'ZCDS_PP_C'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basie view for Sale order delivery date'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true


define view ZCDS_PP_INSP
  as select distinct from ZCDS_DIFF        as mo
    left outer join ZCDS_DIFF_SO          as il
        on mo.SalesOrderHeader = il.SalesOrderHeader 
//         mo.ManufacturingOrder = il.ManufacturingOrder
    
{
       
          
          key  mo.SalesOrderHeader,
        key  mo.SalesOrderItem,
          mo.ManufacturingOrder,
          mo.MfgOrderConfirmedEndDate,
          mo.ZBRAND,
          mo.InspectionLot,
          mo.Material,
          mo.InspectionLotOrigin,
          mo.manuf,
          mo.MatlDocLatestPostgDate,
          mo.InspLotIsStockPostingCompleted,
          mo.Product,
          mo.Brand,
          mo.SalesOrder,
          mo.TotalNetAmount,
          mo.TransactionCurrency,
          mo.SalesOrganization,
          mo.DistributionChannel,
          mo.SoldToParty,

          mo.NetPriceAmount,
          mo.NetAmount,
          mo.CommittedDeliveryDate,
          mo.SalesDocument,
          mo.SalesDocumentItem,
          mo.ScheduleLine,
          mo.DeliveryDate,
          mo.Delivery_year as OTD_Year,
          mo.Del_month as OTD_Month,
          mo.DayDifference,
          mo.Percentage as OTD_Percentage,
//          il.MfgOrderConfirmedEndDate,
//          il.DayDifference,
//           il.Percentage as sale_order_Percentage
case
  when il.Percentage is null
    then 100
  else il.Percentage
end as sale_order_Percentage

          
}
