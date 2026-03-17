*ITMTXT*&---------------------------------------------------------------------*
* Include           ZSD_PENDING_SO_DATASEL.
*&---------------------------------------------------------------------*
* Texts
 TYPES: BEGIN OF ty_hdtext,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          obj   TYPE tdobject,
          id    TYPE tdid,
          name  TYPE tdname,
          text  TYPE text255,
        END   OF ty_hdtext,

        BEGIN OF ty_mattxt,
          matnr  TYPE matnr,
          mattxt TYPE tdline,
        END   OF ty_mattxt,

        BEGIN OF ty_so,
          vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
        END   OF ty_so,

        BEGIN OF ty_text,
          tpi             TYPE text50,
          freight         TYPE text128,
          ofm             TYPE text50,
          ofm_date        TYPE text50,
          insur           TYPE text250,
          spl             TYPE text255,
          ld_txt          TYPE text50,
          tag_req         TYPE text50,
          pardel          TYPE text250,
          quota_ref       TYPE text128,
          zcust_proj_name TYPE text250,
          amendment_his   TYPE text250,
          po_dis          TYPE text250,
          full_pmnt       TYPE text255,
          proj            TYPE text255,
          cond            TYPE text255,
          infra           TYPE text255,
          validation      TYPE text255,
          review_date     TYPE text255,
          diss_summary    TYPE text255,
          ofm_no          TYPE text128,
          special_comm    TYPE text250,
          itmtxt          TYPE text255,
          po_sr_no        TYPE text128,

        END   OF ty_text,

        tty_hdtext TYPE STANDARD TABLE OF ty_hdtext,
        tty_mattxt TYPE STANDARD TABLE OF ty_mattxt,
        tty_so     TYPE STANDARD TABLE OF ty_so.

 DATA:
   ls_exch_rate TYPE bapi1093_0,
   lv_pos       TYPE sy-curow.

 DATA: lv_vbe    TYPE char10,
       lv_pos1   TYPE char6,

       gt_hdtext TYPE tty_hdtext,
       gt_mattxt TYPE tty_mattxt,
       gt_so     TYPE tty_so,
       GS_tEXT   TYPE ty_text.

 START-OF-SELECTION.

   IF open_so = 'X'.

     SELECT a~vbeln
            a~posnr
            a~matnr
            a~lgort
            a~lfsta
            a~lfgsa
*           A~FKSTA
            a~absta
            a~gbsta
     INTO TABLE it_data
     FROM  vbap AS a

     WHERE a~erdat  IN s_date
     AND   a~matnr  IN s_matnr
     AND   a~vbeln  IN s_vbeln         "SHREYAS
     AND   a~lfsta  NE 'C'
     AND   a~lfgsa  NE 'C'
     AND   a~gbsta  NE 'C'.

*******ADDED BY SNEHAL RAJALE ON 29 JAN 201************
     LOOP AT it_data INTO ls_data.
       IF ls_data-absta = 'C'.
         IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' "AND LS_DATA-FKSTA = ' ' "FR
                                                       AND ls_data-gbsta = ' '.
*        IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' AND ls_data-gbsta = ' '.
           IF sy-subrc = 0.
*            delete it_data[] from ls_data.
             DELETE it_data[]  WHERE vbeln = ls_data-vbeln AND posnr = ls_data-posnr.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDLOOP.

********************        edited by PJ on 16-08-21
*    SELECT matnr item_type bom zpen_item zre_pen_item FROM mara
*      INTO TABLE it1_mara
*      FOR ALL ENTRIES IN it_data WHERE matnr = it_data-matnr.

*****************        end

*******ENDED BY SNEHAL RAJALE ON 29 JAN 2021************
*        IF sy-subrc = 0.
     IF it_data[] IS NOT INITIAL.
       SELECT vbeln
              erdat
              auart
              lifsk
              waerk
              vkbur
              knumv
              vdatu
              bstdk
              kunnr
              objnr              "added by pankaj 04.02.2022
              zldfromdate
              zldperweek
              zldmax
              faksk
              vkorg     "ADD BY SYPRIYA ON 19.08.2024
              vtweg     "ADD BY SYPRIYA ON 19.08.2024
              spart     "ADD BY SYPRIYA ON 19.08.2024

              FROM vbak INTO TABLE it_vbak
              FOR ALL ENTRIES IN it_data WHERE vbeln = it_data-vbeln AND
                                               kunnr IN s_kunnr.          " SHREYAS.


       PERFORM fill_tables.
       PERFORM process_for_output.
       IF p_down IS   INITIAL.
         PERFORM alv_for_output.

       ELSE.
         PERFORM down_set.
       ENDIF.

     ENDIF.

   ELSEIF all_so = 'X'.

     SELECT vbeln
            erdat
            auart
            lifsk
            waerk
            vkbur
            knumv
            vdatu
            bstdk
            kunnr
            objnr              "added by pankaj 04.02.2022
            zldfromdate
            zldperweek
            zldmax
            faksk
            vkorg     "ADD BY SYPRIYA ON 19.08.2024
            vtweg     "ADD BY SYPRIYA ON 19.08.2024
            spart     "ADD BY SYPRIYA ON 19.08.2024
*           faksk
            FROM vbak INTO TABLE it_vbak WHERE erdat IN s_date AND
                                                 vbeln IN s_vbeln AND "shreyas
                                                 kunnr IN s_kunnr . "shreyas.
*                                                bukrs_vf = 'PL01'.

*    if it_vbak is not initial.
*      select spras
*             faksp
*             vtext
*        from tvfst into table it_tvfst
*        for all entries in it_vbak
*        where faksp = it_vbak-faksk
*        and spras = 'EN'.
*    endif.

**************************************************************************************
*      select * from vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak where vbeln = it_vbak-vbeln.
**************************************************************************************
     IF sy-subrc = 0.
       PERFORM fill_tables.
       PERFORM process_for_output.
       IF p_down IS   INITIAL.
         PERFORM alv_for_output.

       ELSE.
*        BREAK Primus.
         PERFORM down_set_all.
       ENDIF.
     ENDIF.

*  ELSE.

   ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

 FORM fill_tables .
   IF open_so = 'X'.
     SELECT FROM vbap AS a
            LEFT OUTER JOIN mara AS b ON b~matnr = a~matnr
            LEFT OUTER JOIN vbep AS c ON c~vbeln = a~vbeln
                                     AND c~posnr = a~posnr
                                     AND c~etenr = '0001'
        FIELDS
            a~vbeln,
            a~posnr,
            a~matnr,
            a~arktx,
            a~abgru,
            a~posex,
            a~kdmat,
            a~waerk,
            a~kwmeng,
            a~werks,
            a~ntgew,                 "added by pankaj 28.01.2022
            a~objnr,
            a~holddate,
            a~holdreldate,
            a~canceldate,
            a~deldate,
            a~custdeldate,
            a~zgad,
            a~ctbg,
            a~receipt_date,            "added by pankaj 28.01.2022
            a~reason,                   "added by pankaj 28.01.2022
            a~ofm_date,               "added by pankaj 01.02.2022
            a~erdat,
            a~zins_loc,
            a~lgort,
            a~zmrp_date,       "ADED BY JYOTI ON 02.07.2024
            a~zexp_mrp_date1,    "ADDED BY JYOTI ON 13.11.2024
            a~zhold_reason_n1, "added by jyoti on 06.02.2025

            a~aedat,
            b~item_type,
            b~bom,
            b~zpen_item,
            b~zre_pen_item,
             b~zseries,
             b~zsize,
             b~brand,
             b~moc,
             b~type,
             b~mtart,
             b~wrkst,

            c~etenr,
            c~ettyp,
            c~edatu
            FOR ALL ENTRIES IN @it_data
              WHERE a~vbeln = @it_data-vbeln
                AND a~posnr = @it_data-posnr
                AND a~werks = 'PL01'
            INTO TABLE @it_vbap .

***************************ADDED BY DH**************
     IF it_vbap IS NOT INITIAL.
       LOOP AT it_vbap INTO wa_vbap.
         CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
           EXPORTING
             input  = wa_vbap-vbeln
           IMPORTING
             output = lv_vbeln.

         MOVE-CORRESPONDING wa_vbap TO wa_vbap2.
         wa_vbap2-vbeln = lv_vbeln.
         APPEND wa_vbap2 TO it_vbap2.

       ENDLOOP.

*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
     ENDIF.

     LOOP AT it_vbap2 INTO wa_vbap2.
       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
         EXPORTING
           input  = wa_vbap2-vbeln
         IMPORTING
           output = lv_vbeln2.

       wa_vbap2-vbeln = lv_vbeln2.
       MODIFY it_vbap2 FROM wa_vbap2.
     ENDLOOP.


*****************        end


**************** Reject Service Sale Order Remove From Pending So(Radio Button)
     LOOP AT it_vbak INTO wa_vbak WHERE auart = 'ZESS' OR auart = 'ZSER'.
       LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln AND abgru NE ' '.
         DELETE it_vbap WHERE vbeln = wa_vbap-vbeln AND posnr = wa_vbap-posnr.
       ENDLOOP.
     ENDLOOP.
**************************************************************************



   ELSE.
     SELECT FROM vbap AS a
            LEFT OUTER JOIN mara AS b ON b~matnr = a~matnr
            LEFT OUTER JOIN vbep AS c ON c~vbeln = a~vbeln
                                     AND c~posnr = a~posnr
                                     AND c~etenr = '0001'
        FIELDS
            a~vbeln,
            a~posnr,
            a~matnr,
            a~arktx,
            a~abgru,
            a~posex,
            a~kdmat,
            a~waerk,
            a~kwmeng,
            a~werks,
            a~ntgew ,               "added by pankaj 28.01.2022
            a~objnr,
            a~holddate,
            a~holdreldate,
            a~canceldate,
            a~deldate,
            a~custdeldate,
            a~zgad,
            a~ctbg,
            a~receipt_date,            "added by pankaj 28.01.2022
            a~reason,                   "added by pankaj 28.01.2022
            a~ofm_date,
            a~erdat,
            a~zins_loc,
            a~lgort,
            a~zmrp_date,    "ADDED BY JYOTI ON 02.07.2024
            a~zexp_mrp_date1,    "ADDED BY JYOTI ON 02.07.2024
            a~zhold_reason_n1, "added by jyoti on 06.02.2025

            a~aedat,
            b~item_type,
            b~bom,
            b~zpen_item,
            b~zre_pen_item,
             b~zseries,
             b~zsize,
             b~brand,
             b~moc,
             b~type,
             b~mtart,
             b~wrkst,

            c~etenr,
            c~ettyp,
            c~edatu

            FOR ALL ENTRIES IN @it_vbak WHERE a~vbeln = @it_vbak-vbeln
                                          AND a~werks = 'PL01'
            INTO TABLE @it_vbap.
   ENDIF.
   IF it_vbap[] IS NOT INITIAL.

*****************************ADDED BY DH************
*    lv_vbeln = wa_vbap-vbeln.
     IF it_vbap IS NOT INITIAL.
       LOOP AT it_vbap INTO wa_vbap.
         CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
           EXPORTING
             input  = wa_vbap-vbeln
           IMPORTING
             output = lv_vbeln.

         MOVE-CORRESPONDING wa_vbap TO wa_vbap2.
         wa_vbap2-vbeln = lv_vbeln.
         APPEND wa_vbap2 TO it_vbap2.

       ENDLOOP.
*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
     ENDIF.

     LOOP AT it_vbap2 INTO wa_vbap2.
       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
         EXPORTING
           input  = wa_vbap2-vbeln
         IMPORTING
           output = lv_vbeln2.

       wa_vbap2-vbeln = lv_vbeln2.
       MODIFY it_vbap2 FROM wa_vbap2.
     ENDLOOP.

*    IF IT_VBAP2 IS NOT INITIAL.
*
*      SELECT OBJECTCLAS OBJECTID UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
*       FOR ALL ENTRIES IN IT_VBAP2
*     WHERE OBJECTCLAS = 'VERKBELEG'
*     AND OBJECTID = IT_VBAP2-VBELN             "it_vbap-vbeln
*      AND TCODE = 'VA02'.
*    ENDIF.

*    SORT IT_CDHDR BY UDATE DESCENDING.

*********************************************
*******************        edited by PJ on 16-08-21
*    SELECT matnr item_type bom zpen_item zre_pen_item FROM mara
*      INTO TABLE it1_mara
*      FOR ALL ENTRIES IN it_vbap WHERE matnr = it_vbap-matnr.

*****************        end
     SELECT vbeln
            posnr
            parvw
            kunnr
            adrnr
            land1
            FROM vbpa INTO TABLE lt_vbpa
            FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln.
*                                     AND  posnr = it_vbap-posnr.

*    SELECT vbeln
*           posnr
*           etenr
*           ettyp
*           edatu
*           FROM vbep INTO TABLE it_vbep
*           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
*                                       AND  posnr = it_vbap-posnr.
*
*    SORT it_vbep BY vbeln posnr etenr.
*
*    SELECT vbeln
*           posnr
*           etenr
*           ettyp
*           edatu
*           FROM vbep INTO TABLE lt_vbep
*           FOR ALL ENTRIES IN it_vbap WHERE vbeln = it_vbap-vbeln
*                                       AND  posnr = it_vbap-posnr
*                                       AND  etenr = '0001'
*                                       AND  ettyp = 'CP'.
*
*    SORT lt_vbep BY vbeln posnr etenr.

     SELECT vbeln
            posnr
            inco1
            inco2
            zterm
            ktgrd       "added by 04.02.2022
            kursk
            bstkd
            prsdt
            FROM vbkd INTO TABLE it_vbkd
            FOR ALL ENTRIES IN it_vbap
            WHERE vbeln = it_vbap-vbeln.

     IF it_vbkd IS NOT INITIAL.
       SELECT spras
              zterm
              text1
              FROM t052u INTO TABLE it_t052u
              FOR ALL ENTRIES IN it_vbkd
              WHERE spras = 'EN'
              AND zterm = it_vbkd-zterm.
     ENDIF.


*BREAK primus.
     SELECT matnr
            werks
            lgort
            vbeln
            posnr
            kalab
            kains
            FROM mska INTO TABLE it_mska
            FOR ALL ENTRIES IN it_vbap
            WHERE vbeln = it_vbap-vbeln
              AND posnr = it_vbap-posnr
              AND matnr = it_vbap-matnr
              AND werks = it_vbap-werks.

     IF it_vbak IS NOT INITIAL.

       SELECT knumv
              kposn
              kschl
              kbetr
              waers
              kwert
              FROM  prcd_elements INTO TABLE it_konv
              FOR ALL ENTRIES IN it_vbak
              WHERE knumv = it_vbak-knumv
              AND kschl IN s_kschl.

       SELECT knumv
              kposn
              kschl
              kbetr
              waers
              kwert
              FROM  prcd_elements INTO TABLE it_konv1
              FOR ALL ENTRIES IN it_vbak
              WHERE knumv = it_vbak-knumv.


       SELECT vbelv
              posnv
              vbeln
              vbtyp_n
              FROM vbfa INTO TABLE it_vbfa
              FOR ALL ENTRIES IN it_vbak
              WHERE vbelv = it_vbak-vbeln
                AND ( vbtyp_n = 'J' OR  vbtyp_n = 'M' ).
     ENDIF.

     IF it_vbfa IS NOT INITIAL.
       SELECT vbeln
              fkart
              fktyp
              vkorg
              vtweg
              fkdat
              fksto
              FROM vbrk INTO TABLE it_vbrk
              FOR ALL ENTRIES IN it_vbfa
              WHERE vbeln = it_vbfa-vbeln
                AND fksto NE 'X'.
     ENDIF.
     IF it_vbrk IS NOT INITIAL.
       SELECT vbeln
              posnr
              fkimg
              aubel
              aupos
              matnr
              werks
              FROM vbrp INTO TABLE it_vbrp
              FOR ALL ENTRIES IN it_vbrk
              WHERE vbeln = it_vbrk-vbeln.
     ENDIF.
     IF it_vbap IS NOT INITIAL.
       SELECT * FROM jest INTO TABLE it_jest FOR ALL ENTRIES IN it_vbap WHERE objnr = it_vbap-objnr
                                                                          AND stat IN s_stat
                                                                          AND inact NE 'X'.
     ENDIF.
     IF it_jest IS NOT INITIAL.
       SELECT * FROM tj30 INTO TABLE it_tj30t FOR ALL ENTRIES IN it_jest WHERE estat = it_jest-stat
                                                                          AND stsma  = 'OR_ITEM'.
     ENDIF.


     SELECT aufnr
            posnr
            kdauf
            kdpos
            matnr
            pgmng
            psmng
            wemng
       FROM afpo
       INTO TABLE it_afpo
       FOR ALL ENTRIES IN it_vbap
       WHERE kdauf = it_vbap-vbeln
         AND kdpos = it_vbap-posnr .
     IF sy-subrc = 0.

       SELECT aufnr
              objnr
              kdauf
              kdpos
              igmng
         FROM caufv
         INTO TABLE it_caufv
         FOR ALL ENTRIES IN it_afpo
         WHERE aufnr = it_afpo-aufnr
         AND   kdauf = it_afpo-kdauf
         AND   kdpos = it_afpo-kdpos
         AND   loekz = space.

     ENDIF.
     """""""""""""""   END 05.05.2017         """"""""""""""""""""""""""

     SELECT vbeln
            posnr
            zibr
            zul
            zsl
            zce
            zapi6d
            zapi60
            zatex
            ztrcu
            zcrn
            zmarine
       FROM vbap
       INTO TABLE it_vbap1
       FOR ALL ENTRIES IN it_vbap
       WHERE vbeln = it_vbap-vbeln AND
             posnr = it_vbap-posnr.

   ENDIF.

   IF lt_vbpa IS NOT INITIAL.

     SELECT * FROM adrc INTO TABLE lt_adrc FOR ALL ENTRIES IN lt_vbpa WHERE addrnumber = lt_vbpa-adrnr." AND country = 'IN'.
     IF lt_adrc IS NOT INITIAL.
       FIELD-SYMBOLS : <f1> TYPE zgst_region.

       SELECT * FROM zgst_region INTO TABLE lt_zgst_region ."FOR ALL ENTRIES IN lt_adrc WHERE region = lt_adrc-region.
       LOOP AT lt_zgst_region ASSIGNING <f1>.
         DATA(lv_str_l) =  strlen( <f1>-region ).
         IF lv_str_l = 1.
           CONCATENATE '0' <f1>-region INTO <f1>-region.
         ENDIF.
       ENDLOOP.
     ENDIF.

   ENDIF.

   SELECT kunnr
          name1
          adrnr
          FROM kna1 INTO TABLE it_kna1
          FOR ALL ENTRIES IN it_vbak
          WHERE kunnr = it_vbak-kunnr.

   """"""""" code added by pankaj 04.02.2022""""""""""""""

   IF it_vbkd IS NOT INITIAL.

     SELECT ktgrd
            vtext FROM tvktt INTO TABLE it_tvktt FOR ALL ENTRIES IN it_vbkd WHERE ktgrd = it_vbkd-ktgrd
                                                                            AND spras = 'EN'.

   ENDIF.

