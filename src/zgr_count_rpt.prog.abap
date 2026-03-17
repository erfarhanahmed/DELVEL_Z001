*&---------------------------------------------------------------------*
*& Report ZGR_COUNT_RPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGR_COUNT_RPT1.
type-pools slis.
TABLES: MKPF, MSEG, ZLOC_MAP,matdoc.


types :begin of ty_final,
       werks type char30,
       shirwal type i,
       kapur type i,
       END OF ty_final.


types :begin of ty_final1,
       werks type mseg-budat_mkpf,
       shirwal type i,
       kapur type i,
       END OF ty_final1.
   types :BEGIN OF ty_year,
          werks type char10,
          jan type i,
          feb type i,
          mar type i,
          april type i,
          may type i,
          jun type i,
          july type i,
          aug type i,
          sept type i,
          oct type i,
          Nov type i,
          Dec type i,
          total TYPE i,
          end of ty_year.

          TYPES: BEGIN OF ty_grn,
         mblnr      TYPE mseg-mblnr,
         mjahr      TYPE mseg-mjahr,
         zeile      TYPE mseg-zeile,
         ebeln      TYPE mseg-ebeln,
         ebelp      TYPE mseg-ebelp,
         matnr      TYPE mseg-matnr,
         werks      TYPE mseg-werks,

         lgort      TYPE mseg-lgort,
         bwart      TYPE mseg-bwart,
         meins      TYPE mseg-meins,
         bukrs      TYPE mseg-bukrs,
         budat_mkpf TYPE mseg-budat_mkpf,
         pur_ebeln  TYPE ekko-ebeln,
         bsart      TYPE ekko-bsart,
         po_matnr   TYPE ekpo-matnr,
            po_lgort type ekpo-lgort,
       END OF ty_grn.

DATA: lt_grn TYPE TABLE OF ty_grn.

DATA :
      lt_final type STANDARD TABLE OF ty_final,
      lt_final1 type STANDARD TABLE OF ty_final1,
       ls_final type ty_final,
       ls_final1 type ty_final1,
       lt_mseg type STANDARD TABLE OF ty_grn,
       lt_mseg4 type STANDARD TABLE OF ty_grn,
       lt_ms type STANDARD TABLE OF ty_grn,
       lt_ekko type STANDARD TABLE OF ekko.

DATA :lt_year type STANDARD TABLE OF ty_year,
      ls_year type ty_year.
data:lv_count1 type i.
data:lv_count type i.
DATA:lv_low type char8,
     lv_high type char8.
data:
      ls_fcat type slis_fieldcat_alv,
      ls_fcat1 type slis_fieldcat_alv,
      ls_fcat2 type slis_fieldcat_alv,
        lt_fcat type STANDARD TABLE OF slis_fieldcat_alv,
        lt_fcat1 type STANDARD TABLE OF slis_fieldcat_alv,
        lt_fcat2 type STANDARD TABLE OF slis_fieldcat_alv.
SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: P_BUKRS  TYPE MSEG-BUKRS OBLIGATORY ,
              P_WERKS TYPE MSEG-WERKS OBLIGATORY.
  SELECT-OPTIONS: S_gjahr FOR MSEG-GJAHR no INTERVALS no-EXTENSION.
SELECTION-SCREEN: END OF BLOCK B1.




START-OF-SELECTION.
PERFORM get_data.
PERFORM dis_data.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  data:lv_kapur type i,
        lv_shirwal type i.
  data:lt_strg_loc_range TYPE RANGE OF zloc_map-strg_loc.
  data:lt_lfbnr TYPE RANGE OF mseg-lfbnr.


refresh lt_final.
SELECT * from zloc_map INTO TABLE @DATA(lt_zloc).

*LOOP AT lt_zloc ASSIGNING FIELD-SYMBOL(<fs_zloc>).
*  APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_zloc>-strg_loc ) TO lt_strg_loc_range.
*ENDLOOP.
*DATA(lv_last_gjahr) TYPE mseg-gjahr.

