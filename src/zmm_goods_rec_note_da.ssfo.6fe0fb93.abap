*data : WA_MSEG    TYPE T_MSEG. " declared globally
*break sansari.
*sort lt_mseg by ZEILE.
*BREAK kdeshmukh .
*BREAK-POINT.
CLEAR : lv_item,lv_zeivr1 .
DATA : LV_UDATE TYPE CDHDR-UDATE,
*       LV_zeivr TYPE CDPOS-VALUE_OLD,
*       LV_zeivr1 TYPE CDPOS-VALUE_OLD,
       LV_CHANG TYPE CDHDR-CHANGENR.
DATA : IT_CDPOS TYPE STANDARD TABLE OF TY_CDPOS,
       WA_CDPOS TYPE TY_CDPOS.
DATA : IT_CDPOS1 TYPE STANDARD TABLE OF TY_CDPOS,
       WA_CDPOS1 TYPE TY_CDPOS.
DATA : IT_CDHDR TYPE STANDARD TABLE OF TY_CDHDR,
       WA_CDHDR TYPE TY_CDHDR.
read TABLE lt_mseg INTO wa_mseg WITH KEY ZEILE = WA_GR_ITEM-ZEILE.

RCPT_QTY = wa_mseg-erfmg.
CHLN_QTY = gv_mseg-LSMNG.
ACPT_QTY = gv_mseg-ERFMG.
REJ_QTY  = WA_QALS-LMENGE04.
lv_item = wa_mseg-zeile .

*SHIFT lv_item LEFT DELETING LEADING '0' .

SELECT SINGLE *  FROM MARA INTO WA_MARA
       WHERE MATNR = WA_GR_ITEM-MATNR.
*************AVINASH BHAGAT
  select SINGLE UDATE from cdhdr INTO LV_UDATE WHERE OBJECTID = wa_mseg-EBELN.
  SELECT OBJECTID CHANGENR FROM CDPOS INTO TABLE IT_CDPOS WHERE OBJECTID = wa_mseg-MATNR
AND TABNAME = 'MARA' AND FNAME = 'ZEIVR'.
    IF IT_CDPOS IS NOT INITIAL.
    SELECT OBJECTID CHANGENR FROM cdhdr INTO TABLE IT_CDHDR FOR ALL ENTRIES IN IT_CDPOS  WHERE OBJECTID = wa_mseg-MATNR
      AND UDATE GE LV_UDATE AND CHANGENR = IT_CDPOS-CHANGENR .
      SORT IT_CDHDR  ASCENDING BY CHANGENR.
      READ TABLE IT_CDHDR INTO WA_CDHDR INDEX 1.
      LV_CHANG = WA_CDHDR-CHANGENR.
      ENDIF.
      SELECT SINGLE VALUE_OLD FROM CDPOS INTO LV_zeivr WHERE OBJECTID = wa_mseg-MATNR
        AND TABNAME = 'MARA' AND FNAME = 'ZEIVR' AND CHANGENR = LV_CHANG.
        IF LV_zeivr IS NOT INITIAL.
          wa_mara-zeivr =  LV_zeivr.
          ELSE.
            SELECT SINGLE zeivr FROM MARA INTO wa_mara-zeivr WHERE MATNR = wa_mseg-MATNR.
            ENDIF.

************  END AVINASH BHAGAT

CONDENSE : RCPT_QTY,
           CHLN_QTY,
           ACPT_QTY,
           REJ_QTY.

DATA :  TEXT_LINES TYPE TABLE OF TLINE,
        WA_TEXT_LINE TYPE TLINE,
        OBJNAME TYPE TDOBNAME.

OBJNAME = gv_mseg-kdauf.

*&--------------------------------------------------------------&*
*for fetching the header text from the SO
*&--------------------------------------------------------------&*

CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z999'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
     .
*IF sy-subrc <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ELSE.
* BREAK fujiabap.
  DESCRIBE TABLE TEXT_LINES.
*  IF SY-TFILL <> 0.
    LOOP AT TEXT_LINES INTO WA_TEXT_LINE.
      CONCATENATE TXT WA_TEXT_LINE-TDLINE INTO TXT.
    ENDLOOP.
*  ENDIF.
*ENDIF.


*&--------------------------------------------------------------&*
*for fetching the header text from the SO
*&--------------------------------------------------------------&*


CLEAR : OBJNAME, TXT1.
REFRESH TEXT_LINES.
CONCATENATE GV_MSEG-KDAUF GV_MSEG-KDPOS INTO OBJNAME.

CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z888'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'VBBP'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
     .
*IF sy-subrc <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*        WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ELSE.
  DESCRIBE TABLE TEXT_LINES.
*  IF SY-TFILL <> 0.
    LOOP AT TEXT_LINES INTO WA_TEXT_LINE.
      CONCATENATE TXT1 WA_TEXT_LINE-TDLINE INTO TXT1.
    ENDLOOP.
*  ENDIF.
*ENDIF.
 BREAK fujiabap.
 READ TABLE GT_MKPF INTO WA_MKPF INDEX 1.
 READ TABLE lt_mseg INTO wa_mseg1 INDEX 1.
 CLEAR gv_flag.
 SELECT SINGLE noinsp
          FROM qinf
          INTO gv_flag
          WHERE MATNR     = WA_GR_ITEM-matnr
          AND   lieferant = GV_LFA1-LIFNR.
   CLEAR gs_mard.
   READ TABLE gt_mard INTO gs_mard
                      with KEY MATNR = WA_GR_ITEM-matnr.
