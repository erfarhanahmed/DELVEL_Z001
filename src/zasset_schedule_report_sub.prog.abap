*&---------------------------------------------------------------------*
*& Include          ZASSET_SCHEDULE_REPORT_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZASSET_SCHEDULE_REPORT_SUB
*&---------------------------------------------------------------------*
CLASS lcl_cust_coll_cls DEFINITION .
  PUBLIC SECTION.

    DATA : go_alv    TYPE REF TO cl_salv_table,
           go_cols   TYPE REF TO cl_salv_columns_table,
           go_layout TYPE REF TO cl_salv_layout,
           go_sort   TYPE REF TO cl_salv_sorts,
           go_tool   TYPE REF TO cl_salv_functions_list,
           gs_key    TYPE salv_s_layout_key.

    TYPES : BEGIN OF struct2,
              color TYPE lvc_t_scol,
              style TYPE lvc_t_styl.
        INCLUDE TYPE zasset_schedule. "<<< COLOR COLUMN
    TYPES   END OF struct2.

    DATA : gt_final TYPE TABLE OF struct2,
           wa_final TYPE  struct2.

    DATA :gv_first_date_current	TYPE string,
            gv_last_date_current  TYPE string.


    TYPE-POOLS truxs.
    DATA: it_csv TYPE truxs_t_text_data,
          wa_csv TYPE LINE OF truxs_t_text_data,
          hd_csv TYPE LINE OF truxs_t_text_data.
    DATA: lv_file(30).
    DATA: lv_fullfile TYPE string,
          lv_dat(10),
          lv_tim(4).
    DATA: lv_msg(80).

    TYPES: BEGIN OF ty_additions,
             bukrs     TYPE bukrs,
             anlkl     TYPE anlkl,
             bwsal     TYPE anep-bwasl,
             tot_anbtr TYPE anep-anbtr,
           END OF ty_additions.

    DATA: it_additions TYPE TABLE OF ty_additions,  " You must define ty_additions TYPE first
          wa_additions TYPE ty_additions.

    TYPES : BEGIN OF ty_down,
*     END OF TY_DOWN.
*    DATA : IT_DOWN TYPE TABLE OF TY_DOWN,
              particulars            TYPE string,
*              zreal_estate           TYPE string,
*              zbuildings             TYPE string,
*              zmachinery             TYPE string,
*              zfix_fitting           TYPE string,
*              zvehicles              TYPE string,
*              zdp_hardware           TYPE string,
*              zasset_construct       TYPE string,
*              zauc_investment        TYPE string,
*              zlow_value_asset       TYPE string,
*              zleased_assets         TYPE string,
*              zobj_of_art            TYPE string,
              zleasehold_improve     TYPE string,
              zland                  TYPE string,
              zbuilding              TYPE string,
              zcanteen_building      TYPE string,
              zlt_room               TYPE string,
              zsite_development      TYPE string,
              zsec_chnge_room        TYPE string,
              zplant_machinary       TYPE string,
              zplant_machinary_ro    TYPE string,
              zequipment             TYPE string,
              zsolar_equipment       TYPE string,
              ztools_dies_jigs       TYPE string,
              zpatterns              TYPE string,
              zelectrical_install    TYPE string,
              zfurniture_fitting     TYPE string,
              zrocks_pallets         TYPE string,
              zoffice_equipment      TYPE string,
              zvehicles_1            TYPE string,
              zcomputers_perpherals  TYPE string,
              zcomputer_software     TYPE string,
              zasset_under_construct TYPE string,
              ztotal                 TYPE string,
              ref                    TYPE char11,
              ref_time               TYPE char15,
            END OF ty_down.

    DATA : it_down TYPE TABLE OF ty_down,
           wa_down TYPE ty_down.

    METHODS : get_data,
      alv_factory,
      set_bold,
      set_color,
      DOWNLOAD.
    METHODS top_of_page1 CHANGING co_alv TYPE REF TO  cl_salv_table.

ENDCLASS.
CLASS lcl_cust_coll_cls IMPLEMENTATION .
  METHOD get_data.
    "Gross block (at cost)
    wa_final-particulars = 'Gross block (at cost)'.


    APPEND wa_final TO gt_final.
    CLEAR : wa_final.
*****************************************************************
    "As at FIRST DATE OF FISCAL YEAR


    DATA :gv_first_date	TYPE string,
          gv_last_date  TYPE string.
*    break primusabap.
    IF p_zujhr IS NOT INITIAL.
      DATA :p_zujhr1 TYPE t009b-bdatj.
*      DATA :p_zujhr_new TYPE t009b-bdatj.
      p_zujhr1 = p_zujhr - 1.
*      p_zujhr_new = p_zujhr - 2.
      ENDIF.
      data : gv_first_Date_new TYPE string.

      CONCATENATE '1 April' p_zujhr1 INTO gv_first_date_new SEPARATED BY ' '.

    CONCATENATE 'As at' gv_first_date_new INTO DATA(gv_string) SEPARATED BY ' '.
    wa_final-particulars = gv_string.

if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table @DATA(it_anla)
*      WHERE zujhr = @p_zujhr1
        WHERE  bukrs = @p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
*      WHERE zujhr = p_zujhr1
        WHERE bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.


      SELECT anln1,
             anln2,
             gjahr,
             afabe,
             kansw
             FROM anlc
             INTO TABLE @DATA(it_anlc)
             FOR ALL ENTRIES IN @it_anla
             WHERE anln1 = @it_anla-anln1
*             AND anln2 = @it_anla-anln2
             AND bukrs  =  @it_anla-bukrs
             AND gjahr = @p_zujhr1
              and afabe = '01'.


*      LOOP AT it_anla INTO DATA(wa_anla) WHERE anlkl = '1000'.
*        LOOP AT it_anlc INTO DATA(wa_anlc) WHERE anln1 = wa_anla-anln1
*                                              AND anln2 = wa_anla-anln2 .
*

      LOOP AT it_anla INTO data(wa_anla) WHERE anlkl = 'D1000'.
        LOOP AT it_anlc INTO data(wa_anlc) WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zleasehold_improve TYPE string.
      gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zland =  wa_final-zland + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
        data : gv_zland TYPE string.
       gv_zland  = gv_zland + wa_final-zland.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zbuilding =   wa_final-zbuilding + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
         data : gv_zbuilding TYPE string.
       gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
        data : gv_zcanteen_building TYPE string.
       gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zlt_room = wa_final-zlt_room + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
        data : gv_zlt_room TYPE string.
       gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsite_development = wa_final-zsite_development + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zsite_development TYPE string.
      gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zsec_chnge_room TYPE string.
      gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zplant_machinary TYPE string.
      gv_zplant_machinary  = gv_zplant_machinary + wa_final-zplant_machinary.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zplant_machinary_ro TYPE string.
      gv_zplant_machinary_ro  = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.


      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zequipment = wa_final-zequipment + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zequipment TYPE string.
      gv_zequipment  = gv_zequipment + wa_final-zequipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zsolar_equipment TYPE string.
      gv_zsolar_equipment  = gv_zsolar_equipment + wa_final-zsolar_equipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_ztools_dies_jigs TYPE string.
      gv_ztools_dies_jigs  = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zpatterns = wa_final-zpatterns + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zpatterns TYPE string.
      gv_zpatterns  = gv_zpatterns + wa_final-zpatterns.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zelectrical_install TYPE string.
      gv_zelectrical_install  = gv_zelectrical_install + wa_final-zelectrical_install.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zfurniture_fitting TYPE string.

       gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.
      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zrocks_pallets TYPE string.
      gv_zrocks_pallets  = gv_zrocks_pallets + wa_final-zrocks_pallets.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
        data : gv_zoffice_equipment TYPE string.
        gv_zoffice_equipment  = gv_zoffice_equipment + wa_final-zoffice_equipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zvehicles_1 TYPE string.
      gv_zvehicles_1  = gv_zvehicles_1 + wa_final-zvehicles_1.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
        data : gv_zcomputers_perpherals TYPE string.
       gv_zcomputers_perpherals  = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
      data : gv_zcomputer_software TYPE string.
      gv_zcomputer_software  = gv_zcomputer_software + wa_final-zcomputer_software.


      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
        LOOP AT it_anlc INTO wa_anlc WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc-kansw.
        ENDLOOP.
        CLEAR : wa_anlc ,wa_anla.
      ENDLOOP.
       data : gv_zasset_under_construct TYPE string.
      gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.

      wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        data : gv_ztotal TYPE string.

      gv_ztotal = gv_ztotal + wa_final-ztotal.

      APPEND wa_final TO gt_final.
      CLEAR : wa_final.

      refresh : it_anla, it_anlc.
*************************************************************************************************
      "Additions
      wa_final-particulars = 'Additions'.

*SELECT ANLA~bukrs
*       anla~anlkl
*       anep~bwsal
*       SUM( anep~anbtr ) AS tot_anbtr
*  INTO CORRESPONDING FIELDS OF TABLE it_additions
*  FROM anla
*  INNER JOIN anep
*    ON anla~anln1 = anep~anln1
*   AND anla~anln2 = anep~anln2
*   AND anla~bukrs = anep~bukrs
*   AND anla~zujhr = anep~gjahr
*  WHERE anla~zujhr = p_zujhr1
*    AND anla~bukrs = p_bukrs
*    AND anla~anlkl = p_anlkl
*    AND anep~bwsal LIKE '1%'
*  GROUP BY anla~anlkl.
*           anep~bwsal.

*      data(it_disposals) = it_additions.
*TYPES: BEGIN OF ty_result,
*         anlkl     TYPE anla-anlkl,
*         tot_anbtr TYPE anep-anbtr,
*       END OF ty_result.
*
*DATA: it_result TYPE SORTED TABLE OF ty_result
*                WITH UNIQUE KEY anlkl,
*      wa_result TYPE ty_result.
*

    if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table it_anla
      WHERE bukrs = p_bukrs."zujhr = p_zujhr1
*        AND bukrs = p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr1
         bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.

**LOOP AT it_anla INTO data(wa_anla).
      SELECT * FROM anep INTO TABLE @DATA(it_anep)
        FOR ALL ENTRIES IN @it_anla
        WHERE bukrs = @it_anla-bukrs
          AND anln1 = @it_anla-anln1
*          AND anln2 = @it_anla-anln2
          AND gjahr = @p_zujhr1"@it_anla-zujhr
        and afabe = '01'.
*          AND bwsal LIKE '1%'.
          data(it_anep1) = it_anep.
*          delete it_anep where bwasl ne '1%'.
          delete it_anep where not ( bwasl CP '1*' OR bwasl = '346' or bwasl = '341' or bwasl = '345' ).



        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anep INTO data(wa_anep) WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zland  = gv_zland + wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

           gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zplant_machinary = gv_zplant_machinary + wa_final-zplant_machinary.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zplant_machinary_ro = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zequipment = gv_zequipment + wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zsolar_equipment = gv_zsolar_equipment + wa_final-zsolar_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_ztools_dies_jigs = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zpatterns = gv_zpatterns + wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zelectrical_install = gv_zelectrical_install  + wa_final-zelectrical_install.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zfurniture_fitting = gv_zfurniture_fitting  + wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

          gv_zrocks_pallets = gv_zrocks_pallets  + wa_final-zrocks_pallets.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zoffice_equipment = gv_zoffice_equipment  + wa_final-zoffice_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zvehicles_1 = gv_zvehicles_1 + wa_final-zvehicles_1.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

          gv_zcomputers_perpherals = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zcomputer_software = gv_zcomputer_software + wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

      gv_zasset_under_construct = gv_zasset_under_construct + wa_final-zasset_under_construct.

       wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

       gv_ztotal = gv_ztotal + wa_final-ztotal.

      APPEND wa_final TO gt_final.
      CLEAR : wa_final.

