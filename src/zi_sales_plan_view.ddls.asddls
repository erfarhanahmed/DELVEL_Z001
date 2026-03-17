@AbapCatalog.sqlViewName: 'ZSALESPLAN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_SALES_PLAN_VIEW'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_PLAN_VIEW as select from
 ZC_ACTUAL_VS_PLAN_VIEW_COM
{
    key SalesOffice,
        SalesPlanPeriod,
//        concat(substring(SalesPlanPeriod, 1, 4), substring(SalesPlanPeriod, 5, 2)) as SalesOrderDateYearMonth,
        SalesPlanAmount,
        //   naga 
     @Semantics.calendar.year
     SalesOrderDateYear,
//       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      SalesOrderDateYearMonth,
                   @Semantics.currencyCode: true
    cast( 'INR' as abap.cuky ) as DisplayCurrency
//naga
}
where SalesOrganization = '1000'
