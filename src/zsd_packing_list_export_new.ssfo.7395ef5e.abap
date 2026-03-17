*LOOP AT Gt_ADR INTO GS_ADR.

  SELECT SINGLE ERDAT FROM likp INTO WA_LIKP11
 WHERE vbeln  = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.

if is_dlv_delnote-hd_gen-sold_to_party = '0000300000'.
if  wa_likp11-erdat ge '20240812'.
IF GS_ADR = '6068 Hwy. 73'.
  GS_ADR = '6535,Industrial Dr, Ste 103'.
ENDIF.
endif.
endif.

*ENDLOOP.




















