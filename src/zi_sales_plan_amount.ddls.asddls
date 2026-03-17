@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan Amount'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_SALES_PLAN_AMOUNT as select from  ZC_ACTUAL_VS_PLAN_VIEW_COM as a
  association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on $projection.SalesPlanCurrency = exchange.SourceCurrency 
  and exchange.TargetCurrency = 'INR'
    and exchange.ExchangeRateType = 'B'
{
 
  key a.SalesOffice,
       a.SalesPlanPeriod,
//        concat(substring(SalesPlanPeriod, 1, 4), substring(SalesPlanPeriod, 5, 2)) as SalesOrderDateYearMonth,
   
        //   naga 
     @Semantics.calendar.year
     a.SalesOrderDateYear,
//       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      a.SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      a.SalesOrderDateYearMonth,
//                   @Semantics.currencyCode: true
                   SalesPlanCurrency,
//    cast( 'INR' as abap.cuky ) as DisplayCurrency
case
    when a.SalesPlanCurrency = 'USD'
        then cast( a.SalesPlanAmount as abap.dec( 23, 2 ) )
    else
        case
            when exchange.ExchangeRate is not null
                then cast( a.SalesPlanAmount as abap.dec( 23, 2 ) )
                     * exchange.ExchangeRate
            else
                cast( a.SalesPlanAmount as abap.dec( 23, 2 ) )
        end
end as SalesPlanAmountInINR,
exchange.ExchangeRate
//naga
}
where SalesOrganization = '1000'
and 
 a.SalesOffice = 'AU' or
 a.SalesOffice = 'AF' or 
 a.SalesOffice = 'AS' or 
a.SalesOffice = 'BR' or
a.SalesOffice = 'CN' or 
a.SalesOffice = 'DR' or
a.SalesOffice = 'DT' or
a.SalesOffice = 'EU' or
a.SalesOffice = 'FE' or 
a.SalesOffice = 'ID' or 
a.SalesOffice = 'JP' or 
a.SalesOffice = 'KR' or 
a.SalesOffice = 'KZ' or 
a.SalesOffice = 'LAT' or 
a.SalesOffice = 'ME' or
a.SalesOffice = 'MX' or
a.SalesOffice = 'MY' or 
a.SalesOffice = 'NG' or a.SalesOffice = 'OC' or a.SalesOffice = 'PH' or 
a.SalesOffice = 'SA' or
a.SalesOffice = 'SG' or 
a.SalesOffice = 'SO' or 
a.SalesOffice = 'ST' or 
a.SalesOffice = 'TH' or 
a.SalesOffice = 'US' or 
a.SalesOffice = 'US01' or 
a.SalesOffice = 'US02' or 
a.SalesOffice = 'US03' ;


    
