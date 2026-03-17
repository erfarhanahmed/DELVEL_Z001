*&---------------------------------------------------------------------*
*& Report ZZPP_COMPLIANCE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZZPP_COMPLIANCE.

TYPES: BEGIN OF t_objk,
         obknr TYPE objk-obknr,
         sernr TYPE objk-sernr,
       END OF t_objk.

TYPES: BEGIN OF t_mara,
         matnr   TYPE mara-matnr,
         v_extwg TYPE mara-extwg,
       END OF t_mara.

TYPES: BEGIN OF t_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF t_makt,

       BEGIN OF t_afru,
         aufnr TYPE afru-aufnr,
         budat TYPE afru-budat,
       END OF t_afru.

DATA:v_kunag        TYPE likp-kunag,
     v_posnv        TYPE vbfa-posnv,
     v_aufnr        TYPE afpo-aufnr,
     v_obknr        TYPE ser05-obknr,
     v_brand        TYPE mara-brand,
     v_extwg        TYPE mara-extwg,
     v_vbeln        TYPE likp-vbeln,
     v_posnr        TYPE lips-posnr,
     v_werks        TYPE lips-werks,
     v_name1        TYPE kna1-name1,
     v_name2        TYPE kna1-name2,
     v_bstnk        TYPE vbak-bstnk,
     v_bstdk        TYPE vbak-bstdk,
     v_fsernr       TYPE objk-sernr,
     v_fsernr1      TYPE char20,
     v_lsernr1      TYPE char20,
     v_lsernr       TYPE objk-sernr,
     v_lfimg        TYPE lips-lfimg,
     v_zsize        TYPE mara-zsize,
     v_kdmat        TYPE vbap-kdmat,
     v_zeinr        TYPE mara-zeinr,
     v_vbelv        TYPE vbfa-vbelv,
     v_body         TYPE char30,
     v_valve        TYPE char30,
     v_stem         TYPE char30,
     v_seat         TYPE char30,
     v_class        TYPE char30,
     v_asupply      TYPE char30,
     v_afail        TYPE char30,
     v_seat_leakage TYPE char30,
     v_shell_test   TYPE char30,
     v_seat_test    TYPE char30,
     v_pneumatic    TYPE char30,
     v_actuator     TYPE char40,
     v_sov          TYPE char40,
     v_lsb          TYPE char40,
     v_afr          TYPE char40,
     v_mor          TYPE char40,
     v_pos          TYPE char40,
     v_matnr        TYPE lips-matnr,
     v_maktx        TYPE makt-maktx,
     v_adrnr        TYPE t001w-adrnr,
     v1_name1       TYPE adrc-name1,
     v1_name2       TYPE adrc-name2,
     v_name_co      TYPE adrc-name_co,
     v_str_suppl1   TYPE adrc-str_suppl1,
     v_str_suppl2   TYPE adrc-str_suppl2,
     v_street       TYPE adrc-street,
     v_city1        TYPE adrc-city1,
     v_post_code1   TYPE adrc-post_code1,
     v_time_zone    TYPE adrc-time_zone,
     v_tel_number   TYPE adrc-tel_number,
     v_fax_number   TYPE adrc-fax_number,
     v_budat        TYPE afru-budat,
     V_LGORT        TYPE afpo-LGORT.  " ADD ON 25/06/2024 BY SA
.

datA:lwa_result TYPE SFPJOBOUTPUT.

data:lwa_OUTPUTPARAMS  TYPE SFPOUTPUTPARAMS.
DATA:it_objk TYPE STANDARD TABLE OF t_objk,
     wa_objk TYPE t_objk.

DATA:it_mara TYPE STANDARD TABLE OF t_mara,
     wa_mara TYPE t_mara.

DATA:it_makt TYPE STANDARD TABLE OF t_makt,
     wa_makt TYPE t_makt.

