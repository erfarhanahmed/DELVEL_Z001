*&---------------------------------------------------------------------*
*& Report ZFI_CASHFLOW_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_CASHFLOW_REPORT_COPY.
tables: bseg,t001,setleaf,bkpf.
data : lv_opbal like bseg-dmbtr.
types: begin of ty_final,
       RBUKRS type bseg-BUKRS,
       gjahr type  bseg-gjahr,
*       belnr type acdoca-belnr,
*       racct type acdoca-racct,
       hsl  type   bseg-dmbtr,
*       DRCRK type acdoca-DRCRK,
       POPER type bkpf-MONAT,
       IOUT TYPE CHAR10,
       VAL TYPE SETLEAF-VALFROM,
       DESC TYPE T035T-TEXTL,
       end of ty_final.

data: it_final type table of ty_final,
      wa_final type ty_final.

types: begin of ty_finalf,
       particular type char50,
       first type bseg-dmbtr,
       second type bseg-dmbtr,
       third type bseg-dmbtr,
       fourth type bseg-dmbtr,
       fifth type bseg-dmbtr,
       sixth type bseg-dmbtr,
       seventh type bseg-dmbtr,
       eighth type bseg-dmbtr,
       nineth type bseg-dmbtr,
       tenth type bseg-dmbtr,
       eleven type bseg-dmbtr,
       twelve type bseg-dmbtr,
       fiscal type bseg-dmbtr,
       planb type bseg-dmbtr,

*       first type acdoca-hsl,
*       first type acdoca-hsl,
*       first type acdoca-hsl,
        color type char4,
       end of ty_finalf.

data: it_finalf type table of ty_finalf,
      wa_finalf type ty_finalf,
      wa_finalfi type ty_finalf,
      wa_finalfo type ty_finalf,
      wa_finalfob type ty_finalf,
      wa_finalfcg type ty_finalf,
      wa_finalfcb type ty_finalf.

DATA: IT_CASH TYPE TABLE OF zcashflow_table,
      WA_CASH TYPE zcashflow_table.

data: f1 type char1,
      f2 type char1,
      f3 type char1,
      f4 type char1,
      f5 type char1,
      f6 type char1,
      f7 type char1,
      f8 type char1,
      f9 type char1,
      f10 type char1,
      f11 type char1,
      f12 type char1.
*data: month type ISELLIST-MONTH.
ranges: r_budat for sy-datum.
ranges: r_budat1 for sy-datum.
ranges: r_setn for setleaf-SETNAME.
PARAMETERS: p_bukrs type t001-bukrs. " DEFAULT '1000'.
select-OPTIONS: s_hkont for bseg-hkont OBLIGATORY,
                s_monat for bkpf-monat no-display.
PARAMETERS: p_gjahr type bseg-gjahr OBLIGATORY.

SELECTION-SCREEN BEGIN OF BLOCK A .
*  PARAMETERS: R1 RADIOBUTTON GROUP A, "DISPLAY DATA
*              R2 RADIOBUTTON GROUP A. "MAINTAIN DATA
SELECTION-SCREEN END OF BLOCK A .
data: r_gjahr type gjahr.
DATA: D1 TYPE SY-DATUM,
      D2 TYPE SY-DATUM,
      D3 TYPE SY-DATUM,
      D4 TYPE SY-DATUM,
      D5 TYPE SY-DATUM,
      D6 TYPE SY-DATUM,
      D7 TYPE SY-DATUM,
      D8 TYPE SY-DATUM,
      D9 TYPE SY-DATUM,
      D10 TYPE SY-DATUM,
      D11 TYPE SY-DATUM,
      D12 TYPE SY-DATUM.


*at SELECTION-SCREEN on VALUE-REQUEST FOR s_monat-low.


*data: month type ISELLIST-MONTH.
*data: month1 type ISELLIST-MONTH.

*month = sy-datum+0(6).
*
*CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
*  EXPORTING
*    ACTUAL_MONTH                     = month
**   FACTORY_CALENDAR                 = ' '
**   HOLIDAY_CALENDAR                 = ' '
*   LANGUAGE                         = SY-LANGU
*   START_COLUMN                     = 8
*   START_ROW                        = 5
* IMPORTING
*   SELECTED_MONTH                   = month1
**   RETURN_CODE                      =
* EXCEPTIONS
*   FACTORY_CALENDAR_NOT_FOUND       = 1
*   HOLIDAY_CALENDAR_NOT_FOUND       = 2
*   MONTH_NOT_FOUND                  = 3
*   OTHERS                           = 4
*          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
* s_monat-low = month1+4(2).
* p_gjahr = month1+0(4).

*at SELECTION-SCREEN on VALUE-REQUEST FOR s_monat-high.


*data: month type ISELLIST-MONTH.
*data: month1 type ISELLIST-MONTH.

*month = sy-datum+0(6).
*
*CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
*  EXPORTING
*    ACTUAL_MONTH                     = month
**   FACTORY_CALENDAR                 = ' '
**   HOLIDAY_CALENDAR                 = ' '
*   LANGUAGE                         = SY-LANGU
*   START_COLUMN                     = 8
*   START_ROW                        = 5
* IMPORTING
*   SELECTED_MONTH                   = month1
**   RETURN_CODE                      =
* EXCEPTIONS
*   FACTORY_CALENDAR_NOT_FOUND       = 1
*   HOLIDAY_CALENDAR_NOT_FOUND       = 2
*   MONTH_NOT_FOUND                  = 3
*   OTHERS                           = 4
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
* s_monat-high = month1+4(2).

START-OF-SELECTION.

*IF R1 = 'X'.
PERFORM DISPLAY_DATA.
*ELSE.
***PERFORM MAINTAIN_DATA.
*ENDIF.


*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

data: date1 type sy-datum.
refresh: r_budat,r_setn.
data: pop type T009B-POPER.
    r_setn-LOW = 'PLANNING_GL_1'.
    r_setn-SIGN = 'I'.
    r_setn-OPTION = 'EQ'.
    APPEND r_setn.

    r_setn-LOW = 'PLANNING_GL_2'.
    r_setn-SIGN = 'I'.
    r_setn-OPTION = 'EQ'.
    APPEND r_setn.

    r_setn-LOW = 'PLANNING_GRP_1'.
    r_setn-SIGN = 'I'.
    r_setn-OPTION = 'EQ'.
    APPEND r_setn.

    r_setn-LOW = 'PLANNING_GRP_2'.
    r_setn-SIGN = 'I'.
    r_setn-OPTION = 'EQ'.
    APPEND r_setn.