*BREAK primus.
   IF  it_vbak IS NOT INITIAL.

     SELECT objnr
            stat
            inact FROM jest INTO TABLE it_jest3 FOR ALL ENTRIES IN it_vbak WHERE objnr = it_vbak-objnr AND inact = ' '.
   ENDIF.

   IF it_jest3 IS NOT INITIAL.

     SELECT stsma
            estat
            txt04 FROM tj30t INTO TABLE it_tj30 FOR ALL ENTRIES IN it_jest3 WHERE estat = it_jest3-stat AND stsma = 'OR_HEADR'.

   ENDIF.


   """""""""""""""""""""""""""""""" ended""""""""""""""""""""""""""""


 ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

 FORM process_for_output .
   DATA:
     lv_ratio TYPE resb-enmng,
     lv_qty   TYPE resb-enmng,
     lv_index TYPE sy-tabix.

   IF it_vbap[] IS NOT INITIAL.
     CLEAR: wa_vbap, wa_vbak, wa_mska,
            wa_vbrp, wa_konv, wa_kna1,wa_vbap1.
     SORT it_vbap BY vbeln posnr matnr werks.
     SORT it_mska BY vbeln posnr matnr werks.
     SORT it_afpo BY kdauf kdpos matnr.
     SORT lt_resb BY aufnr kdauf kdpos.
*BREAK-POINT.
     LOOP AT it_vbap INTO wa_vbap.

       wa_output-lgort = wa_vbap-lgort.   ""added by Pranit 10.06.2024
       wa_output-zmrp_date = wa_vbap-zmrp_date.   ""added by Pranit 10.06.2024
       wa_output-zexp_mrp_date1 = wa_vbap-zexp_mrp_date1.   ""added by JYOTI 13.11.2024
       IF wa_vbap-zhold_reason_n1 IS NOT INITIAL.
         SELECT SINGLE zhold_reason_n1 FROM zhold_reason
           INTO wa_output-hold_reason_n1 WHERE zhold_key = wa_vbap-zhold_reason_n1.
*      wa_output-hold_reason_n1 = wa_vbap-zhold_reason_n1.   ""added by JYOTI 13.11.2024
       ENDIF.
**********ADDED BY DH ****************
       READ TABLE it_vbap2 INTO wa_vbap2 WITH KEY vbeln = wa_vbap-vbeln.

       wa_output-udate = WA_vbap-aedat.


       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = wa_output-udate
         IMPORTING
           output = wa_output-udate.

       CONCATENATE wa_output-udate+0(2) wa_output-udate+2(3) wa_output-udate+5(4)
                       INTO wa_output-udate SEPARATED BY '-'.

       IF wa_output-udate = '--'.
         REPLACE ALL OCCURRENCES OF '--' IN wa_output-udate WITH ' '.
       ENDIF.

       READ TABLE it_data INTO ls_data WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr.     """Added by Pranit 10.06.2024
       IF sy-subrc = 0.
         wa_output-lgort = ls_data-lgort.
       ENDIF.

       wa_output-item_type    = wa_vbap-item_type.
       wa_output-bom    = wa_vbap-bom.
       wa_output-zpen_item    = wa_vbap-zpen_item.
       wa_output-zre_pen_item    = wa_vbap-zre_pen_item.

       wa_output-holddate    = wa_vbap-holddate.        "Statsu
       wa_output-reldate     = wa_vbap-holdreldate.     "Release date
       wa_output-canceldate  = wa_vbap-canceldate.      "Cancel date
       wa_output-deldate     = wa_vbap-deldate.         "delivary date
       wa_output-custdeldate = wa_vbap-custdeldate.         "customer del. date
       wa_output-posex       = wa_vbap-posex.
       wa_output-posex1       = wa_vbap-posex.         "ADDED BY JYOTI ON 16.04.2024
       wa_output-matnr       = wa_vbap-matnr.           "Material
       wa_output-posnr       = wa_vbap-posnr.           "item
       wa_output-arktx       = wa_vbap-arktx.           "item short description
       wa_output-kwmeng      = wa_vbap-kwmeng.          "sales order qty
       wa_output-werks       = wa_vbap-werks.           "PLANT
       wa_output-waerk       = wa_vbap-waerk.           "Currency
       wa_output-kdmat       = wa_vbap-kdmat.
       wa_output-vbeln       = wa_vbap-vbeln.           "Sales Order
       wa_output-zins_loc    = wa_vbap-zins_loc.        "Installation Location


       IF wa_vbap-custdeldate IS NOT INITIAL .
         wa_output-po_del_date = wa_vbap-custdeldate.
       ENDIF.
       IF wa_vbap-zgad = '1'.
         wa_output-gad = 'Reference'.
       ELSEIF wa_vbap-zgad = '2'.
         wa_output-gad = 'Approved'.
       ELSEIF wa_vbap-zgad = '3'.
         wa_output-gad = 'Standard'.
       ENDIF.

       wa_output-ctbg       = wa_vbap-ctbg.               " added by ajay

       """"""""" code added by pankaj 28.01.2022""""""""""""""""""

       wa_output-receipt_date       = wa_vbap-receipt_date.               " added by pankaj 30.12.2021

       IF wa_vbap-reason = '1' OR wa_vbap-reason = '01'.
         wa_output-reason = 'Hold'.
       ELSEIF
         wa_vbap-reason = '2' OR wa_vbap-reason = '02'.
         wa_output-reason = 'Cancel'.
       ELSEIF
         wa_vbap-reason = '3' OR wa_vbap-reason = '03'.
         wa_output-reason = 'QTY Change'.
       ELSEIF
         wa_vbap-reason = '4'OR wa_vbap-reason = '04'.
         wa_output-reason = 'Quality Change'.
       ELSEIF
         wa_vbap-reason = '5' OR wa_vbap-reason = '05'.
         wa_output-reason = 'Technical Changes'.
       ELSEIF
         wa_vbap-reason = '6' OR wa_vbap-reason = '06'.
         wa_output-reason = 'New Line'.
       ELSEIF
       wa_vbap-reason = '07'.
         wa_output-reason = 'Line added against BCR'.
       ELSEIF
       wa_vbap-reason = '08'.
         wa_output-reason = 'Line added against wrong code given by sales'.
       ELSEIF
       wa_vbap-reason = '09'.
         wa_output-reason = 'Line added for split scheduling'.
       ELSEIF
       wa_vbap-reason = '10'.
         wa_output-reason = 'Clubbed line'.
       ELSEIF
     wa_vbap-reason = '11'.
         wa_output-reason = 'Validation line doesn''t show on OA'.
       ENDIF.

       wa_output-ntgew           = wa_vbap-ntgew.
       wa_output-ofm_date1       = wa_vbap-ofm_date.
*      break primus.              "added by pankaj 01.02.2022
       IF  wa_output-ofm_date1 NE '00000000'.
         wa_output-ofm_date1 = wa_output-ofm_date1.
       ELSE.
         wa_output-ofm_date1 = space.
       ENDIF.
       wa_output-chang_so_date = wa_vbap-erdat.
       """""""" code ended""""""""""""""""""""""""""""""'

       READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_output-vbeln.
       IF sy-subrc = 0.
         wa_output-auart        = wa_vbak-auart.           "ORDER TYPE
         wa_output-vkbur        = wa_vbak-vkbur.           "Sales Office
         wa_output-erdat        = wa_vbak-erdat.           "Sales Order date
         wa_output-vdatu        = wa_vbak-vdatu.           "Req del date
         wa_output-bstdk        = wa_vbak-bstdk.
         wa_output-lifsk        = wa_vbak-lifsk.
         wa_output-zldperweek   = wa_vbak-zldperweek.  "LD per week
         wa_output-zldmax       = wa_vbak-zldmax.      "LD Max
         wa_output-zldfromdate  = wa_vbak-zldfromdate. "LD from date
         wa_output-kunnr        = wa_vbak-kunnr.

         wa_output-vkorg = wa_vbak-vkorg .  "ADD BY SUPRIYA ON 19.08.2024
         wa_output-vtweg = wa_vbak-vtweg.    "ADD BY SUPRIYA ON 19.08.2024
         wa_output-spart = wa_vbak-spart.    "ADD BY SUPRIYA ON 19.08.2024

       ENDIF.

       """"""""" code added by pankaj 28.01.2021"""""""""""""""""""""""""

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'ZPR0'  kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-zpr0 = wa_konv1-kbetr.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'ZPF0' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-zpf0 = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kschl = 'ZIN1' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-zin1 = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kschl = 'ZIN2' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-zin2 = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOIG' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-joig = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOCG' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-jocg = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv  kschl = 'JOSG' kposn = wa_vbap-posnr.

       IF sy-subrc = 0.
         wa_output-josg = wa_konv1-kwert.
       ENDIF.

       READ TABLE it_konv1 INTO DATA(wa_konv12) WITH KEY knumv = wa_vbak-knumv  kschl = 'ZDIS' kposn = wa_vbap-posnr. "ADDED BY MAHADEV HEMENT ON 10/12/2025

       IF sy-subrc = 0.
*        WA_OUTPUT-JOSG = WA_KONV12-KWERT.
         wa_output-dis_rate = wa_konv12-kbetr .
         gv_kbetr2 = wa_output-zpr0 * wa_konv12-kbetr / 100  . "ADDED BY MAHADEV SACHIN ON 08/12/2025
         gv_kbetr = gv_kbetr2 - ( - wa_output-zpr0 ). "ADDED BY MAHADEV SACHIN ON 08/12/2025

         gv_kwert = wa_konv12-kwert.
         wa_output-dis_amt  = wa_konv12-kwert.
       ENDIF.
       wa_output-dis_unit_rate  = wa_output-zpr0 - ( - wa_konv12-kwert ).


       """"""""""""" code ended""""""""""""""""""""""""""""""""""""

*      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_output-vbeln
*                                               posnr = wa_output-posnr
*                                               etenr = '0001'.
*      IF sy-subrc = 0.
       wa_output-ettyp       = wa_vbap-ettyp.           "So Status
       wa_output-edatu       = wa_vbap-edatu.           "delivary Date
       wa_output-etenr       = wa_vbap-etenr.           "Schedule line no.
       wa_output-date        = wa_vbap-edatu.
*      ENDIF.
*      READ TABLE it_vbep INTO wa_vbep WITH KEY vbeln = wa_output-vbeln
*                                               posnr = wa_output-posnr
*                                               etenr = '0001'.
*      IF sy-subrc = 0.
*        wa_output-date       = wa_vbep-edatu.
*
*      ENDIF.
*      READ TABLE lt_vbep INTO ls_vbep WITH KEY vbeln = wa_output-vbeln
*                                               posnr = wa_output-posnr
*                                               etenr = '0001'
*                                               ettyp = 'CP'.

       READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = wa_output-vbeln.

*                                               posnr = wa_vbap-posnr.
       IF sy-subrc = 0.
         wa_output-so_exc      = wa_vbkd-kursk.           "SO Exchange Rate
         wa_output-bstkd       = wa_vbkd-bstkd.           "Cust Ref No.
*        wa_output-bstkd1       = wa_vbkd-bstkd.           "ADDED BY JYOTI ON 16.04.2024"Cust Ref No.
         wa_output-zterm       = wa_vbkd-zterm.           "payment terms
         wa_output-inco1       = wa_vbkd-inco1.           "inco terms
         wa_output-inco2       = wa_vbkd-inco2.           "inco terms description
         wa_output-prsdt       = wa_vbkd-prsdt.

       ENDIF.
       ""assesable value
       gv_kwert2 = wa_output-zpr0 - ( - gv_kwert ). " ADDED BY MAHADEV HEMENT ON 10/12/2025
*    LS_FINAL-ASS2_VAL = GV_Kwert2 * wa_vbkd-KURSK . " ADDED BY MAHADEV HEMENT ON 10/12/2025
       wa_output-ass2_val = gv_kwert2 *  wa_vbkd-kursk . " ADDED BY MAHADEV HEMENT ON 10/12/2025

       "" TOTAL assesable value
*     LS_FINAL-TOT_ASS = GV_KBETR . " ADDED BY MAHADEV HEMENT ON 10/12/2025
       wa_output-tot_ass = gv_kbetr *  wa_vbkd-kursk . " ADDED BY MAHADEV HEMENT ON 10/12/2025

       CLEAR wa_kna1.
       READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_output-kunnr.
       IF sy-subrc = 0.
         wa_output-name1       = wa_kna1-name1.           "Cust Name
       ENDIF.


       READ TABLE it_t052u INTO wa_t052u WITH KEY zterm = wa_output-zterm.
       IF sy-subrc = 0.
         wa_output-text1       = wa_t052u-text1.          "payment terms description
       ENDIF.
*      BREAK primus.
       READ TABLE it_vbap1 INTO wa_vbap1 WITH KEY vbeln = wa_output-vbeln
                                                  posnr = wa_output-posnr.
       IF sy-subrc = 0.

         IF wa_vbap1-zibr = 'X'.
           certif_zibr = 'IBR'.
*          CONCATENATE quote certif_zibr quote INTO certif_zibr.
           CONCATENATE wa_output-certif certif_zibr INTO wa_output-certif SEPARATED BY space.
         ENDIF.

         IF wa_vbap1-zul = 'X'.
           certif_zul = 'UL'.
*          CONCATENATE quote certif_zul quote INTO certif_zul.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zul INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zul INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zsl = 'X'.
           certif_zsl = 'SIL3'.
*           CONCATENATE quote certif_zsl quote INTO certif_zsl.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zsl INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zsl INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zce = 'X'.
           certif_zce = 'CE'.
*          CONCATENATE quote certif_zce quote INTO certif_zce.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zce INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zce INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zapi6d = 'X'.
           certif_zapi6d = 'API 6D'.
*          CONCATENATE quote certif_zapi6d quote INTO certif_zapi6d.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zapi6d INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zapi6d INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zapi60 = 'X'.
           certif_zapi60 = 'API 609'.
*          CONCATENATE quote certif_zapi60 quote INTO certif_zapi60.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zapi60 INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zapi60 INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zatex = 'X'.
           certif_zatex = 'ATEX'.
*          CONCATENATE quote certif_zatex quote INTO certif_zatex.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zatex INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zatex INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-ztrcu = 'X'.
           certif_ztrcu = 'TRCU'.
*          CONCATENATE quote certif_ztrcu quote INTO certif_ztrcu.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_ztrcu INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_ztrcu INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zcrn = 'X'.
           certif_zcrn = 'CRN'.
*          CONCATENATE quote certif_zcrn quote INTO certif_zcrn.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zcrn INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zcrn INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         IF wa_vbap1-zmarine = 'X'.
           certif_zmarine = 'MARINE'.
*          CONCATENATE quote certif_zmarine quote INTO certif_zmarine.
           IF wa_output-certif IS INITIAL.
             CONCATENATE wa_output-certif certif_zmarine INTO wa_output-certif SEPARATED BY space.
           ELSE.
             CONCATENATE wa_output-certif certif_zmarine INTO wa_output-certif SEPARATED BY ','.
           ENDIF.
         ENDIF.

         CLEAR : certif_zibr, certif_zul, certif_zsl, certif_zce, certif_zapi6d, certif_zapi60, certif_zatex , certif_ztrcu, certif_zcrn, certif_zmarine.

       ENDIF.

       READ TABLE it_vbrp INTO wa_vbrp WITH KEY vbeln = wa_output-vbeln
                                                posnr = wa_output-posnr.
**TPI TEXT

       CLEAR: lv_lines, wa_lines.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z999'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO wa_lines INDEX 1.

*LD Req Text
       CLEAR: lv_lines, wa_ln_ld.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z038'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO wa_ln_ld INDEX 1.

**********
*Tag Required
       CLEAR: lv_lines, wa_tag_rq.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z039'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO wa_tag_rq INDEX 1.
**********
*******************************ADDED BY JYOTI ON 04.12.2024
*************** CUSTOMER PROJECT NAME*********************
       CLEAR: lv_lines,  wa_cust_proj_name.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z063'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO  wa_cust_proj_name.
           IF  wa_cust_proj_name-tdline IS NOT INITIAL.
             CONCATENATE wa_output-zcust_proj_name  wa_cust_proj_name-tdline INTO wa_output-zcust_proj_name SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.

*  *  *********************************ADDED BY JYOTI ON 20.01.2024**********************************
       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = 'Z064'
           language                = 'E'
           name                    = lv_name
           object                  = 'VBBK'
         TABLES
           lines                   = lv_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.

       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
             CONCATENATE wa_output-amendment_his ls_lines-tdline INTO wa_output-amendment_his SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.


       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = 'Z065'
           language                = 'E'
           name                    = lv_name
           object                  = 'VBBK'
         TABLES
           lines                   = lv_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.

       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
             CONCATENATE wa_output-po_dis ls_lines-tdline INTO wa_output-po_dis SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.

**********************************************************

*Material text
       CLEAR: lv_lines, ls_mattxt.
       REFRESH lv_lines.
       lv_name = wa_output-matnr.
       IF lv_name IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'GRUN'
             language                = sy-langu
             name                    = lv_name
             object                  = 'MATERIAL'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO ls_mattxt INDEX 1.

       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z102'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_ctbgi.
           IF ls_ctbgi-tdline IS NOT INITIAL.
             CONCATENATE wa_output-ofm_no ls_ctbgi-tdline INTO wa_output-ofm_no SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.

       """"""""""""""""""""""""SPECIAL COMMENTS
       CLEAR: lv_lines, wa_ln_ld.
       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z888'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_ctbgi.
           IF ls_ctbgi-tdline IS NOT INITIAL.
             CONCATENATE wa_output-special_comm ls_ctbgi-tdline INTO wa_output-special_comm SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.
       """"""""""""""""""""""""""""""""""""""""

**********changes by madhavi jocg joig JTC1
*konv data
       CLEAR: wa_konv1." WA_OUTPUT.

       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_output-posnr kschl = 'JOCG'.
       IF sy-subrc = 0.
         CLEAR : lv_cgst,lv_cgst_temp.
*        lv_cgst =  wa_konv1-kbetr / 10. """  -- NC
         lv_cgst =  wa_konv1-kbetr.   """ ++ NC
         lv_cgst_temp = lv_cgst.
         CONDENSE lv_cgst_temp.
         wa_output-cgst = lv_cgst_temp.
         wa_output-sgst = lv_cgst_temp.
       ENDIF.
       CLEAR: wa_konv1.
       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_output-posnr kschl = 'JOIG'.
       IF sy-subrc = 0.
         CLEAR : lv_cgst,lv_cgst_temp.
