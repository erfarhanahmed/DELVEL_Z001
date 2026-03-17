*&---------------------------------------------------------------------*
*& Report Z_FIND_CUSTOM_TEMPLATES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_FIND_CUSTOM_TEMPLATES.


TABLES: tka52, kpp1loio.

SELECT-OPTIONS: plprof FOR tka52-plprof,
                subclass FOR tka52-subclass,
                tabname FOR tka52-tabname,
                posit FOR tka52-posit,
                form_u FOR tka52-form_u.
PARAMETERS: test_run AS CHECKBOX DEFAULT 'X'.

DATA: ld_bildtyp LIKE kpp2k-bildtyp VALUE '6',
      ls_obj_id_log LIKE sdokobject,
      ld_subrc LIKE sy-subrc,
      ls_mesg LIKE mesg.

DATA: lt_tka52 LIKE TABLE OF tka52 WITH HEADER LINE.

START-OF-SELECTION.

* Sätze mit Excel Integration aus TKA52.
SELECT  * FROM tka52                             "#EC CI_GENBUFF
  INTO  TABLE lt_tka52
  WHERE plprof IN plprof
  AND   subclass IN subclass
  AND   tabname IN tabname
  AND   posit IN posit
  AND   form_u IN form_u
  AND   excel  EQ 'X'.
* Sonderlocke CO-PA / KEPM: Hier gibt es für die kundeneigenen
* Excel Templates keine Sätze in der TKA52. Daher Pseudo-TKA52-Sätze
* aus den entsprechenden KPP1LOIO-Sätzen "basteln".
SELECT * FROM kpp1loio                           "#EC CI_NOFIRST
  WHERE prop02 = '02'.
  CLEAR lt_tka52.
  MOVE: kpp1loio-prop01 TO lt_tka52-plprof,
        kpp1loio-prop02 TO lt_tka52-subclass,
        kpp1loio-prop08 TO lt_tka52-tabname,
        kpp1loio-prop03 TO lt_tka52-posit,
        kpp1loio-prop05 TO lt_tka52-form_u,
        'X'             TO lt_tka52-excel.
  APPEND lt_tka52.
ENDSELECT.

* Finde Sätze mit kundeneigenem Excel Template
* (analog Logik aus FB KPP_XL_TEMPLATE_GET_COPY).
LOOP AT lt_tka52.
  CLEAR ld_subrc.
  PERFORM sdok_loio_read(saplkpp7) USING lt_tka52 ld_bildtyp space
                          CHANGING ls_obj_id_log
                                   ld_subrc ls_mesg.
  IF ld_subrc = 2.
*   Master gefunden
    DELETE lt_tka52.
    CONTINUE.
  ELSEIF ld_subrc GT 2.
    MESSAGE a208(00) WITH 'NO_TEMPLATE_FOUND'.
  ENDIF.
ENDLOOP.

* im LT_TKA52 verbleiben die Sätze mit kundeneigenem Template.
LOOP AT lt_tka52.
  WRITE: /(15) lt_tka52-plprof,
          (08) lt_tka52-subclass,
          (10) lt_tka52-tabname,
          (12) lt_tka52-posit,
          (15) lt_tka52-form_u.
ENDLOOP.

IF lt_tka52[] IS INITIAL.
  MESSAGE i208(00) WITH 'no custom templates found'.
  STOP.
ENDIF.

* Kundeneigene Templates im Echtlauf löschen.
IF test_run IS INITIAL.
  LOOP AT lt_tka52.
    SUBMIT kpp7ut03
           AND RETURN
            WITH layout = lt_tka52-form_u
            WITH posit = lt_tka52-posit
            WITH profil = lt_tka52-plprof
            WITH subclass = lt_tka52-subclass
            WITH tabname = lt_tka52-tabname.
  ENDLOOP.
  MESSAGE i208(00) WITH 'custom templates have been deleted'.
ENDIF.

end-of-selection.

TOP-OF-PAGE.
WRITE: /(15) 'Planner profile',
        (08) 'Subclass',
        (10) 'Table name',
        (12) 'Profile item',
        (15) 'Planning layout'.
ULINE.
