@AbapCatalog.sqlViewName: 'ZCTBG_GR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CTBG'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
define view ZCTBG_GRID
with parameters
  @Consumption.defaultValue: 'B'
  P_ExchangeRateType : kurst,

  @Consumption.defaultValue: 'INR'
  P_DisplayCurrency  : vdm_v_display_currency

as select from ZI_CTBG(
        P_ExchangeRateType: $parameters.P_ExchangeRateType,
        P_DisplayCurrency : $parameters.P_DisplayCurrency
     ) as a
inner join ZI_CUSTOM_PRODUCT_V1 as b
  on a.SalesOrder     = b.SalesOrder
 and a.SalesOrderItem = b.SalesOrderItem
 and a.Product        = b.Product
 //naga
 left outer to one join ZI_LATESTEXCHANGERATE1(
        P_ExchangeRateType: $parameters.P_ExchangeRateType
     )                                         as LER
  on  LER.SourceCurrency = a.TransactionCurrency
  and LER.TargetCurrency = $parameters.P_DisplayCurrency
 //naga
{
  /* Keys */
  key a.SalesOrder,
  key a.SalesOrderItem,
  key a.Product,

  /* Dimensions */
  a.SalesOffice,
  a.SalesOrderType,
  a.SalesOrderItemCategory,
  a.SalesOrderDate,
  a.BillingDocumentDate,
  @Semantics.currencyCode: true
  a.DisplayCurrency,
  /* ===== Aging Bucket (TEXT – Dimension) ===== */
 
  /* ===== Measures ===== */
  @DefaultAggregation: #SUM
  cast( DaysFromSalesOrder as abap.int8 ) as DaysFromSalesOrder,

  @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
  a.OrderQuantity,

  @Semantics.unitOfMeasure: true
  a.OrderQuantityUnit,

  @DefaultAggregation: #SUM
  a.NetAmount_2,
//  a.DisplayCurrency,
  a.TransactionCurrency,

 @EndUserText.label: 'Aging Grid'


cast(
  case
    when DaysFromSalesOrder between 0 and 10 then '0-10'
    when DaysFromSalesOrder between 11 and 20 then '11-20'
    when DaysFromSalesOrder between 21 and 30 then '21-30'
    when DaysFromSalesOrder > 30 then '31 above'
    else 'Unknown'
  end
as abap.char(60) ) as Aging_Grid_Text,

//naga
@EndUserText.label: 'Sales office Group'
cast(
  case
    when SalesOffice = 'PN'
      or SalesOffice = 'MB'
      or SalesOffice = 'AH'
      or SalesOffice = 'DL'
      or SalesOffice = 'KO'
      or SalesOffice = 'CH'
      or SalesOffice = 'HD'
      or SalesOffice = 'SO'
    then 'Domestic Sales Office'

    when SalesOffice = 'AF'
      or SalesOffice = 'AS'
      or SalesOffice = 'AU'
      or SalesOffice = 'BR'
      or SalesOffice = 'CN'
      or SalesOffice = 'DR'
      or SalesOffice = 'EU'
      or SalesOffice = 'FE'
      or SalesOffice = 'ID'
      or SalesOffice = 'JP'
      or SalesOffice = 'KR'
      or SalesOffice = 'KZ'
      or SalesOffice = 'LAT'
      or SalesOffice = 'ME'
      or SalesOffice = 'MX'
      or SalesOffice = 'MY'
      or SalesOffice = 'NG'
      or SalesOffice = 'OC'
      or SalesOffice = 'PH'
      or SalesOffice = 'SA'
      or SalesOffice = 'SG'
      or SalesOffice = 'ST'
      or SalesOffice = 'SU01'
      or SalesOffice = 'TH'
      or SalesOffice = 'US'
      or SalesOffice = 'US01'
      or SalesOffice = 'US02'
      or SalesOffice = 'US03'
      or SalesOffice = 'VN'
      or SalesOffice = 'LA'
    then 'International Sales Office'

    when SalesOffice = 'DT'
    then 'Delaval USA'

    else 'Others'
  end
as abap.char(30)
) as Sales_Office_Group,
LER.ExchangeRate as Exchangerate,
cast(
  case
    when LER.ExchangeRate > 1 then
      cast(
        cast( a.NetAmount_2 as abap.dec(15,2) )
        * cast( LER.ExchangeRate as abap.dec(9,6) )
      as abap.dec(23,2) )
    else
      cast( a.NetAmount_2 as abap.dec(23,2) )
  end
as abap.dec(23,2)
) as NetAmountAsOnDate,

  /* Product attributes */
  b.ProductName,
  b.Product_type,
  b.Moc,
  b.ZBrand,
  b.ZSize,
  b.Series,
  b.BOM
}
where OrderQuantityUnit = 'NOS'
