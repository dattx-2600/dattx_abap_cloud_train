*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_flight definition.

  public section.
  CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_flight.

  METHODS get_flight IMPORTING i_carrier_id TYPE /dmo/flight-carrier_id
                               i_connection_id TYPE /dmo/flight-connection_id
                     EXPORTING es_flight TYPE /dmo/flight
                    RAISING   cx_sy_open_sql_db.

  METHODS check_flight_exists
      IMPORTING
        i_carrier_id TYPE /dmo/flight-carrier_id
        i_connection_id TYPE /dmo/flight-connection_id
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

  CLASS-DATA gv_success TYPE string VALUE 'S'.
  protected section.
  private section.
  CLASS-DATA go_instance TYPE REF TO lcl_flight.

endclass.

class lcl_flight implementation.
  METHOD get_instance.
    go_instance = COND #( WHEN go_instance IS BOUND THEN go_instance ELSE NEW #( ) ).
    ro_instance = go_instance.
  ENDMETHOD.


  METHOD get_flight.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
       RAISE EXCEPTION TYPE cx_sy_open_sql_db.
    ENDIF.

     SELECT SINGLE * FROM /dmo/flight WHERE carrier_id = @i_carrier_id AND connection_id = @i_connection_id
      INTO @es_flight.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_open_sql_db.
    ENDIF.

  ENDMETHOD.

  METHOD check_flight_exists.
    SELECT SINGLE @abap_true
      FROM /dmo/flight
      WHERE carrier_id = @i_carrier_id
        AND connection_id = @i_connection_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

endclass.
