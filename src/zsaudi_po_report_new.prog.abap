*&---------------------------------------------------------------------*
*& Report ZGST_MM_PURCHASE_ORDER_DRVR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsaudi_po_report_new.

TYPE-POOLS meein .
TABLES : nast, zobj_link.
DATA : lfa_adrnr TYPE adrnr,
       lfa_email TYPE ad_smtpadr.


*
*FORM entry_neu_mail USING returncode
*                     us_screen.
*
*
*  DATA : fm_name       TYPE rs38l_fnam,
*         v_ebeln       TYPE ekko-ebeln,
*         l_druvo       LIKE t166k-druvo,
*         l_nast        LIKE nast,
*         l_from_memory,
*         l_doc         TYPE meein_purchase_doc_print.
*
*  DATA: control_parameters TYPE ssfctrlop,
*        return             TYPE ssfcrescl,
*
*        lng                TYPE i,
*        lines              TYPE  oij_tline.
**        docs type docs." TABLE OF TLINE.
*
*  ".......................................................................
*  TYPES : tt_itcoo TYPE TABLE OF itcoo.
*  DATA : p_path TYPE string,
*         mobj   TYPE swotobjid,
*         rcvr   TYPE swotobjid,
*         sndr   TYPE swotobjid.
**DMS attachments
*  DATA : it_drad TYPE  STANDARD TABLE OF draw,
*         wa_drad TYPE draw.
*  DATA : it_drad1 TYPE  STANDARD TABLE OF draw,
*         wa_drad1 TYPE draw.
*  DATA : it_draw TYPE  STANDARD TABLE OF draw,
*         wa_draw TYPE draw.
*  DATA : it_draw1 TYPE  STANDARD TABLE OF draw,
*         wa_draw1 TYPE draw.
*
*  DATA : it_lo_objid TYPE TABLE OF dms_doc2loio , " sdok_loid,
*         wa_lo_objid TYPE dms_doc2loio.  "sdok_loid.
*
*  DATA : v_phio_id  TYPE sdok_phid,
*         v_ph_class TYPE sdok_phcl.
*  DATA : it_object_id TYPE sdokobject,
*         wa_object_id TYPE  sdokobject.
*  DATA : it_file_content_binary TYPE STANDARD TABLE OF sdokcntbin,
*         wa_file_content_binary TYPE sdokcntbin.
*  DATA : it_file_content_ascii TYPE STANDARD TABLE OF sdokcntasc,
*         wa_file_content_ascii TYPE sdokcntasc.
*  DATA: objcont TYPE TABLE OF soli.
*  DATA: it_context TYPE STANDARD TABLE OF sdokpropty.
*
*  DATA: it_content_binary       TYPE  solix_tab,
*        it_content_binary_solix TYPE solix,
*        wa_content_binary       TYPE LINE OF  solix_tab.
*
*  DATA: count       TYPE i,
*        data_string TYPE xstring.
*
*  DATA : v_counter TYPE sy-tabix.
*
*  DATA : v_dappl TYPE dappl.
*  DATA : v_filename TYPE char100.
*  DATA: send_request       TYPE REF TO cl_bcs.
*  DATA: text               TYPE bcsy_text.
*  DATA: binary_content     TYPE solix_tab.
*  DATA: document           TYPE REF TO cl_document_bcs.
*  DATA: sender             TYPE REF TO cl_sapuser_bcs.
*  DATA: recipient          TYPE REF TO if_recipient_bcs.
*  DATA: bcs_exception      TYPE REF TO cx_bcs.
*  DATA: sent_to_all        TYPE os_boolean.
*  DATA: path               TYPE string.
*  DATA: filelength         TYPE i.
*  DATA: i_text             TYPE soli_tab.
*  DATA: wa_emailbody       TYPE soli.
*  DATA: it_emailbody       TYPE  soli_tab.
*  DATA: it_text            TYPE TABLE OF soli_tab.
*  DATA: v_dktxt            TYPE drat-dktxt.
*  DATA : wa_text           TYPE soli.
*  DATA : v_ext(3)          TYPE c.
*  DATA : v_extension_type  TYPE soodk-objtp.
*  DATA : v_attachname      TYPE sood-objdes.
*  DATA : v_mail   TYPE adr6-smtp_addr,
*         v_objdes TYPE so_obj_des.
*
*  DATA  : it_ekpo     TYPE STANDARD TABLE OF ekpo,
*          wa_ekpo     TYPE ekpo,
*          it_ekko     LIKE ekko,
*          wa_obj_link TYPE zobj_link.
*
** create the attachment for the mail :
*  v_ebeln = nast-objky.
*  CONCATENATE 'PurchaseOrder_' v_ebeln '.PDF' INTO p_path.
*  CLEAR returncode.
*  IF nast-aende EQ space.
*    l_druvo = '1'.
*  ELSE.
*    l_druvo = '2'.
*  ENDIF.
*
*  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
*    EXPORTING
*      ix_nast        = nast
*      ix_screen      = us_screen
*    IMPORTING
*      ex_retco       = returncode
*      ex_nast        = l_nast
*      doc            = l_doc
*    CHANGING
*      cx_druvo       = l_druvo
*      cx_from_memory = l_from_memory.
*
*  it_ekpo = l_doc-xekpo.
*  it_ekko = l_doc-xekko.

