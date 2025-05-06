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

    "Working with Expressions in ABAP SQL

    CONSTANTS c_number TYPE i VALUE 1234.

    SELECT FROM /dmo/carrier
         FIELDS 'Hello'    AS Character,    " Type c
                 1         AS Integer1,     " Type i
                -1         AS Integer2,     " Type i

                @c_number  AS constant      " Type i  (same as constant)

          INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).



    SELECT FROM /dmo/carrier
         FIELDS '19891109'                           AS char_8,
                CAST( '19891109' AS CHAR( 4 ) )      AS char_4,
                CAST( '19891109' AS NUMC( 8  ) )     AS numc_8,

                CAST( '19891109' AS INT4 )          AS integer,
                CAST( '19891109' AS DEC( 10, 2 ) )  AS dec_10_2,
                CAST( '19891109' AS FLTP )          AS fltp,

                CAST( '19891109' AS DATS )          AS date

           INTO TABLE @DATA(result1).

    out->write(
      EXPORTING
        data   = result1
        name   = 'RESULT1'
    ).




    SELECT FROM /dmo/customer
         FIELDS customer_id,
                title,
                CASE title
                  WHEN 'Mr.'  THEN 'Mister'
                  WHEN 'Mrs.' THEN 'Misses'
                  ELSE             ' '
               END AS title_long

        WHERE country_code = 'AT'
         INTO TABLE @DATA(result_simple).

    out->write(
      EXPORTING
        data   = result_simple
        name   = 'RESULT_SIMPLE'
    ).

**********************************************************************

    SELECT FROM /DMO/flight
         FIELDS flight_date,
                seats_max,
                seats_occupied,
                CASE
                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
                  ELSE                                 'This is impossible'
                END AS Booking_State

          WHERE carrier_id    = 'LH'
            AND connection_id = '0400'
           INTO TABLE @DATA(result_complex).

    out->write(
      EXPORTING
        data   = result_complex
        name   = 'RESULT_COMPLEX'
    ).





    ENDMETHOD.
ENDCLASS.
