***&---------------------------------------------------------------------*
***& REPORT  ZSD_PACKINGLIST_DRVR
***&
***&---------------------------------------------------------------------*
***&
***&
***&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& REPORT  ZSD_PACKINGLIST_DRVR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZSD_PACKINGLIST_DRVR_NEW.
TABLES: VEKP.
*DATA: GT_VEKP LIKE VEKP OCCURS 0 WITH HEADER LINE.
DATA: GT_VEKP TYPE ZGT_VEKP1 .

*----------------------------------------------------------------------*
*      PRINT OF A DELIVERY NOTE BY SAPSCRIPT SMART FORMS               *
*----------------------------------------------------------------------*
*REPORT RLE_DELNOTE.

* DECLARATION OF DATA
INCLUDE RLE_DELNOTE_DATA_DECLARE.
* DEFINITION OF FORMS
INCLUDE RLE_DELNOTE_FORMS.
INCLUDE RLE_PRINT_FORMS.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING    US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM PROCESSING USING    PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LEDLV_PRINT_DATA_TO_READ.
  DATA: LS_DLV_DELNOTE        TYPE LEDLV_DELNOTE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
  DATA: LF_FORMNAME           TYPE TDSFNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.

* SMARTFORM FROM CUSTOMIZING TABLE TNAPR
  LF_FORMNAME = TNAPR-SFORM.

* DETERMINE PRINT DATA
  PERFORM SET_PRINT_DATA_TO_READ USING    LF_FORMNAME
                                 CHANGING LS_PRINT_DATA_TO_READ
                                 CF_RETCODE.

*  IF CF_RETCODE = 0.
* SELECT PRINT DATA
    PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                     CHANGING LS_ADDR_KEY
                              LS_DLV_DELNOTE
                              CF_RETCODE.
*  ENDIF.

*  IF CF_RETCODE = 0.
    PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                            CHANGING LS_CONTROL_PARAM
                                     LS_COMPOSER_PARAM
                                     LS_RECIPIENT
                                     LS_SENDER
                                     CF_RETCODE.
*  ENDIF.

*  IF CF_RETCODE = 0.
** DETERMINE SMARTFORM FUNCTION MODULE FOR DELIVERY NOTE
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*         EXPORTING  FORMNAME           = LF_FORMNAME
**                 VARIANT            = ' '
**                 DIRECT_CALL        = ' '
*         IMPORTING  FM_NAME            = LF_FM_NAME
*         EXCEPTIONS NO_FORM            = 1
*                    NO_FUNCTION_MODULE = 2
*                    OTHERS             = 3.
*    IF SY-SUBRC <> 0.
**   ERROR HANDLING
*      CF_RETCODE = SY-SUBRC.
*      PERFORM PROTOCOL_UPDATE.
*    ENDIF.
*  ENDIF.

  DATA: GV_FM_NAME         TYPE RS38L_FNAM, " FM Name
        GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
        GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
  DATA : GV_FORM_NAME TYPE FPNAME.

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


  GV_FORM_NAME = 'ZSD_PACKINGLIST_EXPORTFORM_NEW'.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = GV_FORM_NAME
    IMPORTING
      E_FUNCNAME = GV_FM_NAME.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.

  SELECT * FROM VEKP INTO TABLE GT_VEKP
                       WHERE VPOBJKEY = LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.



  CALL FUNCTION GV_FM_NAME                            "'/1BCDWB/SM00000180'
    EXPORTING
*      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
      GT_VEKP           = GT_VEKP
      IS_NAST           = NAST
      IS_DLV_DELNOTE    = LS_DLV_DELNOTE
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


*  IF CF_RETCODE = 0.
*   CALL SMARTFORM DELIVERY NOTE

*    CALL FUNCTION LF_FM_NAME
*      EXPORTING
*   ARCHIVE_INDEX        = TOA_DARA
*                  ARCHIVE_PARAMETERS   = ARC_PARAMS
*                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
**                 MAIL_APPL_OBJ        =
*                  MAIL_RECIPIENT       = LS_RECIPIENT
*                  MAIL_SENDER          = LS_SENDER
*                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
*                  USER_SETTINGS        = ' '
*                 I_VBELN               =  LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
*                    NAST              = NAST
**     IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
**       JOB_OUTPUT_INFO            =
**       JOB_OUTPUT_OPTIONS         =
**     EXCEPTIONS
**       FORMATTING_ERROR           = 1
**       INTERNAL_ERROR             = 2
**       SEND_ERROR                 = 3
**       USER_CANCELED              = 4
**       OTHERS                     = 5
*              .
*    IF SY-SUBRC <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**    ENDIF.
*