DATA:it_afru TYPE STANDARD TABLE OF t_afru,
     wa_afru TYPE t_afru.

DATA:it_final TYPE zpp_compliance_lt,
     wa_final TYPE zpp_compliance.

DATA: it_stb TYPE STANDARD TABLE OF stpox,
      wa_stb TYPE stpox.

DATA:lf_fm_name TYPE FUNCNAME,
     formname   TYPE FPNAME,
     control    TYPE ssfctrlop,        "CONTROL PARAMETERS
     out_opt    TYPE ssfcompop,
     return1    TYPE ssfcrescl,
     length     TYPE i,
     otf1       TYPE TABLE OF itcoo,
     lines1     TYPE TABLE OF tline,
     f_path     TYPE ibipparms-path.
DATA: v_file TYPE string,
      v_path TYPE string.

DATA: allocvaluesnum     TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
      allocvalueschar    TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
      allocvaluescurr    TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
      return             TYPE STANDARD TABLE OF bapiret2,
      objectkey          TYPE bapi1003_key-object,
      wa_allocvalueschar TYPE bapi1003_alloc_values_char,
      classnum           LIKE bapi1003_key-classnum.

***SELECTION SCREEN

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: r_del   RADIOBUTTON GROUP rad1 DEFAULT 'X', "Local
            p_vbeln TYPE lips-vbeln MODIF ID del,
            p_posnr TYPE lips-posnr MODIF ID del,
            r_prd   RADIOBUTTON GROUP rad1 , "USER-COMMAND flg.
            p_aufnr TYPE afpo-aufnr MODIF ID pro,
            r_po    RADIOBUTTON GROUP rad1,
            p_pordr TYPE ekkn-ebeln MODIF ID po.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK a WITH FRAME TITLE TEXT-001.
*PARAMETERS: p_vbeln  LIKE lips-vbeln ."OBLIGATORY.
*PARAMETERS: p_posnr  TYPE lips-posnr.
PARAMETERS :p_zdelsr TYPE zpp_compliance-zdelsrno,
            p_ztagno TYPE zpp_compliance-ztagno.
PARAMETERS: p_path   TYPE string.
SELECTION-SCREEN: END OF BLOCK a.
*
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*PARAMETERS: r_prd RADIOBUTTON GROUP rad1 USER-COMMAND flg, "Local
*            r_del RADIOBUTTON GROUP rad1 DEFAULT 'X'.
*SELECTION-SCREEN : END of block b1.



AT SELECTION-SCREEN OUTPUT.


  IF r_del IS NOT INITIAL.
* Don't allow input for these fields
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'DEL'.
          screen-input = '1'.
          screen-output = '1'.
          screen-invisible = '0'.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PRO'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
          CLEAR : p_aufnr , p_path.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PO'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
          CLEAR : p_path ,p_pordr.
      ENDCASE.
    ENDLOOP.

  ENDIF.
  IF r_prd = 'X'.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PRO'.
          screen-input = '1'.
          screen-output = '1'.
          screen-invisible = '0'.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'DEL'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.

          CLEAR : p_vbeln , p_posnr , p_path.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PO'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
          CLEAR :  p_path ,p_pordr.
      ENDCASE.
    ENDLOOP.

  ENDIF.

  IF r_po = 'X'.                                         "Addition Of logic for Purchase order Radio Button By Snehal Rajale on 4.02.2021

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PO'.
          screen-input = '1'.
          screen-output = '1'.
          screen-invisible = '0'.
          MODIFY SCREEN.
          CLEAR :  p_path ,p_pordr.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'PRO'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'DEL'.
          screen-input = '0'.
          screen-output = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.

          CLEAR : p_vbeln , p_posnr , p_path.
      ENDCASE.
    ENDLOOP.

  ENDIF.

