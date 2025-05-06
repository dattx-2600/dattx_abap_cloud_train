CLASS zcl_dattx_sql_join DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dattx_sql_join IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    TYPES:
      BEGIN OF st_connections_buffer,
        carrier_id      TYPE /dmo/carrier_id,
        connection_id   TYPE /dmo/connection_id,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        departure_time  TYPE /dmo/flight_departure_time,
        arrival_time    TYPE /dmo/flight_departure_time,
        timzone_from TYPE timezone,
        timzone_to TYPE timezone,
       duration        TYPE i,
      END OF st_connections_buffer.

      DATA: connections_buffer TYPE TABLE OF st_connections_buffer.



    SELECT
      FROM /dmo/airport
    FIELDS airport_id
      INTO TABLE @DATA(airports).

    SELECT
      FROM /dmo/connection AS c
      LEFT OUTER JOIN /dmo/airport AS f
        ON c~airport_from_id = f~airport_id
      LEFT OUTER JOIN /dmo/airport AS t
        ON c~airport_to_id = t~airport_id
    FIELDS carrier_id, connection_id,
           airport_from_id, airport_to_id, departure_time, arrival_time
      INTO TABLE @connections_buffer.

    ENDMETHOD.
ENDCLASS.