if s_monat is not initial.

CLEAR R_GJAHR.
*IF S_MONAT-LOW GE 10.
*  r_gjahr = p_gjahr + 1.
*  ELSE.
*  r_gjahr = p_gjahr.
*ENDIF.
pop = S_MONAT-LOW.
  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = pop
   IMPORTING
     E_DATE               = r_budat-low.

*r_budat-low = |{ R_gjahr }{ s_monat-low }01|.

    DATA: DAY_START TYPE SY-DATUM.
    DATA: DAY_END TYPE SY-DATUM.
CLEAR R_GJAHR.
*IF S_MONAT-HIGH GE 10.
*  r_gjahr = p_gjahr + 1.
*  ELSE.
*  r_gjahr = p_gjahr.
*ENDIF.

pop = S_MONAT-HIGH.
  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = pop
   IMPORTING
     E_DATE               = DAY_sTART.
*day_start = |{ r_gjahr }{ s_monat-high }01|.
    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN            = DAY_START
      IMPORTING
        LAST_DAY_OF_MONTH = DAY_END.

r_budat-high = day_end.

*    r_budat-LOW = DAY_START.
*    r_budat-HIGH = DAY_END.
    r_budat-SIGN = 'I'.
    r_budat-OPTION = 'BT'.
    APPEND r_budat.


endif.
clear r_gjahr.
IF S_MONAT IS INITIAL.
r_gjahr = p_gjahr + 1.
    r_budat1-LOW = '00000000'.
    r_budat1-HIGH = '20250331'."DAY_START - 1.
*    31.07.2025
    r_budat1-SIGN = 'I'.
    r_budat1-OPTION = 'BT'.
    APPEND r_budat1.

ELSE.
DATE1 = |{ P_GJAHR }{ s_monat-low }01|.
DATE1 = DAY_START - 1.
    r_budat1-LOW = '00000000'.
    r_budat1-HIGH = DATE1.
    r_budat1-SIGN = 'I'.
    r_budat1-OPTION = 'BT'.
    APPEND r_budat1.

ENDIF.




*select
*RLDNR,
*RBUKRS,
*GJAHR,
*BELNR,
*DOCLN,BUDAT,HSL,DRCRK,GKONT,GKOAR,POPER,RACCT from acdoca into table @DATA(IT_ACDOCA) WHERE
*     GJAHR = @P_GJAHR
*  "AND augbl ne ''
*  and rbukrs = @p_bukrs and racct in @s_hkont
*   and gkont ne ' ' and budat in @r_budat and gkoar ne ' '.
*
data : begin of IT_ACDOCA occurs 0,
       RLDNR like acdoca-rldnr,
       RBUKRS like acdoca-rbukrs,
       GJAHR  like acdoca-gjahr,
       blart  like acdoca-blart,
       "DOCLN  like acdoca-docln,
       BUDAT  like acdoca-budat,
       HSL    like acdoca-hsl,
       DRCRK  like acdoca-drcrk ,
       POPER  like acdoca-poper,
       RACCT  like acdoca-racct,
       belnr  like acdoca-belnr,
       buzei  like acdoca-buzei,
       GKOAR  like acdoca-koart,
       gkont  like acdoca-gkont,
       cbttype like acdoca-cbttype,
       end of it_acdoca.
data : wa_acdoca1 like it_acdoca.
data : begin of it_acdoca1 occurs 0,
         belnr  like acdoca-belnr,
         GJAHR  like acdoca-GJAHR,
         RACCT  like acdoca-racct,
         HSL    like acdoca-hsl,
         DRCRK  like acdoca-drcrk ,
       end of it_acdoca1.
data : wa_acdoca2 like it_acdoca1.
data : begin of i_bseg occurs 0.
       include STRUCTURE bseg.
data : end of i_bseg.
data : wa_bseg like i_bseg.
data : begin of i_bkpf occurs 0,
       bukrs like bkpf-bukrs,
       belnr like bkpf-belnr,
       gjahr like bkpf-gjahr,
       end of i_bkpf.
data : wa_bkpf like i_bkpf.

select
  RLDNR
  RBUKRS
  GJAHR
  belnr
  blart
  HSL DRCRK POPER RACCT buzei gkont GKOAR cbttype
  from acdoca into CORRESPONDING FIELDS OF "BUDAT
  table  IT_ACDOCA WHERE
       GJAHR = P_GJAHR
          "AND gkont ne ''
          and rbukrs = p_bukrs
          and RLDNR = '0L'
          and racct in s_hkont.
    "and gkont ne s_hkont "and budat in @r_budat and gkoar ne ' '.
    "and budat in r_budat." and gkoar ne ' '.
if it_acdoca[] is not initial.
*  delete it_acdoca where blart = 'AB'
*                   and cbttype = 'RFCL' .
sort it_acdoca by belnr.
  loop at it_acdoca into wa_acdoca1 where blart = 'AB'..
    move : wa_ACDOCA1-belnr      to wa_acdoca2-belnr,
           wa_acdoca1-GJAHR      to wa_acdoca2-GJAHR,
           wa_ACDOCA1-racct+0(9) to wa_ACDOCA2-RACCT,
           wa_acdoca1-HSL        to wa_acdoca2-HSL.
  COLLECT  wa_acdoca2 into it_acdoca1.
  clear :  wa_acdoca2.
  endloop.
   delete it_acdoca1 where hsl ne 0.
if it_acdoca1[] is not initial.
  loop at it_acdoca into wa_acdoca1.
    read table it_acdoca1 into wa_acdoca2
                      with key belnr = wa_acdoca1-belnr
                               gjahr = wa_acdoca1-gjahr.
    if sy-subrc eq 0.
    clear : wa_acdoca1.
    modify it_acdoca from wa_acdoca1.
    endif.
  endloop.
  delete it_acdoca where belnr = ''.
endif.
*                   and racct = gkont.
*                   and racct+0(9) = gkont+0(9).


