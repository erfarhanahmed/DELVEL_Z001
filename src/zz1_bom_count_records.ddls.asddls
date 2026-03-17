@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Count records'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZZ1_BOM_COUNT_RECORDS as select from ZZ1_BOM_Inactive
{
  Plant,
  BillOfMaterial,
    BillOfMaterialVariant,
  BillOfMaterialStatus,
  cast(
        case 
            when BillOfMaterialVariant = '01'
             and ( BillOfMaterialStatus = '01' or BillOfMaterialStatus = '02' )
            then 1 
            else 0 
        end 
    as abap.int8 ) as totalbomcount

}

////    cast( sum( case  when BillOfMaterialVariant = '01'
////         and ( BillOfMaterialStatus = '01'
////               or BillOfMaterialStatus = '02' ) 
////    then 1 else 0 end ) as abap.int8 ) as totalbomcount
//    cast( sum( case when BillOfMaterialStatus = '02' and BillOfMaterialVariant = '01'
//    then 1 else 0 end ) as abap.int8 ) as Status02Total

group by Plant,
  BillOfMaterial,
  BillOfMaterialVariant,
  BillOfMaterialStatus;