*        lv_cgst =  wa_konv1-kbetr / 10.  """ --NC
         lv_cgst =  wa_konv1-kbetr.  """" ++ NC
         lv_cgst_temp = lv_cgst.
         wa_output-igst = lv_cgst_temp.
*        wa_output-igst_val = wa_konv1-kwert.
       ENDIF.

       CLEAR: wa_konv1.
       READ TABLE it_konv1 INTO wa_konv1 WITH KEY knumv = wa_vbak-knumv kposn = wa_vbap-posnr kschl = 'JTC1'.
       IF sy-subrc = 0.
*        wa_output-tcs = wa_konv1-kbetr / 10.  """ -- NC
         wa_output-tcs = wa_konv1-kbetr .  """ NC
         wa_output-tcs_amt = wa_konv1-kwert.
       ENDIF.

       CLEAR: wa_konv.

       SELECT SINGLE knumv
                     kposn
                     kschl
                     kbetr
                     waers
                     kwert
                     FROM  prcd_elements INTO wa_konv WHERE  knumv = wa_vbak-knumv
                                              AND   kposn = wa_output-posnr
                                              AND   kschl = 'ZPR0'.
       wa_output-kbetr       = wa_konv-kbetr.           "Rate

       CLEAR: wa_konv .
       SELECT SINGLE knumv
                     kposn
                     kschl
                     kbetr
                     waers
                     kwert
                     FROM  prcd_elements INTO wa_konv WHERE knumv = wa_vbak-knumv
                                              AND   kposn = wa_output-posnr
                                              AND   kschl = 'VPRS'.
       IF wa_vbap-waerk <> 'INR'.
         IF wa_konv-waers <> 'INR'.
           wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
         ENDIF.
       ENDIF.

       wa_output-in_price    = wa_konv-kbetr.           "Internal Price

       CLEAR: wa_konv .

       SELECT SINGLE knumv
                     kposn
                     kschl
                     kbetr
                     waers
                     kwert
                     FROM prcd_elements INTO wa_konv WHERE knumv = wa_vbak-knumv
                                              AND   kposn = wa_output-posnr
                                              AND  kschl = 'ZESC'.
       IF wa_vbap-waerk <> 'INR'.
         IF wa_konv-waers <> 'INR'.
           wa_konv-kbetr = wa_konv-kbetr * wa_vbkd-kursk.
         ENDIF.
       ENDIF.

       wa_output-est_cost    = wa_konv-kbetr.           "Estimated cost


       CLEAR wa_jest1.
       READ TABLE it_jest INTO wa_jest1 WITH KEY objnr = wa_vbap-objnr.

       SELECT SINGLE * FROM tj30t INTO wa_tj30t  WHERE estat = wa_jest1-stat
                                                 AND stsma  = 'OR_ITEM'
                                                 AND spras  = 'EN'.
       IF sy-subrc = 0.
         wa_output-status      = wa_tj30t-txt30.          "Hold/Unhold
       ENDIF.

       CLEAR : wa_mska.


       LOOP AT it_mska INTO wa_mska WHERE vbeln = wa_output-vbeln AND
                                          posnr = wa_output-posnr AND
                                          matnr = wa_output-matnr AND
                                          werks = wa_output-werks.

         CASE wa_mska-lgort.
           WHEN 'FG01'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
*          WHEN 'TPI1'.
*            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'PRD1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'RM01'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'RWK1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SC01'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SFG1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SPC1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SRN1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'VLD1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SLR1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KFG0'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KMCN'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KNDT'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KPLG'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KPR1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KPRD'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KRJ0'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KRM0'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KRWK'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSC0'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSCR'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSFG'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSLR'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSPC'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KSRN'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
*          WHEN 'KTPI'.
*            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KVLD'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'SUPT'.                                                      """"ADDED BY PRANIT 17.01.2024
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KUPT'.                                                        """"ADDED BY PRANIT 17.01.2024
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'KTPI'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
           WHEN 'TPI1'.
             wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
         ENDCASE.
         IF sy-subrc = 0.

         ENDIF.
       ENDLOOP.

*DELIVARY QTY
       CLEAR: wa_vbfa, wa_lfimg, wa_lfimg_sum.
       LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_output-vbeln
                                    AND posnv = wa_output-posnr
                                    AND vbtyp_n = 'J'.

         CLEAR wa_lfimg.
         SELECT SINGLE lfimg FROM lips INTO  wa_lfimg  WHERE vbeln = wa_vbfa-vbeln
                                                       AND   pstyv = 'ZTAN'
                                                       AND   vgbel = wa_output-vbeln
                                                       AND   vgpos = wa_output-posnr.
         wa_lfimg_sum = wa_lfimg_sum + wa_lfimg .

       ENDLOOP.

*INVOICE QTY
       CLEAR: wa_vbfa, wa_fkimg, wa_fkimg_sum.
       LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_output-vbeln
                                      AND posnv = wa_output-posnr
                                      AND vbtyp_n = 'M'.

         CLEAR wa_vbrk.
         READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.

         CLEAR wa_fkimg.
         SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                       AND   aubel = wa_output-vbeln
                                                       AND   aupos = wa_output-posnr.
         wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
       ENDLOOP.

****
       CLEAR wa_mbew.
       SELECT SINGLE * FROM mbew INTO wa_mbew WHERE matnr = wa_output-matnr
                                                AND bwkey = wa_output-werks.

*      CLEAR wa_mara.
*      SELECT SINGLE * FROM mara INTO wa_mara WHERE matnr = wa_output-matnr.

       """"""""""     Added By KD on 04.05.2017    """""""""""
       SELECT SINGLE dispo FROM marc INTO wa_output-dispo WHERE matnr = wa_output-matnr.
       """""""""""""""""""""""""""""""""""""""""""""""""""
*currency conversion
       REFRESH ls_fr_curr.
       CLEAR ls_fr_curr.
       ls_fr_curr-sign   = 'I'.
       ls_fr_curr-option = 'EQ'.
       ls_fr_curr-low = wa_vbak-waerk.
       APPEND ls_fr_curr.
       CLEAR: ls_ex_rate,lv_ex_rate, ls_return.
       REFRESH: ls_ex_rate, ls_return.
       IF ls_to_curr-low <> ls_fr_curr-low.

         CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
           EXPORTING
             date             = sy-datum
             date_type        = 'V'
             rate_type        = 'B'
           TABLES
             from_curr_range  = ls_fr_curr
             to_currncy_range = ls_to_curr
             exch_rate_list   = ls_ex_rate
             return           = ls_return.

         CLEAR lv_ex_rate.
         READ TABLE ls_ex_rate INTO lv_ex_rate INDEX 1.
       ELSE.
         lv_ex_rate-exch_rate = 1.
       ENDIF.

*Latest Estimated cost
       REFRESH: it_konh.
       CLEAR:   it_konh.

*  FOR ZESC
       SELECT * FROM konh INTO TABLE it_konh WHERE kotabnr = '508'
                                               AND kschl  = 'ZESC'
                                               AND knumh = wa_output-matnr
*                                              AND vakey = wa_output-matnr
                                               AND knumh = wa_output-matnr
                                               AND datab <= sy-datum
                                               AND datbi >= sy-datum .
       SORT  it_konh DESCENDING BY knumh .
       CLEAR wa_konh.
       READ TABLE it_konh INTO wa_konh INDEX 1.

       CLEAR wa_konp.
       SELECT SINGLE * FROM konp INTO wa_konp WHERE knumh = wa_konh-knumh
                                               AND kschl  = 'ZESC'.

*      CLEAR WA_CDPOS.
*      DATA tabkey TYPE cdpos-tabkey.
*      CONCATENATE sy-mandt wa_vbep-vbeln wa_vbep-posnr wa_vbep-etenr INTO tabkey.
*--Original Code
********PJ on 01-10-21*********************************************

*     ******We dont want this code for PendinG so and all To reduce TimING OF EXECUTION OF THE PROGRAM
*            for MRP Date As disscussion with Parag and Joshi Sir.
       IF open_so = 'X' AND all_so NE 'X' AND 1 = 2. "Added By Nilay B. On 06.09.2023 "1=2 added by farhan on dated 13.11.2025
*      IF .                     "commented by pankaj 05.10.2021
*        SELECT * FROM CDPOS INTO TABLE IT_CDPOS WHERE TABKEY = TABKEY
*
***                                               AND value_new = 'CP'
***                                               AND value_old = 'CN'
*                                                 AND TABNAME = 'VBEP' AND FNAME = 'ETTYP'.
*--End Original
*--Start change by CRC
         DATA : r_objectclas TYPE RANGE OF cdpos-objectclas.

*        SELECT *
*      FROM CDPOS INTO TABLE IT_CDPOS
*      WHERE OBJECTCLAS IN R_OBJECTCLAS
*      AND   TABKEY  = TABKEY
*      AND   TABNAME = 'VBEP'
*      AND   FNAME   = 'ETTYP'.
**-- End Change
*        SORT IT_CDPOS BY CHANGENR DESCENDING.
*        READ TABLE IT_CDPOS INTO WA_CDPOS INDEX 1.
*        IF WA_CDPOS-VALUE_NEW = 'CP' .
*          SELECT SINGLE * FROM CDHDR INTO WA_CDHDR WHERE CHANGENR = WA_CDPOS-CHANGENR.
*
*          WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar
*
*        ENDIF.
*        CLEAR WA_CDHDR.

*      ENDIF.                      "commented by pankaj 05.10.2021
       ENDIF.                       "Added By Nilay B. On 06.09.2023
       IF open_so = 'X' AND all_so NE 'X'.
         TYPES:
           BEGIN OF zty_changes,
             objectclas TYPE cdobjectcl,
             objectid   TYPE cdobjectv,
             changenr   TYPE cdchangenr,
             username   TYPE cdchangenr,
             udate      TYPE cddatum,
             utime      TYPE cduzeit,
             tcode      TYPE cdtcode,
             planchngnr TYPE planchngnr,
             act_chngno TYPE cd_chngno,
             was_plannd TYPE cd_planned,
             change_ind TYPE cdchngindh,
             langu      TYPE langu,
             version    TYPE char3,

             tabname    TYPE tabname,
             tabkey     TYPE cdtabkey,
             fname      TYPE fieldname,
             chngind    TYPE cdchngind,
             text_case  TYPE cdxfeld,
             unit_old   TYPE cdunit,
             unit_new   TYPE cdunit,
             cuky_old   TYPE cdcuky,
             cuky_new   TYPE cdcuky,
             value_new  TYPE cdfldvaln,
             value_old  TYPE cdfldvalo,

           END OF zty_changes .
         DATA: it_changes TYPE TABLE OF  zty_changes,
               wa_changes TYPE zty_changes.


*        CALL METHOD zcl_change_doc_amdp=>get_changes
*          EXPORTING
*            tabkey     = tabkey
*          IMPORTING
*            et_changes = it_changes.
         READ TABLE it_changes INTO wa_changes INDEX 1.
         wa_output-mrp_dt =   wa_changes-udate.
       ENDIF.
*     ******We dont want this code for Pendind so and all To reduce Timn for MRP Date As disscussion with Parag and Joshi Sir.
**********end****************************
       CLEAR wa_tvagt.
       SELECT SINGLE spras
                     abgru
                     bezei
                     FROM tvagt INTO  wa_tvagt
                     WHERE abgru = wa_vbap-abgru AND spras = 'E'.

*Sales text
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = '0001'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_itmtxt.
           IF ls_itmtxt-tdline IS NOT INITIAL.
             CONCATENATE wa_output-itmtxt ls_itmtxt-tdline INTO wa_output-itmtxt SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.
*wa_output-itmtxt = ls_itmtxt-tdline.

*********CTBG Item Details     "added by SR on 03.05.2021

       CLEAR: lv_lines, ls_ctbgi,lv_name.
       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z061'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
*  ENDIF.
         READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

         IF lv_lines IS NOT INITIAL.
           LOOP AT lv_lines INTO ls_ctbgi.
             IF ls_ctbgi-tdline IS NOT INITIAL.
*            CONCATENATE wa_output-ctbgi ls_ctbgi-tdline INTO wa_output-ctbgi SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
*************
********Insurance
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z017'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

         IF lv_lines IS NOT INITIAL.
           LOOP AT lv_lines INTO ls_itmtxt.
             IF ls_itmtxt-tdline IS NOT INITIAL.
               CONCATENATE wa_output-insur ls_itmtxt-tdline INTO wa_output-insur SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = '0001'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
         READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

         IF lv_lines IS NOT INITIAL.
           LOOP AT lv_lines INTO ls_ctbgi.
             IF ls_ctbgi-tdline IS NOT INITIAL.
               CONCATENATE wa_output-mat_text ls_ctbgi-tdline INTO wa_output-mat_text SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
********Insurance***********
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z047'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

         IF lv_lines IS NOT INITIAL.
           LOOP AT lv_lines INTO ls_itmtxt.
             IF ls_itmtxt-tdline IS NOT INITIAL.
               CONCATENATE wa_output-pardel ls_itmtxt-tdline INTO wa_output-pardel SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.

*      BREAK primus.
       SELECT SINGLE vtext INTO wa_output-vtext FROM tvlst WHERE lifsp = wa_vbak-lifsk AND spras = 'EN'.
       CLEAR wa_text1.
*                                    wa_text = wa_tag_rq-tdline(20).
       wa_text1 = wa_tag_rq-tdline(50).     "CHANGED BY SR ON 03.05.2021
       TRANSLATE wa_text1 TO UPPER CASE .       "tag Required
*                                    wa_output-tag_req     = wa_text(1).
       wa_output-tag_req     = wa_text1.      "CHANGED BY SR ON 03.05.2021

       wa_output-lfimg       = wa_lfimg_sum.                "del qty
       wa_output-fkimg       = wa_fkimg_sum.                "inv qty
       wa_output-pnd_qty     = wa_output-kwmeng - wa_output-fkimg.  "Pending Qty

       IF wa_tvagt-abgru IS INITIAL.
         wa_output-abgru           =  '-'.   " avinash bhagat 20.12.2018
       ELSE.
         wa_output-abgru           =  wa_tvagt-abgru.   " avinash bhagat 20.12.2018
       ENDIF.
       IF wa_tvagt-bezei IS INITIAL.
         wa_output-bezei           =  '-'.   " avinash bhagat 20.12.2018
       ELSE.
         wa_output-bezei           =  wa_tvagt-bezei.   " avinash bhagat 20.12.2018
       ENDIF.
**      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR WA_OUTPUT-ETENR     """"""""""" --NC

       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
         EXPORTING
           input  = wa_output-vbeln
         IMPORTING
           output = lv_vbe.
       .


       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
         EXPORTING
           input  = wa_output-posnr
         IMPORTING
           output = lv_pos1.
       .

       CONCATENATE lv_vbe lv_pos1     """"""""""" ++NC
*        INTO WA_OUTPUT-SCHID(25). "commented by supriya on 2024.08.20
           INTO wa_output-schid SEPARATED BY '-'.
       CLEAR : lv_pos1 ,lv_vbe .

       DATA lv_qmqty TYPE mska-kains.
       CLEAR lv_qmqty.

       READ TABLE it_mska INTO wa_mska WITH KEY vbeln = wa_vbap-vbeln
                                                posnr = wa_vbap-posnr
                                                matnr = wa_vbap-matnr
                                                werks = wa_vbap-werks.
       IF sy-subrc IS INITIAL.
         lv_index = sy-tabix.
         LOOP AT it_mska INTO wa_mska FROM lv_index.
           IF wa_mska-vbeln = wa_vbap-vbeln AND wa_mska-posnr = wa_vbap-posnr
            AND wa_mska-matnr = wa_vbap-matnr AND wa_mska-werks = wa_vbap-werks.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
             lv_qmqty = wa_mska-kains + lv_qmqty.
           ELSE.
             CLEAR lv_index.
             EXIT.
           ENDIF.
         ENDLOOP.
       ENDIF.

       wa_output-qmqty = lv_qmqty.
       wa_output-mattxt = ls_mattxt-tdline.

       CLEAR wa_text1.
*                                    wa_text = wa_lines-tdline(20).
       wa_text1 = wa_lines-tdline(50).            "added by sr 0n 03.05.2021
       TRANSLATE wa_text1 TO UPPER CASE .
       wa_output-tpi         = wa_text1.     "TPI Required

*      CLEAR wa_text1.
*                                    wa_text = wa_ln_ld-tdline(20).     "wa_ln_ld ld_req
       wa_text1 = wa_ln_ld-tdline(50).     "added by sr 0n 03.05.2021
       TRANSLATE wa_text1 TO UPPER CASE .
       wa_output-ld_txt         = wa_text1.     "lD Required

*                                    CLEAR wa_text.
*                                    wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*                                    TRANSLATE wa_text TO UPPER CASE .
*                                    wa_output-ofm_no         = wa_text(1).     "ofm sr no

       wa_output-curr_con     = lv_ex_rate-exch_rate.    "Currency conversion

       IF lv_ex_rate-exch_rate IS NOT INITIAL.
         wa_output-amont       = wa_output-pnd_qty * wa_output-dis_unit_rate *  "added by mahadev hement on 11 /12/2025
                               lv_ex_rate-exch_rate.    "Amount
         wa_output-ordr_amt    = wa_output-kwmeng * wa_output-dis_unit_rate *   "added by mahadev hement on 11 /12/2025
                                lv_ex_rate-exch_rate.    "Ordr Amount
         CONDENSE wa_output-ordr_amt.
       ELSEIF lv_ex_rate-exch_rate IS INITIAL.
         wa_output-amont       = wa_output-pnd_qty * wa_output-dis_unit_rate .  "added by mahadev hement on 11 /12/2025
         wa_output-ordr_amt    = wa_output-kwmeng * wa_output-dis_unit_rate .    "added by mahadev hement on 11 /12/2025
         CONDENSE wa_output-ordr_amt.
       ENDIF.
*      ENDCATCH.
       wa_output-in_pr_dt    = wa_mbew-laepr.           "Internal Price Date
       wa_output-st_cost     = wa_mbew-stprs .          "Standard Cost
*      wa_output-latst_cost   =  wa_KONV-KBETR.                    "
       wa_output-latst_cost    = wa_konp-kbetr.        "LATEST EST COST
       wa_output-zseries     = wa_vbap-zseries.         "series
       wa_output-zsize       = wa_vbap-zsize.           "size
       wa_output-brand       = wa_vbap-brand.           "Brand
       wa_output-moc         = wa_vbap-moc.             "MOC
       wa_output-type        = wa_vbap-type.            "TYPE
       wa_output-mtart        = wa_vbap-mtart.          " Material TYPE        """" Addded by KD on 05.05.2017
       wa_output-wrkst        = wa_vbap-wrkst.          "Basic Material(Usa Item Code)
