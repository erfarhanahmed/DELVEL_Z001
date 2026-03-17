REPORT ZMAT_STOCK.
tables : mseg,mara.
TYPE-POOLS: slis.


 DATA: i_sort             TYPE slis_t_sortinfo_alv, " SORT
      gt_events          TYPE slis_t_event,        " EVENTS
      i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
      wa_layout          TYPE  slis_layout_alv..            " LAYOUT WORKAREA
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.
DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.
******
data : begin of i_afpo occurs 0,
       aufnr like afpo-aufnr,
       end of i_afpo.
data : wa_afpo like i_afpo.

data : begin of i_mseg occurs 0,
       mblnr like mseg-mblnr,
       mjahr like mseg-mjahr,
       zeile like mseg-zeile,
       bwart like mseg-bwart,
       matnr like mseg-matnr,
       menge like mseg-menge,
       sjahr like mseg-sjahr,
       smbln like mseg-smbln,
       smblp like mseg-smblp,
       aufnr like mseg-aufnr,
       lgort like mseg-lgort,
       end of i_mseg.
data : wa_mseg like i_mseg.
data : i_mseg1 LIKE TABLE OF i_mseg.
data : wa_mseg1 like i_mseg.
data : begin of i_aufk occurs 0,
       aufnr like aufk-aufnr,
       objnr like aufk-objnr,
       end of i_aufk.
data : wa_aufk like i_aufk.
data : begin of i_jest occurs 0,
       objnr like jest-objnr,
       stat  like jest-stat,
       end of i_jest.
data : wa_jest like i_jest.
data : begin of i_mseg_sum occurs 0,
       matnr like mseg-matnr,
       LOC_CODE like ZLOC_MAP-LOC_CODE,
       menge    like mseg-menge,
       end of i_mseg_sum.
data : wa_mseg_sum like i_mseg_sum.
******
data : begin of i_mard occurs 0,
       matnr like mard-matnr,
       werks like mard-werks,
       lgort like mard-lgort,
       labst like mard-labst,
       insme like mard-insme,
       speme like mard-speme,
       LOC_CODE like ZLOC_MAP-LOC_CODE,
       end of i_mard.
data : wa_mard like i_mard.
data : begin of i_MSLB occurs 0.
       INCLUDE STRUCTURE MSLB.
data : end of i_MSLB.
data : wa_MSLB like i_MSLB.
data : begin of i_mslb1 occurs 0,
       matnr like mslb-matnr,
       lblab like mslb-lbins,
       end of i_mslb1.
data : wa_mslb1 like i_mslb1.
data : begin of i_T001L occurs 0.
       INCLUDE STRUCTURE T001L.
data : end of i_T001L.
data : wa_T001L like i_T001L.

data : begin of i_ZLOC_MAP occurs 0.
       INCLUDE STRUCTURE ZLOC_MAP.
data : end of i_ZLOC_MAP.
data : wa_ZLOC_MAP like i_ZLOC_MAP.
data : begin of i_resb occurs 0,
       matnr like resb-matnr,
       werks like resb-werks,
       lgort like resb-lgort,
       bdmng like resb-bdmng,
       enmng like resb-enmng,
       LOC_CODE like ZLOC_MAP-LOC_CODE,
       end of i_resb.
data : wa_resb like i_resb.
TYPES: BEGIN OF TY_AFPO_RESB,
         AUFNR TYPE AFPO-AUFNR,
         KDAUF TYPE AFPO-KDAUF,
         KDPOS TYPE AFPO-KDPOS,
         DAUAT TYPE AFPO-DAUAT,
         MATNR TYPE AFPO-MATNR,
         PSMNG TYPE AFPO-PSMNG,
         AMEIN TYPE AFPO-AMEIN,
         WEMNG TYPE AFPO-WEMNG,
         DWERK TYPE AFPO-DWERK,
         ELIKZ TYPE AFPO-ELIKZ,
         MEINS TYPE AFPO-MEINS,
         ERDAT TYPE CAUFV-ERDAT,
         ENMNG TYPE RESB-ENMNG,
         BDMNG TYPE RESB-BDMNG,
         SHKZG TYPE RESB-SHKZG,
         XLOEK TYPE RESB-XLOEK,
         RSNUM TYPE RESB-RSNUM,
         RSPOS TYPE RESB-RSPOS,
         LGORT TYPE AFPO-LGORT,       "" added by pavan 24.06.2024
         LOC_CODE like ZLOC_MAP-LOC_CODE,
       END OF TY_AFPO_RESB.
DATA : IT_AFPO_RESB TYPE TABLE OF TY_AFPO_RESB,
       WA_AFPO_RESB TYPE          TY_AFPO_RESB.