*  IF it_ekko-frgke = '2'.  " CHECK FOR PO RELEASE
*
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = 'ZSAUDI_MM_PURCHASE_ORDER'
**    *     VARIANT                  = ' '
**       DIRECT_CALL        = ' '
*      IMPORTING
*        fm_name            = fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*
*    " Control Parameters
*    control_parameters-no_dialog  = 'X'.
*    control_parameters-getotf     = 'X'.
*    control_parameters-preview    = space.
*    control_parameters-langu      = nast-spras.
*    control_parameters-device     = 'PRINTER'.
**
**" Mail-App_obj
**  MOBJ-OBJTYPE = 'BUS1008'.
**  MOBJ-OBJKEY = l_doc-XEKKO-LIFNR.
**
**" Sender Details
**  SNDR-OBJTYPE = 'BUS1008'.
**  SNDR-OBJKEY = l_doc-XEKKO-LIFNR.
**
**" Recipient Details
**  RCVR-OBJTYPE = 'BUS1008'.
**  RCVR-OBJKEY = l_doc-XEKKO-LIFNR.
***
*    CALL FUNCTION fm_name
*      EXPORTING
**       ARCHIVE_INDEX      =
**       ARCHIVE_INDEX_TAB  =
**       ARCHIVE_PARAMETERS =
*        control_parameters = control_parameters
**       MAIL_APPL_OBJ      = MOBJ
**       MAIL_RECIPIENT     = RCVR
**       MAIL_SENDER        = SNDR
**       OUTPUT_OPTIONS     =
*        user_settings      = 'X'  "..CHK..CHK..CHK
*        xekko              = l_doc-xekko
*      IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
*        job_output_info    = return
**       JOB_OUTPUT_OPTIONS =
*      TABLES
*        xekpo              = l_doc-xekpo
*        xeket              = l_doc-xeket
*        xtkomv             = l_doc-xtkomv
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ELSE.
*
*      PERFORM generate_pdf USING return-otfdata[] CHANGING lng lines .
*      IF sy-subrc = 0.
*        SELECT SINGLE adrnr
*          INTO lfa_adrnr
*          FROM lfa1
*          WHERE lifnr = l_doc-xekko-lifnr.
*        IF sy-subrc = 0.
*          SELECT SINGLE smtp_addr
*          FROM adr6
*          INTO lfa_email
*          WHERE addrnumber = lfa_adrnr.
*          IF sy-subrc = 0.
*            DATA : packlist  TYPE sopcklsti1,
*                   tpacklist TYPE TABLE OF sopcklsti1,
*                   doc_data  LIKE sodocchgi1,
*                   tablines  TYPE int4,
*                   wa_rcvr   TYPE somlreci1,
*                   rcvrs     TYPE TABLE OF somlreci1,
*                   line      TYPE tline.
*
*            CLEAR : packlist, doc_data.
*            "///////////////////////////////////////////////////////////////////
*            DATA:lns      TYPE TABLE OF solisti1,
*                 ln       TYPE solisti1,
*                 v_buffer TYPE string.
*            .
*            LOOP AT lines INTO line.
*              TRANSLATE line USING '~'.
*              CONCATENATE v_buffer line INTO v_buffer.
*              CLEAR line.
*            ENDLOOP.
*            TRANSLATE v_buffer USING '~'.
*            DO.
*              ln = v_buffer.
*              APPEND ln TO lns.
*              SHIFT v_buffer LEFT BY 255 PLACES.
*              IF v_buffer IS INITIAL.
*                EXIT.
*              ENDIF.
*            ENDDO.
*            "///////////////////////////////////////////////////////////////////
*
*            DESCRIBE TABLE lns LINES tablines.
*
*            "DOC_DATA-DOC_SIZE = LNG.
*            doc_data-obj_name  = 'Purchase Order'.
*            CONCATENATE 'Purchase Order : ' v_ebeln INTO doc_data-obj_descr.
*            doc_data-obj_name = p_path.
*            doc_data-doc_size = tablines * 255.
*
*
*            CLEAR packlist.
*
*            packlist-transf_bin = 'X'.
*            packlist-head_start = 1.
*            packlist-head_num = 1.
*            packlist-body_start = 1.
*            packlist-body_num = tablines.
*            packlist-doc_type = 'PDF'.
*            packlist-obj_name = 'Purchase Order'.
*            packlist-obj_descr = p_path.
*            packlist-doc_size = tablines * 255.
*            APPEND packlist TO tpacklist.
*
*            CLEAR wa_rcvr.
*            wa_rcvr-receiver = lfa_email . "sy-uname."LFA_EMAIL.
*            wa_rcvr-rec_type = 'U'.
*            APPEND wa_rcvr TO rcvrs.
*
*            CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
*              EXPORTING
*                document_data              = doc_data
*                put_in_outbox              = 'X'
**               COMMIT_WORK                = 'X'
**             IMPORTING
**               SENT_TO_ALL                =
**               NEW_OBJECT_ID              =
*              TABLES
*                packing_list               = tpacklist
**               OBJECT_HEADER              =
*                contents_bin               = lns[]
**               CONTENTS_TXT               =
**               CONTENTS_HEX               =
**               OBJECT_PARA                =
**               OBJECT_PARB                =
*                receivers                  = rcvrs
*              EXCEPTIONS
*                too_many_receivers         = 1
*                document_not_sent          = 2
*                document_type_not_exist    = 3
*                operation_no_authorization = 4
*                parameter_error            = 5
*                x_error                    = 6
*                enqueue_error              = 7
*                OTHERS                     = 8.
*            IF sy-subrc <> 0.
*              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*            ENDIF.
*          ELSE.
*            MESSAGE 'No email address is set for the vendor.' TYPE 'E'.
*          ENDIF.
*        ENDIF.
*
*      ENDIF.
*    ENDIF.
*
*
**To fetch DIR for the PO material
*
*    it_ekpo[] = l_doc-xekpo[].
*    LOOP AT it_ekpo INTO wa_ekpo.
*      SELECT dokar doknr dokvr doktl dokob objky APPENDING
*        CORRESPONDING FIELDS OF TABLE it_drad FROM drad
*        WHERE objky = wa_ekpo-matnr AND dokar = 'ZDR'.
*    ENDLOOP.
*
*    SELECT dokar doknr dokvr doktl  APPENDING
*        CORRESPONDING FIELDS OF TABLE it_draw FROM draw
*      FOR ALL ENTRIES IN it_drad
*        WHERE doknr = it_drad-doknr AND dokst = '{1'.
*
*
*    SORT it_draw BY  doknr dokvr.
*    LOOP AT it_draw INTO wa_draw.
*      ON CHANGE OF wa_draw-doknr.
*        wa_draw1 = wa_draw.
*        APPEND wa_draw1 TO it_draw1.
*      ENDON.
*    ENDLOOP.
*    READ TABLE it_draw1 INTO wa_draw1 INDEX 1.
*
**To check whether a particular Document of the material
**has already been sent to the vendor
**Documents which are sent are stored in Z table zobj_link
*    SELECT SINGLE * FROM zobj_link
*                   WHERE
*                lifnr  = l_doc-xekko-lifnr
*                AND matnr = wa_ekpo-matnr
*                AND doknr = wa_drad-doknr
*                AND dokvr  = wa_drad-dokvr
*                AND doktl = '000'
*                AND filename = v_filename.
*    IF sy-subrc NE 0.
*
*      SELECT lo_index  lo_objid
*               INTO CORRESPONDING FIELDS OF TABLE it_lo_objid        FROM dms_doc2loio
*              WHERE dokar = wa_draw1-dokar
*                AND  doknr = wa_draw1-doknr
*                AND dokvr  = wa_draw1-dokvr
*                AND doktl = '000'.
*
** To get the latest file of the Document
*      SORT it_lo_objid  DESCENDING.
*
*      READ TABLE it_lo_objid  INTO wa_lo_objid INDEX 1.
*      SELECT SINGLE phio_id
*                    ph_class
*             INTO   (wa_object_id-objid ,wa_object_id-class)
*             FROM    dms_ph_cd1
*             WHERE   loio_id = wa_lo_objid-lo_objid.
*
*      CALL FUNCTION 'SDOK_PHIO_LOAD_CONTENT'
*        EXPORTING
*          object_id           = wa_object_id
*          client              = sy-mandt
**         AS_IS_MODE          = 'X'
*          raw_mode            = 'X'
**         TEXT_AS_STREAM      = 'X'
*        TABLES
**         FILE_ACCESS_INFO    =
*          file_content_ascii  = it_file_content_ascii
*          file_content_binary = it_file_content_binary
*        EXCEPTIONS
*          not_existing        = 1
*          not_authorized      = 2
*          no_content          = 3
*          bad_storage_type    = 4
*          OTHERS              = 5.
*      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      DESCRIBE TABLE it_file_content_binary LINES count.
*
*      count = count * 1022.
*
*      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*        EXPORTING
*          input_length = count
**         FIRST_LINE   = 0
**         LAST_LINE    = 0
*        IMPORTING
*          buffer       = data_string
*        TABLES
*          binary_tab   = it_file_content_binary[]
*        EXCEPTIONS
*          failed       = 1
*          OTHERS       = 2.
*      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
*      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*        EXPORTING
*          buffer     = data_string
**         APPEND_TO_TABLE       = ' '
** IMPORTING
**         OUTPUT_LENGTH         =
*        TABLES
*          binary_tab = it_content_binary[].
*      IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*      ENDIF.
*
**     ------- create persistent send request -----------------------
*      send_request = cl_bcs=>create_persistent( ).
*
**     ------- create and set document with attachment --------------
**     create document from internal table with text
*      SHIFT wa_draw1-doknr LEFT DELETING LEADING '00'.
*      CONCATENATE 'This is Document' wa_draw1-doknr 'for PO' nast-objky  INTO v_objdes SEPARATED BY space.
*      APPEND  v_objdes TO text.
*      document = cl_document_bcs=>create_document(
*                      i_type    = 'RAW'
*                      i_text    = i_text
*                      i_subject = v_objdes ).
**     add attachment to document
** create the attachment for the mail :
** get the extension and the names of the files ********************
*
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = wa_draw1-doknr
*        IMPORTING
*          output = wa_draw1-doknr.
*      CLEAR : v_dappl,v_filename.
*      SELECT SINGLE dappl
*                    filename
*        INTO (v_dappl,v_filename)
*
*        FROM dms_doc_files
*        WHERE dokar = wa_draw1-dokar
*         AND  doknr = wa_draw1-doknr
*         AND dokvr = wa_draw1-dokvr
*         AND file_idx = wa_lo_objid-lo_index .
*
*      v_extension_type = v_dappl.
*      v_attachname  = v_filename.
*      CLEAR v_filename.
*      CALL METHOD document->add_attachment
*        EXPORTING
*          i_attachment_type    = v_extension_type
*          i_attachment_subject = v_attachname
*          i_att_content_hex    = it_content_binary.
*
**     add document to send request
*      CALL METHOD send_request->set_document( document ).
**    v_counter = v_counter + 1.
*      CLEAR v_counter.
**     -------- set sender ------------------------------------------
*
*      sender = cl_sapuser_bcs=>create( sy-uname ).
*      CALL METHOD send_request->set_sender
*        EXPORTING
*          i_sender = sender.
*
**     -------- add recipient (e-mail address) ----------------------
*
*      recipient = cl_cam_address_bcs=>create_internet_address( lfa_email  ).
**                                            ).
**     add recipient with its respective attributes to send request
*      CALL METHOD send_request->add_recipient
*        EXPORTING
*          i_recipient = recipient
*          i_express   = 'X'.
*      CLEAR v_mail.
*
**     --------- send document --------------------------------------
*      CALL METHOD send_request->send(
*        EXPORTING
*          i_with_error_screen = 'X'
*        RECEIVING
*          result              = sent_to_all ).
*      IF sent_to_all = 'X'.
*        wa_obj_link-matnr = wa_ekpo-matnr.
*        wa_obj_link-lifnr =  l_doc-xekko-lifnr.
*        wa_obj_link-doknr =  wa_draw1-doknr.
*        wa_obj_link-doktl = wa_draw1-doktl.
*        wa_obj_link-dokvr =  wa_draw1-dokvr.
*        wa_obj_link-filename =  v_filename.
*        MODIFY zobj_link FROM wa_obj_link.
*      ENDIF.
*    ENDIF.
*    CLEAR returncode.
**
*  ENDIF.
*ENDFORM. " ...EMAIL

