@AbapCatalog.sqlViewName: 'Z_QM_SUPP_PERF_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monthly Supplier Performance'
@Metadata.ignorePropagatedAnnotations: true
define view ZZ_QM_SUPP_MON_CONSUME_CDS
with parameters
         p_startdt : abap.dats ,
           p_enddt : abap.dats 
           as select from ZZ_QM_MON_PERF_CDS( p_startdt: $parameters.p_startdt,
                                    p_enddt: $parameters.p_enddt )
      as a
{
    a.lifnr as Vendor_Code,
    a.name1 as Vendor_Name,
    a.ort01 as City,
    sum(a.Received_Qty_101)as Received_Qty_101,
    sum(a.Received_Qty_102)as Received_Qty_102,
    sum( case when a.tvarvc_name = 'ZQM_PERF_ACC_LGORT' then Sum_Accepted_Qty end ) as Sum_of_accepted_qty,
    sum(case when a.tvarvc_name = 'ZQM_PERF_REJ_LGORT' then Sum_Rejected_Qty end ) as Sum_of_rejected_qty,
    sum(case when a.tvarvc_name = 'ZQM_PERF_REW_LGORT' then Sum_Rework_Qty end )as Sum_of_rework_qty,
    sum(case when a.tvarvc_name = 'ZQM_PERF_SRN_LGORT' then Sum_SRN_Qty end ) as Sum_of_SRN_qty

}

    group by a.lifnr,
             a.name1,
             a.ort01
            

         