READ TABLE s_gjahr INTO DATA(ls_gjahr) INDEX lines( s_gjahr ).
IF sy-subrc = 0.
  data(lv_last_gjahr) = ls_gjahr-low.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_last_gjahr + 1 ) TO s_gjahr.
*  CLEAR lv_last_gjahr.
ENDIF.

SELECT 'I' AS SIGN , 'EQ' AS OPTION, strg_loc as low from zloc_map
         INTO TABLE @lt_strg_loc_range.
SORT lt_strg_loc_range BY low.
DELETE ADJACENT DUPLICATES FROM lt_strg_loc_range COMPARING low.
  if lt_zloc is not INITIAL.

*    SELECT m~mblnr,
*       m~mjahr,
*       m~zeile,
*       m~ebeln,
*       m~ebelp,
*       m~matnr,
*       m~werks,
*       m~lgort,
*       p~lgort as po_lgort,
*       m~bwart,
*       m~meins,
*       m~bukrs,
*       m~budat as budat_mkpf,
*       e~ebeln   AS pur_ebeln,
*       e~bsart,
*       p~matnr   AS po_matnr
*  FROM matdoc AS m
*  INNER join  ekko AS e
*    ON e~ebeln = m~ebeln
*  inner JOIN ekpo AS p
*    ON p~ebeln = m~ebeln
**   AND p~ebelp = m~ebelp
*
*  WHERE m~mjahr in @s_gjahr
*    AND m~bukrs = @p_bukrs
*    AND m~werks = @p_werks
*    AND m~bwart = '101'
*    AND m~ebeln IS NOT INITIAL
*    AND e~bsart <> 'FO'
**    and m~sobkz = ' '
*    and M~cancelled ne 'X'
**    AND m~lgort IN @lt_strg_loc_range
*      INTO TABLE @lt_mseg.


    SELECT m~mblnr,
       m~mjahr,
       m~zeile,
       m~ebeln,
       m~ebelp,
       m~matnr,
       m~werks,
        CASE
      WHEN m~lgort IS NOT INITIAL THEN m~lgort
      ELSE p~lgort
    END AS lgort,
       m~bwart,
       m~meins,
       m~bukrs,
       m~budat as budat_mkpf,
       e~ebeln   AS pur_ebeln,
       e~bsart,
       p~matnr   AS po_matnr,
       p~lgort as po_lgort
  FROM ekko AS e
  INNER join  ekpo AS p
    ON e~ebeln = p~ebeln
  inner JOIN matdoc AS m
    ON p~ebeln = m~ebeln
*   AND p~ebelp = m~ebelp

  WHERE m~mjahr in @s_gjahr
    AND e~bukrs = @p_bukrs
    AND m~werks = @p_werks
    AND m~bwart = '101'
    AND m~ebeln IS NOT INITIAL
    AND e~bsart <> 'FO'
*    and m~sobkz = ' '
    and M~cancelled ne 'X'
*    AND m~lgort IN @lt_strg_loc_range
      INTO TABLE @lt_mseg.



  sort lt_mseg by ebeln ebelp mblnr zeile ASCENDING.
  sort lt_mseg by  mjahr mblnr  zeile ASCENDING.
