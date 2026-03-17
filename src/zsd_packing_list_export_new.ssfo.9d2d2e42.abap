*clear :

*SELECT SINGLE SUM( brgew )
*  INTO v_gross_wt
*  FROM vekp
*  WHERE vpobj = '01'
*    AND vpobjkey = is_dlv_delnote-hd_gen-deliv_numb
**  where vbeln_gen = IS_DLV_DELNOTE-HD_GEN-DELIV_NUMB
*  GROUP BY vbeln_gen.

  CLEAR : v_net_wt , v_gross_wt .

  SELECT SINGLE SUM( brgew )
              SUM( ntgew )
  INTO (v_gross_wt, v_net_wt)
  FROM lips WHERE vbeln = is_dlv_delnote-hd_gen-deliv_numb .

















