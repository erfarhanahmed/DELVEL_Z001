
SELECT vbeln,
   vbelv FROM vbfa INTO TABLE @DATA(it_vbfa1)
    where vbeln = @is_nast-objky.

"SORT it_likp DESCENDING BY vbeln.

DELETE ADJACENT DUPLICATES FROM it_vbfa1 COMPARING vbelv.

   READ TABLE it_vbfa1 into data(wa_vbfa1) INDEX 1.
   if sy-subrc = 0.
    sales_ord1 = wa_vbfa1-vbelv.
  endif.
     READ TABLE it_vbfa1 into data(wa_vbfa2) INDEX 2.
   if sy-subrc = 0.
    sales_ord2 = wa_vbfa2-vbelv.
  endif.
     READ TABLE it_vbfa1 into data(wa_vbfa3) INDEX 3.
   if sy-subrc = 0.
    sales_ord3 = wa_vbfa3-vbelv.
  endif.
     READ TABLE it_vbfa1 into data(wa_vbfa4) INDEX 4.
   if sy-subrc = 0.
    sales_ord4 = wa_vbfa4-vbelv.
  endif.
     READ TABLE it_vbfa1 into data(wa_vbfa5) INDEX 5.
   if sy-subrc = 0.
    sales_ord5 = wa_vbfa5-vbelv.
  endif.

  READ TABLE it_vbfa1 into data(wa_vbfa6) INDEX 6.
   if sy-subrc = 0.
    sales_ord6 = wa_vbfa6-vbelv.
  endif.

    READ TABLE it_vbfa1 into data(wa_vbfa7) INDEX 7.
   if sy-subrc = 0.
    sales_ord7 = wa_vbfa7-vbelv.
  endif.

    READ TABLE it_vbfa1 into data(wa_vbfa8) INDEX 8.
   if sy-subrc = 0.
    sales_ord8 = wa_vbfa8-vbelv.
  endif.

    READ TABLE it_vbfa1 into data(wa_vbfa9) INDEX 9.
   if sy-subrc = 0.
    sales_ord9 = wa_vbfa9-vbelv.
  endif.

IF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS  INITIAL
    AND sales_ord3 IS  INITIAL
    AND sales_ord4 IS  INITIAL
    AND sales_ord5 IS  INITIAL
    AND sales_ord6 IS  INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
  SALES_ORDT = sales_ord1.
  ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS  INITIAL
    AND sales_ord4 IS  INITIAL
    AND sales_ord5 IS  INITIAL
    AND sales_ord6 IS  INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 INTO SALES_ORDT .
  ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS  INITIAL
    AND sales_ord5 IS  INITIAL
    AND sales_ord6 IS  INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3 INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS  INITIAL
    AND sales_ord6 IS  INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS NOT INITIAL
    AND sales_ord6 IS  INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 ',' sales_ord5 INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS NOT INITIAL
    AND sales_ord6 IS NOT INITIAL
    AND sales_ord7 IS  INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 ',' sales_ord5 ',' sales_ord6 INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS NOT INITIAL
    AND sales_ord6 IS NOT INITIAL
    AND sales_ord7 IS NOT INITIAL
    AND sales_ord8 IS  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 ',' sales_ord5 ',' sales_ord6 ',' sales_ord7
INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS NOT INITIAL
    AND sales_ord6 IS NOT INITIAL
    AND sales_ord7 IS NOT INITIAL
    AND sales_ord8 IS NOT  INITIAL
    AND sales_ord9 IS  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 ',' sales_ord5 ',' sales_ord6 ',' sales_ord7
',' sales_ord8 INTO SALES_ORDT .
ELSEIF sales_ord1 IS NOT INITIAL
    AND sales_ord2 IS NOT  INITIAL
    AND sales_ord3 IS NOT INITIAL
    AND sales_ord4 IS NOT  INITIAL
    AND sales_ord5 IS NOT INITIAL
    AND sales_ord6 IS NOT INITIAL
    AND sales_ord7 IS NOT INITIAL
    AND sales_ord8 IS NOT  INITIAL
    AND sales_ord9 IS NOT  INITIAL .
CONCATENATE sales_ord1 ',' sales_ord2 ',' sales_ord3
',' sales_ord4 ',' sales_ord5 ',' sales_ord6 ',' sales_ord7
',' sales_ord8 ',' sales_ord9 INTO SALES_ORDT .
ENDIF.


