DElete ADJACENT DUPLICATES FROM lt_mseg COMPARING   mblnr .
*SELECT * from mseg INTO TABLE @lt_mseg
*  FOR ALL ENTRIES IN @lt_zloc
*WHERE MJAHR in @s_gjahr and bukrs = @p_bukrs and werks = @p_werks and bwart = '101' and lgort = @lt_zloc-strg_loc and ebeln ne ' '..
*  delete lt_mseg WHERE lgort is INITIAL.
*  sort lt_mseg by mblnr mjahr budat_mkpf.
**  SELECT * from mseg INTO TABLE @DATA(lt_mseg1)
**WHERE MJAHR in @s_gjahr and bukrs = @p_bukrs and werks = @p_werks and bwart = '102'.
*  SELECT
*    a~ebeln,
*    a~bsart,
*    b~matnr
*  FROM ekko AS a
*  LEFT OUTER JOIN ekpo AS b
*    ON a~ebeln = b~ebeln
*  FOR ALL ENTRIES IN @lt_mseg
*  WHERE a~ebeln = @lt_mseg-ebeln and bsart ne 'FO'
*  INTO TABLE @lt_ekko.
*
*SELECT * from ZI_MSEG_COUNT INTO TABLE @lt_mseg
*SELECT * from ZIMSEGCOUNT INTO TABLE @lt_mseg
*  FOR ALL ENTRIES IN @lt_zloc
*  WHERE  MJAHR in @s_gjahr and bukrs = @p_bukrs and werks = @p_werks and bwart = '101'
*  and lgort = @lt_zloc-strg_loc and ebeln ne ' ' and bsart ne 'FO'..
*
*  SELECT 'I' AS SIGN , 'EQ' AS OPTION, lfbnr as low
*  from mseg  WHERE lfbnr in ( select mblnr from @lt_mseg as a ) and bwart = '102' INTO TABLE @lt_lfbnr.
*    sort lt_lfbnr by low ASCENDING.
*  DELETE ADJACENT DUPLICATES FROM lt_lfbnr COMPARING low.
sort lt_mseg by mblnr mjahr budat_mkpf.
delete lt_mseg WHERE bsart = 'ZAST' and matnr is INITIAL.
*delete lt_mseg WHERE mblnr   in lt_lfbnr.
    DATA(lt_mseg1)    = lt_mseg.
*    DATA(lt_mseg1)    = lt_mseg.
    sort lt_mseg1 by mjahr .
   delete ADJACENT DUPLICATES FROM lt_mseg1 COMPARING mjahr .
*   DELETE lt_mseg1 WHERE mjahr = lv_last_year.
*   lt_mseg1
   DESCRIBE TABLE lt_mseg1 LINES DATA(line).
*   READ TABLE lt_mseg1 INTO DATA(ls_mseg1) INDEX line.
   delete lt_mseg1 WHERE mjahr = lv_last_gjahr + 1.

ENDIF.

   LOOP AT lt_mseg1 ASSIGNING FIELD-SYMBOL(<fs>) GROUP BY ( key1 = <fs>-mjahr ).
     loop at GROUP <fs> ASSIGNING FIELD-SYMBOL(<fs1>).
*       ls_final-werks = <fs1>-budat_mkpf+0(4).

       data(lv_date) = <fs1>-budat_mkpf+0(4) + 1.
       ls_final-werks = |April{ <fs>-budat_mkpf(4) } to March{ lv_date }|.
    CONDENSE ls_final-werks.
       lv_low = |{ <fs1>-budat_mkpf(4) }0401|.
       lv_high = |{ lv_date }0331|.
     SELECT COUNT( * ) from @lt_mseg as a
*      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'KAPURHOL' ) and mjahr = @<fs1>-mjahr
      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'KAPURHOL' ) and budat_mkpf >= @lv_low
    AND budat_mkpf <= @lv_high
       INTO @lv_count.
*        SELECT COUNT( * ) from @lt_mseg as a
**      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'KAPURHOL' ) and mjahr = @<fs1>-mjahr
*      where po_lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'KAPURHOL' ) and budat_mkpf >= @lv_low
*    AND budat_mkpf <= @lv_high and lgort = ' '
*       INTO @DATA(lv_c).



     SELECT COUNT( * ) from @lt_mseg as a
*      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'SHIRWAL' ) and mjahr = @<fs1>-mjahr
      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'SHIRWAL' ) AND budat_mkpf >= @lv_low
    AND budat_mkpf <= @lv_high
       INTO @lv_count1.