*&---------------------------------------------------------------------*
*&      Form  entry_neu
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RETURNCODE text
*      -->US_SCREEN  text
*----------------------------------------------------------------------*
FORM entry_neu  USING returncode
                            us_screen.

  DATA : fm_name       TYPE rs38l_fnam,
         v_ebeln       TYPE ekko-ebeln,
         l_druvo       LIKE t166k-druvo,
         l_nast        LIKE nast,
         l_from_memory,
         l_doc         TYPE meein_purchase_doc_print,
          l_doc1         TYPE ztt_ekpo.

  DATA: control_parameters TYPE ssfctrlop,
        return             TYPE ssfcrescl.

  DATA lt_komvd TYPE TABLE OF komvd.
  DATA: lv_net TYPE kwert,
        lv_sub TYPE kwert.

  DATA: lv_fm_name       TYPE funcname,
        lv_doc_params    TYPE sfpdocparams,
        lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
        ls_form_output   TYPE fpformoutput.
  DATA: gv_form_name TYPE fpname.             " Name of the Function Module
  DATA: gv_fm_name         TYPE rs38l_fnam.
  CONSTANTS : sf_name1 TYPE fpname VALUE 'ZSAUDI_MM_PURCHASE_ORDER_NEW'.
  gv_form_name = 'ZSAUDI_MM_PURCHASE_ORDER_NEW'.

  ".......................................................................
  TYPES : tt_itcoo TYPE TABLE OF itcoo.
  DATA : p_path TYPE string,

         mobj   TYPE swotobjid,
         rcvr   TYPE swotobjid,
         sndr   TYPE swotobjid,

         lng    TYPE i,
         lines  TYPE oij_tline.

  v_ebeln = nast-objky.
  CONCATENATE 'PurchaseOrder_' v_ebeln '.PDF' INTO p_path.

  CLEAR returncode.
  IF nast-aende EQ space.
    l_druvo = '1'.
  ELSE.
    l_druvo = '2'.
  ENDIF.

  CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = us_screen
    IMPORTING
      ex_retco       = returncode
      ex_nast        = l_nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.


