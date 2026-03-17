"Name: \PR:RCS14001\FO:DIFF_OUTPUT\SE:BEGIN\EI
ENHANCEMENT 0 ZENH_CS14.
BREAK CTPLFARHAN.
  IF bom_key-displ_method EQ 'A'.
    PERFORM zdiff_output_alv
       TABLES diff
              bom_a
              bom_b
              bom_key.
exit.
ENDIF.
ENDENHANCEMENT.
