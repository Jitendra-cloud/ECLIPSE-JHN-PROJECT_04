@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TLR: Timing Letter Comments'
define view entity ZCJS_I_TLR_COMM
  as select from zdjs_tlr_comm as TLR_Comments
  association        to parent zcjs_i_tlr_head as _Header              on $projection.TlUUID = _Header.TlUUID

  association [0..1] to ZCJS_R_USER_NAME_VH     as _LocalCreatedByU     on $projection.LocalCreatedBy = _LocalCreatedByU.UserID
  association [0..1] to ZCJS_R_USER_NAME_VH     as _LocalLastChangedByU on $projection.LocalLastChangedBy = _LocalLastChangedByU.UserID


{
  key tl_uuid               as TlUUID,
  key comment_uuid          as CommentUUID,
      user_profile          as UserProfile,
      tl_item_number        as TlItemNumber,
      comment_text          as CommentText, //COMMENTED BY PPANDIT
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      /*associations*/
      _Header,
      _LocalCreatedByU,
      _LocalLastChangedByU



}
