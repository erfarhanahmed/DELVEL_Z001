@AbapCatalog.sqlViewName: 'ZI_PENDING1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending Sales Orders'
@Metadata.ignorePropagatedAnnotations: true
//}
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
                                      
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE                                 
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define  view ZI_PENDING_SALES_ORDER1
with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
 
 as select  from    ZI_PENDING_SALES_ORDER(P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency)
 as SDIA
 inner join ZI_EXCHANGE_RATE
(
        P_ExchangeRateType: $parameters.P_ExchangeRateType,
        P_DisplayCurrency:  $parameters.P_DisplayCurrency
     )                                          as SD on SD.SalesOrder = SDIA.SalesOrder
                                         and SD.SalesOrderItem = SDIA.SalesOrderItem
                                          and SD.Product = SDIA.Product
 left outer join ZI_PENDING_P13 as d on SDIA.SalesOrder = d.SalesDocument and SDIA.SalesOrderItem = d.SalesDocumentItem
 {
 key SDIA.SalesOrder,
 key SDIA.SalesOrderItem,
 key SDIA.Product,
 SalesOrderType,
 SalesOrderItemCategory,
 SalesOrderItemType,
 IsReturnsItem,
 CreatedByUser,
 CreatedByUserName,
  @Semantics.systemDate.createdAt: true
 CreationDate,
 
 CreationTime,
 @Semantics.calendar.year
 CreationDateYear,
 @Semantics.calendar.yearQuarter
 CreationDateYearQuarter ,
  @Semantics.calendar.yearMonth
 CreationDateYearMonth,
 @Semantics.systemDate.lastChangedAt: true
 LastChangeDate,
  @Semantics.calendar.year
 SalesOrderDateYear,
 @Semantics.calendar.yearQuarter
 SalesOrderDateYearQuarter,
 @Semantics.calendar.yearMonth
 SalesOrderDateYearMonth,
 SalesOrganization,
 DistributionChannel,
 OrganizationDivision,
 SalesGroup,
 SalesOffice,
 Division,
 PartnerCompany,
 OriginallyRequestedMaterial,
 MaterialByCustomer,
 InternationalArticleNumber,
 ProductHierarchyNode,
 ProductCatalog,
MaterialSubstitutionReason,
ProductGroup,
AdditionalMaterialGroup1,
AdditionalMaterialGroup2,
AdditionalMaterialGroup3,
AdditionalMaterialGroup4,
AdditionalMaterialGroup5,
Plant,
 @Semantics.text: true
ProductionPlantName,
ProductionPlant,
 @Semantics.text: true
StorageLocation,
 @Semantics.text: true
StorageLocationName,
ProductConfiguration,
MainItemPricingRefProduct,
BillOfMaterial,
PropagatePrftbltySgmt2BOM,
CostDeterminationIsRequired,
SoldToParty,
SoldToPartyClassification,
SoldToPartyName,
ShipToParty,
ShipToPartyName,
PayerParty,
PayerPartyName,
BillToParty,
BillToPartyName,
SalesEmployee,
SalesEmployeeName,
ResponsibleEmployee ,
ResponsibleEmployeeName,
AdditionalCustomerGroup1 ,   
AdditionalCustomerGroup2,    
AdditionalCustomerGroup3,   
AdditionalCustomerGroup4,   
AdditionalCustomerGroup5,


CreditControlArea,
CustomerRebateAgreement,
SalesOrderDate,
SDDocumentReason,
SDDocumentCollectiveNumber,
CustomerPurchaseOrderType   ,
CustomerPurchaseOrderDate,
CustomerPurchaseOrderSuplmnt,
CustomerPurchaseOrderSupplemnt  ,
SalesOrderItemText,
PurchaseOrderByCustomer,
UnderlyingPurchaseOrderItem,
OpenReqdDelivQtyInBaseUnit,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
   
SDIA.OrderQuantity,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
ConfdDelivQtyInOrderQtyUnit ,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
TargetDelivQtyInOrderQtyUnit,
// @DefaultAggregation: #SUM
  @Semantics.unitOfMeasure: true
SDIA.OrderQuantityUnit,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
ConfdDeliveryQtyInBaseUnit ,
@Semantics.unitOfMeasure: true
BaseUnit,
OrderToBaseQuantityDnmntr   ,
OrderToBaseQuantityNmrtr,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
SD.TargetQuantity,
@Semantics.unitOfMeasure: true
TargetQuantityUnit,
TargetToBaseQuantityDnmntr,
TargetToBaseQuantityNmrtr,
  @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemGrossWeight,

      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
//
      @Semantics.unitOfMeasure: true
//      @ObjectModel.foreignKey.association: '_ItemWeightUnit'
      ItemWeightUnit,
//      _ItemWeightUnit,

//ItemVolume,

//ItemVolumeUnit,
ServicesRenderedDate,
SalesDistrict,
SalesDeal,
SalesDealDescription,
SalesPromotion,
RetailPromotion,
CustomerGroup,
SalesDocumentRjcnReason,
ItemOrderProbabilityInPercent,
//OrderQuantityUnitDcmls,

 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'

TotalNetAmount,
SalesOrderCondition,
 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
NetAmount_2,
@Semantics.currencyCode: true
SDIA.TransactionCurrency,
@Semantics.currencyCode: true
SDIA.DisplayCurrency,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
NetAmountInDisplayCurrency,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
IncomingSalesOrdersNetAmount,
//IncomingSalesOrdersQuantity,
//IncomingSalesOrdersNetAmtInDC,
//NumberOfIncomingSlsOrderItems,
//OpnSOForOrdReltdInvcsNetAmount,
//OpnSOForOrdReltdInvcsNetAmtDC,
//OpnSlsOrdsForDelivAmtInDspCrcy,
//OpenConfdDelivQtyInBaseUnit,
//OpnSlsOrdsForInvcPlansNetAmtDC,
//NumberOfOpenSalesOrderItems,
PricingDate,
ExchangeRateDate,
PriceDetnExchangeRate,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
SDIA.NetPriceAmount,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
NetPriceQuantity,
@Semantics.unitOfMeasure: true
NetPriceQuantityUnit,
StatisticalValueControl,
StatisticalValue,

//Subtotal1Amount,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
CostAmount,
//Subtotal2Amount,
//Subtotal3Amount,
//Subtotal4Amount,
//Subtotal5Amount,
//Subtotal6Amount,
RequestedDeliveryDate,
ShippingCondition,
  CompleteDeliveryIsDefined,
  DeliveryBlockReason,
  ShippingPoint,
  ShippingType,
  SDIA.InventorySpecialStockType,
  DeliveryPriority,
  Route,
  SDIA.DeliveryDateQuantityIsFixed,
  SDIA.PartialDeliveryIsAllowed,
  SDIA.MaxNmbrOfPartialDelivery,
   UnlimitedOverdeliveryIsAllowed,
   SDIA.OverdelivTolrtdLmtRatioInPct,
   SDIA.UnderdelivTolrtdLmtRatioInPct,
   MinDeliveryQtyInBaseUnit,
   SDIA.IncotermsClassification,
   IncotermsTransferLocation,
   IncotermsLocation1,
   IncotermsLocation2,
   IncotermsVersion,
   
   OpenDeliveryLeadingUnitCode,
   ItemIsDeliveryRelevant,
   BillingCompanyCode,
   HeaderBillingBlockReason,
   BillingDocumentDate,
   ItemIsBillingRelevant,
   ItemBillingBlockReason   ,
   BillingPlan,
   CustomerPaymentTerms,
   PaymentMethod,
   FixedValueDate,
   AdditionalValueDays,
   CustomerProject,
   ExchangeRateType,
   CostCenterBusinessArea,
   SDIA.CostCenter,
   @Semantics.text: true
   ControllingArea,
   
   ControllingAreaName,
   FiscalYear,
   FiscalPeriod,
   SDIA.CustomerAccountAssignmentGroup,
   BusinessArea,
   ProfitCenter,
   
   WBSElementInternalID,
   WBSElementExternalID,
   OrderID,
   ControllingObject,
   ProfitabilitySegment_2,
   OriginSDDocument,
   OriginSDDocumentItem,
  ReferenceSDDocument,
  ReferenceSDDocumentItem,
  ReferenceSDDocumentCategory,
   HigherLevelItem,
   BusinessSolutionOrder,
    OverallSDProcessStatus,
   OverallPurchaseConfStatus,
   OverallSDDocumentRejectionSts,
   TotalBlockStatus,
   OverallDelivConfStatus,
   OverallTotalDeliveryStatus,
   OverallDeliveryStatus,
    OverallDeliveryBlockStatus,
  OverallOrdReltdBillgStatus,
  OverallBillingBlockStatus,
  OverallTotalSDDocRefStatus,
  OverallSDDocReferenceStatus,
  
  TotalCreditCheckStatus,
  MaxDocValueCreditCheckStatus,
  PaymentTermCreditCheckStatus,
  FinDocCreditCheckStatus,
  ExprtInsurCreditCheckStatus,
  PaytAuthsnCreditCheckSts,
  CentralCreditCheckStatus,
  CentralCreditChkTechErrSts,
  HdrGeneralIncompletionStatus,
  OverallPricingIncompletionSts,
  HeaderDelivIncompletionStatus,
  HeaderBillgIncompletionStatus,
  OvrlItmGeneralIncompletionSts,
  OvrlItmBillingIncompletionSts,
  OvrlItmDelivIncompletionSts,
  SDProcessStatus,
  DeliveryConfirmationStatus    ,
  TotalDeliveryStatus,
  PurchaseConfirmationStatus,
  DeliveryStatus,
  DeliveryBlockStatus   ,
  OrderRelatedBillingStatus,
  BillingBlockStatus,
  ItemGeneralIncompletionStatus,
  ItemBillingIncompletionStatus    ,
  PricingIncompletionStatus ,
  SDDocumentRejectionStatus,
  ItemDeliveryIncompletionStatus,
  TotalSDDocReferenceStatus,
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

CTBG_Details,
Amendment_Reason,
CustomerDelivery_Date,
Delivery_Date,
LD_From_Date,
LD_Percentage_Week,
LD_Percentage_Max,
LDRequired,
@Semantics.text: true
Project_Name,
@Semantics.text: true
ProjectOwner_Name,
@Semantics.text: true
ProductName,
Product_type,
Moc,
ZBrand,
ZSize ,
Series,
BOM,
 @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
SD.OpenDeliveryOrderQuantity,
@DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TargetCurrency'
  @EndUserText.label: 'LatestExchangerate'
 SD.LatestExchangeRate as LatestExchangeRate,
   SD.ExchangeRateValidFrom,
   @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
   SD.NetPriceAmount as LatestNetPriceamount,
   @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
SD.OrderQuantity as LatestOrderQuantity,

SD.OrderQuantityUnit as LatestOrderQuantityUnit,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'TargetCurrency'
  SD.LatestSalesOrderAmount  as SalesOrderamountasonDate,

 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'TargetCurrency'
SD.LatestSalesOrderAmount as Order_Board_Value_as_on_Date,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
SD.OrderNetValue as OrderItemNetValue,
SD.TargetCurrency as TargetCurrency,
  @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'TargetCurrency'
 SDIA.TaxAmount * SD.LatestExchangeRate  as TaxAmount,
  @DefaultAggregation: #SUM
    @Semantics.amount.currencyCode: 'TargetCurrency'
cast(
    case
        when SD.LatestExchangeRate > 1
            then
                cast( SD.LatestExchangeRate as abap.dec(9,5) ) *
                cast( SD.OpenDeliveryOrderQuantity as abap.dec(13,3) ) *
                cast( d.AssessbaleValuePerUnit as abap.dec(13,2) )
        else
                cast( SD.OpenDeliveryOrderQuantity as abap.dec(13,3) ) *
                cast( d.AssessbaleValuePerUnit as abap.dec(13,2) )
    end
as abap.dec(15,2)) as AssessibleValueInInr,
@Semantics.currencyCode: true
cast( 'INR' as abap.cuky ) as Disc,
 @DefaultAggregation: #SUM
 @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
cast(
    cast( SD.OpenDeliveryOrderQuantity as abap.dec(13,3) ) *
    cast( d.AssessbaleValuePerUnit as abap.dec(13,2) )
as abap.dec(15,2)) as Assessiblevalue
 
    
}  
  where (
    SalesOrderType = 'ZESS'
    or SalesOrderType = 'ZEXP'
    or SalesOrderType = 'ZDEX'
    or SalesOrderType = 'ZOR'
    or SalesOrderType = 'ZSER'
    or SalesOrderType = 'ZRE'
    or SalesOrderType = 'ZERO'
    or SalesOrderType = 'ZESP'
)
and not (
    SalesOrderType = 'ZSER' 
    and SDIA.Product = 'OTHER SERVICES'
)
and SalesOffice <> 'SO'
and SalesOrganization = '1000'
and SalesDocumentRjcnReason = ' '
