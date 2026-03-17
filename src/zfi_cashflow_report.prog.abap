*&---------------------------------------------------------------------*
*& Report ZFI_CASHFLOW_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_CASHFLOW_REPORT.
tables: bseg,t001,setleaf,bkpf.
data : lv_opbal like bseg-dmbtr.
types: begin of ty_final,
       BUKRS type bseg-BUKRS,
       gjahr type  bseg-gjahr,
*       belnr type acdoca-belnr,
*       racct type acdoca-racct,
       dmbtr  type   bseg-dmbtr,
*       DRCRK type acdoca-DRCRK,
      H_MONAT  type bseg-H_MONAT ,
       IOUT TYPE CHAR10,
       VAL TYPE SETLEAF-VALFROM,
       DESC TYPE T035T-TEXTL,
       end of ty_final.

data: it_final type table of ty_final,
      wa_final type ty_final.

types: begin of ty_col,
       BUKRS type bseg-BUKRS,
       gjahr type  bseg-gjahr,
       belnr type acdoca-belnr,
*       racct type acdoca-racct,
       dmbtr  type   bseg-dmbtr,
*       DRCRK type acdoca-DRCRK,
      H_MONAT  type bseg-H_MONAT ,
       IOUT TYPE CHAR10,
       VAL TYPE SETLEAF-VALFROM,
       DESC TYPE T035T-TEXTL,
     SHKZG TYPE bseg-SHKZG,
     koart TYPE bseg-koart,
     GKart TYPE bseg-GKart,
     gkont TYPE bseg-gkont,

       end of ty_col.
data: it_col type table of ty_col,
      wa_col type ty_col.
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

        .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


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
*    r_budat1-HIGH = '20250331'."DAY_START - 1.
    r_budat1-HIGH = '20250731'."DAY_START - 1.
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


*
data : begin of IT_ACDOCA occurs 0,
*       RLDNR like acdoca-rldnr,
*       RBUKRS like acdoca-rbukrs,
       BUKRS like bseg-bukrs,
       GJAHR  like acdoca-gjahr,
*      blart  like acdoca-blart,
      h_blart  like bseg-h_blart,
       "DOCLN  like acdoca-docln,
       BUDAT  like acdoca-budat,
*       HSL    like acdoca-hsl,
       dmbtr    like bseg-dmbtr,
*       DRCRK  like acdoca-drcrk ,
       SHKZG  like bseg-SHKZG ,
       H_MONAT  like bseg-H_MONAT,
*       POPER  like acdoca-poper,
       hkont  like bseg-hkont,
*       RACCT  like acdoca-racct,
       belnr  like acdoca-belnr,
       buzei  like acdoca-buzei,
       gkart  like bseg-gkart,
    koart like bseg-koart,
*       GKOAR  like acdoca-koart,
       gkont  like acdoca-gkont,
*       cbttype like acdoca-cbttype,
  UMSKZ TYPE bseg-UMSKZ,
       end of it_acdoca.
data : wa_acdoca1 like it_acdoca.
data: it_acdoca2 like TABLE OF  it_acdoca.
data : begin of it_acdoca1 occurs 0,
         belnr  like acdoca-belnr,
         GJAHR  like acdoca-GJAHR,
         hkont  like bseg-hkont,
         dmbtr    like bseg-dmbtr,
         shkzg  like bseg-SHKZG ,
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
*  RLDNR
  BUKRS
  GJAHR
  belnr
  h_blart
  dmbtr SHKZG H_MONAT hkont buzei gkont gkart umskz
  "cbttype
  from bseg into CORRESPONDING FIELDS OF "BUDAT
  table  IT_ACDOCA WHERE
       GJAHR = P_GJAHR
          "AND gkont ne ''
          and bukrs = p_bukrs
*          and RLDNR = '0L'
          and hkont in s_hkont.

  select
*  RLDNR
  BUKRS
  GJAHR
  belnr
  h_blart
  dmbtr SHKZG H_MONAT hkont buzei gkont gkart koart umskz
  "cbttype
  from bseg APPENDING  CORRESPONDING FIELDS OF "BUDAT