*  select bukrs belnr gjahr into corresponding fields of
*         table i_bkpf from bkpf for all entries in it_acdoca
*                       where bukrs = it_acdoca-rbukrs and
*                             belnr = it_acdoca-docnr and
*                             gjahr = it_acdoca-gjahr and
*                             blart = 'ZR'.
*  if sy-subrc eq 0.
*    loop at it_acdoca into wa_acdoca1.
*     read table i_bkpf with key bukrs = wa_acdoca1-rbukrs
*                                belnr = wa_acdoca1-docnr
*                                gjahr = wa_acdoca1-gjahr.
*     if sy-subrc eq 0.
*       clear : wa_acdoca1.
*       modify it_acdoca from wa_acdoca1.
*     endif.
*    endloop.
*    delete it_acdoca where docnr = ''.
*  endif.
*  select * from bseg into CORRESPONDING FIELDS OF
*           table i_bseg for all entries in it_acdoca
*           where bukrs = it_acdoca-rbukrs and
*                 belnr = it_acdoca-belnr  and
*                 buzei = it_acdoca-buzei .
*    if sy-subrc eq 0.
*      loop at it_acdoca into wa_acdoca1.
**        read table i_bseg into wa_bseg
**               with key bukrs = wa_acdoca1-rbukrs
**                        belnr = wa_acdoca1-belnr
**                        buzei = wa_acdoca1-buzei.
**        if sy-subrc eq 0.
**          move : wa_bseg-koart to wa_acdoca1-gkoar.
**          modify it_acdoca from wa_acdoca1.
**
**        endif.
**        clear : wa_acdoca1.
*        CALL FUNCTION 'GET_GKONT'
*       EXPORTING
*            BELNR           = wa_acdoca1-BELNR
*            BUKRS           = wa_acdoca1-rBUKRS
*            BUZEI           = wa_acdoca1-BUZEI
*            GJAHR           = wa_acdoca1-GJAHR
*            GKNKZ           = '3'
*       IMPORTING
*            GKONT           = wa_acdoca1-gkont "E_POSTAB-GKONT
*            KOART           = wa_acdoca1-gkoar "e_postab-zzgkart "E_POSTAB-GKART
*       EXCEPTIONS
*            BELNR_NOT_FOUND = 1
*            BUZEI_NOT_FOUND = 2
*            GKNKZ_NOT_FOUND = 3
*            OTHERS          = 4.
*  IF SY-SUBRC <> 0.
*  endif.
*      modify it_acdoca from wa_acdoca1.
*      endloop.
    endif.
*endif.

*""""""""""opening balance""""""""""""""""""""""""""
select BUKRS,HKONT,AUGDT,AUGBL,ZUONR,GJAHR,BELNR,BUZEI,BUDAT,SHKZG,DMBTR
  FROM BSIS INTO TABLE @DATA(IT_BSIS) WHERE BUKRS = @P_BUKRS AND HKONT IN @S_HKONT
  AND BUDAT IN @R_BUDAT1."and
**    blart ne 'ZR'.
"""

*  SELECT * FROM I_GLACCOUNTLINEITEMCUBE INTO TABLE @DATA(it_open) WHERE PostingDate in @R_BUDAT1 and BusinessTransactionType ne 'RFBC'
*                             and GLAccount in @S_HKONT and Ledger = '0L'.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '001'
   IMPORTING
     E_DATE               = D1.



  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '002'
   IMPORTING
     E_DATE               = D2.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '003'
   IMPORTING
     E_DATE               = D3.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '004'
   IMPORTING
     E_DATE               = D4.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '005'
   IMPORTING
     E_DATE               = D5.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '006'
   IMPORTING
     E_DATE               = D6.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '007'
   IMPORTING
     E_DATE               = D7.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '008'
   IMPORTING
     E_DATE               = D8.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '009'
   IMPORTING
     E_DATE               = D9.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '010'
   IMPORTING
     E_DATE               = D10.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '011'
   IMPORTING
     E_DATE               = D11.

  CALL FUNCTION 'FIRST_DAY_IN_PERIOD_GET'
    EXPORTING
      I_GJAHR              = P_GJAHR
      I_PERIV              = 'V3'
      I_POPER              = '012'
   IMPORTING
     E_DATE               = D12.




LOOP AT IT_BSIS INTO DATA(WA_BSIS).

lv_opbal = lv_opbal  + wa_bsis-dmbtr.
*if wa_bsis-shkzg = 'H'.
* wa_bsis-HSL = wa_bsis-HSL * -1.
*endif.
*clear : lv_opbal.
*LOOP AT IT_BSIS INTO DATA(WA_BSIS).
*  lv_opbal = lv_opbal  + wa_bsis-HSL.
*endloop.


IF WA_BSIS-BUDAT LT D1.
wa_finalfob-first = wa_finalfob-first + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D2.
wa_finalfob-second = wa_finalfob-second + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D3.
wa_finalfob-third = wa_finalfob-third + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D4.
wa_finalfob-fourth = wa_finalfob-fourth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D5.
wa_finalfob-fifth = wa_finalfob-fifth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D6.
wa_finalfob-sixth = wa_finalfob-sixth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D7.
wa_finalfob-seventh = wa_finalfob-seventh + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D8.
wa_finalfob-eighth = wa_finalfob-eighth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D9.
wa_finalfob-nineth = wa_finalfob-nineth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D10.
wa_finalfob-tenth = wa_finalfob-tenth + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D11.
 wa_finalfob-eleven = wa_finalfob-eleven + wa_bsis-dmbtr.
ENDIF.
IF WA_BSIS-BUDAT LT D12.
 wa_finalfob-twelve = wa_finalfob-twelve + wa_bsis-dmbtr.
ENDIF.

