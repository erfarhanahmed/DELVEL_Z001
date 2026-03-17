*&---------------------------------------------------------------------*
*& Include          ZUS_MATERIAL_EXTENSION_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t06 .
PARAMETERS : p_file LIKE rlgrap-filename .
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN: PUSHBUTTON 2(40) but1 USER-COMMAND cli1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN SKIP.

INITIALIZATION.
  but1 = 'Download Excel Template'.
AT SELECTION-SCREEN.
  IF sscrfields  = 'CLI1'.
PERFORM dOWNLOAD_EXCEL.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.
