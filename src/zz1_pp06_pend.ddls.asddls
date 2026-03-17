@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZZ1_PP06_pend as select from ZZ1_PP06_S
  association [0..1] to I_ProductValuationBasic as _I_ProductValuationBasic
    on  _I_ProductValuationBasic.Product = ZZ1_PP06_S.Product_1
{
  key ZZ1_PP06_S.Product_1                                  as Product,

  /* --- Unit (mandatory for QUAN fields) --- */
  ZZ1_PP06_S.BaseUnit                                       as BaseUnit,

  /* --- Quantities --- */
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  ZZ1_PP06_S.ResvnItmRequiredQtyInBaseUnit                  as RequiredQtyInBaseUnit,

  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  ZZ1_PP06_S.ResvnItmWithdrawnQtyInBaseUnit                 as WithdrawnQtyInBaseUnit,

  /* --- Pending Qty = Required - Withdrawn --- */
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  cast(
      cast( ZZ1_PP06_S.ResvnItmRequiredQtyInBaseUnit  as abap.dec( 15, 3 ) )
    - cast( ZZ1_PP06_S.ResvnItmWithdrawnQtyInBaseUnit as abap.dec( 15, 3 ) )
    as abap.dec( 15, 3 )
  )                                                         as PendingQtyInBaseUnit,

  /* --- Moving Avg Price as DEC (NO COALESCE, NO CURR EXPRESSION) --- */
  cast(
    case
      when _I_ProductValuationBasic.MovingAveragePrice is null
        then 0
      else
        cast( _I_ProductValuationBasic.MovingAveragePrice as abap.dec( 15, 2 ) )
    end
    as abap.dec( 15, 2 )
  )                                                         as MovingAveragePriceDec,

  /* --- Pending Value = (Required - Withdrawn) * Price --- */
  cast(
    (
        ( cast( ZZ1_PP06_S.ResvnItmRequiredQtyInBaseUnit  as abap.dec( 15, 3 ) )
        - cast( ZZ1_PP06_S.ResvnItmWithdrawnQtyInBaseUnit as abap.dec( 15, 3 ) ) )
      *
        ( case
            when _I_ProductValuationBasic.MovingAveragePrice is null
              then 0
            else
              cast( _I_ProductValuationBasic.MovingAveragePrice as abap.dec( 15, 2 ) )
          end
        )
    )
    as abap.dec( 23, 2 )
  )                                                         as PendingQtyValue,

  _I_ProductValuationBasic
}
