@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Sales Rate'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSALES_LATEST_RATE1 
with parameters
  P_ExchangeRateType : kurst,
    P_ValidFrom        : abap.dats
as select from I_ExchangeRate as ER
inner join ZSALES_LATEST_RATE(
    P_ExchangeRateType: $parameters.P_ExchangeRateType,
    P_ValidFrom       : $parameters.P_ValidFrom
) as LD
  on  ER.SourceCurrency            = LD.SourceCurrency
  and ER.TargetCurrency            = LD.TargetCurrency
  and ER.ExchangeRateType          = LD.ExchangeRateType
  and ER.ExchangeRateEffectiveDate = LD.ValidFrom
{
  key ER.SourceCurrency,
  key ER.TargetCurrency,
  key ER.ExchangeRateType,
      ER.ExchangeRate,
      ER.ExchangeRateEffectiveDate as ValidFrom
}
