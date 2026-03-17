REPORT zvendor_rejection_qabypass.

TABLES : qals.


TYPES : BEGIN OF ty_qals,
          art        TYPE qals-art,
          enstehdat  TYPE qals-enstehdat,
          aufnr      TYPE qals-aufnr,
          prueflos   TYPE qals-prueflos,
          objnr      TYPE qals-objnr,
          lifnr      TYPE qals-lifnr,
          selmatnr   TYPE qals-selmatnr,
          mblnr      TYPE qals-mblnr,
          zeile      TYPE qals-zeile,
          mjahr      TYPE qals-mjahr,
          budat      TYPE qals-budat,
          lmenge01   TYPE qals-lmenge01,
          matnr      TYPE qals-matnr,
          werk       TYPE qals-werk,
          lagortvorg TYPE qals-lagortvorg,    " added by supriya :102423: 24:06:2024
        END OF ty_qals.

TYPES : BEGIN OF ty_mseg,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          lgort      TYPE mseg-lgort,
          menge      TYPE mseg-menge,
          sgtxt      TYPE mseg-sgtxt,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          dmbtr      TYPE mseg-dmbtr,
          aufnr      TYPE mseg-aufnr,
          lifnr      TYPE mseg-lifnr,
          budat_mkpf TYPE mseg-budat_mkpf,
          smbln      TYPE mseg-smbln,
          sjahr      TYPE mseg-sjahr,
        END OF ty_mseg.


*TYPES : BEGIN OF ty_qinf,
*          matnr     TYPE qinf-matnr,
*          noinsp    TYPE qinf-noinsp,
*          lieferant TYPE qinf-lieferant,
*        END OF ty_qinf.

TYPES: BEGIN OF ty_qave,
         prueflos TYPE qave-prueflos,
         vcode    TYPE qave-vcode,
         vdatum   TYPE qave-vdatum,
       END OF ty_qave.

TYPES : BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
        END OF ty_mara.

TYPES: BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktg TYPE makt-maktg,
       END OF ty_makt.

TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1.

TYPES: BEGIN OF ty_aufk,
         aufnr TYPE aufk-aufnr,
         auart TYPE aufk-auart,
       END OF ty_aufk.
DATA : lt_aufk TYPE STANDARD TABLE OF ty_aufk,
       ls_aufk TYPE ty_aufk.

TYPES: BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         lgort TYPE mard-lgort,
         lgpbe TYPE mard-lgpbe,
       END OF ty_mard.

TYPES : BEGIN OF ty_qmat,
          art   TYPE qmat-art,
          matnr TYPE qmat-matnr,
        END OF ty_qmat.

TYPES : BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
          inact TYPE jest-inact,
        END OF ty_jest.

TYPES : BEGIN OF ty_tj02t,
          istat TYPE tj02t-istat,
          txt04 TYPE tj02t-txt04,
          spras TYPE tj02t-spras,
        END OF ty_tj02t.

TYPES : BEGIN OF ty_mkpf,
          mblnr TYPE mkpf-mblnr,
          mjahr TYPE mkpf-mjahr,
          bktxt TYPE mkpf-bktxt,
          frbnr TYPE mkpf-frbnr,
        END OF ty_mkpf.

TYPES : BEGIN OF ty_qpct,                  "ADDED BY Snehal Rajale ON 07.04.2021
          code     TYPE qpct-code,
          kurztext TYPE qpct-kurztext,
          sprache  TYPE qpct-sprache,      "Added By Nilay pn 05.06.2023
        END OF ty_qpct.

TYPES : BEGIN OF ty_final,

          lifnr        TYPE qals-lifnr,
          name1        TYPE lfa1-name1,
          selmatnr     TYPE qals-selmatnr,
          mattxt(1320) TYPE c,
          mblnr        TYPE qals-mblnr,
          budat        TYPE qals-budat,
          prueflos     TYPE qals-prueflos,
          rec_qty      TYPE qals-lmenge01,
          lmenge01     TYPE qals-lmenge01,
          art          TYPE qals-art,
          zeile        TYPE mseg-zeile,
          lgort        TYPE mseg-lgort,
          lgpbe        TYPE mard-lgpbe,
          rm01_menge   TYPE mseg-menge,
          tpi1_menge   TYPE mseg-menge,
          rj01_menge   TYPE mseg-menge,
          rwk1_menge   TYPE mseg-menge,
          scr1_menge   TYPE mseg-menge,
          srn1_menge   TYPE mseg-menge,
          sgtxt        TYPE mseg-sgtxt,
          moc          TYPE mara-moc,
          type         TYPE mara-type,
          zseries      TYPE mara-zseries,
          zsize        TYPE mara-zsize,
          brand        TYPE mara-brand,
          maktx        TYPE makt-maktx,
*          NAME1        TYPE LFA1-NAME1,
          rew_qty      TYPE prcd_elements-kbetr,
          total_rej    TYPE prcd_elements-kbetr,
          auart        TYPE aufk-auart,
          srn_vendor   TYPE mkpf-bktxt,

          vdatum       TYPE qave-vdatum,
          stat         TYPE char100,
          dmbtr        TYPE mseg-dmbtr,
          sgtxt1       TYPE mseg-sgtxt,
          kurztext     TYPE qpct-kurztext,
          lagortvorg   TYPE qals-lagortvorg,    " added by supriya :102423: 24:06:2024
          frbnr        TYPE mkpf-frbnr,
        END OF ty_final,

        BEGIN OF str,
          lifnr    TYPE qals-lifnr,
          name1    TYPE lfa1-name1,
          selmatnr TYPE qals-selmatnr,
          maktx    TYPE makt-maktx,
          mblnr    TYPE qals-mblnr,
          budat    TYPE char15,
*          prueflos TYPE qals-prueflos,
*          art      TYPE qals-art,
          lmenge01 TYPE char15,
          lgpbe    TYPE mard-lgpbe,
*          MATTXT     TYPE CHAR100,
          zseries  TYPE mara-zseries,
          zsize    TYPE mara-zsize,
          brand    TYPE mara-brand,
          moc      TYPE mara-moc,
          type     TYPE mara-type,
*          stat     TYPE char100,
          dmbtr    TYPE char15,
          sgtxt1   TYPE mseg-sgtxt,
          lgort    TYPE mseg-lgort,    " added by supriya :102423: 24:06:2024
          frbnr    TYPE mkpf-frbnr, "
          ref      TYPE char15,
          ref_time TYPE char15,
        END OF str.