data : begin of i_tab occurs 0,
       LOC_CODE like ZLOC_MAP-LOC_CODE,
       matnr    like mseg-matnr,
       tot1_qty like mseg-menge,
       val_1r   like mseg-dmbtr,
       val_1l   like mseg-dmbtr,
       tot2_qty like mseg-menge,
       val_2r   like mseg-dmbtr,
       val_2l   like mseg-dmbtr,
       tot3_qty like mseg-menge,
       val_3r   like mseg-dmbtr,
       val_3l   like mseg-dmbtr,
       end of i_tab.
data : wa_tab like i_tab.

PARAMETERS : P_WERKS LIKE   mseg-werks,
             p_matnr like   mseg-matnr NO-DISPLAY.
SELECT-OPTIONS : s_matnr for mseg-matnr.
perform get_data.
perform proc_data.
perform get_fcat.
perform get_display.

*       val_1r   like mseg-dmbtr,
*       val_1l   like mseg-dmbtr,
*       tot2_qty like mseg-menge,
*       val_2r   like mseg-dmbtr,
*       val_2l   like mseg-dmbtr,
*       tot3_qty like mseg-menge,


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .

select mblnr mjahr zeile bwart matnr menge sjahr
       smbln smblp aufnr lgort from mseg into
       corresponding fields of table i_mseg
       where matnr in s_matnr and "= p_matnr and
             werks = p_werks and
             bwart in ( '261' , '262' ).
if sy-subrc eq 0.
   select aufnr from afpo into CORRESPONDING FIELDS OF table
                      i_afpo FOR ALL ENTRIES IN
                      i_mseg where aufnr = i_mseg-aufnr and
                                   elikz = ''.
endif.

select * from mard into CORRESPONDING FIELDS OF table
                    i_mard where matnr in s_matnr and  "= p_matnr and
                                 werks = p_werks.

select * from mslb into CORRESPONDING FIELDS OF table
                    i_mslb where matnr in s_matnr and "= p_matnr and
                                 werks = p_werks and
                                 lifnr ne ''.

select * from T001L into CORRESPONDING FIELDS OF table
                    i_T001L where  werks = p_werks.

select * from ZLOC_MAP into CORRESPONDING FIELDS OF table
                    i_ZLOC_MAP for all ENTRIES IN i_t001l
                      where  STRG_LOC = i_t001l-lgort.

i_mseg1[] = i_mseg[].
delete i_mseg1 where bwart = '261'.
loop at i_mseg into wa_mseg.
  move : wa_mseg-matnr to wa_mseg_sum-matnr.
  read table i_mseg1 into wa_mseg1
              with key matnr = wa_mseg-matnr .
  if sy-subrc eq 0.
  if wa_mseg-bwart = '262'.
     wa_mseg-menge = wa_mseg-menge * -1.
  endif.
  endif.
  read table i_afpo into wa_afpo
             with key aufnr = wa_mseg-aufnr.
  if sy-subrc eq 0.
  move : wa_mseg-menge to wa_mseg_sum-menge.
  read table i_ZLOC_MAP into wa_zloc_map with
                      key STRG_LOC = wa_mseg-lgort.
  if sy-subrc eq 0.
    move : wa_zloc_map-LOC_CODE to wa_mseg_sum-loc_code.
  endif.
  collect wa_mseg_sum into i_mseg_sum.
  endif.
  clear : wa_mseg, wa_mseg_sum.
  clear : wa_afpo.
endloop.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form proc_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROC_DATA .
loop at i_mard into wa_mard.
  read table i_ZLOC_MAP into wa_ZLOC_MAP
             with key STRG_LOC = wa_mard-lgort.
  if sy-subrc eq 0.
    move : wa_zloc_map-loc_code to wa_mard-loc_code.
    modify i_mard from wa_mard.
    clear : wa_mard.
  endif.
endloop.

loop at i_resb into wa_resb.
 read table i_ZLOC_MAP into wa_ZLOC_MAP
             with key STRG_LOC = wa_resb-lgort.
  if sy-subrc eq 0.
    move : wa_zloc_map-loc_code to wa_resb-loc_code.
    modify i_resb from wa_resb.
    clear : wa_resb.
  endif.
endloop.

loop at s_matnr.
 loop at i_zloc_map into wa_zloc_map.
  move : wa_zloc_map-LOC_CODE to wa_tab-LOC_CODE,
         s_matnr-low          to wa_tab-matnr.

  collect wa_tab into i_tab .
  clear : wa_tab.
endloop.
endloop.
data : t_qty like mseg-menge,
       t_qty1 like mseg-menge,
       t_qty2 like mseg-menge.