*      refresh : it_Anla, it_Anep.

*****************************************************************
      "Disposals
      wa_final-particulars = 'Disposals'.

*       delete it_anep1 where bwasl ne '2'.
       delete it_anep1 where not ( bwasl CP '2*' or bwasl = '340' ).

*

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anep1 INTO data(wa_anep1) WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zleasehold_improve lt '0'.
          wa_final-zleasehold_improve = wa_final-zleasehold_improve * -1.
        endif.

         gv_zleasehold_improve = gv_zleasehold_improve - wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zland lt '0'.
          wa_final-zland = wa_final-zland * -1.
        endif.

        gv_zland = gv_zland - wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

       if wa_final-zbuilding lt '0'.
          wa_final-zbuilding = wa_final-zbuilding * -1.
        endif.

        gv_zbuilding = gv_zbuilding - wa_final-zbuilding.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         if wa_final-zcanteen_building lt '0'.
          wa_final-zcanteen_building = wa_final-zcanteen_building * -1.
        endif.

        gv_zcanteen_building = gv_zcanteen_building - wa_final-zcanteen_building .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        if wa_final-zlt_room lt '0'.
          wa_final-zlt_room = wa_final-zlt_room * -1.
        endif.

         gv_zlt_room = gv_zlt_room - wa_final-zlt_room .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zsite_development lt '0'.
         wa_final-zsite_development = wa_final-zsite_development * -1.
        endif.

        gv_zsite_development  = gv_zsite_development  - wa_final-zsite_development  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zsec_chnge_room lt '0'.
         wa_final-zsec_chnge_room = wa_final-zsec_chnge_room * -1.
        endif.

         gv_zsec_chnge_room  = gv_zsec_chnge_room  - wa_final-zsec_chnge_room  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary lt '0'.
         wa_final-zplant_machinary = wa_final-zplant_machinary * -1.
        endif.

        gv_zplant_machinary  = gv_zplant_machinary  - wa_final-zplant_machinary  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zplant_machinary_ro lt '0'.
         wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro * -1.
        endif.

        gv_zplant_machinary_ro  = gv_zplant_machinary_ro  - wa_final-zplant_machinary_ro  .


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if  wa_final-zequipment lt '0'.
          wa_final-zequipment =  wa_final-zequipment * -1.
        endif.

       gv_zequipment  = gv_zequipment  - wa_final-zequipment  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.
        if  wa_final-zsolar_equipment lt '0'.
           wa_final-zsolar_equipment =   wa_final-zsolar_equipment * -1.
        endif.

         gv_zsolar_equipment  = gv_zsolar_equipment  - wa_final-zsolar_equipment .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-ztools_dies_jigs lt '0'.
           wa_final-ztools_dies_jigs =   wa_final-ztools_dies_jigs * -1.
        endif.

        gv_ztools_dies_jigs  = gv_ztools_dies_jigs  - wa_final-ztools_dies_jigs .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zpatterns lt '0'.
           wa_final-zpatterns =   wa_final-zpatterns * -1.
        endif.

        gv_zpatterns  = gv_zpatterns  - wa_final-zpatterns .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zelectrical_install lt '0'.
           wa_final-zelectrical_install =   wa_final-zelectrical_install * -1.
        endif.

         gv_zelectrical_install  = gv_zelectrical_install  - wa_final-zelectrical_install .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if  wa_final-zfurniture_fitting lt '0'.
            wa_final-zfurniture_fitting =   wa_final-zfurniture_fitting * -1.
        endif.


         gv_zfurniture_fitting  = gv_zfurniture_fitting - wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zrocks_pallets lt '0'.
           wa_final-zrocks_pallets =  wa_final-zrocks_pallets * -1.
        endif.

         gv_zrocks_pallets  = gv_zrocks_pallets  - wa_final-zrocks_pallets .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zoffice_equipment lt '0'.
          wa_final-zoffice_equipment = wa_final-zoffice_equipment * -1.
        endif.

          gv_zoffice_equipment  = gv_zoffice_equipment - wa_final-zoffice_equipment .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if  wa_final-zvehicles_1 lt '0'.
           wa_final-zvehicles_1 =  wa_final-zvehicles_1 * -1.
        endif.

        gv_zvehicles_1  = gv_zvehicles_1  - wa_final-zvehicles_1 .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zcomputers_perpherals lt '0'.
          wa_final-zcomputers_perpherals =  wa_final-zcomputers_perpherals * -1.
        endif.

        gv_zcomputers_perpherals  = gv_zcomputers_perpherals - wa_final-zcomputers_perpherals .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zcomputer_software lt '0'.
          wa_final-zcomputer_software =  wa_final-zcomputer_software * -1.
        endif.

       gv_zcomputer_software  = gv_zcomputer_software - wa_final-zcomputer_software .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zasset_under_construct lt '0'.
          wa_final-zasset_under_construct =  wa_final-zasset_under_construct * -1.
        endif.

        gv_zasset_under_construct  = gv_zasset_under_construct - wa_final-zasset_under_construct .


       wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal - wa_final-ztotal.


      APPEND wa_final TO gt_final.
      CLEAR : wa_final.
      refresh : it_anla ,it_anep1.
*********************************************************************
      CONCATENATE '31 March' p_zujhr INTO gv_last_date SEPARATED BY ' '.


      CONCATENATE 'As at' gv_last_date INTO DATA(gv_string2) SEPARATED BY ' '.
      wa_final-particulars = gv_string2.


*       wa_final-zreal_estate           = gv_zreal_estate.
*       wa_final-zbuildings             = gv_zbuildings.
*       wa_final-zmachinery             = gv_zmachinery.
*       wa_final-zfix_fitting           = gv_zfix_fitting.
*       wa_final-zvehicles              = gv_zvehicles.
*       wa_final-zdp_hardware           = gv_zdp_hardware.
*       wa_final-zasset_construct       = gv_zasset_construct.
*       wa_final-zauc_investment        =  gv_zauc_investment.
*       wa_final-zlow_value_asset       =  gv_zlow_value_asset.
*       wa_final-zleased_assets         =  gv_zleased_assets.
*       wa_final-zobj_of_art            =  gv_zobj_of_art.
       wa_final-zleasehold_improve     =  gv_zleasehold_improve.
       wa_final-zland                  =  gv_zland.
       wa_final-zbuilding              = gv_zbuilding.
       wa_final-zcanteen_building      = gv_zcanteen_building.
       wa_final-zlt_room               = gv_zlt_room.
       wa_final-zsite_development      = gv_zsite_development.
       wa_final-zsec_chnge_room        = gv_zsec_chnge_room.
       wa_final-zplant_machinary       = gv_zplant_machinary.
       wa_final-zplant_machinary_ro    = gv_zplant_machinary_ro.
       wa_final-zequipment             = gv_zequipment.
       wa_final-zsolar_equipment       = gv_zsolar_equipment.
       wa_final-ztools_dies_jigs       = gv_ztools_dies_jigs.
       wa_final-zpatterns              = gv_zpatterns.
       wa_final-zelectrical_install    = gv_zelectrical_install.
       wa_final-zfurniture_fitting     = gv_zfurniture_fitting.
       wa_final-zrocks_pallets         = gv_zrocks_pallets.
       wa_final-zoffice_equipment      = gv_zoffice_equipment .
       wa_final-zvehicles_1            = gv_zvehicles_1 .
       wa_final-zcomputers_perpherals  = gv_zcomputers_perpherals .
       wa_final-zcomputer_software     = gv_zcomputer_software.
       wa_final-zasset_under_construct = gv_zasset_under_construct .
       wa_final-ztotal                 = gv_ztotal .


      APPEND wa_final TO gt_final.
      CLEAR : wa_final,
**             gv_zvehicles,
**             gv_zdp_hardware,
**             gv_zasset_construct,
**              gv_zauc_investment,
**              gv_zlow_value_asset,
**              gv_zleased_assets,
**              gv_zobj_of_art,
              gv_zleasehold_improve,
              gv_zland,
             gv_zbuilding,
             gv_zcanteen_building,
             gv_zlt_room,
             gv_zsite_development,
             gv_zsec_chnge_room,
             gv_zplant_machinary,
             gv_zplant_machinary_ro,
             gv_zequipment,
             gv_zsolar_equipment,
             gv_ztools_dies_jigs,
             gv_zpatterns,
             gv_zelectrical_install,
             gv_zfurniture_fitting,
             gv_zrocks_pallets,
             gv_zoffice_equipment,
             gv_zvehicles_1,
             gv_zcomputers_perpherals,
             gv_zcomputer_software,
             gv_zasset_under_construct ,
             gv_ztotal .

****************************************************************************
********************************Current year ********************************
CONCATENATE '1 April' p_zujhr INTO gv_first_date_current SEPARATED BY ' '.

      CONCATENATE 'As at' gv_first_date_current INTO DATA(gv_string3) SEPARATED BY ' '.
      read TABLE gt_final INTO wa_final index 5.
      wa_final-particulars = gv_string3.




        gv_zleasehold_improve = gv_zleasehold_improve + wa_final-zleasehold_improve.
       gv_zland               = gv_zland + wa_final-zland.
       gv_zbuilding           = gv_zbuilding + wa_final-zbuilding.
       gv_zcanteen_building   = gv_zcanteen_building + wa_final-zcanteen_building.
       gv_zlt_room            = gv_zlt_room + wa_final-zlt_room.
       gv_zsite_development   = gv_zsite_development + wa_final-zsite_development.
       gv_zsec_chnge_room     = gv_zsec_chnge_room  + wa_final-zsec_chnge_room   .
       gv_zplant_machinary    = gv_zplant_machinary + wa_final-zplant_machinary.
       gv_zplant_machinary_ro = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.
       gv_zequipment          = gv_zequipment + wa_final-zequipment.
       gv_zsolar_equipment    =  gv_zsolar_equipment + wa_final-zsolar_equipment.
       gv_ztools_dies_jigs    =  gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.
       gv_zpatterns           =  gv_zpatterns + wa_final-zpatterns.
       gv_zelectrical_install = gv_zelectrical_install + wa_final-zelectrical_install.
       gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.
       gv_zrocks_pallets      = gv_zrocks_pallets + wa_final-zrocks_pallets.
       gv_zoffice_equipment   = gv_zoffice_equipment + wa_final-zoffice_equipment.
       gv_zvehicles_1         = gv_zvehicles_1 + wa_final-zvehicles_1.
       gv_zcomputers_perpherals = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.
       gv_zcomputer_software   =  gv_zcomputer_software + wa_final-zcomputer_software.
       gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.
       gv_ztotal                = gv_ztotal + wa_final-ztotal.
*   gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.
*
*          wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
*                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
*                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
*                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
*                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
*                        + wa_final-zasset_under_construct ).

*          gv_ztotal = gv_ztotal + wa_final-ztotal.

        APPEND wa_final TO gt_final.
        CLEAR : wa_final.
refresh : it_anla ,it_anlc.
*************************************************************************************************
        "Additions
        wa_final-particulars = 'Additions'.

