*"* use this source file for your ABAP unit test classes
CLASS ltc_units_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    CLASS-DATA: cut TYPE REF TO zcl_abaptb_projecteuler. " Class under test

    CLASS-METHODS: class_setup.

    METHODS: p001_multiples_below_x FOR TESTING.
    METHODS: p002_sum_even_valued_u4mio FOR TESTING.
    METHODS: p003_largest_prime_factor FOR TESTING.
    METHODS: p004_largest_palindrome FOR TESTING.
    METHODS: p005_smallest_num_that_div FOR TESTING.
    METHODS: p006_find_diff_sum_squares FOR TESTING.
    METHODS: p007_determine_x_prime_numer FOR TESTING.

ENDCLASS.

CLASS ltc_units_test IMPLEMENTATION.

  METHOD class_setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD p001_multiples_below_x.
    DATA:
      BEGIN OF ty_exp,
        below   TYPE i,
        exp_sum TYPE i,
      END OF ty_exp,
      lt_exp_sums LIKE TABLE OF ty_exp.

    lt_exp_sums = VALUE #( ( below = 10 exp_sum = 23 )
                           ( below = 1000 exp_sum = 233168 ) ).

    LOOP AT lt_exp_sums REFERENCE INTO DATA(ls_exp_sum).

      DATA(lv_act_sum) = cut->p001_multiples_of_3_or_5( max_loops = ls_exp_sum->below ).

      cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_sum
                                                    exp = ls_exp_sum->exp_sum ).

    ENDLOOP.
  ENDMETHOD.

  METHOD p002_sum_even_valued_u4mio.
    CONSTANTS:
      lc_max_value TYPE i VALUE 4000000,
      lc_exp_sum   TYPE i VALUE 4613732.

    DATA(lv_act_sum) = cut->p002_even_fibonacci_numbers( below_certain_value = lc_max_value ).

    cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_sum
                                                  exp = lc_exp_sum ).
  ENDMETHOD.

  METHOD p003_largest_prime_factor.
    CONSTANTS:
      lc_number                   TYPE int8 VALUE 600851475143,
      lc_exp_largest_prime_factor TYPE int8 VALUE 6857.

    cut->p003_largest_prime_factor( EXPORTING number = lc_number
                                    IMPORTING result = DATA(lv_act_largest_prime_factor) ).

    cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_largest_prime_factor
                                                  exp = lc_exp_largest_prime_factor ).
  ENDMETHOD.

  METHOD p004_largest_palindrome.
    CONSTANTS: lc_act_largest_palindrome TYPE int8 VALUE 906609.

    DATA:
      lv_counter1 TYPE int8 VALUE 999,
      lv_counter2 TYPE int8 VALUE 999.

    DATA(lv_act_largest_palindrome) = cut->p004_largest_palindrome_prod(
          CHANGING counter1 = lv_counter1
                   counter2 = lv_counter2 ).

    cl_abap_unit_assert=>assert_equals( act = lv_act_largest_palindrome
                                        exp = lc_act_largest_palindrome ).

  ENDMETHOD.

  METHOD p005_smallest_num_that_div.
    DATA:
      BEGIN OF ty_exp,
        iteration TYPE int8,
        number    TYPE int8,
      END OF ty_exp,
      lt_exp LIKE TABLE OF ty_exp.

    lt_exp = VALUE #( ( iteration = 10 number = 2520 )
                           ( iteration = 20 number = 232792560 ) ).

    LOOP AT lt_exp REFERENCE INTO DATA(ls_exp).

      DATA(lv_act_smallest_number) = cut->p005_smallest_multiple( iteration = ls_exp->iteration ).

      cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_smallest_number
                                                    exp = ls_exp->number ).
    ENDLOOP.

  ENDMETHOD.

  METHOD p006_find_diff_sum_squares.
    DATA:
      BEGIN OF ty_exp,
        iteration TYPE int8,
        sum_diff  TYPE int8,
      END OF ty_exp,
      lt_exp LIKE TABLE OF ty_exp.

    lt_exp = VALUE #( ( iteration = 10 sum_diff = 2640 )
                      ( iteration = 100 sum_diff = 25164150 ) ).

    LOOP AT lt_exp REFERENCE INTO DATA(ls_exp).

      DATA(lv_act_sum_diff) = cut->p006_sum_square_difference( iteration = ls_exp->iteration ).

      cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_sum_diff
                                                    exp = ls_exp->sum_diff ).
    ENDLOOP.
  ENDMETHOD.

  METHOD p007_determine_x_prime_numer.
    DATA:
      BEGIN OF ty_exp,
        x_prime_number TYPE int8,
        prime_number   TYPE int8,
      END OF ty_exp,
      lt_exp LIKE TABLE OF ty_exp.

    lt_exp = VALUE #( ( x_prime_number = 6 prime_number = 13 )
                      ( x_prime_number = 10001 prime_number = 104743 ) ).

    LOOP AT lt_exp REFERENCE INTO DATA(ls_exp).

      DATA(lv_act_prime_number) = cut->p007_10001st_prime( xth_prime_number = ls_exp->x_prime_number ).

      cl_abap_unit_assert=>assert_equals( EXPORTING act = lv_act_prime_number
                                                    exp = ls_exp->prime_number ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