data : wa_mbew like mbew.
data : lv_cnt(10) type n.
loop at i_mslb into wa_mslb.
 wa_mslb1-lblab = wa_mslb-lblab + wa_mslb-lbins.
 move : wa_mslb-matnr to wa_mslb1-matnr.
 collect wa_mslb1 into  i_mslb1.
* collect wa_mseg_sum into i_mseg_sum.
endloop.
data : lv_flag(1) type c.

if i_tab[] is not INITIAL.
  select single * from mbew into wa_mbew where
                   matnr = p_matnr and
                   bwkey = p_werks.
  lv_cnt = 1.
  sort i_tab by matnr loc_code.
  loop at i_tab into wa_tab.
    at new matnr.
      lv_flag = 'X'.
    endat.
    if lv_flag  = 'X'.
       clear : lv_flag.
    clear : t_qty2.
    read table i_mslb1 into wa_mslb1
                 with key matnr = wa_tab-matnr.
    if sy-subrc eq 0.
      move : wa_mslb1-lblab to t_qty2.
      delete i_mslb1 where matnr = wa_tab-matnr.
    endif.
    endif.
     clear : wa_mbew.
     select single * from mbew into wa_mbew where
                   matnr = wa_tab-matnr and "p_matnr and
                   bwkey = p_werks.
    clear : t_qty, t_qty1 .
    loop at i_mard into wa_mard
                 where loc_code = wa_tab-loc_code and
                       matnr    = wa_tab-matnr.
    t_qty = t_qty + wa_mard-labst +
            wa_mard-insme + wa_mard-speme.
    endloop.

    read table i_mseg_sum into wa_mseg_sum
                 with key loc_code = wa_tab-loc_code
                          matnr    = wa_tab-matnr.
    if sy-subrc eq 0.
      move : wa_mseg_sum-menge to t_qty1.
    endif.

    move : t_qty  to wa_tab-tot1_qty,
           t_qty1 to wa_tab-tot2_qty,
           t_qty2 to wa_tab-tot3_qty.
           wa_tab-val_1r = wa_tab-tot1_qty * ( wa_mbew-salk3 / wa_mbew-lbkum ).
           wa_tab-val_1l = wa_tab-val_1r / 100000.

           wa_tab-val_2r = wa_tab-tot2_qty * ( wa_mbew-salk3 / wa_mbew-lbkum ).
           wa_tab-val_2l = wa_tab-val_2r / 100000.

           wa_tab-val_3r = wa_tab-tot3_qty * ( wa_mbew-salk3 / wa_mbew-lbkum ).
           wa_tab-val_3l = wa_tab-val_3r / 100000.

          modify i_tab from wa_tab.
          lv_cnt = lv_cnt + 1.
          clear : t_qty2 .
  endloop.
  endif.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_FCAT .
 PERFORM fcat USING :
                      '1'  'LOC_CODE '          'I_TAB'  'Location   '           '12' ,
                      '2'  'MATNR    '          'I_TAB'  'Material Code'         '12',

                      '4'  'TOT1_QTY'           'I_TAB'  'Total Stock'           '12',
                      '5'  'VAL_1R'             'I_TAB'  'Value in Rs.'          '15',
                      '6'  'VAL_1L'             'I_TAB'  'Value in Lac.'         '12',
                      '7'  'TOT2_QTY'           'I_TAB'  'WIP Stock    '         '12',
                      '8'  'VAL_2R'             'I_TAB'  'Value in Rs(WIP).'     '15',
                      '9'  'VAL_2L'             'I_TAB'  'Value in Lac(WIP).'    '12',
                      '10' 'TOT3_QTY'           'I_TAB'  'SUB CON Stock'         '15',
                      '11' 'VAL_3R'             'I_TAB'  'Value in Rs(SUB CON).' '15',
                      '12' 'VAL_3L'             'I_TAB'  'Value in Lac(SUB CON)' '12'.

ENDFORM.
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK      = ' '
*     I_BYPASSING_BUFFER     = ' '
*     I_BUFFER_ACTIVE        = ' '
      i_callback_program     = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
      i_callback_top_of_page = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = 'TOP-OF-PAGE'
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME       =
*     I_BACKGROUND_ID        = ' '
*     I_GRID_TITLE           =
*     I_GRID_SETTINGS        =
      is_layout              = wa_layout
      it_fieldcat            = it_fcat
*     IT_EXCLUDING           =
*     IT_SPECIAL_GROUPS      =
*     IT_SORT                =
*     IT_FILTER              =
*     IS_SEL_HIDE            =
*     I_DEFAULT              = 'X'
*     I_SAVE                 = ' '
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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab               = i_tab
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
