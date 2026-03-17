*&---------------------------------------------------------------------*
*& Report ZMTRL_MOVEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
***************Below Report is developed for need dump for 541 movement type
******From table J_1IG_SUBCON for only India ( PL01) plant .
*&Report: ZMTRL_MOVEMENT_541
*&Transaction :ZMTRL_MOVEMENT
*&Functional Cosultant: MEghana Barhate
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915897       PRIMUSABAP   PRIMUS:INDIA:101690:ZMTRL_MOVEMENT:541 &542 DUMP NEW REPORT
*&Date: 1. 09.04.2025
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMTRL_MOVEMENT.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE xyz.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.

INITIALIZATION.
xyz = 'SelectSubcontracting Dump '(tt1).
AT SELECTION-SCREEN.
  IF r1 = 'X'.
    SUBMIT ZMTRL_MOVEMENT_541 VIA SELECTION-SCREEN AND RETURN.
  ELSEIF r2 = 'X'.
    SUBMIT ZMTRL_MOVEMENT_542 VIA SELECTION-SCREEN AND RETURN.
  ENDIF.
