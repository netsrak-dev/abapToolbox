*----------------------------------------------------------------------*
*       CLASS ZCL_ABAPTB_BADI DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS zcl_abaptb_badi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_column_name_imp_class TYPE lvc_fname VALUE 'IMP_CLASS'. "#EC NOTEXT
    CONSTANTS gc_column_name_exit_name TYPE lvc_fname VALUE 'EXIT_NAME'. "#EC NOTEXT
    CONSTANTS gc_column_name_interface_name TYPE lvc_fname VALUE 'INTER_NAME'. "#EC NOTEXT
    CONSTANTS gc_column_name_imp_name TYPE lvc_fname VALUE 'IMP_NAME'. "#EC NOTEXT

    METHODS list_badi_implementation
      RAISING
        zcx_abaptb_badi .
  PROTECTED SECTION.

    TYPES:
      tt_badi_implementation TYPE STANDARD TABLE OF v_ext_imp .
  PRIVATE SECTION.

    DATA gt_badi_implementation TYPE tt_badi_implementation .

    CLASS-METHODS open_badi
      IMPORTING
        !iv_tcode TYPE tcode
        !iv_badi_name TYPE exit_def .
    CLASS-METHODS open_enhancemenrt_impl
      IMPORTING
        !iv_tcode TYPE tcode
        !iv_enh_badi_impl TYPE exit_imp .
    CLASS-METHODS open_class
      IMPORTING
        !iv_tcode TYPE tcode
        !iv_class_name TYPE seoclsname .
    METHODS on_link_click
      FOR EVENT link_click OF cl_salv_events_table
      IMPORTING
        !row
        !column .
    METHODS read_badi_implementation .
ENDCLASS.



