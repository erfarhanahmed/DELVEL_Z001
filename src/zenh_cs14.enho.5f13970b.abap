"Name: \PR:RCS14001\IC:RCS14F02\SE:END\EI
ENHANCEMENT 0 ZENH_CS14.
form Zdiff_output_alv tables lt_diff        structure rc29v        "MBALV
                            lt_bom_a       structure rc29v1
                            lt_bom_b       structure rc29v1
                            lt_bom_key     structure bom_key.

*---
data: lt_field_nw type slis_t_fieldcat_alv,
      lt_events   type slis_t_event,
      lt_groups   type slis_t_sp_group_alv,
      lt_dfies    like dfies                occurs 0,

      ls_layout   type slis_layout_alv,
      ls_variant  type disvariant,
      ls_dfies    like dfies ,
      ls_print    type slis_print_alv,                      "note 335129
      ls_num_lines TYPE i,                                  "note 424673

      l_stpox_nam like dfies-fieldname.

field-symbols: <dfies> type any,
               <stpox> type any.

clear gt_cscomp.                  refresh gt_cscomp.

*-- count number of lines of internal table lt_diff        "note 424673
DESCRIBE TABLE lt_diff LINES ls_num_lines.                 "note 424673

IF ls_num_lines > 10000.                                   "note 424673
  MESSAGE A599 with ls_num_lines.                          "note 424673
*   Vergleichsergebnis kann im List-Viewer nicht           "note 424673
*   dargestellt werden                                     "note 424673
ENDIF.                                                     "note 424673

*-- fill structure information
perform alv_fill_dfies tables lt_dfies.

*-- fill fieldcat
perform alv_fill_fieldcat
  using    lt_bom_key-cumulated
  changing lt_field_nw.

*-- fill groups
perform alv_fill_special_group changing lt_groups.

*-- fill events
perform alv_fill_events  changing lt_events.

*-- fill layout
perform alv_fill_layout  changing ls_layout.

*-- fill variants
perform alv_fill_variant
    using    lt_bom_key-cumulated
    changing ls_variant.

*--- printing
move: c_cross to ls_print-prnt_title.                       "note 335129

*-- initialize status buttons
move: c_cross to show_dif,
      c_cross to show_sim,
      c_cross to show_equ.

do.
  refresh: gt_cscomp.

*-- build output table
  loop at lt_diff.
    if ( ( show_dif = 'X' ) and ( lt_diff-difference eq 'different' ) )
      or ( ( show_sim = 'X' ) and ( lt_diff-difference eq 'similar' ) )
      or ( ( show_equ = 'X' ) and ( lt_diff-difference eq 'equal' ) ).

    clear gt_cscomp.

    move: sy-tabix         to gt_cscomp-index_alv,
          lt_diff-akt_komp to gt_cscomp-akt_komp,
          lt_diff-akt_text to gt_cscomp-akt_text.

    if lt_diff-difference eq 'similar'.
      move: lt_diff-mnglg_diff to gt_cscomp-diff_menge.
    endif.

* Primary Position
    if lt_diff-a_tabix ne 0.
      read table lt_bom_a index lt_diff-a_tabix.
      if sy-subrc eq 0.
        loop at lt_dfies into ls_dfies.
          concatenate 'A_' ls_dfies-fieldname
             into l_stpox_nam.
          assign component ls_dfies-fieldname
             of structure lt_bom_a  to <stpox>.
          check sy-subrc eq 0.
          assign component l_stpox_nam
             of structure gt_cscomp to <dfies>.
          check sy-subrc eq 0.
          <dfies> = <stpox>.
        endloop.

        move: lt_bom_a-stufe to gt_cscomp-a_dstuf.

        if not lt_bom_key-cumulated is initial.
          case lt_bom_a-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_a-mmein to gt_cscomp-a_dmnge,
                  lt_bom_a-mmein to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-mmein to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 2.
*         Text Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 3.
*         Document Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 4.
*         Class Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          endcase.
        else.
          case lt_bom_a-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          endcase.
        endif.

        if lt_bom_key-cumulated is initial.
        else.
          if not lt_bom_a-multiple is initial.
