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

    "Avoiding the Pitfalls of Type Conversions
    "Successful Assignments
    DATA var_string TYPE string.
    DATA var_int TYPE i.
    DATA var_date TYPE d.
    data var_pack type p length 3 decimals 2.


    var_string = `12345`.
    var_int = var_string.


    out->write( TEXT-001 ).


    var_string = `20230101`.
    var_date = var_string.


    out->write( |String value: { var_string }| ).
    out->write( |Date Value: { var_date date = user }| ).

    "Truncation and Rounding
    DATA long_char TYPE c LENGTH 10.
    DATA short_char TYPE c LENGTH 5.


    DATA result TYPE p LENGTH 3 DECIMALS 2.


    long_char = 'ABCDEFGHIJ'.
    short_char = long_char.


    out->write( long_char ).
    out->write( short_char ).


    result = 1 / 8.
    out->write( |1 / 8 is rounded to { result NUMBER = USER }| ).


    "Unexpected Results of Assignments

    DATA var_date1 TYPE d.
    DATA var_int1 TYPE i.
    DATA var_string1 TYPE string.
    DATA var_n TYPE n LENGTH 4.

    var_date1 = cl_abap_context_info=>get_system_date( ).
    var_int1 = var_date1.

    out->write( |Date as date| ).
    out->write( var_date1 ).
    out->write( |Date assigned to integer| ).
    out->write( var_int1 ).

    var_string1 = `R2D2`.
    var_n = var_string1.

    out->write( |String| ).
    out->write( var_string1 ).
    out->write( |String assigned to type N| ).
    out->write( var_n ).

    "Conversions of Forced Type

*     result has type C.
*     and is displayed unformatted in the console

       DATA(result1) = '20230101'.
       out->write( result1 ).

*     result2 is forced to have type D
*     and is displayed with date formatting in the console

       DATA(result2) = CONV d( '20230101' ).
       out->write( result2 ).

    "Prevention of Truncation and Rounding
      DATA var_date2   TYPE d.
      DATA var_pack2   TYPE p LENGTH 3 DECIMALS 2.
      DATA var_string2 TYPE string.
      DATA var_char2   TYPE c LENGTH 3.

     var_pack2 = 1 / 8.
     out->write( |1/8 = { var_pack2 NUMBER = USER }| ).

     TRY.
       var_pack2 = EXACT #( 1 / 8 ).
     CATCH cx_sy_conversion_error.
       out->write( |1/8 has to be rounded. EXACT triggered an exception| ).
     ENDTRY.

     var_string2 = 'ABCDE'.
     var_char2   = var_string.
     out->write( var_char2 ).

     TRY.
       var_char2 = EXACT #( var_string2 ).
     CATCH cx_sy_conversion_error.
       out->write( 'String has to be truncated. EXACT triggered an exception' ).
     ENDTRY.

     var_date2 = 'ABCDEFGH'.
     out->write( var_date2 ).

     TRY.
       var_date2 = EXACT #( 'ABCDEFGH' ).
     CATCH cx_sy_conversion_error.
       out->write( |ABCDEFGH is not a valid date. EXACT triggered an exception| ).
     ENDTRY.


    var_date2 = '20221232'.
    out->write( var_date2 ).


    TRY.
    var_date2 = EXACT #( '20221232' ).
    CATCH cx_sy_conversion_error.
    out->write( |2022-12-32 is not a valid date. EXACT triggered an exception| ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
