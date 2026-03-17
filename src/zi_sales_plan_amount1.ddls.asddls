@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_PLAN_AMOUNT1 as select from ZI_SALES_PLAN_AMOUNT3 as a
{
    key a.SalesOffice,
       a.SalesPlanPeriod,

     @Semantics.calendar.year
     a.SalesOrderDateYear,

      @Semantics.calendar.yearQuarter
      a.SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      a.SalesOrderDateYearMonth,
//                   @Semantics.currencyCode: true
//                   SalesPlanCurrency,
//    cast( 'INR' as abap.cuky ) as DisplayCurrency

sum(a.SalesPlanAmount) as SalesPlanAmount
//ExchangeRate
//naga
}
group by 
a.SalesOffice,
a.SalesPlanPeriod,
a.SalesOrderDateYear,
a.SalesOrderDateYearQuarter,    
a.SalesOrderDateYearMonth
