*&---------------------------------------------------------------------*
*& Report ZUS_SD_INVOICE_DRVR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZUS_SD_INVOICE_DRVR_TR.
INCLUDE ZRLB_INVOICE_DATA_DECLARE.
INCLUDE ZRLB_INVOICE_FORM08.
**INCLUDE ZUS_SD_INVOICE_DRVR_FORM01.
INCLUDE ZRLB_PRINT_FORMS09.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING US_SCREEN
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
FORM PROCESSING USING PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ.
  DATA: LS_BIL_INVOICE TYPE LBBIL_INVOICE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
  DATA: LF_FORMNAME           TYPE TDSFNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.
  DATA: LS_DLV-LAND           LIKE VBRK-LAND1.
  DATA: LS_JOB_INFO           TYPE SSFCRESCL.

* SmartForm from customizing table TNAPR
  LF_FORMNAME = TNAPR-SFORM.

* BEGIN: Country specific extension for Hungary
  DATA: LV_CCNUM TYPE IDHUCCNUM,
        LV_ERROR TYPE C.

* If a valid entry exists for the form in customizing view
* IDHUBILLINGOUT then the localized output shall be used.
  SELECT SINGLE CCNUM INTO LV_CCNUM FROM IDHUBILLINGOUT WHERE
    KSCHL = NAST-KSCHL.

  IF SY-SUBRC EQ 0.
    IF LV_CCNUM IS INITIAL.
      LV_CCNUM = 1.
    ENDIF.
***
    IF ( NAST-DELET IS INITIAL OR NAST-DIMME IS INITIAL ).

      NAST-DELET = 'X'.
      NAST-DIMME = 'X'.

      SY-MSGID = 'IDFIHU'.
      SY-MSGTY = 'W'.
      SY-MSGNO = 201.
      SY-MSGV1 = NAST-OBJKY.

      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          MSG_ARBGB = SY-MSGID
          MSG_NR    = SY-MSGNO
          MSG_TY    = SY-MSGTY
          MSG_V1    = SY-MSGV1
          MSG_V2    = ''
          MSG_V3    = ''
          MSG_V4    = ''
        EXCEPTIONS
          OTHERS    = 1.
    ENDIF.
  ELSE.
    CLEAR LV_CCNUM.
  ENDIF.
**** END: Country specific extension for Hungary
***
**** determine print data
  PERFORM SET_PRINT_DATA_TO_READ USING    LF_FORMNAME
                                 CHANGING LS_PRINT_DATA_TO_READ
                                 CF_RETCODE.

***  IF cf_retcode = 0.
**** select print data
  PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                   CHANGING LS_ADDR_KEY
                            LS_DLV-LAND
                            LS_BIL_INVOICE
                            CF_RETCODE.
***  ENDIF.
***
***  IF cf_retcode = 0.
  PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                                   LS_DLV-LAND
                          CHANGING LS_CONTROL_PARAM
                                   LS_COMPOSER_PARAM
                                   LS_RECIPIENT
                                   LS_SENDER
                                   CF_RETCODE.
***  ENDIF.

*  IF cf_retcode = 0.
* determine smartform function module for invoice

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME           = LF_FORMNAME
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = LF_FM_NAME
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.
  IF SY-SUBRC <> 0.
    CF_RETCODE = SY-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.


*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = lf_formname
**     variant            = ' '
**     direct_call        = ' '
*    IMPORTING
*      fm_name            = lf_fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
**   error handling
*    cf_retcode = sy-subrc.
*    PERFORM protocol_update.
*  ENDIF.
**  ENDIF.

***  IF cf_retcode = 0.
***    PERFORM check_repeat.
***    IF ls_composer_param-tdcopies EQ 0.
***      nast_anzal = 1.
***    ELSE.
***      nast_anzal = ls_composer_param-tdcopies.
***    ENDIF.
  LS_COMPOSER_PARAM-TDCOPIES = 5.