*          SELECT COUNT( * ) from @lt_mseg as a
**      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'SHIRWAL' ) and mjahr = @<fs1>-mjahr
*      where lgort in ( SELECT STRG_LOC as b from  zloc_map  as a WHERE a~loc_code = 'SHIRWAL' ) AND budat_mkpf >= @lv_low
*    AND budat_mkpf <= @lv_high and lgort = ' '
*       INTO @DATA(lv_c1).
   endloop.
   ls_final-kapur = lv_count .
   ls_final-shirwal = lv_count1 .
   lv_kapur = lv_kapur + lv_count .
   lv_shirwal = lv_shirwal + lv_count1 .
   APPEND ls_final to lt_final.
   CLEAR:ls_final,lv_count,lv_count1 .
    ENDLOOP.
    ls_final-werks = 'Total GRNs'.
    ls_final-kapur = lv_kapur.
    ls_final-shirwal = lv_shirwal.
    APPEND ls_final to lt_final.
     CLEAR:ls_final,lv_kapur,lv_shirwal.
*     sort lt_mseg1 by mblnr mjahr budat_mkpf.
*  loop AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs>) GROUP BY ( key1 = <fs>-mjahr ).
*
*    loop at GROUP <fs> ASSIGNING FIELD-SYMBOL(<fs1>).
*      if <fs1> is ASSIGNED and <fs1>-bsart eq 'ZAST' and <fs1>-matnr is INITIAL.
*        CLEAR <fs1>.
*        CONTINUE.
*        ENDIF.
*      SELECT SINGLE LFBNR from mseg INTO @DATA(lv_LFBNR) WHERE LFBNR = @<fs1>-mblnr and bwart = '102'.
*          if lv_lfbnr is INITIAL.
*    READ TABLE lt_zloc INTO DATA(ls_zloc) with KEY STRG_LOC = <fs1>-lgort.
*    if sy-subrc = 0.
*      ls_final-werks = <fs1>-budat_mkpf+0(4).
*    if ls_zloc-LOC_code = 'KAPURHOL'.
*      ls_final-kapur =  ls_final-kapur + 1.
*    ELSEIF ls_zloc-loc_code = 'SHIRWAL'.
*      ls_final-shirwal = ls_final-shirwal + 1.
*    endif.
*    endif.
*    else.
*       CLEAR lv_lfbnr.
*      CONTINUE.
*
*    endif.
*  ENDLOOP.
*  APPEND ls_final to lt_final.
*  lv_kapur = lv_kapur + ls_final-kapur.
*  lv_shirwal = lv_shirwal + ls_final-shirwal.
*  CLEAr ls_final.
* ENDLOOP.
*
* ls_final-werks = 'Total GRNs'.
* ls_final-kapur = lv_kapur.
* ls_final-shirwal = lv_shirwal.
* APPEND ls_final to lt_final.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form dis_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_data .
refresh lt_fcat.
  ls_fcat-col_pos = '1'.
  ls_fcat-fieldname = 'WERKS'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-hotspot = 'X'.
  ls_fcat-seltext_l = 'Plant'.
  append ls_fcat to lt_fcat.
  CLEAr ls_fcat.

   ls_fcat-col_pos = '2'.
  ls_fcat-fieldname = 'SHIRWAL'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'SHIRWAL'.
  append ls_fcat to lt_fcat.
  CLEAr ls_fcat.
   ls_fcat-col_pos = '3'.
  ls_fcat-fieldname = 'KAPUR'.
  ls_fcat-tabname = 'LT_FINAL'.
  ls_fcat-seltext_l = 'KAPURHOL'.
  append ls_fcat to lt_fcat.
  CLEAr ls_fcat.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-cprog
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
*   O_COMMON_HUB                      =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = lt_final
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.



ENDFORM.

FORM user_command USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
DATA: lt_map3 TYPE RANGE OF zloc_map-STRG_LOC.
DATA: lt_map4 TYPE RANGE OF zloc_map-STRG_LOC.