DATA : it_qals     TYPE TABLE OF ty_qals,
       wa_qals     TYPE ty_qals,

       it_qals1    TYPE TABLE OF ty_qals,
       wa_qals1    TYPE ty_qals,


       it_qamb     TYPE STANDARD TABLE OF qamb,
       wa_qamb     TYPE qamb,

       it_qamb1    TYPE STANDARD TABLE OF qamb,
       wa_qamb1    TYPE qamb,

       it_mseg     TYPE TABLE OF ty_mseg,
       wa_mseg     TYPE ty_mseg,

       it_mseg_101 TYPE TABLE OF ty_mseg,
       wa_mseg_101 TYPE ty_mseg,

       it_mseg_102 TYPE TABLE OF ty_mseg,
       wa_mseg_102 TYPE ty_mseg,

       it_mseg1    TYPE TABLE OF ty_mseg,
       wa_mseg1    TYPE          ty_mseg,

       it_mara     TYPE TABLE OF ty_mara,
       wa_mara     TYPE ty_mara,

       it_makt     TYPE TABLE OF ty_makt,
       wa_makt     TYPE ty_makt,

       it_lfa1     TYPE TABLE OF ty_lfa1,
       wa_lfa1     TYPE ty_lfa1,

       it_mard     TYPE TABLE OF ty_mard,
       wa_mard     TYPE ty_mard,

       it_qmat     TYPE TABLE OF ty_qmat,
       wa_qmat     TYPE          ty_qmat,

       it_jest     TYPE TABLE OF ty_jest,
       wa_jest     TYPE          ty_jest,

       it_tj02t    TYPE TABLE OF ty_tj02t,
       wa_tj02t    TYPE          ty_tj02t,

       it_final    TYPE TABLE OF ty_final,
       wa_final    TYPE ty_final,

       lt_final    TYPE TABLE OF str,
       ls_final    TYPE          str,

       lt_mkpf     TYPE TABLE OF ty_mkpf,
       ls_mkpf     TYPE          ty_mkpf,

       lt_qpct     TYPE TABLE OF ty_qpct,
       ls_qpct     TYPE          ty_qpct.

DATA : lt_fcat TYPE slis_t_fieldcat_alv,
       ls_fcat TYPE slis_fieldcat_alv.

DATA : ls_layout TYPE slis_layout_alv.

DATA:
  lv_clint   LIKE sy-mandt,   "Client
  lv_id      LIKE thead-tdid, "Text ID of text to be read
  lv_lang    LIKE thead-tdspras, "Language
  lv_name    LIKE thead-tdname, "Name of text to be read
  lv_object  LIKE thead-tdobject, "Object of text to be read
  lv_a(132)  TYPE c,           "local variable to store text
  lv_b(132)  TYPE c,           "local variable to store text
  lv_d(132)  TYPE c,           "local variable to store text
  lv_e(132)  TYPE c,           "local variable to store text
  lv_l(132)  TYPE c,           "local variable to store text
  lv_g(132)  TYPE c,           "local variable to store text
  lv_h(132)  TYPE c,           "local variable to store text
  lv_i(132)  TYPE c,           "local variable to store text
  lv_j(132)  TYPE c,           "local variable to store text
  lv_k(132)  TYPE c,           "local variable to store text
  lv_f(1320) TYPE c.           "local variable to store concatenated text


lv_clint = sy-mandt. "Client
lv_lang = 'EN'.      "Language
lv_id = 'QAVE'.      "Text ID of text to be read
lv_object = 'QPRUEFLOS'. "Object of text to be read

TYPES : BEGIN OF t_line,
          tdformat(2) TYPE c , "Tag column
          tdline(132) TYPE c , "Text Line
        END OF t_line.

DATA:it_line TYPE STANDARD TABLE OF t_line, "Table to store read_text data
     wa_line TYPE t_line.



SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : s_date   FOR qals-budat,
                 s_vendor FOR qals-lifnr.
*                 P_INSP FOR QALS-ART .
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME .           "TITLE TEXT-XYZ.
* created by supriya :102423: on 27.06.2024
PARAMETERS :r1 RADIOBUTTON GROUP def DEFAULT 'X',
            r2 RADIOBUTTON GROUP def.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN  COMMENT /1(60) TEXT-005.

SELECTION-SCREEN: END OF BLOCK b3.





START-OF-SELECTION.

*AT SELECTION-SCREEN.
  IF r1 = 'X'.
    PERFORM get_data.
    PERFORM readdata.
    PERFORM fieldcat.
    PERFORM dispdata.
  ELSEIF r2 = 'X'.
* created by supriya :102423: on 27.06.2024
    PERFORM get_data_new.
    PERFORM readdata_new.
    PERFORM fieldcat_new.
    PERFORM dispdata_new.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

