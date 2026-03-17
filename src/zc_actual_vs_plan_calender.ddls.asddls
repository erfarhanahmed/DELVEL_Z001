@AbapCatalog.sqlViewName: 'ZACTUALVSPLANCAL'
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
define view ZC_ACTUAL_VS_PLAN_CALENDER 
    as select from ZC_ACTUAL_VS_PLAN_VIEW_C
//(P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
  as item
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
   @Semantics.amount.currencyCode: 'DisplayCurrency'
   
    SalesActualAmount,
    
      @Semantics.currencyCode: true
     DisplayCurrency,
     @DefaultAggregation: #SUM
     SalesPlanAmount,
   @EndUserText.label: 'Actual Percentage'
@DefaultAggregation: #SUM
division(ActualPer ,SalesPlanAmount ,2) as Percentageactualvsplan
}
    
where item.SalesOffice = 'PN' or
item.SalesOffice = 'MB '  or
item.SalesOffice = 'AH' or
item.SalesOffice = 'DL' or 
item.SalesOffice = 'KO' or 
item.SalesOffice = 'CH' or
item.SalesOffice = 'HD'
//and 
//item.SalesOffice = 'AU' and 
//item.SalesOffice = 'BR' and 
//item.SalesOffice = 'CN' and 
//item.SalesOffice = 'DR' and 
//item.SalesOffice = 'DT' and 
//item.SalesOffice = 'EU' and 
//item.SalesOffice = 'FE' and 
//item.SalesOffice = 'ID' and 
//item.SalesOffice = 'JP' and 
//item.SalesOffice = 'KR' and 
//item.SalesOffice = 'KZ' and 
//item.SalesOffice = 'LAT' and 
//item.SalesOffice = 'ME' and 
//item.SalesOffice = 'MX' and 
//item.SalesOffice = 'MY' and 
//item.SalesOffice = 'NG' and item.SalesOffice = 'OC' and item.SalesOffice = 'PH' and 
//item.SalesOffice = 'SA' and 
//item.SalesOffice = 'SG' and 
//item.SalesOffice = 'SO' and 
//item.SalesOffice = 'ST' and 
//item.SalesOffice = 'TH' and 
//item.SalesOffice = 'US' and 
//item.SalesOffice = 'US01' and 
//item.SalesOffice = 'US02' and 
//item.SalesOffice = 'US03' ;
//
//    

    