*  from bseg INTO CORRESPONDING FIELDS OF "BUDAT
  table IT_ACDOCA2 WHERE
       GJAHR = P_GJAHR
          "AND gkont ne ''
          and bukrs = p_bukrs
*          and RLDNR = '0L'
          and gkont in s_hkont and umskz = 'A'.

*BREAK-POINT.
sort IT_ACDOCA2 by belnr.
DELETE ADJACENT DUPLICATES FROM IT_ACDOCA2 COMPARING belnr.
    LOOP AT IT_ACDOCA2 INTO DATA(wa_bseg_sp).
READ TABLE IT_ACDOCA INTO DATA(wa_bseg_SG) with key belnr = wa_bseg_sp-belnr
                                                    gjahr  = wa_bseg_sp-GJAHR
                                                    bukrs = wa_bseg_sp-BUKRS.
IF sy-subrc = 0.
DELETE IT_ACDOCA WHERE belnr = wa_bseg_sp-belnr and
                                                    gjahr  = wa_bseg_sp-GJAHR
                                                    and bukrs = wa_bseg_sp-BUKRS.

wa_bseg_sp-dmbtr = wa_bseg_sg-dmbtr.
MODIFY IT_ACDOCA2 from wa_bseg_sp.
ENDIF.

CLEAR: wa_bseg_sp.
    ENDLOOP.



SELECT BUKRS,
BELNR,
GJAHR, XREVERSING, XREVERSED from bkpf INTO TABLE @DATA(it_bkpf) FOR ALL ENTRIES IN @IT_ACDOCA WHERE belnr = @IT_ACDOCA-belnr
                                                   and gjahr  = @IT_ACDOCA-GJAHR
                                               and     bukrs = @IT_ACDOCA-BUKRS and ( XREVERSED = 'X' or XREVERSING = 'X' ).


SELECT BUKRS,
BELNR,
GJAHR, XREVERSING, XREVERSED from bkpf INTO TABLE @DATA(it_bkpf_sp) FOR ALL ENTRIES IN @IT_ACDOCA2 WHERE belnr = @IT_ACDOCA2-belnr
                                                   and gjahr  = @IT_ACDOCA2-GJAHR
                                               and     bukrs = @IT_ACDOCA2-BUKRS and ( XREVERSED = 'X' or XREVERSING = 'X' ) .

  LOOP AT it_bkpf INTO DATA(wa_bkpf2).

DELETE IT_ACDOCA WHERE belnr = wa_bkpf2-belnr and gjahr = wa_bkpf2-gjahr and bukrs =  wa_bkpf2-bukrs.

CLEAR wa_bkpf.
  ENDLOOP.

LOOP AT it_bkpf_sp INTO DATA(wa_bkpf_sp).

DELETE IT_ACDOCA2 WHERE belnr = wa_bkpf_sp-belnr and gjahr = wa_bkpf_sp-gjahr and bukrs =  wa_bkpf_sp-bukrs.

CLEAR wa_bkpf_sp.
  ENDLOOP.


if it_acdoca[] is not initial.
*  delete it_acdoca where blart = 'AB'
*                   and cbttype = 'RFCL' .
sort it_acdoca by belnr.
  loop at it_acdoca into wa_acdoca1 where h_blart = 'AB'..
    move : wa_ACDOCA1-belnr      to wa_acdoca2-belnr,
           wa_acdoca1-GJAHR      to wa_acdoca2-GJAHR,
           wa_ACDOCA1-hkont+0(9) to wa_ACDOCA2-hkont,

           wa_acdoca1-dmbtr        to wa_acdoca2-dmbtr.
  COLLECT  wa_acdoca2 into it_acdoca1.
  clear :  wa_acdoca2.
  endloop.
   delete it_acdoca1 where dmbtr ne 0.
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
    endif.


  SELECT * from I_GLACCOUNTLINEITEMCUBE INTO TABLE @data(it_bsis)  WHERE CompanyCode = @P_BUKRS
                                                               and GLACCOUNT in @S_HKONT
                                                               and LEDGER = '0L'
                                                               and BusinessTransactionType ne 'RFBC'
                                                                and PostingDate IN @R_BUDAT1.