*SELECT ANLA~bukrs
*       anla~anlkl
*       anep~bwsal
*       SUM( anep~anbtr ) AS tot_anbtr
*  INTO CORRESPONDING FIELDS OF TABLE it_additions
*  FROM anla
*  INNER JOIN anep
*    ON anla~anln1 = anep~anln1
*   AND anla~anln2 = anep~anln2
*   AND anla~bukrs = anep~bukrs
*   AND anla~zujhr = anep~gjahr
*  WHERE anla~zujhr = p_zujhr1
*    AND anla~bukrs = p_bukrs
*    AND anla~anlkl = p_anlkl
*    AND anep~bwsal LIKE '1%'
*  GROUP BY anla~anlkl.
*           anep~bwsal.

*      data(it_disposals) = it_additions.
*TYPES: BEGIN OF ty_result,
*         anlkl     TYPE anla-anlkl,
*         tot_anbtr TYPE anep-anbtr,
*       END OF ty_result.
*
*DATA: it_result TYPE SORTED TABLE OF ty_result
*                WITH UNIQUE KEY anlkl,
*      wa_result TYPE ty_result.
*

 if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr
       bukrs = p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr
        bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.

**LOOP AT it_anla INTO data(wa_anla).
      SELECT * FROM anep INTO TABLE it_anep
        FOR ALL ENTRIES IN it_anla
        WHERE bukrs = it_anla-bukrs
          AND anln1 = it_anla-anln1
*          AND anln2 = @it_anla-anln2
          AND gjahr = P_zujhr
        and afabe = '01'.
*          AND bwsal LIKE '1%'.
         it_anep1 = it_anep.
*          delete it_anep where bwasl ne '1%'.
*          delete it_anep where not bwasl CP '1*'.
           delete it_anep where not ( bwasl CP '1*' OR bwasl = '346' or bwasl = '341' or bwasl = '345').


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zland  = gv_zland + wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zplant_machinary  = gv_zplant_machinary + wa_final-zplant_machinary.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

     gv_zplant_machinary_ro  = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zequipment  = gv_zequipment + wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zsolar_equipment  = gv_zsolar_equipment + wa_final-zsolar_equipment.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_ztools_dies_jigs  = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zpatterns  = gv_zpatterns + wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

          gv_zelectrical_install  = gv_zelectrical_install + wa_final-zelectrical_install.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zrocks_pallets  = gv_zrocks_pallets + wa_final-zrocks_pallets.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

            gv_zoffice_equipment  = gv_zoffice_equipment + wa_final-zoffice_equipment.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         gv_zvehicles_1  = gv_zvehicles_1 + wa_final-zvehicles_1.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zcomputers_perpherals  = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zcomputer_software  = gv_zcomputer_software + wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anep INTO wa_anep WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anep-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.

         wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal + wa_final-ztotal.

        APPEND wa_final TO gt_final.
        CLEAR : wa_final.
refresh : it_anep.
*****************************************************************
        "Disposals
        wa_final-particulars = 'Disposals'.
               delete it_anep1 where not ( bwasl CP '2*' or bwasl = '340' ).


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zleasehold_improve lt '0'.
          wa_final-zleasehold_improve =  wa_final-zleasehold_improve * -1.
        endif.

        gv_zleasehold_improve = gv_zleasehold_improve - wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zland lt '0'.
          wa_final-zland =  wa_final-zland * -1.
        endif.

         gv_zland = gv_zland - wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zbuilding lt '0'.
          wa_final-zbuilding =  wa_final-zbuilding * -1.
        endif.


         gv_zbuilding = gv_zbuilding - wa_final-zbuilding.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        if wa_final-zcanteen_building lt '0'.
          wa_final-zcanteen_building =  wa_final-zcanteen_building * -1.
        endif.

         gv_zcanteen_building = gv_zcanteen_building - wa_final-zcanteen_building.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

         if wa_final-zlt_room lt '0'.
          wa_final-zlt_room =   wa_final-zlt_room * -1.
        endif.

        gv_zlt_room = gv_zlt_room - wa_final-zlt_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zsite_development lt '0'.
          wa_final-zsite_development  =  wa_final-zsite_development * -1.
        endif.

         gv_zsite_development = gv_zsite_development - wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zsec_chnge_room lt '0'.
         wa_final-zsec_chnge_room  =  wa_final-zsec_chnge_room * -1.
        endif.

         gv_zsec_chnge_room = gv_zsec_chnge_room - wa_final-zsec_chnge_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary lt '0'.
         wa_final-zplant_machinary  =  wa_final-zplant_machinary * -1.
        endif.

        gv_zplant_machinary = gv_zplant_machinary - wa_final-zplant_machinary.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary_ro lt '0'.
         wa_final-zplant_machinary_ro  =  wa_final-zplant_machinary_ro * -1.
        endif.

        gv_zplant_machinary_ro = gv_zplant_machinary_ro - wa_final-zplant_machinary_ro.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zequipment  lt '0'.
         wa_final-zequipment =  wa_final-zequipment  * -1.
        endif.

        gv_zequipment = gv_zequipment - wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zsolar_equipment lt '0'.
         wa_final-zsolar_equipment =  wa_final-zsolar_equipment  * -1.
        endif.

         gv_zsolar_equipment = gv_zsolar_equipment - wa_final-zsolar_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-ztools_dies_jigs lt '0'.
         wa_final-ztools_dies_jigs =  wa_final-ztools_dies_jigs * -1.
        endif.

        gv_ztools_dies_jigs = gv_ztools_dies_jigs - wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.


        if wa_final-zpatterns lt '0'.
         wa_final-zpatterns =  wa_final-zpatterns * -1.
        endif.

        gv_zpatterns = gv_zpatterns - wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if  wa_final-zelectrical_install lt '0'.
         wa_final-zelectrical_install =   wa_final-zelectrical_install * -1.
        endif.

        gv_zelectrical_install = gv_zelectrical_install - wa_final-zelectrical_install.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if  wa_final-zfurniture_fitting lt '0'.
         wa_final-zfurniture_fitting =  wa_final-zfurniture_fitting * -1.
        endif.

         gv_zfurniture_fitting = gv_zfurniture_fitting - wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

         if wa_final-zrocks_pallets lt '0'.
         wa_final-zrocks_pallets = wa_final-zrocks_pallets * -1.
        endif.

        gv_zrocks_pallets = gv_zrocks_pallets - wa_final-zrocks_pallets.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

           if wa_final-zoffice_equipment lt '0'.
         wa_final-zoffice_equipment = wa_final-zoffice_equipment * -1.
        endif.

        gv_zoffice_equipment = gv_zoffice_equipment - wa_final-zoffice_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

           if wa_final-zvehicles_1 lt '0'.
         wa_final-zvehicles_1 = wa_final-zvehicles_1 * -1.
        endif.

        gv_zvehicles_1 = gv_zvehicles_1 - wa_final-zvehicles_1.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

          if wa_final-zcomputers_perpherals lt '0'.
         wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals * -1.
        endif.

         gv_zcomputers_perpherals = gv_zcomputers_perpherals - wa_final-zcomputers_perpherals.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

          if wa_final-zcomputer_software lt '0'.
         wa_final-zcomputer_software = wa_final-zcomputer_software * -1.
        endif.

        gv_zcomputer_software = gv_zcomputer_software - wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anep1 INTO wa_anep1 WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anep1-anbtr.
          ENDLOOP.
          CLEAR : wa_anep1 ,wa_anla.
        ENDLOOP.

        if wa_final-zasset_under_construct lt '0'.
         wa_final-zasset_under_construct = wa_final-zasset_under_construct * -1.
        endif.

        gv_zasset_under_construct = gv_zasset_under_construct - wa_final-zasset_under_construct.

         wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal - wa_final-ztotal.

        APPEND wa_final TO gt_final.
        CLEAR : wa_final.

        refresh : it_anep1 ,it_anla.

*********************************************************************
          DATA :p_zujhr2 TYPE t009b-bdatj.
        p_zujhr2 = p_zujhr + 1 .
         CONCATENATE '31 March' p_zujhr2 INTO gv_last_date_current SEPARATED BY ' '.

        CONCATENATE 'As at' gv_last_date_current INTO DATA(gv_string4) SEPARATED BY ' '.
        wa_final-particulars = gv_string4.



*       wa_final-zreal_estate           = gv_zreal_estate.
*       wa_final-zbuildings             = gv_zbuildings.
*       wa_final-zmachinery             = gv_zmachinery.
*       wa_final-zfix_fitting           = gv_zfix_fitting.
*       wa_final-zvehicles              = gv_zvehicles.
*       wa_final-zdp_hardware           = gv_zdp_hardware.
*       wa_final-zasset_construct       = gv_zasset_construct.
*       wa_final-zauc_investment        = gv_zauc_investment.
*       wa_final-zlow_value_asset       = gv_zlow_value_asset.
*       wa_final-zleased_assets         = gv_zleased_assets.
*       wa_final-zobj_of_art            = gv_zobj_of_art.
       wa_final-zleasehold_improve     = gv_zleasehold_improve.
       wa_final-zland                  = gv_zland.
       wa_final-zbuilding              = gv_zbuilding.
       wa_final-zcanteen_building      = gv_zcanteen_building.
       wa_final-zlt_room               = gv_zlt_room.
       wa_final-zsite_development      = gv_zsite_development.
       wa_final-zsec_chnge_room        = gv_zsec_chnge_room.
       wa_final-zplant_machinary       = gv_zplant_machinary.
       wa_final-zplant_machinary_ro    = gv_zplant_machinary_ro.
       wa_final-zequipment             = gv_zequipment.
       wa_final-zsolar_equipment       = gv_zsolar_equipment.
       wa_final-ztools_dies_jigs       = gv_ztools_dies_jigs.
       wa_final-zpatterns              = gv_zpatterns.
       wa_final-zelectrical_install    = gv_zelectrical_install.
       wa_final-zfurniture_fitting     = gv_zfurniture_fitting.
       wa_final-zrocks_pallets         = gv_zrocks_pallets.
       wa_final-zoffice_equipment      = gv_zoffice_equipment .
       wa_final-zvehicles_1            = gv_zvehicles_1 .
       wa_final-zcomputers_perpherals  = gv_zcomputers_perpherals .
       wa_final-zcomputer_software     = gv_zcomputer_software.
       wa_final-zasset_under_construct = gv_zasset_under_construct .
       wa_final-ztotal                 = gv_ztotal.





        APPEND wa_final TO gt_final.
        CLEAR : wa_final,
*             gv_zvehicles,
*             gv_zdp_hardware,
*             gv_zasset_construct,
*              gv_zauc_investment,
*              gv_zlow_value_asset,
*              gv_zleased_assets,
*              gv_zobj_of_art,
              gv_zleasehold_improve,
              gv_zland,
             gv_zbuilding,
             gv_zcanteen_building,
             gv_zlt_room,
             gv_zsite_development,
             gv_zsec_chnge_room,
             gv_zplant_machinary,
             gv_zplant_machinary_ro,
             gv_zequipment,
             gv_zsolar_equipment,
             gv_ztools_dies_jigs,
             gv_zpatterns,
             gv_zelectrical_install,
             gv_zfurniture_fitting,
             gv_zrocks_pallets,
             gv_zoffice_equipment,
             gv_zvehicles_1,
             gv_zcomputers_perpherals,
             gv_zcomputer_software,
             gv_zasset_under_construct ,
             gv_ztotal.
*********************************************************************
***************************************end gross block (at cost)**************
******************************************************************************
***  start Accumulated depreciation************************************
      "Accumulated depreciation
      wa_final-particulars = 'Accumulated depreciation '.
      APPEND wa_final TO gt_final.
      CLEAR : wa_final.