CLEAR: lv_low ,lv_high.
*DATA(ls_row) = lt_final[ rs_selfield-tabindex ].
READ TABLE lt_final ASSIGNING FIELD-SYMBOL(<fs>) with key werks+5(4) = rs_selfield-value+5(4).
if <fs> is ASSIGNED.
  DATA(lv_high1) = rs_selfield-value+5(4) + 1.
   lv_low = |{ rs_selfield-value+5(4)  }0401|.
       lv_high = |{ lv_high1 }0331|.
*  delete lt_mseg WHERE budat_mkpf .
        lt_mseg4 = lt_mseg.
  DELETE lt_mseg4 WHERE budat_mkpf < lv_low OR budat_mkpf > lv_high.
*  DELETE lt_mseg WHERE budat_mkpf < lv_low OR budat_mkpf > lv_high.
  lt_ms = lt_mseg4.
  SELECT 'I' as sign ,'EQ' as option ,STRG_LOC as low from zloc_map INTO TABLE @lt_map3 WHERE loc_code = 'KAPURHOL'.
  SELECT 'I' as sign ,'EQ' as option ,STRG_LOC as low  from zloc_map INTO TABLE @lt_map4 WHERE loc_code = 'SHIRWAL'.
    data(lt_mseg1) = lt_mseg4.
    data(lt_mseg2) = lt_mseg4.
*    LOOP AT lt_map ASSIGNING FIELD-SYMBOL(<fy>).
*    APPEND VALUE #( sign = 'I' option = 'EQ' low = <fy>-STRG_LOC ) TO lt_map3.
*    ENDLOOP.
*     LOOP AT lt_map1 ASSIGNING FIELD-SYMBOL(<fy1>).
*    APPEND VALUE #( sign = 'I' option = 'EQ' low = <fy1>-STRG_LOC ) TO lt_map4.
*    ENDLOOP.
    delete lt_mseg1 WHERE lgort not in lt_map3.
    delete lt_mseg2 WHERE lgort not in lt_map4.
     refresh :lt_year.
*    LOOP AT lt_mseg1 ASSIGNING FIELD-SYMBOL(<fs1>).
*       if <fs1> is ASSIGNED and <fs1>-bsart eq 'ZAST' and <fs1>-matnr is INITIAL.
*        CLEAR <fs1>.
*        CONTINUE.
*        ENDIF.
*      SELECT SINGLE LFBNR from mseg INTO @DATA(lv_LFBNR) WHERE LFBNR = @<fs1>-mblnr and bwart = '102'.
*        if lv_lfbnr is INITIAL.
          ls_year-werks = 'KAPURHOL'.
          SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '01'
            INTO  @ls_year-jan.
        SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '02'
            INTO  @ls_year-feb.

           SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '03'
            INTO  @ls_year-mar.

              SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '04'
            INTO  @ls_year-april.

                SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '05'
            INTO  @ls_year-may.
               SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '06'
            INTO  @ls_year-jun.
                  SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '07'
            INTO  @ls_year-july.

               SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '08'
            INTO  @ls_year-aug.

                    SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '09'
            INTO  @ls_year-sept.


                    SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '10'
            INTO  @ls_year-oct.

              SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '11'
            INTO  @ls_year-nov.


              SELECT COUNT( * ) from @lt_mseg1 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '12'
            INTO  @ls_year-dec.

*        ELSEIF <fs1>-budat_mkpf+4(2) = '02'.
*         ls_year-feb = ls_year-feb + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '03'.
*         ls_year-mar = ls_year-mar + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '04'.
*         ls_year-april = ls_year-april + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '05'.
*         ls_year-may = ls_year-may + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '06'.
*         ls_year-jun = ls_year-jun + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '07'.
*         ls_year-july = ls_year-july + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '08'.
*         ls_year-aug = ls_year-aug + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '09'.
*         ls_year-sept = ls_year-sept + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '10'.
*         ls_year-oct = ls_year-oct + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '11'.
*         ls_year-nov = ls_year-nov + 1 .
*          ELSEIF <fs1>-budat_mkpf+4(2) = '12'.
*         ls_year-dec = ls_year-dec + 1 .
*          ENDIF.
*         else.
*            CLEAR lv_lfbnr.
*          CONTINUE.

