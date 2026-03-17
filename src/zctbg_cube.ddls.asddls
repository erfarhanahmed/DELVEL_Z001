
@AbapCatalog.sqlViewName: 'ZCTBG_CUBE1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CTBG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define view ZCTBG_CUBE with parameters
@Consumption.defaultValue: 'B'

    P_ExchangeRateType : kurst,
    @Consumption.defaultValue: 'INR'
    P_DisplayCurrency  : vdm_v_display_currency
//    P_CurrentDate      : abap.dats
   as select from ZI_CTBG(P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency ) as a
//   P_CurrentDate:$parameters.P_CurrentDate)   as a 
   inner join ZI_CUSTOM_PRODUCT_V1 as b on a.SalesOrder = b.SalesOrder
                                     and a.SalesOrderItem = b.SalesOrderItem
                                     and a.Product = b.Product
{
key a.SalesOrder,
    key a.SalesOrderItem,
    key a.Product,
    SalesOffice,
    SalesOrderType,
    SalesOrderItemCategory,
    SalesOrderDate,
     BillingDocumentDate,
     @DefaultAggregation: #SUM
cast( DaysFromSalesOrder as abap.int4 ) as DaysFromSalesOrder,

            @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity,
        @Semantics.unitOfMeasure: true      
      OrderQuantityUnit,
      @DefaultAggregation: #SUM
      NetAmount_2,
        TransactionCurrency,
//         @DefaultAggregation: #SUM
         @EndUserText.label: '0-10'
       @DefaultAggregation: #SUM

cast(
  case
    when DaysFromSalesOrder between 0 and 10
    then DaysFromSalesOrder
    else 0
  end as abap.int4
) as Days_0_10,
@DefaultAggregation: #SUM
@EndUserText.label: '11-20'
//  @EndUserText.label: '0-10 Days'
  cast(
    case
      when a.DaysFromSalesOrder between 11 and 20
      then DaysFromSalesOrder
      else 0
    end as abap.int4
  ) as CNT_11_20,

@DefaultAggregation: #SUM
@EndUserText.label: '21-30'
cast(
  case
    when DaysFromSalesOrder between 21 and 30
    then DaysFromSalesOrder
    else 0
  end as abap.int4
) as Days_20_30,

@DefaultAggregation: #SUM
@EndUserText.label: '31 Above'
cast(
  case
    when DaysFromSalesOrder > 30
    then DaysFromSalesOrder
    else 0
  end as abap.int4
) as Days_30_Above,


       

    b.ProductName,
       b.Product_type,
        b.Moc,
       b.ZBrand,
       b.ZSize ,
       b.Series,
       b.BOM
     
     }
where OrderQuantityUnit = 'NOS'
