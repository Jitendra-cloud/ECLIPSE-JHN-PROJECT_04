CLASS lhc_tlr_head DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_features,
             submit   TYPE if_abap_behv=>t_xflag,
             update   TYPE if_abap_behv=>t_xflag,
             delete   TYPE if_abap_behv=>t_xflag,
             complete TYPE if_abap_behv=>t_xflag,
           END OF ty_features.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR TLR_Head RESULT result. ""

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TLR_Head RESULT result. ""

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
    IMPORTING REQUEST requested_authorizations FOR TLR_Head RESULT result. ""

    METHODS earlynumbering_cba_Item FOR NUMBERING
      IMPORTING entities FOR CREATE TLR_Head\_Item. ""

    METHODS fillData FOR MODIFY
      IMPORTING keys FOR ACTION TLR_Head~fillData RESULT result. ""

    METHODS genTimLetNum FOR DETERMINE ON SAVE
      IMPORTING keys FOR TLR_Head~genTimLetNum. ""

    METHODS header_validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR TLR_Head~header_validate. ""

    METHODS itemExistancy_validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR TLR_Head~itemExistancy_validate.
    METHODS Complete FOR MODIFY
      IMPORTING keys FOR ACTION TLR_Head~Complete RESULT result. ""

    METHODS: gen_number_range IMPORTING p_type       TYPE zjs_de_nrnr
                                        p_obj        TYPE zjs_de_nrobj
                              RETURNING VALUE(p_num) TYPE zjs_de_tlr_id.

ENDCLASS.

CLASS lhc_tlr_head IMPLEMENTATION.

  METHOD get_instance_features.
*         IF requested_features-%action-fillData = if_abap_behv=>mk-on.
*         READ ENTITIES OF zplm_i_tlr_head
*         IN LOCAL MODE
*         ENTITY TLR_Head
*         ALL FIELDS "FIELDS ( )
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_head).
*
*         LOOP AT lt_head
*         ASSIGNING FIELD-SYMBOL(<ls_head>)
*         WHERE TlStatus IS NOT INITIAL.
**         DATA(lv_deactivate) =
**         COND #( WHEN <ls_head>-Street IS INITIAL
**         THEN if_abap_behv=>mk-off
**         ELSE if_abap_behv=>mk-on ).
*
*         INSERT
*         VALUE #( TlUUID = <ls_head>-TlUUID
*         %action-fillData = if_abap_behv=>mk-on ) "lv_deactivate
*         INTO TABLE result.
*         ENDLOOP.
*         ENDIF.
*            ""=====================================================

    DATA: ls_features TYPE ty_features.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
    ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_result_head).

    LOOP AT lt_result_head ASSIGNING FIELD-SYMBOL(<fs_result_head>).
      IF <fs_result_head>-%is_draft = if_abap_behv=>mk-on.

        ls_features-delete = if_abap_behv=>fc-o-enabled.
        ls_features-update = if_abap_behv=>fc-o-enabled.
      ELSE.
        ls_features-delete = if_abap_behv=>fc-o-enabled.
        ls_features-update = if_abap_behv=>fc-o-enabled.
      ENDIF.

      IF <fs_result_head>-TlStatus = 'H3'.
        ls_features-delete = if_abap_behv=>fc-o-disabled.
        ls_features-update = if_abap_behv=>fc-o-disabled.
        ls_features-complete = if_abap_behv=>fc-o-enabled.
      ELSEIF <fs_result_head>-TlStatus = 'H4'.
        ls_features-delete = if_abap_behv=>fc-o-disabled.
        ls_features-update = if_abap_behv=>fc-o-disabled.
        ls_features-complete = if_abap_behv=>fc-o-disabled.
      ELSE.
        ls_features-complete = if_abap_behv=>fc-o-disabled.
      ENDIF.

      INSERT VALUE #( %is_draft = <fs_result_head>-%is_draft
                      tluuid = <fs_result_head>-TlUUID
                      %update = ls_features-update
                      %delete = ls_features-delete
                      %action-edit = ls_features-delete
                      %action-Complete = ls_features-complete ) INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.