*d          move: c_icon_sum to gt_cscomp-a_multiple_icon.     "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_sum             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-a_multiple_icon   "Acc
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_sum TO gt_cscomp-a_multiple_icon.   "Acc 2004
            ENDIF.                                             "Acc 2004
          endif.
        endif.
      endif.
    endif.

    if lt_diff-b_tabix ne 0.
      read table lt_bom_b index lt_diff-b_tabix.
      if sy-subrc eq 0.
        loop at lt_dfies into ls_dfies.
          concatenate 'B_' ls_dfies-fieldname
             into l_stpox_nam.
          assign component ls_dfies-fieldname
             of structure lt_bom_b  to <stpox>.
          check sy-subrc eq 0.
          assign component l_stpox_nam
             of structure gt_cscomp to <dfies>.
          check sy-subrc eq 0.
          <dfies> = <stpox>.
        endloop.

        move: lt_bom_b-stufe to gt_cscomp-b_dstuf.

        if not lt_bom_key-cumulated is initial.
          case lt_bom_b-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_b-mmein to gt_cscomp-b_dmnge,
                  lt_bom_b-mmein to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-mmein to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          endcase.
        else.
          case lt_bom_b-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          endcase.
        endif.

        if lt_bom_key-cumulated is initial.
        else.
          if not lt_bom_b-multiple is initial.
*d          move: c_icon_sum to gt_cscomp-b_multiple_icon.     "Acc 2004

*Note 1012798: Changed gt_cscomp-a_multiple_icon to
*gt_cscomp-b_multiple_icon in the below code.

            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_sum             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-b_multiple_icon   "Acc
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_sum TO gt_cscomp-b_multiple_icon.   "Acc 2004
            ENDIF.                                             "Acc 2004
          endif.
        endif.
      endif.
    endif.

    case lt_diff-icon.
    when 'ICON_FAILURE'.
*d    move: c_icon_failure       to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_failure               "Acc 2004
          info                  = text-090                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_failure TO gt_cscomp-icon.                "Acc 2004
      ENDIF.                                                   "Acc 2004

    when 'ICON_EQUAL_GREEN'.
*d    move: c_icon_equal_green   to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_equal_green           "Acc 2004
          info                  = text-089                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_equal_green TO gt_cscomp-icon.            "Acc 2004
      ENDIF.                                                   "Acc 2004

    when 'ICON_NOT_EQUAL_RED'.
*d    write c_icon_not_equal_red to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_not_equal_red         "Acc 2004
          info                  = text-091                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_not_equal_red TO gt_cscomp-icon.          "Acc 2004
      ENDIF.                                                   "Acc 2004

    endcase.

*   Phantom item adjusted for ALV filtering                      "Note 1327742
    IF NOT gt_cscomp-a_dumps IS INITIAL.                         "Note 1327742
      TRANSLATE gt_cscomp-a_dumps TO UPPER CASE. "#EC TRANSLANG  "Note 1327742
    ENDIF.                                                       "Note 1327742

    IF NOT gt_cscomp-b_dumps IS INITIAL.                         "Note 1327742
      TRANSLATE gt_cscomp-b_dumps TO UPPER CASE. "#EC TRANSLANG  "Note 1327742
    ENDIF.

    select single ZEINR , ZEIVR ,ZZEDS, ZZMSS, MTART from mara
    into @data(wa_mara) where matnr eq @gt_cscomp-AKT_KOMP.

    IF gt_cscomp-A_MTART IS NOT INITIAL.
    gt_cscomp-MTART = gt_cscomp-A_MTART.
     ELSE.
      gt_cscomp-MTART = gt_cscomp-B_MTART.
      ENDIF.
    gt_cscomp-zZEINR = wa_mara-ZEINR.
     gt_cscomp-ZzEIVR = wa_mara-ZEIVR .
      gt_cscomp-ZZEDS = wa_mara-ZZEDS.
       gt_cscomp-zZZMSS = wa_mara-ZZMSS.                                                  "Note 1327742

    append gt_cscomp.
    endif.
  endloop.