*****************************************************************
************************last year fiscal year data**********************
      clear gv_string.
    CONCATENATE '1 April' p_zujhr1 INTO gv_first_date_new SEPARATED BY ' '.

    CONCATENATE 'As at' gv_first_date_new INTO gv_string SEPARATED BY ' '.
    wa_final-particulars = gv_string.

if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr1
         bukrs = p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr1
        bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.


      SELECT anln1,
             anln2,
             gjahr,
             afabe,
             knafa,
             KAafa
             FROM anlc
             INTO TABLE @data(it_anlc_accu)
             FOR ALL ENTRIES IN @it_anla
             WHERE anln1 = @it_anla-anln1
*             AND anln2 = @it_anla-anln2
             AND bukrs  =  @it_anla-bukrs
             AND gjahr = @p_zujhr1"it_anla-zujhr
              and afabe = '01'.




      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
        LOOP AT it_anlc_accu INTO data(wa_anlc_new) WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
*       data : gv_zleasehold_improve TYPE string.
      if wa_final-zleasehold_improve lt 0.
        wa_final-zleasehold_improve = wa_final-zleasehold_improve * -1.
      endif.
      gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zland =  wa_final-zland + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-zland lt 0.
       wa_final-zland = wa_final-zland * -1.
      endif.
*        data : gv_zland TYPE string.
       gv_zland  = gv_zland + wa_final-zland.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zbuilding =   wa_final-zbuilding + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-zbuilding lt 0.
       wa_final-zbuilding = wa_final-zbuilding * -1.
      endif.
*         data : gv_zbuilding TYPE string.
       gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
      if  wa_final-zcanteen_building lt 0.
        wa_final-zcanteen_building =  wa_final-zcanteen_building * -1.
      endif.
*        data : gv_zcanteen_building TYPE string.
       gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zlt_room = wa_final-zlt_room + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-zlt_room lt 0.
       wa_final-zlt_room =  wa_final-zlt_room * -1.
      endif.
*        data : gv_zlt_room TYPE string.
       gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsite_development = wa_final-zsite_development + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
        if  wa_final-zsite_development lt 0.
        wa_final-zsite_development =   wa_final-zsite_development * -1.
      endif.
*      data : gv_zsite_development TYPE string.
      gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR :wa_anlc_new ,wa_anla.
      ENDLOOP.
        if wa_final-zsec_chnge_room lt 0.
        wa_final-zsec_chnge_room =  wa_final-zsec_chnge_room * -1.
      endif.
*       data : gv_zsec_chnge_room TYPE string.
      gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
        if  wa_final-zplant_machinary lt 0.
         wa_final-zplant_machinary =  wa_final-zplant_machinary * -1.
      endif.
*       data : gv_zplant_machinary TYPE string.
      gv_zplant_machinary  = gv_zplant_machinary + wa_final-zplant_machinary.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if  wa_final-zplant_machinary_ro lt 0.
         wa_final-zplant_machinary_ro =  wa_final-zplant_machinary_ro * -1.
      endif.
*       data : gv_zplant_machinary_ro TYPE string.
      gv_zplant_machinary_ro  = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.


      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zequipment = wa_final-zequipment + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-zequipment lt 0.
         wa_final-zequipment = wa_final-zequipment * -1.
      endif.
*       data : gv_zequipment TYPE string.
      gv_zequipment  = gv_zequipment + wa_final-zequipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-zsolar_equipment lt 0.
         wa_final-zsolar_equipment = wa_final-zsolar_equipment * -1.
      endif.
*      data : gv_zsolar_equipment TYPE string.
      gv_zsolar_equipment  = gv_zsolar_equipment + wa_final-zsolar_equipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
       if wa_final-ztools_dies_jigs lt 0.
         wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs * -1.
      endif.
*       data : gv_ztools_dies_jigs TYPE string.
      gv_ztools_dies_jigs  = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zpatterns = wa_final-zpatterns + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.

       if wa_final-zpatterns lt 0.
         wa_final-zpatterns = wa_final-zpatterns * -1.
      endif.
*       data : gv_zpatterns TYPE string.
      gv_zpatterns  = gv_zpatterns + wa_final-zpatterns.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new,wa_anla.
      ENDLOOP.
        if wa_final-zelectrical_install lt 0.
         wa_final-zelectrical_install = wa_final-zelectrical_install * -1.
      endif.
*      data : gv_zelectrical_install TYPE string.
      gv_zelectrical_install  = gv_zelectrical_install + wa_final-zelectrical_install.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
*      data : gv_zfurniture_fitting TYPE string.

       if wa_final-zfurniture_fitting lt 0.
        wa_final-zfurniture_fitting = wa_final-zfurniture_fitting * -1.
      endif.
       gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.

       if wa_final-zrocks_pallets lt 0.
        wa_final-zrocks_pallets = wa_final-zrocks_pallets * -1.
      endif.


*      data : gv_zrocks_pallets TYPE string.
      gv_zrocks_pallets  = gv_zrocks_pallets + wa_final-zrocks_pallets.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.

       if wa_final-zoffice_equipment lt 0.
        wa_final-zoffice_equipment = wa_final-zoffice_equipment * -1.
      endif.

*        data : gv_zoffice_equipment TYPE string.
        gv_zoffice_equipment  = gv_zoffice_equipment + wa_final-zoffice_equipment.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.

       if wa_final-zvehicles_1 lt 0.
        wa_final-zvehicles_1 = wa_final-zvehicles_1 * -1.
      endif.

*      data : gv_zvehicles_1 TYPE string.
      gv_zvehicles_1  = gv_zvehicles_1 + wa_final-zvehicles_1.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new,wa_anla.
      ENDLOOP.
         if  wa_final-zcomputers_perpherals lt 0.
         wa_final-zcomputers_perpherals =  wa_final-zcomputers_perpherals * -1.
      endif.
*        data : gv_zcomputers_perpherals TYPE string.
       gv_zcomputers_perpherals  = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.

      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new,wa_anla.
      ENDLOOP.
        if wa_final-zcomputer_software lt 0.
         wa_final-zcomputer_software =  wa_final-zcomputer_software * -1.
      endif.

*      data : gv_zcomputer_software TYPE string.
      gv_zcomputer_software  = gv_zcomputer_software + wa_final-zcomputer_software.


      LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
        LOOP AT it_anlc_accu INTO wa_anlc_new WHERE anln1 = wa_anla-anln1
                                            AND anln2 = wa_anla-anln2 .

          wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc_new-knafa + wa_anlc_new-kaafa.
        ENDLOOP.
        CLEAR : wa_anlc_new ,wa_anla.
      ENDLOOP.
          if wa_final-zasset_under_construct  lt 0.
         wa_final-zasset_under_construct  =  wa_final-zasset_under_construct * -1.
      endif.
*       data : gv_zasset_under_construct TYPE string.
      gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.

      wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

*        data : gv_ztotal TYPE string.

      gv_ztotal = gv_ztotal + wa_final-ztotal.

      APPEND wa_final TO gt_final.
      CLEAR : wa_final.

      refresh : it_anla, it_anlc.
*************************************************************************************************
      "Additions
      wa_final-particulars = 'Charge for the Year'.


    if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr1
       bukrs = p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr1
        bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.
data: it_anlc_charge TYPE TABLE OF anlc,
      wa_anlc_charge TYPE anlc.
**LOOP AT it_anla INTO data(wa_anla).
      SELECT * FROM anlc INTO TABLE it_anlc_charge
        FOR ALL ENTRIES IN it_anla
        WHERE bukrs = it_anla-bukrs
          AND anln1 = it_anla-anln1
*          AND anln2 = it_anla-anln2
          AND gjahr = p_zujhr1"it_anla-zujhr
        and afabe = '1'.
*          AND bwsal LIKE '1%'.

*  loop at it_anla INTO data(temp).
*    read TABLE it_anlc_charge INTO data(temp1) with key anln1 = it_anla-anln1
*  endloop.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

      if wa_final-zleasehold_improve lt 0.
         wa_final-zleasehold_improve =  wa_final-zleasehold_improve * -1.
      endif.

        gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

      if wa_final-zland lt 0.
          wa_final-zland =   wa_final-zland * -1.
      endif.

         gv_zland  = gv_zland + wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        if wa_final-zbuilding  lt 0.
          wa_final-zbuilding  =    wa_final-zbuilding  * -1.
      endif.

        gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zcanteen_building lt 0.
          wa_final-zcanteen_building  =   wa_final-zcanteen_building  * -1.
         endif.

           gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zlt_room lt 0.
          wa_final-zlt_room =  wa_final-zlt_room * -1.
         endif.

        gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_Charge ,wa_anla.
        ENDLOOP.

         if wa_final-zsite_development lt 0.
          wa_final-zsite_development =  wa_final-zsite_development * -1.
         endif.

        gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zsec_chnge_room lt 0.
         wa_final-zsec_chnge_room =  wa_final-zsec_chnge_room * -1.
         endif.

         gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zplant_machinary lt 0.
          wa_final-zplant_machinary =   wa_final-zplant_machinary * -1.
         endif.

         gv_zplant_machinary = gv_zplant_machinary + wa_final-zplant_machinary.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary_ro lt 0.
          wa_final-zplant_machinary_ro =   wa_final-zplant_machinary_ro * -1.
         endif.

        gv_zplant_machinary_ro = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR : wa_anlc_Charge ,wa_anla.
        ENDLOOP.

         if wa_final-zequipment lt 0.
          wa_final-zequipment =  wa_final-zequipment * -1.
         endif.

        gv_zequipment = gv_zequipment + wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zsolar_equipment lt 0.
          wa_final-zsolar_equipment =  wa_final-zsolar_equipment * -1.
         endif.

        gv_zsolar_equipment = gv_zsolar_equipment + wa_final-zsolar_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-ztools_dies_jigs lt 0.
         wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs * -1.
         endif.

         gv_ztools_dies_jigs = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zpatterns lt 0.
         wa_final-zpatterns = wa_final-zpatterns * -1.
         endif.

         gv_zpatterns = gv_zpatterns + wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zelectrical_install lt 0.
          wa_final-zelectrical_install =  wa_final-zelectrical_install * -1.
         endif.

        gv_zelectrical_install = gv_zelectrical_install  + wa_final-zelectrical_install.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

         if  wa_final-zfurniture_fitting lt 0.
          wa_final-zfurniture_fitting =  wa_final-zfurniture_fitting * -1.
         endif.

        gv_zfurniture_fitting = gv_zfurniture_fitting  + wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zrocks_pallets lt 0.
         wa_final-zrocks_pallets =  wa_final-zrocks_pallets * -1.
         endif.

          gv_zrocks_pallets = gv_zrocks_pallets  + wa_final-zrocks_pallets.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zoffice_equipment lt 0.
         wa_final-zoffice_equipment =  wa_final-zoffice_equipment * -1.
         endif.


        gv_zoffice_equipment = gv_zoffice_equipment  + wa_final-zoffice_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zvehicles_1 lt 0.
          wa_final-zvehicles_1 =  wa_final-zvehicles_1 * -1.
         endif.

         gv_zvehicles_1 = gv_zvehicles_1 + wa_final-zvehicles_1.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zcomputers_perpherals lt 0.
          wa_final-zcomputers_perpherals =  wa_final-zcomputers_perpherals * -1.
        endif.

          gv_zcomputers_perpherals = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
        LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zcomputer_software lt 0.
          wa_final-zcomputer_software =  wa_final-zcomputer_software * -1.
        endif.

        gv_zcomputer_software = gv_zcomputer_software + wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zasset_under_construct lt 0.
          wa_final-zasset_under_construct =  wa_final-zasset_under_construct * -1.
        endif.

      gv_zasset_under_construct = gv_zasset_under_construct + wa_final-zasset_under_construct.

       wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

       gv_ztotal = gv_ztotal + wa_final-ztotal.

      APPEND wa_final TO gt_final.
      CLEAR : wa_final.

