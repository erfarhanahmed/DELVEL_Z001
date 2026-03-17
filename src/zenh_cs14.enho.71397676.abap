"Name: \PR:RCS14001\FO:DIFF_OUTPUT_CUMULATED\SE:BEGIN\EI
ENHANCEMENT 0 ZENH_CS14.
BREAK dvbasis.
IF bom_key-displ_method EQ 'A'.
  PERFORM zZdiff_output_alv
            TABLES diff
                   bom_a
                   bom_b
                   bom_key.
  EXIT.
ENDIF.
ENDENHANCEMENT.