*  IF r_prd EQ 'X' .
*
*    LOOP AT SCREEN.
** Radio button parameter = P_RADIO
**   hide the parameter named "to_hide"
*      IF screen-name CS 'P_VBELN' . " OR SCREEN-NAME CS 'P_POSNR' ).
*        screen-input = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ELSE.
*    LOOP AT SCREEN.
**   display the parameter named "to_hide"
*      IF screen-name CS 'P_VBELN'  . "OR SCREEN-NAME CS 'P_POSNR' ).
*        screen-input = 1.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*
*  ENDIF.
***********************************************************************
*AT SELECTION-SCREEN.
*  SELECT SINGLE vbeln posnr FROM lips
*   INTO (v_vbeln,
*         v_posnr)
*   WHERE vbeln = p_vbeln
*    AND posnr = p_posnr.
*  IF sy-subrc <> 0.
*    MESSAGE e009(zdel).
*  ENDIF.
***********************************************************************

 DATA: lv_usr_act TYPE i.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_extension         = 'PDF'
      default_file_name         = 'DOWNLOAD'              " Default File Name
    CHANGING
      filename                  =  v_file               " File Name to Save
      path                      =  v_path                " Path to File
      fullpath                  =  p_path                " Path + File Name
    EXCEPTIONS
      cntl_error                = 1                " Control error
      error_no_gui              = 2                " No GUI available
      not_supported_by_gui      = 3                " GUI does not support this
      invalid_default_file_name = 4                " Invalid default file name
      others                    = 5
    .
  IF SY-SUBRC <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


***********************************************************************
START-OF-SELECTION.

  IF p_vbeln IS NOT INITIAL AND p_posnr IS NOT INITIAL AND p_aufnr IS INITIAL.
    PERFORM get_data.
    PERFORM process_data.
    PERFORM display_data.
  ELSEIF p_aufnr IS NOT INITIAL.
    PERFORM get_data.
    PERFORM process_data.
    PERFORM display_data.
  ELSEIF p_pordr IS NOT INITIAL.
    PERFORM get_data.
    PERFORM process_data.
    PERFORM display_data.
  ELSE.
    MESSAGE 'Please Enter the valid input' TYPE 'E'.
  ENDIF.

***********************************************************************
FORM get_data .

  IF p_aufnr IS NOT INITIAL.
    SELECT SINGLE kdauf kdpos LGORT FROM afpo INTO ( v_vbelv , v_posnv , V_LGORT )
                                          WHERE aufnr = p_aufnr .

*    SELECT SINGLE vbeln posnr FROM lips INTO ( p_vbeln , p_posnr )
*                                          WHERE vbelv = p_vbeln
*                                            AND posnv = p_posnr .

    p_posnr = v_posnv .

    SELECT SINGLE budat FROM afru INTO v_budat
           WHERE aufnr = p_aufnr.

  ELSEIF p_vbeln IS NOT INITIAL.
***SELECTING SOLD-TO PARTY NO FROM LIKP
    SELECT SINGLE kunag
      FROM likp
      INTO v_kunag
      WHERE vbeln = p_vbeln.

****SELECTING SALES ORDER AND ITEM NO FROM VBFA
    SELECT SINGLE vbelv posnv
      FROM vbfa
      INTO (v_vbelv,
            v_posnv)
      WHERE vbeln = p_vbeln
        AND posnn = p_posnr.

      p_posnr = v_posnv .

  ELSEIF p_pordr IS NOT INITIAL.

****SELECTING SALES ORDER AND ITEM NO FROM VBFA
    SELECT SINGLE vbeln vbelp
    FROM ekkn
    INTO (v_vbelv,
    v_posnv)
    WHERE ebeln = p_pordr.

    p_posnr = v_posnv .

  ENDIF.

****SELECTING CUSTOMER PURCHASE ORDER NUMBER,CUSTOMER PURCHASE ORDER DATE
****FROM VBAK.
  IF v_vbelv IS NOT INITIAL AND v_posnv IS NOT INITIAL.
    SELECT SINGLE bstnk bstdk kunnr
      FROM vbak
      INTO (v_bstnk,
            v_bstdk,
            v_kunag)
      WHERE vbeln = v_vbelv.

