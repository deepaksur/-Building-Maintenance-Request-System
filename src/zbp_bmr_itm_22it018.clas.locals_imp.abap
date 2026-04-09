CLASS lhc_MaintItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE MaintItem.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE MaintItem.
    METHODS read FOR READ
      IMPORTING keys FOR READ MaintItem RESULT result.
    METHODS rba_MaintHeader FOR READ
      IMPORTING keys_rba FOR READ MaintItem\_MaintHeader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_MaintItem IMPLEMENTATION.
  METHOD update.
    DATA ls_itm TYPE zbmr_itm_22it018.
    LOOP AT entities INTO DATA(ls_ent).
      ls_itm = CORRESPONDING #( ls_ent MAPPING FROM ENTITY ).
      CHECK ls_itm-requestno IS NOT INITIAL.
      SELECT SINGLE FROM zbmr_itm_22it018 FIELDS requestno
        WHERE requestno = @ls_itm-requestno AND itemnumber = @ls_itm-itemnumber
        INTO @DATA(lv_ex).
      IF sy-subrc EQ 0.
        DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
        lo_util->set_itm_value( EXPORTING im_itm = ls_itm
                                IMPORTING ex_created = DATA(lv_ok) ).
        IF lv_ok = abap_true.
          APPEND VALUE #( requestno = ls_itm-requestno itemnumber = ls_itm-itemnumber )
            TO mapped-maintitem.
          APPEND VALUE #( %key = ls_ent-%key
            %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
              v1 = 'Item Updated' severity = if_abap_behv_message=>severity-success ) )
            TO reported-maintitem.
        ENDIF.
      ELSE.
        APPEND VALUE #( %cid = ls_ent-%cid_ref requestno = ls_itm-requestno
                        itemnumber = ls_itm-itemnumber )
          TO failed-maintitem.
        APPEND VALUE #( %cid = ls_ent-%cid_ref requestno = ls_itm-requestno
          %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 003
            v1 = 'Item Not Found' severity = if_abap_behv_message=>severity-error ) )
          TO reported-maintitem.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_i, requestno TYPE zbmr_reqno,
                          itemnumber TYPE int2, END OF ty_i.
    DATA ls_i TYPE ty_i.
    DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      ls_i-requestno  = ls_key-requestno.
      ls_i-itemnumber = ls_key-ItemNumber.
      lo_util->set_itm_delete( im_itm = ls_i ).
      APPEND VALUE #( %cid = ls_key-%cid_ref requestno = ls_key-requestno
                      itemnumber = ls_key-ItemNumber
        %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
          v1 = 'Item Deleted' severity = if_abap_behv_message=>severity-success ) )
        TO reported-maintitem.
    ENDLOOP.
  ENDMETHOD.

  METHOD read. ENDMETHOD.
  METHOD rba_MaintHeader. ENDMETHOD.
ENDCLASS.
