*&---------------------------------------------------------------------*
*& Report ZSUBCON_PO_STATUS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsubcon_po_status.
TYPE-POOLS:slis.
TABLES:mkpf,mseg,ekko.
TYPES: BEGIN OF ty_final1,
         date  TYPE mseg-budat_mkpf,
         werks TYPE char10,
         pdoc  TYPE i,
         pchal TYPE i,
         cchal TYPE i,
         total TYPE i,
       END OF ty_final1.
TYPES : BEGIN OF ty_final,
          ebeln              TYPE ekko-ebeln,
          lifnr              TYPE ekko-lifnr,
          aedat              TYPE ekko-aedat,
          ekgrp              TYPE ekko-ekgrp,
          frgke              TYPE ekko-frgke,
          ekorg              TYPE ekko-ekorg,
          name1              TYPE lfa1-name1,
          mblnr              TYPE mseg-mblnr,
          bwart              TYPE mseg-bwart,
          xauto              TYPE mseg-xauto,
          budat_mkpf         TYPE mseg-budat_mkpf,
          menge              TYPE mseg-menge,
          smbln              TYPE mseg-smbln,
          chln_inv           TYPE  j_1ig_subcon-chln_inv,
          matnr              TYPE  j_1ig_subcon-matnr,
          menge_j_1ig_subcon TYPE  j_1ig_subcon-menge,
          ebelp              TYPE ekpo-ebelp,
          loekz              TYPE ekpo-loekz,
          elikz              TYPE ekpo-elikz,
          brand              TYPE mara-brand,
          zseries            TYPE mara-zseries,
          zsize              TYPE mara-zsize,
          moc                TYPE mara-moc,
          type               TYPE mara-type,
          delivery_text      TYPE string,
          bdmng              TYPE resb-bdmng,
          enmng              TYPE resb-enmng,
          maktx              TYPE makt-maktx,
          yes                TYPE c LENGTH 3,
          pend_chlln_qty     TYPE mseg-menge,
          menge1             TYPE mseg-menge,
          menge2             TYPE mseg-menge,
          menge3             TYPE mseg-menge,
          qty_recv           TYPE mseg-menge,
          diff               TYPE mseg-menge,
          pending_po         TYPE mseg-menge,
          po_status          TYPE c LENGTH 5,
          delivey_menge      TYPE mseg-menge,
          lgort              TYPE mseg-lgort, "added by jyoti on 17.06.2024
*          pend_po_qty type i,
          bukrs              TYPE ekpo-bukrs,
          werks              TYPE ekpo-werks,
        END OF ty_final.

DATA : gt_final TYPE TABLE OF ty_final,
       gs_final TYPE ty_final.
DATA:ls_fcat TYPE slis_fieldcat_alv,
     lt_fcat TYPE STANDARD TABLE OF slis_fieldcat_alv.
DATA:lt_final TYPE STANDARD TABLE OF ty_final1,
     ls_final TYPE ty_final1.

DATA:s_ebeln TYPE RANGE OF ekko-ebeln.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_bukrs TYPE mseg-bukrs OBLIGATORY,
              p_werks TYPE mseg-werks OBLIGATORY.
  SELECT-OPTIONS: s_Date FOR mseg-budat_mkpf.

SELECTION-SCREEN: END OF BLOCK b1.

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
*  BREAK-POINT.
  DATA: lt_map3 TYPE RANGE OF zloc_map-strg_loc.
  DATA: lt_map4 TYPE RANGE OF zloc_map-strg_loc.
  DATA: lt_map5 TYPE RANGE OF zloc_map-strg_loc.
  DATA:lv_total  TYPE i,
       lv_total1 TYPE i,
       lv_total2 TYPE i,
       lv_totsub TYPE i,
       lv_sub    TYPE i.
  APPEND VALUE #( sign = 'I' option = 'BT' low = '1750000000' high = '1759999999' ) TO s_ebeln[].
  SELECT 'I' AS sign , 'BT' AS option , strg_loc AS low FROM zloc_map
   INTO TABLE @lt_map5.
  SORT lt_map5 BY low ASCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_map5 COMPARING low.
  DATA:lt_date TYPE STANDARD TABLE OF casdayattr.
  if s_date-high is NOT INITIAL.
  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
*     FACTORY_CALENDAR           = ' '
*     HOLIDAY_CALENDAR           = ' '
      date_from                  = s_date-low
      date_to                    = s_date-high
      language                   = sy-langu
