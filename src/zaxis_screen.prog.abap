*&---------------------------------------------------------------------*
*& Report ZAXIS_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAXIS_SCREEN.



SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-000.

  PARAMETERS: R_OPT1 RADIOBUTTON GROUP GRP1 USER-COMMAND RAD DEFAULT 'X',
              R_OPT2 RADIOBUTTON GROUP GRP1,
              R_OPT3 RADIOBUTTON GROUP GRP1.
*              R_OPT4 RADIOBUTTON GROUP GRP1.

SELECTION-SCREEN END OF BLOCK B1.

INITIALIZATION.
*  text-000 = 'Choose an Option'.

* Set labels for radio buttons (on the right)
  %_R_OPT1_%_APP_%-TEXT = 'Payment Run'.
  %_R_OPT2_%_APP_%-TEXT = 'UTR Response'.
  %_R_OPT3_%_APP_%-TEXT = 'Payment Run Report'.
*  %_R_OPT4_%_APP_%-TEXT = 'UTR Response Report'.

START-OF-SELECTION.
  IF R_OPT1 = 'X'.
*    SUBMIT ZHDFC_MAN_PAY_RUN_TCI VIA SELECTION-SCREEN AND RETURN .
    SUBMIT ZAXIS_MAN_PAY_RUN_TCI VIA SELECTION-SCREEN AND RETURN .
  ELSEIF R_OPT2 = 'X'.
    SUBMIT ZAXIS_STATUS_INQUIRY VIA SELECTION-SCREEN AND RETURN .
  ELSEIF R_OPT3 = 'X'.
    SUBMIT ZAXIS_STATUS_REQ_REPORT VIA SELECTION-SCREEN AND RETURN .
*  ELSEIF R_OPT4 = 'X'.
*    SUBMIT ZAXIS_STATUS_INQUIRY_REPORT VIA SELECTION-SCREEN  AND RETURN  .
  ENDIF.
