@AbapCatalog.sqlViewName: 'ZV_BANKGLSUM'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bankwise Credit and GL Amount Summary'
@Analytics:{
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture.automatic: true
    }
}
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY,
                                      #ANALYTICAL_DIMENSION
                                      ]
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZI_BankGLSummary
  as select from ZI_CreditSum as Credit
    inner join ZI_GLAccountAmountFiltered as GL
      on Credit.gl = GL.GLAccount
{
  key Credit.bank_name as BankName,
  key Credit.bank_type as BankType,
//  key Credit.gl        as GLAccount,

  @Semantics.amount.currencyCode: 'vbrp.waerk'
  sum( Credit.total_credit ) as CreditAmount,

  @Semantics.amount.currencyCode: 'vbrp.waerk'
  sum( GL.TotalAmount )      as LedgerBalance
}
group by
  Credit.bank_name,
  Credit.bank_type;
//  Credit.gl;
