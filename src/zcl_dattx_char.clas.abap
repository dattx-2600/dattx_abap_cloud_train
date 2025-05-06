CLASS zcl_dattx_char DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_dattx_char IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
    "Common Parameters of String Functions
        DATA text   TYPE string VALUE `  Let's talk about ABAP  `.
        DATA result TYPE i.

        out->write(  text ).

        result = find( val = text sub = 'A' ).
*
       result = find( val = text sub = 'A' case = abap_false ).
*
        result = find( val = text sub = 'A' case = abap_false occ =  -1 ).
        result = find( val = text sub = 'A' case = abap_false occ =  -2 ).
        result = find( val = text sub = 'A' case = abap_false occ =   2 ).
*
        result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 ).
        result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 len = 4 ).

        out->write( |RESULT = { result } | ).




       "Processing Functions

DATA text2 TYPE string      VALUE ` SAP BTP,   ABAP Environment  `.

* Change Case of characters
**********************************************************************
    out->write( |TO_UPPER         = {   to_upper(  text2 ) } | ).
    out->write( |TO_LOWER         = {   to_lower(  text2 ) } | ).
    out->write( |TO_MIXED         = {   to_mixed(  text2 ) } | ).
    out->write( |FROM_MIXED       = { from_mixed(  text2 ) } | ).


* Change order of characters
**********************************************************************
    out->write( |REVERSE             = {  reverse( text2 ) } | ).
    out->write( |SHIFT_LEFT  (places)= {  shift_left(  val = text2 places   = 3  ) } | ).
    out->write( |SHIFT_RIGHT (places)= {  shift_right( val = text2 places   = 3  ) } | ).
    out->write( |SHIFT_LEFT  (circ)  = {  shift_left(  val = text2 circular = 3  ) } | ).
    out->write( |SHIFT_RIGHT (circ)  = {  shift_right( val = text2 circular = 3  ) } | ).


* Extract a Substring
**********************************************************************
    out->write( |SUBSTRING       = {  substring(        val = text2 off = 4 len = 10 ) } | ).
    out->write( |SUBSTRING_FROM  = {  substring_from(   val = text2 sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_AFTER = {  substring_after(  val = text2 sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_TO    = {  substring_to(     val = text2 sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_BEFORE= {  substring_before( val = text2 sub = 'ABAP'     ) } | ).


* Condense, REPEAT and Segment
**********************************************************************
    out->write( |CONDENSE         = {   condense( val = text2 ) } | ).
    out->write( |REPEAT           = {   repeat(   val = text2 occ = 2 ) } | ).

    out->write( |SEGMENT1         = {   segment(  val = text2 sep = ',' index = 1 ) } |  ).
    out->write( |SEGMENT2         = {   segment(  val = text2 sep = ',' index = 2 ) } |  ).


    endmethod.
ENDCLASS.