***SELECTING  NAME OF SOLD-TO PARTY NO FROM KNA1
    IF sy-subrc = 0.
      SELECT SINGLE name1 name2
        FROM kna1
        INTO (v_name1, v_name2)
        WHERE kunnr = v_kunag.
    ENDIF.

****SELECTING MATERIAL NUMBER USED BY CUSTOMER FROM VBAP.
    IF sy-subrc = 0.
      SELECT SINGLE kdmat werks matnr "kwmeng
        FROM vbap
        INTO (v_kdmat,
              v_werks,
              v_matnr)
*              v_lfimg)
        WHERE vbeln = v_vbelv
        AND posnr = v_posnv.

****SELECTING PRODUCTION ORDER NO FROM AFPO.
      IF p_vbeln IS NOT INITIAL.
        SELECT SINGLE aufnr psmng
          FROM afpo
          INTO (v_aufnr , v_lfimg)
          WHERE kdauf = v_vbelv
            AND kdpos = v_posnv.
      ELSEIF p_aufnr IS NOT INITIAL.
        SELECT SINGLE aufnr psmng
          FROM afpo
          INTO (v_aufnr , v_lfimg)
          WHERE aufnr = p_aufnr.
*        v_aufnr = p_aufnr .
      ELSEIF p_pordr IS NOT INITIAL.
        SELECT SINGLE menge
          FROM ekkn
          INTO ( v_lfimg )
          WHERE ebeln = p_pordr
          AND   vbeln = v_vbelv
          AND   vbelp = v_posnv.
      ENDIF.
****SELECTING OBJECT LIST NUMBER FROM SER05.
      IF sy-subrc = 0.
        SELECT SINGLE obknr
          FROM ser05
          INTO v_obknr
          WHERE ppaufnr = v_aufnr.

****SELECTING SERIAL NUMBER FROM OBJK.
        IF sy-subrc = 0.
          SELECT obknr sernr
            FROM objk
            INTO TABLE it_objk
            WHERE obknr = v_obknr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

****SELECTING MATERIAL NUMBER AND QUANTITY,PLANT FROM LIPS.

*  SELECT SINGLE werks
*    FROM lips
*    INTO v_werks
*    WHERE vbeln = p_vbeln
*      AND posnr = p_posnr.
*
*  SELECT SINGLE matnr lfimg werks
*    FROM lips
*    INTO (v_matnr,
*          v_lfimg,
*          v_werks)
*    WHERE vbeln = p_vbeln
*      AND posnr = p_posnr.


*  IF sy-subrc = 0.
  IF v_werks IS NOT INITIAL .
    SELECT SINGLE adrnr
      INTO v_adrnr
      FROM t001w
      WHERE werks = v_werks.
    IF sy-subrc = 0.

      SELECT SINGLE name1
                    name2
                    name_co
                    str_suppl1
                    str_suppl2
                    street
                    city1
                    post_code1
                    time_zone
                    tel_number
                    fax_number
                    FROM adrc
                    INTO  (v1_name1,
                           v1_name2,
                           v_name_co,
                           v_str_suppl1,
                           v_str_suppl2,
                           v_street,
                           v_city1,
                           v_post_code1,
                           v_time_zone,
                           v_tel_number,
                           v_fax_number)
                      WHERE addrnumber = v_adrnr.
    ENDIF.
  ENDIF.
