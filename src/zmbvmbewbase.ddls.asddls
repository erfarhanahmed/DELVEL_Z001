@AbapCatalog.sqlViewName: 'ZV_ZMBVMBEWB'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MBEW Base CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZMbvMbewBase
  as

  select from              mbew                           as m

    inner join             R_MatlPriceDataMigrationStatus as tf       on(
            tf.MatlPriceDataMigrationStatus                                                             = 'X'
          )
                                                                      or(
                                                                        tf.MatlPriceDataMigrationStatus = 'R'
                                                                      )
                                                                      or(
                                                                        tf.MatlPriceDataMigrationStatus = 'F'
                                                                      )

    left outer to one join V_ML_ACDOC_EX_UL_DDL           as u        on  u.kalnr = m.kaln1
                                                                      and u.rclnt = m.mandt
                                                                      and u.matnr = m.matnr //MATNR and BWKEY are added due to performance reason,
                                                                      and u.bwkey = m.bwkey //see SAP note 2505119

    left outer to one join FMLV_XBEW_CKMLCR_SALKV         as matprice on  matprice.mandt                        = m.mandt
                                                                      and matprice.kalnr                        = m.kaln1
                                                                      and (
                                                                         (
                                                                           (
                                                                             tf.MatlPriceDataMigrationStatus    = 'X'
                                                                             or tf.MatlPriceDataMigrationStatus = 'R'
                                                                           )
                                                                           and matprice.bdatj                   = m.lfgja
                                                                           and matprice.lfmonp                  = concat(
                                                                             '0', m.lfmon
                                                                           )
                                                                         )
                                                                         or(
                                                                           (
                                                                             tf.MatlPriceDataMigrationStatus    = 'R'
                                                                             or tf.MatlPriceDataMigrationStatus = 'F'
                                                                           )
                                                                           and matprice.bdatj                   = '9999'
                                                                         )
                                                                       )

{
  key m.mandt,
  key m.matnr,
  key m.bwkey,
  key m.bwtar,
      kaln1,

      //LBKUM from acdoca extract table
      u.vmsl         as lbkum,

      //SALK3 from acdoca extract table
      u.hsl          as salk3,
      lvorm,
      m.vprsv,
      verpr,
      m.stprs,
      m.peinh,
      bklas,

      //SALKV from CR table
      matprice.salkv as salkv,
      vmkum,
      vmsal,
      vmvpr,
      vmver,
      vmstp,
      vmpei,
      vmbkl,
      vmsav,
      vjkum,
      vjsal,
      vjvpr,
      vjver,
      vjstp,
      vjpei,
      vjbkl,
      vjsav,
      lfgja,
      lfmon,
      bwtty,
      stprv,
      laepr,
      zkprs,
      zkdat,
      timestamp,
      bwprs,
      bwprh,
      vjbws,
      vjbwh,
      vvjsl,
      vvjlb,
      vvmlb,
      vvsal,
      zplpr,
      zplp1,
      zplp2,
      zplp3,
      zpld1,
      zpld2,
      zpld3,
      pperz,
      pperl,
      pperv,
      kalkz,
      kalkl,
      kalkv,
      kalsc,
      xlifo,
      mypol,
      bwph1,
      bwps1,
      abwkz,
      pstat,
      m.kalnr,
      bwva1,
      bwva2,
      bwva3,
      vers1,
      vers2,
      vers3,
      hrkft,
      kosgr,
      pprdz,
      pprdl,
      pprdv,
      pdatz,
      pdatl,
      pdatv,
      ekalr,
      vplpr,
      mlmaa,
      mlast,
      lplpr,

      //VKSAL from acdoca extract table
      u.hvkwrt       as vksal,
      hkmat,
      sperw,
      kziwl,
      wlinl,
      abciw,
      bwspa,
      lplpx,
      vplpx,
      fplpx,
      lbwst,
      vbwst,
      fbwst,
      eklas,
      qklas,
      mtuse,
      mtorg,
      ownpr,
      xbewm,
      bwpei,
      mbrue,
      oklas,
      dummy_val_incl_eew_ps
}