*      refresh : it_Anla, it_Anep.

*****************************************************************
      "Disposals
      wa_final-particulars = 'Disposals'.

*       delete it_anep1 where bwasl ne '2'.
*       delete it_anep1 where not bwasl CP '2*'.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zleasehold_improve lt '0'.
          wa_final-zleasehold_improve = wa_final-zleasehold_improve  * -1.
        endif.
*
         gv_zleasehold_improve = gv_zleasehold_improve - wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

          if wa_final-zland lt '0'.
          wa_final-zland = wa_final-zland  * -1.
        endif.

        gv_zland = gv_zland - wa_final-zland.
*
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zbuilding lt '0'.
         wa_final-zbuilding = wa_final-zbuilding  * -1.
        endif.
*
        gv_zbuilding = gv_zbuilding - wa_final-zbuilding.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if  wa_final-zcanteen_building lt '0'.
         wa_final-zcanteen_building =  wa_final-zcanteen_building  * -1.
        endif.

        gv_zcanteen_building = gv_zcanteen_building - wa_final-zcanteen_building .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav. .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zlt_room lt '0'.
         wa_final-zlt_room =  wa_final-zlt_room  * -1.
        endif.

         gv_zlt_room = gv_zlt_room - wa_final-zlt_room .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if  wa_final-zsite_development lt '0'.
          wa_final-zsite_development =   wa_final-zsite_development  * -1.
        endif.

        gv_zsite_development  = gv_zsite_development  - wa_final-zsite_development  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

          if wa_final-zsec_chnge_room lt '0'.
          wa_final-zsec_chnge_room =  wa_final-zsec_chnge_room * -1.
        endif.

         gv_zsec_chnge_room  = gv_zsec_chnge_room  - wa_final-zsec_chnge_room  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zplant_machinary lt '0'.
          wa_final-zplant_machinary =  wa_final-zplant_machinary * -1.
        endif.

        gv_zplant_machinary  = gv_zplant_machinary - wa_final-zplant_machinary  .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary_ro lt '0'.
          wa_final-zplant_machinary_ro =  wa_final-zplant_machinary_ro * -1.
        endif.

        gv_zplant_machinary_ro  = gv_zplant_machinary_ro - wa_final-zplant_machinary_ro  .
*
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zequipment lt '0'.
          wa_final-zequipment =  wa_final-zequipment * -1.
        endif.

       gv_zequipment  = gv_zequipment - wa_final-zequipment  .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
*
            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zsolar_equipment lt '0'.
          wa_final-zsolar_equipment =  wa_final-zsolar_equipment * -1.
        endif.

         gv_zsolar_equipment  = gv_zsolar_equipment - wa_final-zsolar_equipment .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-ztools_dies_jigs lt '0'.
          wa_final-ztools_dies_jigs =  wa_final-ztools_dies_jigs * -1.
        endif.
*
        gv_ztools_dies_jigs  = gv_ztools_dies_jigs  - wa_final-ztools_dies_jigs .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 . .

            wa_final-zpatterns = wa_final-zpatterns + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zpatterns lt '0'.
          wa_final-zpatterns =  wa_final-zpatterns * -1.
        endif.

        gv_zpatterns  = gv_zpatterns - wa_final-zpatterns .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2  .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if  wa_final-zelectrical_install lt '0'.
           wa_final-zelectrical_install =   wa_final-zelectrical_install * -1.
        endif.
*
         gv_zelectrical_install  = gv_zelectrical_install  - wa_final-zelectrical_install .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zfurniture_fitting lt '0'.
           wa_final-zfurniture_fitting =   wa_final-zfurniture_fitting * -1.
        endif.

*
         gv_zfurniture_fitting = gv_zfurniture_fitting - wa_final-zfurniture_fitting.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zrocks_pallets lt '0'.
           wa_final-zrocks_pallets =   wa_final-zrocks_pallets * -1.
        endif.

         gv_zrocks_pallets  = gv_zrocks_pallets  - wa_final-zrocks_pallets .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 ..

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zoffice_equipment lt '0'.
           wa_final-zoffice_equipment =  wa_final-zoffice_equipment * -1.
        endif.
*
          gv_zoffice_equipment  = gv_zoffice_equipment - wa_final-zoffice_equipment .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zvehicles_1 lt '0'.
          wa_final-zvehicles_1 =  wa_final-zvehicles_1 * -1.
        endif.

        gv_zvehicles_1  = gv_zvehicles_1  - wa_final-zvehicles_1 .

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zcomputers_perpherals lt '0'.
          wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals * -1.
        endif.

        gv_zcomputers_perpherals  = gv_zcomputers_perpherals  - wa_final-zcomputers_perpherals .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zcomputer_software lt '0'.
          wa_final-zcomputer_software = wa_final-zcomputer_software * -1.
        endif.

       gv_zcomputer_software  = gv_zcomputer_software  - wa_final-zcomputer_software .
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zasset_under_construct lt '0'.
         wa_final-zasset_under_construct = wa_final-zasset_under_construct * -1.
        endif.

        gv_zasset_under_construct  = gv_zasset_under_construct  - wa_final-zasset_under_construct .


       wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal - wa_final-ztotal.


      APPEND wa_final TO gt_final.
      CLEAR : wa_final.
      refresh : it_anla ,it_anep1.
*********************************************************************
      CONCATENATE '31 March' p_zujhr INTO gv_last_date SEPARATED BY ' '.


      CONCATENATE 'As at' gv_last_date INTO gv_string2 SEPARATED BY ' '.
      wa_final-particulars = gv_string2.


*       wa_final-zreal_estate           = gv_zreal_estate.
*       wa_final-zbuildings             = gv_zbuildings.
*       wa_final-zmachinery             = gv_zmachinery.
*       wa_final-zfix_fitting           = gv_zfix_fitting.
*       wa_final-zvehicles              = gv_zvehicles.
*       wa_final-zdp_hardware           = gv_zdp_hardware.
*       wa_final-zasset_construct       = gv_zasset_construct.
*       wa_final-zauc_investment        =  gv_zauc_investment.
*       wa_final-zlow_value_asset       =  gv_zlow_value_asset.
*       wa_final-zleased_assets         =  gv_zleased_assets.
*       wa_final-zobj_of_art            =  gv_zobj_of_art.
       wa_final-zleasehold_improve     =  gv_zleasehold_improve.
       wa_final-zland                  =  gv_zland.
       wa_final-zbuilding              = gv_zbuilding.
       wa_final-zcanteen_building      = gv_zcanteen_building.
       wa_final-zlt_room               = gv_zlt_room.
       wa_final-zsite_development      = gv_zsite_development.
       wa_final-zsec_chnge_room        = gv_zsec_chnge_room.
       wa_final-zplant_machinary       = gv_zplant_machinary.
       wa_final-zplant_machinary_ro    = gv_zplant_machinary_ro.
       wa_final-zequipment             = gv_zequipment.
       wa_final-zsolar_equipment       = gv_zsolar_equipment.
       wa_final-ztools_dies_jigs       = gv_ztools_dies_jigs.
       wa_final-zpatterns              = gv_zpatterns.
       wa_final-zelectrical_install    = gv_zelectrical_install.
       wa_final-zfurniture_fitting     = gv_zfurniture_fitting.
       wa_final-zrocks_pallets         = gv_zrocks_pallets.
       wa_final-zoffice_equipment      = gv_zoffice_equipment .
       wa_final-zvehicles_1            = gv_zvehicles_1 .
       wa_final-zcomputers_perpherals  = gv_zcomputers_perpherals .
       wa_final-zcomputer_software     = gv_zcomputer_software.
       wa_final-zasset_under_construct = gv_zasset_under_construct .
       wa_final-ztotal                 = gv_ztotal .


      APPEND wa_final TO gt_final.
      CLEAR : wa_final,
**             gv_zvehicles,
**             gv_zdp_hardware,
**             gv_zasset_construct,
**              gv_zauc_investment,
**              gv_zlow_value_asset,
**              gv_zleased_assets,
**              gv_zobj_of_art,
              gv_zleasehold_improve,
              gv_zland,
             gv_zbuilding,
             gv_zcanteen_building,
             gv_zlt_room,
             gv_zsite_development,
             gv_zsec_chnge_room,
             gv_zplant_machinary,
             gv_zplant_machinary_ro,
             gv_zequipment,
             gv_zsolar_equipment,
             gv_ztools_dies_jigs,
             gv_zpatterns,
             gv_zelectrical_install,
             gv_zfurniture_fitting,
             gv_zrocks_pallets,
             gv_zoffice_equipment,
             gv_zvehicles_1,
             gv_zcomputers_perpherals,
             gv_zcomputer_software,
             gv_zasset_under_construct ,
             gv_ztotal .


***************************************************************
*********************cureent fiscal year data****************************
      "As at FIRST DATE OF FISCAL YEAR


   CONCATENATE '1 April' p_zujhr INTO gv_first_date_current SEPARATED BY ' '.

      CONCATENATE 'As at' gv_first_date_current INTO gv_string3 SEPARATED BY ' '.
   READ TABLE gt_final INTO wa_final INDEX 14.
      wa_final-particulars = gv_string3.


*

          gv_ztotal = gv_ztotal + wa_final-ztotal.
       gv_zleasehold_improve = gv_zleasehold_improve + wa_final-zleasehold_improve.
       gv_zland               = gv_zland + wa_final-zland.
       gv_zbuilding           = gv_zbuilding + wa_final-zbuilding.
       gv_zcanteen_building   = gv_zcanteen_building + wa_final-zcanteen_building.
       gv_zlt_room            = gv_zlt_room + wa_final-zlt_room.
       gv_zsite_development   = gv_zsite_development + wa_final-zsite_development.
       gv_zsec_chnge_room     = gv_zsec_chnge_room  + wa_final-zsec_chnge_room   .
       gv_zplant_machinary    = gv_zplant_machinary + wa_final-zplant_machinary.
       gv_zplant_machinary_ro = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.
       gv_zequipment          = gv_zequipment + wa_final-zequipment.
       gv_zsolar_equipment    =  gv_zsolar_equipment + wa_final-zsolar_equipment.
       gv_ztools_dies_jigs    =  gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.
       gv_zpatterns           =  gv_zpatterns + wa_final-zpatterns.
       gv_zelectrical_install = gv_zelectrical_install + wa_final-zelectrical_install.
       gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.
       gv_zrocks_pallets      = gv_zrocks_pallets + wa_final-zrocks_pallets.
       gv_zoffice_equipment   = gv_zoffice_equipment + wa_final-zoffice_equipment.
       gv_zvehicles_1         = gv_zvehicles_1 + wa_final-zvehicles_1.
       gv_zcomputers_perpherals = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.
       gv_zcomputer_software   =  gv_zcomputer_software + wa_final-zcomputer_software.
       gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.
       gv_ztotal                = gv_ztotal = wa_final-ztotal.







        APPEND wa_final TO gt_final.
        CLEAR : wa_final.
refresh : it_anla ,it_anlc.
*************************************************************************************************
        "Additions
        wa_final-particulars = 'Charge for the year'.

*
refresh : it_anla, it_anlc_charge.
 if p_anlkl is INITIAL.
    SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr
         bukrs = p_bukrs.
*        AND anlkl =  @p_anlkl.
  else.
     SELECT * FROM anla INTO table it_anla
      WHERE "zujhr = p_zujhr
        bukrs = p_bukrs
        AND anlkl = p_anlkl.
  endif.