*- call alv
  call function 'REUSE_ALV_GRID_DISPLAY'
          exporting
               i_buffer_active             = c_cross
               i_callback_html_top_of_page = 'ALV_FILL_HTML_TOP'
               i_callback_top_of_page      = 'ALV_TOP_OF_PAGE'"te 335129
               i_callback_program          = c_repid_rcs14001
*               i_structure_name            = c_comp_alv
*               i_default                   = c_space       "note 353331
               i_default                   = c_cross        "note 353331
               i_save                      = 'A'            "note 390305
               is_layout                   = ls_layout
               is_variant                  = ls_variant
               is_print                    = ls_print       "note 335129
               it_special_groups           = lt_groups
               it_fieldcat                 = lt_field_nw
               it_events                   = lt_events
          tables
               t_outtab                    = gt_cscomp
          exceptions
               program_error               = 1
               others                      = 2.

  case sy-ucomm.
  when 'SDIF' or
       'HDIF' or
       'SEQU' or
       'HEQU' or
       'SSIM' or
       'HSIM'.

  when others.
    exit.
  endcase.
enddo.

endform.
FORM ZZDIFF_OUTPUT_ALV tables lt_diff        structure rc29v        "MBALV
                            lt_bom_a       structure rc29v1
                            lt_bom_b       structure rc29v1
                            lt_bom_key     structure bom_key .
  data: lt_field_nw type slis_t_fieldcat_alv,
      lt_events   type slis_t_event,
      lt_groups   type slis_t_sp_group_alv,
      lt_dfies    like dfies                occurs 0,

      ls_layout   type slis_layout_alv,
      ls_variant  type disvariant,
      ls_dfies    like dfies ,
      ls_print    type slis_print_alv,                      "note 335129
      ls_num_lines TYPE i,                                  "note 424673

      l_stpox_nam like dfies-fieldname.

field-symbols: <dfies> type any,
               <stpox> type any.

clear gt_cscomp.                  refresh gt_cscomp.

*-- count number of lines of internal table lt_diff        "note 424673
DESCRIBE TABLE lt_diff LINES ls_num_lines.                 "note 424673

IF ls_num_lines > 10000.                                   "note 424673
  MESSAGE A599 with ls_num_lines.                          "note 424673
*   Vergleichsergebnis kann im List-Viewer nicht           "note 424673
*   dargestellt werden                                     "note 424673
ENDIF.                                                     "note 424673

*-- fill structure information
perform alv_fill_dfies tables lt_dfies.

*-- fill fieldcat
perform alv_fill_fieldcat
  using    lt_bom_key-cumulated
  changing lt_field_nw.

*-- fill groups
perform alv_fill_special_group changing lt_groups.

*-- fill events
perform alv_fill_events  changing lt_events.

*-- fill layout
perform alv_fill_layout  changing ls_layout.

*-- fill variants
perform alv_fill_variant
    using    lt_bom_key-cumulated
    changing ls_variant.

*--- printing
move: c_cross to ls_print-prnt_title.                       "note 335129

*-- initialize status buttons
move: c_cross to show_dif,
      c_cross to show_sim,
      c_cross to show_equ.

do.
  refresh: gt_cscomp.

*-- build output table
  loop at lt_diff.
    if ( ( show_dif = 'X' ) and ( lt_diff-difference eq 'different' ) )
      or ( ( show_sim = 'X' ) and ( lt_diff-difference eq 'similar' ) )
      or ( ( show_equ = 'X' ) and ( lt_diff-difference eq 'equal' ) ).

    clear gt_cscomp.

    move: sy-tabix         to gt_cscomp-index_alv,
          lt_diff-akt_komp to gt_cscomp-akt_komp,
          lt_diff-akt_text to gt_cscomp-akt_text.

    if lt_diff-difference eq 'similar'.
      move: lt_diff-mnglg_diff to gt_cscomp-diff_menge.
    endif.