*     NON_ISO                    = ' '
* IMPORTING
*     YEAR_OF_VALID_FROM         =
*     YEAR_OF_VALID_TO           =
*     RETURNCODE                 =
    TABLES
      day_attributes             = lt_date
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.
  else.

      CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
*     FACTORY_CALENDAR           = ' '
*     HOLIDAY_CALENDAR           = ' '
      date_from                  = s_date-low
      date_to                    = s_date-low
      language                   = sy-langu
*     NON_ISO                    = ' '
* IMPORTING
*     YEAR_OF_VALID_FROM         =
*     YEAR_OF_VALID_TO           =
*     RETURNCODE                 =
    TABLES
      day_attributes             = lt_date
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.


  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  ENDIF.




  SELECT DISTINCT
      a~ebeln,
      b~ebelp,
      a~bukrs,
      a~aedat,
      a~loekz     AS deletion_ind,

      b~werks,
      b~elikz     AS delivery_ind,
      b~lgort AS lgort,
      c~mblnr     AS material_doc,
      c~mjahr     AS year,
      c~zeile     AS zeile,
      c~budat AS budat,
      c~line_id   AS lineid,
      c~smbln     AS mat,
      c~lgort AS lgort_mat,
      c~header_counter AS counter,
      c~bwart     AS move_type,
      c~shkzg     AS ind,
      d~chln_inv  AS challan,
      d~budat AS post,
      e~vbeln as salesorder,
      e~rfbsk as posting_status
  FROM ekko AS a
*    LEFT OUTER JOIN ekpo AS b
    INNER  JOIN ekpo AS b
      ON  a~ebeln = b~ebeln
      AND b~werks = @p_werks
*      AND b~elikz <> 'X'
      AND b~ebelp = '00010'
*   //AND b~lgort IN @VALUE #( lt_map5 )

    LEFT OUTER JOIN matdoc AS c
      ON  a~ebeln = c~ebeln
*      AND c~bwart IN ('541','542') and c~budat = a~aedat
      AND c~bwart IN ('541','542') "and c~budat = a~aedat
      AND c~shkzg = 'H' AND b~ebelp = c~ebelp AND c~mblnr IS NOT INITIAL

    LEFT OUTER JOIN j_1ig_subcon AS d
*      ON  c~mblnr = d~mblnr and  D~budat = a~aedat
      ON  c~mblnr = d~mblnr "and  D~budat = a~aedat

   LEFT OUTER JOIN vbrk  AS e  ON e~vbeln  = d~chln_inv
  WHERE a~ebeln IN @s_ebeln
    AND a~bukrs = @p_bukrs
    AND B~loekz <> 'L'
    AND b~elikz <> 'X'
    AND a~bsart = 'ZSUB'
    AND b~ebelp = '00010'
    AND a~aedat IN @s_date AND c~mblnr IS NOT INITIAL
  INTO TABLE @DATA(lt_ekko).

  "" naga

  SELECT
      a~ebeln,
      a~bukrs,
      a~aedat,
      a~loekz     AS deletion_ind,
      b~ebelp,
      b~werks,
      b~elikz     AS delivery_ind,
      b~lgort AS lgort,
      c~mblnr     AS material_doc,
      c~mjahr     AS year,
      c~zeile     AS zeile,
      c~budat AS budat,
      c~line_id   AS lineid,
      c~smbln     AS mat,
      c~lgort AS lgort_mat,
      c~header_counter AS counter,
      c~bwart     AS move_type,
      c~shkzg     AS ind,
      d~chln_inv  AS challan,
      d~budat AS post,
      e~vbeln as salesorder,
      e~rfbsk as posting_status
  FROM ekko AS a
*    LEFT OUTER JOIN ekpo AS b
    INNER  JOIN ekpo AS b
      ON  a~ebeln = b~ebeln
      AND b~werks = @p_werks
*      AND b~elikz <> 'X'
      AND b~ebelp = '00010'
*   //AND b~lgort IN @VALUE #( lt_map5 )

    LEFT OUTER JOIN matdoc AS c
      ON  a~ebeln = c~ebeln
*      AND c~bwart IN ('541','542') and c~budat = a~aedat
      AND c~bwart IN ('541','542') "and c~budat = a~aedat
      AND c~shkzg = 'H' AND b~ebelp = c~ebelp " AND c~mblnr = ' '

    LEFT OUTER JOIN j_1ig_subcon AS d
