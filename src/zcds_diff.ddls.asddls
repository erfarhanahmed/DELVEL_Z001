@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dffernce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_DIFF as select from ZCDS_PP_BASIC_INSP1
{

key SalesOrderHeader,
 key   SalesOrderItem,
    ManufacturingOrder,
  
   MfgOrderConfirmedEndDate,
   ZBRAND,
   InspectionLot,
   Material,
   InspectionLotOrigin,
   manuf,
   MatlDocLatestPostgDate,
   InspLotIsStockPostingCompleted,
   Product,
   Brand,
   SalesOrder,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   TotalNetAmount,
   TransactionCurrency,
   SalesOrganization,
   DistributionChannel,
   SoldToParty,
     
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    NetPriceAmount,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
     NetAmount,  
   CommittedDeliveryDate,
   SalesDocument,
   SalesDocumentItem,
   ScheduleLine,
   DeliveryDate,
   Delivery_year,
   Del_month,
   DayDifference,
   
//    case
//  when MatlDocLatestPostgDate is null
//    or MatlDocLatestPostgDate = '00000000'
//    then '000'
//  when DayDifference > 7
//    then '000'
//  else '100'
//end 
//
//as Percentage
   

cast(
  case
    when MatlDocLatestPostgDate is null
      or MatlDocLatestPostgDate = '00000000'
      then 0
    when DayDifference > 7
      then 0
    else 100
  end
  as abap.dec(5,2)
) as Percentage

   
  
//       case
//    when   DayDifference > 07.00 then '0%'
//    else '100%'
//end as Percentage




}
