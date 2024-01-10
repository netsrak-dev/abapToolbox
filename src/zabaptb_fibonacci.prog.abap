*&---------------------------------------------------------------------*
*& Report ZABAPTB_FIBONACCI
*&---------------------------------------------------------------------*
*& Determine the Fibonacci sequence. 2 possibilities to realize this.
*&---------------------------------------------------------------------*
REPORT zabaptb_fibonacci.

CONSTANTS:
  gc_id                     TYPE vrm_id VALUE 'P_IMPWAY',
  gc_key1                   TYPE c LENGTH 2 VALUE '01',
  gc_key2                   TYPE c LENGTH 2 VALUE '02',
  gc_text1_iterative_method TYPE string VALUE 'Iterative' ##NO_TEXT,
  gc_text2_recursive_method TYPE string VALUE 'Recursive' ##NO_TEXT.

PARAMETERS:
  P_seq    TYPE int8 OBLIGATORY,
  p_impway TYPE char10 AS LISTBOX VISIBLE LENGTH 15 OBLIGATORY.

INITIALIZATION.
  PERFORM initial_list_box.

*&---------------------------------------------------------------------*
*& Class lcl_app
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_app DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-METHODS run IMPORTING iv_sequence           TYPE int8
                                iv_implemented_way    TYPE c
                      RETURNING VALUE(rv_output_text) TYPE string.
  PRIVATE SECTION.
    METHODS run_app IMPORTING iv_sequence           TYPE int8
                              iv_implemented_way    TYPE c
                    RETURNING VALUE(rv_output_text) TYPE string.
    METHODS iterative_determination IMPORTING iv_sequence         TYPE int8
                                    RETURNING VALUE(rv_fibonacci) TYPE int8 .
    METHODS recursive_determination IMPORTING iv_sequence         TYPE int8
                                    RETURNING VALUE(rv_fibonacci) TYPE int8 .
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_app
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_app IMPLEMENTATION.
  METHOD run.
    CLEAR: rv_output_text.
    rv_output_text = NEW lcl_app( )->run_app( iv_sequence        = iv_sequence
                                              iv_implemented_way = iv_implemented_way ).
  ENDMETHOD.

  METHOD run_app.
    CLEAR: rv_output_text.

    DATA: lv_fibonacci TYPE int8.

    CASE iv_implemented_way.
      WHEN gc_key1.
        lv_fibonacci = iterative_determination( iv_sequence  = iv_sequence ).
      WHEN gc_key2.
        lv_fibonacci = recursive_determination( iv_sequence  = iv_sequence ).
      WHEN OTHERS.
        MESSAGE 'Selection does not exists.' TYPE 'E' DISPLAY LIKE 'I' ##NO_TEXT.
    ENDCASE.

    rv_output_text = |Determine for Fibonacci sequence { iv_sequence } number { lv_fibonacci }| ##NO_TEXT.

  ENDMETHOD.

  METHOD iterative_determination.
    CLEAR: rv_fibonacci.

    CONSTANTS: lc_start_loop TYPE i VALUE 2.

    DATA:
      a TYPE int8 VALUE 0,
      b TYPE int8 VALUE 1.

    CASE iv_sequence.
      WHEN 0.
        rv_fibonacci = 0.
      WHEN 1.
        rv_fibonacci = 1.
      WHEN OTHERS.
        DO iv_sequence TIMES.
          IF sy-index < lc_start_loop.
            CONTINUE.
          ENDIF.

          rv_fibonacci = a + b.
          a = b.
          b = rv_fibonacci.
        ENDDO.

    ENDCASE.

  ENDMETHOD.

  METHOD recursive_determination.
*  F(n) = F(n - 1) + F(n - 2)

    CLEAR: rv_fibonacci.

    CASE iv_sequence.
      WHEN 0.
        rv_fibonacci = 0.
      WHEN 1.
        rv_fibonacci = 1.
      WHEN OTHERS.
        rv_fibonacci = recursive_determination( iv_sequence - 1 ) + recursive_determination( iv_sequence - 2 ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Form initial_list_box
*&---------------------------------------------------------------------*
*& Listbox with implemented 2 ways
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
FORM initial_list_box .

  DATA(lt_values) = VALUE vrm_values(
                                      ( key  = gc_key1
                                        text = gc_text1_iterative_method )
                                      ( key  = gc_key2
                                        text = gc_text2_recursive_method )
                                    ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = gc_id
      values          = lt_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'I'.
  ENDIF.

ENDFORM.

START-OF-SELECTION.
  DATA(lv_result) = lcl_app=>run( EXPORTING iv_sequence        = p_seq
                                            iv_implemented_way = p_impway ) ##NEEDED.
  WRITE: / lv_result.

  INCLUDE zabaptb_fibonacci_test.