*      wa_output-normt      = wa_mara-normt.

       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z015'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-ofm ls_lines-tdline INTO wa_output-ofm SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF .
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
*            CLIENT                  = SY-MANDT
             id                      = 'Z016'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-ofm_date ls_lines-tdline INTO wa_output-ofm_date SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
*
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z020'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-spl ls_lines-tdline INTO wa_output-spl SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
*************USA CUSTOMER CODE
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_output-bstkd.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'F22'
             language                = 'E'
             name                    = lv_name
             object                  = 'EKKO'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-us_cust ls_lines-tdline INTO wa_output-us_cust SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       """"""""""""" code added by pankaj 28.01.2022"""""""""""""""""

       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z102'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-proj ls_lines-tdline INTO wa_output-proj SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.

       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z103'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-cond ls_lines-tdline INTO wa_output-cond SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       """""""""""""""" code ended"""""""""""""""""""""""""""""
       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z012'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       """""""""""" code added by pankaj 31.01.2022""""""""""""""""

*           infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary TYPE char25

       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z104'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z105'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF .

       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z106'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.

       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z107'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
               CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""

*****************************************************************************************************************************
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z066'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
*              CONCATENATE wa_output-ofm_received_date ls_lines-tdline INTO wa_output-ofm_received_date SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z067'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* Implement suitable error handling here
         ENDIF.
         IF NOT lv_lines IS INITIAL.
           LOOP AT lv_lines INTO ls_lines.
             IF NOT ls_lines-tdline IS INITIAL.
*              CONCATENATE wa_output-oss_received_cell ls_lines-tdline INTO wa_output-oss_received_cell SEPARATED BY space.  """ nc
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.
       CLEAR :lv_lines,ls_lines.
       REFRESH lv_lines.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = 'Z068'
           language                = sy-langu
           name                    = lv_name
           object                  = 'VBBK'
         TABLES
           lines                   = lv_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.
       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE wa_output-source_rest ls_lines-tdline INTO wa_output-source_rest SEPARATED BY space.
           ENDIF.
         ENDLOOP.
*        CONDENSE wa_output-source_rest.
       ENDIF.
       REFRESH :lv_lines.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = 'Z069'
           language                = sy-langu
           name                    = lv_name
           object                  = 'VBBK'
         TABLES
           lines                   = lv_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.
       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE wa_output-suppl_rest ls_lines-tdline INTO wa_output-suppl_rest SEPARATED BY space.
           ENDIF.
         ENDLOOP.
*        CONDENSE wa_output-suppl_rest.
       ENDIF.
       REFRESH :lv_lines.
       CLEAR lv_name.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = 'Z110'
           language                = sy-langu
           name                    = lv_name
           object                  = 'VBBP'
         TABLES
           lines                   = lv_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.
       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
*            CONCATENATE wa_output-cust_mat_desc ls_lines-tdline INTO wa_output-cust_mat_desc SEPARATED BY space.
           ENDIF.
         ENDLOOP.
*        CONDENSE wa_output-cust_mat_desc.
       ENDIF.

*********************************************************************************************************************

       REFRESH : it_jest2 , it_jest2[] .
       CLEAR : wa_afpo , wa_caufv.

       LOOP AT it_afpo INTO wa_afpo WHERE kdauf = wa_vbap-vbeln
                                      AND kdpos = wa_vbap-posnr
                                      AND matnr = wa_vbap-matnr.

         READ TABLE it_caufv INTO wa_caufv WITH KEY aufnr = wa_afpo-aufnr
                                                    kdauf = wa_afpo-kdauf
                                                    kdpos = wa_afpo-kdpos.
         IF sy-subrc = 0.
           SELECT objnr stat FROM jest INTO TABLE it_jest2
                                 WHERE objnr = wa_caufv-objnr
                                   AND inact = ' '.
********************************Commented by SK(22.09.17)
           CLEAR wa_jest2 .
           READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0012' BINARY SEARCH .
           IF sy-subrc NE 0.
             CLEAR wa_jest2 .
             READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0009' BINARY SEARCH .
             IF sy-subrc NE 0.
               CLEAR wa_jest2 .
               READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0002' BINARY SEARCH .
               IF sy-subrc = 0.
                 wa_output-wip = wa_output-wip + wa_afpo-psmng - wa_caufv-igmng ."wa_afpo-pgmng
               ENDIF.
             ENDIF.
           ENDIF.


         ENDIF.

       ENDLOOP.

       wa_output-ref_dt = sy-datum.
       """ Ship to party logic

       READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = wa_vbap-posnr parvw = 'WE'.
       IF sy-subrc = 0.
         wa_output-ship_kunnr = ls_vbpa-kunnr.
         wa_output-ship_land = ls_vbpa-land1.
         READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
         IF sy-subrc = 0.
           wa_output-ship_kunnr_n = ls_adrc-name1.
           READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
           IF sy-subrc = 0.
             wa_output-ship_reg_n = ls_zgst_region-bezei.
           ENDIF.
         ENDIF.
       ELSE.
         READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln posnr = ' '  parvw = 'WE'.
         wa_output-ship_kunnr = ls_vbpa-kunnr.
         wa_output-ship_land = ls_vbpa-land1.
         READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
         IF sy-subrc = 0.
           wa_output-ship_kunnr_n = ls_adrc-name1.
           READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
           IF sy-subrc = 0.
             wa_output-ship_reg_n = ls_zgst_region-bezei.
           ENDIF.
         ENDIF.
       ENDIF.

       READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'AG'.
       IF sy-subrc = 0.
         wa_output-sold_land = ls_vbpa-land1.
         READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
         IF sy-subrc = 0.
*          wa_output-ship_kunnr_n = ls_adrc-name1.
           READ TABLE lt_zgst_region INTO ls_zgst_region WITH KEY region = ls_adrc-region.
           IF sy-subrc = 0.
             wa_output-sold_reg_n = ls_zgst_region-bezei.
           ENDIF.
         ENDIF.
       ENDIF.

       SELECT SINGLE landx50 INTO wa_output-s_land_desc FROM t005t WHERE spras = 'EN' AND land1 = wa_output-ship_land.

       """"""" code added by pankaj 04.02.2022"""""""""""""""""""
* Commented by Dhanashree because this field shows in downloaded excel
**      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'PT'.
**      IF sy-subrc = 0.
**        wa_output-adrnr = ls_vbpa-adrnr.

       READ TABLE lt_adrc INTO ls_adrc WITH KEY addrnumber = ls_vbpa-adrnr.
       IF sy-subrc = 0.
         wa_output-port = ls_adrc-name1.

       ENDIF.
*      ENDIF.
       """"""""""""""""""""""""""""""""""""""""""""""""
************        edited by PJ on 08-09-21

       wa_output-ref_time = sy-uzeit.

*BREAK PRIMUS.
       CONCATENATE wa_output-ref_time+0(2) ':' wa_output-ref_time+2(2)  INTO wa_output-ref_time.

       """"""""""'''  code added by pankaj 04.02.2022""""""""""""""""""""""""

       CLEAR: lv_lines, ls_lines.
       REFRESH lv_lines.
       lv_name = wa_vbak-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z101'
             language                = 'E'
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF.
       IF NOT lv_lines IS INITIAL.
         LOOP AT lv_lines INTO ls_lines.
           IF NOT ls_lines-tdline IS INITIAL.
             CONCATENATE wa_output-full_pmnt ls_lines-tdline INTO wa_output-full_pmnt SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.

       READ TABLE it_tvktt INTO wa_tvktt WITH  KEY ktgrd = wa_vbkd-ktgrd .     "wa_output-ktgrd.   "04.02
       IF sy-subrc = 0.

         wa_output-act_ass       = wa_tvktt-vtext.

       ENDIF.

*     CLEAR wa_jest1.
       READ TABLE it_jest3 INTO wa_jest3 WITH KEY objnr = wa_vbak-objnr.

       SELECT SINGLE * FROM tj30t INTO wa_tj30t  WHERE estat = wa_jest3-stat AND stsma  = 'OR_HEADR'.

       IF sy-subrc = 0.
*        wa_output-stsma      = wa_tj30-stsma.
         wa_output-txt04      = wa_tj30t-txt04.
       ENDIF.

       """""""""""" ended"""""""""""""""""""""""""""""""""""""
*********************ADDED BY SHREYA *********************
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z005'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
       ENDIF.
       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_itmtxt.
           IF ls_itmtxt-tdline IS NOT INITIAL.
             CONCATENATE wa_output-freight ls_itmtxt-tdline INTO wa_output-freight SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.
********************************ADDED BY JYOTI ON 19.06.2024****************
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL.
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z062'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
       ENDIF.
       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_itmtxt.
           IF ls_itmtxt-tdline IS NOT INITIAL.
             CONCATENATE wa_output-quota_ref ls_itmtxt-tdline INTO wa_output-quota_ref SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.
******************************************************************************

       REFRESH lv_lines.
       CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z103'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBP'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.
       ENDIF .
       READ TABLE lv_lines INTO ls_ctbgi INDEX 1.

       IF lv_lines IS NOT INITIAL.
         LOOP AT lv_lines INTO ls_ctbgi.
           IF ls_ctbgi-tdline IS NOT INITIAL.
             CONCATENATE wa_output-po_sr_no ls_ctbgi-tdline INTO wa_output-po_sr_no SEPARATED BY space.
           ENDIF.
         ENDLOOP.
       ENDIF.
**************************************** ADDED BY SHREYA**********************
*BREAK-POINT.
       IF wa_vbap-vbeln IS NOT INITIAL.                                                          """Added by MA on 28.03.2024
         SELECT SINGLE matnr FROM vbap INTO @DATA(lv_matnr) WHERE vbeln = @wa_vbap-vbeln  AND werks = 'PL01'.
         SELECT SINGLE * FROM mast INTO @DATA(ls_mast) WHERE matnr = @lv_matnr AND werks = 'PL01'.
         IF ls_mast IS NOT INITIAL.
           wa_output-bom_exist = 'Yes'.
         ELSEIF ls_mast IS INITIAL.
           wa_output-bom_exist = 'No'.
         ENDIF.
       ENDIF.

************     end
       """""""""""""""""""LD REQUIRED CHANGES BY PRANIT 12.12.2024
       BREAK primusabap.
       CLEAR: lv_lines, ls_itmtxt.
       REFRESH lv_lines.
       lv_name = wa_output-vbeln.
       IF lv_name  IS NOT INITIAL .
         CALL FUNCTION 'READ_TEXT'
           EXPORTING
             client                  = sy-mandt
             id                      = 'Z038'
             language                = sy-langu
             name                    = lv_name
             object                  = 'VBBK'
           TABLES
             lines                   = lv_lines
           EXCEPTIONS
             id                      = 1
             language                = 2
             name                    = 3
             not_found               = 4
             object                  = 5
             reference_check         = 6
             wrong_access_to_archive = 7
             OTHERS                  = 8.
         IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
         ENDIF.

         IF lv_lines IS NOT INITIAL.
           LOOP AT lv_lines INTO ls_itmtxt.
             IF ls_itmtxt-tdline IS NOT INITIAL.
               CONCATENATE wa_output-ld_txt ls_itmtxt-tdline INTO wa_output-ld_txt SEPARATED BY space.
             ENDIF.
           ENDLOOP.
         ENDIF.
       ENDIF.

       """""""""""""""""""

       APPEND wa_output TO it_output.
*      CLEAR ls_vbep.
       CLEAR:lv_matnr,ls_mast.
       CLEAR:wa_output-wip,wa_output-stock_qty .
       CLEAR :wa_output,wa_vbap.
     ENDLOOP.

   ENDIF.

   """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
   IF it_output[] IS NOT INITIAL.
     REFRESH : it_oauto , it_oauto[] , it_mast , it_mast[] , it_stko , it_stko[] ,
               it_stpo , it_stpo[] , it_mara , it_mara[] , it_makt , it_makt[] .

     it_oauto[] = it_output[] .
     DELETE it_oauto WHERE dispo NE 'AUT' .
     DELETE it_oauto WHERE mtart NE 'FERT'.

     SELECT matnr werks stlan stlnr stlal FROM mast INTO TABLE it_mast
                                             FOR ALL ENTRIES IN it_oauto
                                                   WHERE matnr = it_oauto-matnr
                                                     AND stlan = 1.

     SELECT stlty stlnr stlal stkoz FROM stko INTO TABLE it_stko
                                       FOR ALL ENTRIES IN it_mast
                                                   WHERE stlnr = it_mast-stlnr
                                                     AND stlal = it_mast-stlal.

     SELECT stlty stlnr stlkn stpoz idnrk FROM stpo INTO TABLE it_stpo
                                             FOR ALL ENTRIES IN it_stko
                                                         WHERE stlnr = it_stko-stlnr
                                                           AND stpoz = it_stko-stkoz .

     SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_stpo
                                                     WHERE matnr = it_stpo-idnrk
                                                       AND mtart = 'FERT' .

     SELECT * FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN it_mara
                                                       WHERE matnr = it_mara-matnr
                                                         AND spras = 'EN'.

     CLEAR wa_output .
     LOOP AT it_makt INTO wa_makt .
       READ TABLE it_stpo INTO wa_stpo WITH KEY idnrk = wa_makt-matnr .
       IF sy-subrc = 0.
         READ TABLE it_stko INTO wa_stko WITH KEY stlnr = wa_stpo-stlnr stkoz = wa_stpo-stpoz .
         IF sy-subrc = 0.
           READ TABLE it_mast INTO wa_mast WITH KEY stlnr = wa_stko-stlnr stlal = wa_stko-stlal.
           IF sy-subrc = 0.
             wa_output-matnr = wa_mast-matnr.
*            wa_output-scmat = wa_makt-matnr.
             wa_output-arktx = wa_makt-maktx.
             CLEAR: lv_lines, ls_itmtxt.



*            BREAK primus.

*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z012'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.

*
*            """""""""""" code added by pankaj 31.01.2022""""""""""""""""
*
**           infra        TYPE char255,         "added by pankaj 31.01.2022
**          validation   TYPE char255,         "added by pankaj 31.01.2022
**          review_date  TYPE char255,         "added by pankaj 31.01.2022
**          diss_summary TYPE char25
*
*           CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z104'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z105'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z106'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*           lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z107'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*            """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""
             APPEND wa_output TO it_output.
             CLEAR wa_output .
           ENDIF.
         ENDIF.
       ENDIF.
       CLEAR : wa_mast , wa_stko , wa_stpo , wa_makt.
     ENDLOOP.

   ENDIF.
   """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

 ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
 FORM alv_for_output .
*ADDING TOP OF PAGE FEATURE
   PERFORM stp3_eventtab_build   CHANGING gt_events[].
   PERFORM comment_build         CHANGING i_list_top_of_page[].
   PERFORM top_of_page.
   PERFORM layout_build          CHANGING wa_layout.
****************************************************************************************

   PERFORM build_fieldcat USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
   PERFORM build_fieldcat USING 'AUART'          'X' '2'   'Order Type'(004)               '15'.
   PERFORM build_fieldcat USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15'.
   PERFORM build_fieldcat USING 'NAME1'          'X' '4'   'Customer'(006)                 '15'.
   PERFORM build_fieldcat USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15'.
   PERFORM build_fieldcat USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15'.
   PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15'.
   PERFORM build_fieldcat USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15'."(010).
   PERFORM build_fieldcat USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15'.
   PERFORM build_fieldcat USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15'.
   PERFORM build_fieldcat USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15'.
   PERFORM build_fieldcat USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15'.
   PERFORM build_fieldcat USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15'. "(015)
   PERFORM build_fieldcat USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '50'.
   PERFORM build_fieldcat USING 'TPI'            'X' '15'  'TPI Required'(044)             '50'.
   PERFORM build_fieldcat USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '50'.
   PERFORM build_fieldcat USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15'.
   PERFORM build_fieldcat USING 'ZLDMAX'        'X' '18'  'LD % Max'(047)                  '15'.
   PERFORM build_fieldcat USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'.
*  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).
*  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
   PERFORM build_fieldcat USING 'MATNR'          'X' '20'   'Item Code'(016)               '18'.
*  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
   PERFORM build_fieldcat USING 'POSNR'          'X' '21'   'Line Item'(017)               '15'.
   PERFORM build_fieldcat USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20'.
   PERFORM build_fieldcat USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15'.
*  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
   PERFORM build_fieldcat USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15'.
   PERFORM build_fieldcat USING 'LFIMG'          'X' '25'   'Delivary Qty'(021)            '15'.
   PERFORM build_fieldcat USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15'.
   PERFORM build_fieldcat USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15'.
   PERFORM build_fieldcat USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15'.
   PERFORM build_fieldcat USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15'.
   PERFORM build_fieldcat USING 'EDATU'          'X' '30'   'Production date'              '15'.   "'Posting Date'(025).
   PERFORM build_fieldcat USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'.
   PERFORM build_fieldcat USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'.
   PERFORM build_fieldcat USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15'.
   PERFORM build_fieldcat USING 'SO_EXC'       'X' '34'   'SO Exchange Rate'(051)          '15'.
   PERFORM build_fieldcat USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15'.
   PERFORM build_fieldcat USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15'.
*  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
   PERFORM build_fieldcat USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15'.
   PERFORM build_fieldcat USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15'.
   PERFORM build_fieldcat USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'.
   PERFORM build_fieldcat USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'.
   PERFORM build_fieldcat USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'.
   PERFORM build_fieldcat USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15'.
   PERFORM build_fieldcat USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15'.
   PERFORM build_fieldcat USING 'BRAND'           'X' '44'   'Brand'(039)                  '15'.
   PERFORM build_fieldcat USING 'MOC'             'X' '45'   'MOC'(040)                    '15'.
   PERFORM build_fieldcat USING 'TYPE'            'X' '46'   'Type'(041)                   '15'.
   """"""""""""'   Added By KD on 04.05.2017    """""""
   PERFORM build_fieldcat USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15'.
   PERFORM build_fieldcat USING 'WIP'              'X' '48'   'WIP'(052)                   '15'.
   PERFORM build_fieldcat USING 'MTART'            'X' '49'   'MAT TYPE'                   '15'.
   PERFORM build_fieldcat USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15'.
   PERFORM build_fieldcat USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15'.
   PERFORM build_fieldcat USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'.
   PERFORM build_fieldcat USING 'MATTXT'           'X' '53'   'Material Text'              '20'.
   PERFORM build_fieldcat USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50'.
   PERFORM build_fieldcat USING 'ETENR'            'X' '55'   'Schedule_no'                '15'.
   PERFORM build_fieldcat USING 'SCHID'            'X' '56'   'Schedule_id'                'string'.
   PERFORM build_fieldcat USING 'ZTERM'            'X' '57'   'Payment Terms'              '15'.
   PERFORM build_fieldcat USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15'.
   PERFORM build_fieldcat USING 'INCO1'            'X' '59'   'Inco Terms'                 '15'.
   PERFORM build_fieldcat USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15'.
   PERFORM build_fieldcat USING 'OFM'              'X' '61'   'OFM No.'                    '15'.
   PERFORM build_fieldcat USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15'.
   PERFORM build_fieldcat USING 'SPL'              'X' '63'   'Special Instruction'        '15'.
   PERFORM build_fieldcat USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15'.   "(015).
   PERFORM build_fieldcat USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15'.   "   AVINASH BHAGAT 20.12.2018
   PERFORM build_fieldcat USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15'.   "   AVINASH BHAGAT 20.12.2018
   PERFORM build_fieldcat USING 'WRKST'            'X' '67'  'USA Item Code'                '15'.
   PERFORM build_fieldcat USING 'CGST'             'X' '68'  'CGST%'                        '15'.
