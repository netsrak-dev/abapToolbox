*&---------------------------------------------------------------------*
*& Report ZABAPTB_FIZZBUZZ_PROBLEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabaptb_fizzbuzz_problem.

CONSTANTS:
  lc_max_loop TYPE i VALUE 100,
  lc_fizz     TYPE string VALUE 'Fizz' ##NO_TEXT,
  lc_buzz     TYPE string VALUE 'Buzz' ##NO_TEXT.

PARAMETERS: p_proc TYPE char10 AS LISTBOX VISIBLE LENGTH 10 OBLIGATORY.

INITIALIZATION.
  PERFORM initial_list_box.

START-OF-SELECTION.
  CASE p_proc.
    WHEN '01'.
      PERFORM MY_fizzbuzz.
    WHEN '02'.
      PERFORM ai_fizzbuzz.
    WHEN OTHERS.
      MESSAGE 'Selection does not exists.' TYPE 'E' DISPLAY LIKE 'I' ##NO_TEXT.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Form initial_list_box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM initial_list_box .
  CONSTANTS:
    lc_id    TYPE vrm_id VALUE 'P_PROC',
    lc_key1  TYPE c LENGTH 2 VALUE '01',
    lc_key2  TYPE c LENGTH 2 VALUE '02',
    lc_text1 TYPE c LENGTH 12 VALUE 'My FizzBuzz' ##NO_TEXT,
    lc_text2 TYPE c LENGTH 12 VALUE 'AI FizzBuzz' ##NO_TEXT.

  DATA(lt_values) = VALUE vrm_values(
                       ( key  = lc_key1
                         text = lc_text1 )
                       ( key  = lc_key2
                         text = lc_text2 )
                     ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lc_id
      values          = lt_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MY_fizzbuzz
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MY_fizzbuzz .
  DO lc_max_loop TIMES.
    IF ( sy-index MOD 3 ) = 0 AND ( sy-index MOD 5 ) = 0.
      WRITE: / lc_fizz && lc_buzz.
    ELSEIF ( sy-index MOD 3 ) = 0.
      WRITE: / lc_fizz.
    ELSEIF ( sy-index MOD 5 ) = 0.
      WRITE: / lc_buzz.
    ELSE.
      WRITE: / sy-index.
    ENDIF.
  ENDDO.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ai_fizzbuzz
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM ai_fizzbuzz .
  DATA: lv_output TYPE string.

  DO lc_max_loop TIMES.
    CLEAR lv_output.

    IF ( sy-index MOD 3 ) = 0.
      lv_output = lc_fizz.
    ENDIF.

    IF ( sy-index MOD 5 ) = 0.
      CONCATENATE lv_output lc_buzz INTO lv_output.
    ENDIF.

    IF lv_output IS INITIAL.
      lv_output = sy-index.
    ENDIF.

    WRITE: / lv_output.
  ENDDO.

ENDFORM.
