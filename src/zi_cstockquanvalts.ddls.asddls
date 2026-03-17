@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for CSTOCKQUANVALTS'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view entity ZI_CSTOCKQUANVALTS
  with parameters
    P_DisplayCurrency : abap.cuky,
    P_PeriodType      : abap.char(1),
    P_StartDate       : abap.dats,
    P_EndDate         : abap.dats,
    P_PrevStartDate   : abap.dats,
    P_PrevEndDate     : abap.dats

  as select from C_StockQuantityValueTimeSeries(
                 P_DisplayCurrency: $parameters.P_DisplayCurrency,
                 P_StartDate      : $parameters.P_StartDate,
                 P_EndDate        : $parameters.P_EndDate,
                 P_PeriodType     : $parameters.P_PeriodType
                 ) as Curr
{
  key cast( 'C' as abap.char(1) )  as PeriodFlag,

  key Curr.EndDate,
  key Curr.YearPeriod,
  key Curr.Product,
  key Curr.Plant,
  key Curr.StorageLocation,
  key Curr.Batch,
  key Curr.Supplier,
  key Curr.SDDocument,
  key Curr.SDDocumentItem,
  key Curr.WBSElementInternalID,
  key Curr.Customer,
  key Curr.InventoryStockType,
  key Curr.InventorySpecialStockType,
  key Curr.MaterialBaseUnit,
  key Curr.Currency,
  key Curr.ValuationAreaType,

      Curr.DisplayCurrency,
      Curr.CompanyCode,
      Curr.WBSElement,
      Curr.CalendarYear,
      Curr.YearPeriodName,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Curr.MatlWrhsStkQtyInMatlBaseUnit,

      @Semantics.amount.currencyCode: 'Currency'
      Curr.StockValueInCCCrcy,

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      Curr.StockValueInDisplayCurrency,

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      Curr.StockValueInDisplayCurrencyEnd,

      Curr.MaterialGroup,
      Curr.MaterialGroupName,
      Curr.ProductName,
      Curr.PlantName,
      Curr.StorageLocationName,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( 0 as abap.quan(15,3) ) as PrvMonthQty,

      @Semantics.amount.currencyCode: 'Currency'
      cast( 0 as abap.curr(23,2) ) as PrvMonthAmt
}

union all

select from C_StockQuantityValueTimeSeries(
            P_DisplayCurrency: $parameters.P_DisplayCurrency,
            P_StartDate      : $parameters.P_PrevStartDate,
            P_EndDate        : $parameters.P_PrevEndDate,
            P_PeriodType     : $parameters.P_PeriodType
            ) as Prev
{
  key cast( 'P' as abap.char(1) )       as PeriodFlag,

  key Prev.EndDate,
  key Prev.YearPeriod,
  key Prev.Product,
  key Prev.Plant,
  key Prev.StorageLocation,
  key Prev.Batch,
  key Prev.Supplier,
  key Prev.SDDocument,
  key Prev.SDDocumentItem,
  key Prev.WBSElementInternalID,
  key Prev.Customer,
  key Prev.InventoryStockType,
  key Prev.InventorySpecialStockType,
  key Prev.MaterialBaseUnit,
  key Prev.Currency,
  key Prev.ValuationAreaType,

      Prev.DisplayCurrency,
      Prev.CompanyCode,
      Prev.WBSElement,
      Prev.CalendarYear,
      Prev.YearPeriodName,
      Prev.MatlWrhsStkQtyInMatlBaseUnit,
      Prev.StockValueInCCCrcy,
      Prev.StockValueInDisplayCurrency,
      Prev.StockValueInDisplayCurrencyEnd,
      Prev.MaterialGroup,
      Prev.MaterialGroupName,
      Prev.ProductName,
      Prev.PlantName,
      Prev.StorageLocationName,
      Prev.MatlWrhsStkQtyInMatlBaseUnit as PrvMonthQty,
      Prev.StockValueInCCCrcy           as PrvMonthAmt
};