***
***    DO nast_anzal TIMES.
**** In case of repetition only one time archiving
***      IF sy-index > 1 AND nast-tdarmod = 3.
***        nast_tdarmod = nast-tdarmod.
***        nast-tdarmod = 1.
***        ls_composer_param-tdarmod = 1.
***      ENDIF.
***      IF sy-index NE 1 AND repeat IS INITIAL.
***        repeat = 'X'.
***      ENDIF.
**** BEGIN: Country specific extension for Hungary
***    IF lv_ccnum IS NOT INITIAL.
***      IF nast-repid IS INITIAL.
***        nast-repid = 1.
***      ELSE.
***        nast-repid = nast-repid + 1.
***      ENDIF.
***      nast-pfld1 = lv_ccnum.
***    ENDIF.
* END: Country specific extension for Hungary

  IF  NAST-KSCHL = 'USIN'.

    TYPES :BEGIN OF TY_EMAIL,
             SMTP_ADDR TYPE ADR6-SMTP_ADDR,
           END OF   TY_EMAIL.

    DATA: I_OTF        TYPE ITCOO OCCURS 0 WITH HEADER LINE,
          I_TLINE      LIKE TLINE OCCURS 0 WITH HEADER LINE,
          WA_BUFFER    TYPE STRING,
          V_LEN_IN     TYPE I,
          TAB_OTF_DATA TYPE SSFCRESCL,
          I_RECLIST    LIKE SOMLRECI1 OCCURS 0 WITH HEADER LINE,
          I_OBJTXT     LIKE SOLISTI1 OCCURS 0 WITH HEADER LINE,
          I_OBJBIN     LIKE SOLISTI1 OCCURS 0 WITH HEADER LINE,
          I_OBJPACK    LIKE SOPCKLSTI1 OCCURS 0 WITH HEADER LINE,
          WA_OBJHEAD   TYPE SOLI_TAB,
          SUBJECT(50)  TYPE C,
          V_LINES_TXT  TYPE I,
          V_LINES_BIN  TYPE I,
          ATTACH(50)   TYPE C,
          WA_DOC_CHNG  TYPE SODOCCHGI1,
          LV_ADRNR     TYPE KNA1-ADRNR,
          LV_SMTP_ADDR TYPE TABLE OF TY_EMAIL,
          I_RECORD     LIKE SOLISTI1 OCCURS 0 WITH HEADER LINE.
    DATA:    CPARAM TYPE SSFCTRLOP.

    CPARAM-NO_DIALOG = 'X'.
    CPARAM-GETOTF = 'X'.
*    * call smartform invoice
*    CALL FUNCTION LF_FM_NAME
*      EXPORTING
*        CONTROL_PARAMETERS = CPARAM
*        OUTPUT_OPTIONS     = LS_COMPOSER_PARAM
*        USER_SETTINGS      = SPACE
*        LS_BIL_INVOICE     = LS_BIL_INVOICE
*      IMPORTING
*        JOB_OUTPUT_INFO    = LS_JOB_INFO
*      EXCEPTIONS
*        FORMATTING_ERROR   = 1
*        INTERNAL_ERROR     = 2
*        SEND_ERROR         = 3
*        USER_CANCELED      = 4
*        OTHERS             = 5.
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.

    DATA: LV_FM_NAME       TYPE FUNCNAME,
          LV_DOC_PARAMS    TYPE SFPDOCPARAMS,
          LV_OUTPUT_PARAMS TYPE SFPOUTPUTPARAMS,
*      lv_control_params TYPE sfpcontrol,
          LS_FORM_OUTPUT   TYPE FPFORMOUTPUT.
    DATA:       E_FUNCNM TYPE FPNAME .             " Name of the Function Module
    CONSTANTS : SF_NAME1 TYPE FPNAME VALUE 'ZUS_SD_SALES_INVOICE_SFP_US'.


LV_OUTPUT_PARAMS-DEVICE = 'PRINTER'.
LV_OUTPUT_PARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
LV_OUTPUT_PARAMS-NODIALOG = 'X'.
LV_OUTPUT_PARAMS-PREVIEW = ''.
LV_OUTPUT_PARAMS-REQIMM = 'X'.
ELSE.
LV_OUTPUT_PARAMS-NODIALOG = ''.
LV_OUTPUT_PARAMS-PREVIEW = 'X'.
ENDIF.







    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LV_OUTPUT_PARAMS
      EXCEPTIONS
        CANCEL          = 1
        USAGE_ERROR     = 2
        SYSTEM_ERROR    = 3
        INTERNAL_ERROR  = 4
        OTHERS          = 5.

    IF SY-SUBRC <> 0.
      MESSAGE 'Error initializing Adobe form' TYPE 'E'.
    ENDIF.

