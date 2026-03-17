@AbapCatalog.sqlViewName: 'ZI_SALES1'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actual amount'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_ACTUAL_AMT1 as select from 
ZI_SALES_ACTUAL_AMT as item 
// association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on $projection.TransactionCurrency = 'USD'
association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on SourceCurrency = 'USD'
  and TargetCurrency = 'INR'
    and exchange.ExchangeRateType = 'B'
{
  
  key item.SalesOffice,
  key  SalesOrder,
      _SalesOrder,
      @Semantics.calendar.year
       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
       SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
       SalesOrderDateYearMonth,

//   key DisplayCurrency,
 
      @ObjectModel.foreignKey.association: '_TransactionCurrency'
  item.TransactionCurrency,
  item._TransactionCurrency,
//   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
//   sum(NetAmountInDisplayCurrency)  as SalesActualAmount

@Semantics.amount.currencyCode: 'TransactionCurrency'
case
  when TransactionCurrency = 'USD'
    then item.SalesActualAmount
  else
    case
      when exchange.ExchangeRate is not initial
        then
          cast(
            cast(
              cast( item.SalesActualAmount as abap.dec( 15, 2 ) )
              as abap.decfloat34
            )
            / cast(
                cast( exchange.ExchangeRate as abap.dec( 15, 6 ) )
                as abap.decfloat34
              )
            as abap.dec( 15, 2 )
          )
      else
        item.SalesActualAmount
    end
end as SalesActualAmount,
//cast(
//    case 
//        when item.TransactionCurrency = 'USD'
//            then cast( item.SalesActualAmount as abap.dec(15,2) )
//
//        when exchange.ExchangeRate is not initial
//            then
//                round(
//                    cast( item.SalesActualAmount as abap.dec(15,2) )
//                    * cast( exchange.ExchangeRate as abap.dec(9,6) ),
//                    2
//                )
//
//        else
//            cast( item.SalesActualAmount as abap.dec(15,2) )
//    end
//as abap.dec(17,2) )
//as SalesActualAmount,

exchange.ExchangeRate
}
where item.SalesOffice = 'AU' or
 item.SalesOffice = 'AF' or 
  item.SalesOffice = 'AS' or 
item.SalesOffice = 'BR' or
item.SalesOffice = 'CN' or 
item.SalesOffice = 'DR' or
item.SalesOffice = 'DT' or
item.SalesOffice = 'EU' or
item.SalesOffice = 'FE' or 
item.SalesOffice = 'ID' or 
item.SalesOffice = 'JP' or 
item.SalesOffice = 'KR' or 
item.SalesOffice = 'KZ' or 
item.SalesOffice = 'LAT' or 
item.SalesOffice = 'ME' or
item.SalesOffice = 'MX' or
item.SalesOffice = 'MY' or 
item.SalesOffice = 'NG' or item.SalesOffice = 'OC' or item.SalesOffice = 'PH' or 
item.SalesOffice = 'SA' or
item.SalesOffice = 'SG' or 
item.SalesOffice = 'SO' or 
item.SalesOffice = 'ST' or 
item.SalesOffice = 'TH' or 
item.SalesOffice = 'US' or 
item.SalesOffice = 'US01' or 
item.SalesOffice = 'US02' or 
item.SalesOffice = 'US03' ;

