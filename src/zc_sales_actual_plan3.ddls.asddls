@AbapCatalog.sqlViewName: 'ZACT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]

@EndUserText.label: 'Actaulpls'
@Metadata.ignorePropagatedAnnotations: true
define  view ZC_SALES_ACTUAL_PLAN3 as select from ZC_SALES_ACTUAL_PLAN1 as item
{
   
    key item.SalesOffice,
        SalesOfficeName,
         @Semantics.calendar.year
    item.SalesOrderDateYear,
    @Semantics.calendar.yearMonth
    item.SalesOrderDateYearMonth,
    @Semantics.calendar.yearQuarter
    SalesOrderDateYearQuarter,
     @Semantics.systemDate.createdAt: true
cast(
    concat( item.SalesOrderDateYearMonth, '01' )
    as abap.dats
) as SalesCreationDate,
    
//   key DisplayCurrency,
 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
    SalesActualAmount,
    
      @Semantics.currencyCode: true
     Displaycurrency,
//     @DefaultAggregation: #SUM
//     Salesplanamount1,
    
     ActualPer
//     @EndUserText.label: 'Actual Percentage'
//@DefaultAggregation: #SUM
//cast(CalculatedPercentage * 100 as abap.dec(13, 2 )) as Percentageofactualsplan
}
