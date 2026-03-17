*----------------------------------------------------------------------*
***INCLUDE ZQUALITY_COUNT_USER_COMMANDI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.



  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'EXECUTE'.
      IF rad1 EQ  'X'.
        PERFORM ud_pending.
        IF it_final IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ELSEIF rad2 EQ 'X'.
        PERFORM ud_done_a.
        IF it_final1 IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ELSEIF rad3 EQ 'X'.
        PERFORM ud_done_r.
        IF it_final2 IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ELSEIF rad4 EQ 'X'.
        PERFORM srn_a.
        IF it_final3 IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ELSEIF rad5 EQ 'X'.
        PERFORM rework_a.
        IF it_final4 IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ELSEIF rad6 EQ 'X'.
        PERFORM scrap_a.
        IF it_final5 IS NOT INITIAL.
          CALL SCREEN '0200'.
        ELSE.
          MESSAGE 'NO DATA FOUND' TYPE 'W'.
        ENDIF.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validation INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
  IF s_budat IS INITIAL.
    MESSAGE 'Enter Posting Date.' TYPE 'W'.
  ELSEIF p_werks IS INITIAL.
    MESSAGE 'Enter Plant.' TYPE 'W'.
  ENDIF.

ENDMODULE.