*  CHECK ent_retco EQ 0.

**  CALL FUNCTION 'ZMM_CALC_TAXES'
**    EXPORTING
**      zxekko   = l_doc-xekko
**    IMPORTING
**      e_sub    = lv_sub
**      e_net    = lv_net
**    TABLES
**      it_ekpo  = l_doc-xekpo
**      it_komv  = l_doc-xtkomv
**      et_komvd = lt_komvd.
*  IF sy-tcode NE 'ME29N' OR sy-tcode NE 'ME22N'.
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = 'ZSAUDI_MM_PURCHASE_ORDER'
**    *     VARIANT                  = ' '
**       DIRECT_CALL        = ' '
*      IMPORTING
*        fm_name            = fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*    " Control Parameters
*****  CONTROL_PARAMETERS-NO_DIALOG  = 'X'.
*    control_parameters-getotf     = 'X'.
*****  CONTROL_PARAMETERS-PREVIEW    = SPACE.
*    control_parameters-langu      = nast-spras.
*    control_parameters-device     = 'PRINTER'.
*
*    CALL FUNCTION fm_name
*      EXPORTING
**       ARCHIVE_INDEX      =
**       ARCHIVE_INDEX_TAB  =
**       ARCHIVE_PARAMETERS =
*        control_parameters = control_parameters
**       MAIL_APPL_OBJ      =
**       MAIL_RECIPIENT     =
**       MAIL_SENDER        =
**       OUTPUT_OPTIONS     =
*        user_settings      = 'X'  "..CHK..CHK..CHK
*        xekko              = l_doc-xekko
**       zxsub              = lv_sub
**       zxnet              = lv_net
*      IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
*        job_output_info    = return
**       JOB_OUTPUT_OPTIONS =
*      TABLES
*        xekpo              = l_doc-xekpo
*        xeket              = l_doc-xeket
*        xtkomv             = l_doc-xtkomv
**       l_komvd            = lt_komvd
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ELSE.
**     PERFORM GENERATE_PDF USING  P_PATH.
**   PERFORM GENERATE_PDF USING RETURN-OTFDATA[] CHANGING LNG LINES.
*      CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
*        EXPORTING
*          i_otf                    = return-otfdata[]
*        EXCEPTIONS
*          convert_otf_to_pdf_error = 1
*          cntl_error               = 2
*          OTHERS                   = 3.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*    ENDIF.
**  ENDIF.
*  CLEAR returncode.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.


  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = gv_form_name "   sf_name1 "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
    IMPORTING
      e_funcname = gv_fm_name.

  IF sy-subrc <> 0.
