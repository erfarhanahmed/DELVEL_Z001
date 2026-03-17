@EndUserText.label: 'SupplierData'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #DIMENSION
@ObjectModel.supportedCapabilities: [#CDS_MODELING_DATA_SOURCE]
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_CUSTOMERSALESOFFICE
  as select distinct from kna1    as A
    inner join            ZC_KNVV as B on B.Kunnr = A.kunnr
    inner join            tvkbt   as C on B.vkbur = C.vkbur
     
{
  key  A.kunnr,
       A.name1,
       A.name2,
       B.vkbur,
       C.bezei

}
