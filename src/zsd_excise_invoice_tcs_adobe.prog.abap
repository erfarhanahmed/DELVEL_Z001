*&---------------------------------------------------------------------*
*& Report ZSD_EXCISE_INVOICE_TCS_ADOBE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSD_EXCISE_INVOICE_TCS_ADOBE.

DATA : V_VBELN TYPE VBRK-VBELN,
       XSCREEN TYPE C.
TABLES: NAST.
DATA: GV_FM_NAME         TYPE RS38L_FNAM, " FM Name
      GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
      GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
DATA : GV_FORM_NAME TYPE FPNAME.
data:IS_PRINT_DATA_TO_READ type LBBIL_PRINT_DATA_TO_READ,
      lS_BIL_INVOICE        TYPE LBBIL_INVOICE.
TYPES: BEGIN OF ty_final,
        head type char70,
       END OF ty_final.
Data: lt_final type STANDARD TABLE OF ty_final,
      wa_final type ty_final.
Data :text type char30.
START-OF-SELECTION.

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


        IS_PRINT_DATA_TO_READ-hd_gen      = 'X'.
        IS_PRINT_DATA_TO_READ-hd_adr      = 'X'.
        IS_PRINT_DATA_TO_READ-hd_gen_descript  = 'X'.
        IS_PRINT_DATA_TO_READ-hd_org       = 'X'.
        IS_PRINT_DATA_TO_READ-hd_part_add   = 'X'.
        IS_PRINT_DATA_TO_READ-hd_kond      = 'X'.
        IS_PRINT_DATA_TO_READ-hd_fin      = 'X'.
        IS_PRINT_DATA_TO_READ-hd_ref      = 'X'.
        IS_PRINT_DATA_TO_READ-hd_tech     = 'X'.
        IS_PRINT_DATA_TO_READ-it_gen    = 'X'.
        IS_PRINT_DATA_TO_READ-it_adr        = 'X'.
        IS_PRINT_DATA_TO_READ-it_price     = 'X'.
        IS_PRINT_DATA_TO_READ-it_kond   = 'X'.
        IS_PRINT_DATA_TO_READ-it_ref       = 'X'.
        IS_PRINT_DATA_TO_READ-it_refdlv    = 'X'.
        IS_PRINT_DATA_TO_READ-it_reford     = 'X'.
        IS_PRINT_DATA_TO_READ-it_refpurord   = 'X'.
        IS_PRINT_DATA_TO_READ-it_refvag      = 'X'.
        IS_PRINT_DATA_TO_READ-it_refvg2      = 'X'.
        IS_PRINT_DATA_TO_READ-it_refvkt      = 'X'.
        IS_PRINT_DATA_TO_READ-it_tech       = 'X'.
        IS_PRINT_DATA_TO_READ-it_fin         = 'X'.
        IS_PRINT_DATA_TO_READ-it_confitm     = 'X'.
        IS_PRINT_DATA_TO_READ-it_confbatch     = 'X'.
        IS_PRINT_DATA_TO_READ-msr_hd           = 'X'.
        IS_PRINT_DATA_TO_READ-msr_it           = 'X'.

        wa_final-head = 'ORIGINAL FOR RECIPIENT'.
        APPEND wa_final to lt_final.
        CLear : wa_final.


          wa_final-head = 'DUPLICATE FOR TRANSPORTER'.
        APPEND wa_final to lt_final.
        CLear : wa_final.


          wa_final-head = 'TRIPLICATE FOR SUPPLIER/SECURITY'.
        APPEND wa_final to lt_final.
        CLear : wa_final.

          wa_final-head = 'QUADRUPLICATE FOR ACCOUNT COPY'.
        APPEND wa_final to lt_final.
        CLear : wa_final.



        wa_final-head = 'QUADRUPLICATE FOR ACCOUNT COPY'.
        APPEND wa_final to lt_final.
        CLear : wa_final.


CALL FUNCTION 'LB_BIL_INV_OUTP_READ_PRTDATA'
    EXPORTING
      IF_BIL_NUMBER         = NAST-OBJKY
      IF_PARVW              = NAST-PARVW
      IF_PARNR              = NAST-PARNR
      IF_LANGUAGE           = NAST-SPRAS
      IS_PRINT_DATA_TO_READ = IS_PRINT_DATA_TO_READ
    IMPORTING
      ES_BIL_INVOICE        = lS_BIL_INVOICE
    EXCEPTIONS
      RECORDS_NOT_FOUND     = 1
      RECORDS_NOT_REQUESTED = 2
      OTHERS                = 3.


    GV_FORM_NAME = 'ZSF_TAX_TCS_SFP'.

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


  Data : lV_copies type STRING,
          lv_cal type string.


  lV_copies = GS_FP_OUTPUTPARAMS-COPIES .



  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = GV_FORM_NAME
    IMPORTING
      E_FUNCNAME = GV_FM_NAME.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.

*-----------------------------------------------------------------------------


    LOOP AT lt_final INTO wa_final. .
      if sy-tabix = 1.
        read TABLE lt_final INTO wa_final INDEX 1.
        text = 'Page 1 of 5'.
        ELSEIF sy-tabix = 2.
           read TABLE lt_final INTO wa_final INDEX 2.
           text = 'Page 2 of 5'.
        ELSEIF sy-tabix = 3.
           read TABLE lt_final INTO wa_final INDEX 3.
           text = 'Page 3 of 5'.
        ELSEIF sy-tabix = 4.
           read TABLE lt_final INTO wa_final INDEX 4.
           text = 'Page 4 of 5'.
        ELSEIF sy-tabix = 5.
           read TABLE lt_final INTO wa_final INDEX 5.
           text = 'Page 5 of 5'.


        ENDIF.



  DO  lV_copies TIMES.

    lv_cal = lv_cal + 1.
*  CALL FUNCTION GV_FM_NAME "'/1BCDWB/SM00000018'
*    EXPORTING
*      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
*      LV_VBELN          = V_VBELN
*      head = wa_final-head
*      lS_BIL_INVOICE          = lS_BIL_INVOICE-HD_GEN
*      LS_BIL_HD_ORG            = lS_BIL_INVOICE-HD_ORG
*      LS_BIL_HD_ref           = lS_BIL_INVOICE-HD_REF
*      LS_BIL_HD_adr           = lS_BIL_INVOICE-HD_adr
*      text = text
*
** IMPORTING
**     /1BCDWB/FORMOUTPUT       =
*    EXCEPTIONS
*      USAGE_ERROR       = 1
*      SYSTEM_ERROR      = 2
*      INTERNAL_ERROR    = 3
*      OTHERS            = 4.
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.

    CALL FUNCTION  GV_FM_NAME                   " '/1BCDWB/SM00000094'
      EXPORTING
       /1BCDWB/DOCPARAMS        = GS_FP_DOCPARAMS
        TEXT                     = text
        HEAD                     = wa_final-head
        LS_BIL_HD_ADR            = lS_BIL_INVOICE-HD_adr
        LS_BIL_HD_ORG            = lS_BIL_INVOICE-HD_ORG
        LS_BIL_HD_REF            = lS_BIL_INVOICE-HD_REF
        LS_BIL_INVOICE           = lS_BIL_INVOICE-HD_GEN
        LV_CAL                   = lv_cal
        LV_VBELN                 = V_VBELN
*     IMPORTING
*       /1BCDWB/FORMOUTPUT       =
     EXCEPTIONS
       USAGE_ERROR              = 1
       SYSTEM_ERROR             = 2
       INTERNAL_ERROR           = 3
       OTHERS                   = 4
              .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.











   ENDDO.
  ENDloop.

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
