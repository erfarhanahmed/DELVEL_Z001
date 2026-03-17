@AbapCatalog.sqlViewName: 'ZACTVSPLAN_QUA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual verses plan view composite'
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
define view ZC_SALES_VS_PLAN_QUARTER as select from 
ZC_ACTUAL_VS_PLAN_VIEW_C1  as item
{
    
      key SalesOffice,
      key SalesOfficeName,
         @Semantics.calendar.year
    item.SalesOrderDateYear,
//    @Semantics.calendar.yearMonth
//    item.SalesOrderDateYearMonth,
    @Semantics.calendar.yearQuarter
    SalesOrderDateYearQuarter,
//   key DisplayCurrency,
 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
    sum(SalesActualAmount) as SalesActualAmount,
    
      @Semantics.currencyCode: true
     DisplayCurrency,
     @DefaultAggregation: #SUM
     sum(SalesPlanAmount) as SalesPlanAmount
}
group by 
SalesOffice,
   SalesOfficeName,
   SalesOrderDateYear,
   SalesOrderDateYearQuarter,
    DisplayCurrency
   