*  BREAK fujiabap.

  SELECT  art
          enstehdat
          aufnr
          prueflos
          objnr
          lifnr
          selmatnr
          mblnr
          zeile
          mjahr
          budat
          lmenge01
          matnr
          werk
          lagortvorg   " added by supriya :102423: 24:06:2024
          FROM qals INTO TABLE it_qals
          WHERE budat IN s_date
            AND lifnr IN s_vendor
           AND prueflos = ' '
            AND art = '01' "04 "(P_INSP
            AND werk = 'PL01'.



  IF it_qals IS INITIAL.

    SELECT
              mblnr
              mjahr
              zeile
              lgort
              menge
              sgtxt
              matnr
              werks
              dmbtr
              aufnr
              lifnr
              budat_mkpf
               smbln
             sjahr
      FROM mseg
      INTO TABLE it_mseg_101
      WHERE budat_mkpf IN s_date
             AND lifnr IN s_vendor
             AND werks = 'PL01'
             AND bwart = '101'
             AND ebeln ne ' ' .






    IF it_mseg_101 IS NOT INITIAL.
      SELECT
              mblnr
              mjahr
              zeile
              lgort
              menge
              sgtxt
              matnr
              werks
              dmbtr
              aufnr
              lifnr
              budat_mkpf
             smbln
             sjahr
      FROM mseg
      INTO TABLE it_mseg_102
        FOR ALL ENTRIES IN it_mseg_101
      WHERE smbln = it_mseg_101-mblnr
         AND sjahr = it_mseg_101-mjahr
       AND bwart = '102'.

      IF it_mseg_102 IS NOT INITIAL.
        LOOP AT it_mseg_102 INTO wa_mseg_102.
          DELETE it_mseg_101 WHERE mblnr = wa_mseg_102-smbln
                                 and  matnr = wa_mseg_102-matnr.
        ENDLOOP.
      ENDIF.

      SELECT  art
         enstehdat
         aufnr
         prueflos
         objnr
         lifnr
         selmatnr
         mblnr
         zeile
         mjahr
         budat
         lmenge01
         matnr
         werk
         lagortvorg   " added by supriya :102423: 24:06:2024
         FROM qals INTO TABLE it_qals1
        FOR ALL ENTRIES IN it_mseg_101
         WHERE mblnr = it_mseg_101-mblnr
        AND mjahr = it_mseg_101-mjahr
        and matnr = it_mseg_101-matnr
*           AND prueflos = ' '
*            AND ART = '01' "04 "(P_INSP
           AND werk = 'PL01'.

      LOOP AT it_qals1 INTO wa_qals1.
        DELETE it_mseg_101 WHERE mblnr = wa_qals1-mblnr
                             and   matnr = wa_qals1-matnr.
      ENDLOOP.





*
*      SELECT  art
*             matnr
*         FROM qmat INTO TABLE it_qmat
*         FOR ALL ENTRIES IN it_mseg_101
*         WHERE matnr = it_mseg_101-matnr.






      SELECT matnr maktg FROM makt INTO TABLE it_makt
        FOR ALL ENTRIES IN it_mseg_101
        WHERE matnr = it_mseg_101-matnr.

*    SELECT OBJNR
*           STAT
*           INACT FROM JEST INTO TABLE IT_JEST
*           FOR ALL ENTRIES IN IT_QALS
*           WHERE OBJNR = IT_QALS-OBJNR
*           AND INACT NE 'X'.

    ENDIF.

*  IF  IT_JEST IS NOT INITIAL  .
*    SELECT ISTAT
*           TXT04
*           SPRAS FROM TJ02T INTO TABLE IT_TJ02T
*           FOR ALL ENTRIES IN IT_JEST
*           WHERE ISTAT = IT_JEST-STAT
*           AND   SPRAS = 'E'.
*  ENDIF.


    IF it_mseg_101 IS NOT INITIAL.
      SELECT aufnr auart FROM aufk INTO TABLE lt_aufk
        FOR ALL ENTRIES IN it_mseg_101
        WHERE aufnr = it_mseg_101-aufnr.
    ENDIF.

    IF it_mseg_101 IS NOT INITIAL.
      SELECT lifnr name1 FROM lfa1 INTO TABLE it_lfa1
        FOR ALL ENTRIES IN it_mseg_101
        WHERE lifnr = it_mseg_101-lifnr.
    ENDIF.

    IF it_mseg_101 IS NOT INITIAL.
      SELECT matnr moc type zseries zsize brand FROM mara INTO TABLE it_mara
        FOR ALL ENTRIES IN it_mseg_101
        WHERE matnr = it_mseg_101-matnr.
    ENDIF.


    IF it_mseg_101 IS NOT INITIAL .

      SELECT mblnr                            "ADDED BY Snehal Rajale On 07.04.2021.
             mjahr
             bktxt
             frbnr
        FROM mkpf
        INTO TABLE lt_mkpf
        FOR ALL ENTRIES IN it_mseg_101
        WHERE mblnr = it_mseg_101-mblnr AND
              mjahr = it_mseg_101-mjahr.


    ENDIF.


    IF it_mseg_101 IS NOT INITIAL.

      SELECT matnr lgort lgpbe FROM mard INTO TABLE it_mard
        FOR ALL ENTRIES IN  it_mseg_101         "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
        WHERE matnr = it_mseg_101-matnr           "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
          AND lgpbe <> ''.

    ENDIF.

*
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM readdata .

*  BREAK-POINT.
  .
  LOOP AT it_mseg_101 INTO wa_mseg_101.
    wa_final-lifnr    = wa_mseg_101-lifnr.
    wa_final-selmatnr = wa_mseg_101-matnr.
    wa_final-mblnr    = wa_mseg_101-mblnr.
*    WA_FINAL-MJAHR    = WA_mseg_101-MJAHR.
    wa_final-budat    = wa_mseg_101-budat_mkpf.
*    WA_FINAL-LMENGE01 = WA_mseg-LMENGE01.
*    WA_FINAL-AUFNR    = WA_mseg_101-AUFNR.
*    WA_FINAL-PRUEFLOS = WA_mseg-PRUEFLOS.
*    WA_FINAL-LAGORTVORG = WA_QALS-LAGORTVORG.    " added by supriya :102423: 24:06:2024

*    SHIFT WA_FINAL-AUFNR LEFT DELETING LEADING '0'.
*    READ TABLE  it_qmat INTO wa_qmat WITH KEY matnr =  wa_final-selmatnr.
*    IF sy-subrc IS INITIAL.
*      wa_final-art      = wa_qmat-art.
*    ENDIF.
*

*    LOOP AT IT_JEST INTO WA_JEST WHERE OBJNR = WA_QALS-OBJNR.
*
*      READ TABLE IT_TJ02T INTO WA_TJ02T WITH KEY ISTAT = WA_JEST-STAT.
*      IF SY-SUBRC = 0.
*        CONCATENATE WA_TJ02T-TXT04 WA_FINAL-STAT INTO WA_FINAL-STAT SEPARATED BY SPACE.
*
*      ENDIF.
*    ENDLOOP.

*BREAK-POINT.
*    READ TABLE it_qamb1 INTO wa_qamb1 WITH KEY  prueflos = wa_qals-prueflos
*                                                typ = '1'.
*    IF sy-subrc = 0.
*    READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY MBLNR = WA_mseg_101-MBLNR ZEILE = WA_mseg_101-ZEILE .
*    IF SY-SUBRC = 0.
    wa_final-rec_qty = wa_mseg_101-menge.
    wa_final-dmbtr   = wa_mseg_101-dmbtr.
    wa_final-sgtxt1  = wa_mseg_101-sgtxt.                    "Added By Snehal Rajale ON 01.02.2021
*    ENDIF.

*    ENDIF.

*    LOOP AT IT_QAMB INTO WA_QAMB WHERE PRUEFLOS = WA_QALS-PRUEFLOS .


*      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = WA_mseg_101-MBLNR  MJAHR = WA_mseg_101-MJAHR.
*      IF SY-SUBRC = 0.
    wa_final-sgtxt      = wa_mseg_101-sgtxt.
    wa_final-lgort      = wa_mseg_101-lgort.
*********************added by jyoti on 25.06.2024
*       if wa_mseg-LGORT = 'RM01' OR wa_mseg-LGORT = 'FG01' OR
*     wa_mseg-LGORT = 'MCN1' OR wa_mseg-LGORT = 'PLG1' OR wa_mseg-LGORT = 'PN01'
*     OR wa_mseg-LGORT = 'PRD1' OR wa_mseg-LGORT = 'RJ01'
*     OR wa_mseg-LGORT = 'RWK1' OR wa_mseg-LGORT = 'TPI1' OR  wa_mseg-LGORT = 'VLD1'.

* ***************************************************************************************************************
    IF wa_mseg_101-lgort = 'RM01'.
      wa_final-rm01_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'TPI1'.
      wa_final-tpi1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'RJ01'.
      wa_final-rj01_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'RWK1'.
      wa_final-rwk1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'SCR1'.
      wa_final-scr1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'SRN1'.
      wa_final-srn1_menge = wa_mseg_101-menge.
    ENDIF.
*************added by jyoti omj 25.06.2024
*       elseif wa_mseg-LGORT+0(1) = 'K'.
*
*      IF wa_mseg-lgort = 'KRM0'.
*          wa_final-rm01_menge = wa_mseg-menge.
*
*        ENDIF.
*          IF WA_MSEG-LGORT = 'KTPI'.
*          WA_FINAL-TPI1_MENGE = WA_MSEG-MENGE.
*        ENDIF.
*       IF wa_mseg-lgort = 'KRJ0'.
*          wa_final-rj01_menge = wa_mseg-menge.
**        lv_menge2 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KRWK'.
*          wa_final-rwk1_menge = wa_mseg-menge.
**        lv_menge3 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KSCR'.
*          wa_final-scr1_menge =  wa_mseg-menge.
**        lv_menge4 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KSRN'.
*          wa_final-srn1_menge = wa_mseg-menge.
**        lv_menge5 = wa_final-rm01_menge.
*        ENDIF.
*        ENDIF.
*      ENDIF.XXXXXXXXXX
*      CLEAR :WA_MSEG_101.

    READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = wa_mseg_101-mblnr  mjahr = wa_mseg_101-mjahr.
    IF sy-subrc = 0.
*      wa_final-srn_vendor = ls_mkpf-bktxt.
      wa_final-frbnr = ls_mkpf-frbnr.
    ENDIF.

*    ENDLOOP.
    CLEAR : wa_qamb.
    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-selmatnr.

    IF sy-subrc = 0.
      wa_final-moc      = wa_mara-moc     .
      wa_final-type     = wa_mara-type    .
      wa_final-zseries  = wa_mara-zseries .
      wa_final-zsize    = wa_mara-zsize   .
      wa_final-brand    = wa_mara-brand.
    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_final-selmatnr .
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktg.

    ENDIF.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr .
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.

    READ TABLE lt_aufk INTO ls_aufk WITH KEY aufnr = wa_qals-aufnr.
    IF sy-subrc = 0.
      wa_final-auart = ls_aufk-auart.
    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_final-selmatnr
                                             lgort =  wa_final-lgort."ADDED BY JYOTI ON 04.09.2024
    IF sy-subrc = 0.
      wa_final-lgpbe = wa_mard-lgpbe.
    ENDIF.
*

    CLEAR lv_f.
    CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

*FM to fetch reason according to inspection lot
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = lv_clint
        id                      = lv_id
        language                = lv_lang
        name                    = lv_name
        object                  = lv_object
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*   IMPORTING
*       HEADER                  =
      TABLES
        lines                   = it_line[]
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

    CLEAR sy-tabix.
    LOOP AT it_line INTO wa_line.

      IF sy-tabix = '1'.
        lv_a = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '2'.
        lv_b = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '3'.
        lv_d = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '4'.
        lv_e = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '5'.
        lv_l = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '6'.
        lv_g = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '7'.
        lv_h = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '8'.
        lv_i = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '9'.
        lv_j = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '10'.
        lv_k = wa_line-tdline.
      ENDIF.

    ENDLOOP.

    CONCATENATE lv_a lv_b lv_d lv_e lv_l lv_g lv_h lv_i lv_j lv_k INTO lv_f SEPARATED BY space.
    wa_final-mattxt = lv_f.


    ls_final-lifnr        = wa_final-lifnr   .
    ls_final-name1        = wa_final-name1   .
    ls_final-selmatnr     = wa_final-selmatnr .
    ls_final-maktx        = wa_final-maktx     .
    ls_final-mblnr        = wa_final-mblnr     .
*ls_final-budat        = wa_final-budat     .

    IF wa_final-budat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat
        IMPORTING
          output = ls_final-budat.

      CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                      INTO ls_final-budat SEPARATED BY '-'.
    ENDIF.

*    ls_final-prueflos     = wa_final-prueflos  .


    ls_final-lmenge01     = wa_final-rec_qty  .
    ls_final-lgpbe             = wa_final-lgpbe       .
*    ls_final-mattxt            = wa_final-mattxt      .
    ls_final-zseries           = wa_final-zseries     .
    ls_final-zsize             = wa_final-zsize       .
    ls_final-brand             = wa_final-brand       .
    ls_final-moc               = wa_final-moc         .
    ls_final-type              = wa_final-type        .
*    ls_final-art               = wa_final-art.
    ls_final-ref               = sy-datum.
*    ls_final-stat              = wa_final-stat.
    ls_final-dmbtr             = wa_final-dmbtr.
    ls_final-sgtxt1            = wa_final-sgtxt1.          "Added By Snehal Rajale ON 01.02.2021
    ls_final-lgort        = wa_final-lgort.      " added by supriya :102423: 24:06:2024
    ls_final-frbnr        = wa_final-frbnr.      " added by supriya :102423: 24:06:2024


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-ref
      IMPORTING
        output = ls_final-ref.

    CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                    INTO ls_final-ref SEPARATED BY '-'.

     CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO ls_final-ref_time.
*BREAK primus.
    IF ls_final-lgort+0(1) NE 'K'.
      APPEND ls_final TO lt_final.
    ENDIF.
    IF wa_final-lgort+0(1) NE 'K'.
      APPEND wa_final TO it_final.
    ENDIF.

    CLEAR : wa_final ,ls_final,ls_aufk,wa_lfa1,wa_makt,wa_mara,wa_qals,ls_mkpf,ls_qpct.
    REFRESH it_line.
    CLEAR : wa_final-mattxt,
            lv_a,
            lv_b,
            lv_d,
            lv_e,
            lv_l,
            lv_g,
            lv_h,
            lv_i,
            lv_j,
            lv_k,
            lv_f.

  ENDLOOP.
  DELETE lt_final WHERE selmatnr is INITIAL.
  DELETE  it_final WHERE selmatnr is INITIAL.

*  DELETE lt_final WHERE art NE '01'.
*  DELETE  it_final WHERE art NE '01'.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat .

  ls_fcat-col_pos   = '1'.
  ls_fcat-fieldname = 'LIFNR'.
  ls_fcat-seltext_m = 'VENDOR'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos  = '2'.
  ls_fcat-fieldname = 'NAME1'.
  ls_fcat-seltext_m = 'VENDOR NAME'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '3'.
  ls_fcat-fieldname = 'SELMATNR'.
  ls_fcat-seltext_m = 'ITEM CODE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '4'.
  ls_fcat-fieldname = 'MAKTX'.
  ls_fcat-seltext_m = 'ITEM DESCRIPTION'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos   = '5'.
  ls_fcat-fieldname = 'MBLNR'.
  ls_fcat-seltext_m = 'MATERIAL DOCUMENT'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '6'.
  ls_fcat-fieldname = 'BUDAT'.
  ls_fcat-seltext_m = 'MATERIAL DOC DATE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

*  ls_fcat-col_pos   = '7'.
*  ls_fcat-fieldname = 'PRUEFLOS'.
*  ls_fcat-seltext_m = 'INSPECTION LOT'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.
*
*  ls_fcat-col_pos   = '8'.
*  ls_fcat-fieldname = 'ART'."vdatum'.               "'BUDAT'.
*  ls_fcat-seltext_m = 'INSPECTION TYPE'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.


  ls_fcat-col_pos   = '9'.
*  ls_fcat-fieldname = 'LMENGE01'.
  ls_fcat-fieldname = 'REC_QTY'.
  ls_fcat-seltext_m = 'RECEIVED QTY'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.



  ls_fcat-col_pos   = '10'.
  ls_fcat-fieldname = 'LGPBE'.
  ls_fcat-seltext_m = 'STORAGE BIN'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos   = '11'.
  ls_fcat-fieldname = 'ZSERIES'.
  ls_fcat-seltext_m = 'SERIES CODE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '12'.
  ls_fcat-fieldname = 'ZSIZE'.
  ls_fcat-seltext_m = 'SIZE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '13'.
  ls_fcat-fieldname = 'BRAND'.
  ls_fcat-seltext_m = 'BRAND'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '14'.
  ls_fcat-fieldname = 'MOC'.
  ls_fcat-seltext_m = 'MOC'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '15'.
  ls_fcat-fieldname = 'TYPE'.
  ls_fcat-seltext_m = 'TYPE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.
*
*  ls_fcat-col_pos   = '16'.
*  ls_fcat-fieldname = 'STAT'.
*  ls_fcat-seltext_m = 'SYSTEM STATUS'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.

  ls_fcat-col_pos   = '17'.
  ls_fcat-fieldname = 'DMBTR'.
  ls_fcat-seltext_m = 'GRN VALUE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '18'.               "Added By Snehal Rajale ON 01.02.2021
  ls_fcat-fieldname = 'SGTXT1'.
  ls_fcat-seltext_m = 'TEXT'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '19'.               " added by supriya :102423: 24:06:2024
  ls_fcat-fieldname = 'LGORT'.
  ls_fcat-seltext_m = 'STORAGE LOCATION ' .   " 'STORAGE LOCATION FOR INSPECTION LOT STOCK'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '20'.               " added by supriya :102423: 24:06:2024
  ls_fcat-fieldname = 'FRBNR'.
  ls_fcat-seltext_m = 'Bill Of Lading' .   " 'STORAGE LOCATION FOR INSPECTION LOT STOCK'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


*  LS_LAYOUT-EDIT = 'X'.
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .



ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPDATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dispdata .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = ls_layout
      it_fieldcat            = lt_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*    IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_final
*    EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.


FORM top.
*  BREAK-POINT.
  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

  REFRESH lt_listheader.
  CLEAR ls_listheader.

  ls_listheader-typ = 'S'.
  ls_listheader-info =  '. '.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  gs_month = sy-datum+4(2).
  CALL FUNCTION 'HR_RU_MONTH_NAME_IN_GENITIVE'
    EXPORTING
      month = gs_month
    IMPORTING
      name  = ls_month_name.
*
  TRANSLATE ls_month_name TO UPPER CASE.
*  CONCATENATE 'DAILY DISPATCH REPORT'." LS_MONTH_NAME SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ' '.
  ls_listheader-typ = 'H'.
  ls_listheader-info = 'QA BYPASS GRN REPORT FOR SHIRVAL LOCATION'."GS_STRING.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT DATE :' sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.


  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
   INTO t_line SEPARATED BY space.

  ls_listheader-typ  = 'A'.
  ls_listheader-info = t_line.
  APPEND ls_listheader TO lt_listheader.
  CLEAR: ls_listheader, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
      i_logo             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_final
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
  lv_file = 'ZQA_BYPASSGRN_SHR.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
*BREAK primus.
  WRITE: / 'ZQA_BYPASSGRN_SHR Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_1182 TYPE string.
DATA lv_crlf_1182 TYPE string.
lv_crlf_1182 = cl_abap_char_utilities=>cr_lf.
lv_string_1182 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1182 lv_crlf_1182 wa_csv INTO lv_string_1182.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_1182 TO lv_fullfile.
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
FORM cvs_header  USING pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'VENDOR'
              'VENDOR NAME'
              'ITEM CODE'
              'ITEM DESCRIPTION'
              'MATERIAL DOCUMENT'
              'MATERIAL DOC DATE'
*              'INSPECTION LOT'
*              'INSPECTION TYPE'
              'RECEIVED QTY'
              'STORAGE BIN'
              'SERIES CODE'
              'SIZE'
              'BRAND'
              'MOC'
              'TYPE'
*              'SYSTEM STATUS'
              'GRN VALUE'
              'TEXT'                          "Added By Snehal Rajale ON 01.02.2021
              'STORAGE LOCATION'              "ADDED BY SUPRIYA JAGTAP :102423: 24.06.2024
              'Bill Of Lading'
              'Refresh Date'
              'Refreshable Time'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.

*****************************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_new .
*  BREAK fujiabap.

  SELECT  art
          enstehdat
          aufnr
          prueflos
          objnr
          lifnr
          selmatnr
          mblnr
          zeile
          mjahr
          budat
          lmenge01
          matnr
          werk
          lagortvorg   " added by supriya :102423: 24:06:2024
          FROM qals INTO TABLE it_qals
          WHERE budat IN s_date
            AND lifnr IN s_vendor
           AND prueflos = ' '
            AND art = '01' "04 "(P_INSP
            AND werk = 'PL01'.


  IF it_qals IS INITIAL.

    SELECT
              mblnr
              mjahr
              zeile
              lgort
              menge
              sgtxt
              matnr
              werks
              dmbtr
              aufnr
              lifnr
              budat_mkpf
             smbln
             sjahr
      FROM mseg
      INTO TABLE it_mseg_101
      WHERE budat_mkpf IN s_date
             AND lifnr IN s_vendor
             AND werks = 'PL01'
             AND bwart = '101'
             AND ebeln ne ' '.


    IF it_mseg_101 IS NOT INITIAL.


       SELECT
              mblnr
              mjahr
              zeile
              lgort
              menge
              sgtxt
              matnr
              werks
              dmbtr
              aufnr
              lifnr
              budat_mkpf
             smbln
             sjahr
      FROM mseg
      INTO TABLE it_mseg_102
        FOR ALL ENTRIES IN it_mseg_101
      WHERE smbln = it_mseg_101-mblnr
         AND sjahr = it_mseg_101-mjahr
       AND bwart = '102'.

      IF it_mseg_102 IS NOT INITIAL.
        LOOP AT it_mseg_102 INTO wa_mseg_102.
          DELETE it_mseg_101 WHERE mblnr = wa_mseg_102-smbln
                                and matnr = wa_mseg_102-matnr.
        ENDLOOP.
      ENDIF.








      SELECT  art
          enstehdat
          aufnr
          prueflos
          objnr
          lifnr
          selmatnr
          mblnr
          zeile
          mjahr
          budat
          lmenge01
          matnr
          werk
          lagortvorg   " added by supriya :102423: 24:06:2024
          FROM qals INTO TABLE it_qals1
         FOR ALL ENTRIES IN it_mseg_101
          WHERE mblnr = it_mseg_101-mblnr
         AND mjahr = it_mseg_101-mjahr
        and matnr = it_mseg_101-matnr
*           AND prueflos = ' '
*            AND ART = '01' "04 "(P_INSP
            AND werk = 'PL01'.

      LOOP AT it_qals1 INTO wa_qals1.
         DELETE it_mseg_101 WHERE mblnr = wa_qals1-mblnr
                             and   matnr = wa_qals1-matnr.
      ENDLOOP.


*      SELECT  art
*             matnr
*         FROM qmat INTO TABLE it_qmat
*         FOR ALL ENTRIES IN it_mseg_101
*         WHERE matnr = it_mseg_101-matnr.


      SELECT matnr maktg FROM makt INTO TABLE it_makt
        FOR ALL ENTRIES IN it_mseg_101
        WHERE matnr = it_mseg_101-matnr.

*    SELECT OBJNR
*           STAT
*           INACT FROM JEST INTO TABLE IT_JEST
*           FOR ALL ENTRIES IN IT_QALS
*           WHERE OBJNR = IT_QALS-OBJNR
*           AND INACT NE 'X'.

    ENDIF.

*  IF  IT_JEST IS NOT INITIAL  .
*    SELECT ISTAT
*           TXT04
*           SPRAS FROM TJ02T INTO TABLE IT_TJ02T
*           FOR ALL ENTRIES IN IT_JEST
*           WHERE ISTAT = IT_JEST-STAT
*           AND   SPRAS = 'E'.
*  ENDIF.


    IF it_mseg_101 IS NOT INITIAL.
      SELECT aufnr auart FROM aufk INTO TABLE lt_aufk
        FOR ALL ENTRIES IN it_mseg_101
        WHERE aufnr = it_mseg_101-aufnr.
    ENDIF.

    IF it_mseg_101 IS NOT INITIAL.
      SELECT lifnr name1 FROM lfa1 INTO TABLE it_lfa1
        FOR ALL ENTRIES IN it_mseg_101
        WHERE lifnr = it_mseg_101-lifnr.
    ENDIF.

    IF it_mseg_101 IS NOT INITIAL.
      SELECT matnr moc type zseries zsize brand FROM mara INTO TABLE it_mara
        FOR ALL ENTRIES IN it_mseg_101
        WHERE matnr = it_mseg_101-matnr.
    ENDIF.


    IF it_mseg_101 IS NOT INITIAL .

      SELECT mblnr                            "ADDED BY Snehal Rajale On 07.04.2021.
             mjahr
             bktxt
        FROM mkpf
        INTO TABLE lt_mkpf
        FOR ALL ENTRIES IN it_mseg_101
        WHERE mblnr = it_mseg_101-mblnr AND
              mjahr = it_mseg_101-mjahr.


    ENDIF.


    IF it_mseg_101 IS NOT INITIAL.

      SELECT matnr lgort lgpbe FROM mard INTO TABLE it_mard
        FOR ALL ENTRIES IN  it_mseg_101         "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
        WHERE matnr = it_mseg_101-matnr           "changed by pankaj on 15.11.2021 it_mseg to it_mseg1
          AND lgpbe <> ''.

    ENDIF.

*
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READDATA_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM readdata_new .
*  BREAK-POINT.
  .
  LOOP AT it_mseg_101 INTO wa_mseg_101.
    wa_final-lifnr    = wa_mseg_101-lifnr.
    wa_final-selmatnr = wa_mseg_101-matnr.
    wa_final-mblnr    = wa_mseg_101-mblnr.
*    WA_FINAL-MJAHR    = WA_mseg_101-MJAHR.
    wa_final-budat    = wa_mseg_101-budat_mkpf.
*    WA_FINAL-LMENGE01 = WA_mseg-LMENGE01.
*    WA_FINAL-AUFNR    = WA_mseg_101-AUFNR.
*    WA_FINAL-PRUEFLOS = WA_mseg-PRUEFLOS.
*    WA_FINAL-LAGORTVORG = WA_QALS-LAGORTVORG.    " added by supriya :102423: 24:06:2024

*    SHIFT WA_FINAL-AUFNR LEFT DELETING LEADING '0'.
*    WA_FINAL-ART      = WA_QALS-ART.
**
*    READ TABLE  it_qmat INTO wa_qmat WITH KEY matnr =  wa_final-selmatnr.
*    IF sy-subrc IS INITIAL.
*      wa_final-art      = wa_qmat-art.
*    ENDIF.

*    LOOP AT IT_JEST INTO WA_JEST WHERE OBJNR = WA_QALS-OBJNR.
*
*      READ TABLE IT_TJ02T INTO WA_TJ02T WITH KEY ISTAT = WA_JEST-STAT.
*      IF SY-SUBRC = 0.
*        CONCATENATE WA_TJ02T-TXT04 WA_FINAL-STAT INTO WA_FINAL-STAT SEPARATED BY SPACE.
*
*      ENDIF.
*    ENDLOOP.

*BREAK-POINT.
*    READ TABLE it_qamb1 INTO wa_qamb1 WITH KEY  prueflos = wa_qals-prueflos
*                                                typ = '1'.
*    IF sy-subrc = 0.
*    READ TABLE IT_MSEG1 INTO WA_MSEG1 WITH KEY MBLNR = WA_mseg_101-MBLNR ZEILE = WA_mseg_101-ZEILE .
*    IF SY-SUBRC = 0.
    wa_final-rec_qty = wa_mseg_101-menge.
    wa_final-dmbtr   = wa_mseg_101-dmbtr.
    wa_final-sgtxt1  = wa_mseg_101-sgtxt.                    "Added By Snehal Rajale ON 01.02.2021
*    ENDIF.

*    ENDIF.

*    LOOP AT IT_QAMB INTO WA_QAMB WHERE PRUEFLOS = WA_QALS-PRUEFLOS .


*      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MBLNR = WA_mseg_101-MBLNR  MJAHR = WA_mseg_101-MJAHR.
*      IF SY-SUBRC = 0.
    wa_final-sgtxt      = wa_mseg_101-sgtxt.
    wa_final-lgort      = wa_mseg_101-lgort.
*********************added by jyoti on 25.06.2024
*       if wa_mseg-LGORT = 'RM01' OR wa_mseg-LGORT = 'FG01' OR
*     wa_mseg-LGORT = 'MCN1' OR wa_mseg-LGORT = 'PLG1' OR wa_mseg-LGORT = 'PN01'
*     OR wa_mseg-LGORT = 'PRD1' OR wa_mseg-LGORT = 'RJ01'
*     OR wa_mseg-LGORT = 'RWK1' OR wa_mseg-LGORT = 'TPI1' OR  wa_mseg-LGORT = 'VLD1'.

* ***************************************************************************************************************
    IF wa_mseg_101-lgort = 'KRM0'.
      wa_final-rm01_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'KTPI'.
      wa_final-tpi1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'KRJ0'.
      wa_final-rj01_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'KRWK'.
      wa_final-rwk1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'KSCR'.
      wa_final-scr1_menge = wa_mseg_101-menge.
    ENDIF.
    IF wa_mseg_101-lgort = 'KSRN'.
      wa_final-srn1_menge = wa_mseg_101-menge.
    ENDIF.
*************added by jyoti omj 25.06.2024
*       elseif wa_mseg-LGORT+0(1) = 'K'.
*
*      IF wa_mseg-lgort = 'KRM0'.
*          wa_final-rm01_menge = wa_mseg-menge.
*
*        ENDIF.
*          IF WA_MSEG-LGORT = 'KTPI'.
*          WA_FINAL-TPI1_MENGE = WA_MSEG-MENGE.
*        ENDIF.
*       IF wa_mseg-lgort = 'KRJ0'.
*          wa_final-rj01_menge = wa_mseg-menge.
**        lv_menge2 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KRWK'.
*          wa_final-rwk1_menge = wa_mseg-menge.
**        lv_menge3 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KSCR'.
*          wa_final-scr1_menge =  wa_mseg-menge.
**        lv_menge4 = wa_final-rm01_menge.
*        ENDIF.
*        IF wa_mseg-lgort = 'KSRN'.
*          wa_final-srn1_menge = wa_mseg-menge.
**        lv_menge5 = wa_final-rm01_menge.
*        ENDIF.
*        ENDIF.
*      ENDIF.XXXXXXXXXX
*      CLEAR :WA_MSEG_101.

    READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = wa_mseg_101-mblnr  mjahr = wa_mseg_101-mjahr.
    IF sy-subrc = 0.
      wa_final-frbnr = ls_mkpf-frbnr.
    ENDIF.

*    ENDLOOP.
    CLEAR : wa_qamb.
    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_final-selmatnr.

    IF sy-subrc = 0.
      wa_final-moc      = wa_mara-moc     .
      wa_final-type     = wa_mara-type    .
      wa_final-zseries  = wa_mara-zseries .
      wa_final-zsize    = wa_mara-zsize   .
      wa_final-brand    = wa_mara-brand.
    ENDIF.

    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_final-selmatnr .
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt-maktg.

    ENDIF.

    READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr .
    IF sy-subrc = 0.
      wa_final-name1 = wa_lfa1-name1.
    ENDIF.

    READ TABLE lt_aufk INTO ls_aufk WITH KEY aufnr = wa_qals-aufnr.
    IF sy-subrc = 0.
      wa_final-auart = ls_aufk-auart.
    ENDIF.

    READ TABLE it_mard INTO wa_mard WITH KEY matnr = wa_final-selmatnr
                                             lgort =  wa_final-lgort."ADDED BY JYOTI ON 04.09.2024
    IF sy-subrc = 0.
      wa_final-lgpbe = wa_mard-lgpbe.
    ENDIF.
*

    CLEAR lv_f.
    CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

*FM to fetch reason according to inspection lot
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = lv_clint
        id                      = lv_id
        language                = lv_lang
        name                    = lv_name
        object                  = lv_object
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*   IMPORTING
*       HEADER                  =
      TABLES
        lines                   = it_line[]
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

    CLEAR sy-tabix.
    LOOP AT it_line INTO wa_line.

      IF sy-tabix = '1'.
        lv_a = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '2'.
        lv_b = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '3'.
        lv_d = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '4'.
        lv_e = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '5'.
        lv_l = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '6'.
        lv_g = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '7'.
        lv_h = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '8'.
        lv_i = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '9'.
        lv_j = wa_line-tdline.
      ENDIF.

      IF sy-tabix = '10'.
        lv_k = wa_line-tdline.
      ENDIF.

    ENDLOOP.

    CONCATENATE lv_a lv_b lv_d lv_e lv_l lv_g lv_h lv_i lv_j lv_k INTO lv_f SEPARATED BY space.
    wa_final-mattxt = lv_f.


    ls_final-lifnr        = wa_final-lifnr   .
    ls_final-name1        = wa_final-name1   .
    ls_final-selmatnr     = wa_final-selmatnr .
    ls_final-maktx        = wa_final-maktx     .
    ls_final-mblnr        = wa_final-mblnr     .
*ls_final-budat        = wa_final-budat     .

    IF wa_final-budat IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat
        IMPORTING
          output = ls_final-budat.

      CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                      INTO ls_final-budat SEPARATED BY '-'.
    ENDIF.

*    ls_final-prueflos     = wa_final-prueflos  .


    ls_final-lmenge01     = wa_final-rec_qty  .
    ls_final-lgpbe             = wa_final-lgpbe       .
*    ls_final-mattxt            = wa_final-mattxt      .
    ls_final-zseries           = wa_final-zseries     .
    ls_final-zsize             = wa_final-zsize       .
    ls_final-brand             = wa_final-brand       .
    ls_final-moc               = wa_final-moc         .
    ls_final-type              = wa_final-type        .
*    ls_final-art               = wa_final-art.
    ls_final-ref               = sy-datum.
*    ls_final-stat              = wa_final-stat.
    ls_final-dmbtr             = wa_final-dmbtr.
    ls_final-sgtxt1            = wa_final-sgtxt1.          "Added By Snehal Rajale ON 01.02.2021
    ls_final-lgort        = wa_final-lgort.      " added by supriya :102423: 24:06:2024
    ls_final-frbnr        = wa_final-frbnr.      " added by supriya :102423: 24:06:2024


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        input  = ls_final-ref
      IMPORTING
        output = ls_final-ref.

    CONCATENATE ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
                    INTO ls_final-ref SEPARATED BY '-'.

    CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO ls_final-ref_time.
*BREAK primus.
*BREAK primus.
    IF ls_final-lgort+0(1) EQ 'K'.
      APPEND ls_final TO lt_final.
    ENDIF.
    IF wa_final-lgort+0(1) EQ 'K'.
      APPEND wa_final TO it_final.
    ENDIF.
    CLEAR : wa_final ,ls_final,ls_aufk,wa_lfa1,wa_makt,wa_mara,wa_qals,ls_mkpf,ls_qpct.
    REFRESH it_line.
    CLEAR : wa_final-mattxt,
            lv_a,
            lv_b,
            lv_d,
            lv_e,
            lv_l,
            lv_g,
            lv_h,
            lv_i,
            lv_j,
            lv_k,
            lv_f.

  ENDLOOP.
   DELETE lt_final WHERE selmatnr is INITIAL.
  DELETE  it_final WHERE selmatnr is INITIAL.
*  DELETE lt_final WHERE art NE '01'.
*  DELETE  it_final WHERE art NE '01'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat_new .
  ls_fcat-col_pos   = '1'.
  ls_fcat-fieldname = 'LIFNR'.
  ls_fcat-seltext_m = 'VENDOR'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos  = '2'.
  ls_fcat-fieldname = 'NAME1'.
  ls_fcat-seltext_m = 'VENDOR NAME'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '3'.
  ls_fcat-fieldname = 'SELMATNR'.
  ls_fcat-seltext_m = 'ITEM CODE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '4'.
  ls_fcat-fieldname = 'MAKTX'.
  ls_fcat-seltext_m = 'ITEM DESCRIPTION'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '5'.
  ls_fcat-fieldname = 'MBLNR'.
  ls_fcat-seltext_m = 'MATERIAL DOCUMENT'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '6'.
  ls_fcat-fieldname = 'BUDAT'.
  ls_fcat-seltext_m = 'MATERIAL DOC DATE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

*  ls_fcat-col_pos   = '7'.
*  ls_fcat-fieldname = 'PRUEFLOS'.
*  ls_fcat-seltext_m = 'INSPECTION LOT'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.
*
*  ls_fcat-col_pos   = '8'.
*  ls_fcat-fieldname = 'ART'."vdatum'.               "'BUDAT'.
*  ls_fcat-seltext_m = 'INSPECTION TYPE'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.


  ls_fcat-col_pos   = '9'.
*  ls_fcat-fieldname = 'LMENGE01'.
  ls_fcat-fieldname = 'REC_QTY'.
  ls_fcat-seltext_m = 'RECEIVED QTY'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '10'.
  ls_fcat-fieldname = 'LGPBE'.
  ls_fcat-seltext_m = 'STORAGE BIN'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos   = '11'.
  ls_fcat-fieldname = 'ZSERIES'.
  ls_fcat-seltext_m = 'SERIES CODE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '12'.
  ls_fcat-fieldname = 'ZSIZE'.
  ls_fcat-seltext_m = 'SIZE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '13'.
  ls_fcat-fieldname = 'BRAND'.
  ls_fcat-seltext_m = 'BRAND'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '14'.
  ls_fcat-fieldname = 'MOC'.
  ls_fcat-seltext_m = 'MOC'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '15'.
  ls_fcat-fieldname = 'TYPE'.
  ls_fcat-seltext_m = 'TYPE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


*  ls_fcat-col_pos   = '16'.
*  ls_fcat-fieldname = 'STAT'.
*  ls_fcat-seltext_m = 'SYSTEM STATUS'.
*  APPEND  ls_fcat TO lt_fcat.
*  CLEAR ls_fcat.

  ls_fcat-col_pos   = '17'.
  ls_fcat-fieldname = 'DMBTR'.
  ls_fcat-seltext_m = 'GRN VALUE'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '18'.               "Added By Snehal Rajale ON 01.02.2021
  ls_fcat-fieldname = 'SGTXT1'.
  ls_fcat-seltext_m = 'TEXT'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.


  ls_fcat-col_pos   = '19'.               " added by supriya :102423: 24:06:2024
  ls_fcat-fieldname = 'LGORT'.
  ls_fcat-seltext_m = 'STORAGE LOCATION ' .   " 'STORAGE LOCATION FOR INSPECTION LOT STOCK'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

  ls_fcat-col_pos   = '20'.               " added by supriya :102423: 24:06:2024
  ls_fcat-fieldname = 'FRBNR'.
  ls_fcat-seltext_m = 'Bill Of Lading' .   " 'STORAGE LOCATION FOR INSPECTION LOT STOCK'.
  APPEND  ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

*  LS_LAYOUT-EDIT = 'X'.
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X' .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPDATA_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dispdata_new .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP_NEW'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = ls_layout
      it_fieldcat            = lt_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = 'X'
*     IS_VARIANT             =
*     IT_EVENTS              =
*     IT_EVENT_EXIT          =
*     IS_PRINT               =
*     IS_REPREP_ID           =
*     I_SCREEN_START_COLUMN  = 0
*     I_SCREEN_START_LINE    = 0
*     I_SCREEN_END_COLUMN    = 0
*     I_SCREEN_END_LINE      = 0
*     I_HTML_HEIGHT_TOP      = 0
*     I_HTML_HEIGHT_END      = 0
*     IT_ALV_GRAPHICS        =
*     IT_HYPERLINK           =
*     IT_ADD_FIELDCAT        =
*     IT_EXCEPT_QINFO        =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*    IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = it_final
*    EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF p_down = 'X'.
    PERFORM download_new.
  ENDIF.

ENDFORM.


FORM top_new.
*  created by supriya :102423: on 27.06.2024
*  BREAK-POINT.
  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

  REFRESH lt_listheader.
  CLEAR ls_listheader.

  ls_listheader-typ = 'S'.
  ls_listheader-info =  '. '.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  gs_month = sy-datum+4(2).
  CALL FUNCTION 'HR_RU_MONTH_NAME_IN_GENITIVE'
    EXPORTING
      month = gs_month
    IMPORTING
      name  = ls_month_name.
*
  TRANSLATE ls_month_name TO UPPER CASE.
*  CONCATENATE 'DAILY DISPATCH REPORT'." LS_MONTH_NAME SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ' '.
  ls_listheader-typ = 'H'.
  ls_listheader-info = 'QA BYPASS GRN REPORT FOR KPR LOCATION'."GS_STRING.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  CONCATENATE 'REPORT DATE :' sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.

  gs_string = ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.


  DESCRIBE TABLE it_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'TOTAL NO. OF RECORDS SELECTED: ' ld_linesc
   INTO t_line SEPARATED BY space.

  ls_listheader-typ  = 'A'.
  ls_listheader-info = t_line.
  APPEND ls_listheader TO lt_listheader.
  CLEAR: ls_listheader, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
      i_logo             = 'NEW_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_new .
* created by supriya :102423: on 27.06.2024
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
*BREAK primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = lt_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header_new USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZQA_BYPASSGRN_KPR.TXT'.

  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.
*BREAK primus.
  WRITE: / 'ZQA_BYPASSGRN_KPR Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_2072 TYPE string.
DATA lv_crlf_2072 TYPE string.
lv_crlf_2072 = cl_abap_char_utilities=>cr_lf.
lv_string_2072 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2072 lv_crlf_2072 wa_csv INTO lv_string_2072.
  CLEAR: wa_csv.
ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
TRANSFER lv_string_2072 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header_new  USING pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'VENDOR'
              'VENDOR NAME'
              'ITEM CODE'
              'ITEM DESCRIPTION'
              'MATERIAL DOCUMENT'
              'MATERIAL DOC DATE'
*              'INSPECTION LOT'
*              'INSPECTION TYPE'
              'RECEIVED QTY'
              'STORAGE BIN'
              'SERIES CODE'
              'SIZE'
              'BRAND'
              'MOC'
              'TYPE'
*              'SYSTEM STATUS'
              'GRN VALUE'
              'TEXT'                          "Added By Snehal Rajale ON 01.02.2021
              'STORAGE LOCATION'              "ADDED BY SUPRIYA JAGTAP :102423: 24.06.2024
              'Bill Of Lading'
               'Refresh Date'
               'Refreshable Time'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
