@AbapCatalog.sqlViewName: 'ZPLAN1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actual amount1'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLAN_AMT1 as select from ZI_PLAN_AMT as a
association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on $projection.SalesPlanCurrency = exchange.SourceCurrency 
  and TargetCurrency = 'USD'
    and exchange.ExchangeRateType = 'B'
{
   
   key SalesOffice,
        SalesPlanPeriod,
//        concat(substring(SalesPlanPeriod, 1, 4), substring(SalesPlanPeriod, 5, 2)) as SalesOrderDateYearMonth,
        
        //   naga 
     @Semantics.calendar.year
     SalesOrderDateYear,
//       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      SalesOrderDateYearMonth,
                   @Semantics.currencyCode: true
                   SalesPlanCurrency,
                  
    @Semantics.amount.currencyCode: 'SalesPlanCurrency'
case
  when SalesPlanCurrency = 'USD'
    then a.SalesPlanAmount
  else
    case
      when exchange.ExchangeRate is not initial
        then
          cast(
            cast(
              cast( a.SalesPlanAmount as abap.dec( 15, 2 ) )
              as abap.decfloat34
            )
            / cast(
                cast( exchange.ExchangeRate as abap.dec( 15, 6 ) )
                as abap.decfloat34
              )
            as abap.dec( 15, 2 )
          )
      else
        a.SalesPlanAmount
    end
end as SalesplanAmount
}

where a.SalesOffice = 'AU' or
SalesOffice = 'AF' or 
SalesOffice = 'AS' or 
SalesOffice = 'BR' or
SalesOffice = 'CN' or 
SalesOffice = 'DR' or
SalesOffice = 'DT' or
SalesOffice = 'EU' or
SalesOffice = 'FE' or 
SalesOffice = 'ID' or 
SalesOffice = 'JP' or 
SalesOffice = 'KR' or 
SalesOffice = 'KZ' or 
SalesOffice = 'LAT' or 
SalesOffice = 'ME' or
SalesOffice = 'MX' or
SalesOffice = 'MY' or 
SalesOffice = 'NG' or SalesOffice = 'OC' or SalesOffice = 'PH' or 
SalesOffice = 'SA' or
SalesOffice = 'SG' or 
SalesOffice = 'SO' or 
SalesOffice = 'ST' or 
SalesOffice = 'TH' or 
SalesOffice = 'US' or 
SalesOffice = 'US01' or 
SalesOffice = 'US02' or 
SalesOffice = 'US03' ;

