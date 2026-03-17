*----------------------------------------------------------------------*
***INCLUDE ZPRODUCTION_COUNT_USER_COMMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

CASE sy-ucomm.

  WHEN '&F03'.
    LEAVE PROGRAM.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'EXECUTE'.

      PERFORM SHIRWAL_PENDING1.
      Perform Kapurhol_Pending1.
      PERFORM SHIRWAL_PENDING2.
      Perform Kapurhol_Pending2.


      CALL SCREEN 0200.

      ENDCASE.
ENDMODULE.
