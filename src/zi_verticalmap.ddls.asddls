@AbapCatalog.sqlViewName: 'ZIVERTICALMAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase group vertical mapping'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_VERTICALMAP as select from zvertical_map
{
    key ekgrp as Ekgrp,
    key vname as Vname,
    bdesc as Bdesc,
    vdesc as Vdesc
}
