@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TLR: Timing Letter Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zcjs_i_tlr_head
  as select from zdjs_tlr_head as TLR_Head
  composition [0..*] of ZCJS_I_TLR_ITEM               as _Item
  composition [0..*] of ZCJS_I_TLR_COMM               as _Comments
  association [0..1] to ZCJS_I_TLR_Status_Description as _HeaderStatus        on  $projection.TlStatus = _HeaderStatus.valuelow
  association [0..1] to ZCJS_R_USER_NAME_VH           as _LocalCreatedByU     on  $projection.LocalCreatedBy = _LocalCreatedByU.UserID
  association [0..1] to ZCJS_R_USER_NAME_VH           as _LocalLastChangedByU on  $projection.LocalLastChangedBy = _LocalLastChangedByU.UserID
  association [0..1] to ZCJS_I_TLR_COMM               as _Comm                on  $projection.TlUUID = _Comm.TlUUID
                                                                              and _Comm.UserProfile  = 'MDT'
  association [0..1] to ZCJS_I_TLR_COMM               as _Comm2               on  $projection.TlUUID = _Comm2.TlUUID
                                                                              and _Comm2.UserProfile = 'MPL'

{
  key TLR_Head.tl_uuid               as TlUUID,
      TLR_Head.tl_number             as TlNumber,
      TLR_Head.tl_status             as TlStatus,
      TLR_Head.tl_reference          as TlReference,
      TLR_Head.ct_reference          as CtReference,
      TLR_Head.aennr                 as Aennr,
      TLR_Head.sww_wiid              as SwwWiID,
      TLR_Head.sww_wistat            as SwwWistat,
      TLR_Head.sww_aed               as SwwAed,
      TLR_Head.wf_level1             as WfLevel1,
      TLR_Head.wf_level2             as WfLevel2,
      TLR_Head.wf_level3             as WfLevel3,
      TLR_Head.werks                 as Werks,
      TLR_Head.zz_autoapp            as Autoapp,
      TLR_Head.lead_cn               as LeadCN,

      _Comm.CommentText              as CommentText,
      _Comm2.CommentText             as CommentText2,

      @Semantics.user.createdBy: true
      TLR_Head.local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      TLR_Head.local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      TLR_Head.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      TLR_Head.local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      TLR_Head.last_changed_at       as LastChangedAt,


      /*associations*/
      _Item,
      _Comments,
      _HeaderStatus,
      _LocalCreatedByU,
      _LocalLastChangedByU
}
