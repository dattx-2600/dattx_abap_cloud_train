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

    flight = NEW lcl_domestic_flight( ).
    flight->if_dattx_flight~set_flight_data(
      carrier_id     = 'SQ'
      connection_id  = '0001'
      flight_date    = '20240101'
    ).

    DATA(domestic_flight) = CAST lcl_domestic_flight( flight ).
    domestic_flight->airport_from = 'SIN'.
    domestic_flight->airport_to = 'KUL'.

    DATA(description) = flight->if_dattx_flight~get_description( ).
    out->write( description ).

    ENDMETHOD.
ENDCLASS.