* Primary Position
    if lt_diff-a_tabix ne 0.
      read table lt_bom_a index lt_diff-a_tabix.
      if sy-subrc eq 0.
        loop at lt_dfies into ls_dfies.
          concatenate 'A_' ls_dfies-fieldname
             into l_stpox_nam.
          assign component ls_dfies-fieldname
             of structure lt_bom_a  to <stpox>.
          check sy-subrc eq 0.
          assign component l_stpox_nam
             of structure gt_cscomp to <dfies>.
          check sy-subrc eq 0.
          <dfies> = <stpox>.
        endloop.

        move: lt_bom_a-stufe to gt_cscomp-a_dstuf.

        if not lt_bom_key-cumulated is initial.
          case lt_bom_a-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_a-mmein to gt_cscomp-a_dmnge,
                  lt_bom_a-mmein to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-mmein to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 2.
*         Text Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 3.
*         Document Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          when 4.
*         Class Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge,
                  lt_bom_a-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_a-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          endcase.
        else.
          case lt_bom_a-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_a-meins to gt_cscomp-a_dmnge.         "Acc 2004
*d          move: lt_bom_a-meins to gt_cscomp-a_dmnge,         "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004
          endcase.
        endif.

        if lt_bom_key-cumulated is initial.
        else.
          if not lt_bom_a-multiple is initial.
*d          move: c_icon_sum to gt_cscomp-a_multiple_icon.     "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_sum             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-a_multiple_icon   "Acc
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_sum TO gt_cscomp-a_multiple_icon.   "Acc 2004
            ENDIF.                                             "Acc 2004
          endif.
        endif.
      endif.
    endif.

    if lt_diff-b_tabix ne 0.
      read table lt_bom_b index lt_diff-b_tabix.
      if sy-subrc eq 0.
        loop at lt_dfies into ls_dfies.
          concatenate 'B_' ls_dfies-fieldname
             into l_stpox_nam.
          assign component ls_dfies-fieldname
             of structure lt_bom_b  to <stpox>.
          check sy-subrc eq 0.
          assign component l_stpox_nam
             of structure gt_cscomp to <dfies>.
          check sy-subrc eq 0.
          <dfies> = <stpox>.
        endloop.

        move: lt_bom_b-stufe to gt_cscomp-b_dstuf.

        if not lt_bom_key-cumulated is initial.
          case lt_bom_b-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_b-mmein to gt_cscomp-b_dmnge,
                  lt_bom_b-mmein to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-mmein to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge,
                  lt_bom_b-meins to gt_cscomp-diff_unit.       "Acc 2004
*d                lt_bom_b-meins to gt_cscomp-diff_unit,       "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          endcase.
        else.
          case lt_bom_b-objty.
          when 1 or 'M'.
*         Material Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_mat     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_mat             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_mat TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 2.
*         Text Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_txt     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_txt             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_txt TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 3.
*         Document Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_doc     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_doc             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_doc TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          when 4.
*         Class Position
            move: lt_bom_b-meins to gt_cscomp-b_dmnge.         "Acc 2004
*d          move: lt_bom_b-meins to gt_cscomp-b_dmnge,         "Acc 2004
*d                c_icon_kla     to gt_cscomp-pos_typ.         "Acc 2004
            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_kla             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-pos_typ      "Acc 2004
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_kla TO gt_cscomp-pos_typ.           "Acc 2004
            ENDIF.                                             "Acc 2004

          endcase.
        endif.

        if lt_bom_key-cumulated is initial.
        else.
          if not lt_bom_b-multiple is initial.
*d          move: c_icon_sum to gt_cscomp-b_multiple_icon.     "Acc 2004

*Note 1012798: Changed gt_cscomp-a_multiple_icon to
*gt_cscomp-b_multiple_icon in the below code.

            CALL FUNCTION 'ICON_CREATE'                        "Acc 2004
              EXPORTING                                        "Acc 2004
                name                  = c_icon_sum             "Acc 2004
              IMPORTING                                        "Acc 2004
                result                = gt_cscomp-b_multiple_icon   "Acc
              EXCEPTIONS                                       "Acc 2004
                icon_not_found        = 1                      "Acc 2004
                outputfield_too_short = 2                      "Acc 2004
                others                = 3.                     "Acc 2004
            IF sy-subrc <> 0.                                  "Acc 2004
              MOVE: c_icon_sum TO gt_cscomp-b_multiple_icon.   "Acc 2004
            ENDIF.                                             "Acc 2004
          endif.
        endif.
      endif.
    endif.

    case lt_diff-icon.
    when 'ICON_FAILURE'.
