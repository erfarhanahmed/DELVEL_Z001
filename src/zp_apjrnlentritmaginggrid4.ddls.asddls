@AbapCatalog.sqlViewName: 'ZPAPJEITMAGGRID4'
@VDM.viewType: #COMPOSITE
@VDM.private:true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.algorithm: #SESSION_VARIABLE
define view ZP_APJRNLENTRITMAGINGGRID4
  with parameters
    P_KeyDate               : sydate,
    P_NetDueInterval1InDays : farp_net_due_interval1,
    P_NetDueInterval2InDays : farp_net_due_interval2,
    P_NetDueInterval3InDays : farp_net_due_interval3,
    P_NetDueInterval4InDays : farp_net_due_interval4
  as select from ZP_APJRNLENTRITMAGINGGRID3(P_KeyDate:               :P_KeyDate,
                                           P_NetDueInterval1InDays: :P_NetDueInterval1InDays,
                                           P_NetDueInterval2InDays: :P_NetDueInterval2InDays,
                                           P_NetDueInterval3InDays: :P_NetDueInterval3InDays,
                                           P_NetDueInterval4InDays: :P_NetDueInterval4InDays
                                           )
  association [0..1] to I_CompanyCode as _Company on _Company.CompanyCode = $projection.CompanyCode
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,

      AccountingDocumentItem,
      NetDueArrearsDays,
      NetDueDate,
      NetDueInterval,
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

      PosNetDueInterval1InDays,
      PosNetDueInterval2InDays,
      PosNetDueInterval3InDays,
      PosNetDueInterval4InDays,
      NegNetDueInterval1InDays,
      NegNetDueInterval2InDays,
      NegNetDueInterval3InDays,
      NegNetDueInterval4InDays,
      MaxNetDueIntervalInDays,
      NumberOfParameters,

      _Company.ControllingArea as ControllingArea,

      AmountInCompanyCodeCurrency,

      case when NetDueInterval > 0 then AmountInCompanyCodeCurrency
                                   else 0
      end                      as TotalNotOverdueAmtInCoCodeCrcy,

      case when NetDueInterval <= 0 then AmountInCompanyCodeCurrency
                                   else 0
      end                      as TotalOverdueAmtInCoCodeCrcy,


      case when NumberOfParameters = 4 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 3 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 1 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 0 and NetDueInterval <= 0                                               then AmountInCompanyCodeCurrency
      else 0
      end                      as NetDueIntvl5AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 1 and NetDueInterval <= 0 and NetDueInterval > NegNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 0 and NetDueInterval <= 0                                               then AmountInCompanyCodeCurrency
      else 0
      end                      as NetDueIntvl1AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval <= NegNetDueInterval1InDays and NetDueInterval > NegNetDueInterval2InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval <= NegNetDueInterval1InDays and NetDueInterval > NegNetDueInterval2InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 1 and NetDueInterval <= NegNetDueInterval1InDays                                               then AmountInCompanyCodeCurrency
      else 0
      end                      as NetDueIntvl2AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval <= NegNetDueInterval2InDays and NetDueInterval > NegNetDueInterval3InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval <= NegNetDueInterval2InDays                                               then AmountInCompanyCodeCurrency
      else 0
      end                      as NetDueIntvl3AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval <= NegNetDueInterval3InDays and NegNetDueInterval3InDays <> 0 then AmountInCompanyCodeCurrency
      else 0
      end                      as NetDueIntvl4AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval > 0 and NetDueInterval <= PosNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval > 0 and NetDueInterval <= PosNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 1 and NetDueInterval > 0 and NetDueInterval <= PosNetDueInterval1InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 0 and NetDueInterval > 0                                               then AmountInCompanyCodeCurrency
      else 0
      end                      as FutureIntvl1AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval > PosNetDueInterval1InDays and NetDueInterval <= PosNetDueInterval2InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval > PosNetDueInterval1InDays and NetDueInterval <= PosNetDueInterval2InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 1 and NetDueInterval > PosNetDueInterval1InDays                                                then AmountInCompanyCodeCurrency
      else 0
      end                      as FutureIntvl2AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval > PosNetDueInterval2InDays and NetDueInterval <= PosNetDueInterval3InDays then AmountInCompanyCodeCurrency
           when NumberOfParameters = 2 and NetDueInterval > PosNetDueInterval2InDays                                                then AmountInCompanyCodeCurrency
      else 0
      end                      as FutureIntvl3AmtInCoCodeCrcy,

      case when NumberOfParameters = 3 and NetDueInterval > PosNetDueInterval3InDays and PosNetDueInterval3InDays <> 0 then AmountInCompanyCodeCurrency
      else 0
      end                      as FutureIntvl4AmtInCoCodeCrcy
}
