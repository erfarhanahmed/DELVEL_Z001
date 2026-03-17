@AbapCatalog.sqlViewName: 'ZPAPJEITMAGGRID2'
@VDM.viewType: #COMPOSITE
@VDM.private:true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.algorithm: #SESSION_VARIABLE
define view ZP_APJRNLENTRITMAGINGGRID2
  with parameters
    P_KeyDate               : sydate,
    P_NetDueInterval1InDays : farp_net_due_interval1,
    P_NetDueInterval2InDays : farp_net_due_interval2,
    P_NetDueInterval3InDays : farp_net_due_interval3,
    P_NetDueInterval4InDays : farp_net_due_interval4
  as select from ZP_APJRNLENTRITMAGINGGRID1(P_KeyDate:           :P_KeyDate,
                                       P_NetDueInterval1InDays: :P_NetDueInterval1InDays,
                                       P_NetDueInterval2InDays: :P_NetDueInterval2InDays,
                                       P_NetDueInterval3InDays: :P_NetDueInterval3InDays,
                                       P_NetDueInterval4InDays: :P_NetDueInterval4InDays )
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

      AmountInCompanyCodeCurrency,

      PosNetDueInterval1InDays,
      PosNetDueInterval2InDays,
      PosNetDueInterval3InDays,
      PosNetDueInterval4InDays,
      NegNetDueInterval1InDays,
      NegNetDueInterval2InDays,
      NegNetDueInterval3InDays,
      NegNetDueInterval4InDays,

      cast( 99999 as abap.int4 ) as MaxNetDueIntervalInDays,

      case when PosNetDueInterval4InDays <> 0 then 4
           when PosNetDueInterval3InDays <> 0 then 3
           when PosNetDueInterval2InDays <> 0 then 2
           when PosNetDueInterval1InDays <> 0 then 1
                                              else 0
      end                        as NumberOfParameters
}