*d    move: c_icon_failure       to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_failure               "Acc 2004
          info                  = text-090                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_failure TO gt_cscomp-icon.                "Acc 2004
      ENDIF.                                                   "Acc 2004

    when 'ICON_EQUAL_GREEN'.
*d    move: c_icon_equal_green   to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_equal_green           "Acc 2004
          info                  = text-089                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_equal_green TO gt_cscomp-icon.            "Acc 2004
      ENDIF.                                                   "Acc 2004

    when 'ICON_NOT_EQUAL_RED'.
*d    write c_icon_not_equal_red to gt_cscomp-icon.            "Acc 2004
      CALL FUNCTION 'ICON_CREATE'                              "Acc 2004
        EXPORTING                                              "Acc 2004
          name                  = c_icon_not_equal_red         "Acc 2004
          info                  = text-091                     "Acc 2004
        IMPORTING                                              "Acc 2004
          result                = gt_cscomp-icon               "Acc 2004
        EXCEPTIONS                                             "Acc 2004
          icon_not_found        = 1                            "Acc 2004
          outputfield_too_short = 2                            "Acc 2004
          others                = 3.                           "Acc 2004
      IF sy-subrc <> 0.                                        "Acc 2004
        MOVE: c_icon_not_equal_red TO gt_cscomp-icon.          "Acc 2004
      ENDIF.                                                   "Acc 2004

    endcase.

*   Phantom item adjusted for ALV filtering                      "Note 1327742
    IF NOT gt_cscomp-a_dumps IS INITIAL.                         "Note 1327742
      TRANSLATE gt_cscomp-a_dumps TO UPPER CASE. "#EC TRANSLANG  "Note 1327742
    ENDIF.                                                       "Note 1327742

    IF NOT gt_cscomp-b_dumps IS INITIAL.                         "Note 1327742
      TRANSLATE gt_cscomp-b_dumps TO UPPER CASE. "#EC TRANSLANG  "Note 1327742
    ENDIF.                                                       "Note 1327742

  select single ZEINR , ZEIVR ,ZZEDS, ZZMSS, MTART from mara
    into @data(wa_mara) where matnr eq @gt_cscomp-AKT_KOMP.

    IF gt_cscomp-A_MTART IS NOT INITIAL.
    gt_cscomp-MTART = gt_cscomp-A_MTART.
     ELSE.
      gt_cscomp-MTART = gt_cscomp-B_MTART.
      ENDIF.

    gt_cscomp-ZZEINR = wa_mara-ZEINR.
     gt_cscomp-ZZEIVR = wa_mara-ZEIVR .
      gt_cscomp-ZZEDS = wa_mara-ZZEDS.
       gt_cscomp-zZZMSS = wa_mara-ZZMSS.




    append gt_cscomp.
    endif.
  endloop.

*- call alv
  call function 'REUSE_ALV_GRID_DISPLAY'
          exporting
               i_buffer_active             = c_cross
               i_callback_html_top_of_page = 'ALV_FILL_HTML_TOP'
               i_callback_top_of_page      = 'ALV_TOP_OF_PAGE'"te 335129
               i_callback_program          = c_repid_rcs14001
*               i_structure_name            = c_comp_alv
*               i_default                   = c_space       "note 353331
               i_default                   = c_cross        "note 353331
               i_save                      = 'A'            "note 390305
               is_layout                   = ls_layout
               is_variant                  = ls_variant
               is_print                    = ls_print       "note 335129
               it_special_groups           = lt_groups
               it_fieldcat                 = lt_field_nw
               it_events                   = lt_events
          tables
               t_outtab                    = gt_cscomp
          exceptions
               program_error               = 1
               others                      = 2.

  case sy-ucomm.
  when 'SDIF' or
       'HDIF' or
       'SEQU' or
       'HEQU' or
       'SSIM' or
       'HSIM'.

  when others.
    exit.
  endcase.
enddo.

ENDFORM.
ENDENHANCEMENT.
