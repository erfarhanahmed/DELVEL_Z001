@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Insepection SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INSP_SO
  as select distinct from I_ManufacturingOrder        as mo
    inner join I_InspectionLot          as il
   on  mo.ManufacturingOrder = il.ManufacturingOrder //and
    inner join I_Product                as pr
        on mo.Material = pr.Product
{
     key mo.ManufacturingOrder,
    mo.SalesOrder,
    mo.SalesOrderItem,
    mo.MfgOrderConfirmedEndDate,
    mo._Product.ZBRAND,

    /* ----------- Inspection Lot fields ----------- */
    il.InspectionLot,
    il.Material,
    il.InspectionLotOrigin,
    il.ManufacturingOrder as manuf,
    il.MatlDocLatestPostgDate,
    il.InspLotIsStockPostingCompleted,

    /* ----------- Product fields ----------- */
    pr.Product,
    pr.Brand
}
