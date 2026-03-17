@AbapCatalog.sqlViewAppendName: 'ZI_V_EXT_SALES'
@EndUserText.label: 'EXtended View for Sales Order'
extend view I_SalesDocumentBasic with ZI_EXTEND_SALES
{
vbak.zldfromdate as LD_From_Date,
   vbak.zldperweek as LD_Percentage_Week,
   vbak.zldmax as LD_Percentage_Max,
   vbak.zldreq as LDRequired,
   vbak.zproject as Project_Name,
   vbak.zprojectname as ProjectOwner_Name
   
   
}