ENDLOOP.
wa_finalfob-PARTICULAR = 'Opening Balance'.
wa_finalfob-fiscal = wa_finalfob-first. " + wa_finalfob-second + wa_finalfob-third +
*  wa_finalfob-fourth + wa_finalfob-fifth + wa_finalfob-sixth + wa_finalfob-seventh
*  + wa_finalfob-eighth + wa_finalfob-nineth + wa_finalfob-tenth +  wa_finalfob-eleven
*  +  wa_finalfob-twelve.
append wa_finalfob to it_finalf. "opening balance
*clear wa_finalf.
"""""""""""

if it_acdoca[] is not initial.
data(it_customer) = it_acdoca[].
data(it_vendor) = it_acdoca[].
data(it_gl) = it_acdoca[].

delete it_customer where GKOAR ne 'D'.
delete it_vendor where GKOAR ne 'K'.
delete it_gl where GKOAR ne 'S'.

if it_customer is not initial.
select * from knb1 into table @data(it_knb1) FOR ALL ENTRIES IN @it_customer
   where bukrs = @p_bukrs and kunnr = @it_customer-gkont.

if it_knb1 is not initial.

 select * from t035t into table @data(it_t035t) for all entries in
   @it_knb1 where spras = 'E' and grupp = @it_knb1-FDGRV.

endif.
endif.

if it_vendor is not initial.
select * from lfb1 into table @data(it_lfb1) FOR ALL ENTRIES IN @it_vendor
   where bukrs = @p_bukrs and lifnr = @it_vendor-gkont.
if it_lfb1 is not initial.

 select * from t035t appending table it_t035t for all entries in
   it_lfb1 where spras = 'E' and grupp = it_lfb1-FDGRV.

endif.
endif.

if it_gl is not initial.
select * from skb1 into table @data(it_skb1) FOR ALL ENTRIES IN @it_gl
   where bukrs = @p_bukrs and saknr = @it_gl-gkont.
 if it_skb1 is not initial.
 select * from t036t into table @data(it_t036t) for all entries in
   @it_skb1 where spras = 'E' and EBENE = @it_skb1-FDLEV.
 endif.
endif.
endif.
*delete it_acdoca where gkoar = ' '.
loop at it_acdoca into data(wa_acdoca).

MOVE-CORRESPONDING WA_ACDOCA TO WA_FINAL.
*
*if wa_acdoca-GKOAR is INITIAL.
* IF wa_acdoca-drcrk = 'S'.
*     wa_final-iout = 'INWARD'.
*    ELSE.
*       wa_final-iout = 'OUTWARD'.
*    ENDIF.
*  endif.

if wa_acdoca-GKOAR = 'D'.
  if sy-subrc = 0.
   IF wa_acdoca-drcrk = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF."customer
  read table it_knb1 into data(wa_knb1) with key kunnr = wa_acdoca-gkont.
*     if sy-subrc = 0.

    read table it_t035t into data(wa_t035t) with key GRUPP = wa_knb1-FDGRV.
    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T035T-TEXTL.
    endif.
  endif.
elseif wa_acdoca-GKOAR = 'K'.
   IF wa_acdoca-drcrk = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF. "vendor
  read table it_lfb1 into data(wa_lfb1) with key lifnr = wa_acdoca-gkont.
read table it_t035t into wa_t035t with key GRUPP = wa_lfb1-FDGRV.

    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T035T-TEXTL.
    endif.

elseif wa_acdoca-GKOAR = 'S'. "GL

   read table it_skb1 into data(wa_skb1) with key saknr = wa_acdoca-gkont.
    IF wa_acdoca-drcrk = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF.
   read table it_t036t into data(wa_t036t) with key EBENE = wa_skb1-FDLEV.
    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T036T-LTEXT.
    endif.

endif.

collect wa_final into it_final.
*clear: wa_final,wa_skb1,wa_setleaf,wa_acdoca,wa_setlinet.
 clear: wa_final,wa_skb1,wa_acdoca.
endloop.


data aflag type char1.

data: k type i.
*sort it_final stable by poper
data: desc type char50.
data: desc1 type char50.
sort it_final stable by iout desc poper.

""""logic for opening balance.


""""""""""""""""""""""""
clear wa_finalf.
wa_finalf-particular = 'Cash Inflow'.
WA_finalf-color = 'C600'.
append wa_finalf to it_finalf.
clear wa_finalf.


DATA: lv_amt TYPE dmbtr.
LOOP AT it_final INTO DATA(wa_tem) WHERE iout = ' ' and  POPER = '00'.
 lv_amt = lv_amt + wa_tem-HSL.
CLEAR: wa_tem.
ENDLOOP.

 READ TABLE it_finalf INTO DATA(wa_tem2) WITH key  PARTICULAR = 'Opening Balance'.
  IF sy-subrc = 0.
wa_finalfob-FIRST = lv_amt.
MODIFY it_finalf FROM wa_finalfob TRANSPORTING FIRST WHERE PARTICULAR = 'Opening Balance'  .
  ENDIF.
CLEAR: lv_amt.


delete it_final where iout = ' '.
data(it_finalin) = it_final[].
data(it_finalout) = it_final[].
delete it_finalin where iout = 'OUTWARD'.
delete it_finalout where iout = 'INWARD'.

loop at it_finalin into wa_final ."where IOUT = 'INWARD'.
 desc = wa_final-desc.
at first.
 desc1 = desc.
endat.

if desc1 ne wa_final-desc.
 desc1 = wa_final-desc.
