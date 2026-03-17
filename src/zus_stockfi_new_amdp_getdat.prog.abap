*&---------------------------------------------------------------------*
*& Include          ZUS_STOCKFI_NEW_AMDP_GETDAT
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .
IF  S_MATNR[] is INITIAL.
  SELECT matnr
             FROM MARC
             INTO TABLE @it_matnr
            WHERE matnr in @S_MATNR
              and WERKS in @S_WERKS.
else.
SELECT matnr
            FROM mara
            INTO TABLE @it_matnr
            WHERE matnr in @S_MATNR.
ENDIF.

*it_matnr = VALUE ztt_matnr_key(
*              FOR ls_matnr IN s_matnr
*              ( matnr = ls_matnr-low )
*           ).
select werks
         FROM t001w
         into TABLE @IT_WERKS
        WHERE WERKS in @s_werks.

*IT_WERKS = VALUE ztt_werks_key(
*             FOR ls_werks in s_werks
*             ( werks = ls_werks-low )
*              ).

 zcl_us_stockbank_amdp=>GET_LT_SORT(
  EXPORTING
    IT_MATNR = it_matnr
    IT_WERKS = it_werks
  IMPORTING
    ET_SORT  = LT_ET_SORT
    ).
*  CATCH CX_AMDP_EXECUTION_FAILED.
*ENDTRY.
ENDFORM.
