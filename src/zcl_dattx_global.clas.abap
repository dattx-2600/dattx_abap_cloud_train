CLASS zcl_dattx_global DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_dattx_global IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ty_connection,
         airlineid               TYPE /dmo/carrier_id,
         connectionid            TYPE /dmo/connection_id,
         departureairport        TYPE /dmo/airport_id,
         destinationairport      TYPE /dmo/airport_id,
         airline_id              TYPE /dmo/carrier_id,  " Từ _Airline
         airline_name            TYPE /dmo/carrier_name,  " Từ _Airline
         departure_airport_id    TYPE /dmo/airport_id,  " Từ _DepartureAirport
         departure_airport_name  TYPE /dmo/airport_name,  " Từ _DepartureAirport
         destination_airport_id  TYPE /dmo/airport_id,  " Từ _DestinationAirport
         destination_airport_name TYPE /dmo/airport_name,  " Từ _DestinationAirport
       END OF ty_connection.

    DATA: wa_flight TYPE /dmo/flight,
          wa_connection TYPE /DMO/I_Connection,
          wa_connection1 TYPE ty_connection,
          lv_carrier_id TYPE /dmo/flight-carrier_id VALUE 'AA',
          lv_connection_id TYPE /dmo/flight-connection_id VALUE '0322',
          lv_flight_exists TYPE abap_bool.

    "Call functional method
    lv_flight_exists = lcl_flight=>get_instance( )->check_flight_exists(
      i_carrier_id = lv_carrier_id
      i_connection_id = lv_connection_id
    ).

    IF lv_flight_exists = abap_false.
        out->write( |Không tìm thấy chuyến bay với Carrier ID { lv_carrier_id } và Connection ID { lv_connection_id }.| ).
    ENDIF.
    "Handle exceptions.
    TRY.
    "Call instance method.
        lcl_flight=>get_instance( )->get_flight(
          EXPORTING
            i_carrier_id = lv_carrier_id
            i_connection_id = lv_connection_id
          IMPORTING
            es_flight = wa_flight
        ).

        out->write( |Thông tin chuyến bay: | ).
        out->write( wa_flight ).
      CATCH cx_sy_open_sql_db INTO DATA(lx_error).
        out->write( |Lỗi: { lx_error->get_text( ) }| ).
      CATCH cx_root INTO DATA(lx_root).
        out->write( |Lỗi không xác định: { lx_root->get_text( ) }| ).
    ENDTRY.

    "Use the Constructor
    DATA: connection TYPE REF TO lcl_instance_constructor.
    TRY.
       connection = NEW #(
                           i_carrier_id    = 'LH'
                           i_connection_id = '0400'
                         ).
        out->write( `New instance created:.` ).
        out->write( connection ).
        "Read private attribute from global class.
        out->write( |connection count: { connection->get_conn_count(  ) } | ).
    CATCH cx_abap_invalid_value.
        out->write( `Create new instance failed.` ).
    ENDTRY.

    "Run method with query using cds view
    TRY.
        lcl_flight=>get_instance( )->get_flight_with_cds(
          EXPORTING
            i_carrier_id = lv_carrier_id
            i_connection_id = lv_connection_id
          IMPORTING
            es_connection = wa_connection
        ).

        out->write( |Run method with query using cds view: | ).
        out->write( wa_connection ).

        lcl_flight=>get_instance( )->get_flight_with_cds1(
          EXPORTING
            i_carrier_id = lv_carrier_id
            i_connection_id = lv_connection_id
          IMPORTING
            es_connection1 = wa_connection1
        ).

        out->write( |Run method with query using cds view 1: | ).
        out->write( wa_connection1 ).
    CATCH cx_sy_open_sql_db INTO DATA(lx_error1).
        out->write( |Lỗi: { lx_error1->get_text( ) }| ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
