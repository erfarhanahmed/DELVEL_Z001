@AbapCatalog.sqlViewAppendName: 'ZI_EXT'
@EndUserText.label: 'EXtended View for Sales Order'
extend view I_SalesOrder with ZI_EXTEND_SALES1
{
 SalesDocument.LD_From_Date,
   SalesDocument. LD_Percentage_Week,
   SalesDocument.LD_Percentage_Max,
   SalesDocument.LDRequired,
   SalesDocument.Project_Name,
   SalesDocument.ProjectOwner_Name
}
