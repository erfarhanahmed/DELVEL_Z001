*&---------------------------------------------------------------------*
*& Include          ZXVDBU01
*&---------------------------------------------------------------------*FR
TYPES : BEGIN of ty_xkomv,
        posnr     LIKE vbap-posnr,
        alckz     LIKE e1edk05-alckz,
        kschl     LIKE komv-kschl,
        kbetr(16) TYPE c,
        koein     LIKE rv61a-koein,
        kmein     LIKE komv-kmein,
        kpein(5)  TYPE c,
        kwert(16) TYPE c,
        currdec   LIKE tcurx-currdec,   "Dezimalstellen Währung
      END OF ty_xkomv.
FIELD-SYMBOLS <fs_DXKOMV> TYPE ty_xkomv.
FIELD-SYMBOLS <fs_DXKOMV1> TYPE ty_xkomv.
DATA: lv_ZPR0(1),
      lv_ZDIS(1).
DATA: wa_E1EDP01 TYPE E1EDP01.
DATA:lv_netwr TYPE netwr.
DATA lv_E1EDK01(17) VALUE '(SAPLVEDB)E1EDK01'.
FIELD-SYMBOLS <fs_E1EDK01> TYPE E1EDK01.


ASSIGN DXKOMV TO <fs_DXKOMV1>.
MOVE SEGMENT-sdata TO  wa_E1EDP01.
ASSIGN (lv_E1EDK01) to  <fs_E1EDK01>.
select SINGLE *
        FROM EKKO
        INto @DATA(wa_ekko)
        WHERE ebeln = @<fs_E1EDK01>-BELNR.


IF SEGMENT-SEGNAM =  'E1EDP01'.
BREAK-POINT.
SELECT *
        FROM PRCD_ELEMENTS
        INTO TABLE @DATA(it_PRCD_ELEMENTS)
        WHERE KNUMV = @wa_ekko-KNUMV
         and   KPOSN = @wa_E1EDP01-POSEX.
LOOP AT DXKOMV[]  ASSIGNING <fs_DXKOMV> .
IF <fs_DXKOMV>-KSCHL = 'ZPR0' AND  <fs_DXKOMV>-POSNR =  <fs_DXKOMV1>-POSNR.
READ TABLE it_PRCD_ELEMENTS INTO DATA(wa_PRCD_ELEMENTS) WITH  KEY KNUMV = wa_ekko-KNUMV
                                                                  KPOSN = wa_E1EDP01-POSEX
                                                                  KSCHL = 'P000'.
<fs_DXKOMV>-KBETR = wa_PRCD_ELEMENTS-KBETR.
lv_ZPR0 = 'X'.
ELSEIF <fs_DXKOMV>-KSCHL = 'ZDIS'  AND  <fs_DXKOMV>-POSNR =  <fs_DXKOMV1>-POSNR.
 CLear:wa_PRCD_ELEMENTS.
READ TABLE it_PRCD_ELEMENTS INTO wa_PRCD_ELEMENTS WITH  KEY KNUMV = wa_ekko-KNUMV
                                                                  KPOSN = wa_E1EDP01-POSEX
                                                                  KSCHL = 'R000'.  "<fs_DXKOMV>-KSCHL.
<fs_DXKOMV>-KBETR = wa_PRCD_ELEMENTS-KBETR.
lv_ZDIS = 'X'.
ENDIF.

ENDLOOP.



IF lv_ZPR0 IS INITIAL.
  CLear:wa_PRCD_ELEMENTS.
READ TABLE it_PRCD_ELEMENTS INTO wa_PRCD_ELEMENTS WITH  KEY KNUMV = wa_ekko-KNUMV
                                                                  KPOSN = wa_E1EDP01-POSEX
                                                                  KSCHL = 'P000'.
IF sy-subrc = 0.
lv_netwr = wa_PRCD_ELEMENTS-KBETR.
<fs_DXKOMV1>-KSCHL = 'ZPR0'. "wa_PRCD_ELEMENTS-KSCHL.
<fs_DXKOMV1>-KBETR = lv_netwr.
CONDENSE <fs_DXKOMV1>-KBETR NO-GAPS.
*DXKOMV-KSCHL = wa_PRCD_ELEMENTS-KSCHL.
*DXKOMV-KBETR = wa_PRCD_ELEMENTS-KBETR.
APPEND DXKOMV.
ENDIF.
ENDIF.


IF lv_ZDIS IS INITIAL.
  CLear:wa_PRCD_ELEMENTS.
READ TABLE it_PRCD_ELEMENTS INTO wa_PRCD_ELEMENTS WITH  KEY KNUMV = wa_ekko-KNUMV
                                                                  KPOSN = wa_E1EDP01-POSEX
                                                                  KSCHL = 'R000'.
IF sy-subrc = 0.
  CLEAR   lv_netwr.
  lv_netwr = wa_PRCD_ELEMENTS-KBETR.
<fs_DXKOMV1>-KSCHL = 'ZDIS'."wa_PRCD_ELEMENTS-KSCHL.
<fs_DXKOMV1>-KBETR = lv_netwr. "wa_PRCD_ELEMENTS-KBETR.
CONDENSE <fs_DXKOMV1>-KBETR NO-GAPS.
APPEND DXKOMV.
ENDIF.
ENDIF.

ENDIF.
