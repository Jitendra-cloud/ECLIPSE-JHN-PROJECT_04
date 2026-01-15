@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'TLR: Timing Letter Item'
define view entity ZCJS_I_TLR_ITEM
  as select from zdjs_tlr_item as TLR_Item
  association        to parent zcjs_i_tlr_head        as _Header              on $projection.TlUUID = _Header.TlUUID
  association [0..1] to ZCJS_I_TLR_Status_Description as _TextView            on $projection.ItemStatus = _TextView.valuelow
  association [0..1] to ZCJS_R_USER_NAME_VH            as _LocalCreatedByU     on $projection.LocalCreatedBy = _LocalCreatedByU.UserID
  association [0..1] to ZCJS_R_USER_NAME_VH            as _LocalLastChangedByU on $projection.LocalLastChangedBy = _LocalLastChangedByU.UserID

{
  key tl_uuid               as TlUUID,
  key tl_item_number        as TlItemNumber,
      plant                 as Plant,
      top_parent_part       as TopParentPart,
      direct_parent_part    as DirectParentPart,
      child_part            as ChildPart,
      child_level           as ChildLevel,
      item_status           as ItemStatus,
      current_valid_from    as CurrentValidFrom,
      current_valid_to      as CurrentValidTo,
      tl_action             as TlAction,
      effective_date        as EffectiveDate,
      @Semantics.quantity.unitOfMeasure: 'CurrentUom'
      current_quantity      as CurrentQuantity,
      @Semantics.quantity.unitOfMeasure: 'NewUom'
      new_quantity          as NewQuantity,
      current_uom           as CurrentUom,
      new_uom               as NewUom,
      quan_change_flag      as QuanChangeFlag,
      uom_change_flag       as UomChangeFlag,
      sww_wiid              as SwwWiID,
      sww_wistat            as SwwWistat,
      sww_aed               as SwwAed,
      wf_level1             as WfLevel1,
      wf_level2             as WfLevel2,
      wf_level3             as WfLevel3,
      zz_planttypeimm       as PlantTypeIMM,
      zz_planttypenewimmtl  as PlantTypeNewIMMTL,
      zz_autoapp            as Autoapp,
      zz_pckgcn             as PackageCN,
      zz_planttype          as PlantType,
      zz_planttypenew       as PlantTypeNew,

      child_parttl          as ChildPartTL,

      tl_number             as TLNumber,
      lead_cn               as LeadCN,
      packagecn             as PackCN,
      comment_text          as CommentText,
      comment_text2         as CommentText2,

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
      _LocalLastChangedByU,
      _TextView


}
