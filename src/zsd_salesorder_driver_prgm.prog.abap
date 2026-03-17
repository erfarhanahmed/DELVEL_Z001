*&---------------------------------------------------------------------*
*& Report ZSD_SALESORDER_DRIVER_PRGM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSD_SALESORDER_DRIVER_PRGM.



*PARAMETERS VBELN TYPE mseg-VBELN OBLIGATORY.
DATA : V_VBELN TYPE VBRK-VBELN,
       XSCREEN TYPE C.
TABLES: NAST.
DATA: GV_FM_NAME         TYPE RS38L_FNAM, " FM Name
      GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
      GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
DATA : GV_FORM_NAME TYPE FPNAME.

START-OF-SELECTION.


*v_VBELN = VBELN.
FORM ENTRY USING RETURN_CODE LIKE SY-SUBRC
                 US_SCREEN   TYPE C.
  DATA: LF_RETCODE TYPE SY-SUBRC.
  XSCREEN = US_SCREEN.                 "Screen Used for Display
  PERFORM PROCESSING USING    US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.
ENDFORM.                               "ENTRY

FORM PROCESSING USING    XSCREEN    TYPE C
                CHANGING CF_RETCODE LIKE SY-SUBRC.
  MOVE NAST-OBJKY(10) TO V_VBELN.

  GV_FORM_NAME = 'ZSD_SALESORDER_FORM'.

  "ADDITION OF CODE BY MADHAVI
  GS_FP_OUTPUTPARAMS-DEVICE = 'PRINTER'.
  GS_FP_OUTPUTPARAMS-DEST = 'LP01'.
  IF SY-UCOMM = 'PRNT'.
    GS_FP_OUTPUTPARAMS-NODIALOG = 'X'.
    GS_FP_OUTPUTPARAMS-PREVIEW = ''.
    GS_FP_OUTPUTPARAMS-REQIMM = 'X'.
  ELSE.
    GS_FP_OUTPUTPARAMS-NODIALOG = ''.
    GS_FP_OUTPUTPARAMS-PREVIEW = 'X'.
  ENDIF.


  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = GS_FP_OUTPUTPARAMS
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.
*&---------------------------------------------------------------------*
**&&~~ Get the Function module name based on Form Name
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = GV_FORM_NAME
    IMPORTING
      E_FUNCNAME = GV_FM_NAME.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.
*-----------------------------------------------------------------------------

  CALL FUNCTION GV_FM_NAME "'/1BCDWB/SM00000018'
    EXPORTING
      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
      LV_VBELN          = V_VBELN
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    EXCEPTIONS
      USAGE_ERROR       = 1
      SYSTEM_ERROR      = 2
      INTERNAL_ERROR    = 3
      OTHERS            = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*&---------------------------------------------------------------------*
*&---- Close the spool job
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* <error handling>
  ENDIF.
*&---------------------------------------------------------------------*
ENDFORM.