**LOOP AT it_anla INTO data(wa_anla).
      SELECT * FROM anlc INTO TABLE it_anlc_charge
        FOR ALL ENTRIES IN it_anla
        WHERE bukrs = it_anla-bukrs
          AND anln1 = it_anla-anln1
*          AND anln2 = @it_anla-anln2
          AND gjahr = p_zujhr"it_anla-zujhr
        and afabe = '01'.
*          AND bwsal LIKE '1%'.
*         it_anep1 = it_anep.
*          delete it_anep where bwasl ne '1%'.
*          delete it_anep where not bwasl CP '1*'.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        gv_zleasehold_improve  = gv_zleasehold_improve + wa_final-zleasehold_improve.

        if wa_final-zleasehold_improve lt '0'.
          wa_final-zleasehold_improve = wa_final-zleasehold_improve * -1.
        endif.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zland lt '0'.
          wa_final-zland = wa_final-zland * -1.
        endif.


         gv_zland  = gv_zland + wa_final-zland.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zbuilding lt '0'.
         wa_final-zbuilding = wa_final-zbuilding * -1.
        endif.

        gv_zbuilding  = gv_zbuilding + wa_final-zbuilding.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
        LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zcanteen_building lt '0'.
         wa_final-zcanteen_building = wa_final-zcanteen_building * -1.
        endif.

        gv_zcanteen_building  = gv_zcanteen_building + wa_final-zcanteen_building.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
        LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zlt_room = wa_final-zlt_room + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zlt_room lt '0'.
          wa_final-zlt_room =  wa_final-zlt_room * -1.
        endif.

        gv_zlt_room  = gv_zlt_room + wa_final-zlt_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 ..

            wa_final-zsite_development = wa_final-zsite_development +  wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR :  wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zsite_development lt '0'.
          wa_final-zsite_development =  wa_final-zsite_development * -1.
        endif.

        gv_zsite_development  = gv_zsite_development + wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room +  wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR :  wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zsec_chnge_room lt '0'.
          wa_final-zsec_chnge_room =  wa_final-zsec_chnge_room * -1.
        endif.

        gv_zsec_chnge_room  = gv_zsec_chnge_room + wa_final-zsec_chnge_room.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
            LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2  .

            wa_final-zplant_machinary = wa_final-zplant_machinary +  wa_anlc_charge-nafap.
          ENDLOOP.
          CLEAR :  wa_anlc_charge ,wa_anla.
        ENDLOOP.

          if wa_final-zplant_machinary lt '0'.
          wa_final-zplant_machinary =  wa_final-zplant_machinary * -1.
        endif.

         gv_zplant_machinary  = gv_zplant_machinary + wa_final-zplant_machinary.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
            LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2  .

            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro +  wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR :  wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zplant_machinary_RO lt '0'.
          wa_final-zplant_machinary_ro =  wa_final-zplant_machinary_ro * -1.
        endif.

     gv_zplant_machinary_ro  = gv_zplant_machinary_ro + wa_final-zplant_machinary_ro.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2  .

            wa_final-zequipment = wa_final-zequipment + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zequipment lt '0'.
          wa_final-zequipment =  wa_final-zequipment * -1.
        endif.

        gv_zequipment  = gv_zequipment + wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.


        if wa_final-zsolar_equipment lt '0'.
          wa_final-zsolar_equipment =  wa_final-zsolar_equipment * -1.
        endif.

        gv_zsolar_equipment  = gv_zsolar_equipment + wa_final-zsolar_equipment.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-ztools_dies_jigs lt '0'.
         wa_final-ztools_dies_jigs =  wa_final-ztools_dies_jigs * -1.
        endif.

         gv_ztools_dies_jigs  = gv_ztools_dies_jigs + wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
        LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zpatterns = wa_final-zpatterns + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zpatterns lt '0'.
         wa_final-zpatterns =  wa_final-zpatterns * -1.
        endif.

         gv_zpatterns  = gv_zpatterns + wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zelectrical_install lt '0'.
         wa_final-zelectrical_install =  wa_final-zelectrical_install * -1.
        endif.

          gv_zelectrical_install  = gv_zelectrical_install + wa_final-zelectrical_install.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .


            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zfurniture_fitting lt '0'.
         wa_final-zfurniture_fitting =  wa_final-zfurniture_fitting * -1.
        endif.
        gv_zfurniture_fitting  = gv_zfurniture_fitting + wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

         if wa_final-zrocks_pallets lt '0'.
         wa_final-zrocks_pallets =  wa_final-zrocks_pallets * -1.
        endif.

        gv_zrocks_pallets  = gv_zrocks_pallets + wa_final-zrocks_pallets.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc_charge-nafap .
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zoffice_equipment lt '0'.
         wa_final-zoffice_equipment =  wa_final-zoffice_equipment * -1.
        endif.

            gv_zoffice_equipment  = gv_zoffice_equipment + wa_final-zoffice_equipment.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
         LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc_charge-nafaP .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

          if wa_final-zvehicles_1 lt '0'.
         wa_final-zvehicles_1 =  wa_final-zvehicles_1 * -1.
        endif.


         gv_zvehicles_1  = gv_zvehicles_1 + wa_final-zvehicles_1.


        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc_charge-nafaP .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

          if wa_final-zcomputers_perpherals lt '0'.
         wa_final-zcomputers_perpherals =  wa_final-zcomputers_perpherals * -1.
        endif.

        gv_zcomputers_perpherals  = gv_zcomputers_perpherals + wa_final-zcomputers_perpherals.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc_charge-nafaP .
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zcomputer_software lt '0'.
         wa_final-zcomputer_software =  wa_final-zcomputer_software * -1.
        endif.

        gv_zcomputer_software  = gv_zcomputer_software + wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc_charge-nafaP .
          ENDLOOP.
          CLEAR :wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zasset_under_construct lt '0'.
         wa_final-zasset_under_construct =  wa_final-zasset_under_construct * -1.
        endif.

        gv_zasset_under_construct  = gv_zasset_under_construct + wa_final-zasset_under_construct.

         wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal + wa_final-ztotal.

        APPEND wa_final TO gt_final.
        CLEAR : wa_final.
refresh : it_anep.
*****************************************************************
        "Disposals
        wa_final-particulars = 'Disposals'.



        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1000'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zleasehold_improve = wa_final-zleasehold_improve + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.
        if wa_final-zleasehold_improve lt 0.
          wa_final-zleasehold_improve = wa_final-zleasehold_improve * -1.
        endif.
*
        gv_zleasehold_improve = gv_zleasehold_improve - wa_final-zleasehold_improve.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zland =  wa_final-zland + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav..
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.
         if wa_final-zland lt 0.
          wa_final-zland = wa_final-zland * -1.
        endif.

         gv_zland = gv_zland - wa_final-zland.
*
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1200'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zbuilding =   wa_final-zbuilding + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zbuilding lt 0.
          wa_final-zbuilding = wa_final-zbuilding * -1.
        endif.
*
*
         gv_zbuilding = gv_zbuilding - wa_final-zbuilding.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1210'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcanteen_building =   wa_final-zcanteen_building + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zcanteen_building lt 0.
          wa_final-zcanteen_building = wa_final-zcanteen_building * -1.
        endif.

         gv_zcanteen_building = gv_zcanteen_building - wa_final-zcanteen_building.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1220'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zlt_room = wa_final-zlt_room + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anep ,wa_anla.
        ENDLOOP.

        if wa_final-zlt_room lt 0.
          wa_final-zlt_room = wa_final-zlt_room * -1.
        endif.

        gv_zlt_room = gv_zlt_room - wa_final-zlt_room.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1230'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsite_development = wa_final-zsite_development + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zsite_development lt 0.
          wa_final-zsite_development = wa_final-zsite_development * -1.
        endif.
*
         gv_zsite_development = gv_zsite_development - wa_final-zsite_development.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1240'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 ..

            wa_final-zsec_chnge_room = wa_final-zsec_chnge_room + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.
          if wa_final-zsec_chnge_room lt 0.
          wa_final-zsec_chnge_room = wa_final-zsec_chnge_room * -1.
        endif.

         gv_zsec_chnge_room = gv_zsec_chnge_room - wa_final-zsec_chnge_room.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1300'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zplant_machinary = wa_final-zplant_machinary + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

         if wa_final-zplant_machinary lt 0.
          wa_final-zplant_machinary = wa_final-zplant_machinary * -1.
        endif.

        gv_zplant_machinary = gv_zplant_machinary - wa_final-zplant_machinary.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1400'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
*
            wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zplant_machinary_ro lt 0.
          wa_final-zplant_machinary_ro = wa_final-zplant_machinary_ro * -1.
        endif.

        gv_zplant_machinary_ro = gv_zplant_machinary_ro - wa_final-zplant_machinary_ro.
*

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1500'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zequipment = wa_final-zequipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zequipment lt 0.
          wa_final-zequipment = wa_final-zequipment * -1.
        endif.

        gv_zequipment = gv_zequipment - wa_final-zequipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1510'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zsolar_equipment = wa_final-zsolar_equipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

         if wa_final-zsolar_equipment lt 0.
          wa_final-zsolar_equipment = wa_final-zsolar_equipment * -1.
        endif.

         gv_zsolar_equipment = gv_zsolar_equipment - wa_final-zsolar_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1600'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-ztools_dies_jigs lt 0.
          wa_final-ztools_dies_jigs = wa_final-ztools_dies_jigs * -1.
        endif.
*
        gv_ztools_dies_jigs = gv_ztools_dies_jigs - wa_final-ztools_dies_jigs.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1700'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zpatterns = wa_final-zpatterns + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.
        if wa_final-zpatterns lt 0.
          wa_final-zpatterns = wa_final-zpatterns * -1.
        endif.

        gv_zpatterns = gv_zpatterns - wa_final-zpatterns.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1800'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zelectrical_install  = wa_final-zelectrical_install + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zelectrical_install lt 0.
          wa_final-zelectrical_install = wa_final-zelectrical_install * -1.
        endif.

        gv_zelectrical_install = gv_zelectrical_install - wa_final-zelectrical_install.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D1900'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zfurniture_fitting  = wa_final-zfurniture_fitting + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zfurniture_fitting lt 0.
          wa_final-zfurniture_fitting = wa_final-zfurniture_fitting * -1.
        endif.

         gv_zfurniture_fitting = gv_zfurniture_fitting - wa_final-zfurniture_fitting.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2000'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zrocks_pallets  = wa_final-zrocks_pallets + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

        if wa_final-zrocks_pallets lt 0.
          wa_final-zrocks_pallets = wa_final-zrocks_pallets * -1.
        endif.

        gv_zrocks_pallets = gv_zrocks_pallets - wa_final-zrocks_pallets.