*         ENDIF.
*    ENDLOOP.

 ls_year-total = ls_year-jan + ls_year-feb + ls_year-mar + ls_year-april
                   + ls_year-may + ls_year-jun + ls_year-july + ls_year-aug
                   + ls_year-sept + ls_year-oct + ls_year-Nov + ls_year-Dec.
    APPEND ls_year to lt_year.
   CLEAR ls_year.
              ls_year-werks = 'SHIRWAL'.
          SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '01'
            INTO  @ls_year-jan.
        SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '02'
            INTO  @ls_year-feb.

           SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '03'
            INTO  @ls_year-mar.

              SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '04'
            INTO  @ls_year-april.

                SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '05'
            INTO  @ls_year-may.
               SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '06'
            INTO  @ls_year-jun.
                  SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '07'
            INTO  @ls_year-july.

               SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '08'
            INTO  @ls_year-aug.

                    SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '09'
            INTO  @ls_year-sept.


                    SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '10'
            INTO  @ls_year-oct.

              SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '11'
            INTO  @ls_year-nov.


              SELECT COUNT( * ) from @lt_mseg2 as a
             WHERE  substring( budat_mkpf, 5, 2 ) = '12'
            INTO  @ls_year-dec.


*   LOOP AT lt_mseg2 ASSIGNING FIELD-SYMBOL(<fs2>).
*      if <fs2> is ASSIGNED and <fs2>-bsart eq 'ZAST' and <fs2>-matnr is INITIAL.
*        CLEAR <fs2>.
*        CONTINUE.
*        ENDIF.
*      SELECT SINGLE LFBNR from mseg INTO @lv_LFBNR WHERE LFBNR = @<fs2>-mblnr and bwart = '102'.
*        if lv_lfbnr is INITIAL.
*          ls_year-werks = 'SHIRWAL'.
*        IF <fs2>-budat_mkpf+4(2) = '01'.
*            ls_year-jan = ls_year-jan + 1 .
*        ELSEIF <fs2>-budat_mkpf+4(2) = '02'.
*         ls_year-feb = ls_year-feb + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '03'.
*         ls_year-mar = ls_year-mar + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '04'.
*         ls_year-april = ls_year-april + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '05'.
*         ls_year-may = ls_year-may + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '06'.
*         ls_year-jun = ls_year-jun + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '07'.
*         ls_year-july = ls_year-july + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '08'.
*         ls_year-aug = ls_year-aug + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '09'.
*         ls_year-sept = ls_year-sept + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '10'.
*         ls_year-oct = ls_year-oct + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '11'.
*         ls_year-nov = ls_year-nov + 1 .
*          ELSEIF <fs2>-budat_mkpf+4(2) = '12'.
*         ls_year-dec = ls_year-dec + 1 .
*          ENDIF.
*         else.
*           CLEAR lv_lfbnr.
*          CONTINUE.
*
*         ENDIF.
*    ENDLOOP.
    ls_year-total = ls_year-jan + ls_year-feb + ls_year-mar + ls_year-april
                   + ls_year-may + ls_year-jun + ls_year-july + ls_year-aug
                   + ls_year-sept + ls_year-oct + ls_year-Nov + ls_year-Dec.
    APPEND ls_year to lt_year.
   CLEAR ls_year.
   PERFORM dis_data1.
  ENDIF.

endform.
*&---------------------------------------------------------------------*
*& Form dis_data1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_data1 .
  data: n type i.
  refresh lt_fcat1.
 ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'WERKS'.
  ls_fcat1-tabname = 'LT_YEAR'.