*    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*      EXPORTING
*        I_NAME              = SF_NAME1
*      IMPORTING
*        EV_FUNCNAME_INBOUND = E_FUNCNM.


*CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*  EXPORTING
*    I_NAME                     =  'ZUS_SD_SALES_INVOICE_SFP_US'
* IMPORTING
*   EV_FUNCNAME_INBOUND        = E_FUNCNM.

CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME                     = 'ZUS_SD_SALES_INVOICE_SFP_US'
 IMPORTING
   E_FUNCNAME                 = E_FUNCNM.





CALL FUNCTION  E_FUNCNM     "'/1BCDWB/SM00000174'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    LS_BIL_INVOICE           = LS_BIL_INVOICE
    OUTPUT_OPTIONS           = LS_COMPOSER_PARAM
    USER_SETTINGS            = SPACE
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
          .
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
      MESSAGE 'Error closing Adobe form job' TYPE 'E'.
    ENDIF.




    REFRESH : I_TLINE,I_RECORD.
    CLEAR : WA_BUFFER.
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        FORMAT                = 'PDF'
        MAX_LINEWIDTH         = 132
      IMPORTING
        BIN_FILESIZE          = V_LEN_IN
      TABLES
        OTF                   = LS_JOB_INFO-OTFDATA "I_OTF
        LINES                 = I_TLINE
      EXCEPTIONS
        ERR_MAX_LINEWIDTH     = 1
        ERR_FORMAT            = 2
        ERR_CONV_NOT_POSSIBLE = 3
        OTHERS                = 4.
    IF SY-SUBRC <> 0.
    ENDIF.

    LOOP AT I_TLINE.
      TRANSLATE I_TLINE USING '~'.
      CONCATENATE WA_BUFFER I_TLINE INTO WA_BUFFER.
    ENDLOOP.
    TRANSLATE WA_BUFFER USING '~'.
    DO.
      I_RECORD = WA_BUFFER.
      APPEND I_RECORD.
      SHIFT WA_BUFFER LEFT BY 255 PLACES.
      IF WA_BUFFER IS INITIAL.
        EXIT.
      ENDIF.
    ENDDO.
    WAIT UP TO 10 SECONDS.

    FIELD-SYMBOLS:<FS> TYPE ANY .
    ASSIGN ('(SAPMV60A)VBRK-VBELN ') TO <FS>.
    SELECT SINGLE BSTNK_VF FROM VBRK INTO @DATA(WA_BSTKD) WHERE VBELN = @<FS>
                                                           AND VKORG = 'US00'.

**  ATTACHMENT
    REFRESH: I_RECLIST,
             I_OBJTXT,
             I_OBJBIN,
             I_OBJPACK.
    CLEAR : WA_OBJHEAD ,SUBJECT,SUBJECT.
    I_OBJBIN[] = I_RECORD[].

