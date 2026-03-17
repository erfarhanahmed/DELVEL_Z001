*&---------------------------------------------------------------------*
*& Include          ZXM08U21
*&---------------------------------------------------------------------*


*  select single budat into
*IF sy-tcode = 'MRRL'.
*   DATA: ls_gr_item TYPE mseg.
** * SELECT SINGLE budat FROM mseg INTO ls_gr_item WHERE
* ...
*
** Check if a GR date was found
**  * IF ls_gr_item-budat IS NOT INITIAL.
** Set the posting date of the ERS invoice
*    E_FRSEG_ERS_CHANGE-ledat  = sy-datum. "<your logic for the date>.
** ENDIF.
** The E_CHANGE flag must be set to 'X' to ensure your changes are adopted
*  e_change = 'X'.
*ENDIF.