*      ON  c~mblnr = d~mblnr and  D~budat = a~aedat
      ON  c~mblnr = d~mblnr "and  D~budat = a~aedat

   LEFT OUTER JOIN vbrk  AS e  ON e~vbeln  = d~chln_inv
  WHERE a~ebeln IN @s_ebeln
    AND a~bukrs = @p_bukrs
    AND B~loekz <> 'L'
    AND b~elikz <> 'X'
    AND a~bsart = 'ZSUB'
    AND b~ebelp = '00010'
    AND a~aedat IN @s_date "AND c~mblnr = ' '
  INTO TABLE @DATA(lt_541).

DELETE lt_541 WHERE material_doc is NOT INITIAL .
  "" naga

  SORT lt_ekko BY ebeln ebelp material_doc counter DESCENDING..
*DELETE ADJACENT DUPLICATES FROM lt_ekko COMPARING ebelp.
  DELETE lt_ekko WHERE move_type IS INITIAL.
*  DELETE lt_ekko WHERE lgort  IN lt_map5.
*  SORT lt_ekko BY material_doc ASCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_ekko COMPARING ebeln ebelp material_doc.
*  SORT lt_ekko BY ebeln ebelp.
*  DELETE ADJACENT DUPLICATES FROM lt_ekko COMPARING ebeln ebelp.
  SORT lt_ekko BY aedat.
  DATA(lt_mat) = lt_ekko.
  SORT lt_mat BY ebeln ebelp.

  DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING ebeln ebelp.

  SORT lt_mat BY aedat.
  DELETE ADJACENT DUPLICATES FROM lt_mat COMPARING aedat.
  SELECT 'I' AS sign , 'EQ' AS option, strg_loc AS low FROM zloc_map INTO TABLE @lt_map3 WHERE loc_code = 'KAPURHOL'.
  SELECT 'I' AS sign , 'EQ' AS option, strg_loc AS low FROM zloc_map INTO TABLE @lt_map4 WHERE loc_code = 'SHIRWAL'.
  DELETE ADJACENT DUPLICATES FROM lt_map3 COMPARING low.
  DELETE ADJACENT DUPLICATES FROM lt_map4 COMPARING low.
  DATA(lt_mat1) = lt_mat.
*  DELETE lt_mat1 WHERE lgort NOT IN lt_map3 .

  DATA(lt_mat2) = lt_mat.
*  DELETE lt_mat2 WHERE lgort NOT IN lt_map4 .

sort lt_ekko by ebeln mat ASCENDING.
*delete ADJACENT DUPLICATES FROM lt_ekko COMPARING ebeln .
* .
sort lt_ekko by aedat ASCENDING.

SELECT DISTINCT a~ebeln,
       a~aedat,
       b~lgort,
       b~move_type
  FROM ekko AS a
  INNER JOIN @lt_ekko AS b
    ON a~ebeln = b~ebeln
  WHERE b~move_type = '541'
    AND b~mat <> ' '
    AND b~ind = 'H'
  GROUP BY a~ebeln,
           a~aedat,
           b~lgort,
           b~move_type
  INTO TABLE @DATA(lt_ebeln).


  .


  LOOP AT lt_date ASSIGNING FIELD-SYMBOL(<fs>).
    ls_final-date = <fs>-date.
    ls_final-werks = 'KAPURHOL'.
*      SELECT COUNT( * ) FROM @lt_ekko AS a
      SELECT COUNT( * ) FROM @lt_ebeln AS a
     WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND aedat = @<fs>-date

      INTO @ls_final-pdoc.

         SELECT COUNT( * ) FROM @lt_541 AS a
     WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND aedat = @<fs>-date
*      AND move_type = '541'  AND material_doc eq ' '  AND mat ne ' '

      INTO @DATA(lv_c2).

    SELECT COUNT( * ) FROM @lt_ekko AS a
*  WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND budat = @<fs>-aedat
  WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND budat = @<fs>-date
    AND counter = '1' AND material_doc IS NOT INITIAL AND challan = ' ' and mat eq ' ' and  ind = 'H' and mat = ' '
   INTO @ls_final-pchal.

          SELECT COUNT( * ) FROM @lt_ekko AS a
*  WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND budat = @<fs>-aedat
  WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND budat = @<fs>-date
    AND counter = '1' AND material_doc IS NOT INITIAL AND challan is not INITIAL and posting_status = 'E' and mat eq ' ' and ind = 'H'
    INTO @DATA(lv_c).