*   error handling

  ENDIF.
*  DATA: ex_ekpo TYPE ztt_ekpo,
*       ex_eket type ztt_eket,
*       ex_xtkomv type ZTT_PRCD_ELEMENTS.
* data : ex_xekko type EKKO.
*
*
*
*  "ex_ekpo[] = l_doc-xekpo .
*  ex_ekpo =  CORRESPONDING #( l_doc-xekpo ).
*
*  ex_xekko = l_doc-xekko.


*  CALL FUNCTION gv_fm_name                                "'/1BCDWB/SM00000144'
*    EXPORTING
**     /1BCDWB/DOCPARAMS  =
*      xekpo              = ex_ekpo
*      xeket              = l_doc-xeket
*      xtkomv             = l_doc-xtkomv
*      xekko              = ex_xekko
*      user_settings      = 'X'
**     OUTPUT_OPTIONS     =
**     MAIL_SENDER        =
**     ARCHIVE_INDEX      =
**     ARCHIVE_INDEX_TAB  =
**     ARCHIVE_PARAMETERS =
*      control_parameters = control_parameters
**     MAIL_APPL_OBJ      =
**     MAIL_RECIPIENT     =
**  IMPORTING
**     /1BCDWB/FORMOUTPUT =
*    EXCEPTIONS
*      usage_error        = 1
*      system_error       = 2
*      internal_error     = 3
*      formatting_error   = 4
*      send_error         = 5
*      user_canceled      = 6
*      OTHERS             = 7.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
   DATA: gt_ekpo TYPE ZTT_ST_EKPO.

