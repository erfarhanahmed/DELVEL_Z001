ENHANCEMENT-POINT DOCUMENT_OUTPUT_ARCH_OBJ_01 SPOTS ES_DOCUMENT_OUTPUT_ARCH_OBJ STATIC INCLUDE BOUND .
*&---------------------------------------------------------------------*
*&  Include  DOCUMENT_OUTPUT_ARCHIVE_OBJECT
*&---------------------------------------------------------------------*

" This include allows for customized logic to be implemented which complies with your business
" requirements for mapping document attributes to an archive object.  Refer to the SAP Note
" 2760477 for further details.

" The following commented code respresents some sample code for how to determine archive object for
" SD document based on document attributes: Sales Organization, Company Code and Shipping Point.
" This sample code does not represent a standard SAP implementation, it is meant only as a guide for
" developing your own solution.  To meet your business requirements for deteriming the archive object
" use the enhancement spot 'ES_DOCUMENT_OUTPUT_ARCH_OBJ' to customize your own implementation.

*  TYPES: BEGIN OF t_docfld_ty,
*           artyp TYPE char4,      " Archive category (1,2,3,4 and 5) that combinations of document attributes are assigned to
*           vkorg TYPE vkorg,      " Sales Organization
*           bukrs TYPE bukrs,      " Company Code
*           vstel TYPE vstel,      " Shipping Point
*           aridx TYPE char4,      " Archive index identifying a combination of document attributes within an archive category
*         END OF t_docfld_ty.
*
*  TYPES: BEGIN OF t_arcobj_ty,
*           kappl TYPE kappl,      " Output Application
*           artyp TYPE char4,      " Archive category (1,2,3,4 and 5) that combinations of document attributes are assigned to
*           aridx TYPE char4,      " Archive index identifying a combination of document attributes within an archive category
*           vbtyp TYPE vbtyp,      " SD Document Category
*           typof TYPE char4,      " Type of document: AUART / FKART
*           arobj TYPE saeobject,  " Archive Object
*         END OF t_arcobj_ty.
*
*  TYPES: BEGIN OF t_invdtl_ty,
*           posnr TYPE posnr,      " Number Of Document Item
*           vstel TYPE vstel,      " Shipping Point
*         END OF t_invdtl_ty.
*
*  TYPES: BEGIN OF objky_ty,
*           vbeln TYPE vbeln,      " Document Number
*           posnr TYPE posnr,      " Number Of Document Item
*         END OF objky_ty.
*
*  TYPES: BEGIN OF dochdr_typ,
*           vkorg TYPE vkorg,      " Sales Organization
*           vbtyp TYPE vbtyp,      " SD Document Category
*         END OF dochdr_typ.
*
*  STATICS ls_arobj TYPE saeobject.
*
*  DATA ls_artyp TYPE char4.
*  DATA ls_vkorg TYPE vkorg.
*  DATA ls_bukrs TYPE bukrs.
*  DATA ls_vbtyp TYPE vbtyp.
*  DATA ls_typof TYPE char4.
*  DATA ls_vstel TYPE vstel.
*  DATA lv_blksz TYPE i VALUE 10."100.
*  DATA lv_dtlix TYPE i VALUE 0.
*  DATA ln_lwbnd TYPE posnr VALUE 000000.
*  DATA ln_upbnd TYPE posnr VALUE 999999.
*  DATA ls_dochdr TYPE dochdr_typ.
*  DATA lb_search TYPE abap_bool VALUE abap_true.
*  DATA lb_mapped TYPE abap_bool VALUE abap_false.
*  DATA ls_objky TYPE objky_ty.
*  DATA t_docfld_t TYPE STANDARD TABLE OF t_docfld_ty WITH KEY artyp vkorg bukrs vstel.
*  DATA t_arcobj_t TYPE STANDARD TABLE OF t_arcobj_ty WITH KEY kappl artyp aridx vbtyp typof.
*  DATA t_invdtl_t TYPE STANDARD TABLE OF t_invdtl_ty WITH KEY posnr vstel.
*
*  FIELD-SYMBOLS <fs_docfld> TYPE t_docfld_ty.
*  FIELD-SYMBOLS <fs_arcobj> TYPE t_arcobj_ty.
*  FIELD-SYMBOLS <fs_invdtl> TYPE t_invdtl_ty.
*
*  " archiving object only needs to be determined once as it will be used for all subsequent document copies
*  IF ( ls_arobj IS INITIAL ).
*
*    " write your customized logic to populate the temporary table with your set of document
*    " fields mapped to an internal archive identifier:
*
*    " ARTYP = 0001: sales organization only
*    "         0002: company code only
*    "         0003: shipping point only
*    "         0004: combination of sales organization and company code
*    "         0005: combination of sales organization, company code and shipping point
*
*    t_docfld_t = VALUE #(
*                   ( artyp = '0001' vkorg = '0001' bukrs = '0000' vstel = '0000' aridx = '0001')
*                   ( artyp = '0001' vkorg = '9999' bukrs = '0000' vstel = '0000' aridx = '0002') " <- results in arobj separate from artyp = 0001 / aridx = 0001
*                   ( artyp = '0002' vkorg = '0000' bukrs = '0001' vstel = '0000' aridx = '0001')
*                   ( artyp = '0003' vkorg = '0000' bukrs = '0000' vstel = '0002' aridx = '0001')
*                   ( artyp = '0004' vkorg = '0001' bukrs = '0001' vstel = '0000' aridx = '0001')
*                   ( artyp = '0004' vkorg = '9999' bukrs = '9999' vstel = '0000' aridx = '0002') " <- results in arobj separate from artyp = 0004 / aridx = 0001
*                   ( artyp = '0005' vkorg = '0001' bukrs = '0001' vstel = '0002' aridx = '0001')
*                   ( artyp = '0005' vkorg = '0770' bukrs = '0001' vstel = '0002' aridx = '0001') " <- results in arobj same as artyp = 0005 / aridx = 0001
*                 ).
*
*    SORT t_docfld_t ASCENDING.
*
*    " write your customized logic to populate the temporary table with your output applicaton,
*    " internal archive identifier and document type mapped to an archive object:
*
*    t_arcobj_t = VALUE #(
*                   ( kappl = 'V1' artyp = '0001' aridx = '0001' vbtyp = 'C' typof = '' arobj = 'SDOORDER' )
*                   ( kappl = 'V1' artyp = '0001' aridx = '0002' vbtyp = 'C' typof = '' arobj = 'SDOORD_2' )
*                   ( kappl = 'V3' artyp = '0001' aridx = '0001' vbtyp = 'M' typof = '' arobj = 'SDOINVOICE' )
*                   ( kappl = 'V3' artyp = '0001' aridx = '0002' vbtyp = 'M' typof = '' arobj = 'SDOINV_2' )
*                   ( kappl = 'V1' artyp = '0002' aridx = '0001' vbtyp = 'C' typof = '' arobj = 'SDOORDER' )
*                   ( kappl = 'V3' artyp = '0002' aridx = '0001' vbtyp = 'M' typof = '' arobj = 'SDOINVOICE' )
*                   ( kappl = 'V1' artyp = '0003' aridx = '0001' vbtyp = 'C' typof = '' arobj = 'SDOORDER' )
*                   ( kappl = 'V3' artyp = '0003' aridx = '0001' vbtyp = 'M' typof = '' arobj = 'SDOINVOICE' )
*                   ( kappl = 'V1' artyp = '0004' aridx = '0001' vbtyp = 'C' typof = '' arobj = 'SDOORDER' )
*                   ( kappl = 'V1' artyp = '0004' aridx = '0002' vbtyp = 'C' typof = '' arobj = 'SDOORD_3' )
*                   ( kappl = 'V3' artyp = '0004' aridx = '0001' vbtyp = 'M' typof = '' arobj = 'SDOINVOICE' )
*                   ( kappl = 'V3' artyp = '0004' aridx = '0002' vbtyp = 'M' typof = '' arobj = 'SDOINV_3' )
*                   ( kappl = 'V1' artyp = '0005' aridx = '0001' vbtyp = 'C' typof = '' arobj = 'SDOORDER' )
*                   ( kappl = 'V3' artyp = '0005' aridx = '0001' vbtyp = 'M' typof = '' arobj = 'SDOINVOICE' )
*                 ).
*
*    " separate objky into document number and item number (default to 000000 if not supplied)
*    CONCATENATE nast-objky '000000' INTO DATA(ls_buf).
*    DESCRIBE FIELD ls_objky LENGTH DATA(ln_len) IN CHARACTER MODE.
*    ls_buf = substring( val = ls_buf len = ln_len ).
*    MOVE ls_buf TO ls_objky.
*
*    " type of document is not currently used in mapping to archive object so it is defaulted to an initial
*    " value.  Enhance select statements and structure ls_dochdr to retrieve value for type of document type
*    " from document header if required for mapping to archive object.
*    CLEAR ls_typof.
*
*    " get sales organization, document category from document header
*    CASE nast-kappl.
*        WHEN 'V1'. SELECT SINGLE vkorg vbtyp FROM vbak INTO ls_dochdr WHERE ( vbeln = ls_objky-vbeln ).
*        WHEN 'V3'. SELECT SINGLE vkorg vbtyp FROM vbrk INTO ls_dochdr WHERE ( vbeln = ls_objky-vbeln ).
*      WHEN OTHERS.
*        sy-subrc = 4. " output application not supported
*    ENDCASE.
*    " if document found, set archive search criteria from document attributes
*    IF ( sy-subrc IS INITIAL ).
*      ls_vkorg = ls_dochdr-vkorg.
*      ls_vbtyp = ls_dochdr-vbtyp.
*      " get company code associated sales organization
*      SELECT SINGLE bukrs FROM tvko INTO ls_bukrs WHERE vkorg = ls_vkorg.
*      IF ( sy-subrc IS NOT INITIAL ).
*        CLEAR ls_bukrs.
*      ENDIF.
*    ELSE.
*      CLEAR ls_vkorg.
*      CLEAR ls_bukrs.
*      CLEAR ls_vbtyp.
*    ENDIF.
*
*    ls_artyp = '0004'.
*    " attempt to map combination of sales organization and company code to archive object
*    IF ( ( ls_vkorg <> '0000' ) AND ( ls_bukrs <> '0000' ) AND ( lb_mapped = abap_false ) ).
*      READ TABLE t_docfld_t WITH KEY artyp = ls_artyp vkorg = ls_vkorg bukrs = ls_bukrs vstel = '0000' ASSIGNING <fs_docfld>.
*      IF ( sy-subrc IS INITIAL ).
*        READ TABLE t_arcobj_t WITH KEY kappl = nast-kappl artyp = ls_artyp aridx = <fs_docfld>-aridx vbtyp = ls_vbtyp typof = ls_typof ASSIGNING <fs_arcobj>.
*        IF ( sy-subrc IS INITIAL ).
*          lb_mapped = abap_true.
*          ls_arobj = <fs_arcobj>-arobj.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    ls_artyp = '0001'.
*    " attempt to map sales organization to archive object
*    IF ( ( ls_vkorg <> '0000' ) AND ( lb_mapped = abap_false ) ).
*      READ TABLE t_docfld_t WITH KEY artyp = ls_artyp vkorg = ls_vkorg bukrs = '0000' vstel = '0000' ASSIGNING <fs_docfld>.
*      IF ( sy-subrc IS INITIAL ).
*        READ TABLE t_arcobj_t WITH KEY kappl = nast-kappl artyp = ls_artyp aridx = <fs_docfld>-aridx vbtyp = ls_vbtyp typof = ls_typof ASSIGNING <fs_arcobj>.
*        IF ( sy-subrc IS INITIAL ).
*          lb_mapped = abap_true.
*          ls_arobj = <fs_arcobj>-arobj.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    ls_artyp = '0002'.
*    " attempt to map company code to archive object
*    IF ( ( ls_bukrs <> '0000' ) AND ( lb_mapped = abap_false ) ).
*      READ TABLE t_docfld_t WITH KEY artyp = ls_artyp vkorg = '0000' bukrs = ls_bukrs vstel = '0000' ASSIGNING <fs_docfld>.
*      IF ( sy-subrc IS INITIAL ).
*        READ TABLE t_arcobj_t WITH KEY kappl = nast-kappl artyp = ls_artyp aridx = <fs_docfld>-aridx vbtyp = ls_vbtyp typof = ls_typof ASSIGNING <fs_arcobj>.
*        IF ( sy-subrc IS INITIAL ).
*          lb_mapped = abap_true.
*          ls_arobj = <fs_arcobj>-arobj.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    " attempt to map shipping point to archive object
*    IF ( lb_mapped = abap_false ).
*      " determine if any shipping points need to be mapped
*      ls_artyp = '0005'.
*      READ TABLE t_docfld_t WITH KEY artyp = ls_artyp TRANSPORTING NO FIELDS.
*      IF ( sy-subrc IS INITIAL ).
*        lv_dtlix = lv_dtlix + 1. " mapping by sales organization, company code and shipping point
*      ENDIF.
*      ls_artyp = '0003'.
*      READ TABLE t_docfld_t WITH KEY artyp = ls_artyp TRANSPORTING NO FIELDS.
*      IF ( sy-subrc IS INITIAL ).
*        lv_dtlix = lv_dtlix + 2. " mapping by shipping point
*      ENDIF.
*      " number of document items can vary so first check if shipping points need to be mapped?
*      IF ( lv_dtlix > 0 ).
*        " search for matching shipping point in the document item detail
*        WHILE ( lb_search = abap_true ).
*          " select the document item details
*          CASE nast-kappl.
*            WHEN 'V1'.
*              IF ( ls_objky-posnr IS INITIAL ).
*                " select next block of document item details if detail item not specified in nast object key
*                SELECT posnr vstel FROM vbap UP TO lv_blksz ROWS INTO TABLE t_invdtl_t WHERE ( vbeln = ls_objky-vbeln ) AND ( posnr > ln_lwbnd AND posnr <= ln_upbnd ) ORDER BY posnr.
*              ELSE.
*                " select document item detail for specified item in nast object key
*                SELECT posnr vstel FROM vbap INTO TABLE t_invdtl_t WHERE ( vbeln = ls_objky-vbeln ) AND ( posnr = ls_objky-posnr ).
*              ENDIF.
*            WHEN 'V3'.
*              IF ( ls_objky-posnr IS INITIAL ).
*                " select next block of document item details if detail item not specified in nast object key
*                SELECT posnr vstel FROM vbrp UP TO lv_blksz ROWS INTO TABLE t_invdtl_t WHERE ( vbeln = ls_objky-vbeln ) AND ( posnr > ln_lwbnd AND posnr <= ln_upbnd ) ORDER BY posnr.
*              ELSE.
*                " select document item detail for specified item in nast object key
*                SELECT posnr vstel FROM vbrp INTO TABLE t_invdtl_t WHERE ( vbeln = ls_objky-vbeln ) AND ( posnr = ls_objky-posnr ).
*              ENDIF.
*            WHEN OTHERS.
*              sy-subrc = 4. " output application not supported
*          ENDCASE.
*          IF ( sy-subrc IS NOT INITIAL ).
*            " quit searching if document item(s) have been processed without mapping shipping point to archive object
*            lb_search = abap_false.
*          ELSE.
*            " process document item detail
*            LOOP AT t_invdtl_t ASSIGNING <fs_invdtl>.
*              IF ( ( lb_mapped = abap_false ) AND ( ( lv_dtlix = 1 ) OR ( lv_dtlix = 3 ) ) ).
*                ls_artyp = '0005'.
*                " attempt to map combination of sales organization, company code and shipping point to archive object
*                READ TABLE t_docfld_t WITH KEY artyp = ls_artyp vkorg = ls_vkorg bukrs = ls_bukrs vstel = <fs_invdtl>-vstel ASSIGNING <fs_docfld>.
*                IF ( sy-subrc IS INITIAL ).
*                  READ TABLE t_arcobj_t WITH KEY kappl = nast-kappl artyp = ls_artyp aridx = <fs_docfld>-aridx vbtyp = ls_vbtyp typof = ls_typof ASSIGNING <fs_arcobj>.
*                  IF ( sy-subrc IS INITIAL ).
*                    lb_mapped = abap_true.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*              IF ( ( lb_mapped = abap_false ) AND ( ( lv_dtlix = 2 ) OR ( lv_dtlix = 3 ) ) ).
*                ls_artyp = '0003'.
*                " attempt to map shipping point to archive object
*                READ TABLE t_docfld_t WITH KEY artyp = ls_artyp vkorg = '0000' bukrs = '0000' vstel = <fs_invdtl>-vstel ASSIGNING <fs_docfld>.
*                IF ( sy-subrc IS INITIAL ).
*                  READ TABLE t_arcobj_t WITH KEY kappl = nast-kappl artyp = ls_artyp aridx = <fs_docfld>-aridx vbtyp = ls_vbtyp typof = ls_typof ASSIGNING <fs_arcobj>.
*                  IF ( sy-subrc IS INITIAL ).
*                    lb_mapped = abap_true.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*              IF ( lb_mapped = abap_true ).
*                " shipping point was successfully mapped so quit searching for document item detail
*                ls_arobj = <fs_arcobj>-arobj.
*                lb_search = abap_false.
*                EXIT.
*              ELSEIF ( ls_objky-posnr IS NOT INITIAL ).
*                " shipping point not mapped, so quit searching for the specific document item detail
*                lb_search = abap_false.
*                EXIT.
*              ENDIF.
*              " set lower bound for selecting next batch ofdocument items details
*              ln_lwbnd = <fs_invdtl>-posnr.
*            ENDLOOP.
*          ENDIF.
*        ENDWHILE.
*      ENDIF.
*    ENDIF.
*
*    " was a mapping of archive object found?
*    IF ( lb_mapped = abap_true ).
*      toa_dara-ar_object = ls_arobj.
*    ELSE.
*      " if mapping not found, uncomment following code and set value of default archive object as required.  (Leave the
*      " statements commented out if archive object customized in output type shall continue to be used as the default)
**      CASE nast-kappl.
**        WHEN 'V1'.
**          CASE ls_vbtyp.
**            WHEN 'C'. toa_dara-ar_object = 'SDOORDER'.
**            WHEN OTHERS.
**              CLEAR toa_dara-ar_object.  " document category not supported
**          ENDCASE.
**        WHEN 'V3'.
**          CASE ls_vbtyp.
**            WHEN 'M'. toa_dara-ar_object = 'SDOINVOICE'.
**            WHEN OTHERS.
**              CLEAR toa_dara-ar_object.  " document category not supported
**          ENDCASE.
**        WHEN OTHERS.
**          CLEAR toa_dara-ar_object. " output application not supported
**      ENDCASE.
*      " set value of mapped archive object to ensure existing logic will not be executed if copies are required
*      ls_arobj = toa_dara-ar_object.
*    ENDIF.
*  ENDIF.
