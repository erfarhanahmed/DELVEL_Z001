@AbapCatalog.sqlViewName: 'ZVREJAGFIX'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'REJECTION CALCULATION'
@Metadata.ignorePropagatedAnnotations: true
define view ZREJECTION_AGEING_CAL
with parameters
  @Environment.systemField: #CLIENT
  p_client : abap.clnt,
  p_bukrs  : bukrs,
  p_werks  : werks_d,
  p_lgort  : lgort_d
as select from ZREJECTION_AGEING_C_INVAGEDET(
                 p_client: $parameters.p_client,
                 p_bukrs : $parameters.p_bukrs,
                 p_werks : $parameters.p_werks,
                 p_lgort : $parameters.p_lgort
               ) as A
{
  key A.Plant           as Plant,
  key A.StorageLocation as StorageLocation,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays <= 30
            then A.AllocatedAmount /  cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_LT_30,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 31 and 60
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_31_60,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 61 and 90
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_61_90,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 91 and 120
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_91_120,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 121 and 150
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_121_150,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 151 and 180
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_151_180,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 181 and 210
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_181_210,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 211 and 240
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_211_240,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 241 and 270
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_241_270,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 271 and 300
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_271_300,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 301 and 330
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_301_330,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 331 and 365
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_331_365,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 366 and 730
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_366_730,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 731 and 1095
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_731_1095,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 1096 and 1460
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_1096_1460,

  @DefaultAggregation: #SUM
  sum( case when A.AgeDays between 1461 and 1825
            then A.AllocatedAmount / cast( 100000  as abap.decfloat16)
            else 0
       end ) as Qty_1461_1825
}
group by
  A.Plant,
  A.StorageLocation;