*    * CREATE MESSAGE BODY TITLE AND DESCRIPTION
*      CONCATENATE 'Please find the attached PDF copy of Outstanding Balance as on' postdate1 '.' INTO lv_text SEPARATED BY space.
    DATA(LV_TEXT1_FINAL) = 'Please find the attached invoice for your PO#'  && WA_BSTKD .
    DATA(LV_TEXT1_NEW) = '.Please let me know if you have any questions.'.
    CONCATENATE LV_TEXT1_FINAL LV_TEXT1_NEW INTO LV_TEXT1_FINAL.
    CONDENSE LV_TEXT1_FINAL.
    I_OBJTXT = LV_TEXT1_FINAL.
    APPEND I_OBJTXT.
    DATA(LV_BR) = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT2) = 'We would like to thank you for choosing DelVal Flow Controls.'.
    I_OBJTXT = LV_TEXT2.
    APPEND I_OBJTXT.
    LV_BR = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT3) = 'Your feedback is extremely essential for us to better understand your expectations and help us to identify areas that need improvement.'.
    I_OBJTXT = LV_TEXT3.
    APPEND I_OBJTXT.
    LV_BR = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT4) = 'We request you to fill out a short survey that would take less than a minute of your time.'.
    I_OBJTXT = LV_TEXT4.
    APPEND I_OBJTXT.
    LV_BR = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT5) = 'The survey can be accessed here - https://forms.office.com/r/hLAWVeM88a'.
    I_OBJTXT = LV_TEXT5.
    APPEND I_OBJTXT.
    LV_BR = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT6) = 'Thank you, in advance, for taking the time to fill in this questionnaire. Your response will be analyzed, and the results shared with every relevant DelVal Flow Controls employee.'.
    I_OBJTXT = LV_TEXT6.
    APPEND I_OBJTXT.
    DATA(LV_TEXT7) = 'Top Management and the Quality Team always look forward to your feedback.'.
    I_OBJTXT = LV_TEXT7.
    APPEND I_OBJTXT.
    LV_BR = ' '.
    I_OBJTXT = LV_BR.
    APPEND I_OBJTXT .
    DATA(LV_TEXT8) = 'Thank you for your continued business with DelVal Flow Controls USA, LLC'.
    I_OBJTXT = LV_TEXT8.
    APPEND I_OBJTXT.

    DESCRIBE TABLE I_OBJTXT LINES V_LINES_TXT.
    READ TABLE I_OBJTXT INDEX V_LINES_TXT.
    WA_DOC_CHNG-OBJ_NAME = 'SMARTFORM'.
    WA_DOC_CHNG-EXPIRY_DAT = SY-DATUM + 0.
    WA_DOC_CHNG-OBJ_DESCR = 'Sales Invoice'. "subject . "'CHECK LETTER'.
    WA_DOC_CHNG-SENSITIVTY = 'F'.
    WA_DOC_CHNG-DOC_SIZE = V_LINES_TXT * 255.

*      * MAIN TEXT
    CLEAR I_OBJPACK-TRANSF_BIN.
    I_OBJPACK-HEAD_START = 1.
    I_OBJPACK-HEAD_NUM = 0.
    I_OBJPACK-BODY_START = 1.
    I_OBJPACK-BODY_NUM = V_LINES_TXT.
    I_OBJPACK-DOC_TYPE = 'RAW'.
    APPEND I_OBJPACK.
* ATTACHMENT (PDF-ATTACHMENT)
    I_OBJPACK-TRANSF_BIN = 'X'.
    I_OBJPACK-HEAD_START = 1.
    I_OBJPACK-HEAD_NUM = 0.
    I_OBJPACK-BODY_START = 1.
    DESCRIBE TABLE I_OBJBIN LINES V_LINES_BIN.
    READ TABLE I_OBJBIN INDEX V_LINES_BIN.
    I_OBJPACK-DOC_SIZE = V_LINES_BIN * 255 .
    I_OBJPACK-BODY_NUM = V_LINES_BIN.
    I_OBJPACK-DOC_TYPE = 'PDF'.
    I_OBJPACK-OBJ_NAME = 'SMART'.
    I_OBJPACK-OBJ_DESCR = ATTACH . "'TEST'.
    APPEND I_OBJPACK.
    CLEAR: LV_ADRNR, LV_SMTP_ADDR.

    SELECT SINGLE KUNAG FROM VBRK INTO @DATA(WA_KUNAG) WHERE VBELN = @<FS>
                                                             AND VKORG = 'US00'.

    SELECT SINGLE ADRNR
                FROM KNA1
                INTO LV_ADRNR
                WHERE KUNNR = WA_KUNAG."custno-low.

    SELECT  SMTP_ADDR
                  FROM ADR6
                  INTO TABLE LV_SMTP_ADDR
                  WHERE ADDRNUMBER = LV_ADRNR.

    IF LV_SMTP_ADDR IS NOT INITIAL .
      DATA TO_MAIL TYPE SOMLRECI1.
      LOOP AT LV_SMTP_ADDR INTO DATA(WA_LV_SMTP_ADDR).    """loop for multiple mail id's
        I_RECLIST-RECEIVER = WA_LV_SMTP_ADDR-SMTP_ADDR.
        I_RECLIST-REC_TYPE = 'U'.
        APPEND I_RECLIST.
      ENDLOOP.
*********************commented by jyoti on 02.05.2025***************************
*      DATA wa_rece TYPE somlreci1.                """cc list
*      wa_rece-rec_type  = 'U'.
*      wa_rece-receiver = 'Cjones@delvalflow.com'.
*      wa_rece-copy = 'X'.
*      APPEND wa_rece  TO i_reclist.
*      CLEAR :wa_rece .
*
*      wa_rece-rec_type  = 'U'.
*      wa_rece-receiver = 'Bladart@delvalflow.com'.
*      wa_rece-copy = 'X'.
*      APPEND wa_rece  TO i_reclist.
*      CLEAR :wa_rece .
*
*      wa_rece-rec_type  = 'U'.
*      wa_rece-receiver = 'Ehowe@delvalflow.com'.
*      wa_rece-copy = 'X'.
*      APPEND wa_rece  TO i_reclist.
*      CLEAR :wa_rece .
*
*      wa_rece-rec_type  = 'U'.
*      wa_rece-receiver = 'Accounting@delvalflow.com'.
*      wa_rece-copy = 'X'.
*      APPEND wa_rece  TO i_reclist.
*      CLEAR :wa_rece .
*
*      wa_rece-rec_type  = 'U'.
*      wa_rece-receiver = 'rajib@delvalflow.com'.
*      wa_rece-copy = 'X'.
*      APPEND wa_rece  TO i_reclist.
*      CLEAR :wa_rece .
**********************************************************************
******************added by jyoti on 02.05.2025*********************************
***********************ADDED BY JYOTI ON 12.02.2025***********************
      DATA WA_RECE TYPE SOMLRECI1.
      SELECT * FROM ZUS_INVOICE_CC INTO TABLE @DATA(IT_MAIL).
      IF IT_MAIL IS NOT INITIAL.
        LOOP AT IT_MAIL INTO DATA(WA_MAIL).
          WA_RECE-RECEIVER = WA_MAIL-ZMAIL_ID.
          WA_RECE-REC_TYPE = 'U'.
          WA_RECE-COPY = 'X'.
          APPEND WA_RECE TO I_RECLIST.
          CLEAR: WA_MAIL.
        ENDLOOP.
      ENDIF.