*
        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2100'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 ..

            wa_final-zoffice_equipment = wa_final-zoffice_equipment + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zoffice_equipment lt 0.
          wa_final-zoffice_equipment = wa_final-zoffice_equipment * -1.
        endif.


        gv_zoffice_equipment = gv_zoffice_equipment - wa_final-zoffice_equipment.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2200'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zvehicles_1 = wa_final-zvehicles_1 + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.
         if wa_final-zvehicles_1 lt 0.
          wa_final-zvehicles_1 = wa_final-zvehicles_1 * -1.
        endif.

        gv_zvehicles_1 = gv_zvehicles_1 - wa_final-zvehicles_1.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2300'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zcomputers_perpherals = wa_final-zcomputers_perpherals + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zcomputers_perpherals  lt 0.
          wa_final-zcomputers_perpherals  = wa_final-zcomputers_perpherals  * -1.
        endif.

         gv_zcomputers_perpherals = gv_zcomputers_perpherals - wa_final-zcomputers_perpherals.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2400'.
          LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .
            wa_final-zcomputer_software = wa_final-zcomputer_software + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge,wa_anla.
        ENDLOOP.

        if wa_final-zcomputer_software lt 0.
          wa_final-zcomputer_software  = wa_final-zcomputer_software  * -1.
        endif.

        gv_zcomputer_software = gv_zcomputer_software - wa_final-zcomputer_software.

        LOOP AT it_anla INTO wa_anla WHERE anlkl = 'D2500'.
           LOOP AT it_anlc_charge INTO wa_anlc_charge WHERE anln1 = wa_anla-anln1
                                              AND anln2 = wa_anla-anln2 .

            wa_final-zasset_under_construct = wa_final-zasset_under_construct + wa_anlc_charge-nafaV + wa_anlc_charge-nafaL + wa_anlc_charge-aafav.
          ENDLOOP.
          CLEAR : wa_anlc_charge ,wa_anla.
        ENDLOOP.

         if wa_final-zasset_under_construct lt 0.
          wa_final-zasset_under_construct  = wa_final-zasset_under_construct  * -1.
        endif.

        gv_zasset_under_construct = gv_zasset_under_construct - wa_final-zasset_under_construct.

         wa_final-ztotal = wa_final-ztotal + (  wa_final-zleasehold_improve + wa_final-zland + wa_final-zbuilding + wa_final-zcanteen_building +
                        wa_final-zlt_room + wa_final-zsite_development + wa_final-zsec_chnge_room + wa_final-zplant_machinary +
                        wa_final-zplant_machinary_ro + wa_final-zequipment + wa_final-zsolar_equipment + wa_final-ztools_dies_jigs +
                        wa_final-zpatterns + wa_final-zelectrical_install + wa_final-zfurniture_fitting + wa_final-zrocks_pallets +
                        wa_final-zoffice_equipment + wa_final-zvehicles_1 + wa_final-zcomputers_perpherals + wa_final-zcomputer_software
                        + wa_final-zasset_under_construct ).

        gv_ztotal = gv_ztotal - wa_final-ztotal.

        APPEND wa_final TO gt_final.
        CLEAR : wa_final.

        refresh : it_anep1 ,it_anla.

*********************************************************************
*          DATA :p_zujhr2 TYPE t009b-bdatj.
        p_zujhr2 = p_zujhr + 1 .
         CONCATENATE '31 March' p_zujhr2 INTO gv_last_date_current SEPARATED BY ' '.

        CONCATENATE 'As at' gv_last_date_current INTO gv_string4 SEPARATED BY ' '.
        wa_final-particulars = gv_string4.



*       wa_final-zreal_estate           = gv_zreal_estate.
*       wa_final-zbuildings             = gv_zbuildings.
*       wa_final-zmachinery             = gv_zmachinery.
*       wa_final-zfix_fitting           = gv_zfix_fitting.
*       wa_final-zvehicles              = gv_zvehicles.
*       wa_final-zdp_hardware           = gv_zdp_hardware.
*       wa_final-zasset_construct       = gv_zasset_construct.
*       wa_final-zauc_investment        = gv_zauc_investment.
*       wa_final-zlow_value_asset       = gv_zlow_value_asset.
*       wa_final-zleased_assets         = gv_zleased_assets.
*       wa_final-zobj_of_art            = gv_zobj_of_art.
       wa_final-zleasehold_improve     = gv_zleasehold_improve.
       wa_final-zland                  = gv_zland.
       wa_final-zbuilding              = gv_zbuilding.
       wa_final-zcanteen_building      = gv_zcanteen_building.
       wa_final-zlt_room               = gv_zlt_room.
       wa_final-zsite_development      = gv_zsite_development.
       wa_final-zsec_chnge_room        = gv_zsec_chnge_room.
       wa_final-zplant_machinary       = gv_zplant_machinary.
       wa_final-zplant_machinary_ro    = gv_zplant_machinary_ro.
       wa_final-zequipment             = gv_zequipment.
       wa_final-zsolar_equipment       = gv_zsolar_equipment.
       wa_final-ztools_dies_jigs       = gv_ztools_dies_jigs.
       wa_final-zpatterns              = gv_zpatterns.
       wa_final-zelectrical_install    = gv_zelectrical_install.
       wa_final-zfurniture_fitting     = gv_zfurniture_fitting.
       wa_final-zrocks_pallets         = gv_zrocks_pallets.
       wa_final-zoffice_equipment      = gv_zoffice_equipment .
       wa_final-zvehicles_1            = gv_zvehicles_1 .
       wa_final-zcomputers_perpherals  = gv_zcomputers_perpherals .
       wa_final-zcomputer_software     = gv_zcomputer_software.
       wa_final-zasset_under_construct = gv_zasset_under_construct .
       wa_final-ztotal                 = gv_ztotal.





        APPEND wa_final TO gt_final.
        CLEAR : wa_final,
*             gv_zvehicles,
*             gv_zdp_hardware,
*             gv_zasset_construct,
*              gv_zauc_investment,
*              gv_zlow_value_asset,
*              gv_zleased_assets,
*              gv_zobj_of_art,
              gv_zleasehold_improve,
              gv_zland,
             gv_zbuilding,
             gv_zcanteen_building,
             gv_zlt_room,
             gv_zsite_development,
             gv_zsec_chnge_room,
             gv_zplant_machinary,
             gv_zplant_machinary_ro,
             gv_zequipment,
             gv_zsolar_equipment,
             gv_ztools_dies_jigs,
             gv_zpatterns,
             gv_zelectrical_install,
             gv_zfurniture_fitting,
             gv_zrocks_pallets,
             gv_zoffice_equipment,
             gv_zvehicles_1,
             gv_zcomputers_perpherals,
             gv_zcomputer_software,
             gv_zasset_under_construct ,
             gv_ztotal.
*********************************************************************
***********************added by jyoti on 20.05.2025************************
   "Net Block
        wa_final-particulars =  'Net Block'.
   APPEND wa_final TO gt_final.
        CLEAR : wa_final.

   READ TABLE gt_final INTO data(wa_final_5) INDEX 5.
        wa_final-particulars = wa_final_5-particulars.

   READ TABLE gt_final INTO data(wa_final_14) INDEX 14.

   wa_final-zleasehold_improve     = wa_final_5-zleasehold_improve     - wa_final_14-zleasehold_improve   .
   wa_final-zland                  = wa_final_5-zland                  - wa_final_14-zland                .
   wa_final-zbuilding              = wa_final_5-zbuilding              - wa_final_14-zbuilding            .
   wa_final-zcanteen_building      = wa_final_5-zcanteen_building      - wa_final_14-zcanteen_building    .
   wa_final-zlt_room               = wa_final_5-zlt_room               - wa_final_14-zlt_room             .
   wa_final-zsite_development      = wa_final_5-zsite_development      - wa_final_14-zsite_development    .
   wa_final-zsec_chnge_room        = wa_final_5-zsec_chnge_room        - wa_final_14-zsec_chnge_room      .
   wa_final-zplant_machinary       = wa_final_5-zplant_machinary       - wa_final_14-zplant_machinary     .
   wa_final-zplant_machinary_ro    = wa_final_5-zplant_machinary_ro    - wa_final_14-zplant_machinary_ro  .
   wa_final-zequipment             = wa_final_5-zequipment             - wa_final_14-zequipment           .
   wa_final-zsolar_equipment       = wa_final_5-zsolar_equipment       - wa_final_14-zsolar_equipment     .
   wa_final-ztools_dies_jigs       = wa_final_5-ztools_dies_jigs       - wa_final_14-ztools_dies_jigs     .
   wa_final-zpatterns              = wa_final_5-zpatterns              - wa_final_14-zpatterns            .
   wa_final-zelectrical_install    = wa_final_5-zelectrical_install    - wa_final_14-zelectrical_install  .
   wa_final-zfurniture_fitting     = wa_final_5-zfurniture_fitting     - wa_final_14-zfurniture_fitting   .
   wa_final-zrocks_pallets         = wa_final_5-zrocks_pallets         - wa_final_14-zrocks_pallets       .
   wa_final-zoffice_equipment      = wa_final_5-zoffice_equipment      - wa_final_14-zoffice_equipment    .
   wa_final-zvehicles_1            = wa_final_5-zvehicles_1            - wa_final_14-zvehicles_1          .
   wa_final-zcomputers_perpherals  = wa_final_5-zcomputers_perpherals  - wa_final_14-zcomputers_perpherals.
   wa_final-zcomputer_software     = wa_final_5-zcomputer_software     - wa_final_14-zcomputer_software   .
   wa_final-zasset_under_construct = wa_final_5-zasset_under_construct - wa_final_14-zasset_under_construct.
   wa_final-ztotal                 = wa_final_5-ztotal                 - wa_final_14-ztotal               .

   APPEND wa_final TO gt_final.
        CLEAR : wa_final,wa_final_5, wa_final_14.
******************************************************************************
         READ TABLE gt_final INTO data(wa_final_9) INDEX 9.
        wa_final-particulars = wa_final_9-particulars.

   READ TABLE gt_final INTO data(wa_final_18) INDEX 18.

   wa_final-zleasehold_improve     = wa_final_9-zleasehold_improve     - wa_final_18-zleasehold_improve   .
   wa_final-zland                  = wa_final_9-zland                  - wa_final_18-zland                .
   wa_final-zbuilding              = wa_final_9-zbuilding              - wa_final_18-zbuilding            .
   wa_final-zcanteen_building      = wa_final_9-zcanteen_building      - wa_final_18-zcanteen_building    .
   wa_final-zlt_room               = wa_final_9-zlt_room               - wa_final_18-zlt_room             .
   wa_final-zsite_development      = wa_final_9-zsite_development      - wa_final_18-zsite_development    .
   wa_final-zsec_chnge_room        = wa_final_9-zsec_chnge_room        - wa_final_18-zsec_chnge_room      .
   wa_final-zplant_machinary       = wa_final_9-zplant_machinary       - wa_final_18-zplant_machinary     .
   wa_final-zplant_machinary_ro    = wa_final_9-zplant_machinary_ro    - wa_final_18-zplant_machinary_ro  .
   wa_final-zequipment             = wa_final_9-zequipment             - wa_final_18-zequipment           .
   wa_final-zsolar_equipment       = wa_final_9-zsolar_equipment       - wa_final_18-zsolar_equipment     .
   wa_final-ztools_dies_jigs       = wa_final_9-ztools_dies_jigs       - wa_final_18-ztools_dies_jigs     .
   wa_final-zpatterns              = wa_final_9-zpatterns              - wa_final_18-zpatterns            .
   wa_final-zelectrical_install    = wa_final_9-zelectrical_install    - wa_final_18-zelectrical_install  .
   wa_final-zfurniture_fitting     = wa_final_9-zfurniture_fitting     - wa_final_18-zfurniture_fitting   .
   wa_final-zrocks_pallets         = wa_final_9-zrocks_pallets         - wa_final_18-zrocks_pallets       .
   wa_final-zoffice_equipment      = wa_final_9-zoffice_equipment      - wa_final_18-zoffice_equipment    .
   wa_final-zvehicles_1            = wa_final_9-zvehicles_1            - wa_final_18-zvehicles_1          .
   wa_final-zcomputers_perpherals  = wa_final_9-zcomputers_perpherals  - wa_final_18-zcomputers_perpherals.
   wa_final-zcomputer_software     = wa_final_9-zcomputer_software     - wa_final_18-zcomputer_software   .
   wa_final-zasset_under_construct = wa_final_9-zasset_under_construct - wa_final_18-zasset_under_construct.
   wa_final-ztotal                 = wa_final_9-ztotal                 - wa_final_18-ztotal               .

   APPEND wa_final TO gt_final.
        CLEAR : wa_final,wa_final_9, wa_final_18.

