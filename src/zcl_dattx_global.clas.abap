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
    DATA: wa_flight TYPE /dmo/flight,
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

  ENDMETHOD.
ENDCLASS.