*  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
   PERFORM build_fieldcat USING 'SGST'             'X' '70'  'SGST%'                        '15'.
*  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
   PERFORM build_fieldcat USING 'IGST'              'X' '72'  'IGST%'                       '15'.
*  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
   PERFORM build_fieldcat USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15'.
   PERFORM build_fieldcat USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15'.
   PERFORM build_fieldcat USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15'.
   PERFORM build_fieldcat USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15'.
*  perform build_fieldcat using 'NORMT'              'X' '77'       'Industry Std Desc.'           '15'.
   PERFORM build_fieldcat USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15'.
   PERFORM build_fieldcat USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15'.
   PERFORM build_fieldcat USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15'.
   PERFORM build_fieldcat USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15'.
   PERFORM build_fieldcat USING 'BSTDK'              'X' '82' 'PO Date'                        '15'.
   PERFORM build_fieldcat USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'.
   PERFORM build_fieldcat USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15'.
   PERFORM build_fieldcat USING 'INSUR'              'X' '85' 'Insurance'               '15'.
   PERFORM build_fieldcat USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15'.
   PERFORM build_fieldcat USING 'GAD'                'X' '87' 'GAD'               '15'.
   PERFORM build_fieldcat USING 'US_CUST'            'X' '88' 'USA Customer Name'               '15'.
   PERFORM build_fieldcat USING 'TCS'                'X' '89' 'TCS Rate'               '15'.
   PERFORM build_fieldcat USING 'TCS_AMT'            'X' '90' 'TCS Amount'               '15'.
   PERFORM build_fieldcat USING 'PO_DEL_DATE'        'X' '91' 'PO_Delivery_Date'               '15'.
   PERFORM build_fieldcat USING 'OFM_NO'             'X' '92' 'OFM SR. NO.'               '15'.
   PERFORM build_fieldcat USING 'CTBG'              'X' '93' 'CTBG Item Details'               '20'.
   PERFORM build_fieldcat USING 'CERTIF'             'X' '94' 'Certificate Details'             '20'.
   PERFORM build_fieldcat USING 'ITEM_TYPE'             'X' '95' 'Item Type'             '20'. "edited by PJ on16-08-21
   PERFORM build_fieldcat USING 'REF_TIME'             'X' '96' 'Ref. Time'             '15'. "edited by PJ on 08-09-21
*  PERFORM build_fieldcat USING 'CTBG'             'X' '94' 'CTBG Details'             '10'.

   """""""""""""""" "added by pankaj 28.01.2022""""""""""""""""

   PERFORM build_fieldcat USING 'PROJ'               'X' '97' 'Project Owner Details'             '15'. "added by pankaj 28.01.2022
   PERFORM build_fieldcat USING 'COND'               'X' '98' 'Condition Delivery Date'             '15'. "added by pankaj 28.01.2022
   PERFORM build_fieldcat USING 'RECEIPT_DATE'       'X' '99' 'Code Receipt Date'             '15'. "added by pankaj 28.01.2022
   PERFORM build_fieldcat USING 'REASON'             'X' '100' 'Reason'             '15'.               "added by pankaj 28.01.2022
   PERFORM build_fieldcat USING 'NTGEW'             'X' '101' 'New Weight'             '15'.               "added by pankaj 28.01.2022
   PERFORM build_fieldcat USING 'ZPR0'             'X' '102' 'Condition ZPR0'           '15'.
   PERFORM build_fieldcat USING 'ZPF0'             'X' '103' 'Condition ZPF0'           '15'.
   PERFORM build_fieldcat USING 'ZIN1'               'X' '104' 'Condition ZIN1'           '15'.
   PERFORM build_fieldcat USING 'ZIN2'               'X' '105' 'Condition ZIN2'           '15'.
   PERFORM build_fieldcat USING 'JOIG'               'X' '106' 'Condition JOIG'           '15'.
   PERFORM build_fieldcat USING 'JOCG'               'X' '107' 'Condition JOCG'           '15'.
   PERFORM build_fieldcat USING 'JOSG'               'X' '108' 'Condition JOSG'           '15'.
   PERFORM build_fieldcat USING 'DATE'               'X' '109' 'Schedule line del.Date'  '15'.
   PERFORM build_fieldcat USING 'PRSDT'               'X' '110' 'Pricing Date'            '15'.
   PERFORM build_fieldcat USING 'PACKING_TYPE'               'X' '111' 'Packing Type'            '15'.
   PERFORM build_fieldcat USING 'OFM_DATE1'               'X' '112' 'OFM Delivery Date'            '15'.
   PERFORM build_fieldcat USING 'MAT_TEXT'               'X' '113' 'Material Sales Text'            '15'.
   "PERFORM build_fieldcat USING 'ERDAT1'               'X' '113' 'SO Change Date '            '15'.

   """""""""""""""""""""""" ended """"""""""""""""""""""""""""""""""'
*infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary
   """"""""""""""""""""""""Coded added by pankaj 31.01.2022  """"""""""""""""""""""""""""

   PERFORM build_fieldcat USING 'INFRA'                      'X' '114' 'Infrastructure Required'            '15'.
   PERFORM build_fieldcat USING 'VALIDATION'                 'X' '115' 'Validation Plan Refrence'            '15'.
   PERFORM build_fieldcat USING 'REVIEW_DATE'                'X' '116' 'Review Date'            '15'.
   PERFORM build_fieldcat USING 'DISS_SUMMARY'                'X' '117' 'Discussion Summary'            '15'.
   PERFORM build_fieldcat USING 'CHANG_SO_DATE'                'X' '118' 'Changed SO Date'            '15'.

   """"""" added by pankaj 04.02.2022"""""""""""""""

   PERFORM build_fieldcat USING 'PORT'                      'X'       '119' 'Port'                         '15'.
   PERFORM build_fieldcat USING 'FULL_PMNT'                 'X'       '120' 'Full Payment Desc'            '15'.
   PERFORM build_fieldcat USING 'ACT_ASS'                   'X'       '121' 'Act Assignments'            '15'.
   PERFORM build_fieldcat USING 'TXT04'                     'X'       '122' 'User Status'            '15'.
*  perform build_fieldcat using 'KWERT'                     'X'       '123' 'Condition Value ZPR0'            '15'.
   PERFORM build_fieldcat USING 'FREIGHT'                     'X'       '124' 'Freight'            '15'.
   " PERFORM build_fieldcat USING 'OFM_SR_NO'                     'X'       '125' 'OFM SR NO'            '15'.
   PERFORM build_fieldcat USING 'PO_SR_NO'                     'X'       '126' 'PO SR NO TEXT'            '15'.

   PERFORM build_fieldcat USING 'UDATE'                      'X'         '127' 'Last changed date'        '15'.
   PERFORM build_fieldcat USING 'BOM'                      'X'         '128' 'BOM Status'        '15'.
   PERFORM build_fieldcat USING 'ZPEN_ITEM'                      'X'         '129' 'Pending Items'        '15'.
   PERFORM build_fieldcat USING 'ZRE_PEN_ITEM'                      'X'         '130' 'Reason for Pending Items'        '15'.
*  perform build_fieldcat using 'VTEXT1'                      'X'         '131' 'Billing Block'        '15'.
   PERFORM build_fieldcat USING 'ZINS_LOC'                      'X'         '131' 'Installation Location'        '15'.
   PERFORM build_fieldcat USING 'BOM_EXIST'                      'X'         '132' 'BOM EXISTS '        '15'.
*   perform build_fieldcat using 'BSTKD1'          'X' '133'   'Line Item Wise PO No'    '15'."ADDED BY JYOTI ON 16.04.2024
   PERFORM build_fieldcat USING 'POSEX1'              'X' '134' 'PO Item No'               '15'."ADDED BY JYOTI ON 16.04.2024
   PERFORM build_fieldcat USING 'LGORT'              'X' '135' 'Storage Location'               '15'."ADDED BY Pranit ON 10.04.2024
   PERFORM build_fieldcat USING 'QUOTA_REF'              'X' '136' 'QT Reference No.'               '15'."ADDED BY jyoti ON 19.06.2024
   PERFORM build_fieldcat USING 'ZMRP_DATE'              'X' '137' 'DV_PLMRPDATE'               '15'."ADDED BY jyoti ON 02.07.2024


*********************************************************************************
   PERFORM build_fieldcat USING 'VKORG' 'X'  '138' 'Sales Organization'   '4'. " ADD BY SUPRIYA ON 19.08.2024
   PERFORM build_fieldcat USING 'VTWEG' 'X' '139'  'Distribution Channel' '2'." ADD BY SUPRIYA ON 19.08.2024
   PERFORM build_fieldcat USING 'SPART' 'X' '140'  'Division' '2'.               " ADD BY SUPRIYA ON 19.08.2024

