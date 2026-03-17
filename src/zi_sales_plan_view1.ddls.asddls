@AbapCatalog.sqlViewName: 'ZSALESPLAN1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_PLAN_VIEW1 as select from ZI_SALES_PLAN_VIEW
{
       key SalesOffice,
       key SalesOrderDateYearMonth,
           SalesOrderDateYear,
           SalesOrderDateYearQuarter,
          DisplayCurrency,
        sum(SalesPlanAmount) as SalesPlanAmount
} group by
SalesOffice,SalesOrderDateYearMonth,
SalesOrderDateYear,
           SalesOrderDateYearQuarter,
           DisplayCurrency
           