*************************************************
      SELECT SINGLE ERNAM,          """SELECT QUERY FOR INVOICE CREATED
                   SMTP_ADDR
         FROM VBRK AS A INNER JOIN USR21 AS B
         ON A~ERNAM EQ B~BNAME
         INNER JOIN ADR6 AS C
         ON B~PERSNUMBER EQ C~PERSNUMBER
         INTO @DATA(WA_CREATED_NAME)
         WHERE VBELN = @<FS>
         AND VKORG = 'US00'.

      DATA LV_SENDER TYPE SO_REC_EXT.
      LV_SENDER = WA_CREATED_NAME-SMTP_ADDR.
*      lv_sender = 'ithelpdesk@delvalflow.com'.
      WAIT UP TO 2 SECONDS.

*      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
*        EXPORTING
*          document_data              = wa_doc_chng
*          put_in_outbox              = 'X'
*          sender_address             = lv_sender
*           sender_address_type        = 'INT'
*          commit_work                = 'X'
*        TABLES
*          packing_list               = i_objpack
*          object_header              = wa_objhead
*          contents_bin               = i_objbin
*          contents_txt               = i_objtxt
*          receivers                  = i_reclist
*        EXCEPTIONS
*          too_many_receivers         = 1
*          document_not_sent          = 2
*          document_type_not_exist    = 3
*          operation_no_authorization = 4
*          parameter_error            = 5
*          x_error                    = 6
*          enqueue_error              = 7
*          OTHERS                     = 8.
*      IF sy-subrc = 0.
*        MESSAGE 'Mail Send Successfully' TYPE 'S'.
*      ENDIF.
*****************************added by jyoti on 14.04.2025*****************************************************
      DATA: LV_ANSWER     TYPE C,
            LV_COUNTER    TYPE I,
            LV_VBELN      TYPE VBRK-VBELN,  " your document number
            LV_OUTPUTTYPE TYPE NAST-KSCHL.

      LV_VBELN = <FS>.         " example: Sales order number
      LV_OUTPUTTYPE = NAST-KSCHL.       " or whatever type you use
      DATA: LS_COUNTER1 TYPE ZUS_EMAIL_COUNT.

      " Check if mail already sent before
*SELECT SINGLE counter INTO lv_counter
      SELECT SINGLE * INTO LS_COUNTER1
        FROM ZUS_EMAIL_COUNT
        WHERE VBELN       = LV_VBELN
          AND KSCHL = LV_OUTPUTTYPE.

      IF SY-SUBRC = 0 AND LS_COUNTER1-COUNTER > 0.
        " Mail was already sent before, ask user if they want to repeat
        CONCATENATE 'An email has already been sent to the customer by the user' LS_COUNTER1-USNAM 'on'
      LS_COUNTER1-CREATED_DATE '.Would you still like to send again?' INTO DATA(GV_STRING) SEPARATED BY ' '.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            TITLEBAR              = 'Mail Already Sent'
            TEXT_QUESTION         = GV_STRING "'Mail already sent successfully. Do you want to send it again?'
            TEXT_BUTTON_1         = 'Yes'     " Button 1 text
            TEXT_BUTTON_2         = 'No'      " Button 2 text
            DEFAULT_BUTTON        = '2'
            DISPLAY_CANCEL_BUTTON = ' '
          IMPORTING
            ANSWER                = LV_ANSWER.

        IF LV_ANSWER = '1'.
          " User said YES # send mail again
          CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
            EXPORTING
              DOCUMENT_DATA              = WA_DOC_CHNG
              PUT_IN_OUTBOX              = 'X'
              SENDER_ADDRESS             = LV_SENDER
              SENDER_ADDRESS_TYPE        = 'INT'
              COMMIT_WORK                = 'X'
            TABLES
              PACKING_LIST               = I_OBJPACK
              OBJECT_HEADER              = WA_OBJHEAD
              CONTENTS_BIN               = I_OBJBIN
              CONTENTS_TXT               = I_OBJTXT
              RECEIVERS                  = I_RECLIST
            EXCEPTIONS
              TOO_MANY_RECEIVERS         = 1
              DOCUMENT_NOT_SENT          = 2
              DOCUMENT_TYPE_NOT_EXIST    = 3
              OPERATION_NO_AUTHORIZATION = 4
              PARAMETER_ERROR            = 5
              X_ERROR                    = 6
              ENQUEUE_ERROR              = 7
              OTHERS                     = 8.
          IF SY-SUBRC = 0.
            MESSAGE 'Mail Send Successfully' TYPE 'S'.
          ENDIF.
          " Update counter
          LV_COUNTER = LS_COUNTER1-COUNTER + 1.
*    UPDATE ZUS_EMAIL_COUNT SET counter = lv_counter
          UPDATE ZUS_EMAIL_COUNT SET COUNTER = LV_COUNTER CREATED_DATE = SY-DATUM CREATED_TIME = SY-UZEIT USNAM = SY-UNAME
            WHERE VBELN = LV_VBELN AND KSCHL = LV_OUTPUTTYPE.
        ELSE.
          " User said NO # exit
          MESSAGE 'Email sending cancelled by user.' TYPE 'I'.
          EXIT.
        ENDIF.
      ELSE.

        " First time # send and create log
        CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
          EXPORTING
            DOCUMENT_DATA              = WA_DOC_CHNG
            PUT_IN_OUTBOX              = 'X'
            SENDER_ADDRESS             = LV_SENDER
            SENDER_ADDRESS_TYPE        = 'INT'
            COMMIT_WORK                = 'X'
          TABLES
            PACKING_LIST               = I_OBJPACK
            OBJECT_HEADER              = WA_OBJHEAD
            CONTENTS_BIN               = I_OBJBIN
            CONTENTS_TXT               = I_OBJTXT
            RECEIVERS                  = I_RECLIST
          EXCEPTIONS
            TOO_MANY_RECEIVERS         = 1
            DOCUMENT_NOT_SENT          = 2
            DOCUMENT_TYPE_NOT_EXIST    = 3
            OPERATION_NO_AUTHORIZATION = 4
            PARAMETER_ERROR            = 5
            X_ERROR                    = 6
            ENQUEUE_ERROR              = 7
            OTHERS                     = 8.
        IF SY-SUBRC = 0.
          MESSAGE 'Mail Send Successfully' TYPE 'S'.
        ENDIF.
        DATA: LS_COUNTER TYPE ZUS_EMAIL_COUNT.

        LS_COUNTER-VBELN        = LV_VBELN.
        LS_COUNTER-KSCHL  = LV_OUTPUTTYPE.
        LS_COUNTER-COUNTER      = 1.
        LS_COUNTER-CREATED_DATE = SY-DATUM.
        LS_COUNTER-CREATED_TIME = SY-UZEIT.
        LS_COUNTER-USNAM = SY-UNAME.
        INSERT ZUS_EMAIL_COUNT FROM LS_COUNTER..
*       INSERT INTO zemail_counter VALUES ( lv_vbeln, lv_outputtype, 1 ).
      ENDIF.
*      BREAK PRIMUSABAP.
      IF SYST-MSGTY = 'S'.
        CALL TRANSACTION 'VF03'.
      ENDIF.
    ELSE.
      MESSAGE 'Please maintain Email Id in Customer master' TYPE 'E'.
    ENDIF.
  ELSEIF NAST-KSCHL = 'USIR'.

** call smartform invoice
*  CALL FUNCTION LF_FM_NAME
*    EXPORTING
*      OUTPUT_OPTIONS   = LS_COMPOSER_PARAM
*      USER_SETTINGS    = SPACE
*      LS_BIL_INVOICE   = LS_BIL_INVOICE
*    IMPORTING
*      JOB_OUTPUT_INFO  = LS_JOB_INFO
*    EXCEPTIONS
*      FORMATTING_ERROR = 1
*      INTERNAL_ERROR   = 2
*      SEND_ERROR       = 3
*      USER_CANCELED    = 4
*      OTHERS           = 5.

 LV_OUTPUT_PARAMS-DEVICE = 'PRINTER'.
 LV_OUTPUT_PARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
 LV_OUTPUT_PARAMS-NODIALOG = 'X'.
 LV_OUTPUT_PARAMS-PREVIEW = ''.
 LV_OUTPUT_PARAMS-REQIMM = 'X'.
ELSE.
 LV_OUTPUT_PARAMS-NODIALOG = ''.
 LV_OUTPUT_PARAMS-PREVIEW = 'X'.
ENDIF.



    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LV_OUTPUT_PARAMS
      EXCEPTIONS
        CANCEL          = 1
        USAGE_ERROR     = 2
        SYSTEM_ERROR    = 3
        INTERNAL_ERROR  = 4
        OTHERS          = 5.

    IF SY-SUBRC <> 0.
      MESSAGE 'Error initializing Adobe form' TYPE 'E'.
    ENDIF.

*    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*      EXPORTING
*        I_NAME              = 'ZUS_SD_SALES_RETURN_INVOICE_01'
*      IMPORTING
*        EV_FUNCNAME_INBOUND = E_FUNCNM.


CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME                     = 'ZUS_SD_SALES_RETURN_INVOICE_01'
 IMPORTING
   E_FUNCNAME                 = E_FUNCNM.


    CALL FUNCTION E_FUNCNM                     "'/1BCDWB/SM00000173'
      EXPORTING
*       /1BCDWB/DOCPARAMS        =
        LS_BIL_INVOICE = LS_BIL_INVOICE
        OUTPUT_OPTIONS = LS_COMPOSER_PARAM
        USER_SETTINGS  = SPACE
* IMPORTING
*       /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*       USAGE_ERROR    = 1
*       SYSTEM_ERROR   = 2
*       INTERNAL_ERROR = 3
*       OTHERS         = 4
      .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.


    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        USAGE_ERROR    = 1
        SYSTEM_ERROR   = 2
        INTERNAL_ERROR = 3
        OTHERS         = 4.

*  IF sy-subrc <> 0.
*    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
*  ENDIF.


    IF SY-SUBRC <> 0.
*   error handling
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
* get SmartForm protocoll and store it in the NAST protocoll
      PERFORM ADD_SMFRM_PROT.
    ENDIF.
  ENDIF.
**    ENDDO.
* get SmartForm spoolid and store it in the NAST protocoll
***    DATA ls_spoolid LIKE LINE OF ls_job_info-spoolids.
***    LOOP AT ls_job_info-spoolids INTO ls_spoolid.
***      IF ls_spoolid NE space.
***        PERFORM protocol_update_spool USING '342' ls_spoolid
***                                            space space space.
***      ENDIF.
***    ENDLOOP.
***    ls_composer_param-tdcopies = nast_anzal.
***    IF NOT nast_tdarmod IS INITIAL.
***      nast-tdarmod = nast_tdarmod.
***      CLEAR nast_tdarmod.
***    ENDIF.
***
***  ENDIF.
***
* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.

ENDFORM.                    "PROCESSING
