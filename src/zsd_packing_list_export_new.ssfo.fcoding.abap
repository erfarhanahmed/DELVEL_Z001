*---------------------------------------------------------------------*
*       FORM GET_TEXTNAME                                             *
*---------------------------------------------------------------------*
*       get adress textnames
*---------------------------------------------------------------------*
FORM get_textname USING    is_dlv_delnote TYPE ledlv_delnote

CHANGING ef_txnam_adr   TYPE txnam_adr
ef_txnam_kop   TYPE txnam_kop
ef_txnam_fus   TYPE txnam_fus
ef_txnam_gru   TYPE txnam_gru
ef_txnam_sdb   TYPE txnam_sdb
ef_txnam_ala   TYPE aland.

  DATA: ls_delivery TYPE likpvb.
  DATA: lf_text_org.

* clear textnames
  CLEAR: ef_txnam_adr,
  ef_txnam_kop,
  ef_txnam_fus,
  ef_txnam_gru,
  ef_txnam_sdb,
  ef_txnam_ala.

* delivery number
  ls_delivery-vbeln = is_dlv_delnote-hd_gen-deliv_numb.
* organisational data
  ls_delivery-vstel = is_dlv_delnote-hd_org-ship_point.
  ls_delivery-vkorg = is_dlv_delnote-hd_org-salesorg.
  ls_delivery-vkbur = is_dlv_delnote-hd_org-sales_off.

* Valid numbers for IF_TABLE:   1     text from sales organisation
*                               2     text from shipping point
*                               3     text from sales office
* default: read text from shipping point
  lf_text_org = '2'.

  CALL FUNCTION 'LE_SHP_DLVOUTP_TEXT_SELECT'
    EXPORTING
      is_delivery           = ls_delivery
      if_table              = lf_text_org
    IMPORTING
      ef_tdname_adr         = ef_txnam_adr
      ef_tdname_kop         = ef_txnam_kop
      ef_tdname_fus         = ef_txnam_fus
      ef_tdname_gru         = ef_txnam_gru
      ef_tdname_sdb         = ef_txnam_sdb
      ef_tdname_ala         = ef_txnam_ala
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
  ENDIF.

ENDFORM.

