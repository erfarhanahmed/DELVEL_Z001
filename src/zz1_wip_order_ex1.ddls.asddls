@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'WIP Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZZ1_WIP_ORDER_EX1 as select from ZZ1_WIP_Order as wip 
inner join I_SalesOrderItem as soi on wip.SalesOrder = soi.SalesOrder
              and wip.SalesOrderItem = soi.SalesOrderItem
{
        key wip.ManufacturingOrder,
        key wip.Product,
        key wip.ProductionPlant,
        key wip.SalesOrder,
        key wip.SalesOrderItem,
         @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
        key wip.MfgOrderPlannedTotalQty,
        key wip.StorageLocation,
        wip.OrderIsReleased,
        wip.OrderIsCreated,
        wip.OrderIsConfirmed,
        wip.OrderIsPartiallyConfirmed,
        wip.OrderIsDelivered,
        wip.OrderIsTechnicallyCompleted,
        wip.OrderIsPartiallyDelivered,
        wip.IsCompletelyDelivered,
        wip.MfgOrderConfirmedEndDate,
         @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
        wip.MfgOrderConfirmedYieldQty,
        wip.ProductionUnit,
        wip.CreationDate,
        wip.ZBRAND,
        wip.ManufacturingOrderType,
        wip.Division,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        wip.NetAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        wip.NetPriceAmount,
        wip.TransactionCurrency,
        wip.SoldToParty,
        wip.VERTICAL,
        wip.ZSERIES,
        wip.ITEM_TYPE,   
        soi.PriceDetnExchangeRate,
@Semantics.amount.currencyCode: 'INRCurrency'
(
    cast( soi.PriceDetnExchangeRate   as abap.dec(9,5) )
  * cast( wip.NetPriceAmount          as abap.dec(15,2) )
  * cast( wip.MfgOrderPlannedTotalQty as abap.dec(13,3) )

)  as NetValueInINR, 
cast( 'INR' as abap.cuky ) as INRCurrency,


//        Reservation,
//        ReservationItem,
//        GoodsMovementType,
        
         /** Calculate Days Difference */
    dats_days_between( wip.CreationDate, $session.system_date ) as DaysOld,

    /** Bucket Field Based on DaysOld */
    case
        when dats_days_between( wip.CreationDate, $session.system_date ) between 0 and 20
            then '01-20'
        when dats_days_between( wip.CreationDate, $session.system_date ) between 21 and 30
            then '21-30'
        when dats_days_between( wip.CreationDate, $session.system_date ) between 31 and 45
            then '31-45'
        else '45+'
    end as AgeBucket
        

}
