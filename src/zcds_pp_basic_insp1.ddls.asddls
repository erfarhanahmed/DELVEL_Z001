
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'basic ins'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true


//   define view entity ZCDS_PP_BASIC_INSP1
//  as select distinct from I_ManufacturingOrder        as mo
//    inner join I_InspectionLot          as il
//   on  mo.ManufacturingOrder = il.ManufacturingOrder //and
//    inner join I_Product                as pr
//        on mo.Material = pr.Product
//   inner join I_SalesOrder            as so
//        on mo.SalesOrder = so.SalesOrder 
//    inner join I_SalesOrderItem         as soi
//        on mo.SalesOrder = soi.SalesOrder and
//           mo.SalesOrderItem = soi.SalesOrderItem
//    inner join I_SalesDocumentScheduleLine as sl
//        on mo.SalesOrder = sl.SalesDocument
//       and mo.SalesOrderItem = sl.SalesDocumentItem

   define view entity ZCDS_PP_BASIC_INSP1
  as select distinct from I_SalesOrderItem         as soi
   left outer join ZCDS_INSP_SO as mo
        on soi.SalesOrder = mo.SalesOrder and
           soi.SalesOrderItem = mo.SalesOrderItem
   inner join I_SalesOrder            as so
        on soi.SalesOrder = so.SalesOrder 
    inner join I_SalesDocumentScheduleLine as sl
        on soi.SalesOrder = sl.SalesDocument
       and soi.SalesOrderItem = sl.SalesDocumentItem

{
    /* ----------- Manufacturing Order fields ----------- */
    key soi.SalesOrder          as SalesOrderHeader,
    key soi.SalesOrderItem,
   
    mo.ManufacturingOrder,
    mo.SalesOrder,
//    mo.SalesOrderItem,
    mo.MfgOrderConfirmedEndDate,
    mo.ZBRAND,

    /* ----------- Inspection Lot fields ----------- */
    mo.InspectionLot,
    mo.Material,
    mo.InspectionLotOrigin,
    mo.ManufacturingOrder as manuf,
    mo.MatlDocLatestPostgDate,
    mo.InspLotIsStockPostingCompleted,

    /* ----------- Product fields ----------- */
    mo.Product,
    mo.Brand,

    /* ----------- Sales Order Header ----------- */
   
    so.SalesOrganization,
    so.DistributionChannel,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    so.TotalNetAmount,  
   
    so.SoldToParty,

    /* ----------- Sales Order Item fields ----------- */
//    soi.SalesOrderItem,
    soi.CommittedDeliveryDate,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    soi.NetPriceAmount,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    soi.NetAmount,
      soi.TransactionCurrency,
    /* ----------- Schedule Line fields ----------- */
    sl.SalesDocument,
    sl.SalesDocumentItem,
    sl.ScheduleLine, 
    sl.DeliveryDate,
    substring( sl.DeliveryDate, 1, 4) as Delivery_year ,
    substring( sl.DeliveryDate, 5, 2) as Del_month ,
   /* ----------- Difference b etween Delivery Date and Posting Date ----------- */
cast( dats_days_between( mo.MatlDocLatestPostgDate, sl.DeliveryDate ) as abap.int4 ) as DayDifference



}
