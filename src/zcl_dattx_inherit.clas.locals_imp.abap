*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_plane DEFINITION.
PUBLIC SECTION.
TYPES: BEGIN OF ts_attributes,
name TYPE string,
value TYPE string,
END OF ts_attributes,
* declare table - do not allow the same attribute to be used more than once
tt_attributes TYPE SORTED TABLE OF ts_attributes WITH UNIQUE KEY name.


METHODS constructor IMPORTING iv_manufacturer TYPE string
iv_type TYPE string.
METHODS: get_Attributes RETURNING VALUE(rt_Attributes) TYPE tt_attributes.


PROTECTED SECTION.
DATA manufacturer TYPE string.
DATA type TYPE string.

PRIVATE SECTION.

ENDCLASS.


CLASS lcl_plane IMPLEMENTATION.
METHOD constructor.
manufacturer = iv_manufacturer.
type = iv_type.
ENDMETHOD.


METHOD get_attributes.
rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = manufacturer )
( name = 'TYPE' value = type ) ) .
ENDMETHOD.


ENDCLASS.


CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_plane.
PUBLIC SECTION.
METHODS constructor IMPORTING iv_manufacturer TYPE string
iv_type TYPE string
iv_cargo TYPE i.
METHODS get_attributes REDEFINITION.
private section.
data cargo type i.
ENDCLASS.


CLASS lcl_cargo_plane IMPLEMENTATION.
METHOD constructor.


super->constructor( iv_manufacturer = iv_manufacturer iv_type = iv_type ).
cargo = iv_cargo.


ENDMETHOD.


METHOD get_attributes.


* method uses protected attributes of superclass


rt_attributes = value #( ( name = 'MANUFACTURER' value = manufacturer )
( name = 'TYPE' value = type )
( name ='CARGO' value = cargo ) ).


ENDMETHOD.


ENDCLASS.


CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_Plane.
PUBLIC SECTION.
METHODS constructor IMPORTING iv_manufacturer TYPE string
iv_type TYPE string
iv_seats TYPE i.
METHODS get_Attributes REDEFINITION.
private section.
data seats type i.
ENDCLASS.


CLASS lcl_passenger_plane IMPLEMENTATION.


METHOD constructor.


super->constructor( iv_manufacturer = iv_manufacturer iv_type = iv_type ).


ENDMETHOD.


METHOD get_attributes.


* Redefinition uses call of superclass implementation

rt_attributes = super->get_attributes( ).
rt_Attributes = value #( base rt_attributes ( name = 'SEATS' value = seats ) ).

ENDMETHOD.

ENDCLASS.

CLASS lcl_flight DEFINITION.

  PUBLIC SECTION.
    DATA: carrier_id TYPE /dmo/carrier_id,
          connection_id TYPE /dmo/connection_id,
          flight_date TYPE /dmo/flight_date.

    METHODS: get_description RETURNING VALUE(r_result) TYPE string.
ENDCLASS.

CLASS lcl_flight IMPLEMENTATION.
  METHOD get_description.
    r_result = |Flight { carrier_id } { connection_id } on { flight_date DATE = USER }|.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_domestic_flight DEFINITION
  INHERITING FROM lcl_flight.

  PUBLIC SECTION.
    DATA: airport_from TYPE /dmo/airport_from_id,
          airport_to   TYPE /dmo/airport_to_id.

    METHODS: get_description REDEFINITION. " Ghi đè phương thức của superclass
ENDCLASS.

CLASS lcl_domestic_flight IMPLEMENTATION.
  METHOD get_description.
    " Gọi phương thức của superclass
    DATA(super_description) = super->get_description( ).

    " Mở rộng mô tả với thông tin sân bay
    r_result = |{ super_description } from { airport_from } to { airport_to }|.
  ENDMETHOD.
ENDCLASS.
