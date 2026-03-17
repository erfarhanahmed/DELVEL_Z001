*&---------------------------------------------------------------------*
*& Report ZQUALITY_COUNT_SEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zquality_count_sel.
TABLES: t001,t001w,qals.

SELECTION-SCREEN : BEGIN OF BLOCK b1.
  SELECT-OPTIONS: p_bukrs FOR t001-bukrs NO INTERVALS NO-EXTENSION,
                  p_werks FOR t001w-werks NO INTERVALS NO-EXTENSION,
                  s_budat FOR qals-budat.

SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN.
  EXPORT s_budat TO MEMORY ID 'SEL_SCREEN'.
  EXPORT p_werks TO MEMORY ID 'SEL_SCREEN'.
  EXPORT p_bukrs TO MEMORY ID 'SEL_SCREEN'.

START-OF-SELECTION.
  SELECT budat FROM qals INTO TABLE @data(it_budat) WHERE budat in @s_budat.
    delete ADJACENT DUPLICATES FROM it_budat.
    BREAK-POINT.
