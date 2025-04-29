CLASS ltc_flight_handler DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    CLASS-DATA: cds_test_environment TYPE REF TO if_cds_test_environment.

    " Định nghĩa table type cho mock data
    TYPES: ty_flight_tab TYPE TABLE OF /dmo/i_flight WITH DEFAULT KEY.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      setup,
      teardown,

      test_get_flight_success FOR TESTING RAISING cx_static_check,
      test_get_flight_not_found FOR TESTING RAISING cx_sy_open_sql_db.
ENDCLASS.

CLASS ltc_flight_handler IMPLEMENTATION.
  METHOD class_setup.
    " Tạo môi trường kiểm thử CDS
    cds_test_environment = cl_cds_test_environment=>create(
      i_for_entity = '/DMO/I_FLIGHT'
    ).
    cds_test_environment->enable_double_redirection( ).
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    " Xóa dữ liệu mock trước mỗi test
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    " Không cần làm gì trong teardown
  ENDMETHOD.

  " Test get_flight: Trường hợp thành công
  METHOD test_get_flight_success.
    " Chuẩn bị dữ liệu mock
    TYPES: ty_flight_tab TYPE TABLE OF /dmo/flight WITH DEFAULT KEY.
    DATA(mock_flight) = VALUE ty_flight_tab(
      ( carrier_id = 'AA' connection_id = '0171' flight_date = '20250429' price = '500' )
    ).

    cds_test_environment->insert_test_data(
      i_data = mock_flight
    ).

    " Tạo instance của class cần kiểm thử
    DATA(cut) = NEW lcl_flight( ).

    " Gọi phương thức get_flight
    DATA es_flight TYPE /dmo/flight.
    cut->get_flight(
      EXPORTING
        i_carrier_id    = 'AA'
        i_connection_id = '0171'
      IMPORTING
        es_flight       = es_flight
    ).

    " Kiểm tra kết quả
    cl_abap_unit_assert=>assert_equals(
      act = es_flight-carrier_id
      exp = 'AA'
      msg = 'Expected carrier_id to be AA'
    ).

    cl_abap_unit_assert=>assert_equals(
      act = es_flight-connection_id
      exp = '0171'
      msg = 'Expected connection_id to be 0171'
    ).
  ENDMETHOD.

  " Test get_flight: Không tìm thấy bản ghi
  METHOD test_get_flight_not_found.
    " Không mock dữ liệu, CDS View /DMO/I_Flight sẽ rỗng
    DATA(cut) = NEW lcl_flight( ).
    DATA es_flight TYPE /dmo/flight.

    TRY.
        cut->get_flight(
          EXPORTING
            i_carrier_id    = 'AA'
            i_connection_id = '0171'
          IMPORTING
            es_flight       = es_flight
        ).
        cl_abap_unit_assert=>fail(
          msg   = 'Expected zcx_flight_error exception for non-existing flight'
        ).
        CATCH cx_sy_open_sql_db INTO DATA(lx_flight_error).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
