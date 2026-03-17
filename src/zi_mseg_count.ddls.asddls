//@AbapCatalog.sqlViewName: 'ZIMSEGCOUNT'
@AbapCatalog.viewEnhancementCategory: [#NONE]

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRN Count View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MSEG_COUNT
  as select from mseg as grn
    left outer join ekko as pur
      on pur.ebeln = grn.ebeln
    left outer join ekpo as item
      on item.ebeln = grn.ebeln
      and item.ebelp = grn.ebelp
{
  /* === MSEG fields === */
//  key grn.mandt,
  key grn.mblnr,
  key grn.mjahr,
  key grn.zeile,
  grn.ebeln,
  grn.ebelp,
  grn.matnr,
  grn.werks,
  grn.lgort ,
  grn.bwart,
//  grn.menge,
  grn.meins,
  grn.bukrs,
  grn.budat_mkpf,
//  grn.budat,
//  grn.cpudt,
//  grn.cputm,

  /* === From EKKO === */
  pur.ebeln as pur_ebeln,
  pur.bsart,

  /* === From EKPO === */
  item.matnr as po_matnr
}// where grn.lgort is not initial and grn.ebeln is not initial