gt_ekpo = VALUE #(
  FOR ls_xekpo IN l_doc-xekpo
    ( CORRESPONDING ZST_EKPO( ls_xekpo ) )
).

   DATA: gt_eket TYPE ZTT_ST_EKET.

gt_eket = VALUE #(
  FOR ls_xeket IN l_doc-xeket
    ( CORRESPONDING ZST_EKET( ls_xeket ) )
).



data : gt_prcd type ZTT_PRCD_ELEMENTS.

 gt_prcd = VALUE #(
  FOR ls_prcd IN l_doc-xtkomv
    ( CORRESPONDING #( ls_prcd ) )
).




  CALL FUNCTION gv_fm_name                       "'/1BCDWB/SM00000144'
    EXPORTING
*     /1BCDWB/DOCPARAMS        =
      xekpo                    = gt_ekpo[]
      xeket                    = gt_eket[]
      xtkomv                   = gt_prcd[]
      xekko                    =  l_doc-xekko
     USER_SETTINGS            =  'X'
*     OUTPUT_OPTIONS           =
*     MAIL_SENDER              =
*     ARCHIVE_INDEX            =
*     ARCHIVE_INDEX_TAB        =
*     ARCHIVE_PARAMETERS       =
      control_parameters       = control_parameters
*     MAIL_APPL_OBJ            =
*     MAIL_RECIPIENT           =
*   IMPORTING
*     /1BCDWB/FORMOUTPUT       =
   EXCEPTIONS
     USAGE_ERROR              = 1
     SYSTEM_ERROR             = 2
     INTERNAL_ERROR           = 3
     FORMATTING_ERROR         = 4
     SEND_ERROR               = 5
     USER_CANCELED            = 6
     OTHERS                   = 7
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



