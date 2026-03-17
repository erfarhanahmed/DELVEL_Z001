
SELECT SINGLE fkdat
  INTO v_pck_lst_dt
  FROM likp
  WHERE vbeln = is_nast-objky.

*SELECT SINGLE VBELN
*   INTO INBOUND
*   FROM LIKP
*   WHERE VERUR = is_nast-objky.

SELECT vbeln
       VERUR
       ERDAT     FROM likp INTO TABLE it_likp
       WHERE VERUR = is_nast-objky.


SORT it_likp DESCENDING BY vbeln.

READ TABLE it_likp INTO wa_likp INDEX 1.
IF sy-subrc = 0.
 inbound = wa_likp-vbeln.
ENDIF.














