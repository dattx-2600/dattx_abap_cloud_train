CLASS zcl_dattx_inherit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dattx_inherit IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
      DATA: flight TYPE REF TO lcl_flight.

    " Tạo instance của subclass
    flight = NEW lcl_domestic_flight( ).

    " Gán giá trị
    flight->carrier_id = 'SQ'.
    flight->connection_id = '0001'.
    flight->flight_date = '20240101'.

    " Gán giá trị cho thuộc tính của subclass
    DATA(domestic_flight) = CAST lcl_domestic_flight( flight ).
    domestic_flight->airport_from = 'SIN'.
    domestic_flight->airport_to = 'KUL'.

    " Gọi phương thức
    DATA(description) = flight->get_description( ).
    out->write( description ).
    ENDMETHOD.
ENDCLASS.
