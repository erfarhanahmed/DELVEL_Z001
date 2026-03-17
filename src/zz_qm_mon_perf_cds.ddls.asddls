@AbapCatalog.sqlViewName: 'Z_QM_DOC_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monthly Performace View'
@Metadata.ignorePropagatedAnnotations: true
define view ZZ_QM_MON_PERF_CDS 
with parameters
         p_startdt : abap.dats ,
           p_enddt : abap.dats 
//as select from nsdm_v_mseg as a
as select from matdoc as a
inner join lfa1 as b
on a.lifnr = b.lifnr
inner join tvarvc as c
on a.lgort_sid = c.low
{
 
   key a.lifnr,
    b.name1,
   b.ort01,
 c.name as tvarvc_name,
 a.bwart,    
  sum( case 
  when a.bwart = '101'  then a.menge 
  end ) as Received_Qty_101,
  
  sum( case 
  when a.bwart = '102'  then a.menge 
  end ) as Received_Qty_102,
    
  sum( case 
  when a.bwart = '321'and a.shkzg = 'S' and c.name = 'ZQM_PERF_ACC_LGORT' 
  then a.menge 
  end ) as Sum_Accepted_Qty,
  
  sum( case 
  when a.bwart = '321'and a.shkzg = 'S' and c.name = 'ZQM_PERF_REJ_LGORT' 
  then a.menge 
  end ) as Sum_Rejected_Qty,
  
    sum( case 
  when a.bwart = '321'and a.shkzg = 'S' and c.name = 'ZQM_PERF_REW_LGORT' 
  then a.menge 
  end ) as Sum_Rework_Qty,
  
   sum( case 
  when a.bwart = '321'and a.shkzg = 'S' and c.name = 'ZQM_PERF_SRN_LGORT' 
  then a.menge 
  end ) as Sum_SRN_Qty
  
}
where 

a.budat >= $parameters.p_startdt 
and a.budat <= $parameters.p_enddt 
and (a.bwart = '101'
or a.bwart = '102'
or a.bwart = '321')
// and a.shkzg = 'S'
 and(c.name = 'ZQM_PERF_ACC_LGORT' 
 or c.name = 'ZQM_PERF_REJ_LGORT'
 or c.name = 'ZQM_PERF_REW_LGORT'
 or c.name = 'ZQM_PERF_SRN_LGORT') 
 group by a.lifnr,
          a.bwart,
          b.name1,
          b.ort01,
          c.name
          

          