"""
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



lv_opbal = lv_opbal  + wa_bsis-AmountInCompanyCodeCurrency.


IF WA_BSIS-postingdate LT D1.
wa_finalfob-first = wa_finalfob-first + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D2.
wa_finalfob-second = wa_finalfob-second + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D3.
wa_finalfob-third = wa_finalfob-third + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D4.
wa_finalfob-fourth = wa_finalfob-fourth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D5.
wa_finalfob-fifth = wa_finalfob-fifth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D6.
wa_finalfob-sixth = wa_finalfob-sixth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D7.
wa_finalfob-seventh = wa_finalfob-seventh + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D8.
wa_finalfob-eighth = wa_finalfob-eighth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D9.
wa_finalfob-nineth = wa_finalfob-nineth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D10.
wa_finalfob-tenth = wa_finalfob-tenth + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D11.
 wa_finalfob-eleven = wa_finalfob-eleven + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.
IF WA_BSIS-postingdate LT D12.
 wa_finalfob-twelve = wa_finalfob-twelve + wa_bsis-AmountInCompanyCodeCurrency.
ENDIF.

CLEAR: wa_bsis.
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

delete it_customer where GKart ne 'D'.
delete it_vendor where GKart ne 'K'.
delete it_gl where GKart ne 'S'.

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
if wa_acdoca-SHKZG = 'H'.
  wa_final-dmbtr = wa_final-dmbtr * -1.
ENDIF.

if wa_acdoca-GKart = 'D'.
  if sy-subrc = 0.
   IF wa_acdoca-SHKZG = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF."customer
  read table it_knb1 into data(wa_knb1) with key kunnr = wa_acdoca-gkont.
if sy-subrc = 0.
    read table it_t035t into data(wa_t035t) with key GRUPP = wa_knb1-FDGRV.
    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T035T-TEXTL.
    endif.
    endif.
  endif.
elseif wa_acdoca-GKart = 'K'.
   IF wa_acdoca-SHKZG = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF. "vendor
  read table it_lfb1 into data(wa_lfb1) with key lifnr = wa_acdoca-gkont.
  if sy-subrc = 0.
read table it_t035t into wa_t035t with key GRUPP = wa_lfb1-FDGRV.

    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T035T-TEXTL.
    endif.
endif.
elseif wa_acdoca-GKart = 'S'. "GL
    IF wa_acdoca-SHKZG = 'S'.
     wa_final-iout = 'INWARD'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
    ENDIF.
      read table it_skb1 into data(wa_skb1) with key saknr = wa_acdoca-gkont.
    if sy-subrc = 0.
   read table it_t036t into data(wa_t036t) with key EBENE = wa_skb1-FDLEV.
    if sy-subrc = 0.
    WA_FINAL-DESC = WA_T036T-LTEXT.
    endif.
endif.
endif.

collect wa_final into it_final.
*clear: wa_final,wa_skb1,wa_setleaf,wa_acdoca,wa_setlinet.
MOVE-CORRESPONDING wa_final  to wa_col.
wa_col-BELNR = wa_acdoca-BELNR.
APPEND wa_col to it_col.
 clear: wa_final,wa_skb1,wa_acdoca, wa_col.
endloop.
*BREAK-POINT.
loop at it_acdoca2 into data(wa_acdoca3).

MOVE-CORRESPONDING WA_ACDOCA3 TO WA_FINAL.
*if wa_acdoca3-SHKZG = 'H'.
*  wa_final-dmbtr = wa_final-dmbtr * -1.
*ENDIF.

if wa_acdoca3-koart = 'D'.

   IF wa_acdoca3-SHKZG = 'H'.
     wa_final-iout = 'INWARD'.
     SELECT SINGLE TEXTL from t035t INTO WA_FINAL-DESC WHERE GRUPP = 'YN'.
    ELSE.
       wa_final-iout = 'OUTWARD'.
         wa_final-DMBTR = wa_final-DMBTR * -1.
         SELECT SINGLE TEXTL from t035t INTO WA_FINAL-DESC WHERE GRUPP = 'ZP'.
    ENDIF."customer

elseif wa_acdoca3-koart = 'K'.
   IF wa_acdoca3-SHKZG = 'S'.
     wa_final-DMBTR = wa_final-DMBTR * -1.
     wa_final-iout = 'OUTWARD'.
     SELECT SINGLE TEXTL from t035t INTO WA_FINAL-DESC WHERE GRUPP = 'YM'.
    ELSE.
       wa_final-iout = 'INWARD'.
        SELECT SINGLE TEXTL from t035t INTO WA_FINAL-DESC WHERE GRUPP = 'ZO'.

    ENDIF. "vendor
*SELECT SINGLE TEXTL from t035t INTO WA_FINAL-DESC WHERE GRUPP = 'YM'.


endif.

collect wa_final into it_final.
*clear: wa_final,wa_skb1,wa_setleaf,wa_acdoca,wa_setlinet.
MOVE-CORRESPONDING wa_final to wa_col.
wa_col-BELNR = wa_acdoca3-BELNR.
APPEND wa_col to it_col.
 clear: wa_final,wa_skb1,wa_acdoca3, wa_col.
endloop.

data aflag type char1.

data: k type i.
*sort it_final stable by poper
data: desc type char50.
data: desc1 type char50.
sort it_final stable by iout desc H_MONAT .

""""logic for opening balance.


