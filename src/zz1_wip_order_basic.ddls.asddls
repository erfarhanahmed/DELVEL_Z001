
@AbapCatalog.sqlViewName: 'ZWIP_BASIC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basie view WIP order'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view ZZ1_WIP_ORDER_BASIC as select from ZZ1_WIP_ORDER_EX1
{
        key ManufacturingOrder,
        key Product,
        key ProductionPlant,
        key SalesOrder,
        key SalesOrderItem,
        key MfgOrderPlannedTotalQty,
        key StorageLocation,
        OrderIsReleased,
        OrderIsCreated,
        OrderIsConfirmed,
        OrderIsPartiallyConfirmed,
        OrderIsDelivered,
        OrderIsTechnicallyCompleted,
        OrderIsPartiallyDelivered,
        IsCompletelyDelivered,
        MfgOrderConfirmedEndDate,
        MfgOrderConfirmedYieldQty,
        ProductionUnit,
        CreationDate,
        ZBRAND,
        ManufacturingOrderType,
        Division,
        NetAmount,
        NetPriceAmount,
        VERTICAL,
        ZSERIES,
        ITEM_TYPE,
//        NetValueInINR,
@Semantics.amount.currencyCode: 'TransactionCurrency'
cast(
    round( NetValueInINR, 2 )
as abap.dec(15,2)) as NetValueInINR,
        TransactionCurrency,
        SoldToParty,
//        Reservation,
//        ReservationItem,
//        GoodsMovementType,
        DaysOld,
        AgeBucket
}