""""
wa_finalfi-first = wa_finalfi-first + wa_finalf-first.
wa_finalfi-second = wa_finalfi-second + wa_finalf-second.
wa_finalfi-third = wa_finalfi-third + wa_finalf-third.
wa_finalfi-fourth = wa_finalfi-fourth + wa_finalf-fourth.
wa_finalfi-fifth = wa_finalfi-fifth + wa_finalf-fifth.
wa_finalfi-SIXTH = wa_finalfi-SIXTH + wa_finalf-SIXTH.
wa_finalfi-SEVENTH = wa_finalfi-SEVENTH + wa_finalf-SEVENTH.
wa_finalfi-EIGHTH = wa_finalfi-EIGHTH + wa_finalf-EIGHTH.
wa_finalfi-NINETH = wa_finalfi-NINETH + wa_finalf-NINETH.
wa_finalfi-tenth = wa_finalfi-tenth + wa_finalf-tenth.
wa_finalfi-ELEVEN = wa_finalfi-ELEVEN + wa_finalf-ELEVEN.
wa_finalfi-TWELVE = wa_finalfi-TWELVE + wa_finalf-TWELVE.

wa_finalf-fiscal = wa_finalf-first + wa_finalf-second + wa_finalf-third +
  wa_finalf-fourth + wa_finalf-fifth + wa_finalf-sixth + wa_finalf-seventh
  + wa_finalf-eighth + wa_finalf-nineth + wa_finalf-tenth +  wa_finalf-eleven
  +  wa_finalf-twelve.
append wa_finalf to it_finalf.
 clear wa_finalf.
endif.

wa_finalf-PARTICULAR = wa_final-desc.
case wa_final-poper.

when 1.
wa_finalf-first = wa_final-hsl.
f1 = 'X'.
when 2.
wa_finalf-second = wa_final-hsl.
f2 = 'X'.
when 3.
wa_finalf-third = wa_final-hsl.
f3 = 'X'.
when 4.
wa_finalf-fourth = wa_final-hsl.
f4 = 'X'.
when 5.
wa_finalf-fifth = wa_final-hsl.
f5 = 'X'.
when 6.
wa_finalf-SIXTH = wa_final-hsl.
f6 = 'X'.
when 7.
wa_finalf-SEVENTH = wa_final-hsl.
f7 = 'X'.
when 8.
wa_finalf-EIGHTH = wa_final-hsl.
f8 = 'X'.
when 9.
wa_finalf-NINETH = wa_final-hsl.
f9 = 'X'.
when 10.
wa_finalf-tenth = wa_final-hsl.
f10 = 'X'.
when 11.
wa_finalf-ELEVEN = wa_final-hsl.
f11 = 'X'.
when 12.
wa_finalf-TWELVE = wa_final-hsl.
f12 = 'X'.
endcase.

k = k + 1.

at last.

wa_finalfi-first = wa_finalfi-first + wa_finalf-first.
wa_finalfi-second = wa_finalfi-second + wa_finalf-second.
wa_finalfi-third = wa_finalfi-third + wa_finalf-third.
wa_finalfi-fourth = wa_finalfi-fourth + wa_finalf-fourth.
wa_finalfi-fifth = wa_finalfi-fifth + wa_finalf-fifth.
wa_finalfi-SIXTH = wa_finalfi-SIXTH + wa_finalf-SIXTH.
wa_finalfi-SEVENTH = wa_finalfi-SEVENTH + wa_finalf-SEVENTH.
wa_finalfi-EIGHTH = wa_finalfi-EIGHTH + wa_finalf-EIGHTH.
wa_finalfi-NINETH = wa_finalfi-NINETH + wa_finalf-NINETH.
wa_finalfi-tenth = wa_finalfi-tenth + wa_finalf-tenth.
wa_finalfi-ELEVEN = wa_finalfi-ELEVEN + wa_finalf-ELEVEN.
wa_finalfi-TWELVE = wa_finalfi-TWELVE + wa_finalf-TWELVE.

wa_finalf-fiscal = wa_finalf-first + wa_finalf-second + wa_finalf-third +
  wa_finalf-fourth + wa_finalf-fifth + wa_finalf-sixth + wa_finalf-seventh
  + wa_finalf-eighth + wa_finalf-nineth + wa_finalf-tenth +  wa_finalf-eleven
  +  wa_finalf-twelve.
append wa_finalf to it_finalf.
 clear wa_finalf.

endat.
endloop.
wa_finalfi-particular = 'Total Cash Inflow'.

wa_finalfi-fiscal = wa_finalfi-first + wa_finalfi-second + wa_finalfi-third +
  wa_finalfi-fourth + wa_finalfi-fifth + wa_finalfi-sixth + wa_finalfi-seventh
  + wa_finalfi-eighth + wa_finalfi-nineth + wa_finalfi-tenth +  wa_finalfi-eleven
  +  wa_finalfi-twelve.
wa_finalfi-color = 'C300'.
append wa_finalfi to it_finalf.
*clear wa_finalfi.
"""OUTWARD"""

clear wa_finalf.
wa_finalf-particular = 'Cash Outflow'.
WA_finalf-color = 'C600'.
append wa_finalf to it_finalf.
clear wa_finalf.

loop at it_finalout into wa_final. " where IOUT = 'OUTWARD'.
 desc = wa_final-desc.
at first.
 desc1 = desc.
endat.

if desc1 ne wa_final-desc.
 desc1 = wa_final-desc.

wa_finalfo-first = wa_finalfo-first + wa_finalf-first.
wa_finalfo-second = wa_finalfo-second + wa_finalf-second.
wa_finalfo-third = wa_finalfo-third + wa_finalf-third.
wa_finalfo-fourth = wa_finalfo-fourth + wa_finalf-fourth.
wa_finalfo-fifth = wa_finalfo-fifth + wa_finalf-fifth.
wa_finalfo-SIXTH = wa_finalfo-SIXTH + wa_finalf-SIXTH.
wa_finalfo-SEVENTH = wa_finalfo-SEVENTH + wa_finalf-SEVENTH.
wa_finalfo-EIGHTH = wa_finalfo-EIGHTH + wa_finalf-EIGHTH.
wa_finalfo-NINETH = wa_finalfo-NINETH + wa_finalf-NINETH.
wa_finalfo-tenth = wa_finalfo-tenth + wa_finalf-tenth.
wa_finalfo-ELEVEN = wa_finalfo-ELEVEN + wa_finalf-ELEVEN.
wa_finalfo-TWELVE = wa_finalfo-TWELVE + wa_finalf-TWELVE.

wa_finalf-fiscal = wa_finalf-first + wa_finalf-second + wa_finalf-third +
  wa_finalf-fourth + wa_finalf-fifth + wa_finalf-sixth + wa_finalf-seventh
  + wa_finalf-eighth + wa_finalf-nineth + wa_finalf-tenth +  wa_finalf-eleven
  +  wa_finalf-twelve.

append wa_finalf to it_finalf.
 clear wa_finalf.
endif.

wa_finalf-PARTICULAR = wa_final-desc.
case wa_final-poper.

when 1.
wa_finalf-first = wa_final-hsl.
f1 = 'X'.
when 2.
wa_finalf-second = wa_final-hsl.
f2 = 'X'.
when 3.
wa_finalf-third = wa_final-hsl.
f3 = 'X'.
when 4.
wa_finalf-fourth = wa_final-hsl.
f4 = 'X'.
when 5.
wa_finalf-fifth = wa_final-hsl.
f5 = 'X'.
when 6.
wa_finalf-SIXTH = wa_final-hsl.
f6 = 'X'.
when 7.
wa_finalf-SEVENTH = wa_final-hsl.
f7 = 'X'.
when 8.
wa_finalf-EIGHTH = wa_final-hsl.
f8 = 'X'.
when 9.
wa_finalf-NINETH = wa_final-hsl.
f9 = 'X'.
when 10.
wa_finalf-tenth = wa_final-hsl.
f10 = 'X'.
when 11.
wa_finalf-ELEVEN = wa_final-hsl.
f11 = 'X'.
when 12.
wa_finalf-TWELVE = wa_final-hsl.
f12 = 'X'.
endcase.

k = k + 1.

at last.

wa_finalfo-first = wa_finalfo-first + wa_finalf-first.
wa_finalfo-second = wa_finalfo-second + wa_finalf-second.
wa_finalfo-third = wa_finalfo-third + wa_finalf-third.
wa_finalfo-fourth = wa_finalfo-fourth + wa_finalf-fourth.
wa_finalfo-fifth = wa_finalfo-fifth + wa_finalf-fifth.
wa_finalfo-SIXTH = wa_finalfo-SIXTH + wa_finalf-SIXTH.
wa_finalfo-SEVENTH = wa_finalfo-SEVENTH + wa_finalf-SEVENTH.
wa_finalfo-EIGHTH = wa_finalfo-EIGHTH + wa_finalf-EIGHTH.
wa_finalfo-NINETH = wa_finalfo-NINETH + wa_finalf-NINETH.
wa_finalfo-tenth = wa_finalfo-tenth + wa_finalf-tenth.
wa_finalfo-ELEVEN = wa_finalfo-ELEVEN + wa_finalf-ELEVEN.
wa_finalfo-TWELVE = wa_finalfo-TWELVE + wa_finalf-TWELVE.

wa_finalf-fiscal = wa_finalf-first + wa_finalf-second + wa_finalf-third +
  wa_finalf-fourth + wa_finalf-fifth + wa_finalf-sixth + wa_finalf-seventh
  + wa_finalf-eighth + wa_finalf-nineth + wa_finalf-tenth +  wa_finalf-eleven
  +  wa_finalf-twelve.

append wa_finalf to it_finalf.
 clear wa_finalf.

endat.
endloop.

wa_finalfo-particular = 'Total Cash Outflow'.
wa_finalfo-fiscal = wa_finalfo-first + wa_finalfo-second + wa_finalfo-third +
  wa_finalfo-fourth + wa_finalfo-fifth + wa_finalfo-sixth + wa_finalfo-seventh
  + wa_finalfo-eighth + wa_finalfo-nineth + wa_finalfo-tenth +  wa_finalfo-eleven
  +  wa_finalfo-twelve.
wa_finalfo-color = 'C300'.
append wa_finalfo to it_finalf.

"""""""""""""""""""""""""
wa_finalfcg-particular = 'Cash Generated'.
wa_finalfcg-first = wa_finalfi-first + wa_finalfo-first.
wa_finalfcg-second = wa_finalfi-second + wa_finalfo-second.
wa_finalfcg-third = wa_finalfi-third + wa_finalfo-third.
wa_finalfcg-fourth = wa_finalfi-fourth + wa_finalfo-fourth.
wa_finalfcg-fifth = wa_finalfi-fifth + wa_finalfo-fifth.
wa_finalfcg-sixth = wa_finalfi-sixth + wa_finalfo-sixth.
wa_finalfcg-seventh = wa_finalfi-seventh + wa_finalfo-seventh.
wa_finalfcg-eighth = wa_finalfi-eighth + wa_finalfo-eighth.
wa_finalfcg-nineth = wa_finalfi-nineth + wa_finalfo-nineth.
wa_finalfcg-tenth = wa_finalfi-tenth + wa_finalfo-tenth.
wa_finalfcg-eleven = wa_finalfi-eleven + wa_finalfo-eleven.
wa_finalfcg-twelve = wa_finalfi-twelve + wa_finalfo-twelve.

wa_finalfcg-fiscal = wa_finalfcg-first + wa_finalfcg-second + wa_finalfcg-third +
  wa_finalfcg-fourth + wa_finalfcg-fifth + wa_finalfcg-sixth + wa_finalfcg-seventh
  + wa_finalfcg-eighth + wa_finalfcg-nineth + wa_finalfcg-tenth +  wa_finalfcg-eleven
  +  wa_finalfcg-twelve.
wa_finalfcg-color = 'C100'.
append wa_finalfcg to it_finalf.
*clear wa_finalfcg.

""""""""""""""""""""

wa_finalfcb-particular = 'Closing Balance'.
wa_finalfcb-first = wa_finalfcg-first + wa_finalfob-first.
wa_finalfob-second = wa_finalfcb-first.
wa_finalfcb-second = wa_finalfcg-second + wa_finalfob-second.
wa_finalfob-third = wa_finalfcb-second.
wa_finalfcb-third = wa_finalfcg-third + wa_finalfob-third.
wa_finalfob-fourth = wa_finalfcb-third.
wa_finalfcb-fourth = wa_finalfcg-fourth + wa_finalfob-fourth.
wa_finalfob-fifth = wa_finalfcb-fourth.
wa_finalfcb-fifth = wa_finalfcg-fifth + wa_finalfob-fifth.
wa_finalfob-sixth = wa_finalfcb-fifth.
wa_finalfcb-sixth = wa_finalfcg-sixth + wa_finalfob-sixth.
wa_finalfob-seventh = wa_finalfcb-sixth.
wa_finalfcb-seventh = wa_finalfcg-seventh + wa_finalfob-seventh.
wa_finalfob-eighth = wa_finalfcb-seventh.
wa_finalfcb-eighth = wa_finalfcg-eighth + wa_finalfob-eighth.
wa_finalfob-nineth = wa_finalfcb-eighth.
wa_finalfcb-nineth = wa_finalfcg-nineth + wa_finalfob-nineth.
wa_finalfob-tenth = wa_finalfcb-nineth.
wa_finalfcb-tenth = wa_finalfcg-tenth + wa_finalfob-tenth.
wa_finalfob-eleven = wa_finalfcb-tenth.
wa_finalfcb-eleven = wa_finalfcg-eleven + wa_finalfob-eleven.
wa_finalfob-twelve = wa_finalfcb-eleven.
wa_finalfcb-twelve = wa_finalfcg-twelve + wa_finalfob-twelve.


wa_finalfcb-fiscal = "wa_finalfcb-first + wa_finalfcb-second + wa_finalfcb-third +
*  wa_finalfcb-fourth + wa_finalfcb-fifth + wa_finalfcb-sixth + wa_finalfcb-seventh
*  + wa_finalfcb-eighth + wa_finalfcb-nineth + wa_finalfcb-tenth +  wa_finalfcb-eleven
*  +
wa_finalfcb-twelve.
wa_finalfcb-color = 'C500'.
append wa_finalfcb to it_finalf.
*clear wa_finalfcb.



"opening balance" corrrection
*wa_finalfob-PARTICULAR = 'Opening Balance'.
read table it_finalf ASSIGNING FIELD-SYMBOL(<fs>) with key PARTICULAR = 'Opening Balance'.
if <fs> is ASSIGNED.
<fs>-second = wa_finalfcb-first.
<fs>-third = wa_finalfcb-second.
<fs>-fourth = wa_finalfcb-third.
<fs>-fifth = wa_finalfcb-fourth.
<fs>-sixth = wa_finalfcb-fifth.
<fs>-seventh = wa_finalfcb-sixth.
<fs>-eighth = wa_finalfcb-seventh.
<fs>-nineth = wa_finalfcb-eighth.
<fs>-tenth = wa_finalfcb-nineth.
<fs>-eleven = wa_finalfcb-tenth.
<fs>-twelve = wa_finalfcb-eleven.
<fs>-color = 'C100'.
<fs>-fiscal = <fs>-first. " + <fs>-second + <fs>-third +
*  <fs>-fourth + <fs>-fifth + <fs>-sixth + <fs>-seventh
*  + <fs>-eighth + <fs>-nineth + <fs>-tenth +  <fs>-eleven
*  +  <fs>-twelve.

UNASSIGN <fs>.
endif.

"closing balance" correction

read table it_finalf ASSIGNING <fs> with key PARTICULAR = 'Closing Balance'.
if <fs> is ASSIGNED.
  read table it_finalf into data(w1) with key PARTICULAR = 'Opening Balance'.
  read table it_finalf into data(w2) with key PARTICULAR = 'Cash Generated'.

<fs>-second = w1-second + w2-second.
<fs>-third = w1-third + w2-third.
<fs>-fourth = w1-fourth + w2-fourth.
<fs>-fifth = w1-fifth + w2-fifth.
<fs>-sixth = w1-sixth + w2-sixth.
<fs>-seventh = w1-seventh + w2-seventh.
<fs>-eighth = w1-eighth + w2-eighth.
<fs>-nineth = w1-nineth + w2-nineth.
<fs>-tenth = w1-tenth + w2-tenth.
<fs>-eleven = w1-eleven + w2-eleven.
<fs>-twelve = w1-twelve + w2-twelve.

<fs>-fiscal = "<fs>-first + <fs>-second + <fs>-third +
*  <fs>-fourth + <fs>-fifth + <fs>-sixth + <fs>-seventh
*  + <fs>-eighth + <fs>-nineth + <fs>-tenth +  <fs>-eleven
*  +
   <fs>-twelve.

UNASSIGN <fs>.
endif.

*loop at it_finalf ASSIGNING <fs> .
*read table it_plan into data(wa_plan) with key particular = <fs>-particular gjahr = p_gjahr.
*if sy-subrc = 0.
*if '01' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zfirst.
*endif.
*if '02' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zsecond.
*endif.
*if '03' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zthird.
*endif.
*if '04' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zfourth.
*endif.
*if '05' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zfifth.
*endif.
*if '06' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zsixth.
*endif.
*if '07' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zseventh.
*endif.
*if '08' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zeighth.
*endif.
*if '09' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-znineth.
*endif.
*if '10' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-ztenth.
*endif.
*if '11' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-zeleven.
*endif.
*if '12' in s_monat.
*  <fs>-planb = <fs>-planb + wa_plan-ztwelve.
*endif.
*endif.
*endloop.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       ls_layout   TYPE slis_layout_alv.

ls_layout-colwidth_optimize = 'X'.
*ls_layout-zebra = 'X'.
ls_layout-INFO_FIELDNAME = 'COLOR'.

  DATA lv_col TYPE i.
DATA: first type char15,
      second type char15,
      third type char15,
      fourth type char15,
      fifth type char15,
      sixth type char15,
      seventh type char15,
      eighth type char15,
      nineth type char15,
      tenth type char15,
      eleven type char15,
      twelve type char15,
      thirteen type char20,
      fourteen type char20.

*first = |Apr-{ p_gjahr+2(2) }|.
*first = |Apr-{ p_gjahr+2(2) }|.

lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'PARTICULAR'.
  it_fieldcat-seltext_m = 'Particulars'.
  APPEND it_fieldcat.
  clear it_fieldcat.


if '01' in s_monat.
first = |Apr-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'FIRST'.
  it_fieldcat-seltext_m = first.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.

if '02' in s_monat.
second = |May-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'SECOND'.
  it_fieldcat-seltext_m = second.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.

if '03' in s_monat.
third = |Jun-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'THIRD'.
  it_fieldcat-seltext_m = third.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.

if '04' in s_monat.
fourth = |Jul-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'FOURTH'.
  it_fieldcat-seltext_m = fourth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '05' in s_monat.
fifth = |Aug-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'FIFTH'.
  it_fieldcat-seltext_m = fifth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '06' in s_monat.
sixth = |Sep-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'SIXTH'.
  it_fieldcat-seltext_m = sixth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '07' in s_monat.
seventh = |Oct-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'SEVENTH'.
  it_fieldcat-seltext_m = seventh.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '08' in s_monat.
eighth = |Nov-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'EIGHTH'.
  it_fieldcat-seltext_m = eighth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '09' in s_monat.
nineth = |Dec-{ p_gjahr+2(2) }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'NINETH'.
  it_fieldcat-seltext_m = nineth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


if '10' in s_monat.
tenth = |Jan-{ p_gjahr+2(2) + 1 }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'TENTH'.
  it_fieldcat-seltext_m = tenth.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.

if '11' in s_monat.
eleven = |Feb-{ p_gjahr+2(2) + 1 }|.
lv_col = lv_col + 1.
   it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'ELEVEN'.
  it_fieldcat-seltext_m = eleven.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.

if '12' in s_monat.
twelve = |Mar-{ p_gjahr+2(2) + 1 }|.
lv_col = lv_col + 1.
  it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'TWELVE'.
  it_fieldcat-seltext_m = twelve.
  APPEND it_fieldcat.
  clear it_fieldcat.
endif.


thirteen = |Fiscal Year-{ p_gjahr }|.
lv_col = lv_col + 1.
  it_fieldcat-col_pos = lv_col.
  it_fieldcat-fieldname = 'FISCAL'.
  it_fieldcat-seltext_l = thirteen.
  APPEND it_fieldcat.
  clear it_fieldcat.

*Fourteen = |Plan Budget-{ p_gjahr }|.
*lv_col = lv_col + 1.
*  it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'PLANB'.
*  it_fieldcat-seltext_l = Fourteen.
*  APPEND it_fieldcat.
*  clear it_fieldcat.


 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     i_callback_program                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
     IS_LAYOUT                         =  LS_LAYOUT
     it_fieldcat                       = it_fieldcat[]
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
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          =  it_finalf
   EXCEPTIONS
     program_error                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form MAINTAIN_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
**FORM MAINTAIN_DATA .


***call TRANSACTION 'ZCASHFLOW_MAINTAIN'.
*SELECT * FROM zcashflow_table into table it_cash
*  where gjahr = p_gjahr.
*
*
*
*
*
*
*DATA:  it_fieldcat TYPE TABLE OF slis_fieldcat_alv WITH HEADER LINE,
*       ls_layout   TYPE slis_layout_alv.
*
**ls_layout-colwidth_optimize = 'X'.
*ls_layout-zebra = 'X'.
*
*
*  DATA lv_col TYPE i.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'GJAHR'.
*  it_fieldcat-seltext_m = 'Fiscal Year'.
*  it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 10.
*
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'PARTICULAR'.
*  it_fieldcat-seltext_m = 'Particulars'.
*  it_fieldcat-edit = 'X'.
*    it_fieldcat-INTLEN = 30.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'FIRST'.
*  it_fieldcat-seltext_m = 'Period 1'.
*  it_fieldcat-DATATYPE = 'QUAN'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'SECOND'.
*  it_fieldcat-seltext_m = 'Period 2'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'THIRD'.
*  it_fieldcat-seltext_m = 'Period 3'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'FOURTH'.
*  it_fieldcat-seltext_m = 'Period 4'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'FIFTH'.
*  it_fieldcat-seltext_m = 'Period 5'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'SIXTH'.
*  it_fieldcat-seltext_m = 'Period 6'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'SEVENTH'.
*  it_fieldcat-seltext_m = 'Period 7'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'EIGHTH'.
*  it_fieldcat-seltext_m = 'Period 8'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'NINETH'.
*  it_fieldcat-seltext_m = 'Period 9'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'TENTH'.
*  it_fieldcat-seltext_m = 'Period 10'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*   it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'ELEVEN'.
*  it_fieldcat-seltext_m = 'Period 11'.
*    it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
*lv_col = lv_col + 1.
*  it_fieldcat-col_pos = lv_col.
*  it_fieldcat-fieldname = 'TWELVE'.
*  it_fieldcat-seltext_m = 'Period 12'.
*  it_fieldcat-edit = 'X'.
*  it_fieldcat-INTLEN = 15.
*  APPEND it_fieldcat.
*  clear it_fieldcat.
*
**lv_col = lv_col + 1.
**  it_fieldcat-col_pos = lv_col.
**  it_fieldcat-fieldname = 'FISCAL'.
**  it_fieldcat-seltext_l = thirteen.
**  APPEND it_fieldcat.
**  clear it_fieldcat.
**
* CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*   EXPORTING
**   I_INTERFACE_CHECK                 = ' '
**   I_BYPASSING_BUFFER                = ' '
**   I_BUFFER_ACTIVE                   = ' '
*     i_callback_program                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS'
*   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
**   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE'
**   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**   I_CALLBACK_HTML_END_OF_LIST       = ' '
**   I_STRUCTURE_NAME                  =
**   I_BACKGROUND_ID                   = ' '
**   I_GRID_TITLE                      =
**   I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =  LS_LAYOUT
*     it_fieldcat                       = it_fieldcat[]
**   IT_EXCLUDING                      =
**   IT_SPECIAL_GROUPS                 =
**   IT_SORT                           =
**   IT_FILTER                         =
**   IS_SEL_HIDE                       =
**   I_DEFAULT                         = 'X'
**   I_SAVE                            = ' '
**   IS_VARIANT                        =
**   IT_EVENTS                         =
**   IT_EVENT_EXIT                     =
**   IS_PRINT                          =
**   IS_REPREP_ID                      =
**   I_SCREEN_START_COLUMN             = 0
**   I_SCREEN_START_LINE               = 0
**   I_SCREEN_END_COLUMN               = 0
**   I_SCREEN_END_LINE                 = 0
**   I_HTML_HEIGHT_TOP                 = 0
**   I_HTML_HEIGHT_END                 = 0
**   IT_ALV_GRAPHICS                   =
**   IT_HYPERLINK                      =
**   IT_ADD_FIELDCAT                   =
**   IT_EXCEPT_QINFO                   =
**   IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**   E_EXIT_CAUSED_BY_CALLER           =
**   ES_EXIT_CAUSED_BY_USER            =
*    TABLES
*      t_outtab                          =  it_cash
*   EXCEPTIONS
*     program_error                     = 1
*     OTHERS                            = 2
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
***ENDFORM.

FORM USER_COMMAND USING R_UCOMM LIKE SY-UCOMM
                        RS_SELFIELD TYPE SLIS_SELFIELD.



if r_ucomm = 'APPEND'.
APPEND WA_CASH TO IT_CASH.

elseif r_ucomm = 'DELE'.
 DELETE IT_CASH INDEX RS_SELFIELD-TABINDEX.
elseif r_ucomm = 'SAVE'.
 MODIFY zcashflow_table FROM TABLE IT_CASH.
endif.

rs_selfield-refresh = 'X'.

ENDFORM.


FORM PF_STATUS USING RT_EXTAB TYPE SLIS_T_EXTAB.

SET PF-STATUS 'Z0001'." EXCLUDING RT_EXTAB.

ENDFORM. "PF_STATUS.


*Selection texts
*----------------------------------------------------------
* P_BUKRS         Company Code
* P_GJAHR         Fiscal Year
* R1         Display Data
* R2         Maintain Data
* S_HKONT         GL Account
* S_MONAT         Period
