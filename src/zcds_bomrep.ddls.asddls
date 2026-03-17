@AbapCatalog.sqlViewName: 'ZCV_BOMREP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Reports'
@Metadata.ignorePropagatedAnnotations: true

define view zcds_BOMREP as select from  mast as A
    inner join   stko  as B  on B.stlty = 'M' 
                            and B.stlal = A.stlal
                            and B.stlnr = A.stlnr
    left outer join stpo as c on c.stlty = B.stlty
                             and c.stlnr = B.stlnr
                             and c.vgknt = '00000000'
                             and c.vgpzl = '00000000'
                                              
{
   key cast(A.stlnr as char8 preserving type ) as stlnr,
   key B.stlal                                    as stlal,
   key A.matnr                                    as MATNR,
   key B.wrkan                                    as werks,
   key A.stlan                                    as stlan,
      cast ('M' as stlty preserving type)      as stlty,
      B.bmein                               as bmein,
      @Semantics.quantity.unitOfMeasure: 'bmein'
      A.losvn                                    as losvn,
       @Semantics.quantity.unitOfMeasure: 'bmein'
      A.losbs                                    as losbs,
      A.cslty                                    as cslty,
      A.material_bom_key                         as material_bom_key,
      A.annam                                    as annam,  
      A.aenam                                    as aenam,
      B.aedat                               as aedat, 
      B.bmeng   as bmeng,
      
      B.stlst as stlst,
      c.posnr as posnr,
      c.idnrk as idnrk,
      
      @Semantics.quantity.unitOfMeasure: 'meins'
      c.menge as menge,
      c.meins   as meins,
      A.andat,
      c.datuv,
      c.aenam   as aenam_po,
      c.aedat   as aedat_po,
      c.stlkn   as stlkn,
      c.stpoz   as stpoz,
      c.postp   as postp,
      $session.system_date as ref
      
} where A.mandt = $session.client
