@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual V/S Plan'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_PLAN_VS_ACTUAL as select from ZI_SALES_ACTUAL_AMT1
{
     key SalesOffice,

      @Semantics.calendar.year
       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
       SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
       SalesOrderDateYearMonth,
       TransactionCurrency,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
        sum(SalesActualAmount) as SalesActualAmount
    
}
group by 
 SalesOffice,
SalesOrderDateYear,
SalesOrderDateYearQuarter,
   SalesOrderDateYearMonth,
    TransactionCurrency
       