*  ls_fcat-hotspot = 'X'.
  ls_fcat1-seltext_l = 'Plant'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.
  ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'APRIL'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'April'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'MAY'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'May'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.

   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'JUN'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'June'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.



   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'JULY'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'July'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'AUG'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'August'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'SEPT'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'September'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'OCT'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'October'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'NOV'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'November'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


  ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'DEC'.
  ls_fcat1-tabname = 'LT_YEAR'.
  ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'December'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.
   ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'JAN'.
  ls_fcat1-tabname = 'LT_YEAR'.
  ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'January'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.
  ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'FEB'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'February'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.


 ls_fcat1-col_pos = n + 1.
  ls_fcat1-fieldname = 'MAR'.
  ls_fcat1-tabname = 'LT_YEAR'.
   ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'March'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.



    ls_fcat1-col_pos = n + 1.
    ls_fcat1-fieldname = 'TOTAL'.
  ls_fcat1-tabname = 'LT_YEAR'.
*  ls_fcat1-hotspot = 'X'.
  ls_fcat1-seltext_l = 'Total GRNS'.
  append ls_fcat1 to lt_fcat1.
  CLEAr ls_fcat1.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-cprog
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND1'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fcat1
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
*   O_COMMON_HUB                      =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = lt_Year
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.





ENDFORM.


FORM user_command1 USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
*  READ TABLE lt_year ASSIGNING FIELD-SYMBOL(<fs>) with key werks = rs_selfield-value.
refresh lt_final1.
*  BREAK-POINT.
  CASE  rs_selfield-fieldname.
    WHEN 'JAN'.
      DATA(lv_month) = '01'.
    WHEN 'FEB'.
      lv_month = '02'.
     WHEN 'MAR'.
      lv_month = '03'.
      WHEN 'APRIL'.
      lv_month = '04'.
      WHEN 'MAY'.
       lv_month = '05'.
      WHEN 'JUN'.
      lv_month = '06'.
      WHEN 'JULY'.
      lv_month = '07'.
      WHEN 'AUG'.
      lv_month = '08'.
      WHEN 'SEPT'.
      lv_month = '09'.
      WHEN 'OCT'.
      lv_month = '10'.
      WHEN 'NOV'.
      lv_month = '11'.
      WHEN 'DEC'.
       lv_month = '12'.

    WHEN OTHERS.
  ENDCASE.
 TYPES:
  BEGIN OF ty_mon,
    month TYPE char2,
  END OF ty_mon.

TYPES: ty_mon_range TYPE RANGE OF ty_mon-month.
DATA: lr_month TYPE ty_mon_range.
*  delete lt_mseg WHERE budat_mkpf+4(2) ne lv_month.
**  DELETE lt_mseg WHERE CONV i( budat_mkpf+4(2) ) <> lv_month.
*  DATA(lv_month_char) = |{ lv_month ALPHA = OUT WIDTH = 2 }|.
*BREAK-POINT.
*DELETE lt_mseg WHERE  budat_mkpf+4(2)  ne lv_month_char.
APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_month ) TO lr_month.
* delete lt_mseg WHERE budat_mkpf+4(2) NOT IN lr_month.
refresh lt_ms.
        lt_ms = lt_mseg4.
 delete lt_ms WHERE budat_mkpf+4(2) NOT IN lr_month.
  SELECT * from zloc_map INTO TABLE @DATA(lt_zloc).
*  LOOP AT  lt_mseg ASSIGNING FIELD-SYMBOL(<fs>).
*    SELECT SINGLE LFBNR from mseg INTO @DATA(lv_LFBNR) WHERE LFBNR = @<fs>-mblnr and bwart = '102'.
*        if lv_lfbnr is INITIAL.
*           READ TABLE lt_zloc INTO DATA(ls_zloc) with KEY STRG_LOC = <fs>-lgort.
*    if sy-subrc = 0.
*      ls_final-werks = <fs>-budat_mkpf.
*    if ls_zloc-LOC_code = 'KAPURHOL'.
*      ls_final1-kapur =  ls_final1-kapur + 1.
*    ELSEIF ls_zloc-loc_code = 'SHIRWAL'.
*      ls_final1-shirwal = ls_final1-shirwal + 1.
*    endif.
*    endif.
*          else.
*            CLEAR:lv_lfbnr.
*            CONTINUE.
*          ENDIF.
*  ENDLOOP.
*  APPEND ls_final1 to lt_final1.
*  CLEAR ls_final1.




    "" naga
    data:lv_kapur type i,
          lv_shirwal type i.
    CLEAR:lv_kapur,lv_shirwal.