*         " As import table contains only keys, we need to get complete bonus calculation data for bonus variant value
*         READ ENTITIES OF zplm_i_tlr_head IN LOCAL MODE
*         ENTITY TLR_Head
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_Head).
*         " fill result list with authorizations per bonus calculation
*         LOOP AT lt_Head
*         ASSIGNING FIELD-SYMBOL(<fs_head>).
*         " check update authorization for bonus calculation, incl. bonus variant dependency
*         AUTHORITY-CHECK OBJECT 'ZPLM_HEAD'
*         ID 'ACTVT' FIELD '02'
*         ID 'ZSTAT' FIELD <fs_head>-TlStatus.
*         " set variable for update authorization
*         DATA(lv_update_allowed) =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         ELSE if_abap_behv=>auth-unauthorized ).
*         " check calculate bonus authorization for bonus calculation, incl. bonus variant dependency
*         AUTHORITY-CHECK OBJECT 'ZPLM_HEAD'
*         ID 'ACTVT' FIELD '93'
*         ID 'ZSTAT' FIELD <fs_head>-TlStatus.
*         " set variable for calculate bonus authorization
*         DATA(lv_calculate_bonus_allowed) =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         ELSE if_abap_behv=>auth-unauthorized ).
*         " check delete authorization for bonus calculation, incl. bonus variant dependency
*         AUTHORITY-CHECK OBJECT 'ZPLM_HEAD'
*         ID 'ACTVT' FIELD '06'
*         ID 'ZSTAT' FIELD <fs_head>-TlStatus.
*         " set variable for delete authorization
*         DATA(lv_delete_allowed) =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         " ELSE if_abap_behv=>auth-unauthorized ). ""##Commented by PPANDIT
*         ELSE if_abap_behv=>auth-allowed ). ""PPANDIT
*         " fill result list
*         APPEND VALUE #( TlUUID = <fs_head>-TlUUID
*         " TlNumber = <fs_head>-TlNumber
*         %update = lv_update_allowed
*         %delete = lv_delete_allowed ) TO result.
*         ENDLOOP.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
    ENTITY TLR_Head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_Head).

*    LOOP AT lt_Head ASSIGNING FIELD-SYMBOL(<lfs_req>).
*      CASE <lfs_req>-Werks.
*        WHEN 'PT01'.
*          AUTHORITY-CHECK OBJECT 'M_RECH_WRK'
*          ID 'WERKS' FIELD <lfs_req>-Werks
*          " ID 'WERKS' FIELD <lfs_req>-werks
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
*          " ID 'WERKS' FIELD <lfs_req>-werks
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


  ENDMETHOD.

  METHOD get_global_authorizations.
*         if requested_authorizations-%create eq if_abap_behv=>mk-on.
*         " check create authorization
*         AUTHORITY-CHECK OBJECT 'ZPLM_HEAD'
*         ID 'ACTVT' FIELD '01'.
*         result-%create =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         ELSE if_abap_behv=>auth-unauthorized ).
*         ENDIF.
*
*         IF requested_authorizations-%update EQ if_abap_behv=>mk-on.
*         " check update authorization
*        * AUTHORITY-CHECK OBJECT 'ZPLM_I_TLR_HEAD_TLF'
*        * ID 'ACTVT' FIELD '02'.
*         result-%update =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         ELSE if_abap_behv=>auth-unauthorized ).
*         ENDIF.
*
*         IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.
*         " check delete authorization
*        * AUTHORITY-CHECK OBJECT 'ZPLM_I_TLR_HEAD_TLF'
*        * ID 'ACTVT' FIELD '06'.
*         result-%delete =
*         COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*         ELSE if_abap_behv=>auth-unauthorized ).
*         ENDIF.

  ENDMETHOD.

*         METHOD get_global_features.
*         IF requested_features-%delete = if_abap_behv=>mk-on.
*         DATA(lv_deactivate) =
*         COND #(
*         WHEN cl_abap_context_info=>get_user_alias( ) = sy-uname
*         THEN if_abap_behv=>mk-off
*        * ELSE if_abap_behv=>mk-on ). ""Commented by PPANDIT
*         ELSE if_abap_behv=>mk-off ).
*         result-%delete = lv_deactivate.
*         ENDIF.
*         ENDMETHOD.

