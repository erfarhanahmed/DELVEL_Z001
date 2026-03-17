@AbapCatalog.sqlViewName: 'ZLATESTRATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Exchange Rate by Currency Pair'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
                                      
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE                                 
@VDM.viewType: #BASIC
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
define view ZI_LATESTEXCHANGERATE1  with parameters
    P_ExchangeRateType : kurst
as select from I_ExchangeRate              as ER
inner join ZI_LatestExchangeRate(
    P_ExchangeRateType: $parameters.P_ExchangeRateType
)                                         as MaxDate
  on  ER.SourceCurrency             = MaxDate.SourceCurrency
  and ER.TargetCurrency             = MaxDate.TargetCurrency
  and ER.ExchangeRateType           = MaxDate.ExchangeRateType
  and ER.ExchangeRateEffectiveDate  = MaxDate.ValidFrom
{
  key ER.SourceCurrency,
  key ER.TargetCurrency,
  key ER.ExchangeRateType,
      ER.ExchangeRate,
      MaxDate.ValidFrom
      
}