* CALL FUNCTION gv_fm_name                                            "'/1BCDWB/SM00000144'
*  EXPORTING
**    /1BCDWB/DOCPARAMS        =
*     xekpo                    =   l_doc-xekpo
*     xeket                    =   l_doc-xeket
*     xtkomv                   =   l_doc-xtkomv
*     xekko                    =    l_doc-xekko
*    USER_SETTINGS            =    'X'
**     output_options           =
**     mail_sender              =
**     archive_index            =
**     archive_index_tab        =
**     archive_parameters       =
*     control_parameters        =  control_parameters
**     mail_appl_obj            =
**     mail_recipient           =
**  IMPORTING
**    /1BCDWB/FORMOUTPUT       =
**  EXCEPTIONS
**    USAGE_ERROR              = 1
**    SYSTEM_ERROR             = 2
**    INTERNAL_ERROR           = 3
**    FORMATTING_ERROR         = 4
**    SEND_ERROR               = 5
**    USER_CANCELED            = 6
**    OTHERS                   = 7
*           .
* IF sy-subrc <> 0.
** Implement suitable error handling here
* ENDIF.







  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.








ENDFORM.                    "entry_neu

*FORM generate_pdf USING otf TYPE tt_itcoo "RTRN TYPE SSFCRESCL
*                        CHANGING lngth TYPE i
*                                 lines TYPE oij_tline.
*  DATA :  docs TYPE TABLE OF docs.
*  "OTF1[] =  RTRN-OTFDATA[].
**  CALL FUNCTION 'CONVERT_OTF'
**    EXPORTING
**      FORMAT                = 'PDF'
**      MAX_LINEWIDTH         = 132
**    IMPORTING
**      BIN_FILESIZE          = LNGTH
**    TABLES
**      OTF                   = OTF[]
**      LINES                 = LINES[]
**    EXCEPTIONS
**      ERR_MAX_LINEWIDTH     = 1
**      ERR_FORMAT            = 2
**      ERR_CONV_NOT_POSSIBLE = 3
**      ERR_BAD_OTF           = 4
**      OTHERS                = 5.
**  IF SY-SUBRC <> 0.
**    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ENDIF.
*
*  CALL FUNCTION 'CONVERT_OTF_2_PDF'
*    EXPORTING
*      use_otf_mc_cmd = 'X'
**     ARCHIVE_INDEX  =
*    IMPORTING
*      bin_filesize   = lngth
*    TABLES
*      otf            = otf[]
*      doctab_archive = docs[]
*      lines          = lines[]
** EXCEPTIONS
**     ERR_CONV_NOT_POSSIBLE        = 1
**     ERR_OTF_MC_NOENDMARKER       = 2
**     OTHERS         = 3
*    .
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*
*
*ENDFORM.                    "GENERATE_PDF
*
*
*
**&---------------------------------------------------------------------*
**&      Form  DOWNLOAD_FILE
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->PATH       text
**      -->LNGTH      text
**      -->LINES      text
**----------------------------------------------------------------------*
*FORM download_file USING path  TYPE string
*                         lngth TYPE i
*                         lines TYPE oij_tline.
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      bin_filesize            = lngth
*      filename                = path
*      filetype                = 'BIN'
*    TABLES
*      data_tab                = lines[]
**     FIELDNAMES              =
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      OTHERS                  = 22.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*ENDFORM.                    "DOWNLOAD FILE