****SELECTING SIZE,BRAND AND MATERIAL DOCUMENT NUMBER FROM MARA.
  IF sy-subrc = 0.
    SELECT SINGLE maktx
      FROM makt
      INTO v_maktx
      WHERE matnr = v_matnr
        AND spras  = sy-langu.

    SELECT SINGLE zsize brand zeinr
      FROM mara
      INTO (v_zsize,
            v_brand,
            v_zeinr)
      WHERE matnr = v_matnr.
  ENDIF.

  LOOP AT it_objk INTO wa_objk.
    v_fsernr = wa_objk-sernr.
    AT FIRST.
      v_fsernr1 = v_fsernr.
    ENDAT.

    AT LAST.
      v_lsernr1 = v_fsernr.
    ENDAT.
  ENDLOOP.

***********************************************************************
  objectkey = v_matnr.
  IF v_brand = TEXT-003.
    classnum = TEXT-004.
  ELSEIF v_brand = TEXT-005.
    classnum = TEXT-006.
  ELSEIF v_brand = TEXT-007.
    classnum = TEXT-008.
  ELSEIF v_brand = TEXT-028.
    classnum = TEXT-029.
  ELSEIF v_brand = 'AUT'.     "TEXT-009.
    classnum = TEXT-010.
  ENDIF.
*****CALLING FM TO GET THE CHARACTERISTIC
*  DATA lv_classtype LIKE  bapi1003_key-classtype.
*  lv_classtype = TEXT-012.
  CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
    EXPORTING
      objectkey       = objectkey
      objecttable     = 'MARA'
      classnum        = classnum
      classtype       = '001'
    TABLES
      allocvaluesnum  = allocvaluesnum
      allocvalueschar = allocvalueschar
      allocvaluescurr = allocvaluescurr
      return          = return.

  CLEAR wa_allocvalueschar.
  LOOP AT allocvalueschar INTO wa_allocvalueschar.
    IF wa_allocvalueschar-charact = TEXT-013.
      v_body = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-014.
      v_valve = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-015.
      v_valve = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-016.
      v_stem = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-017.
      v_seat = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-018.
      v_class = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-019.
      v_asupply = wa_allocvalueschar-value_char.
    ENDIF.
    IF wa_allocvalueschar-charact = TEXT-020.
      v_afail = wa_allocvalueschar-value_char.
    ENDIF.

  ENDLOOP.

  SELECT SINGLE seat_leakage
  shell_test
  seat_test
  pneumatic
  FROM zppcompliance
  INTO (v_seat_leakage,
        v_shell_test,
        v_seat_test,
        v_pneumatic)
   WHERE class = v_class.
***********************************************************************
  IF v_matnr IS NOT INITIAL.
*****CALLING FM TO EXPLODE MATERIAL.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'PP01'
        datuv                 = sy-datum
        mehrs                 = 'X'
        mtnrv                 = v_matnr
        stpst                 = 0
        svwvo                 = 'X'
        werks                 = v_werks
        vrsvo                 = 'X'
      TABLES
        stb                   = it_stb
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  IF NOT it_stb IS INITIAL.
    SELECT matnr extwg
      FROM mara
      INTO  TABLE it_mara
      FOR ALL ENTRIES IN it_stb
      WHERE matnr = it_stb-idnrk.
    IF sy-subrc = 0.
      SORT it_mara BY matnr.
    ENDIF.

    SELECT matnr maktx
      FROM makt
      INTO TABLE it_makt
         FOR ALL ENTRIES IN it_stb
         WHERE matnr = it_stb-idnrk
        AND spras  = sy-langu.
    IF sy-subrc = 0.
      SORT it_makt BY matnr.
    ENDIF.
  ENDIF.

  LOOP AT it_mara INTO wa_mara.
    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr
    BINARY SEARCH.

    IF wa_mara-v_extwg = TEXT-007.
      v_actuator = wa_makt-maktx.
    ENDIF.

    IF wa_mara-v_extwg = TEXT-023.
      v_sov = wa_makt-maktx.
    ENDIF.

    IF wa_mara-v_extwg = TEXT-024.
      v_lsb = wa_makt-maktx.
    ENDIF.

    IF wa_mara-v_extwg = TEXT-025.
      v_afr = wa_makt-maktx.
    ENDIF.

    IF wa_mara-v_extwg = TEXT-026.
      v_mor = wa_makt-maktx.
    ENDIF.

    IF wa_mara-v_extwg = TEXT-027.
      v_pos = wa_makt-maktx.
    ENDIF.
    CLEAR :wa_makt,wa_mara.
  ENDLOOP.
