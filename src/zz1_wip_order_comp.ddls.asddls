@AbapCatalog.sqlViewName: 'ZWIP_COMP'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COMPOSITE VIEW for WIP order'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view ZZ1_WIP_ORDER_COMP as select from ZZ1_WIP_ORDER_BASIC
{
        key ManufacturingOrder,
        key Product,
        key ProductionPlant,
        key SalesOrder,
        key SalesOrderItem,
        @Aggregation.default: #SUM
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
        @Aggregation.default: #SUM
        MfgOrderConfirmedYieldQty,
        ProductionUnit,
        CreationDate,
        ZBRAND,
        ManufacturingOrderType,
        Division,
        @Aggregation.default: #SUM
        NetAmount,
        @Aggregation.default: #SUM
        NetPriceAmount,
         @Aggregation.default: #SUM
        NetValueInINR,
         VERTICAL,
        ZSERIES,
        ITEM_TYPE,
        TransactionCurrency,
        SoldToParty,
//        Reservation,
//        ReservationItem,
//        GoodsMovementType,
        DaysOld,
        AgeBucket
        
}
