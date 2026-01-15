*CLASS lhc_TLR_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS:
*      get_instance_authorizations FOR INSTANCE AUTHORIZATION
*        IMPORTING
*          keys   REQUEST requested_authorizations FOR tlr_head
*        RESULT
*          result,
*      get_global_authorizations FOR GLOBAL AUTHORIZATION
*        IMPORTING
*        REQUEST requested_authorizations FOR tlr_head
*        RESULT
*          result,
*      get_global_features FOR GLOBAL FEATURES
*        IMPORTING
*        REQUEST requested_features FOR tlr_head
*        RESULT
*          result,
*      get_instance_features FOR INSTANCE FEATURES
*        IMPORTING
*          keys   REQUEST requested_features FOR tlr_head
*        RESULT
*          result. "" ,
** copyline FOR MODIFY
** IMPORTING
** keys FOR ACTION tlr_head~copyline.
*
*    METHODS filldata FOR MODIFY
*      IMPORTING
*        keys   FOR ACTION tlr_head~filldata
*      RESULT
*        result.
*    METHODS gentimletnum FOR DETERMINE ON SAVE
*      IMPORTING keys FOR tlr_head~gentimletnum.
*    METHODS earlynumbering_cba_item FOR NUMBERING
*      IMPORTING entities FOR CREATE tlr_head\_item.
*
*    METHODS: gen_number_range IMPORTING p_type       TYPE zjs_de_nrnr
*                                        p_obj        TYPE zjs_de_nrobj
*                              RETURNING VALUE(p_num) TYPE zjs_de_tlr_id.
*
*
*ENDCLASS.
*
*CLASS lhc_TLR_Head IMPLEMENTATION.
*
*  METHOD get_instance_authorizations.
*
*    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
*    ENTITY TLR_Head
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_Head).
*
*    LOOP AT lt_Head ASSIGNING FIELD-SYMBOL(<lfs_req>).
*      CASE <lfs_req>-Werks.
*        WHEN 'PT01'.
*          AUTHORITY-CHECK OBJECT 'M_RECH_WRK'
*          ID 'WERKS' FIELD <lfs_req>-Werks
*            " ID 'WERKS' FIELD <lfs_req>-werks
*          ID 'ACTVT' FIELD '01'.
*          IF sy-subrc NE 0.
*            APPEND VALUE #( %tky = <lfs_req>-%tky ) TO failed-tlr_head.
*            APPEND VALUE #( %tky = keys[ 1 ]-%tky
*            %msg = new_message_with_text(
*            severity = if_abap_behv_message=>severity-error
*            Text = |{ 'No Authorization for Requested Ticket Type' }| ) ) TO reported-tlr_head.
*
*          ENDIF.
*
*        WHEN 'PT02'.
*          AUTHORITY-CHECK OBJECT 'M_RECH_WRK'
*          ID 'WERKS' FIELD <lfs_req>-Werks
*            " ID 'WERKS' FIELD <lfs_req>-werks
*          ID 'ACTVT' FIELD '02'.
*          IF sy-subrc NE 0.
*            APPEND VALUE #( %tky = <lfs_req>-%tky ) TO failed-tlr_head.
*            APPEND VALUE #( %tky = keys[ 1 ]-%tky
*            %msg = new_message_with_text(
*            severity = if_abap_behv_message=>severity-error
*            Text = |{ 'No Authorization for Requested Ticket Type' }| ) ) TO reported-tlr_head.
*
*          ENDIF.
*      ENDCASE.
*    ENDLOOP.
*
*
*  ENDMETHOD.
*
*  METHOD get_global_authorizations.
*
*  ENDMETHOD.
*
*  METHOD get_global_features.
*    IF requested_features-%delete = if_abap_behv=>mk-on.
*      DATA(lv_deactivate) =
*      COND #(
*      WHEN cl_abap_context_info=>get_user_alias( ) = sy-uname
*      THEN if_abap_behv=>mk-off
** ELSE if_abap_behv=>mk-on ). ""Commented by PPANDIT
*      ELSE if_abap_behv=>mk-off ).
*      result-%delete = lv_deactivate.
*    ENDIF.
*  ENDMETHOD.
*
*  METHOD get_instance_features.
*    IF requested_features-%action-fillData = if_abap_behv=>mk-on.
*      READ ENTITIES OF zcjs_i_tlr_head
*      IN LOCAL MODE
*      ENTITY TLR_Head
*      ALL FIELDS "FIELDS ( )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_head).
*
*      LOOP AT lt_head
*      ASSIGNING FIELD-SYMBOL(<ls_head>)
*      WHERE TlStatus IS NOT INITIAL.
*
*        INSERT
*        VALUE #( TlUUID = <ls_head>-TlUUID
*        %action-fillData = if_abap_behv=>mk-on ) "lv_deactivate
*        INTO TABLE result.
*      ENDLOOP.
*    ENDIF.
*  ENDMETHOD.
*
*  METHOD fillData.
*    READ ENTITIES OF zcjs_i_tlr_head
*    IN LOCAL MODE
*    ENTITY TLR_Head
*    ALL FIELDS "FIELDS ( Street )
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_head).
*
*    LOOP AT lt_head
*    ASSIGNING FIELD-SYMBOL(<ls_head>)
*    WHERE TlStatus IS INITIAL.
*
*      INSERT VALUE #( %tky = <ls_head>-%tky
*      %param = <ls_head> ) INTO TABLE result.
*    ENDLOOP.
*  ENDMETHOD.
*
*
*  METHOD genTimLetNum.
*
*    DATA lt_for_determine TYPE TABLE FOR UPDATE zcjs_i_tlr_head.
*
*    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
*    ENTITY TLR_Head FIELDS ( TlNumber Aennr ) WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_request_data).
*
*    DATA(lv_leadcn) = VALUE #( lt_request_data[ 1 ]-Aennr OPTIONAL ).
*
*    SELECT * FROM zdjs_aehi
*        WHERE aepar = @lv_leadcn
*        INTO TABLE @DATA(lt_aehi).
*
*    DATA(lv_leadpackval) = VALUE #( lt_aehi[ 1 ]-aechi OPTIONAL ).
*
*    CONSTANTS: tl_num_range TYPE zjs_de_nrnr VALUE 'TL',
*               tl_object    TYPE zjs_de_nrobj VALUE 'ZPLM_TLR'.
*
*    LOOP AT lt_request_data ASSIGNING FIELD-SYMBOL(<lwa_requestdata>).
*      IF <lwa_requestdata>-TlNumber IS INITIAL.
*        APPEND VALUE #( %tky = <lwa_requestdata>-%tky
*                        TlNumber = gen_number_range( p_type = tl_num_range
*                                                     p_obj = tl_object )
*                        TlStatus = 'H1'
*                        LeadCN   = lv_leadpackval ) TO lt_for_determine.
*      ENDIF.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
*    ENTITY TLR_Head
*    UPDATE FIELDS ( TlNumber TlStatus LeadCN )
*    WITH lt_for_determine.
*  ENDMETHOD.
*
*  METHOD gen_number_range.
*    TRY.
*        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr = p_type
*        object = p_obj
*        IMPORTING number = DATA(lv_number)
*        returncode = DATA(lv_rcode) ).
*
*      CATCH cx_root INTO DATA(lo_error2).
*        p_num = '###'.
*    ENDTRY.
*    p_num = lv_number+8.
*  ENDMETHOD.
*
*
*  METHOD earlynumbering_cba_Item.
*
*    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
*    ENTITY TLR_Head ALL FIELDS WITH VALUE #( ( tluuid = entities[ 1 ]-TlUUID %is_draft = entities[ 1 ]-%is_draft ) )
*    RESULT DATA(lt_head)
*    ENTITY TLR_Head BY \_Item ALL FIELDS WITH VALUE #( ( tluuid = entities[ 1 ]-TlUUID %is_draft = entities[ 1 ]-%target[ 1 ]-%is_draft ) )
*    RESULT DATA(lt_items)
*    FAILED DATA(lt_failed).
*
*    SORT lt_items BY TlItemNumber DESCENDING.
*
*    DATA(lv_max_itemnumber) = VALUE #( lt_items[ 1 ]-TlItemNumber OPTIONAL ).
*
*    lv_max_itemnumber += 1.
*
*    LOOP AT entities[ 1 ]-%target INTO DATA(ls_item1).
*      IF ls_item1-TlItemNumber IS INITIAL.
*        ls_item1-TlItemNumber = lv_max_itemnumber.
*        APPEND CORRESPONDING #( ls_item1 ) TO mapped-tlr_item.
*      ELSE.
*        APPEND CORRESPONDING #( ls_item1 ) TO mapped-tlr_item.
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.
*
*
*ENDCLASS.