*  CLEAR: LS_CONTROL_PARAM .

****    CALL FUNCTION LF_FM_NAME
****         EXPORTING
****                  ARCHIVE_INDEX        = TOA_DARA
****                  ARCHIVE_PARAMETERS   = ARC_PARAMS
****                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
*****                 MAIL_APPL_OBJ        =
****                  MAIL_RECIPIENT       = LS_RECIPIENT
****                  MAIL_SENDER          = LS_SENDER
****                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
****                  USER_SETTINGS        = ' '
****                  IS_DLV_DELNOTE       = LS_DLV_DELNOTE
****                  IS_NAST              = NAST
****          TABLES
****                     GT_VEKP            = GT_VEKP
****
****       EXCEPTIONS FORMATTING_ERROR     = 1
****                  INTERNAL_ERROR       = 2
****                  SEND_ERROR           = 3
****                  USER_CANCELED        = 4
****                  OTHERS               = 5.
****    IF SY-SUBRC <> 0.
*****   ERROR HANDLING
****      CF_RETCODE = SY-SUBRC.
****      PERFORM PROTOCOL_UPDATE.
*****     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
****      PERFORM ADD_SMFRM_PROT.                  "INS_HP_335958
****    ENDIF.
****  ENDIF.




* GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

*ENDFORM.                    "PROCESSING