*         METHOD copyLine.
*         DATA:
*         lt_create TYPE TABLE FOR CREATE zplm_i_tlr_head.
*
*         READ ENTITIES OF zplm_i_tlr_head
*         IN LOCAL MODE
*         ENTITY TLR_Head
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_Head).
*
*         LOOP AT lt_head
*         ASSIGNING FIELD-SYMBOL(<ls_head>).
*        * <ls_head>-Partner = .
*        * <ls_head>-Name &&= |Copy|.
*        *
*        * INSERT
*        * VALUE #( %cid = keys[ sy-tabix ]-%cid )
*        * INTO TABLE lt_create
*        * REFERENCE INTO DATA(lr_create).
*        *
*        * lr_create->* = CORRESPONDING #( <ls_head> ).
*        * lr_create->%control-Partner = if_abap_behv=>mk-on.
*        * lr_create->%control-Name = if_abap_behv=>mk-on.
*        * lr_create->%control-Street = if_abap_behv=>mk-on.
*        * lr_create->%control-City = if_abap_behv=>mk-on.
*        * lr_create->%control-Country = if_abap_behv=>mk-on.
*        * lr_create->%control-Currency = if_abap_behv=>mk-on.
*         ENDLOOP.
*
*         MODIFY ENTITIES OF zplm_i_tlr_head
*         IN LOCAL MODE
*         ENTITY TLR_Head
*         CREATE FROM lt_create
*         FAILED DATA(ls_fail)
*         MAPPED DATA(ls_map)
*         REPORTED DATA(ls_report).
*
*        * mapped-TlUUID = ls_map-TlUUID.
* ENDMETHOD.

  METHOD earlynumbering_cba_Item.
    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH VALUE #( ( tluuid = entities[ 1 ]-TlUUID %is_draft = entities[ 1 ]-%is_draft ) )
            RESULT DATA(lt_head)
        ENTITY TLR_Head BY \_Item ALL FIELDS WITH VALUE #( ( tluuid = entities[ 1 ]-TlUUID %is_draft = entities[ 1 ]-%target[ 1 ]-%is_draft ) )
            RESULT DATA(lt_items)
            FAILED DATA(lt_failed).

    SORT lt_items BY TlItemNumber DESCENDING.

    DATA(lv_max_itemnumber) = VALUE #( lt_items[ 1 ]-TlItemNumber OPTIONAL ).

    lv_max_itemnumber += 1.

    LOOP AT entities[ 1 ]-%target INTO DATA(ls_item1).
      IF ls_item1-TlItemNumber IS INITIAL.
        ls_item1-TlItemNumber = lv_max_itemnumber.
        APPEND CORRESPONDING #( ls_item1 ) TO mapped-tlr_item.
      ELSE.
        APPEND CORRESPONDING #( ls_item1 ) TO mapped-tlr_item.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD fillData.
    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head).

    LOOP AT lt_head ASSIGNING FIELD-SYMBOL(<ls_head>)
    WHERE TlStatus IS INITIAL.
