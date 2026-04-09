CLASS lhc_MaintRequest DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MaintRequest RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR MaintRequest RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE MaintRequest.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE MaintRequest.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE MaintRequest.
    METHODS read FOR READ
      IMPORTING keys FOR READ MaintRequest RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK MaintRequest.
    METHODS rba_MaintItem FOR READ
      IMPORTING keys_rba FOR READ MaintRequest\_MaintItem
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_MaintItem FOR MODIFY
      IMPORTING entities_cba FOR CREATE MaintRequest\_MaintItem.
ENDCLASS.

CLASS lhc_MaintRequest IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock.                        ENDMETHOD.

  METHOD create.
    DATA ls_hdr TYPE zbmr_hdr_22it018.
    LOOP AT entities INTO DATA(ls_ent).
      ls_hdr = CORRESPONDING #( ls_ent MAPPING FROM ENTITY ).
      CHECK ls_hdr-requestno IS NOT INITIAL.
      SELECT SINGLE FROM zbmr_hdr_22it018 FIELDS requestno
        WHERE requestno = @ls_hdr-requestno INTO @DATA(lv_exists).
      IF sy-subrc NE 0.
        DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
        lo_util->set_hdr_value( EXPORTING im_hdr = ls_hdr
                                IMPORTING ex_created = DATA(lv_ok) ).
        IF lv_ok = abap_true.
          APPEND VALUE #( %cid = ls_ent-%cid requestno = ls_hdr-requestno )
            TO mapped-maintrequest.
          APPEND VALUE #( %cid = ls_ent-%cid requestno = ls_hdr-requestno
            %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
              v1 = 'Maintenance Request Created' severity = if_abap_behv_message=>severity-success ) )
            TO reported-maintrequest.
        ENDIF.
      ELSE.
        APPEND VALUE #( %cid = ls_ent-%cid requestno = ls_hdr-requestno )
          TO failed-maintrequest.
        APPEND VALUE #( %cid = ls_ent-%cid requestno = ls_hdr-requestno
          %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 002
            v1 = 'Duplicate Request Number' severity = if_abap_behv_message=>severity-error ) )
          TO reported-maintrequest.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_hdr TYPE zbmr_hdr_22it018.
    LOOP AT entities INTO DATA(ls_ent).
      ls_hdr = CORRESPONDING #( ls_ent MAPPING FROM ENTITY ).
      CHECK ls_hdr-requestno IS NOT INITIAL.
      SELECT SINGLE FROM zbmr_hdr_22it018 FIELDS requestno
        WHERE requestno = @ls_hdr-requestno INTO @DATA(lv_exists).
      IF sy-subrc EQ 0.
        DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
        lo_util->set_hdr_value( EXPORTING im_hdr = ls_hdr
                                IMPORTING ex_created = DATA(lv_ok) ).
        IF lv_ok = abap_true.
          APPEND VALUE #( requestno = ls_hdr-requestno ) TO mapped-maintrequest.
          APPEND VALUE #( %key = ls_ent-%key
            %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
              v1 = 'Request Updated' severity = if_abap_behv_message=>severity-success ) )
            TO reported-maintrequest.
        ENDIF.
      ELSE.
        APPEND VALUE #( %cid = ls_ent-%cid_ref requestno = ls_hdr-requestno )
          TO failed-maintrequest.
        APPEND VALUE #( %cid = ls_ent-%cid_ref requestno = ls_hdr-requestno
          %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 003
            v1 = 'Request Not Found' severity = if_abap_behv_message=>severity-error ) )
          TO reported-maintrequest.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_h, requestno TYPE zbmr_reqno, END OF ty_h.
    DATA ls_h TYPE ty_h.
    DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      ls_h-requestno = ls_key-requestno.
      lo_util->set_hdr_delete( im_hdr = ls_h ).
      lo_util->set_hdr_del_flag( im_flag = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref requestno = ls_key-requestno
        %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
          v1 = 'Request Deleted' severity = if_abap_behv_message=>severity-success ) )
        TO reported-maintrequest.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zbmr_hdr_22it018 FIELDS *
        WHERE requestno = @ls_key-requestno INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_MaintItem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zbmr_itm_22it018 FIELDS *
        WHERE requestno = @ls_key-requestno INTO TABLE @DATA(lt_itm).
      LOOP AT lt_itm INTO DATA(ls_itm).
        APPEND CORRESPONDING #( ls_itm ) TO result.
        APPEND VALUE #( source-requestno = ls_key-requestno
                        target-requestno = ls_itm-requestno
                        target-itemnumber = ls_itm-itemnumber ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_MaintItem.
    DATA ls_itm TYPE zbmr_itm_22it018.
    LOOP AT entities_cba INTO DATA(ls_ecba).
      ls_itm = CORRESPONDING #( ls_ecba-%target[ 1 ] ).
      CHECK ls_itm-requestno IS NOT INITIAL AND ls_itm-itemnumber IS NOT INITIAL.
      SELECT SINGLE FROM zbmr_itm_22it018 FIELDS requestno
        WHERE requestno = @ls_itm-requestno AND itemnumber = @ls_itm-itemnumber
        INTO @DATA(lv_ex).
      IF sy-subrc NE 0.
        DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
        lo_util->set_itm_value( EXPORTING im_itm = ls_itm
                                IMPORTING ex_created = DATA(lv_ok) ).
        IF lv_ok = abap_true.
          APPEND VALUE #( %cid = ls_ecba-%target[ 1 ]-%cid
                          requestno = ls_itm-requestno itemnumber = ls_itm-itemnumber )
            TO mapped-maintitem.
          APPEND VALUE #( %cid = ls_ecba-%target[ 1 ]-%cid requestno = ls_itm-requestno
            %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 001
              v1 = 'Item Created' severity = if_abap_behv_message=>severity-success ) )
            TO reported-maintitem.
        ENDIF.
      ELSE.
        APPEND VALUE #( %cid = ls_ecba-%target[ 1 ]-%cid
                        requestno = ls_itm-requestno itemnumber = ls_itm-itemnumber )
          TO failed-maintitem.
        APPEND VALUE #( %cid = ls_ecba-%target[ 1 ]-%cid requestno = ls_itm-requestno
          %msg = new_message( id = 'ZBMR_MSG_22IT018' number = 002
            v1 = 'Duplicate Item Number' severity = if_abap_behv_message=>severity-error ) )
          TO reported-maintitem.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
