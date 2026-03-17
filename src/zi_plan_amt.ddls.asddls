@AbapCatalog.sqlViewName: 'ZPLAN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant amount Cds View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLAN_AMT as select from
 ZC_ACTUAL_VS_PLAN_VIEW_COM as a
 association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on $projection.SalesPlanCurrency = exchange.SourceCurrency 
  and TargetCurrency = 'INR'
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
                   case 
    when SalesPlanCurrency = 'USD'
        then a.SalesPlanAmount
    else
        case 
            when exchange.ExchangeRate is not initial
                then a.SalesPlanAmount * exchange.ExchangeRate
            else
                a.SalesPlanAmount
        end
end as SalesPlanAmount
//    cast( 'INR' as abap.cuky ) as DisplayCurrency
//naga
}
where SalesOrganization = '1000'
