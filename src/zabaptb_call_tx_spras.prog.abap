*&---------------------------------------------------------------------*
*& Report ZABAPTB_CALL_TX_SPRAS
*&---------------------------------------------------------------------*
*& Open the transaction in a new mode with a different language
*&---------------------------------------------------------------------*
REPORT zabaptb_call_tx_spras.

PARAMETERS:
  pa_spras TYPE spras OBLIGATORY DEFAULT 'D' VALUE CHECK,
  pa_tcode TYPE tcode OBLIGATORY DEFAULT 'SESSION_MANAGER' MATCHCODE OBJECT prgn_tstc.

START-OF-SELECTION.

  PERFORM call_transaction.

  LEAVE PROGRAM.
*&---------------------------------------------------------------------*
*& Form call_transaction
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
FORM call_transaction .
  SET LOCALE LANGUAGE pa_spras.

  CALL FUNCTION 'ABAP4_CALL_TRANSACTION' STARTING NEW TASK 'CALL_TX_SPRAS' DESTINATION 'NONE'
    EXPORTING
      tcode  = pa_tcode
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'I'.
  ENDIF.
ENDFORM.
