*&---------------------------------------------------------------------*
*&  Include           ZMTRL_LAST_CONSUMPTION_TOP
*&---------------------------------------------------------------------*
TABLES : mseg,makt.

TYPE-POOLS : slis.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat TYPE LINE OF slis_t_fieldcat_alv.
DATA : fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
TYPES : BEGIN OF ty_final,
          werks        TYPE mseg-werks,
          matnr        TYPE mseg-matnr,
*          maktx        TYPE makt-maktx,
          mattxt       TYPE text300,
          budat_mkpf   TYPE mseg-budat_mkpf,
          menge        TYPE mseg-menge,
          mblnr        TYPE mseg-mblnr,
          aufnr        TYPE mseg-aufnr,
          ebeln        TYPE mseg-ebeln,
          kostl        TYPE mseg-kostl,
          vbeln_im     TYPE mseg-vbeln_im,
          kdauf        TYPE mseg-kdauf,
*          refresh_on   TYPE c,
*          refresh_time TYPE c,
        END OF ty_final.

DATA :it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.
data : lv_bwart type bwart.

TYPES : BEGIN OF ty_down,
          werks        TYPE string,
          matnr        TYPE string,
          mattxt       TYPE string,
          budat_mkpf   TYPE string,
          menge        TYPE string,
          mblnr        TYPE string,
          aufnr        TYPE string,
          ebeln        TYPE string,
          kostl        TYPE string,
          vbeln_im     TYPE string,
          kdauf        TYPE string,
          ref_date     TYPE char11,
          ref_time     TYPE char15,
        END OF ty_down.

DATA :it_down TYPE TABLE OF ty_down,
      wa_down TYPE ty_down.

data: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.