CLASS ZCL_ABAPTB_BADI IMPLEMENTATION.


  METHOD list_badi_implementation.
    DATA:
      lv_sheet_title TYPE lvc_title,
      lr_salv_table	TYPE REF TO cl_salv_table,
      lr_error_salv TYPE REF TO cx_salv_msg,
      lr_column TYPE REF TO cl_salv_column_table,
      lr_events TYPE REF TO cl_salv_events_table.

    lv_sheet_title = 'Overview BAdi Implementation'(001).

    me->read_badi_implementation( ).

    IF gt_badi_implementation IS NOT INITIAL.
      TRY.
          cl_salv_table=>factory(
            EXPORTING list_display = if_salv_c_bool_sap=>false
            IMPORTING r_salv_table = lr_salv_table
            CHANGING  t_table      = gt_badi_implementation ).

          " SALV settings
          lr_salv_table->get_functions( )->set_all( abap_true ).
          lr_salv_table->get_columns( )->set_optimize( abap_true ).
          lr_salv_table->get_display_settings( )->set_list_header( lv_sheet_title ).

          " Set hotspot
          lr_column ?= lr_salv_table->get_columns( )->get_column( gc_column_name_interface_name ).
          lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
          lr_column ?= lr_salv_table->get_columns( )->get_column( gc_column_name_imp_class ).
          lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
          lr_column ?= lr_salv_table->get_columns( )->get_column( gc_column_name_imp_name ).
          lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
          lr_column ?= lr_salv_table->get_columns( )->get_column( gc_column_name_exit_name ).
          lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

          " Set Event handler
          lr_events = lr_salv_table->get_event( ).
          SET HANDLER on_link_click FOR lr_events.

          lr_salv_table->display( ).

        CATCH cx_salv_not_found.
          RETURN.

        CATCH cx_salv_msg INTO lr_error_salv.
          RAISE EXCEPTION TYPE zcx_abaptb_badi
            EXPORTING
              previous = lr_error_salv.
      ENDTRY.

    ENDIF.

  ENDMETHOD.                    "list_badi_implementation


  METHOD on_link_click.

    FIELD-SYMBOLS: <ls_badi_implementation> LIKE LINE OF gt_badi_implementation.

    READ TABLE gt_badi_implementation ASSIGNING <ls_badi_implementation> INDEX row.

    CASE column.
      WHEN gc_column_name_interface_name.
        IF sy-subrc = 0.
          open_class( iv_tcode = 'SE24'
                      iv_class_name = <ls_badi_implementation>-inter_name ).
        ENDIF.

      WHEN gc_column_name_imp_class.
        IF sy-subrc = 0.
          open_class( iv_tcode = 'SE24'
                      iv_class_name = <ls_badi_implementation>-imp_class ).
        ENDIF.

      WHEN gc_column_name_imp_name.
        IF sy-subrc = 0.
          open_enhancemenrt_impl( iv_tcode = 'SE19'
                                  iv_enh_badi_impl = <ls_badi_implementation>-imp_name ).
        ENDIF.

      WHEN gc_column_name_exit_name.
        IF sy-subrc = 0.
          open_badi( iv_tcode = 'SE18'
                     iv_badi_name = <ls_badi_implementation>-exit_name ).
        ENDIF.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.                    "on_link_click


  METHOD open_badi.

    DATA:
      lt_bdcdata TYPE STANDARD TABLE OF bdcdata,
      ls_bdcdata LIKE LINE OF lt_bdcdata,
      ls_opt TYPE ctu_params.

    " Selection Radio Button and Field 'BAdI Name' Activation
    CLEAR: ls_bdcdata.
    ls_bdcdata-program = 'SAPLSEXO'.
    ls_bdcdata-dynpro = '0100'.
    ls_bdcdata-dynbegin = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_CURSOR'.
    ls_bdcdata-fval = 'G_IS_BADI'.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_IS_BADI'.
    ls_bdcdata-fval = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_OKCODE'.
    ls_bdcdata-fval = '=ISSPOT'.
    APPEND ls_bdcdata TO lt_bdcdata.

    " Enter BAdI name
    CLEAR: ls_bdcdata.
    ls_bdcdata-program = 'SAPLSEXO'.
    ls_bdcdata-dynpro = '0100'.
    ls_bdcdata-dynbegin = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_CURSOR'.
    ls_bdcdata-fval = 'G_BADINAME'.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_IS_BADI'.
    ls_bdcdata-fval = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_BADINAME'.
    ls_bdcdata-fval = iv_badi_name.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_OKCODE'.
    ls_bdcdata-fval = '=SHOW'.
    APPEND ls_bdcdata TO lt_bdcdata.


    ls_opt-dismode = 'E'.

    CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
      EXPORTING
        tcode  = iv_tcode
      EXCEPTIONS
        ok     = 1
        not_ok = 2
        OTHERS = 3.
    IF sy-subrc = 1.
      CALL TRANSACTION iv_tcode USING lt_bdcdata OPTIONS FROM ls_opt. "#EC CI_CALLTA
    ENDIF.

  ENDMETHOD.                    "open_badi


  METHOD open_class.
    DATA:
      ls_bdcdata TYPE bdcdata,
      lt_bdcdata LIKE TABLE OF ls_bdcdata,
      ls_opt TYPE ctu_params.

    CLEAR ls_bdcdata.
    ls_bdcdata-program  = 'SAPLSEOD'.
    ls_bdcdata-dynpro   = '1000'.
    ls_bdcdata-dynbegin = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_CURSOR'.
    ls_bdcdata-fval = 'SEOCLASS-CLSNAME'.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR ls_bdcdata.
    ls_bdcdata-fnam = 'SEOCLASS-CLSNAME'.
    ls_bdcdata-fval = iv_class_name.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_OKCODE'.
    ls_bdcdata-fval = '=WB_DISPLAY'.
    APPEND ls_bdcdata TO lt_bdcdata.

    ls_opt-dismode = 'E'.

    CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
      EXPORTING
        tcode  = iv_tcode
      EXCEPTIONS
        ok     = 1
        not_ok = 2
        OTHERS = 3.
    IF sy-subrc = 1.
      CALL TRANSACTION iv_tcode USING lt_bdcdata OPTIONS FROM ls_opt. "#EC CI_CALLTA
    ENDIF.

  ENDMETHOD.                    "open_class


  METHOD open_enhancemenrt_impl.

    DATA:
      lt_bdcdata TYPE STANDARD TABLE OF bdcdata,
      ls_bdcdata LIKE LINE OF lt_bdcdata,
      ls_opt TYPE ctu_params.

    " Selection Radio Button and Field 'BAdI Name' Activation
    CLEAR: ls_bdcdata.
    ls_bdcdata-program = 'SAPLSEXO'.
    ls_bdcdata-dynpro = '0120'.
    ls_bdcdata-dynbegin = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_CURSOR'.
    ls_bdcdata-fval = 'G_ENHNAME'.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_IS_NEW_1'.
    ls_bdcdata-fval = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_IS_NEW_2'.
    ls_bdcdata-fval = abap_on.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'G_ENHNAME'.
    ls_bdcdata-fval = iv_enh_badi_impl.
    APPEND ls_bdcdata TO lt_bdcdata.

    CLEAR: ls_bdcdata.
    ls_bdcdata-fnam = 'BDC_OKCODE'.
    ls_bdcdata-fval = '=IMP_SHOW'.
    APPEND ls_bdcdata TO lt_bdcdata.


    ls_opt-dismode = 'E'.

    CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
      EXPORTING
        tcode  = iv_tcode
      EXCEPTIONS
        ok     = 1
        not_ok = 2
        OTHERS = 3.
    IF sy-subrc = 1.
      CALL TRANSACTION iv_tcode USING lt_bdcdata OPTIONS FROM ls_opt. "#EC CI_CALLTA
    ENDIF.

  ENDMETHOD.                    "open_enhancemenrt_impl


  METHOD read_badi_implementation.
    CLEAR: gt_badi_implementation.

    SELECT *
      INTO TABLE gt_badi_implementation
      FROM v_ext_imp
        WHERE imp_name LIKE 'Z%'.
    IF sy-subrc <> 0.
      CLEAR: gt_badi_implementation.
    ENDIF.

  ENDMETHOD.                    "read_badi_implementation
ENDCLASS.
