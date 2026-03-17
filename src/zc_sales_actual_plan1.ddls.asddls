@AbapCatalog.sqlViewName: 'ZACT_PLAN1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual V/S Plan'
@Analytics:{
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture.automatic: true
    }
}
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                     
                                      ]
// @ObjectModel.transactionalProcessingEnabled: false
                                                                           
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view  ZC_SALES_ACTUAL_PLAN1 as select from ZC_SALES_ACTUAL_PLAN as item
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
     @DefaultAggregation: #SUM
     SalesPlanAmount,
    
     ActualPer,
     @EndUserText.label: 'Actual Percentage'
@DefaultAggregation: #SUM
division(ActualPer ,SalesPlanAmount1,2) as Percentageactualvsplan
}