*    SELECT COUNT( * ) FROM @lt_ekko AS a
**WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND post = @<fs>-aedat
*WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND post = @<fs>-date
*  AND counter = '1' AND material_doc IS NOT INITIAL AND challan IS NOT INITIAL and posting_status ne 'E' and  mat eq ' ' and ind = 'H'
* INTO @ls_final-cchal.

      "" nag
*      SELECT COUNT( * ) FROM @lt_ekko AS a
**WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND post = @<fs>-aedat
*WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND post = @<fs>-date
*  AND counter = '1' AND material_doc IS NOT INITIAL AND challan IS NOT INITIAL and
* INTO @ls_final-cchal.
*    IF ls_final-pdoc IS INITIAL AND ls_final-pchal IS INITIAL .
*       CLEAR :ls_final,lv_c,lv_c2.
*      CONTINUE.
*    ELSE.
*       SELECT
*    SUM( cnt )
*  FROM @p_pdoc as a
*  INTO @ls_final-pdoc.
      ls_final-pdoc = ls_final-pdoc + lv_c + lv_c2.
      lv_total = lv_total + ls_final-pdoc .
       lv_total1 = lv_total1 + ls_final-pchal.
      lv_total2 = lv_total2 + ls_final-cchal.
      ls_final-total =  ls_final-cchal + ls_final-pchal + ls_final-pdoc.

      APPEND ls_final TO lt_final.
      CLEAR :ls_final,lv_c,lv_c2.
*    ENDIF.

CLEAR :lv_c ,ls_final.
  ENDLOOP.
  delete lt_final WHERE pdoc is INITIAL and  pchal is INITIAL.
  LOOP AT lt_date ASSIGNING FIELD-SYMBOL(<fs1>).
    ls_final-date = <fs1>-date.
    ls_final-werks = 'SHIRWAL'.
*    SELECT COUNT( * ) FROM @lt_ekko AS a
    SELECT COUNT( * ) FROM @lt_ebeln AS a
     WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND aedat = @<fs1>-date
*      AND move_type = '541'    AND mat NE ' ' and ind = 'H'
      INTO @ls_final-pdoc.
      SELECT COUNT( * ) FROM @lt_541 AS a
     WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND aedat = @<fs1>-date
      INTO @DATA(lv_c1).

    SELECT COUNT( * ) FROM @lt_ekko AS a
*  WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND budat = @<fs1>-aedat
  WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND budat = @<fs1>-date
    AND counter = '1' AND material_doc IS NOT INITIAL AND challan = ' ' and ind = 'H' and mat = ' '
   INTO @ls_final-pchal.
 SELECT COUNT( * ) FROM @lt_ekko AS a
*  WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'KAPURHOL' ) AND budat = @<fs>-aedat
  WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND budat = @<fs>-date
    AND counter = '1' AND material_doc IS NOT INITIAL AND challan is not INITIAL and posting_status = 'E' and ind  = 'H' and mat = ' '
    INTO @lv_c.

    SELECT COUNT( * ) FROM @lt_ekko AS a
*WHERE lgort IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND  post = @<fs1>-aedat
WHERE lgort_mat IN ( SELECT strg_loc AS b FROM  zloc_map  AS a WHERE a~loc_code = 'SHIRWAL' ) AND  post = @<fs1>-date
  AND counter = '1' AND material_doc IS NOT INITIAL AND challan IS NOT INITIAL and ind = 'H' and mat = ' ' and posting_status ne 'E'
 INTO @ls_final-cchal.
*    IF ls_final-pdoc IS INITIAL AND ls_final-pchal IS INITIAL  .
*       CLEAR :ls_final,lv_c,lv_c2.
*      CONTINUE.
*    ELSE.
      ls_final-pdoc = ls_final-pdoc + lv_c + lv_c1.
      lv_total = lv_total + ls_final-pdoc.
      lv_total1 = lv_total1 + ls_final-pchal.
      lv_total2 = lv_total2 + ls_final-cchal.
      ls_final-total =  ls_final-cchal + ls_final-pchal + ls_final-pdoc.

      APPEND ls_final TO lt_final.
      CLEAR :lv_c ,ls_final,lv_c1.
*    ENDIF.

CLEAR :lv_c ,ls_final.
  ENDLOOP.
