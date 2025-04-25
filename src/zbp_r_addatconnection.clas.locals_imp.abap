CLASS LHC_ZR_ADDATCONNECTION DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZMODEL_CON_DATTX
        RESULT result,
      checkSemanticKey FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZMODEL_CON_DATTX~checkSemanticKey.
ENDCLASS.

CLASS LHC_ZR_ADDATCONNECTION IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD checkSemanticKey.
    READ ENTITIES OF ZR_ADDATCONNECTION IN LOCAL MODE
    ENTITY ZMODEL_CON_DATTX FIELDS ( Uuid Carried Connid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
        SELECT FROM ZADDATCONNECTION FIELDS uuid
        WHERE Carried = @connection-Carried AND connid = @connection-connid
        UNION
        SELECT FROM zaddtcnnection_d FIELDS uuid
        WHERE Carried = @connection-Carried AND connid = @connection-connid
        INTO TABLE @DATA(check_result).
    ENDLOOP.

    IF check_result IS NOT INITIAL.
    DATA(message) = me->new_message(
      id       = 'ZMSG_CONN'
      number   = '001'
      severity = ms-error
      v1       = connection-Carried
      v2       = connection-connid
    ).

    DATA reported_record LIKE LINE OF reported-ZMODEL_CON_DATTX.
    reported_record-%tky = connection-%tky.
    reported_record-%msg = message.
    reported_record-%element-Carried = if_abap_behv=>mk-on.
    reported_record-%element-connid = if_abap_behv=>mk-on.
    APPEND reported_record TO reported-ZMODEL_CON_DATTX.

    DATA failed_record LIKE LINE OF failed-ZMODEL_CON_DATTX.
    failed_record-%tky = connection-%tky.
    APPEND failed_record TO failed-ZMODEL_CON_DATTX.
  ENDIF.
  ENDMETHOD.

ENDCLASS.
