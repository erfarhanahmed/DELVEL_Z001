@AbapCatalog.sqlViewName: 'ZACTVSPLAN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual verses plan view basic'
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
                                                                           
@VDM.viewType: #BASIC
@Analytics.dataCategory: #CUBE
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view ZC_ACTUAL_VS_PLAN_VIEW_C
//with parameters     P_ExchangeRateType : kurst,
//    P_DisplayCurrency  : vdm_v_display_currency
as select from ZI_SALES_ORDER_ACTUAL_BASIC1
//(P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
  as item
  right outer join ZI_SALES_PLAN_VIEW1 as head on head.SalesOffice = item.SalesOffice 
  and head.SalesOrderDateYearMonth = item.SalesOrderDateYearMonth
 
{

    key head.SalesOffice,
    case head.SalesOffice
    when 'AF'   then 'African Countries'
    when 'AH'   then 'Ahmedabad'
    when 'AS'   then 'Asia'
    when 'AU'   then 'Australia'
    when 'BR'   then 'Baroda'
    when 'CH'   then 'Chennai'
    when 'CN'   then 'China'
    when 'DL'   then 'Delhi'
    when 'DR'   then 'DelVal Russia'
    when 'DT'   then 'DelVal USA'
    when 'EU'   then 'Europe'
    when 'FE'   then 'Far East'
    when 'HD'   then 'Hyderabad'
    when 'ID'   then 'SEA-Indonesia'
    when 'JP'   then 'SEA-Japan'
    when 'KO'   then 'Kolkata'
    when 'KR'   then 'SEA-S. Korea'
    when 'KZ'   then 'CIS-Kazakhstan'
    when 'LAT'  then 'Latin America'
    when 'MB'   then 'Mumbai'
    when 'ME'   then 'Middle East'
    when 'MY'   then 'SEA-Malaysia'
    when 'NG'   then 'Nagpur'
    when 'OC'   then 'Oceania'
    when 'PH'   then 'SEA-Philippines'
    when 'PN'   then 'Pune'
    when 'SA'   then 'Saudi-KSA'
    when 'SG'   then 'SEA-Singapore'
    when 'SO'   then 'Stock Order'
    when 'ST'   then 'South East Asia'
    when 'SU01' then 'Al Khobar'
    when 'TH'   then 'SEA-Thailand'
    when 'US'   then 'USA'
    when 'US01' then 'Geismar Sales Office'
    when 'US02' then 'Houston Sales Office'
    when 'US03' then 'Arizona Sales Office'
    when 'VN'   then 'SEA-Vietnam'
    when 'MX' then 'Mexico'
    else 'Others'
end as SalesOfficeName,
    
//    item.SalesOrderDateYear,
//    item.SalesOrderDateYearMonth,
   head.SalesOrderDateYear,
    head.SalesOrderDateYearMonth,
    head.SalesOrderDateYearQuarter,
//   key DisplayCurrency,
 
   @Semantics.amount.currencyCode: 'vbrp.waerk'
    @DefaultAggregation: #SUM
    SalesActualAmount,
//     @DefaultAggregation: #SUM
      @Semantics.currencyCode: true
     head.DisplayCurrency,
      item.SalesActualAmount * 100 as ActualPer,
     
     head.SalesPlanAmount
     
    
}