*******************************************************************************
   PERFORM build_fieldcat USING 'ZEXP_MRP_DATE1'              'X' '141' 'Expected MRP Date'               '15'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'SPECIAL_COMM'                'X' '142' 'Special Comments'                '20'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'ZCUST_PROJ_NAME'                'X' '143' 'Customer Project NAme'                '20'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'AMENDMENT_HIS'                'X' '144' 'Amendment_history'                '20'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'PO_DIS'                'X' '145' 'Po Discrepancy'                '20'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'HOLD_REASON_N1'                'X' '146' 'Hold Reason'                '20'."ADDED BY jyoti ON 02.07.2024
   PERFORM build_fieldcat USING 'DIS_RATE'                'X' '147' 'Dis %'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
   PERFORM build_fieldcat USING 'DIS_AMT'                'X' '148' 'Discount Amount'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
   PERFORM build_fieldcat USING 'DIS_UNIT_RATE'                'X' '149' 'Discount Unit Rate'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025


   """"""" ended """"""""""""""""""""""""""""

*          dispo       TYPE marc-dispo,
*          wip         TYPE i,
*          mtart       TYPE mara-mtart,
*          kdmat       TYPE vbap-kdmat,
*          etenr       type vbep-etenr,
*          kunnr       TYPE kna1-kunnr,

   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       i_callback_program = sy-repid
       i_structure_name   = 'OUTPUT'
       is_layout          = wa_layout
       it_fieldcat        = it_fcat
*      it_sort            = i_sort
*      i_default          = 'A'
*      i_save             = 'A'
       i_save             = 'X'
       it_events          = gt_events[]
     TABLES
       t_outtab           = it_output
     EXCEPTIONS
       program_error      = 1
       OTHERS             = 2.
   IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
   ENDIF.

   REFRESH it_output.
 ENDFORM.                    " ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

 FORM stp3_eventtab_build  CHANGING p_gt_events TYPE slis_t_event.

   DATA: lf_event TYPE slis_alv_event. "WORK AREA

   CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
     EXPORTING
       i_list_type     = 0
     IMPORTING
       et_events       = p_gt_events
     EXCEPTIONS
       list_type_wrong = 1
       OTHERS          = 2.
   IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
   ENDIF.
   MOVE c_formname_top_of_page TO lf_event-form.
   MODIFY p_gt_events  FROM  lf_event INDEX 3 TRANSPORTING form."TO P_I_EVENTS .

 ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
 FORM comment_build CHANGING i_list_top_of_page TYPE slis_t_listheader.
   DATA: lf_line       TYPE slis_listheader. "WORK AREA
*--LIST HEADING -  TYPE H
   CLEAR lf_line.
   lf_line-typ  = c_h.
   lf_line-info =  ''(042).
   APPEND lf_line TO i_list_top_of_page.
*--HEAD INFO: TYPE S
   CLEAR lf_line.
   lf_line-typ  = c_s.
   lf_line-key  = TEXT-043.
   lf_line-info = sy-datum.
   WRITE sy-datum TO lf_line-info USING EDIT MASK '__.__.____'.
   APPEND lf_line TO i_list_top_of_page.

 ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM top_of_page .

*** THIS FM IS USED TO CREATE ALV HEADER
   CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
     EXPORTING
       it_list_commentary = i_list_top_of_page[]. "INTERNAL TABLE WITH


 ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
 FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   wa_layout-zebra          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
   p_wa_layout-zebra          = 'X'.
   p_wa_layout-no_colhead        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


 ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

 FORM build_fieldcat  USING    v1  v2 v3 v4 v5.
   wa_fcat-fieldname   = v1 ." 'VBELN'.
   wa_fcat-tabname     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.
   wa_fcat-key         =  v2 ."  'X'.
   wa_fcat-seltext_l   =  v4.
   wa_fcat-outputlen   =  v5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.
   wa_fcat-col_pos     =  v3.
   APPEND wa_fcat TO it_fcat.
   CLEAR wa_fcat.

 ENDFORM.

 " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM down_set .
*  BREAK fujiabap.
   TYPE-POOLS truxs.
   DATA: it_csv TYPE truxs_t_text_data,
         wa_csv TYPE LINE OF truxs_t_text_data,
         hd_csv TYPE LINE OF truxs_t_text_data.
*  DATA: lv_folder(150).
   DATA: lv_file(30).
   DATA: lv_fullfile TYPE string,
         lv_dat(10),
         lv_tim(4).
   DATA: lv_msg(80).
*break primus.
   PERFORM new_file_1."added by jyoti on 26.04.2024
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       i_tab_sap_data       = it_output_new "it_output
     CHANGING
       i_tab_converted_data = it_csv
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
   lv_file = 'ZDELPENDSO_1_V1.TXT'.

   CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
     INTO lv_fullfile.

   WRITE: / 'ZPENDSO_1 Download started on', sy-datum, 'at', sy-uzeit.
   IF open_so IS NOT INITIAL.
     WRITE: / 'Open Sales Orders'.
   ELSE.
     WRITE: / 'All Sales Orders'.
   ENDIF.
   WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
   WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
   WRITE: / 'Dest. File:', lv_fullfile.

   OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF sy-subrc = 0.
     DATA lv_string_1362 TYPE string.
     DATA lv_crlf_1362 TYPE string.
     lv_crlf_1362 = cl_abap_char_utilities=>cr_lf.
     lv_string_1362 = hd_csv.
     LOOP AT it_csv INTO wa_csv.
       CONCATENATE lv_string_1362 lv_crlf_1362 wa_csv INTO lv_string_1362.
       CLEAR: wa_csv.
     ENDLOOP.
     TRANSFER lv_string_1362 TO lv_fullfile.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
     CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
     MESSAGE lv_msg TYPE 'S'.
   ENDIF.
******************************************************new file zpendso **********************************
   PERFORM new_file.
*  break primus.
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       i_tab_sap_data       = gt_final
     CHANGING
       i_tab_converted_data = it_csv
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
   lv_file = 'ZDELPENDSO_1_V1.TXT'.

   CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

   WRITE: / 'ZPENDSO_1 Download started on', sy-datum, 'at', sy-uzeit.
   OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF sy-subrc = 0.
     DATA lv_string_1363 TYPE string.
     DATA lv_crlf_1363 TYPE string.
     lv_crlf_1363 = cl_abap_char_utilities=>cr_lf.
     lv_string_1363 = hd_csv.
     LOOP AT it_csv INTO wa_csv.
       CONCATENATE lv_string_1363 lv_crlf_1363 wa_csv INTO lv_string_1363.
       CLEAR: wa_csv.
     ENDLOOP.
     TRANSFER lv_string_1363 TO lv_fullfile.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
     CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
     MESSAGE lv_msg TYPE 'S'.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
 FORM cvs_header  USING    pd_csv.

   DATA: l_field_seperator.
   l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
   CONCATENATE
            'PLANT'
            'ORDER TYPE'
            'CUST REF NO'
            'CUSTOMER NAME'
            'SALES OFFICE'
            'SALES DOC NO'
            'SO DATE'
            'REQUIRED DELIVERY DATE'
            'HOLD/UNHOLD'
            'HOLD DATE'
            'REL DATE'
            'CANCEL DATE'
            'DELV DATE'
            'TAG_REQD'
            'TPI REQD'
            'LD REQD'
            'LD PER WEEK'
            'LD MAX'
            'LD FROM DATE'
            'MAT NR'
            'POS NR'
            'DESCRIPTION'
            'SO QTY'
            'STOCK QTY'
            'DELIVARY QTY'
            'INVOICE QUANTITY'
            'PENDING QTY'
            'SO STATUS'
            'MRP DATE'
            'PRODUCTION DATE'
            'RATE'
            'CURRENCY'
            'CURRENCY CONV'
*          'SO Exchange Rate'
            'PENDING SO AMOUNT'
            'ORDER AMOUNT'
            'INTERNAL PRICE'
            'INTERNAL PRICE DATE'
            'ESTIMATED COST'
            'LATEST ESTIMATED COST'
            'STANDARD COST'
            'SERIES'
            'SIZE'
            'BRAND'
            'MOC'
            'TYPE'
            'MRP CONTROLLER'
            'WIP'
            'MAT TYPE'
            'CUST MAT NO'
            'CUSTOMER'
            'QM QTY'
            'Description Long'
            'MATTXT'              "'Sales Text'
            'SCHD NO'
            'SCHEDULE_ID'
            'SO Exchange Rate'
            'Payment Terms'
            'Payment Terms Text'
            'Inco Terms'
            'Inco Terms Descr'
            'OFM No.'
            'OFM Date'
            'CUSTOMER DEL DATE'
            'File Created Date'
            'Rejection Reason Code'
            'Rejection Reason Description'
            'USA Item Code'
            'CGST%'
*          'CGST'
            'SGST%'
*          'SGST'
            'IGST%'
*          'IGST'
            'Ship To Party'
            'Ship To Party Description'
            'Ship To Party State'
            'Sold To Party State'
            'Industry Std Desc.'
            'Ship To Party Country Key'
            'Sold To Party Country Key'
            'Purchase Order Item'
            'Ship To Party Country Desc'
            'PO Date'
            'Delivery Block(Header Loc)'
            'Delivery Block Txt'
             'Insurance'
            'Partial Delivery'
            'GAD'
            'USA Customer Name'
            'TCS Rate'
            'TCS Amount'
            'Special Instruction'
            'PO_Delivery_Date'
            'OFM SR. NO.'
            'CTBG Item Details'
            'Certificate Details'
            'Item Type' "  edited by PJ on 16-08-21
            'Ref. Time' "  edited by PJ on 08-09-21
*          'CTBG Details'
            'Project Ownwer Name'            "added by pankaj 28.01.2022
            'Condition Delivery Date'        "added by pankaj 28.01.2022
            'Code Receipt Date'              "added by pankaj 28.01.2022
            'Reason'                         "added by pankaj 28.01.2022
            'Net Weight'                         "added by pankaj 28.01.2022
            'Condition ZPR0'
            'Condition ZPF0'
            'Condition ZIN1'
            'Condition ZIN2'
            'Condition JOIG'
            'Condition JOCG'
            'Condition JOSG'
            'Schedule line del.Dat'
            'Pricing Date'
            'Packing Type'
            'OFM Delivery Date'
            'Material Sales Text'
            'Infrastructure required'        "added by pankaj 31.01.2022
            'Validation Plan Refrence'          "added by pankaj 31.01.2022
            'Review Date'                      "added by pankaj 31.01.2022
            'Discussion Summary'                "added by pankaj 31.01.2022
            'Changed SO Date'
            'Port'                                   "added by pankaj 04.02.2022
            'Full Payment Desc'                     "added by pankaj 04.02.2022
            'Act Assignments'                       "added by pankaj 04.02.2022
            'User Status'                             "added by pankaj 04.02.2022
            'Freight'
            "'OFM SR NO'
            'PO SR NO Text'
            'Last changed date'
            'BOM Status'
            'Pending Items'
            'Reason for Pending Items'
             'Installation Location'
             'BOM EXISTS '
             'Po Item No.'
*          'Billing Block'
             'Storage Location'         ""Added by Pranit 10.06.2024
             'QT Reference No.'   "added by jyoti on 19.06.2024
             'DV_PLMRPDATE'  "added by jyoti on 02.07.2024
             'Sales Organization'
             'Distribution Channel'
             'Division'
             'Expected MRP Date'
             'Special Comments'
             'Customer Project Name'
             'Amendment_history'
             'Po Discrepancy'
             'Hold Reason'  "added by jyoti on 06.02.2024
             'SO QTY KTPI'
             'SO QTY TPI1'
             'OFM Received Dt. from pre-sales'
             'OSS received fr Technical Cell'
             'Sourcing restrictions'
             'Supplier restrictions'
             'Customer Material Description'
             'Dis %'               "added by mahadev 17.12.2025
             'Discount Amount'               "added by mahadev 17.12.2025
             'Discount Unit Rate'               "added by mahadev 17.12.2025
    INTO pd_csv
    SEPARATED BY l_field_seperator.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM new_file .
   DATA:
     ls_final TYPE t_final.

   LOOP AT it_output INTO wa_output.
     ls_final-werks       = wa_output-werks.
     ls_final-auart       = wa_output-auart.
     ls_final-bstkd       = wa_output-bstkd.
     ls_final-name1       = wa_output-name1.
     ls_final-vkbur       = wa_output-vkbur.
     ls_final-vbeln       = wa_output-vbeln.
     ls_final-status      = wa_output-status.
     ls_final-tag_req     = wa_output-tag_req.
     ls_final-tpi         = wa_output-tpi.
     ls_final-ld_txt      = wa_output-ld_txt.
     ls_final-zldperweek  = wa_output-zldperweek.
     ls_final-zldmax      = wa_output-zldmax.
     ls_final-matnr       = wa_output-matnr.
     ls_final-posnr       = wa_output-posnr.
     ls_final-arktx       = wa_output-arktx.
     ls_final-kalab       = abs( wa_output-stock_qty ).
     ls_final-kwmeng      = abs( wa_output-kwmeng ).
     ls_final-lfimg       = abs( wa_output-lfimg ).
     ls_final-fkimg       = abs( wa_output-fkimg ).
     ls_final-pnd_qty     = abs( wa_output-pnd_qty ).
     ls_final-ettyp       = wa_output-ettyp.
     ls_final-kbetr       = wa_output-kbetr.
     ls_final-waerk       = wa_output-waerk.
     ls_final-curr_con    = wa_output-curr_con.
     ls_final-so_exc      = wa_output-so_exc."ADDED BY JYOTI ON26.04.2024
     ls_final-amont       = abs( wa_output-amont ).
     ls_final-ordr_amt    = abs( wa_output-ordr_amt ).
     ls_final-in_price    = abs( wa_output-in_price ).
     ls_final-est_cost    = abs( wa_output-est_cost ).
     ls_final-latst_cost  = abs( wa_output-latst_cost ).
     ls_final-st_cost     = abs( wa_output-st_cost ).
     ls_final-zseries     = wa_output-zseries.
     ls_final-zsize       = wa_output-zsize.
     ls_final-brand       = wa_output-brand.
     ls_final-moc         = wa_output-moc.
     ls_final-type        = wa_output-type.
     ls_final-dispo       = wa_output-dispo.
     ls_final-wip         = wa_output-wip.
     ls_final-mtart       = wa_output-mtart.
     ls_final-kdmat       = wa_output-kdmat.
     ls_final-kunnr       = wa_output-kunnr.
     ls_final-qmqty       = abs( wa_output-qmqty ).
     ls_final-mattxt      = wa_output-mattxt.
     ls_final-us_cust      = wa_output-us_cust.
     REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-mattxt WITH ' & '.
     ls_final-itmtxt      = wa_output-itmtxt.
     REPLACE ALL OCCURRENCES OF '<(>&<)>' IN ls_final-itmtxt WITH ' & '.
     ls_final-etenr       = wa_output-etenr.
     ls_final-schid       = wa_output-schid.
*    ls_final-so_exc      = wa_output-so_exc."COMMENTED BY JYOTI ON 26.04.2024
     ls_final-zterm       = wa_output-zterm.
     ls_final-text1       = wa_output-text1.
     ls_final-inco1       = wa_output-inco1.
     ls_final-inco2       = wa_output-inco2.
     ls_final-ofm         = wa_output-ofm.
     ls_final-ofm_date    = wa_output-ofm_date.
     ls_final-spl         = wa_output-spl.
     ls_final-wrkst       = wa_output-wrkst.
     ls_final-abgru       = wa_output-abgru.
     ls_final-bezei       = wa_output-bezei.
     ls_final-cgst        = wa_output-cgst.
     IF ls_final-cgst IS INITIAL .
       CONCATENATE  '0' ls_final-cgst INTO ls_final-cgst.
     ENDIF.
     ls_final-sgst        = wa_output-sgst.
     IF ls_final-sgst IS INITIAL .
       CONCATENATE  '0' ls_final-sgst INTO ls_final-sgst.
     ENDIF.
     ls_final-igst        = wa_output-igst.
     IF ls_final-igst IS INITIAL .
       CONCATENATE  '0' ls_final-igst INTO ls_final-igst.
     ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
     ls_final-ship_kunnr    = wa_output-ship_kunnr.
     ls_final-ship_kunnr_n  = wa_output-ship_kunnr_n.
     ls_final-ship_reg_n    = wa_output-ship_reg_n.
     ls_final-sold_reg_n    = wa_output-sold_reg_n.
     ls_final-ship_land     = wa_output-ship_land.
     ls_final-s_land_desc   = wa_output-s_land_desc.
     ls_final-sold_land     =  wa_output-sold_land.
*    ls_final-normt          = wa_output-normt.
     ls_final-posex          = wa_output-posex.

     ls_final-lifsk          = wa_output-lifsk.
     ls_final-vtext          = wa_output-vtext.
     ls_final-insur          = wa_output-insur .
     ls_final-pardel         = wa_output-pardel.
     ls_final-gad            = wa_output-gad.
     ls_final-tcs            = wa_output-tcs.
     ls_final-tcs_amt        = wa_output-tcs_amt.

     ls_final-ctbg          = wa_output-ctbg.
     ls_final-certif         = wa_output-certif.
     ls_final-special_comm   = wa_output-special_comm.
     ls_final-amendment_his   = wa_output-amendment_his.
*    ls_final-stock_qty_ktpi   = wa_output-stock_qty_ktpi.
*    ls_final-stock_qty_tpi1   = wa_output-stock_qty_tpi1.
*    ls_final-ctbg         = wa_output-ctbg.


     IF wa_output-bstdk IS NOT INITIAL .
       IF wa_output-bstdk NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-bstdk
           IMPORTING
             output = ls_final-bstdk.
         CONCATENATE ls_final-bstdk+0(2) ls_final-bstdk+2(3) ls_final-bstdk+5(4)
                        INTO ls_final-bstdk SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-erdat IS NOT INITIAL .
       IF wa_output-erdat NE '00000000'..
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-erdat
           IMPORTING
             output = ls_final-erdat.
         CONCATENATE ls_final-erdat+0(2) ls_final-erdat+2(3) ls_final-erdat+5(4)
                        INTO ls_final-erdat SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-vdatu IS NOT INITIAL .
       IF wa_output-vdatu NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-vdatu
           IMPORTING
             output = ls_final-vdatu.
         CONCATENATE ls_final-vdatu+0(2) ls_final-vdatu+2(3) ls_final-vdatu+5(4)
                        INTO ls_final-vdatu SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-holddate IS NOT INITIAL OR wa_output-holddate NE '00000000'.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = wa_output-holddate
         IMPORTING
           output = ls_final-holddate.
       CONCATENATE ls_final-holddate+0(2) ls_final-holddate+2(3) ls_final-holddate+5(4)
                      INTO ls_final-holddate SEPARATED BY '-'.
     ENDIF.
*    ENDIF.

     IF wa_output-reldate IS NOT INITIAL.
       IF wa_output-reldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-reldate
           IMPORTING
             output = ls_final-reldate.
         CONCATENATE ls_final-reldate+0(2) ls_final-reldate+2(3) ls_final-reldate+5(4)
                        INTO ls_final-reldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-canceldate IS NOT INITIAL .
       IF  wa_output-canceldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-canceldate
           IMPORTING
             output = ls_final-canceldate.
         CONCATENATE ls_final-canceldate+0(2) ls_final-canceldate+2(3) ls_final-canceldate+5(4)
                        INTO ls_final-canceldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-deldate IS NOT INITIAL .
       IF wa_output-deldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-deldate
           IMPORTING
             output = ls_final-deldate.
         CONCATENATE ls_final-deldate+0(2) ls_final-deldate+2(3) ls_final-deldate+5(4)
                        INTO ls_final-deldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-custdeldate IS NOT INITIAL .
       IF wa_output-custdeldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-custdeldate
           IMPORTING
             output = ls_final-custdeldate.
         CONCATENATE ls_final-custdeldate+0(2) ls_final-custdeldate+2(3) ls_final-custdeldate+5(4)
                        INTO ls_final-custdeldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-po_del_date IS NOT INITIAL .
       IF wa_output-po_del_date NE '00000000'. "AddedBy Snehal Rajale On 28 jan 2021
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-po_del_date
           IMPORTING
             output = ls_final-po_del_date.
         CONCATENATE ls_final-po_del_date+0(2) ls_final-po_del_date+2(3) ls_final-po_del_date+5(4)
         INTO ls_final-po_del_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-zldfromdate IS NOT INITIAL .
       IF wa_output-zldfromdate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-zldfromdate
           IMPORTING
             output = ls_final-zldfromdate.
         CONCATENATE ls_final-zldfromdate+0(2) ls_final-zldfromdate+2(3) ls_final-zldfromdate+5(4)
                        INTO ls_final-zldfromdate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-mrp_dt IS NOT INITIAL OR wa_output-mrp_dt NE '00000000'.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = wa_output-mrp_dt
         IMPORTING
           output = ls_final-mrp_dt.
       CONCATENATE ls_final-mrp_dt+0(2) ls_final-mrp_dt+2(3) ls_final-mrp_dt+5(4)
                      INTO ls_final-mrp_dt SEPARATED BY '-'.
     ENDIF.

     IF wa_output-edatu IS NOT INITIAL .
       IF wa_output-edatu NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-edatu
           IMPORTING
             output = ls_final-edatu.
         CONCATENATE ls_final-edatu+0(2) ls_final-edatu+2(3) ls_final-edatu+5(4)
                        INTO ls_final-edatu SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-in_pr_dt IS NOT INITIAL .
       IF wa_output-in_pr_dt NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-in_pr_dt
           IMPORTING
             output = ls_final-in_pr_dt.
         CONCATENATE ls_final-in_pr_dt+0(2) ls_final-in_pr_dt+2(3) ls_final-in_pr_dt+5(4)
                        INTO ls_final-in_pr_dt SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
       EXPORTING
         input  = sy-datum
       IMPORTING
         output = ls_final-ref_dt.
     CONCATENATE ls_final-ref_dt+0(2) ls_final-ref_dt+2(3) ls_final-ref_dt+5(4)
                    INTO ls_final-ref_dt SEPARATED BY '-'.
******************added by jyoti on 02.07.2024************************************
     IF wa_output-zmrp_date IS NOT INITIAL .
       IF wa_output-zmrp_date NE '00000000'..
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-zmrp_date
           IMPORTING
             output = ls_final-zmrp_date.
         CONCATENATE ls_final-zmrp_date+0(2) ls_final-zmrp_date+2(3) ls_final-zmrp_date+5(4)
                        INTO ls_final-zmrp_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-zexp_mrp_date1 IS NOT INITIAL.
       IF wa_output-zexp_mrp_date1 NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-zexp_mrp_date1
           IMPORTING
             output = ls_final-zexp_mrp_date1.
         CONCATENATE ls_final-zexp_mrp_date1+0(2) ls_final-zexp_mrp_date1+2(3) ls_final-zexp_mrp_date1+5(4)
                        INTO ls_final-zexp_mrp_date1  SEPARATED BY '-'.
       ENDIF.
     ENDIF.
*************************************************************************************
     ls_final-ofm_no = wa_output-ofm_no .

     CONDENSE ls_final-kwmeng.
     IF wa_output-kwmeng < 0.
       CONCATENATE '-' ls_final-kwmeng INTO ls_final-kwmeng.
     ENDIF.

     CONDENSE ls_final-lfimg.
     IF wa_output-lfimg < 0.
       CONCATENATE '-' ls_final-lfimg INTO ls_final-lfimg.
     ENDIF.

     CONDENSE ls_final-fkimg.
     IF wa_output-fkimg < 0.
       CONCATENATE '-' ls_final-fkimg INTO ls_final-fkimg.
     ENDIF.

     CONDENSE ls_final-pnd_qty.
     IF wa_output-pnd_qty < 0.
       CONCATENATE '-' ls_final-pnd_qty INTO ls_final-pnd_qty.
     ENDIF.

     CONDENSE ls_final-qmqty.
     IF wa_output-qmqty < 0.
       CONCATENATE '-' ls_final-qmqty INTO ls_final-qmqty.
     ENDIF.
     CONDENSE ls_final-kbetr.

     IF wa_output-kbetr < 0.
       CONCATENATE '-' ls_final-kbetr INTO ls_final-kbetr.
     ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

     CONDENSE ls_final-amont.
     IF wa_output-amont < 0.
       CONCATENATE '-' ls_final-amont INTO ls_final-amont.
     ENDIF.

     CONDENSE ls_final-ordr_amt.
     IF wa_output-ordr_amt < 0.
       CONCATENATE '-' ls_final-ordr_amt INTO ls_final-ordr_amt.
     ENDIF.


     CONDENSE ls_final-in_price.
     IF wa_output-in_price < 0.
       CONCATENATE '-' ls_final-in_price INTO ls_final-in_price.
     ENDIF.

     CONDENSE ls_final-est_cost.
     IF wa_output-est_cost < 0.
       CONCATENATE '-' ls_final-est_cost INTO ls_final-est_cost.
     ENDIF.

     CONDENSE ls_final-latst_cost.
     IF wa_output-latst_cost < 0.
       CONCATENATE '-' ls_final-latst_cost INTO ls_final-latst_cost.
     ENDIF.

     CONDENSE ls_final-st_cost.
     IF wa_output-st_cost < 0.
       CONCATENATE '-' ls_final-st_cost INTO ls_final-st_cost.
     ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
     ls_final-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
     ls_final-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21


     """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

     ls_final-proj          = wa_output-proj .

     ls_final-cond          = wa_output-cond .

     IF wa_output-receipt_date IS NOT INITIAL .
       IF wa_output-receipt_date NE '00000000'..
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-receipt_date
           IMPORTING
             output = ls_final-receipt_date.
         CONCATENATE ls_final-receipt_date+0(2) ls_final-receipt_date+2(3) ls_final-receipt_date+5(4)
                        INTO ls_final-receipt_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     ls_final-reason      = wa_output-reason.

     ls_final-ntgew      = wa_output-ntgew.

     ls_final-zpr0        = wa_output-zpr0.
     ls_final-zpf0        = wa_output-zpf0.
     ls_final-zin1        = wa_output-zin1.
     ls_final-zin2        = wa_output-zin2.
     ls_final-joig        = wa_output-joig.
     ls_final-jocg        = wa_output-jocg.
     ls_final-josg        = wa_output-josg.


     IF wa_output-date IS NOT INITIAL .
       IF wa_output-date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-date
           IMPORTING
             output = ls_final-date.
         CONCATENATE ls_final-date+0(2) ls_final-date+2(3) ls_final-date+5(4)
                        INTO ls_final-date SEPARATED BY '-'.
       ENDIF.
     ENDIF.


     IF wa_output-prsdt IS NOT INITIAL .
       IF  wa_output-prsdt NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-prsdt
           IMPORTING
             output = ls_final-prsdt.
         CONCATENATE ls_final-prsdt+0(2) ls_final-prsdt+2(3) ls_final-prsdt+5(4)
                        INTO ls_final-prsdt  SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     ls_final-packing_type = wa_output-packing_type.


     IF wa_output-ofm_date1 IS NOT INITIAL.
       IF wa_output-ofm_date1 NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-ofm_date1
           IMPORTING
             output = ls_final-ofm_date1.
         CONCATENATE ls_final-ofm_date1+0(2) ls_final-ofm_date1+2(3) ls_final-ofm_date1+5(4)
                        INTO ls_final-ofm_date1 SEPARATED BY '-'.
       ELSE .
         ls_final-ofm_date1 = space.
       ENDIF.
     ELSE .
       ls_final-ofm_date1 = space.
     ENDIF.

     ls_final-mat_text = wa_output-mat_text.


     """"""" code added by pankaj 31.01.2022"""""""""

     ls_final-infra        = wa_output-infra.
     ls_final-validation   = wa_output-validation.

     IF wa_output-review_date IS NOT INITIAL .
       IF wa_output-review_date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-review_date
           IMPORTING
             output = ls_final-review_date.
         CONCATENATE ls_final-review_date+0(2) ls_final-review_date+2(3) ls_final-review_date+5(4)
                        INTO ls_final-review_date  SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     ls_final-review_date = wa_output-review_date.

     ls_final-diss_summary = wa_output-diss_summary .

     IF wa_output-chang_so_date IS NOT INITIAL .
       IF wa_output-chang_so_date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-chang_so_date
           IMPORTING
             output = ls_final-chang_so_date.
         CONCATENATE ls_final-chang_so_date+0(2) ls_final-chang_so_date+2(3) ls_final-chang_so_date+5(4)
                        INTO ls_final-chang_so_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     """""""""""""" code added by pankaj 04.02.2022

     ls_final-port      = wa_output-port .
     ls_final-full_pmnt = wa_output-full_pmnt .
     ls_final-act_ass   = wa_output-act_ass .
     ls_final-txt04     = wa_output-txt04 .
     ls_final-freight  = wa_output-freight.
     " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
     ls_final-po_sr_no = wa_output-po_sr_no.
     ls_final-udate = wa_output-udate.
     ls_final-bom = wa_output-bom.
     ls_final-zpen_item = wa_output-zpen_item.
     ls_final-zre_pen_item = wa_output-zre_pen_item.
     ls_final-zins_loc = wa_output-zins_loc. "ADDED BY PRIMUS JYOTI MAHAJAN
     ls_final-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS JYOTI MAHAJAN