*    loop AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs>) GROUP BY ( key1 = <fs>-budat_mkpf+6(2) ).
    loop AT lt_ms ASSIGNING FIELD-SYMBOL(<fs>) GROUP BY ( key1 = <fs>-budat_mkpf+6(2) ).
      LOOP AT GROUP <fs> ASSIGNING FIELD-SYMBOL(<fs1>).
*         if <fs1> is ASSIGNED and <fs1>-bsart eq 'ZAST' and <fs1>-matnr is INITIAL.
*        CLEAR <fs1>.
*        CONTINUE.
*        ENDIF.
        if <fs1> is ASSIGNED.
*    SELECT SINGLE LFBNR from mseg INTO @DATA(lv_LFBNR) WHERE LFBNR = @<fs1>-mblnr and bwart = '102'.
*        if lv_lfbnr is INITIAL.
           READ TABLE lt_zloc INTO DATA(ls_zloc) with KEY STRG_LOC = <fs1>-lgort.
    if sy-subrc = 0.
      ls_final1-werks = <fs1>-budat_mkpf.
    if ls_zloc-LOC_code = 'KAPURHOL'.
      ls_final1-kapur =  ls_final1-kapur + 1.
    ELSEIF ls_zloc-loc_code = 'SHIRWAL'.
      ls_final1-shirwal = ls_final1-shirwal + 1.
    endif.
    endif.
*          else.
*            CLEAR:lv_lfbnr.
*            CONTINUE.
*          ENDIF.
          ENDIF.


  ENDLOOP.
   APPEND ls_final1 to lt_final1.
   lv_kapur = lv_kapur + ls_final1-kapur.
  lv_shirwal = lv_shirwal + ls_final1-shirwal.
  CLEAR ls_final1.
  ENDLOOP.
  ls_final1-werks = 'TOTAL GRNS'.
  ls_final1-kapur = lv_kapur.
  ls_final1-shirwal = lv_shirwal.
  APPEND ls_final1 to lt_final1.
  CLEAR :ls_final1,lv_kapur,lv_shirwal.
PERFORM dis_month.
    "" naga
  ENDFORM.
*&---------------------------------------------------------------------*
*& Form dis_month
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dis_month .
refresh lt_fcat2.
  ls_fcat2-col_pos = '1'.
  ls_fcat2-fieldname = 'WERKS'.
  ls_fcat2-tabname = 'LT_FINAL1'.
*  ls_fcat2-hotspot = 'X'.
  ls_fcat2-seltext_l = 'Plant'.
  append ls_fcat2 to lt_fcat2.
  CLEAr ls_fcat2.

   ls_fcat2-col_pos = '2'.
  ls_fcat2-fieldname = 'SHIRWAL'.
  ls_fcat2-tabname = 'LT_FINAL1'.
  ls_fcat2-seltext_l = 'SHIRWAL'.
  append ls_fcat2 to lt_fcat2.
  CLEAr ls_fcat2.
   ls_fcat2-col_pos = '3'.
  ls_fcat2-fieldname = 'KAPUR'.
  ls_fcat2-tabname = 'LT_FINAL1'.
  ls_fcat2-seltext_l = 'KAPURHOL'.
  append ls_fcat2 to lt_fcat2.
  CLEAr ls_fcat2.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-cprog
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = lt_fcat2
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER           =
*   O_COMMON_HUB                      =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = lt_final1
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


ENDFORM.
