"Name: \PR:SAPMV45A\FO:USEREXIT_MOVE_FIELD_TO_VBAP\SE:END\EI
ENHANCEMENT 0 ZENH_SO_COPY_PRICE_FOR_CTBG.

*
*  DATA:
*    IT_TEXT     TYPE TABLE OF TLINE,
*    LT_TEXT_IDS TYPE STANDARD TABLE OF STXH, "thead,
*    LS_THEAD    TYPE STXH, "thead,
*    LV_OLD_NAME TYPE THEAD-TDNAME,
*    LV_NEW_NAME TYPE THEAD-TDNAME.
*
*  " Check material change
*  IF sy-tcode = 'VA02'  and *VBAP-MATNR+0(4) = 'CTBG' and *VBAP-MATNR <> vbap-matnr.
*
*    LV_OLD_NAME = |{ XVBAK-VBELN }{ XVBAP-POSNR }|.
*    LV_NEW_NAME = |{ XVBAK-VBELN }{ VBAP-POSNR }|.
*
*    DATA: HEADER TYPE THEAD.
*    SELECT *
*            FROM STXH
*            INTO TABLE LT_TEXT_IDS
*            WHERE TDOBJECT = 'VBBP'
*            AND TDNAME =   LV_OLD_NAME
*           AND TDSPRAS = 'E'.
*    LOOP AT LT_TEXT_IDS INTO LS_THEAD.
*      CL_RSTXT_PERSISTENCE_MANAGER=>READ( EXPORTING CLIENT                   = SY-MANDT
*                                                    OBJECT                   = LS_THEAD-TDOBJECT
*                                                    ID                       = LS_THEAD-TDID
*                                                    NAME                     = LS_THEAD-TDNAME
*                                                    LANGUAGE                 = LS_THEAD-TDSPRAS
*                                                    USE_OLD_PERSISTENCE      = ''
*                                          IMPORTING HEADER                   = HEADER
*                                                    TEXT_LINES               = IT_TEXT
*                                                    LINE_COUNTER_FROM_HEADER = DATA(L_LINE_COUNTER_FROM_HEADER) ).
*      IF SY-SUBRC = 0 AND IT_TEXT IS NOT INITIAL.
*        CALL FUNCTION 'SAVE_TEXT'
*          EXPORTING
*            HEADER = VALUE THEAD(
*                       TDOBJECT = 'VBBP'
*                       TDNAME   = LV_NEW_NAME
*                       TDID     = LS_THEAD-TDID
*                       TDSPRAS  = LS_THEAD-TDSPRAS )
*          TABLES
*            LINES  = IT_TEXT
*          EXCEPTIONS
*            OTHERS = 1.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDIF.


ENDENHANCEMENT.