*     ls_final-bstkd1       = wa_output-bstkd."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
     ls_final-posex1       = wa_output-posex1."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
*    ls_final-vtext1 = wa_output-vtext1.

     ls_final-lgort = wa_output-lgort. "Added by Pranit 10.06.2024
     ls_final-quota_ref = wa_output-quota_ref. "Added by jyoti  19.06.2024

     """"""" endded """""""""""""""""""
     ls_final-vkorg = wa_output-vkorg.
     ls_final-vtweg = wa_output-vtweg.
     ls_final-spart = wa_output-spart.
     ls_final-zcust_proj_name = wa_output-zcust_proj_name."Added by jyoti
     ls_final-amendment_his = wa_output-amendment_his."Added by jyoti
     ls_final-po_dis = wa_output-po_dis."Added by jyoti
     ls_final-hold_reason_n1 = wa_output-hold_reason_n1."Added by jyoti


     CONDENSE: ls_final-kbetr,ls_final-kwmeng,ls_final-kalab,ls_final-amont,ls_final-ordr_amt,ls_final-in_price.
     APPEND ls_final TO gt_final.
     CLEAR:
       ls_final,wa_output.
   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM down_set_all .

   TYPE-POOLS truxs.
   DATA: it_csv TYPE truxs_t_text_data,
         wa_csv TYPE LINE OF truxs_t_text_data,
         hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
   DATA: lv_file(30).
   DATA: lv_fullfile TYPE string,
         lv_dat(10),
         lv_tim(4).
   DATA: lv_msg(80).
   PERFORM new_file_1."added by jyoti on 26.04.2024
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       i_tab_sap_data       = it_output_new "it_output"added by jyoti on 26.04.2024
     CHANGING
       i_tab_converted_data = it_csv
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
   lv_file = 'ZDELPENDSOALL_1.TXT'.

   CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file
     INTO lv_fullfile.

   WRITE: / 'ZDELPENDSO Download started on', sy-datum, 'at', sy-uzeit.
   IF open_so IS NOT INITIAL.
     WRITE: / 'Open Sales Orders'.
   ELSE.
     WRITE: / 'All Sales Orders'.
   ENDIF.
   WRITE: / 'Sales Order Dt. From', s_date-low, 'To', s_date-high.
   WRITE: / 'Material code   From', s_matnr-low, 'To', s_matnr-high.
   WRITE: / 'Dest. File:', lv_fullfile.

   OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF sy-subrc = 0.
     DATA lv_string_1364 TYPE string.
     DATA lv_crlf_1364 TYPE string.
     lv_crlf_1364 = cl_abap_char_utilities=>cr_lf.
     lv_string_1364 = hd_csv.
     LOOP AT it_csv INTO wa_csv.
       CONCATENATE lv_string_1364 lv_crlf_1364 wa_csv INTO lv_string_1364.
       CLEAR: wa_csv.
     ENDLOOP.
     TRANSFER lv_string_1364 TO lv_fullfile.

*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
     CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
     MESSAGE lv_msg TYPE 'S'.
   ENDIF.


******************************************************new file zpendso **********************************
   PERFORM new_file.
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       i_tab_sap_data       = gt_final
     CHANGING
       i_tab_converted_data = it_csv
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM cvs_header USING hd_csv.

**lv_folder = 'D:\usr\sap\DEV\D00\work'.
   lv_file = 'ZDELPENDSOALL_1.TXT'.

   CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

   WRITE: / 'ZPENDSO Download started on', sy-datum, 'at', sy-uzeit.
   OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF sy-subrc = 0.
     DATA lv_string_1365 TYPE string.
     DATA lv_crlf_1365 TYPE string.
     lv_crlf_1365 = cl_abap_char_utilities=>cr_lf.
     lv_string_1365 = hd_csv.
     LOOP AT it_csv INTO wa_csv.
       CONCATENATE lv_string_1365 lv_crlf_1365 wa_csv INTO lv_string_1365.
       CLEAR: wa_csv.
     ENDLOOP.
     TRANSFER lv_string_1365 TO lv_fullfile.

*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
     CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
     MESSAGE lv_msg TYPE 'S'.
   ENDIF.

 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM new_file_1 .
   "added by jyoti on 26.04.2024 for date refreshable file ****************************
*  BREAK primusabap.
   LOOP AT it_output INTO wa_output.
     wa_output_new-werks       = wa_output-werks.
     wa_output_new-auart       = wa_output-auart.
     wa_output_new-bstkd       = wa_output-bstkd.
     wa_output_new-name1       = wa_output-name1.
     wa_output_new-vkbur       = wa_output-vkbur.
     wa_output_new-vbeln       = wa_output-vbeln.
     wa_output_new-status      = wa_output-status.
     wa_output_new-tag_req     = wa_output-tag_req.
     wa_output_new-tpi         = wa_output-tpi.
     wa_output_new-ld_txt      = wa_output-ld_txt.
     wa_output_new-zldperweek  = wa_output-zldperweek.
     wa_output_new-zldmax      = wa_output-zldmax.
     wa_output_new-matnr       = wa_output-matnr.
     wa_output_new-posnr       = wa_output-posnr.
     wa_output_new-arktx       = wa_output-arktx.
     wa_output_new-stock_qty   = abs( wa_output-stock_qty ).
     wa_output_new-kwmeng      = abs( wa_output-kwmeng ).
     wa_output_new-lfimg       = abs( wa_output-lfimg ).
     wa_output_new-fkimg       = abs( wa_output-fkimg ).
     wa_output_new-pnd_qty     = abs( wa_output-pnd_qty ).
     wa_output_new-ettyp       = wa_output-ettyp.
     wa_output_new-kbetr       = wa_output-kbetr.
     CONDENSE wa_output_new-kbetr.
     wa_output_new-waerk       = wa_output-waerk.
     wa_output_new-curr_con    = wa_output-curr_con.
     wa_output_new-amont       = abs( wa_output-amont ).
     wa_output_new-ordr_amt    = abs( wa_output-ordr_amt ).
     wa_output_new-in_price    = abs( wa_output-in_price ).
     wa_output_new-est_cost    = abs( wa_output-est_cost ).
     wa_output_new-latst_cost  = abs( wa_output-latst_cost ).
     wa_output_new-st_cost     = abs( wa_output-st_cost ).
     wa_output_new-zseries     = wa_output-zseries.
     wa_output_new-zsize       = wa_output-zsize.
     wa_output_new-brand       = wa_output-brand.
     wa_output_new-moc         = wa_output-moc.
     wa_output_new-type        = wa_output-type.
     wa_output_new-dispo       = wa_output-dispo.
     wa_output_new-wip         = wa_output-wip.
     wa_output_new-mtart       = wa_output-mtart.
     wa_output_new-kdmat       = wa_output-kdmat.
     wa_output_new-kunnr       = wa_output-kunnr.
     wa_output_new-qmqty       = abs( wa_output-qmqty ).
     wa_output_new-mattxt      = wa_output-mattxt.
     wa_output_new-us_cust      = wa_output-us_cust.
     REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-mattxt WITH ' & '.
     wa_output_new-itmtxt      = wa_output-itmtxt.
     REPLACE ALL OCCURRENCES OF '<(>&<)>' IN wa_output_new-itmtxt WITH ' & '.
     wa_output_new-etenr       = wa_output-etenr.
     wa_output_new-schid       = wa_output-schid.
     wa_output_new-so_exc      = wa_output-so_exc.
     wa_output_new-zterm       = wa_output-zterm.
     wa_output_new-text1       = wa_output-text1.
     wa_output_new-inco1       = wa_output-inco1.
     wa_output_new-inco2       = wa_output-inco2.
     wa_output_new-ofm         = wa_output-ofm.
     wa_output_new-ofm_date    = wa_output-ofm_date.
     wa_output_new-spl         = wa_output-spl.
     wa_output_new-wrkst       = wa_output-wrkst.
     wa_output_new-abgru       = wa_output-abgru.
     wa_output_new-bezei       = wa_output-bezei.
     wa_output_new-cgst        = wa_output-cgst.
     IF  wa_output_new-cgst IS INITIAL .
       CONCATENATE  '0'  wa_output_new-cgst INTO  wa_output_new-cgst.
     ENDIF.
     wa_output_new-sgst        = wa_output-sgst.
     IF  wa_output_new-sgst IS INITIAL .
       CONCATENATE  '0'  wa_output_new-sgst INTO  wa_output_new-sgst.
     ENDIF.
     wa_output_new-igst        = wa_output-igst.
     IF  wa_output_new-igst IS INITIAL .
       CONCATENATE  '0'  wa_output_new-igst INTO  wa_output_new-igst.
     ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
     wa_output_new-ship_kunnr    = wa_output-ship_kunnr.
     wa_output_new-ship_kunnr_n  = wa_output-ship_kunnr_n.
     wa_output_new-ship_reg_n    = wa_output-ship_reg_n.
     wa_output_new-sold_reg_n    = wa_output-sold_reg_n.
     wa_output_new-ship_land     = wa_output-ship_land.
     wa_output_new-s_land_desc   = wa_output-s_land_desc.
     wa_output_new-sold_land     =  wa_output-sold_land.
     wa_output_new-posex          = wa_output-posex.
*    wa_output_new-normt          = wa_output-normt.


     wa_output_new-special_comm   = wa_output-special_comm.
     wa_output_new-lifsk          = wa_output-lifsk.
     wa_output_new-vtext          = wa_output-vtext.
     wa_output_new-insur          = wa_output-insur .
     wa_output_new-pardel         = wa_output-pardel.
     wa_output_new-gad            = wa_output-gad.
     wa_output_new-tcs            = wa_output-tcs.
     wa_output_new-tcs_amt        = wa_output-tcs_amt.

     wa_output_new-ctbg          = wa_output-ctbg.
     wa_output_new-certif         = wa_output-certif.

*    ls_final-ctbg         = wa_output-ctbg.


     IF wa_output-bstdk IS NOT INITIAL .
       IF  wa_output-bstdk NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-bstdk
           IMPORTING
             output = wa_output_new-bstdk.
         CONCATENATE  wa_output_new-bstdk+0(2)  wa_output_new-bstdk+2(3)  wa_output_new-bstdk+5(4)
                        INTO  wa_output_new-bstdk SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-erdat IS NOT INITIAL .
       IF  wa_output-erdat  NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-erdat
           IMPORTING
             output = wa_output_new-erdat.
         CONCATENATE  wa_output_new-erdat+0(2)  wa_output_new-erdat+2(3)  wa_output_new-erdat+5(4)
                        INTO  wa_output_new-erdat SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-vdatu IS NOT INITIAL.
       IF wa_output-vdatu NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-vdatu
           IMPORTING
             output = wa_output_new-vdatu.
         CONCATENATE  wa_output_new-vdatu+0(2)  wa_output_new-vdatu+2(3)  wa_output_new-vdatu+5(4)
                        INTO  wa_output_new-vdatu SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-holddate IS NOT INITIAL .
       IF wa_output-holddate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-holddate
           IMPORTING
             output = wa_output_new-holddate.
         CONCATENATE  wa_output_new-holddate+0(2)  wa_output_new-holddate+2(3)  wa_output_new-holddate+5(4)
                        INTO  wa_output_new-holddate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-reldate IS NOT INITIAL .
       IF wa_output-reldate NE '00000000' .
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-reldate
           IMPORTING
             output = wa_output_new-reldate.
         CONCATENATE  wa_output_new-reldate+0(2)  wa_output_new-reldate+2(3)  wa_output_new-reldate+5(4)
                        INTO  wa_output_new-reldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-canceldate IS NOT INITIAL .
       IF wa_output-canceldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-canceldate
           IMPORTING
             output = wa_output_new-canceldate.
         CONCATENATE  wa_output_new-canceldate+0(2)  wa_output_new-canceldate+2(3)  wa_output_new-canceldate+5(4)
                        INTO  wa_output_new-canceldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-deldate IS NOT INITIAL .
       IF wa_output-deldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-deldate
           IMPORTING
             output = wa_output_new-deldate.
         CONCATENATE  wa_output_new-deldate+0(2)  wa_output_new-deldate+2(3)  wa_output_new-deldate+5(4)
                        INTO  wa_output_new-deldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-custdeldate IS NOT INITIAL .
       IF wa_output-custdeldate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-custdeldate
           IMPORTING
             output = wa_output_new-custdeldate.
         CONCATENATE  wa_output_new-custdeldate+0(2)  wa_output_new-custdeldate+2(3)  wa_output_new-custdeldate+5(4)
                        INTO  wa_output_new-custdeldate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-po_del_date IS NOT INITIAL .
       IF wa_output-po_del_date NE '00000000'.                         "Added By Snehal Rajale On 28 jan 2021
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-po_del_date
           IMPORTING
             output = wa_output_new-po_del_date.
         CONCATENATE  wa_output_new-po_del_date+0(2)  wa_output_new-po_del_date+2(3)  wa_output_new-po_del_date+5(4)
         INTO  wa_output_new-po_del_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-zldfromdate IS NOT INITIAL .
       IF wa_output-zldfromdate NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-zldfromdate
           IMPORTING
             output = wa_output_new-zldfromdate.
         CONCATENATE  wa_output_new-zldfromdate+0(2)  wa_output_new-zldfromdate+2(3)  wa_output_new-zldfromdate+5(4)
                        INTO  wa_output_new-zldfromdate SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-mrp_dt IS NOT INITIAL .
       IF wa_output-mrp_dt NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-mrp_dt
           IMPORTING
             output = wa_output_new-mrp_dt.
         CONCATENATE  wa_output_new-mrp_dt+0(2)  wa_output_new-mrp_dt+2(3)  wa_output_new-mrp_dt+5(4)
                        INTO  wa_output_new-mrp_dt SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-edatu IS NOT INITIAL .
       IF wa_output-edatu NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-edatu
           IMPORTING
             output = wa_output_new-edatu.
         CONCATENATE  wa_output_new-edatu+0(2)  wa_output_new-edatu+2(3)  wa_output_new-edatu+5(4)
                        INTO  wa_output_new-edatu SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     IF wa_output-in_pr_dt IS NOT INITIAL .
       IF  wa_output-in_pr_dt NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-in_pr_dt
           IMPORTING
             output = wa_output_new-in_pr_dt.
         CONCATENATE  wa_output_new-in_pr_dt+0(2)  wa_output_new-in_pr_dt+2(3)  wa_output_new-in_pr_dt+5(4)
                        INTO  wa_output_new-in_pr_dt SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
       EXPORTING
         input  = sy-datum
       IMPORTING
         output = wa_output_new-ref_dt.
     CONCATENATE  wa_output_new-ref_dt+0(2)  wa_output_new-ref_dt+2(3)  wa_output_new-ref_dt+5(4)
                    INTO  wa_output_new-ref_dt SEPARATED BY '-'.

     IF wa_output-zmrp_date IS NOT INITIAL OR wa_output-zmrp_date NE '00000000'.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = wa_output-zmrp_date
         IMPORTING
           output = wa_output_new-zmrp_date.
       CONCATENATE  wa_output_new-zmrp_date+0(2)  wa_output_new-zmrp_date+2(3)  wa_output_new-zmrp_date+5(4)
                      INTO  wa_output_new-zmrp_date SEPARATED BY '-'.
     ENDIF.

     IF wa_output-zexp_mrp_date1 IS NOT INITIAL .
       IF wa_output-zexp_mrp_date1 NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-zexp_mrp_date1
           IMPORTING
             output = wa_output_new-zexp_mrp_date1.
         CONCATENATE  wa_output_new-zexp_mrp_date1+0(2)  wa_output_new-zexp_mrp_date1+2(3)  wa_output_new-zexp_mrp_date1+5(4)
                        INTO  wa_output_new-zexp_mrp_date1 SEPARATED BY '-'.
       ENDIF.
     ENDIF.
