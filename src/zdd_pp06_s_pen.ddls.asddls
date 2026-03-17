@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DD for Pending quantity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZDD_PP06_S_PEN
  as select from ZZ1_PP06_S              as _a
    inner join   I_ProductValuationBasic as _b on(
      _b.Product = _a.Product_1  and _b.ValuationArea = _a.Plant
    )
{
  _a.ManufacturingOrder,
  _a.ManufacturingOrderItem,
  _a.ManufacturingOrderType,
  _a.OrderIsReleased,
  _a.IsMarkedForDeletion,
  _a.Product,
  _a.IsCompletelyDelivered,
  _a.ReservationItem,
  _a.Reservation,
  _a.Plant,
  _a.StorageLocation,
  _a.Product_1,
  _a.GoodsMovementType,
  _a.GoodsMovementIsAllowed,
  _a.EntryUnit,
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  _a.ResvnItmRequiredQtyInBaseUnit,
  _a.ReservationItemIsFinallyIssued,
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  _a.ResvnItmWithdrawnQtyInBaseUnit,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  _a.ResvnItmWithdrawnAmtInCCCrcy,
  _a.BaseUnit,
  _a.CompanyCodeCurrency,
  _a.OrderIsMarkedForDeletion,
  _a.OrderIsTechnicallyCompleted,
  _a.Material,
  _a.MfgOrderActualStartDate,
  _a.MfgOrderActualStartTime,
  _a.MfgOrderScheduledStartDate,
  _a.MfgOrderScheduledStartTime,
  _a./SAP/1_MANUFAC_XUXM6N_CATEGORY,
  _a./SAP/1_MANUFACTURINGORDERTYPE,
  _a./SAP/1_PRODUCTIONPLANT,
  _a._BaseUnit,
  _a._Currency,
  _a._EntryUnit,
  _a._GoodsMovementType,
  _a._MfgOrder,
  _a._MfgOrderType,
  _a._Plant,
  _a._Product,
  _a._Product_1,
  _a._ReservationDocumentHeader,
  _a._StorageLocation,
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  _a.ResvnItmRequiredQtyInBaseUnit - _a.ResvnItmWithdrawnQtyInBaseUnit as PendingQuantity,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  _b.MovingAveragePrice,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast(
    (
      _a.ResvnItmRequiredQtyInBaseUnit
    - _a.ResvnItmWithdrawnQtyInBaseUnit
    )
   * cast( _b.MovingAveragePrice as abap.dec(16,3) )
   as abap.curr(16,2)
    ) as PendingValue
 
 }
 
