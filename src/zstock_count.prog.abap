*&---------------------------------------------------------------------*
*& Report ZSTOCK_COUNT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTOCK_COUNT.

INCLUDE ZSTOCK_COUNT_TOP.

INCLUDE ZSTOCK_COUNT_F01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_VNAME-LOW.
  PERFORM VNAME.

START-OF-SELECTION.

  DATA: LO_OBJ TYPE REF TO CL_DATA.

  CREATE OBJECT LO_OBJ.

  LO_OBJ->GET_DATA( ).

  LO_OBJ->FILTER_DATA( ).

  LO_OBJ->DISPLAY_DATA( ).