*         MODIFY ENTITIES OF zplm_i_tlr_head
*         IN LOCAL MODE
*         ENTITY TLR_Head
*         UPDATE FIELDS ( Street )
*         WITH VALUE #( ( %tky = <ls_>-%tky
*         Street = 'EMPTY'
*         %control-Street = if_abap_behv=>mk-on ) ).
      INSERT VALUE #( %tky = <ls_head>-%tky
      %param = <ls_head> ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD genTimLetNum.
    DATA lt_for_determine TYPE TABLE FOR UPDATE zcjs_i_tlr_head.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head FIELDS ( TlNumber Aennr TlStatus ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_request_data).

    DATA(lv_leadcn) = VALUE #( lt_request_data[ 1 ]-Aennr OPTIONAL ).

    SELECT * FROM zdjs_aehi WHERE aepar = @lv_leadcn
    INTO TABLE @DATA(lt_aehi).

    DATA(lv_leadpackval) = VALUE #( lt_aehi[ 1 ]-aechi OPTIONAL ).

    CONSTANTS: tl_num_range TYPE zjs_de_nrnr VALUE '01',  ""'TL',
               tl_object    TYPE zjs_de_nrobj VALUE 'ZJSNUM_TL'.  ""'ZPLM_TLR'.

    LOOP AT lt_request_data ASSIGNING FIELD-SYMBOL(<lwa_requestdata>).
      IF <lwa_requestdata>-TlNumber IS INITIAL.
        APPEND VALUE #( %tky = <lwa_requestdata>-%tky
                        TlNumber = gen_number_range( p_type = tl_num_range p_obj = tl_object )
                        TlStatus = COND #( WHEN <lwa_requestdata>-TlStatus IS INITIAL THEN 'H1' ELSE <lwa_requestdata>-TlStatus ) ) TO lt_for_determine.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE ENTITY TLR_Head
    UPDATE FIELDS ( TlNumber TlStatus )
    WITH lt_for_determine.
  ENDMETHOD.


  METHOD header_validate.
    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
            REPORTED DATA(ls_reported).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

    IF ls_head-Aennr IS INITIAL OR ls_head-LeadCN IS INITIAL OR ls_head-Werks IS INITIAL.
      INSERT VALUE #( tluuid = ls_head-TlUUID
                      %is_draft = ls_head-%is_draft
                      ) INTO TABLE failed-tlr_head.

      INSERT VALUE #( tluuid = ls_head-TlUUID
                      %is_draft = ls_head-%is_draft
                      %state_area = 'VALIDATE_APP' ) INTO TABLE reported-tlr_head.

      INSERT VALUE #( tluuid = ls_head-tluuid
                      %is_draft = ls_head-%is_draft
                      %state_area = 'VALIDATE_APP'
                      %element-aennr = if_abap_behv=>mk-on
                      %element-werks = if_abap_behv=>mk-on
                      %element-LeadCN = if_abap_behv=>mk-on
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning text = 'Mandatory field should not be blank' ) ) INTO TABLE reported-tlr_head.
    ENDIF.
  ENDMETHOD.

  METHOD gen_number_range.
    TRY.
        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr = p_type
                                                      object = p_obj
                                            IMPORTING number = DATA(lv_number)
                                                      returncode = DATA(lv_rcode) ).

      CATCH cx_root INTO DATA(lo_error2).
        p_num = '###'.
    ENDTRY.
    p_num = lv_number+8.
  ENDMETHOD.


  METHOD itemExistancy_validate.
    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
        ENTITY TLR_Head BY \_Item ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item)
            REPORTED DATA(ls_reported).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

    IF lt_item IS INITIAL.
      INSERT VALUE #( tluuid = ls_head-TlUUID
                      %is_draft = ls_head-%is_draft ) INTO TABLE failed-tlr_head.

      INSERT VALUE #( tluuid = ls_head-TlUUID
                      %is_draft = ls_head-%is_draft
                      %state_area = 'VALIDATE_APP' ) INTO TABLE reported-tlr_head.

      INSERT VALUE #( tluuid = ls_head-tluuid
                      %is_draft = ls_head-%is_draft
                      %state_area = 'VALIDATE_APP'
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning text = 'Atleast one item should be available' ) ) INTO TABLE reported-tlr_head.
    ENDIF.
  ENDMETHOD.

  METHOD Complete.
    DATA lt_for_determine TYPE TABLE FOR UPDATE zcjs_i_tlr_head.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_request_data).

    IF lt_request_data IS NOT INITIAL.
      LOOP AT lt_request_data ASSIGNING FIELD-SYMBOL(<lwa_requestdata>).
        <lwa_requestdata>-TlStatus = 'H4'.
        APPEND VALUE #( %tky = <lwa_requestdata>-%tky
                        TlStatus = <lwa_requestdata>-TlStatus ) TO lt_for_determine.
      ENDLOOP.
    ENDIF.

    MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head
            UPDATE FIELDS ( TlStatus ) WITH lt_for_determine.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( lt_request_data )
            RESULT DATA(lt_requests_submitted).

    result = VALUE #(  FOR ls_request IN lt_requests_submitted ( %tky = ls_request-%tky
                                                                 %param = ls_request ) ).

  ENDMETHOD.

ENDCLASS.



CLASS lhc_TLR_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES: BEGIN OF ty_features,
             submit      TYPE if_abap_behv=>t_xflag,
             update      TYPE if_abap_behv=>t_xflag,
             delete      TYPE if_abap_behv=>t_xflag,
             implemented TYPE if_abap_behv=>t_xflag,
           END OF ty_features.

    METHODS Submit FOR MODIFY
      IMPORTING keys FOR ACTION TLR_Item~Submit RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR TLR_Item RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TLR_Item RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
    IMPORTING REQUEST requested_authorizations FOR tlr_item RESULT result.
    METHODS gentimletitmstat FOR DETERMINE ON SAVE
      IMPORTING keys FOR tlr_item~gentimletitmstat.
    METHODS implemented FOR MODIFY
      IMPORTING keys FOR ACTION tlr_item~implemented RESULT result.