delete lt_final WHERE pdoc is INITIAL and  pchal is INITIAL.
clear ls_final-date.
  SORT lt_final ASCENDING BY  date.
  IF lt_final IS NOT INITIAL.
    ls_final-werks = 'Total'.
    ls_final-pdoc = lv_total.
    ls_final-pchal = lv_total1.
    ls_final-cchal = lv_total2.
    ls_final-total =  ls_final-pdoc  +  ls_final-pchal +  ls_final-cchal .

    APPEND ls_final TO lt_final.
    CLEAR: ls_final,lv_total,lv_total1,lv_total2,lv_sub.
  ENDIF.




*  IF lt_ekko IS NOT INITIAL.
**
*        SELECT a~mblnr,
*       a~mjahr,
*       a~zeile,
*       a~bwart,
*       a~xauto,
*       a~matnr,
*       a~werks,
*       a~lgort,
*       a~charg,
*       a~ebeln,
*       a~ebelp,
*       a~elikz,
*       a~bukrs,
*       a~budat_mkpf,
*       c~aedat,
*       c~loekz AS deletion_ind,
*       b~werks AS po_werks,
*       b~elikz AS delivery_ind
*  FROM ekko AS c
*  left outer JOIN mseg AS a ON c~ebeln = a~ebeln
*  left outer  JOIN ekpo AS b ON c~ebeln = b~ebeln
* WHERE c~ebeln IN @s_ebeln
*   AND a~bukrs = @p_bukrs
*   AND b~werks = @p_werks
*   AND c~loekz <> 'X'
*   AND b~elikz <> 'X'
*   AND c~bsart = 'ZSUB'
*   AND a~bwart IN ('541','542')
*   AND a~elikz <> 'X'
*   AND a~lgort IS NOT INITIAL
**   AND b~lgort IS NOT INITIAL
* INTO TABLE @DATA(lt_naga).
*
*     select a~mblnr,
*       a~mjahr,
*       a~zeile,
*       a~bwart,
*       a~xauto,
*       a~matnr,
*       a~werks,
*       a~lgort,
*       a~charg,
*       a~ebeln,
*       a~ebelp,
*       a~elikz,
*       a~bukrs,
*       a~budat_mkpf,
*       b~ebeln as po1,
*       b~aedat,
*       b~bukrs as comp,
*         b~deletion_ind,
*         b~po,
*         b~ebelp as item,
*         b~werks as plant,
*         b~delivery_ind from @lt_ekko as b
*        RIGHT OUTER JOIN  mseg as a on a~ebeln = b~ebeln
*       WHERE a~bwart IN ('541','542') and  a~elikz <> 'X' and A~lgort is NOT INITIAL
*       INTO TABLE @DATA(lt_prani).
*
*    "" naga
*
*    SELECT c~mblnr,
*       c~mjahr,
*       c~zeile,
*       c~bwart,
*       c~xauto,
*       c~matnr,
*       c~werks,
*       c~lgort,
*       c~charg,
*       c~ebeln,
*       c~ebelp,
*       c~elikz,
*       c~bukrs,
*       c~budat_mkpf,
*       a~aedat,
*       a~loekz AS deletion_ind,
*       b~werks AS po_werks,
*       b~elikz AS delivery_ind
*  FROM mseg AS c
*  INNER JOIN ekko AS a ON c~ebeln = a~ebeln
*  INNER JOIN ekpo AS b ON c~ebeln = b~ebeln
* WHERE c~ebeln IN @s_ebeln
*   AND a~bukrs = @p_bukrs
*   AND b~werks = @p_werks
*   AND a~loekz <> 'X'
*   AND b~elikz <> 'X'
*   AND a~bsart = 'ZSUB'
*   AND c~bwart IN ('541','542')
**   AND c~elikz <> 'X'
*   AND c~lgort IS NOT INITIAL
*   AND b~lgort IS NOT INITIAL
* INTO TABLE @DATA(lt_ms).
* endif.
*    IF lt_ms IS NOT INITIAL.
*
*
*
*    SORT lt_ms BY ebeln ebelp mblnr zeile ASCENDING.
*    DELETE ADJACENT DUPLICATES FROM lt_ms COMPARING  ebeln ebelp mblnr .
*  ENDIF.
*
*  SELECT * FROM zloc_map INTO TABLE @DATA(lt_zloc).
**     DElete gt_final WHERE werks ne p_werks.
**     DElete gt_final WHERE bukrs ne p_bukrs.
*  SORT lt_ms BY aedat ASCENDING.
*  SELECT ebeln, ebelp
*      FROM ekpo WHERE ( ebeln, ebelp ) IN (
*  SELECT ebeln, ebelp
*    FROM @lt_ms AS ms
*    WHERE bwart = '541' )  INTO TABLE @DATA(lt_ekpo).
*  SORT lt_ekpo BY ebeln ebelp.
*  DELETE ADJACENT DUPLICATES FROM lt_ekpo COMPARING ebeln ebelp.
**  SELECT * FROM @lt_ms AS mm INTO TABLE @DATA(lt_ms1) WHERE ( mm~ebeln ,mm~ebelp ) IN ( SELECT ebeln , ebelp FROM @lt_ekpo  AS a )
*  SELECT c~mblnr,
*       c~mjahr,
*       c~zeile,
*       c~bwart,
*       c~xauto,
*       c~matnr,
*       c~werks,
*       c~lgort,
*       c~charg,
*       c~ebeln,
*       c~ebelp,
*       c~elikz,
*       c~bukrs,
*       c~budat_mkpf,
*       c~aedat,
*     deletion_ind,
*       po_werks,
*       elikz AS delivery_ind FROM @lt_ms AS c INNER JOIN @lt_ekpo as b on c~ebeln = b~ebeln and c~ebelp = b~ebelp
**    FOR ALL ENTRIES IN @lt_ekpo
**    WHERE  ebeln  = @ebeln AND  ebelp = @lt_ekpo-ebelp
*     INTO TABLE @DATA(lt_ms1).
*    if lt_ms1 is NOT INITIAL.
**   SELECT bukrs,
**             mblnr,
**             mjahr,
**            zeile,
**            seq_no,
**           chln_inv,
**           item,
**          fkart FROM j_1ig_subcon INTO TABLE @DATA(lt_sub)
**        FOR ALL ENTRIES IN @lt_ms1
**        WHERE mblnr = @lt_ms1-mblnr AND mjahr = @lt_ms1-mjahr AND zeile = @lt_ms1-zeile AND fkart IN ( 'ZSN' ,'ZSP' ) AND bukrs = @p_bukrs.
*    ENDIF.
**    DATA(lt_ms1) = FILTER #( lt_ms IN lt_ekpo WHERE ebeln = ebeln AND ebelp = ebelp ).
*
*  SELECT 'I' AS sign , 'EQ' AS option, strg_loc AS low FROM zloc_map INTO TABLE @lt_map3 WHERE loc_code = 'KAPURHOL'.
*  SELECT 'I' AS sign , 'EQ' AS option, strg_loc AS low FROM zloc_map INTO TABLE @lt_map4 WHERE loc_code = 'SHIRWAL'.
***  DATA(lt_mseg1) = gt_final.
*  DATA(lt_mseg1) = lt_ms1.
*  DATA(lt_mseg2) = lt_ms1.
*  SORT lt_map3 BY low.
*  SORT lt_map4 BY low.
*  DELETE ADJACENT DUPLICATES FROM lt_map3 COMPARING low.
*  DELETE ADJACENT DUPLICATES FROM lt_map4 COMPARING low.
**
**    LOOP AT lt_map ASSIGNING FIELD-SYMBOL(<fy>).
**      APPEND VALUE #( sign = 'I' option = 'EQ' low = <fy>-strg_loc ) TO lt_map3.
**    ENDLOOP.
**    LOOP AT lt_map1 ASSIGNING FIELD-SYMBOL(<fy1>).
**      APPEND VALUE #( sign = 'I' option = 'EQ' low = <fy1>-strg_loc ) TO lt_map4.
**    ENDLOOP.
*  DELETE lt_mseg1 WHERE lgort NOT IN lt_map3.
*  DELETE lt_mseg2 WHERE lgort NOT IN lt_map4.
*  IF lt_mseg1 IS NOT INITIAL.
*
*  ENDIF.
*
*  LOOP AT lt_mseg1 ASSIGNING FIELD-SYMBOL(<fs>) GROUP BY ( key1 = <fs>-aedat ).
*    LOOP AT GROUP <fs> ASSIGNING FIELD-SYMBOL(<fs1>).
*
*
**        READ TABLE lt_zloc INTO DATA(ls_zloc) WITH KEY strg_loc = <fs>-lgort.
*      IF sy-subrc = 0.
*        ls_final-date = <fs>-aedat.
*        ls_final-werks = 'KAPURHOL'.
**        IF <fs1>-bwart = '541' AND <fs1>-mblnr IS INITIAL .
**          ls_final-pdoc = ls_final-pdoc + 1.
**        ENDIF.
**        IF <fs1>-mblnr IS NOT INITIAL  AND  <fs1>-chln_inv IS  INITIAL.
**          ls_final-pchal = ls_final-pchal + 1.
**        ENDIF.
**        IF <fs1>-chln_inv IS NOT INITIAL .
**          ls_final-cchal = ls_final-cchal + 1.
**        ENDIF.
*
*      ENDIF.
**        CLEAR ls_zloc.
*    ENDLOOP.
*    lv_total = lv_total + ls_final-pdoc.
*    lv_total1 = lv_total1 + ls_final-pchal.
*    lv_total2 = lv_total2 + ls_final-cchal.
*    ls_final-total =  ls_final-cchal + ls_final-pchal + ls_final-pdoc.
*    lv_sub = lv_sub + ls_final-total .
*    APPEND ls_final TO lt_final.
*    CLEAR :ls_final .
*  ENDLOOP.
*
**
*
*  LOOP AT lt_mseg2 ASSIGNING FIELD-SYMBOL(<fs2>) GROUP BY ( key1 = <fs2>-aedat ).
*    LOOP AT GROUP <fs2> ASSIGNING FIELD-SYMBOL(<fs3>).
*
*
*      READ TABLE lt_zloc INTO ls_zloc WITH KEY strg_loc = <fs3>-lgort.
*      IF sy-subrc = 0.
*        ls_final-date = <fs3>-aedat.
*        ls_final-werks = 'SHIRWAL'.
*        IF <fs3>-bwart = '541' AND <fs3>-mblnr IS INITIAL .
*          ls_final-pdoc = ls_final-pdoc + 1.
*        ENDIF.
*        IF <fs3>-mblnr IS NOT INITIAL  AND  <fs3>-chln_inv IS  INITIAL.
*          ls_final-pchal = ls_final-pchal + 1.
*        ENDIF.
*        IF <fs3>-chln_inv IS NOT INITIAL .
*          ls_final-cchal = ls_final-cchal + 1.
*        ENDIF.
*
*      ENDIF.
*      CLEAR ls_zloc.
*    ENDLOOP.
*    lv_total = lv_total + ls_final-pdoc.
*    lv_total1 = lv_total1 + ls_final-pchal.
*    lv_total2 = lv_total2 + ls_final-cchal.
*    ls_final-total =  ls_final-cchal + ls_final-pchal + ls_final-pdoc.
*    lv_sub = lv_sub + ls_final-total .
*    APPEND ls_final TO lt_final.
*    CLEAR :ls_final , lv_total.
*  ENDLOOP.
*  SORT lt_final BY date ASCENDING.
*  IF lt_final IS NOT INITIAL.
*    ls_final-werks = 'Total'.
*    ls_final-pdoc = lv_total.
*    ls_final-pchal = lv_total1.
*    ls_final-cchal = lv_total2.
*    ls_final-total = lv_sub.
*    APPEND ls_final TO lt_final.
*    CLEAR: ls_final,lv_total,lv_total1,lv_total2,lv_sub.
*  ENDIF.
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
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'DATE'  'Date'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'WERKS'  'Plant'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'PDOC'  'Pending For Document(541)Creation'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'PCHAL'  'Pending For Challan Creation'    'LT_FINAL'  '40'.
*  PERFORM build_fc USING   pr_count 'CCHAL'  'Document & Challan Created by'    'LT_FINAL'  '40'.
*  PERFORM build_fc USING   pr_count 'TOTAL'  'Total Subcon Po'    'LT_FINAL'  '10'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lT_FINAL
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.



FORM build_fc  USING        "PR_ROW TYPE I
                            pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            pr_table TYPE slis_tabname
                            pr_length TYPE string.

  pr_count = pr_count + 1.
*  GS_FIELDCAT-ROW_POS   = PR_ROW.
  ls_fcat-col_pos   = pr_count.
  ls_fcat-fieldname = pr_fname.
  ls_fcat-seltext_l = pr_title.
  ls_fcat-tabname   = pr_table.
  ls_fcat-outputlen = pr_length.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

ENDFORM.
