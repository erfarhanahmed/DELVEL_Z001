@AbapCatalog.sqlViewName: 'ZSALESORDERBASIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order basic'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_ORDER_ACTUAL_BASIC1
//with parameters
//    P_ExchangeRateType : kurst,
//    P_DisplayCurrency  : vdm_v_display_currency
 as select from ZI_SALES_ORDER_ACTUAL_BASIC  
  as item

{
    
       key SalesOffice,
     @Semantics.calendar.year
   key SalesOrderDateYear,
   @Semantics.calendar.yearMonth
   key SalesOrderDateYearMonth,
  @Semantics.calendar.yearQuarter
   key SalesOrderDateYearQuarter,
///  key DisplayCurrency,
 
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
    SalesActualAmount,
    
      @Semantics.currencyCode: true
    cast( 'INR' as abap.cuky ) as DisplayCurrency
}
