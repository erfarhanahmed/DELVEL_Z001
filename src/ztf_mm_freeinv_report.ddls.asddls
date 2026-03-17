@EndUserText.label: 'Table Function CDS for Free Inventory Report'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZTF_MM_FREEINV_REPORT
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt  : abap.clnt,
    p_werks : werks_d,
    p_langu : spras
  returns
  {
    mandt       : abap.clnt;

    werks       : werks_d;
    matnr       : matnr;
    maktx       : maktx;
    meins       : meins;
    minbm       : minbm;

    totreq      : menge_d;     // placeholder = 0 (ABAP will compute)
    totstck     : menge_d;
    totstck_val : stprs;

    wip_qty     : menge_d;
    wip_val     : stprs;

    qa_qty      : menge_d;
    qa_val      : stprs;

    sbcn_qty    : menge_d;
    sbcn_val    : stprs;

    free_qty    : menge_d;     // placeholder = 0 (ABAP will compute)
    free_val    : stprs;       // placeholder = 0 (ABAP will compute)

    zrate       : verpr;
    insme       : insme;
    mtart       : mtart;
  }
  implemented by method zcl_mm_freeinv_report=>get_base;
