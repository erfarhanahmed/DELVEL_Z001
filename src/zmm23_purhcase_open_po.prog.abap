*&---------------------------------------------------------------------*
*& Report ZMM22_PURHCASE_OPEN_PO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM23_PURHCASE_OPEN_PO.

INCLUDE ZMM23_PURHCASE_OPEN_PO_TOP.

INCLUDE ZMM23_PURHCASE_OPEN_PO_F01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_VNAME-LOW.
  PERFORM VNAME.

START-OF-SELECTION.

  CREATE OBJECT LO_OBJ.

  LO_OBJ->GET_DATA( ).

  LO_OBJ->FILTER_DATA( ).

*  LO_OBJ->DISPLAY_DATA( ).
