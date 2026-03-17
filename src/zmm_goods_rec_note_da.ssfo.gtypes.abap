TYPES :   BEGIN OF T_GR,
    ZEILE     TYPE MBLPO,
*    EBELP     TYPE EBELP,
*    BRAND     TYPE WRF_BRAND_ID,
    MATNR     TYPE MATNR,
    MAKTX     TYPE MAKTX,
    ZEINR     TYPE DZEINR,
    ZEIVR     TYPE DZEIVR,
    ERFME     TYPE ERFME,
    QTY       TYPE MENGE_D,
    MENGE_PO  TYPE MENGE_D,
    MEINS_PO  TYPE MEINS,
    MENGE_CH  TYPE MENGE_D,
    MEINS_CH  TYPE MEINS,
    MENGE_GR  TYPE MENGE_D,
    MEINS_GR  TYPE MEINS,
    MENGE_DF  TYPE MENGE_D,
    MENGE_AC  TYPE MENGE_D,
    MENGE_RJ  TYPE MENGE_D,
*    lgort     TYPE mseg-lgort,
END OF T_GR.

TYPES :  BEGIN OF T_ADD,
    ADRNR      TYPE T001-ADRNR,              " ADDRESS NO
    NAME1      TYPE ADRC-NAME1,
    NAME2      TYPE ADRC-NAME2,
    CITY1      TYPE ADRC-CITY1,
    STREET     TYPE ADRC-STREET,
    STR_SUPPL1 TYPE AD_STRSPP1,
    STR_SUPPL2 TYPE AD_STRSPP1,
    HOUSE_NUM1 TYPE ADRC-HOUSE_NUM1,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    LOCATION   TYPE ADRC-LOCATION,
    POST_CODE1 TYPE ADRC-POST_CODE1,         " POST CODE
    COUNTRY    TYPE ADRC-COUNTRY,            " COUNTRY KEY
    LANDX      TYPE T005T-LANDX,             " COUNTRY
    REGION     TYPE ADRC-REGION,             " STATE KEY
    TEL_NUMBER TYPE ADRC-TEL_NUMBER,         " TEL NO
    FAX_NUMBER TYPE ADRC-FAX_NUMBER,         " FAX NO
    BEZEI      TYPE T005U-BEZEI,             " STATE
END OF T_ADD.

TYPES: BEGIN OF TY_MARA,
    MATNR      TYPE MATNR,
    ZEINR      TYPE DZEINR,
END OF TY_MARA.

TYPES: BEGIN OF TY_EKPO,
    EBELN      TYPE EBELN,
    EBELP      TYPE EBELP,
    MENGE      TYPE BSTMG,
END OF TY_EKPO.

TYPES: BEGIN OF TY_KONV,
    KNUMV      TYPE KNUMV,
    KSCHA      TYPE KSCHA,
    LIFNR      TYPE LIFNR,
    KAWRT      TYPE KAWRT,
END OF TY_KONV.

TYPES: BEGIN OF TY_EKKO,
    EBELN      TYPE EBELN,
    KNUMV      TYPE KNUMV,
END OF TY_EKKO.

TYPES: BEGIN OF TY_QALS,
    LMENGE04   TYPE QLMENGE04F,
END OF TY_QALS.

TYPES : BEGIN OF ST_ADRC,
    ADDRNUMBER TYPE ADRC-ADDRNUMBER,
    NAME1      TYPE ADRC-NAME1,
    NAME2      TYPE ADRC-NAME2,
    NAME_CO    TYPE ADRC-NAME_CO,
    STR_SUPPL1 TYPE ADRC-STR_SUPPL1,
    STR_SUPPL2 TYPE ADRC-STR_SUPPL2,
    STR_SUPPL3 TYPE ADRC-STR_SUPPL3,
    STREET     TYPE ADRC-STREET,         "
    LOCATION   TYPE ADRC-LOCATION,
    CITY1      TYPE ADRC-CITY1,
    REGION     TYPE ADRC-REGION,
    BEZEI      TYPE T005U-BEZEI,         " REGION
    COUNTRY    TYPE ADRC-COUNTRY,
    LANDX      TYPE T005T-LANDX,         " COUNTRY
    POST_CODE1 TYPE ADRC-POST_CODE1,     " POST CODE
    TEL_NUMBER TYPE ADRC-TEL_NUMBER,                           " TELE1
    TEL_EXTENS TYPE ADRC-TEL_EXTENS,                           " TELE2
    FAX_NUMBER TYPE ADRC-FAX_NUMBER,                           " FAX1
    FAX_EXTENS TYPE ADRC-FAX_EXTENS,                           " FAX3
END OF ST_ADRC.

TYPES : BEGIN OF T_MSEG,
    ZEILE          TYPE MBLPO,
    EBELN          TYPE BSTNR,
    EBELP          TYPE EBELP,
    MATNR          TYPE MATNR,
    LSMNG          TYPE LSMNG,
    LSMEH          TYPE LSMEH,
    ERFMG          TYPE ERFMG,
    ERFME          TYPE ERFME,
    BPMNG          TYPE BPMNG,
    BPRME          TYPE BPRME,
    LIFNR          TYPE LIFNR,
    BWART          TYPE BWART,
    LGORT          TYPE LGORT_D,
    SHKZG          TYPE SHKZG,
    INSMK          TYPE INSMK,
    AUFNR          TYPE MSEG-AUFNR,
    MAT_KDAUF      TYPE MSEG-MAT_KDAUF,
   END OF T_MSEG,
   tt_mseg TYPE TABLE OF t_mseg.

TYPES : BEGIN OF T_MAKT,
    MATNR          TYPE MATNR,
    MAKTX          TYPE MAKTX,
END OF T_MAKT.

types ty_TEXT_LINES1   TYPE TABLE OF TLINE.

TYPES : BEGIN OF t_mblnr,
          mblnr TYPE mblnr,
          mjahr TYPE mjahr,
          vgart TYPE vgart,
        END OF t_mblnr.

TYPES : BEGIN OF ty_ekpo1,
        ebeln TYPE ekpo-ebeln,
        pstyp TYPE ekpo-pstyp,
        END OF ty_ekpo1.

TYPES : BEGIN OF ty_afpo,
        aufnr TYPE afpo-aufnr,
        kdauf TYPE afpo-kdauf,
        kdpos TYPE afpo-kdpos,
        END OF ty_afpo.

TYPES:
  BEGIN OF t_mard,
    matnr TYPE mard-matnr,
    werks TYPE mard-werks,
    lgort TYPE mard-lgort,
    lgpbe TYPE mard-lgpbe,
  END OF t_mard,
  tt_mard TYPE STANDARD TABLE OF t_mard.

  TYPES : BEGIN OF TY_CDPOS,
  OBJECTID TYPE CDPOS-OBJECTID,
  CHANGENR TYPE CDPOS-CHANGENR,
  VALUE_OLD TYPE CDPOS-VALUE_OLD,
  END OF TY_CDPOS.

  TYPES : BEGIN OF TY_CDHDR,
  OBJECTID TYPE CDPOS-OBJECTID,
  CHANGENR TYPE CDPOS-CHANGENR,
  END OF TY_CDHDR.


  TYPES : BEGIN OF ty_final,
          aufnr type aufm-aufnr,
          zeile type aufm-zeile,
          matnr type aufm-matnr,
          maktx type STRING,
          MENGE type aufm-menge,
          END OF ty_final.
