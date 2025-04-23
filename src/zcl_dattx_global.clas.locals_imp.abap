*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_flight definition.

  public section.
  "Define static method.
  CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_flight.
  "Define instance method.
  METHODS get_flight IMPORTING i_carrier_id TYPE /dmo/flight-carrier_id
                               i_connection_id TYPE /dmo/flight-connection_id
                     EXPORTING es_flight TYPE /dmo/flight
                    RAISING   cx_sy_open_sql_db.
  "Define a functional method.
  METHODS check_flight_exists
      IMPORTING
        i_carrier_id TYPE /dmo/flight-carrier_id
        i_connection_id TYPE /dmo/flight-connection_id
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

  "Use CDS View Entity
  METHODS get_flight_with_cds IMPORTING i_carrier_id TYPE /dmo/flight-carrier_id
                               i_connection_id TYPE /dmo/flight-connection_id
                               EXPORTING es_connection TYPE /DMO/I_Connection.

  CLASS-DATA gv_success TYPE string VALUE 'S'.
  protected section.
  private section.
  "static private attribute
  CLASS-DATA go_instance TYPE REF TO lcl_flight.


endclass.

class lcl_flight implementation.

  METHOD get_instance.
      go_instance = COND #( WHEN go_instance IS BOUND THEN go_instance
                            ELSE NEW #(  ) ).
      ro_instance = go_instance.
  ENDMETHOD.

"Implementing Basic SELECT Statements
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

  method get_flight_with_cds.
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_sy_open_sql_db.
  ENDIF.

  SELECT SINGLE *
    FROM /DMO/I_Connection
    WHERE AirlineID     = @i_carrier_id
    AND ConnectionID  = @i_connection_id
    INTO @es_connection.

  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE cx_sy_open_sql_db.
  ENDIF.
  endmethod.

endclass.

class lcl_instance_constructor definition.

        public section.
        DATA: carrier_id    TYPE /dmo/carrier_id,
              connection_id TYPE /dmo/connection_id.

        METHODS constructor
          IMPORTING
            i_connection_id TYPE /dmo/connection_id
            i_carrier_id    TYPE /dmo/carrier_id
          RAISING
            cx_ABAP_INVALID_VALUE.

        METHODS get_conn_count RETURNING VALUE(rv_count) TYPE i.
        "Define a class constructor
        CLASS-METHODS class_constructor.

        protected section.
        private section.
        "Define a private attribute.
        CLASS-DATA: conn_counter TYPE i.

endclass.

class lcl_instance_constructor implementation.

  METHOD constructor.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->connection_id = i_connection_id.
    me->carrier_id    = i_carrier_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.

  method get_conn_count.
    rv_count = conn_counter.
  endmethod.

  method class_constructor.
    conn_counter = 0.
  endmethod.

endclass.
