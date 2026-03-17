@AbapCatalog.sqlViewName: 'ZPAPJEITMAGGRID1'
@VDM.viewType: #COMPOSITE
@VDM.private:true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.algorithm: #SESSION_VARIABLE
define view ZP_APJRNLENTRITMAGINGGRID1
  with parameters
    P_KeyDate               : sydate,
    P_NetDueInterval1InDays : farp_net_due_interval1,
    P_NetDueInterval2InDays : farp_net_due_interval2,
    P_NetDueInterval3InDays : farp_net_due_interval3,
    P_NetDueInterval4InDays : farp_net_due_interval4
  as select from P_APJrnlEntrItmOpenPay(P_KeyDate: :P_KeyDate)
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,

      AccountingDocumentItem,
      NetDueArrearsDays,
      NetDueDate,

      Supplier,
      GLAccount,
      SpecialGLCode,
      CostCenter,
      ProfitCenter,
      FunctionalArea,
      BusinessArea,
      Segment,
      PurchasingDocument,
      AssignmentReference,
      CompanyCodeCurrency,

      -1 * AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,

      :P_NetDueInterval1InDays         as PosNetDueInterval1InDays,
      :P_NetDueInterval2InDays         as PosNetDueInterval2InDays,
      :P_NetDueInterval3InDays         as PosNetDueInterval3InDays,
      :P_NetDueInterval4InDays         as PosNetDueInterval4InDays,

      -1 * :P_NetDueInterval1InDays    as NegNetDueInterval1InDays,
      -1 * :P_NetDueInterval2InDays    as NegNetDueInterval2InDays,
      -1 * :P_NetDueInterval3InDays    as NegNetDueInterval3InDays,
      -1 * :P_NetDueInterval4InDays    as NegNetDueInterval4InDays
}
