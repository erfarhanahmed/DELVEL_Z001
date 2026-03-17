@AbapCatalog.sqlViewAppendName: 'ZI_EXTEND_CUBE'
@EndUserText.label: 'EXtended View for Sales Order'
extend view I_SalesOrderItemCube with ZI_EXTEND_SALES_CUBE
{
 _SalesOrder.LD_From_Date,
   _SalesOrder.LD_Percentage_Week,
   _SalesOrder.LD_Percentage_Max,
   _SalesOrder.LDRequired,
    _SalesOrder.Project_Name,
    _SalesOrder.ProjectOwner_Name
}
