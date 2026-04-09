CLASS zcl_bmr_util_22it018 DEFINITION
  PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_req_hdr,
             requestno TYPE zbmr_reqno,
           END OF ty_req_hdr,
           BEGIN OF ty_req_itm,
             requestno  TYPE zbmr_reqno,
             itemnumber TYPE int2,
           END OF ty_req_itm.
    TYPES: tt_req_hdr TYPE STANDARD TABLE OF ty_req_hdr,
           tt_req_itm TYPE STANDARD TABLE OF ty_req_itm.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_bmr_util_22it018.

    METHODS:
      set_hdr_value
        IMPORTING im_hdr     TYPE zbmr_hdr_22it018
        EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_hdr TYPE zbmr_hdr_22it018,
      set_itm_value
        IMPORTING im_itm     TYPE zbmr_itm_22it018
        EXPORTING ex_created TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_itm TYPE zbmr_itm_22it018,
      set_hdr_delete
        IMPORTING im_hdr TYPE ty_req_hdr,
      set_itm_delete
        IMPORTING im_itm TYPE ty_req_itm,
      get_hdr_delete
        EXPORTING ex_hdrs TYPE tt_req_hdr,
      get_itm_delete
        EXPORTING ex_itms TYPE tt_req_itm,
      set_hdr_del_flag
        IMPORTING im_flag TYPE abap_boolean,
      get_del_flags
        EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gs_hdr    TYPE zbmr_hdr_22it018,
                gs_itm    TYPE zbmr_itm_22it018,
                gt_hdrdel TYPE tt_req_hdr,
                gt_itmdel TYPE tt_req_itm,
                gv_hdr_del TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_bmr_util_22it018.
ENDCLASS.

CLASS zcl_bmr_util_22it018 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_hdr-requestno IS NOT INITIAL.
      gs_hdr = im_hdr.  ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.  ex_hdr = gs_hdr.  ENDMETHOD.

  METHOD set_itm_value.
    IF im_itm IS NOT INITIAL.
      gs_itm = im_itm.  ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.  ex_itm = gs_itm.  ENDMETHOD.

  METHOD set_hdr_delete.
    APPEND im_hdr TO gt_hdrdel.
  ENDMETHOD.

  METHOD set_itm_delete.
    APPEND im_itm TO gt_itmdel.
  ENDMETHOD.

  METHOD get_hdr_delete.  ex_hdrs = gt_hdrdel.  ENDMETHOD.
  METHOD get_itm_delete.  ex_itms = gt_itmdel.  ENDMETHOD.

  METHOD set_hdr_del_flag.  gv_hdr_del = im_flag.  ENDMETHOD.
  METHOD get_del_flags.  ex_hdr_del = gv_hdr_del.  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr, gs_itm, gt_hdrdel, gt_itmdel, gv_hdr_del.
  ENDMETHOD.
ENDCLASS.