ENDCLASS.

CLASS lhc_TLR_Item IMPLEMENTATION.

  METHOD Submit.
    DATA lt_update_item TYPE TABLE FOR UPDATE zcjs_i_tlr_head\\TLR_Item.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_head)
        BY \_Item ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_item) .

    READ TABLE lt_result_item ASSIGNING FIELD-SYMBOL(<fs_result_item>) WITH KEY TlItemNumber = keys[ 1 ]-tlitemnumber.
    <fs_result_item>-ItemStatus = 'I2'.
    APPEND VALUE #( %tky = <fs_result_item>-%tky
                    itemstatus = <fs_result_item>-ItemStatus ) TO lt_update_item.

    MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Item UPDATE FIELDS ( ItemStatus )
            WITH lt_update_item.

    result = VALUE #( ( %tky = <fs_result_item>-%tky
                        %param = <fs_result_item> ) ).

    APPEND VALUE #( %tky = <fs_result_item>-%tky
                    %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-success
                    text = | Item Number | && | | && | { VALUE #( result[ 1 ]-%param-TlItemNumber ) } | && | Successfully Submited | ) ) TO reported-tlr_item.

  ENDMETHOD.

  METHOD get_instance_features.
    DATA: ls_features TYPE ty_features.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head BY \_Item ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_item).

    LOOP AT lt_result_item ASSIGNING FIELD-SYMBOL(<fs_result_item>).

      IF <fs_result_item>-%is_draft = if_abap_behv=>mk-on.
        ls_features-submit = if_abap_behv=>fc-o-enabled.
        ls_features-implemented = if_abap_behv=>fc-o-enabled.
        ls_features-update = if_abap_behv=>fc-o-enabled.
        ls_features-delete = if_abap_behv=>fc-o-enabled.
      ELSE.
        ls_features-submit = if_abap_behv=>fc-o-enabled.
        ls_features-implemented = if_abap_behv=>fc-o-enabled.
        ls_features-update = if_abap_behv=>fc-o-enabled.
        ls_features-delete = if_abap_behv=>fc-o-enabled.
      ENDIF.

      CASE <fs_result_item>-ItemStatus.
        WHEN 'I1'.
            IF <fs_result_item>-CurrentValidFrom = '00000000' OR <fs_result_item>-CurrentValidTo = '00000000' OR <fs_result_item>-PackCN = ' ' .
                ls_features-submit = if_abap_behv=>fc-o-disabled.
                ls_features-implemented = if_abap_behv=>fc-o-disabled.
                ls_features-update = if_abap_behv=>fc-o-enabled.
                ls_features-delete = if_abap_behv=>fc-o-enabled.
            ELSE.
                ls_features-submit = if_abap_behv=>fc-o-enabled.
                ls_features-implemented = if_abap_behv=>fc-o-disabled.
                ls_features-update = if_abap_behv=>fc-o-enabled.
                ls_features-delete = if_abap_behv=>fc-o-enabled.
            ENDIF.
        WHEN 'I2'.
            ls_features-update = if_abap_behv=>fc-o-disabled.
            ls_features-delete = if_abap_behv=>fc-o-disabled.
            ls_features-implemented = if_abap_behv=>fc-o-enabled.
            ls_features-submit = if_abap_behv=>fc-o-disabled.
        WHEN 'I3'.
            ls_features-update = if_abap_behv=>fc-o-disabled.
            ls_features-delete = if_abap_behv=>fc-o-disabled.
            ls_features-implemented = if_abap_behv=>fc-o-disabled.
            ls_features-submit = if_abap_behv=>fc-o-disabled.
     ENDCASE.

    INSERT VALUE #( %is_draft = <fs_result_item>-%is_draft
                    tluuid = <fs_result_item>-TlUUID
                    tlitemnumber = <fs_result_item>-TlItemNumber
                    %delete = ls_features-delete
                    %update = ls_features-update
                    %action-submit = ls_features-submit
                    %action-implemented = ls_features-implemented ) INTO TABLE result.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD genTimLetItmStat.

    DATA lt_for_determine TYPE TABLE FOR UPDATE zcjs_i_tlr_item.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
                ENTITY TLR_Item FIELDS ( ItemStatus TLNumber LeadCN PackageCN Plant ) WITH CORRESPONDING #( keys )
                    RESULT DATA(lt_request_data).

    DATA(lv_leadcn) = VALUE #( lt_head[ 1 ]-Aennr OPTIONAL ).

    SELECT * FROM zdjs_aehi
        WHERE aepar = @lv_leadcn
        INTO TABLE @DATA(lt_aehi).

    DATA(lv_leadpackval) = VALUE #( lt_aehi[ 1 ]-aechi OPTIONAL ).

    LOOP AT lt_request_data ASSIGNING FIELD-SYMBOL(<lwa_requestdata>).
      IF <lwa_requestdata>-ItemStatus IS INITIAL.
        APPEND VALUE #( %tky = <lwa_requestdata>-%tky
                        ItemStatus = COND #( WHEN <lwa_requestdata>-ItemStatus IS INITIAL THEN 'I1' ELSE <lwa_requestdata>-ItemStatus )
                        tlnumber = lt_head[ 1 ]-TlNumber
                        Plant = COND #( WHEN lt_head[ 1 ]-Werks IS INITIAL THEN <lwa_requestdata>-Plant ELSE lt_head[ 1 ]-Werks ) ) TO lt_for_determine.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
    ENTITY TLR_Item
    UPDATE FIELDS ( ItemStatus tlnumber Plant )
    WITH lt_for_determine.

  ENDMETHOD.

  METHOD Implemented.

    DATA lt_update_item TYPE TABLE FOR UPDATE zcjs_i_tlr_head\\TLR_Item.

    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
        ENTITY TLR_Head ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_head)
        BY \_Item ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_items)
        ENTITY TLR_Item ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result_item).

    LOOP AT lt_result_item ASSIGNING FIELD-SYMBOL(<fs_result_item>).
      <fs_result_item>-ItemStatus = 'I3'.

      APPEND VALUE #( %tky = <fs_result_item>-%tky
      itemstatus = <fs_result_item>-ItemStatus ) TO lt_update_item.

      MODIFY ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
          ENTITY TLR_Item UPDATE FIELDS ( ItemStatus )
              WITH lt_update_item.

      result = VALUE #( ( %tky = <fs_result_item>-%tky
      %param = <fs_result_item> ) ).

    ENDLOOP.

    APPEND VALUE #( %tky = <fs_result_item>-%tky
                    %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-success
                    text = | Item Number | && | | && | { VALUE #( result[ 1 ]-%param-TlItemNumber ) } | && | implemented successfully. | ) ) TO reported-tlr_item.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_TLR_Comments DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS commentConsistency FOR VALIDATE ON SAVE
      IMPORTING keys FOR TLR_Comments~commentConsistency.

ENDCLASS.

CLASS lhc_TLR_Comments IMPLEMENTATION.

  METHOD commentConsistency.
    READ ENTITIES OF zcjs_i_tlr_head IN LOCAL MODE
  ENTITY TLR_Head BY \_Comments ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_result_comm).

    SELECT COUNT( * ) FROM @lt_result_comm AS comm
    WHERE UserProfile = 'MDT'
    INTO @DATA(lv_count_mdt) .

    SELECT COUNT( * ) FROM @lt_result_comm AS comm
    WHERE UserProfile = 'MPL'
    INTO @DATA(lv_count_mpl) .

    IF lv_count_mdt > 1 OR lv_count_mpl > 1.

      INSERT VALUE #( tluuid = lt_result_comm[ 1 ]-TlUUID
      %is_draft = lt_result_comm[ 1 ]-%is_draft ) INTO TABLE failed-tlr_head.
      INSERT VALUE #( tluuid = lt_result_comm[ 1 ]-tluuid
      %is_draft = lt_result_comm[ 1 ]-%is_draft
      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning "error
      text = 'Only one comment allowed for each "MDT" & "MPL"' ) ) INTO TABLE reported-tlr_head.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCJS_I_TLR_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCJS_I_TLR_HEAD IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