""""""""""""""""""""""""
clear wa_finalf.
wa_finalf-particular = 'Cash Inflow'.
WA_finalf-color = 'C600'.
append wa_finalf to it_finalf.
clear wa_finalf.

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
case wa_final-H_MONAT .

when 1.
wa_finalf-first = wa_final-DMBTR.
f1 = 'X'.
when 2.
wa_finalf-second = wa_final-dmbtr.
f2 = 'X'.
when 3.
wa_finalf-third = wa_final-dmbtr.
f3 = 'X'.
when 4.
wa_finalf-fourth = wa_final-dmbtr.
f4 = 'X'.
when 5.
wa_finalf-fifth = wa_final-dmbtr.
f5 = 'X'.
when 6.
wa_finalf-SIXTH = wa_final-dmbtr.
f6 = 'X'.
when 7.
wa_finalf-SEVENTH = wa_final-dmbtr.
f7 = 'X'.
when 8.
wa_finalf-EIGHTH = wa_final-dmbtr.
f8 = 'X'.
when 9.
wa_finalf-NINETH = wa_final-dmbtr.
f9 = 'X'.
when 10.
wa_finalf-tenth = wa_final-dmbtr.
f10 = 'X'.
when 11.
wa_finalf-ELEVEN = wa_final-dmbtr.
f11 = 'X'.
when 12.
wa_finalf-TWELVE = wa_final-dmbtr.
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
case wa_final-H_MONAT .

when 1.
wa_finalf-first = wa_final-dmbtr.
f1 = 'X'.
when 2.
wa_finalf-second = wa_final-dmbtr.
f2 = 'X'.
when 3.
wa_finalf-third = wa_final-dmbtr.
f3 = 'X'.
when 4.
wa_finalf-fourth = wa_final-dmbtr.
f4 = 'X'.
when 5.
wa_finalf-fifth = wa_final-dmbtr.
f5 = 'X'.
when 6.
wa_finalf-SIXTH = wa_final-dmbtr.
f6 = 'X'.
when 7.
wa_finalf-SEVENTH = wa_final-dmbtr.
f7 = 'X'.
when 8.
wa_finalf-EIGHTH = wa_final-dmbtr.
f8 = 'X'.
when 9.
wa_finalf-NINETH = wa_final-dmbtr.
f9 = 'X'.
when 10.
wa_finalf-tenth = wa_final-dmbtr.
f10 = 'X'.
when 11.
wa_finalf-ELEVEN = wa_final-dmbtr.
f11 = 'X'.
when 12.
wa_finalf-TWELVE = wa_final-dmbtr.
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


 CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     i_callback_program                = sy-repid
     IS_LAYOUT                         =  LS_LAYOUT
     it_fieldcat                       = it_fieldcat[]
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
