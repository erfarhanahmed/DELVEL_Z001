


SELECT SINGLE erdat
  INTO wa_likp11-erdat
  FROM likp
  WHERE vbeln = is_dlv_delnote-hd_gen-deliv_numb.


IF is_dlv_delnote-hd_gen-sold_to_party = '0000300000' AND
  is_dlv_delnote-hd_gen-ship_to_party = '0000300000'.

  IF wa_likp11-erdat GE '20240812'.
  wa_adrc1-str_suppl1 = '6535 Industrial Dr, Ste 103'.

  ELSE.
SELECT SINGLE str_suppl1
      INTO wa_adrc1-str_suppl1
      FROM adrc
      WHERE addrnumber = is_dlv_delnote-hd_gen-sold_to_party.
  ENDIF.
   ELSE.
  SELECT SINGLE str_suppl1
    INTO wa_adrc1-str_suppl1
    FROM adrc
    WHERE addrnumber = is_dlv_delnote-hd_gen-sold_to_party.

ENDIF.
