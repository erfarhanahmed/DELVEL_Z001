@AbapCatalog.sqlViewName: 'ZV_BANKGLSUM_C'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bankwise Credit and GL Amount Summary (Cube)'
@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZC_BankGLSummary
  as select from ZI_BankGLSummary_Basic
{
  key BankName,
  key BankType,
   @DefaultAggregation: #SUM
  
    CreditAmount,
//      @AnalyticsDetails.query.aggregateFunction: #SUM
       @DefaultAggregation: #SUM
      LedgerBalance,
//      @AnalyticsDetails.query.aggregateFunction: #SUM
 @DefaultAggregation: #SUM
      
      case 
    when CreditAmount is null or CreditAmount = 0 
        then LedgerBalance
    else 
        ( CreditAmount - ( LedgerBalance * -1 ) )
end as AvailableBalance
}