**
**REPORT  zsd_packinglist_drvr.
**TABLES: vekp.
**"DATA: gt_vekp LIKE vekp OCCURS 0 WITH HEADER LINE.
**DATA: gt_vekp TYPE zgt_vekp1. "VEKP ." ZGT_VEKP1." OCCURS 0 WITH HEADER LINE.
**
**
***----------------------------------------------------------------------*
***      PRINT OF A DELIVERY NOTE BY SAPSCRIPT SMART FORMS               *
***----------------------------------------------------------------------*
***REPORT RLE_DELNOTE.
**
*** DECLARATION OF DATA
**INCLUDE rle_delnote_data_declare.
*** DEFINITION OF FORMS
**INCLUDE rle_delnote_forms.
**INCLUDE rle_print_forms.
**
***---------------------------------------------------------------------*
***       FORM ENTRY
***---------------------------------------------------------------------*
**FORM entry USING return_code us_screen.
**
**  DATA: lf_retcode TYPE sy-subrc.
**  xscreen = us_screen.
**  PERFORM processing USING    us_screen
**                     CHANGING lf_retcode.
**  IF lf_retcode NE 0.
**    return_code = 1.
**  ELSE.
**    return_code = 0.
**  ENDIF.
**
**ENDFORM.                    "ENTRY
***---------------------------------------------------------------------*
***       FORM PROCESSING                                               *
***---------------------------------------------------------------------*
**FORM processing USING    proc_screen
**                CHANGING cf_retcode.
**
**  DATA: ls_print_data_to_read TYPE ledlv_print_data_to_read.
**  "DATA: ls_dlv_delnote        TYPE ledlv_delnote.
**  DATA: ls_dlv_delnote        TYPE ledlv_delnote.
**  DATA: lf_fm_name            TYPE rs38l_fnam.
**  DATA: ls_control_param      TYPE ssfctrlop.
**  DATA: ls_composer_param     TYPE ssfcompop.
**
**  DATA: ls_recipient          TYPE swotobjid.
**  DATA: ls_sender             TYPE swotobjid.
**  DATA: lf_formname           TYPE tdsfname.
**  DATA: ls_addr_key           LIKE addr_key.
**  "data: GT_VEKP type table of  VEKP.
**  DATA: nast TYPE nast.
**  DATA: gt_vekp1 TYPE TABLE OF zgt_vekp1.
**
*** SMARTFORM FROM CUSTOMIZING TABLE TNAPR
**  lf_formname = tnapr-sform.
**
*** DETERMINE PRINT DATA
**  PERFORM set_print_data_to_read USING    lf_formname
**                                 CHANGING ls_print_data_to_read
**                                 cf_retcode.
**
**  IF cf_retcode = 0.
*** SELECT PRINT DATA
**    PERFORM get_data USING    ls_print_data_to_read
**                     CHANGING ls_addr_key
**                              ls_dlv_delnote
**                              cf_retcode.
**  ENDIF.
**
**  IF cf_retcode = 0.
**    PERFORM set_print_param USING    ls_addr_key
**                            CHANGING ls_control_param
**                                     ls_composer_param
**                                     ls_recipient
**                                     ls_sender
**                                     cf_retcode.
**  ENDIF.
**
***  IF CF_RETCODE = 0.
**** DETERMINE SMARTFORM FUNCTION MODULE FOR DELIVERY NOTE
***    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
***         EXPORTING  FORMNAME           = LF_FORMNAME
****                 VARIANT            = ' '
****                 DIRECT_CALL        = ' '
***         IMPORTING  FM_NAME            = LF_FM_NAME
***         EXCEPTIONS NO_FORM            = 1
***                    NO_FUNCTION_MODULE = 2
***                    OTHERS             = 3.
***    IF SY-SUBRC <> 0.
****   ERROR HANDLING
***      CF_RETCODE = SY-SUBRC.
***      PERFORM PROTOCOL_UPDATE.
***    ENDIF.
***  ENDIF.
***
***  SELECT * FROM VEKP INTO TABLE GT_VEKP
***                       WHERE VPOBJKEY = LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
***
***  IF CF_RETCODE = 0.
****   CALL SMARTFORM DELIVERY NOTE
***
****    CALL FUNCTION LF_FM_NAME
****      EXPORTING
****   ARCHIVE_INDEX        = TOA_DARA
****                  ARCHIVE_PARAMETERS   = ARC_PARAMS
****                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
*****                 MAIL_APPL_OBJ        =
****                  MAIL_RECIPIENT       = LS_RECIPIENT
****                  MAIL_SENDER          = LS_SENDER
****                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
****                  USER_SETTINGS        = ' '
****                 I_VBELN               =  LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
****                    NAST              = NAST
*****     IMPORTING
*****       DOCUMENT_OUTPUT_INFO       =
*****       JOB_OUTPUT_INFO            =
*****       JOB_OUTPUT_OPTIONS         =
*****     EXCEPTIONS
*****       FORMATTING_ERROR           = 1
*****       INTERNAL_ERROR             = 2
*****       SEND_ERROR                 = 3
*****       USER_CANCELED              = 4
*****       OTHERS                     = 5
****              .
****    IF SY-SUBRC <> 0.
****** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
******         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*****    ENDIF.
****
***
***    CALL FUNCTION LF_FM_NAME
***         EXPORTING
***                  ARCHIVE_INDEX        = TOA_DARA
***                  ARCHIVE_PARAMETERS   = ARC_PARAMS
***                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
****                 MAIL_APPL_OBJ        =
***                  MAIL_RECIPIENT       = LS_RECIPIENT
***                  MAIL_SENDER          = LS_SENDER
***                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
***                  USER_SETTINGS        = ' '
***                  IS_DLV_DELNOTE       = LS_DLV_DELNOTE
***                  IS_NAST              = NAST
***          TABLES
***                     GT_VEKP            = GT_VEKP
***
***       EXCEPTIONS FORMATTING_ERROR     = 1
***                  INTERNAL_ERROR       = 2
***                  SEND_ERROR           = 3
***                  USER_CANCELED        = 4
***                  OTHERS               = 5.
***    IF SY-SUBRC <> 0.
****   ERROR HANDLING
***      CF_RETCODE = SY-SUBRC.
***      PERFORM PROTOCOL_UPDATE.
****     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
***      PERFORM ADD_SMFRM_PROT.                  "INS_HP_335958
***    ENDIF.
***  ENDIF.
**
**
**
**
*** GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
*** PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958
**
**
**
**
**  "changes from here
**
**  IF cf_retcode = 0.
**    DATA: lv_output_params TYPE sfpoutputparams.
**
**    CALL FUNCTION 'FP_JOB_OPEN'
**      CHANGING
**        ie_outputparams = lv_output_params
**      EXCEPTIONS
**        cancel          = 1
**        usage_error     = 2
**        system_error    = 3
**        internal_error  = 4
**        OTHERS          = 5.
**
**    IF sy-subrc <> 0.
***   ERROR HANDLING
**      cf_retcode = sy-subrc.
**      PERFORM protocol_update.
**    ENDIF.
**  ENDIF.
**
**  SELECT * FROM vekp INTO TABLE gt_vekp
**                       WHERE vpobjkey = ls_dlv_delnote-hd_gen-deliv_numb.
**
**  IF cf_retcode = 0.
**
**    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
**      EXPORTING
**        i_name     = lf_formname
**      IMPORTING
**        e_funcname = lf_fm_name
***       E_INTERFACE_TYPE           =
***       EV_FUNCNAME_INBOUND        =
**      .
**
**
**"Added
**CALL FUNCTION   LF_FM_NAME "'/1BCDWB/SM00000107'
**  EXPORTING
***   /1BCDWB/DOCPARAMS        =
***   ARCHIVE_INDEX            =
***   ARCHIVE_INDEX_TAB        =
***   ARCHIVE_PARAMETERS       =
***   CONTROL_PARAMETERS       =
***   MAIL_APPL_OBJ            =
***   MAIL_RECIPIENT           =
***   MAIL_SENDER              =
***   OUTPUT_OPTIONS           =
***   USER_SETTINGS            = 'X'
**    is_dlv_delnote           = LS_DLV_DELNOTE
**    is_nast                  = NAST
**    gt_vekp                  = GT_VEKP
*** IMPORTING
***   /1BCDWB/FORMOUTPUT       =
** EXCEPTIONS
**   USAGE_ERROR              = 1
**   SYSTEM_ERROR             = 2
**   INTERNAL_ERROR           = 3
**   FORMATTING_ERROR         = 4
**   SEND_ERROR               = 5
**   USER_CANCELED            = 6
**   OTHERS                   = 7
**          .
**
**    IF sy-subrc <> 0.
**   "ERROR HANDLING
**      cf_retcode = sy-subrc.
**      PERFORM protocol_update.
***     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
**      PERFORM add_smfrm_prot.                  "INS_HP_335958
**    ENDIF.
**
**
***  CALL FUNCTION LF_FM_NAME
***         EXPORTING
***                  ARCHIVE_INDEX        = TOA_DARA
***                  ARCHIVE_PARAMETERS   = ARC_PARAMS
***                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
****                 MAIL_APPL_OBJ        =
***                  MAIL_RECIPIENT       = LS_RECIPIENT
***                  MAIL_SENDER          = LS_SENDER
***                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
***                  USER_SETTINGS        = ' '
***                  IS_DLV_DELNOTE       = LS_DLV_DELNOTE
***                  IS_NAST              = NAST
***          TABLES
***                     GT_VEKP            = GT_VEKP
***
***       EXCEPTIONS FORMATTING_ERROR     = 1
***                  INTERNAL_ERROR       = 2
***                  SEND_ERROR           = 3
***                  USER_CANCELED        = 4
***                  OTHERS               = 5.
**
**
**
**    "  GT_VEKP1 = CORRESPONDING ZGT_VEKP1( GT_VEKP ).
**
**
**
**    .
**
**
**
***    CALL FUNCTION lf_fm_name " '/1BCDWB/SM00000129'
***      EXPORTING
****       /1BCDWB/DOCPARAMS        =
***        user_settings  = space
***        is_dlv_delnote = ls_dlv_delnote
***        is_nast        = nast
**** IMPORTING
****       /1BCDWB/FORMOUTPUT       =
***      EXCEPTIONS
***        usage_error    = 1
***        system_error   = 2
***        internal_error = 3
***        OTHERS         = 4.
***
**
**
**    CALL FUNCTION 'FP_JOB_CLOSE'
**    EXCEPTIONS
**      usage_error    = 1
**      system_error   = 2
**      internal_error = 3
**      OTHERS         = 4.
**
**  IF sy-subrc <> 0.
**    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
**  ENDIF.
***
***
***CALL FUNCTION LF_FM_NAME "'/1BCDWB/SM00000107'
***  EXPORTING
****   /1BCDWB/DOCPARAMS        =
***   ARCHIVE_INDEX            = TOA_DARA
****   ARCHIVE_INDEX_TAB        =
***   ARCHIVE_PARAMETERS       = ARC_PARAMS
***   CONTROL_PARAMETERS       =  LS_CONTROL_PARAM
***"   MAIL_APPL_OBJ            =
***   MAIL_RECIPIENT           = LS_RECIPIENT
***   MAIL_SENDER              = LS_SENDER
***   OUTPUT_OPTIONS           = LS_COMPOSER_PARAM
****   USER_SETTINGS            = 'X'
***    is_dlv_delnote           = ls_dlv_delnote
***    is_nast                  =  nast
***    gt_vekp                  = gt_vekp
**** IMPORTING
****   /1BCDWB/FORMOUTPUT       =
*** EXCEPTIONS
***   USAGE_ERROR              = 1
***   SYSTEM_ERROR             = 2
***   INTERNAL_ERROR           = 3
***   FORMATTING_ERROR         = 4
***   SEND_ERROR               = 5
***   USER_CANCELED            = 6
***   OTHERS                   = 7
***          .
**
**
**
**
***    IF sy-subrc <> 0.
****   ERROR HANDLING
***      cf_retcode = sy-subrc.
***      PERFORM protocol_update.
****     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
***      PERFORM add_smfrm_prot.                  "INS_HP_335958
***    ENDIF.
**
**
***
***  ENDIF.
**
**
**
**
**endif.
**
**
**ENDFORM.                    "PROCESSING
