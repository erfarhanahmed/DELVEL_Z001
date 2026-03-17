@AbapCatalog.sqlViewName: 'ZPAPJEITMAGGRID3'
@VDM.viewType: #COMPOSITE
@VDM.private:true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.algorithm: #SESSION_VARIABLE
define view ZP_APJRNLENTRITMAGINGGRID3
  with parameters
    P_KeyDate               : sydate,
    P_NetDueInterval1InDays : farp_net_due_interval1,
    P_NetDueInterval2InDays : farp_net_due_interval2,
    P_NetDueInterval3InDays : farp_net_due_interval3,
    P_NetDueInterval4InDays : farp_net_due_interval4
  as select from ZP_APJRNLENTRITMAGINGGRID2(P_KeyDate:           :P_KeyDate,
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

      MaxNetDueIntervalInDays,
      NumberOfParameters,

      case 
           when NumberOfParameters = 4 and NetDueArrearsDays  > PosNetDueInterval4InDays                                                    then  MaxNetDueIntervalInDays    
           when NumberOfParameters = 4 and NetDueArrearsDays  > PosNetDueInterval3InDays and NetDueArrearsDays <= :P_NetDueInterval4InDays  then  PosNetDueInterval4InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  > PosNetDueInterval2InDays and NetDueArrearsDays <= :P_NetDueInterval3InDays  then  PosNetDueInterval3InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  > PosNetDueInterval1InDays and NetDueArrearsDays <= :P_NetDueInterval2InDays  then  PosNetDueInterval2InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  > 0                        and NetDueArrearsDays <= :P_NetDueInterval1InDays  then  PosNetDueInterval1InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  >= NegNetDueInterval1InDays and NetDueArrearsDays <= 0                        then  0
           when NumberOfParameters = 4 and NetDueArrearsDays  >= NegNetDueInterval2InDays and NetDueArrearsDays < NegNetDueInterval1InDays  then  NegNetDueInterval1InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  >= NegNetDueInterval3InDays and NetDueArrearsDays < NegNetDueInterval2InDays  then  NegNetDueInterval2InDays
           when NumberOfParameters = 4 and NetDueArrearsDays  >= NegNetDueInterval4InDays and NetDueArrearsDays < NegNetDueInterval3InDays  then  NegNetDueInterval3InDays
           when NumberOfParameters = 4                                                                                                      then  NegNetDueInterval4InDays
                  
           when NumberOfParameters = 3 and NetDueArrearsDays  > PosNetDueInterval3InDays                                                    then  MaxNetDueIntervalInDays
           when NumberOfParameters = 3 and NetDueArrearsDays  > PosNetDueInterval2InDays and NetDueArrearsDays <= :P_NetDueInterval3InDays  then  PosNetDueInterval3InDays
           when NumberOfParameters = 3 and NetDueArrearsDays  > PosNetDueInterval1InDays and NetDueArrearsDays <= :P_NetDueInterval2InDays  then  PosNetDueInterval2InDays
           when NumberOfParameters = 3 and NetDueArrearsDays  > 0                        and NetDueArrearsDays <= :P_NetDueInterval1InDays  then  PosNetDueInterval1InDays
           when NumberOfParameters = 3 and NetDueArrearsDays  >= NegNetDueInterval1InDays and NetDueArrearsDays <= 0                        then  0
           when NumberOfParameters = 3 and NetDueArrearsDays  >= NegNetDueInterval2InDays and NetDueArrearsDays < NegNetDueInterval1InDays  then  NegNetDueInterval1InDays
           when NumberOfParameters = 3 and NetDueArrearsDays  >= NegNetDueInterval3InDays and NetDueArrearsDays < NegNetDueInterval2InDays  then  NegNetDueInterval2InDays
           when NumberOfParameters = 3                                                                                                      then  NegNetDueInterval3InDays

           when NumberOfParameters = 2 and NetDueArrearsDays  > PosNetDueInterval2InDays                                                    then  MaxNetDueIntervalInDays
           when NumberOfParameters = 2 and NetDueArrearsDays  > PosNetDueInterval1InDays and NetDueArrearsDays <= :P_NetDueInterval2InDays  then  PosNetDueInterval2InDays
           when NumberOfParameters = 2 and NetDueArrearsDays  > 0                        and NetDueArrearsDays <= :P_NetDueInterval1InDays  then  PosNetDueInterval1InDays
           when NumberOfParameters = 2 and NetDueArrearsDays  >= NegNetDueInterval1InDays and NetDueArrearsDays <= 0                        then  0
           when NumberOfParameters = 2 and NetDueArrearsDays  >= NegNetDueInterval2InDays and NetDueArrearsDays < NegNetDueInterval1InDays  then  NegNetDueInterval1InDays
           when NumberOfParameters = 2                                                                                                      then  NegNetDueInterval2InDays

           when NumberOfParameters = 1 and NetDueArrearsDays  > PosNetDueInterval1InDays                                                    then  MaxNetDueIntervalInDays
           when NumberOfParameters = 1 and NetDueArrearsDays  > 0                        and NetDueArrearsDays <= :P_NetDueInterval1InDays  then  PosNetDueInterval1InDays
           when NumberOfParameters = 1 and NetDueArrearsDays  >= NegNetDueInterval1InDays and NetDueArrearsDays <= 0                        then  0
           when NumberOfParameters = 1                                                                                                      then  NegNetDueInterval1InDays

           when NumberOfParameters = 0 and NetDueArrearsDays  > 0  then  MaxNetDueIntervalInDays
           when NumberOfParameters = 0                           then  0

                                                                                                                                        else  0 // dummy
      end as NetDueInterval
}
