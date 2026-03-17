@AbapCatalog.sqlViewName: 'ZIAPJEITMAGGRID'
@VDM.viewType: #COMPOSITE
@EndUserText.label: 'Aging Grid of Accounts Payables'
@Analytics: { dataCategory: #CUBE }
@Analytics.internalName: #LOCAL   // released with Cloud 1808 and OP 1809 hence no design studio usage before
@Search.searchable: false // I_Region is annotated as true, hence this new must have an annotation for searchable
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck:#CHECK
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.dataClass: #MIXED
@AccessControl.personalData.blocking: #REQUIRED
@Metadata.allowExtensions: true
define view ZI_APJRNLENTRITMAGINGGRID
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_KeyDate               : sydate,
    P_NetDueInterval1InDays : farp_net_due_interval1,
    P_NetDueInterval2InDays : farp_net_due_interval2,
    P_NetDueInterval3InDays : farp_net_due_interval3,
    P_NetDueInterval4InDays : farp_net_due_interval4,
    P_DisplayCurrency       : vdm_v_display_currency,
    P_ExchangeRateType      : kurst

  as select from ZP_APJRNLENTRITMAGINGGRID4(P_KeyDate:              :P_KeyDate,
                                           P_NetDueInterval1InDays: :P_NetDueInterval1InDays,
                                           P_NetDueInterval2InDays: :P_NetDueInterval2InDays,
                                           P_NetDueInterval3InDays: :P_NetDueInterval3InDays,
                                           P_NetDueInterval4InDays: :P_NetDueInterval4InDays )

  association [0..1] to I_FiscalYearForCompanyCode   as _FiscalYear                 on  $projection.FiscalYear  = _FiscalYear.FiscalYear
                                                                                    and $projection.CompanyCode = _FiscalYear.CompanyCode
  association [1..1] to I_JournalEntry               as _JournalEntry               on  $projection.CompanyCode        = _JournalEntry.CompanyCode
                                                                                    and $projection.FiscalYear         = _JournalEntry.FiscalYear
                                                                                    and $projection.AccountingDocument = _JournalEntry.AccountingDocument
  association [0..1] to I_CompanyCode                as _Company                    on  _Company.CompanyCode = $projection.CompanyCode
  association [0..1] to I_Supplier                   as _Supplier                   on  _Supplier.Supplier = $projection.Supplier
  association [0..1] to I_FinancialAccountType       as _FinancialAccountType       on  _FinancialAccountType.FinancialAccountType = $projection.FinancialAccountType
  association [0..1] to I_SupplierCompany            as _SupplierCompany            on  _SupplierCompany.CompanyCode = $projection.CompanyCode
                                                                                    and _SupplierCompany.Supplier    = $projection.Supplier
  association [0..1] to I_AccountingClerk            as _AccountingClerk            on  _AccountingClerk.CompanyCode     = $projection.CompanyCode
                                                                                    and _AccountingClerk.AccountingClerk = $projection.AccountingClerk
  association [0..1] to I_Country                    as _SupplierCountry            on  _SupplierCountry.Country = $projection.SupplierCountry
  association [0..1] to I_Region                     as _SupplierRegion             on  _SupplierRegion.Region  = $projection.SupplierRegion
                                                                                    and _SupplierRegion.Country = $projection.SupplierCountry
  association [0..1] to I_Currency                   as _DisplayCurrency            on  _DisplayCurrency.Currency = $projection.DisplayCurrency
  association [0..1] to I_SpecialGLCode              as _SpecialGLCode              on  _SpecialGLCode.SpecialGLCode        = $projection.SpecialGLCode
                                                                                    and _SpecialGLCode.FinancialAccountType = 'K' // credit items
  association [0..1] to I_ChartOfAccounts            as _ChartOfAccounts            on  _ChartOfAccounts.ChartOfAccounts = $projection.ChartOfAccounts
  association [0..1] to I_GLAccountInChartOfAccounts as _GLAccountInChartOfAccounts on  _GLAccountInChartOfAccounts.ChartOfAccounts = $projection.ChartOfAccounts
                                                                                    and _GLAccountInChartOfAccounts.GLAccount       = $projection.GLAccount
  association [0..1] to I_GLAccountInChartOfAccounts as _ReconciliationAccount      on  _ReconciliationAccount.ChartOfAccounts = $projection.ChartOfAccounts
                                                                                    and _ReconciliationAccount.GLAccount       = $projection.ReconciliationAccount
  association [0..1] to I_SupplierAccountGroup       as _SupplierAccountGroup       on  _SupplierAccountGroup.SupplierAccountGroup = $projection.SupplierAccountGroup
  //  association [0..*] to I_CostCenter               as _CostCenter                 on  _CostCenter.CostCenter = $projection.CostCenter
  //                                                                                  and _CostCenter.ControllingArea = $projection.ControllingArea
  //  association [0..1] to I_CostCenter                 as _CurrentCostCenter          on  $projection.ControllingArea          = _CurrentCostCenter.ControllingArea
  //                                                                                    and $projection.CostCenter               = _CurrentCostCenter.CostCenter
  //                                                                                    and _CurrentCostCenter.ValidityStartDate <= $session.system_date
  //                                                                                    and _CurrentCostCenter.ValidityEndDate   >= $session.system_date
  //  association [0..1] to I_ControllingArea             as _ControllingArea            on  _ControllingArea.ControllingArea = $projection.ControllingArea

{
      @ObjectModel.foreignKey.association: '_Company'
  key CompanyCode,
      @ObjectModel.foreignKey.association: '_FiscalYear'
  key FiscalYear,
      @ObjectModel.foreignKey.association: '_JournalEntry'
  key AccountingDocument,
  key LedgerGLLineItem,

      AccountingDocumentItem,
      //      will be sorted as char (- 1, -10, -100, -2, -20, ...)  as of now hence useless
      //      @DefaultAggregation: #NONE
      //      cast( NetDueArrearsDays as zmm_verzn_char )                     as NetDueArrearsDays,
      @ObjectModel.foreignKey.association: '_FinancialAccountType'
      cast( 'K' as fis_koart )                                            as FinancialAccountType,
      @ObjectModel.foreignKey.association: '_Supplier'
      Supplier,
      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      GLAccount,
      @ObjectModel.foreignKey.association: 'SpecialGLCode'
      SpecialGLCode,
      //      foreign key 0..* will cause problem with SADL calling AE (not with AE itself which assumes and searches in view definition for time restrictions)
      //      @ObjectModel.foreignKey.association: '_ProfitCenter'
      ProfitCenter,
      BusinessArea,
      Segment,
      //@ObjectModel.foreignKey.association: '_ControllingArea'
      //ControllingArea,
      AssignmentReference,

      cast(
      case when NumberOfParameters = 4 and NetDueInterval = MaxNetDueIntervalInDays  then concat_with_space('J.',concat_with_space('>', cast(PosNetDueInterval4InDays as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = PosNetDueInterval4InDays then concat_with_space('I.',concat_with_space(concat_with_space(cast(PosNetDueInterval3InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval3InDays as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = PosNetDueInterval3InDays then concat_with_space('H.',concat_with_space(concat_with_space(cast(PosNetDueInterval2InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval3InDays as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = PosNetDueInterval2InDays then concat_with_space('G.',concat_with_space(concat_with_space(cast(PosNetDueInterval1InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval2InDays as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = PosNetDueInterval1InDays then concat_with_space('F.',concat_with_space(concat_with_space('1','-',1), cast(PosNetDueInterval1InDays as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = 0                        then concat_with_space('E.',concat_with_space(concat_with_space(cast(NegNetDueInterval1InDays as abap.char(20)), '-',1), '0',1),1)
           when NumberOfParameters = 4 and NetDueInterval = NegNetDueInterval1InDays then concat_with_space('D.',concat_with_space(concat_with_space(cast(NegNetDueInterval2InDays as abap.char(20)), '-',1), cast(NegNetDueInterval1InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = NegNetDueInterval2InDays then concat_with_space('C.',concat_with_space(concat_with_space(cast(NegNetDueInterval3InDays as abap.char(20)), '-',1), cast(NegNetDueInterval2InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = NegNetDueInterval3InDays then concat_with_space('B.',concat_with_space(concat_with_space(cast(NegNetDueInterval4InDays as abap.char(20)), '-',1), cast(NegNetDueInterval3InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 4 and NetDueInterval = NegNetDueInterval4InDays then concat_with_space('A.',concat_with_space('<', cast(NegNetDueInterval4InDays as abap.char(20)),1),1)


           when NumberOfParameters = 3 and NetDueInterval = MaxNetDueIntervalInDays  then concat_with_space('H.',concat_with_space('>', cast(PosNetDueInterval3InDays as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = PosNetDueInterval3InDays then concat_with_space('G.',concat_with_space(concat_with_space(cast(PosNetDueInterval2InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval3InDays as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = PosNetDueInterval2InDays then concat_with_space('F.',concat_with_space(concat_with_space(cast(PosNetDueInterval1InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval2InDays as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = PosNetDueInterval1InDays then concat_with_space('E.',concat_with_space(concat_with_space('1','-',1), cast(PosNetDueInterval1InDays as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = 0                        then concat_with_space('D.',concat_with_space(concat_with_space(cast(NegNetDueInterval1InDays as abap.char(20)), '-',1), '0',1),1)
           when NumberOfParameters = 3 and NetDueInterval = NegNetDueInterval1InDays then concat_with_space('C.',concat_with_space(concat_with_space(cast(NegNetDueInterval2InDays as abap.char(20)), '-',1), cast(NegNetDueInterval1InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = NegNetDueInterval2InDays then concat_with_space('B.',concat_with_space(concat_with_space(cast(NegNetDueInterval3InDays as abap.char(20)), '-',1), cast(NegNetDueInterval2InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 3 and NetDueInterval = NegNetDueInterval3InDays then concat_with_space('A.',concat_with_space('<', cast(NegNetDueInterval3InDays as abap.char(20)),1),1)

           when NumberOfParameters = 2 and NetDueInterval = MaxNetDueIntervalInDays  then concat_with_space('F.',concat_with_space('>', cast(PosNetDueInterval2InDays as abap.char(20)),1),1)
           when NumberOfParameters = 2 and NetDueInterval = PosNetDueInterval2InDays then concat_with_space('E.',concat_with_space(concat_with_space(cast(PosNetDueInterval1InDays + 1 as abap.char(20)), '-',1), cast(PosNetDueInterval2InDays as abap.char(20)),1),1)
           when NumberOfParameters = 2 and NetDueInterval = PosNetDueInterval1InDays then concat_with_space('D.',concat_with_space(concat_with_space('1', '-',1), cast(PosNetDueInterval1InDays as abap.char(20)),1),1)
           when NumberOfParameters = 2 and NetDueInterval = 0                        then concat_with_space('C.',concat_with_space(concat_with_space(cast(NegNetDueInterval1InDays as abap.char(20)), '-',1), '0',1),1)
           when NumberOfParameters = 2 and NetDueInterval = NegNetDueInterval1InDays then concat_with_space('B.',concat_with_space(concat_with_space(cast(NegNetDueInterval2InDays as abap.char(20)), '-',1), cast(NegNetDueInterval1InDays - 1 as abap.char(20)),1),1)
           when NumberOfParameters = 2 and NetDueInterval = NegNetDueInterval2InDays then concat_with_space('A.',concat_with_space('<', cast(NegNetDueInterval2InDays as abap.char(20)),1),1)

           when NumberOfParameters = 1 and NetDueInterval = MaxNetDueIntervalInDays  then concat_with_space('D.',concat_with_space('>', cast(PosNetDueInterval1InDays as abap.char(20)),1),1)
           when NumberOfParameters = 1 and NetDueInterval = PosNetDueInterval1InDays then concat_with_space('C.',concat_with_space(concat_with_space('1', '-',1), cast(PosNetDueInterval1InDays as abap.char(20)),1),1)
           when NumberOfParameters = 1 and NetDueInterval = 0                        then concat_with_space('B.',concat_with_space(concat_with_space(cast(NegNetDueInterval1InDays as abap.char(20)),'-',1),'0',1),1)
           when NumberOfParameters = 1 and NetDueInterval = NegNetDueInterval1InDays then concat_with_space('A.',concat_with_space('<', cast(NegNetDueInterval1InDays as abap.char(20)),1),1)

           when NumberOfParameters = 0 and  NetDueInterval = MaxNetDueIntervalInDays then 'A. > 0'
           when NumberOfParameters = 0 and  NetDueInterval = 0                       then 'B. <= 0'

           else 'ERROR'  // dummy
       end as farp_netdue_intvl_text )                                    as NetDueIntervalText,

      @ObjectModel.foreignKey.association: '_SupplierCountry'
      cast( _Supplier._StandardAddress._Country.Country as farp_land1 )   as SupplierCountry,
      @ObjectModel.foreignKey.association: '_SupplierRegion'
      _Supplier._StandardAddress._Region.Region                           as SupplierRegion,
      @ObjectModel.foreignKey.association: '_AccountingClerk'
      cast( _SupplierCompany.AccountingClerk as farp_busab )              as AccountingClerk,
      @ObjectModel.foreignKey.association: '_ChartOfAccounts'
      cast( _Company.ChartOfAccounts as fis_ktopl )                       as ChartOfAccounts,
      @ObjectModel.foreignKey.association: '_ReconciliationAccount'
      cast( _SupplierCompany.ReconciliationAccount as farp_akont )        as ReconciliationAccount,

      // fields for authorization checks via DCL
      cast( _Supplier.AuthorizationGroup as fis_supplier_basic_auth_grp ) as SupplierBasicAuthorizationGrp,
      _SupplierCompany.AuthorizationGroup                                 as SupplierFinsAuthorizationGrp,

      @ObjectModel.foreignKey.association: '_SupplierAccountGroup'
      _Supplier.SupplierAccountGroup                                      as SupplierAccountGroup,

      @Semantics.currencyCode:true
      @ObjectModel.foreignKey.association: '_DisplayCurrency'
      cast(:P_DisplayCurrency as vdm_v_display_currency)                  as DisplayCurrency,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => AmountInCompanyCodeCurrency,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_total_amount_display_crcy )                               as TotalAmountInDisplayCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => TotalNotOverdueAmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_tot_not_ovrd_amt_dspcrcy )                                as TotalNotOvrdAmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => TotalOverdueAmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      )  as farp_total_overdue_amt_dspcrcy)                               as TotalOverdueAmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => NetDueIntvl1AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_netdue_intvl1_amt_dspcrcy )                               as NetDueIntvl1AmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => NetDueIntvl2AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_netdue_intvl2_amt_dspcrcy )                               as NetDueIntvl2AmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => NetDueIntvl3AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_netdue_intvl3_amt_dspcrcy )                               as NetDueIntvl3AmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => NetDueIntvl4AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_netdue_intvl4_amt_dspcrcy )                               as NetDueIntvl4AmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => FutureIntvl1AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_futdue_intvl1_amt_dspcrcy )                               as FirstIntvlFutrDueAmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => FutureIntvl2AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_futdue_intvl2_amt_dspcrcy )                               as SecondIntvlFutrDueAmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => FutureIntvl3AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_futdue_intvl3_amt_dspcrcy )                               as ThirdIntvlFutrDueAmtInDspCrcy,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      cast( currency_conversion(
            amount => FutureIntvl4AmtInCoCodeCrcy,
            source_currency => CompanyCodeCurrency,
            target_currency => :P_DisplayCurrency,
            exchange_rate_date => :P_KeyDate,
            exchange_rate_type => :P_ExchangeRateType,
      //        error_handling => 'FAIL_ON_ERROR',
            round => #CDSBoolean.true,
            decimal_shift => #CDSBoolean.true,
            decimal_shift_back => #CDSBoolean.true
      ) as farp_futdue_lintvl_amt_dspcrcy )                               as FourthIntvlFutrDueAmtInDspCrcy,

      _FiscalYear,
      _JournalEntry,
      _Company,
      _Supplier,
      _SupplierCompany,
      _FinancialAccountType,
      _AccountingClerk,
      _SupplierCountry,
      _SupplierRegion,
      _SpecialGLCode,
      //      _CostCenter,
      //_CurrentCostCenter,
      //_ControllingArea,
      _GLAccountInChartOfAccounts,
      _ReconciliationAccount,
      _ChartOfAccounts,
      _DisplayCurrency,
      _SupplierAccountGroup
}