******************************************************************************

         me->set_bold( ).
        me->set_color( ).
        me->alv_factory( ).
        IF p_down EQ 'X'.
      ME->DOWNLOAD( ).
        ENDIF.

      ENDMETHOD.
      METHOD alv_factory.
        DATA: toolbar TYPE REF TO cl_salv_functions_list .
        TRY.
            CALL METHOD cl_salv_table=>factory(
              IMPORTING
                r_salv_table = DATA(go_alv)
              CHANGING
                t_table      = gt_final ).
          CATCH cx_salv_msg.
        ENDTRY.

        toolbar = go_alv->get_functions( ) .
        toolbar->set_all(
              value  = if_salv_c_bool_sap=>true
               ).

        go_cols = go_alv->get_columns( ).
        go_cols->set_optimize( abap_true ).

.

        DATA : lo_column TYPE REF TO cl_salv_column_table.


        TRY.
            lo_column ?= go_cols->get_column( 'PARTICULARS' ).
            lo_column->set_alignment( if_salv_c_alignment=>right ).


          CATCH cx_salv_not_found.
        ENDTRY.

        TRY.
            lo_column  ?= go_cols->get_column( 'ZLEASEHOLD_IMPROVE' ).

             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

         TRY.
            lo_column  ?= go_cols->get_column( 'ZLAND' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.


         TRY.
            lo_column  ?= go_cols->get_column( 'ZASSET_UNDER_CONSTRUCT' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

         TRY.
            lo_column  ?= go_cols->get_column( 'ZBUILDING' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

         TRY.
            lo_column  ?= go_cols->get_column( 'ZCANTEEN_BUILDING' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.


         TRY.
            lo_column  ?= go_cols->get_column( 'ZCOMPUTER_SOFTWARE' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.


         TRY.
            lo_column  ?= go_cols->get_column( 'ZCOMPUTERS_PERPHERALS' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.


         TRY.
            lo_column  ?= go_cols->get_column( 'ZELECTRICAL_INSTALL' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

         TRY.
            lo_column  ?= go_cols->get_column( 'ZEQUIPMENT' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

          TRY.
            lo_column  ?= go_cols->get_column( 'ZFURNITURE_FITTING' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

          TRY.
            lo_column  ?= go_cols->get_column( 'ZLT_ROOM' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.
          TRY.
            lo_column  ?= go_cols->get_column( 'ZOFFICE_EQUIPMENT' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.
          TRY.
            lo_column  ?= go_cols->get_column( 'ZPATTERNS' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.
          TRY.
            lo_column  ?= go_cols->get_column( 'ZPLANT_MACHINARY' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

          TRY.
            lo_column  ?= go_cols->get_column( 'ZPLANT_MACHINARY_RO' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.
          TRY.
            lo_column  ?= go_cols->get_column( 'ZROCKS_PALLETS' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

          TRY.
            lo_column  ?= go_cols->get_column( 'ZSEC_CHNGE_ROOM' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

          TRY.
            lo_column  ?= go_cols->get_column( 'ZSITE_DEVELOPMENT' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

           TRY.
            lo_column  ?= go_cols->get_column( 'ZSOLAR_EQUIPMENT' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.


           TRY.
            lo_column  ?= go_cols->get_column( 'ZTOOLS_DIES_JIGS' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

         TRY.
            lo_column  ?= go_cols->get_column( 'ZVEHICLES_1' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.



          TRY.
            lo_column  ?= go_cols->get_column( 'ZTOTAL' ).
             lo_column->set_zero( abap_false ). " abap_false = hide zeros

    " Handle invalid column name
     CATCH cx_salv_not_found.
        ENDTRY.

*    setting color column
        go_cols->set_color_column( 'COLOR' ).

        go_layout = go_alv->get_layout( ).
        go_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
        gs_key-report = sy-repid.
        go_layout->set_key( gs_key ).
        go_layout->set_default( abap_true ).
        go_tool = go_alv->get_functions( ).
        go_tool->set_all( value = if_salv_c_bool_sap=>true ).


        CALL METHOD me->top_of_page1
          CHANGING
            co_alv = go_alv.

        go_alv->display( ).

      ENDMETHOD.
      METHOD top_of_page1.
        DATA: lo_header  TYPE REF TO cl_salv_form_layout_grid,
              lo_h_label TYPE REF TO cl_salv_form_label,
              lo_h_flow  TYPE REF TO cl_salv_form_layout_flow,
              lv_string  TYPE string,
              lv_from    TYPE char10,
              lv_to      TYPE char10.
        CONSTANTS :  gc_dot    TYPE char01 VALUE '.'.


        CREATE OBJECT lo_header.

        lo_header->create_header_information( row = 1 column = 1 text = 'Asset Schedules Report' tooltip = 'Asset Schedules Report'  ).

        "Add blank row
        lo_header->add_row( ).
        lo_header->add_row( ).
        lo_header->add_row( ).
        lo_header->add_row( ).

        " Selection - Date
*    IF S_BUDAT IS NOT INITIAL.
        lo_h_flow = lo_header->create_flow( row     = 3
                                            column  = 1 ).

*      CLEAR : LV_STRING,LV_FROM,LV_TO.
*      LV_FROM = S_BUDAT-LOW+6(2) && GC_DOT && S_BUDAT-LOW+4(2) && GC_DOT &&  S_BUDAT-LOW+0(4).
*      LV_TO   = S_BUDAT-HIGH+6(2) && GC_DOT && S_BUDAT-HIGH+4(2) && GC_DOT &&  S_BUDAT-HIGH+0(4).

*      CONCATENATE TEXT-005  SPACE LV_FROM TEXT-006 LV_TO INTO LV_STRING SEPARATED BY SPACE.
        lo_h_flow = lo_header->create_flow( row     = 3
                                            column  = 1 ).
        lo_h_flow->create_text( EXPORTING text = lv_string ).
*    ENDIF.

        co_alv->set_top_of_list( lo_header ).

        co_alv->set_top_of_list_print( lo_header ).

      ENDMETHOD.
   METHOD set_bold.
*     DATA: lt_style TYPE lvc_t_styl,
*      ls_style TYPE lvc_s_styl,
*      lo_row_settings  TYPE REF TO cl_salv_row_settings.
*
*     FIELD-SYMBOLS: <ls_data> TYPE  struct2.

 " Apply bold style to the first row

* Get row settings
*    lo_row_settings = go_alv->get_row_settings( ).
*
** Mark the first row as emphasized (bold)
*     lo_row_settings->set_emphasized( row_id = 1 ).


*  read TABLE gt_final ASSIGNING  <ls_data> INDEX 1.
*      IF sy-subrc = 0.
*      " Set bold style for first cell
*      ls_style-fieldname = 'PARTICULARS' .
*     ls_style-style = cl_gui_alv_grid=>mc_style_emphasize.
**    APPEND ls_style TO lt_style.
*
*    READ TABLE gt_final INDEX 1.
*    it_data-style = lt_style.

* Make first row bold


   endmethod.
      METHOD set_color.
* Set color to a particular COLUMN based on your condition.
*        FIELD-SYMBOLS: <lwa_final> TYPE struct2.
        DATA: ls_color             TYPE lvc_s_scol.



*     <LWA_FINAL>-SR_NO = 'VAT on FOC :'.
        ls_color-fname = 'PARTICULARS' .
        ls_color-color-col = 2.
        ls_color-color-int = 0.
        ls_color-color-inv = 0.
*        APPEND ls_color TO <lwa_final>-color.
*    ENDLOOP.
      ENDMETHOD.

METHOD DOWNLOAD .
    DATA: L_FIELD_SEPERATOR.

*    **********************ADDED BY MA REFRESHABLE DATE AND TIME 20.02.2024 **************************
    DATA : LV_REF      TYPE CHAR11,
           LV_REF_TIME TYPE CHAR15.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LV_REF.

    CONCATENATE LV_REF+0(2) LV_REF+2(3) LV_REF+5(4)
                    INTO LV_REF SEPARATED BY '-'.

    LV_REF_TIME = SY-UZEIT.
    CONCATENATE LV_REF_TIME+0(2) ':' LV_REF_TIME+2(2)  INTO LV_REF_TIME.

*************************************************************************************


    LOOP AT GT_FINAL INTO WA_FINAL.
      MOVE-CORRESPONDING WA_FINAL TO WA_DOWN.
      WA_DOWN-REF =  LV_REF .
      WA_DOWN-REF_TIME = LV_REF_TIME.
      APPEND WA_DOWN TO IT_DOWN.
    ENDLOOP.

    CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
      TABLES
        I_TAB_SAP_DATA       = IT_DOWN
      CHANGING
        I_TAB_CONVERTED_DATA = IT_CSV
      EXCEPTIONS
        CONVERSION_FAILED    = 1
        OTHERS               = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.

    CONCATENATE  'Particulars'
*                 'Real Estae and siilar rights'
*                 'Buildings'
*                 'Machinery'
*                 'Fixtures and Fittings'
*                 'Vehicles'
*                 'DP/Hardware'
*                 'Assets Under construction'
*                 'AuC AS Investment measure'
*                 'Low-value Assets'
*                 'Leased Assets'
*                 'Objects of Art'
                 'Leasehold Improvement'
                 'Land'
                 'Building'
                 'Canteen Building'
                 'L.T. Room'
                 'Site Development'
                 'Security & Changing Room'
                 'Plant & Machinery'
                 'Plant & Machinery(R.O.Plant'
                 'Equipment'
                 'Solar Equipment'
                 'Tools, Dies & Jigs'
                 'Patterns'
                 'Electrical Installations'
                 'Furnitures and Fittings'
                 'Rocks & Pallets'
                 'Office Equipment'
                 'Vehicles'
                 'Computer & Peripherals'
                 'Computer software'
                 'Assets under construction'
                 'Refreshable Date'
                 'Refreshable Time'
    INTO HD_CSV SEPARATED BY L_FIELD_SEPERATOR.

    LV_FILE = 'ZASSET_SCHEDULE.TXT'.

    CONCATENATE P_FOLDER '/'  LV_FILE INTO LV_FULLFILE.

    WRITE: / 'Asset Schedule Report Download started on', SY-DATUM, 'at', SY-UZEIT.
    OPEN DATASET LV_FULLFILE
      FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF SY-SUBRC = 0.
      DATA LV_STRING_2453 TYPE STRING.
    DATA LV_CRLF_2453 TYPE STRING.
    LV_CRLF_2453 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_2453 = HD_CSV.
*      TRANSFER HD_CSV TO LV_FULLFILE.
      LOOP AT IT_CSV INTO WA_CSV.
         CONCATENATE LV_STRING_2453 LV_CRLF_2453 WA_CSV INTO LV_STRING_2453.
      CLEAR: WA_CSV.
*        IF SY-SUBRC = 0.
*          TRANSFER WA_CSV TO LV_FULLFILE.
*        ENDIF.
      ENDLOOP.
      TRANSFER LV_STRING_2453 TO LV_FULLFILE.
*      CLOSE DATASET LV_FULLFILE.
      CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
      MESSAGE LV_MSG TYPE 'S'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
