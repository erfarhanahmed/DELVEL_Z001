@AbapCatalog.sqlViewName: 'ZACT_PLAN'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
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
                                                                           
@VDM.viewType: #BASIC
@Analytics.dataCategory: #CUBE
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view  ZC_SALES_ACTUAL_PLAN as select from ZI_SALES_PLAN_VS_ACTUAL
 as item
  right outer join ZI_SALES_PLAN_AMOUNT1 as head on head.SalesOffice = item.SalesOffice 
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
 
   @Semantics.amount.currencyCode: 'Displaycurrency'
    @DefaultAggregation: #SUM
    item.SalesActualAmount,
//     @DefaultAggregation: #SUM
//      @Semantics.currencyCode: true
     cast('USD' as abap.cuky) as Displaycurrency ,
     
     head.SalesPlanAmount,
     cast(item.SalesActualAmount * 100 as abap.dec(16,2)) as ActualPer,
//@DefaultAggregation: #FORMULA
//@DefaultAggregation: #FORMULA
//case 
//    when head.SalesPlanAmount = '0.00' then cast( '3.00' as abap.curr( 15, 2 ) )
//    else 
//        division(  item.SalesActualAmount * 100  , cast(head.SalesPlanAmount as abap.curr( 15,2 )  ) , 2 )  end as Percentage_FLTP
////        (
//                cast( item.SalesActualAmount as abap.fltp )
//                * cast( 100 as abap.fltp )
//            )
//            / cast( head.SalesPlanAmount as abap.fltp ) 
//                end as Percentage_FLTP

//FLTP_TO_DEC( Percentage_FLTP, 15, 2 )
//    as PercentageofActualvsPlan
    
//       ( ( cast( SalesActualAmount as abap.fltp ) * 100.0 ) 
//        / cast( SalesPlanAmount as abap.fltp ) decimals 2 )
//end as PercentageofActualvsPlan

//case
//    when SalesPlanAmount = 0 
//        then cast( 0 as abap.dec(15,2) )
//
//    else cast(
//            division(
//                cast( SalesActualAmount as abap.dec(15,2) ),
//                cast( SalesPlanAmount   as abap.dec(15,2) ),
//                6
//            ) * 100
//         as abap.dec(15,2) )
//
//end as PercentageofActualvsPlan1
cast( SalesActualAmount as abap.dec(16,2) ) as SalesActualAmount1,
cast( SalesPlanAmount  as abap.dec(16,2) ) as SalesPlanAmount1
}
