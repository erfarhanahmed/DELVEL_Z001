@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for CSTOCKQUANVALTS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define view entity ZC_CSTOCKQUANVALTS
  with parameters
    P_DisplayCurrency : abap.cuky,
    P_PeriodType      : abap.char(1),
    P_StartDate       : abap.dats,
    P_EndDate         : abap.dats

  as select from C_StockQuantityValueTimeSeries(
                 P_DisplayCurrency: $parameters.P_DisplayCurrency,
                 P_StartDate      : $parameters.P_StartDate,
                 P_EndDate        : $parameters.P_EndDate,
                 P_PeriodType     : $parameters.P_PeriodType
                 ) as Curr
{
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
      @Aggregation.default: #SUM
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Curr.MatlWrhsStkQtyInMatlBaseUnit,
      
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      Curr.StockValueInCCCrcy,
      
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      Curr.StockValueInDisplayCurrency,
      
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      Curr.StockValueInDisplayCurrencyEnd,

      Curr.MaterialGroup,
      Curr.MaterialGroupName,
      Curr.ProductName,
      Curr.PlantName,
      Curr.StorageLocationName
}
