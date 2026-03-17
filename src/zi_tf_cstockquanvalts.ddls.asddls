@EndUserText.label: 'TF: Stock Qty/Value with Previous Month'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZI_TF_CSTOCKQUANVALTS_PM
  with parameters
    P_DisplayCurrency : abap.cuky,
    P_StartDate       : abap.dats,
    P_EndDate         : abap.dats,
    P_PeriodType      : abap.char(1)
returns
{
      /* Client must be first for client-dependent TF */
  key Client                         : abap.clnt;

      /* Keys (same grain as your view) */
  key EndDate                        : abap.dats;
  key YearPeriod                     : abap.char(7);
  key Product                        : abap.char(40);
  key Plant                          : abap.char(4);
  key StorageLocation                : abap.char(4);
  key Batch                          : abap.char(10);
  key Supplier                       : abap.char(10);
  key SDDocument                     : abap.char(10);
  key SDDocumentItem                 : abap.char(6);
  key WBSElementInternalID           : abap.char(24);
  key Customer                       : abap.char(10);
  key InventoryStockType             : abap.char(2);
  key InventorySpecialStockType      : abap.char(2);
  key MaterialBaseUnit               : abap.unit(3);
  key Currency                       : abap.cuky;
  key ValuationAreaType              : abap.char(4);

      DisplayCurrency                : abap.cuky;
      CompanyCode                    : abap.char(4);
      WBSElement                     : abap.char(24);
      CalendarYear                   : abap.char(4);
      YearPeriodName                 : abap.char(30);

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      MatlWrhsStkQtyInMatlBaseUnit   : abap.quan(15,3);

      @Semantics.amount.currencyCode: 'Currency'
      StockValueInCCCrcy             : abap.curr(23,2);

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      StockValueInDisplayCurrency    : abap.curr(23,2);

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      StockValueInDisplayCurrencyEnd : abap.curr(23,2);

      MaterialGroup                  : abap.char(9);
      MaterialGroupName              : abap.char(40);
      ProductName                    : abap.char(40);
      PlantName                      : abap.char(40);
      StorageLocationName            : abap.char(40);

      /* Previous month fields */
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      PrevMatlWrhsStkQty             : abap.quan(15,3);

      @Semantics.amount.currencyCode: 'Currency'
      PrevStockValueInCCCrcy         : abap.curr(23,2);
}
implemented by method
  ZCL_AMDP_CSTOCKQUANVALTS_PM=>GET_DATA;
