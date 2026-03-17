@AbapCatalog.sqlViewName: 'ZV_PP06'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PP06 Cube(Cube)'
@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZC_PP06_S_PEN
  as select from ZDD_PP06_S_PEN
{
  ManufacturingOrder,
  ManufacturingOrderItem,
  ManufacturingOrderType,
  OrderIsReleased,
  IsMarkedForDeletion,
  Product,
  IsCompletelyDelivered,
  ReservationItem,
  Reservation,
  Plant,
  StorageLocation,
  Product_1,
  GoodsMovementType,
  GoodsMovementIsAllowed,
  EntryUnit,
  //@Aggregation.exception: #SUM
  @Aggregation.default: #SUM
  sum (ResvnItmRequiredQtyInBaseUnit) as ResvnItmRequiredQtyInBaseUnit,
  ReservationItemIsFinallyIssued,
  //@Aggregation.exception: #SUM
  @Aggregation.default: #SUM
  sum (ResvnItmWithdrawnQtyInBaseUnit) as ResvnItmWithdrawnQtyInBaseUnit,
  ResvnItmWithdrawnAmtInCCCrcy,
  BaseUnit,
  CompanyCodeCurrency,
  OrderIsMarkedForDeletion,
  OrderIsTechnicallyCompleted,
  Material,
  MfgOrderActualStartDate,
  MfgOrderActualStartTime,
  MfgOrderScheduledStartDate,
  MfgOrderScheduledStartTime,
  /SAP/1_MANUFAC_XUXM6N_CATEGORY,
  /SAP/1_MANUFACTURINGORDERTYPE,
  /SAP/1_PRODUCTIONPLANT,
  //@Aggregation.exception: #SUM 
  @Aggregation.default: #SUM
  sum (PendingQuantity) as PendingQuantity,
  //@Aggregation.exception: #SUM
  @Aggregation.default: #SUM
  sum (MovingAveragePrice) as MovingAveragePrice,
  //@Aggregation.exception: #SUM
  @Aggregation.default: #SUM
  sum (PendingValue) as PendingValue,
  /* Associations */
  _BaseUnit,
  _Currency,
  _EntryUnit,
  _GoodsMovementType,
  _MfgOrder,
  _MfgOrderType,
  _Plant,
  _Product,
  _Product_1,
  _ReservationDocumentHeader,
  _StorageLocation
}
where PendingQuantity > 0
group by
    ManufacturingOrder,
    ManufacturingOrderItem,
    ManufacturingOrderType,
    OrderIsReleased,
    IsMarkedForDeletion,
    Product,
    IsCompletelyDelivered,
    ReservationItem,
    Reservation,
    Plant,
    StorageLocation,
    Product_1,
    GoodsMovementType,
    GoodsMovementIsAllowed,
    EntryUnit,
    ReservationItemIsFinallyIssued,
    ResvnItmWithdrawnAmtInCCCrcy,
    BaseUnit,
    CompanyCodeCurrency,
    OrderIsMarkedForDeletion,
    OrderIsTechnicallyCompleted,
    Material,
    MfgOrderActualStartDate,
    MfgOrderActualStartTime,
    MfgOrderScheduledStartDate,
    MfgOrderScheduledStartTime,
    /SAP/1_MANUFAC_XUXM6N_CATEGORY,
    /SAP/1_MANUFACTURINGORDERTYPE,
    /SAP/1_PRODUCTIONPLANT
   