ENDFORM.                    " GET_DATA
***********************************************************************
FORM process_data .
*****POPULATING DATA INTO IT_FINAL.
  wa_final-name1 = v_name1.
  wa_final-name2 = v_name2.
  wa_final-bstnk = v_bstnk.
  wa_final-bstdk = v_bstdk.
  wa_final-fsernr = v_fsernr1.
  wa_final-lsernr = v_lsernr1.
  wa_final-lfimg = v_lfimg.
  wa_final-zsize = v_zsize.
  wa_final-kdmat = v_kdmat.
  wa_final-zeinr = v_zeinr.
  wa_final-vbelv = v_vbelv.
  wa_final-posnr = p_posnr.
  wa_final-body = v_body.
  wa_final-valve = v_valve.
  wa_final-stem = v_stem.
  wa_final-seat = v_seat.
  wa_final-class = v_class.
  wa_final-asupply = v_asupply.
  wa_final-afail = v_afail.
  wa_final-seat_leakage = v_seat_leakage.
  wa_final-shell_test = v_shell_test.
  wa_final-seat_test = v_seat_test.
  wa_final-pneumatic = v_pneumatic.
  wa_final-actuator = v_actuator.
  wa_final-sov = v_sov.
  wa_final-lsb = v_lsb.
  wa_final-afr = v_afr.
  wa_final-mor = v_mor.
  wa_final-pos = v_pos.
  wa_final-matnr = v_matnr.
  wa_final-maktx = v_maktx.
  wa_final-v1_name1 = v1_name1.
  wa_final-v_name_co = v_name_co.
  wa_final-v_str_suppl1 = v_str_suppl1.
  wa_final-v_str_suppl2 = v_str_suppl2.
  wa_final-v_street = v_street.
  wa_final-v_city1 = v_city1.
  wa_final-v_post_code1 = v_post_code1.
  wa_final-v_time_zone = v_time_zone.
  wa_final-v_tel_number = v_tel_number.
  wa_final-v_fax_number = v_fax_number.
  wa_final-zdelsrno = p_zdelsr.
  wa_final-ztagno = p_ztagno.
  wa_final-budat = v_budat.
  wa_final-lgort = v_lgort.     " ADD ON 25/06/2024 BY SA
  APPEND wa_final TO it_final.

  CLEAR: wa_final,wa_objk,wa_allocvalueschar,wa_mara,wa_makt,wa_stb.
  CLEAR : v_kunag,v_posnv,v_aufnr,v_obknr,v_matnr,v_brand,v_extwg,v_vbeln,v_posnr,v_name1,v_werks,v_bstnk,
          v_bstdk,v_fsernr, v_lsernr,v_lfimg,v_zsize,v_kdmat,v_zeinr,v_vbelv,v_body,v_valve,v_stem,
          v_seat,v_class,v_asupply,v_afail,v_seat_leakage,v_shell_test,v_seat_test,v_pneumatic,
          v_actuator,v_sov,v_lsb,v_afr,v_mor.
  CLEAR:lf_fm_name,formname,objectkey,classnum.

ENDFORM.                    " PROCESS_DATA
***********************************************************************
FORM display_data .


  formname = TEXT-002.

 lwa_OUTPUTPARAMS-nodialog = 'X'.
* DATA: lv_fp_outputparams TYPE sfpoutputparams.

lwa_OUTPUTPARAMS-getpdf = abap_true.
lwa_OUTPUTPARAMS-getxml = abap_false.

CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS       = lwa_OUTPUTPARAMS
   EXCEPTIONS
     CANCEL                = 1
     USAGE_ERROR           = 2
     SYSTEM_ERROR          = 3
     INTERNAL_ERROR        = 4
     OTHERS                = 5
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

   CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME                     = formname
 IMPORTING
   E_FUNCNAME                 = lf_fm_name
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
          .
IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

data:lv_SFPDOCPARAMS TYPE FPFORMOUTPUT,
      lv_fp_docparams TYPE SFPDOCPARAMS.

   CALL FUNCTION  lf_fm_name  " '/1BCDWB/SM00000077'
     EXPORTING
      /1BCDWB/DOCPARAMS        = lv_fp_docparams
       it_final                 = it_final[]
       p_posnr                  = p_posnr
       p_vbeln                  = p_vbeln
    IMPORTING
      /1BCDWB/FORMOUTPUT       = lv_SFPDOCPARAMS
    EXCEPTIONS
      USAGE_ERROR              = 1
      SYSTEM_ERROR             = 2
      INTERNAL_ERROR           = 3
      OTHERS                   = 4
             .

   IF sy-subrc <> 0.
* Implement suitable error handling here
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

   ENDIF.

  DATA: lv_filename TYPE string,
      lv_timestamp TYPE string.

DATA: lt_pdf_data TYPE TABLE OF solix,
      lv_length TYPE i,
      lv_xstring      TYPE xstring,
         lv_bin_filesize TYPE i.

CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer     =   lv_SFPDOCPARAMS-pdf
  TABLES
    binary_tab = lt_pdf_data
  EXCEPTIONS
    others     = 1.
IF sy-subrc <> 0.
  " Handle error
ENDIF.


CALL METHOD cl_gui_frontend_services=>gui_download
  EXPORTING
*    bin_filesize              =                   " File length for binary files
    filename                  = p_path                   " Name of file
    filetype                  = 'BIN'                " File type (ASCII, binary ...)

  CHANGING
    data_tab                  =  lt_pdf_data                    " Transfer table
  EXCEPTIONS
    file_write_error          = 1                    " Cannot write to file
    no_batch                  = 2                    " Front-End Function Cannot Be Executed in Backgrnd
    gui_refuse_filetransfer   = 3                    " Incorrect Front End
    invalid_type              = 4                    " Invalid value for parameter FILETYPE
    no_authority              = 5                    " No Download Authorization
    unknown_error             = 6                    " Unknown error
    header_not_allowed        = 7                    " Invalid header
    separator_not_allowed     = 8                    " Invalid separator
    filesize_not_allowed      = 9                    " Invalid file size
    header_too_long           = 10                   " Header information currently restricted to 1023 bytes
    dp_error_create           = 11                   " Cannot create DataProvider
    dp_error_send             = 12                   " Error Sending Data with DataProvider
    dp_error_write            = 13                   " Error Writing Data with DataProvider
    unknown_dp_error          = 14                   " Error when calling data provider
    access_denied             = 15                   " Access to File Denied
    dp_out_of_memory          = 16                   " Not Enough Memory in DataProvider
    disk_full                 = 17                   " Storage Medium full
    dp_timeout                = 18                   " Timeout of DataProvider
    file_not_found            = 19                   " Could not find file
    dataprovider_exception    = 20                   " General Exception Error in DataProvider
    control_flush_error       = 21                   " Error in Control Framework
    not_supported_by_gui      = 22                   " GUI does not support this
    error_no_gui              = 23                   " GUI not available
    others                    = 24
  .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.


  CALL FUNCTION 'FP_JOB_CLOSE'
   IMPORTING
     E_RESULT             = lwa_result
   EXCEPTIONS
     USAGE_ERROR          = 1
     SYSTEM_ERROR         = 2
     INTERNAL_ERROR       = 3
     OTHERS               = 4
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

*
ENDFORM.                    " DISPLAY_DATA
*&---------------------------------------------------------------------*
