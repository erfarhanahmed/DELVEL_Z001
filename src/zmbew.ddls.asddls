@AbapCatalog.sqlViewName: 'ZMBEWTAB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'mbew table'
@Metadata.ignorePropagatedAnnotations: true
define view zmbew as select from mbvmbew
{
 matnr,
          bwkey,
          bklas,
          salk3,
          vprsv,
          verpr,
          stprs,
          bwtar
}
