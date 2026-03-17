@AbapCatalog.sqlViewAppendName: 'ZEXT_SALES'
@EndUserText.label: 'I_SALESORDER EXTENDED view'
extend view I_SalesDocument with ZEXTEND_SALES
{
  SalesDocumentBasic.LD_From_Date,
   SalesDocumentBasic. LD_Percentage_Week,
   SalesDocumentBasic.LD_Percentage_Max,
   SalesDocumentBasic.LDRequired,
   SalesDocumentBasic.Project_Name,
   SalesDocumentBasic.ProjectOwner_Name
  
}  