*****************************************************************************************************

     wa_output_new-ofm_no = wa_output-ofm_no .

     CONDENSE  wa_output_new-kwmeng.
     IF wa_output-kwmeng < 0.
       CONCATENATE '-'  wa_output_new-kwmeng INTO  wa_output_new-kwmeng.
     ENDIF.

     CONDENSE  wa_output_new-lfimg.
     IF wa_output-lfimg < 0.
       CONCATENATE '-'  wa_output_new-lfimg INTO wa_output_new-lfimg.
     ENDIF.

     CONDENSE  wa_output_new-fkimg.
     IF wa_output-fkimg < 0.
       CONCATENATE '-'wa_output_new-fkimg INTO wa_output_new-fkimg.
     ENDIF.

     CONDENSE wa_output_new-pnd_qty.
     IF wa_output-pnd_qty < 0.
       CONCATENATE '-' wa_output_new-pnd_qty INTO wa_output_new-pnd_qty.
     ENDIF.

     CONDENSE wa_output_new-qmqty.
     IF wa_output-qmqty < 0.
       CONCATENATE '-' wa_output_new-qmqty INTO wa_output_new-qmqty.
     ENDIF.

     CONDENSE wa_output_new-kbetr.
     IF wa_output-kbetr < 0.
       CONCATENATE '-' wa_output_new-kbetr INTO wa_output_new-kbetr.
     ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

     CONDENSE wa_output_new-amont.
     IF wa_output-amont < 0.
       CONCATENATE '-' wa_output_new-amont INTO wa_output_new-amont.
     ENDIF.

     CONDENSE wa_output_new-ordr_amt.
     IF wa_output-ordr_amt < 0.
       CONCATENATE '-' wa_output_new-ordr_amt INTO wa_output_new-ordr_amt.
     ENDIF.


     CONDENSE wa_output_new-in_price.
     IF wa_output-in_price < 0.
       CONCATENATE '-' wa_output_new-in_price INTO wa_output_new-in_price.
     ENDIF.

     CONDENSE wa_output_new-est_cost.
     IF wa_output-est_cost < 0.
       CONCATENATE '-' wa_output_new-est_cost INTO wa_output_new-est_cost.
     ENDIF.

     CONDENSE wa_output_new-latst_cost.
     IF wa_output-latst_cost < 0.
       CONCATENATE '-' wa_output_new-latst_cost INTO wa_output_new-latst_cost.
     ENDIF.

     CONDENSE wa_output_new-st_cost.
     IF wa_output-st_cost < 0.
       CONCATENATE '-' wa_output_new-st_cost INTO wa_output_new-st_cost.
     ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
     wa_output_new-item_type         = wa_output-item_type. "edited by PJ on 16-08-21
     wa_output_new-ref_time          = wa_output-ref_time. "edited by PJ on 08-09-21


     """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

     wa_output_new-proj          = wa_output-proj .

     wa_output_new-cond          = wa_output-cond .

     IF wa_output-receipt_date IS NOT INITIAL .
       IF wa_output-receipt_date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-receipt_date
           IMPORTING
             output = wa_output_new-receipt_date.
         CONCATENATE  wa_output_new-receipt_date+0(2)  wa_output_new-receipt_date+2(3)  wa_output_new-receipt_date+5(4)
                        INTO  wa_output_new-receipt_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     wa_output_new-reason      = wa_output-reason.

     wa_output_new-ntgew      = wa_output-ntgew.

     wa_output_new-zpr0        = wa_output-zpr0.
     wa_output_new-zpf0        = wa_output-zpf0.
     wa_output_new-zin1        = wa_output-zin1.
     wa_output_new-zin2        = wa_output-zin2.
     wa_output_new-joig        = wa_output-joig.
     wa_output_new-jocg        = wa_output-jocg.
     wa_output_new-josg        = wa_output-josg.


     IF wa_output-date IS NOT INITIAL .
       IF wa_output-date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-date
           IMPORTING
             output = wa_output_new-date.
         CONCATENATE wa_output_new-date+0(2) wa_output_new-date+2(3) wa_output_new-date+5(4)
                        INTO wa_output_new-date SEPARATED BY '-'.
       ENDIF.
     ENDIF.


     IF wa_output-prsdt IS NOT INITIAL .
       IF wa_output-prsdt NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-prsdt
           IMPORTING
             output = wa_output_new-prsdt.
         CONCATENATE wa_output_new-prsdt+0(2) wa_output_new-prsdt+2(3) wa_output_new-prsdt+5(4)
                        INTO wa_output_new-prsdt  SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     wa_output_new-packing_type = wa_output-packing_type.

     CONDENSE wa_output-ofm_date1.
     IF wa_output-ofm_date1 IS NOT INITIAL." OR WA_OUTPUT-OFM_DATE1 NE ' '.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = wa_output-ofm_date1
         IMPORTING
           output = wa_output_new-ofm_date1.
       CONCATENATE wa_output_new-ofm_date1+0(2) wa_output_new-ofm_date1+2(3) wa_output_new-ofm_date1+5(4)
                      INTO wa_output_new-ofm_date1 SEPARATED BY '-'.
     ELSE .
       wa_output_new-ofm_date1 = space.
     ENDIF.

     wa_output_new-mat_text = wa_output-mat_text.


     """"""" code added by pankaj 31.01.2022"""""""""

     wa_output_new-infra        = wa_output-infra.
     wa_output_new-validation   = wa_output-validation.

     IF wa_output-review_date IS NOT INITIAL .
       IF wa_output-review_date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-review_date
           IMPORTING
             output = wa_output_new-review_date.
         CONCATENATE wa_output_new-review_date+0(2) wa_output_new-review_date+2(3) wa_output_new-review_date+5(4)
                        INTO wa_output_new-review_date  SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     wa_output_new-review_date = wa_output-review_date.

     wa_output_new-diss_summary = wa_output-diss_summary .

     IF wa_output-chang_so_date IS NOT INITIAL .
       IF wa_output-chang_so_date NE '00000000'.
         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
           EXPORTING
             input  = wa_output-chang_so_date
           IMPORTING
             output = wa_output_new-chang_so_date.
         CONCATENATE wa_output_new-chang_so_date+0(2) wa_output_new-chang_so_date+2(3) wa_output_new-chang_so_date+5(4)
                        INTO wa_output_new-chang_so_date SEPARATED BY '-'.
       ENDIF.
     ENDIF.

     """""""""""""" code added by pankaj 04.02.2022

     wa_output_new-port      = wa_output-port .
     wa_output_new-full_pmnt = wa_output-full_pmnt .
     wa_output_new-act_ass   = wa_output-act_ass .
     wa_output_new-txt04     = wa_output-txt04 .
     wa_output_new-freight  = wa_output-freight.
     " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
     wa_output_new-po_sr_no = wa_output-po_sr_no.
     wa_output_new-udate = wa_output-udate.
     wa_output_new-bom = wa_output-bom.
     wa_output_new-zpen_item = wa_output-zpen_item.
     wa_output_new-zre_pen_item = wa_output-zre_pen_item.
     wa_output_new-zins_loc = wa_output-zins_loc. "ADDED BY PRIMUS MA
     wa_output_new-bom_exist = wa_output-bom_exist. "ADDED BY PRIMUS MA
     wa_output_new-posex1         = wa_output-posex.
     wa_output_new-lgort          = wa_output-lgort.  "ADDED BY Pranit 10.06.2024
     wa_output_new-quota_ref         = wa_output-quota_ref.  "ADDED BY jyoti 19.06.2024
*    ls_final-vtext1 = wa_output-vtext1.

     """"""" endded """""""""""""""""""

     wa_output_new-vkorg = wa_output-vkorg.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-vtweg = wa_output-vtweg.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-spart = wa_output-spart.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-zcust_proj_name = wa_output-zcust_proj_name.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-po_dis = wa_output-po_dis.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-amendment_his = wa_output-amendment_his.    """ ADDED BY SUPRIYA 19.08.2024
     wa_output_new-hold_reason_n1 = wa_output-hold_reason_n1."Added by jyoti on 06.02.2025
*     wa_output_new-stock_qty_ktpi = wa_output-stock_qty_ktpi.
*    wa_output_new-stock_qty_tpi1 = wa_output-stock_qty_tpi1.
*    wa_output_new-ofm_received_date = wa_output-ofm_received_date.
*    wa_output_new-oss_received_cell = wa_output-oss_received_cell.
*    wa_output_new-source_rest = wa_output-source_rest.
*    wa_output_new-suppl_rest = wa_output-suppl_rest.
*    wa_output_new-cust_mat_desc = wa_output-cust_mat_desc.
     APPEND wa_output_new TO it_output_new.
     CLEAR:
       wa_output_new,wa_output.
   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_hdtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SO
*&---------------------------------------------------------------------*
 FORM read_hdtext  USING   put_so TYPE tty_so.
   TYPES:BEGIN OF ty_hdid,
           id TYPE tdid,
         END   OF ty_hdid,
         tty_hdid TYPE STANDARD TABLE OF ty_hdid.

   DATA: lt_hdid   TYPE tty_hdid,
         lv_name   TYPE thead-tdname,
         Lt_LINES  TYPE STANDARD TABLE OF tline,
         ls_hdtext TYPE ty_hdtext,
         lt_so     TYPE tty_so.
   CLEAR: gt_hdtext.
   lt_hdid = VALUE #( ( id = 'Z999' )    "WA_OUTPUT-TPI (50)
                      ( id = 'Z005' )    "WA_OUTPUT-FREIGHT (128)
                      ( id = 'Z015' )    "WA_OUTPUT-OFM (50)
                      ( id = 'Z016' )    "WA_OUTPUT-OFM_DATE (50)
                      ( id = 'Z017' )    "WA_OUTPUT-INSUR (250)
                      ( id = 'Z020' )    "WA_OUTPUT-SPL (255)
                      ( id = 'Z038' )    "WA_OUTPUT-LD_TXT (50)
                      ( id = 'Z039' )    "WA_OUTPUT-TAG_REQ (50)
                      ( id = 'Z047' )    "WA_OUTPUT-PARDEL (250)
                      ( id = 'Z062' )    "WA_OUTPUT-QUOTA_REF (128)
                      ( id = 'Z063' )    "WA_OUTPUT-ZCUST_PROJ_NAME (250)
                      ( id = 'Z064' )    "WA_OUTPUT-AMENDMENT_HIS (250)
                      ( id = 'Z065' )    "WA_OUTPUT-PO_DIS (250)
*                     ( id = 'Z066' )    "NOT USING
*                     ( id = 'Z067' )    "NOT USING
*                     ( id = 'Z068' )    "NOT USING
*                     ( id = 'Z069' )    "NOT USING
                      ( id = 'Z101' )    "WA_OUTPUT-FULL_PMNT (255)
                      ( id = 'Z102' )    "WA_OUTPUT-PROJ (255)
                      ( id = 'Z103' )    "WA_OUTPUT-COND (255)
                      ( id = 'Z104' )    "WA_OUTPUT-INFRA (255)
                      ( id = 'Z105' )    "WA_OUTPUT-VALIDATION (255)
                      ( id = 'Z106' )    "WA_OUTPUT-REVIEW_DATE (255)
                      ( id = 'Z107' )    "WA_OUTPUT-DISS_SUMMARY (255)
                    ).

   SORT lt_hdid BY id.

   lt_so = CORRESPONDING #( put_so ).

   SORT lt_so BY vbeln.
   DELETE ADJACENT DUPLICATES FROM lt_so COMPARING vbeln.

* For header text
   LOOP AT LT_so INTO DATA(ls_so).
     lv_name = ls_so-vbeln.
     LOOP AT lt_hdid INTO DATA(ls_hdid).

       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
*          id                      = 'Z999'
           id                      = ls_hdid-id
           language                = 'E'
           name                    = lv_name
           object                  = 'VBBK'
*          ARCHIVE_HANDLE          = 0
*          LOCAL_CAT               = ' '
*          USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*          HEADER                  =
*          OLD_LINE_COUNTER        =
         TABLES
           lines                   = lt_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* Implement suitable error handling here
       ENDIF.
*    READ TABLE lt_lines INTO wa_lines INDEX 1.

       ls_hdtext-vbeln = ls_so-vbeln.
       IF lt_lines IS NOT INITIAL.
         LOOP AT lt_lines INTO DATA(ls_line).
           CONCATENATE ls_hdtext-text ls_line INTO ls_hdtext-text SEPARATED BY space.
         ENDLOOP.
         ls_hdtext-posnr = '000000'.
         ls_hdtext-obj = 'VBBK'.
         ls_hdtext-id = ls_hdid-id.
         ls_hdtext-name = lv_name.
         APPEND ls_hdtext TO gt_hdtext.
       ENDIF.
       CLEAR: lt_lines, ls_hdtext.
     ENDLOOP.
   ENDLOOP.

* For item text
   lt_hdid = VALUE #( ( id = 'Z102' )    "WA_OUTPUT-OFM_NO (128)
                      ( id = 'Z888' )    "WA_OUTPUT-SPECIAL_COMM (250)
                      ( id = '0001' )    "WA_OUTPUT-ITMTXT (255), WA_OUTPUT-MAT_TEXT (15)
*                     ( id = 'Z061' )    "Not using
                      ( id = 'Z110' )    "Not using
                      ( id = 'Z103' )    "WA_OUTPUT-PO_SR_NO (128)
                    ).

   SORT lt_hdid BY id.

   lt_so = CORRESPONDING #( put_so ).

   SORT lt_so BY vbeln posnr.
   DELETE ADJACENT DUPLICATES FROM lt_so COMPARING vbeln posnr.
   LOOP AT LT_so INTO ls_so.
     CONCATENATE ls_so-vbeln ls_so-posnr INTO lv_name.
     LOOP AT lt_hdid INTO ls_hdid.

       CALL FUNCTION 'READ_TEXT'
         EXPORTING
           client                  = sy-mandt
           id                      = ls_hdid-id
           language                = 'E'
           name                    = lv_name
           object                  = 'VBBP'
*          ARCHIVE_HANDLE          = 0
*          LOCAL_CAT               = ' '
*          USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*          HEADER                  =
*          OLD_LINE_COUNTER        =
         TABLES
           lines                   = lt_lines
         EXCEPTIONS
           id                      = 1
           language                = 2
           name                    = 3
           not_found               = 4
           object                  = 5
           reference_check         = 6
           wrong_access_to_archive = 7
           OTHERS                  = 8.
       IF sy-subrc <> 0.
* Implement suitable error handling here
       ENDIF.
*    READ TABLE lt_lines INTO wa_lines INDEX 1.

       ls_hdtext-vbeln = ls_so-vbeln.
       IF lt_lines IS NOT INITIAL.
         LOOP AT lt_lines INTO ls_line.
           CONCATENATE ls_hdtext-text ls_line INTO ls_hdtext-text SEPARATED BY space.
         ENDLOOP.
         ls_hdtext-posnr = ls_so-posnr.
         ls_hdtext-obj = 'VBBP'.
         ls_hdtext-id = ls_hdid-id.
         ls_hdtext-name = lv_name.
         APPEND ls_hdtext TO gt_hdtext.
       ENDIF.
       CLEAR: lt_lines, ls_hdtext.
     ENDLOOP.
   ENDLOOP.

   SORT gt_hdtext BY vbeln posnr obj id.
 ENDFORM.
*&---------------------------------------------------------------------*
*& Form fill_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> <F1>_VBELN
*&      --> <F1>_POSNR
*&      <-- LS_OUTPUT
*&---------------------------------------------------------------------*
 FORM fill_text  USING    pu_vbeln TYPE vbeln_va
                          pu_posnr TYPE posnr_Va
                 CHANGING Cs_output TYPE TY_tEXT.

   DATA: lt_hdtext TYPE tty_hdtext.

   lt_hdtext = CORRESPONDING #( gt_hdtext ).
   DELETE lt_hdtext WHERE vbeln <> pu_vbeln.
*  delete lt_hdtext where posnr <> pu_posnr.
* Header text
   LOOP AT lt_hdtext INTO DATA(ls_hdtext) WHERE obj = 'VBBK'
                                            AND posnr = '000000'.
     CASE ls_hdtext-id.
       WHEN  'Z999' .      cs_output-tpi   = ls_hdtext-text.
       WHEN  'Z005' .      cs_output-freight   = ls_hdtext-text.
       WHEN  'Z015' .      cs_output-ofm   = ls_hdtext-text.
       WHEN  'Z016' .      cs_output-ofm_date   = ls_hdtext-text.
       WHEN  'Z017' .      cs_output-insur   = ls_hdtext-text.
       WHEN  'Z020' .      cs_output-spl   = ls_hdtext-text.
       WHEN  'Z038' .      cs_output-ld_txt   = ls_hdtext-text.
       WHEN  'Z039' .      cs_output-tag_req   = ls_hdtext-text.
       WHEN  'Z047' .      cs_output-pardel   = ls_hdtext-text.
       WHEN  'Z062' .      cs_output-quota_ref   = ls_hdtext-text.
       WHEN  'Z063' .      cs_output-zcust_proj_name   = ls_hdtext-text.
       WHEN  'Z064' .      cs_output-amendment_his   = ls_hdtext-text.
       WHEN  'Z065' .      cs_output-po_dis   = ls_hdtext-text.
       WHEN  'Z101' .      cs_output-full_pmnt   = ls_hdtext-text.
       WHEN  'Z102' .      cs_output-proj   = ls_hdtext-text.
       WHEN  'Z103' .      cs_output-cond   = ls_hdtext-text.
       WHEN  'Z104' .      cs_output-infra   = ls_hdtext-text.
       WHEN  'Z105' .      cs_output-validation   = ls_hdtext-text.
       WHEN  'Z106' .      cs_output-review_date   = ls_hdtext-text.
       WHEN  'Z107' .      cs_output-diss_summary   = ls_hdtext-text.

       WHEN OTHERS.
     ENDCASE.

   ENDLOOP.

* ITEM text
   DELETE lt_hdtext WHERE posnr <> pu_posnr.
   LOOP AT lt_hdtext INTO ls_hdtext WHERE obj = 'VBBP'
                                            AND posnr = pu_posnr..
     CASE ls_hdtext-id.
       WHEN  'Z102' .      cs_output-ofm_no   = ls_hdtext-text.
       WHEN  'Z888' .      cs_output-special_comm   = ls_hdtext-text.
       WHEN  '0001' .      cs_output-itmtxt   = ls_hdtext-text.
       WHEN  'Z103' .      cs_output-po_sr_no   = ls_hdtext-text.
       WHEN OTHERS.
     ENDCASE.

   ENDLOOP.

 ENDFORM.
*&---------------------------------------------------------------------*
*& Form READ_MATEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_MATTXT
*&---------------------------------------------------------------------*
 FORM read_matext  CHANGING Ct_mattxt TYPE tty_mattxt.
   DATA: lt_lines TYPE STANDARD TABLE OF tline,
         lv_name  TYPE thead-tdname.

   LOOP AT ct_mattxt ASSIGNING FIELD-SYMBOL(<f1>).

     lv_name = <f1>-matnr.

     CALL FUNCTION 'READ_TEXT'
       EXPORTING
         client                  = sy-mandt
         id                      = 'GRUN'
         language                = sy-langu
         name                    = lv_name
         object                  = 'MATERIAL'
*        ARCHIVE_HANDLE          = 0
*        LOCAL_CAT               = ' '
*        USE_OLD_PERSISTENCE     = ABAP_FALSE
*     IMPORTING
*        HEADER                  =
*        OLD_LINE_COUNTER        =
       TABLES
         lines                   = lt_lines
       EXCEPTIONS
         id                      = 1
         language                = 2
         name                    = 3
         not_found               = 4
         object                  = 5
         reference_check         = 6
         wrong_access_to_archive = 7
         OTHERS                  = 8.
     IF sy-subrc <> 0.
* Implement suitable error handling here
     ENDIF.
     IF lt_lines IS NOT INITIAL.
       <f1>-mattxt = VALUE #( lt_lines[ 1 ]-tdline OPTIONAL ).
     ENDIF.
   ENDLOOP.
 ENDFORM.
