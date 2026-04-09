CLASS lsc_ZBMR_I_HDR_22IT018 DEFINITION
  INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_ZBMR_I_HDR_22IT018 IMPLEMENTATION.
  METHOD finalize.          ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD cleanup_finalize.  ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_bmr_util_22it018=>get_instance( ).
    lo_util->get_hdr_value(    IMPORTING ex_hdr     = DATA(ls_hdr) ).
    lo_util->get_itm_value(    IMPORTING ex_itm     = DATA(ls_itm) ).
    lo_util->get_hdr_delete(   IMPORTING ex_hdrs    = DATA(lt_del_hdr) ).
    lo_util->get_itm_delete(   IMPORTING ex_itms    = DATA(lt_del_itm) ).
    lo_util->get_del_flags(    IMPORTING ex_hdr_del = DATA(lv_hdr_del) ).

    " 1. Save/update header
    IF ls_hdr IS NOT INITIAL.
      MODIFY zbmr_hdr_22it018 FROM @ls_hdr.
    ENDIF.

    " 2. Save/update item
    IF ls_itm IS NOT INITIAL.
      MODIFY zbmr_itm_22it018 FROM @ls_itm.
    ENDIF.

    " 3. Handle deletions
    IF lv_hdr_del = abap_true.
      LOOP AT lt_del_hdr INTO DATA(ls_dh).
        DELETE FROM zbmr_hdr_22it018 WHERE requestno = @ls_dh-requestno.
        DELETE FROM zbmr_itm_22it018 WHERE requestno = @ls_dh-requestno.
      ENDLOOP.
    ELSE.
      LOOP AT lt_del_hdr INTO ls_dh.
        DELETE FROM zbmr_hdr_22it018 WHERE requestno = @ls_dh-requestno.
      ENDLOOP.
      LOOP AT lt_del_itm INTO DATA(ls_di).
        DELETE FROM zbmr_itm_22it018
          WHERE requestno  = @ls_di-requestno
            AND itemnumber = @ls_di-itemnumber.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcl_bmr_util_22it018=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.
ENDCLASS.
