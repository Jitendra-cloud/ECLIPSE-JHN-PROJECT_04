@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZPLM_I_TLR_ITEM'
@ObjectModel.semanticKey: [ 'TlItemNumber' ]
define view entity ZCJS_C_TLR_ITEM
  as projection on ZCJS_I_TLR_ITEM
{
  key TlUUID,
  key TlItemNumber,
      Plant,
      TopParentPart,
      DirectParentPart,
      ChildPart,
      ChildLevel,
      @ObjectModel.text: {
      element: [ 'StatusText' ] }
      @UI.textArrangement: #TEXT_ONLY
      ItemStatus,
      // StatusText,
      CurrentValidFrom,
      CurrentValidTo,
      TlAction,
      EffectiveDate,
      CurrentQuantity,
      NewQuantity,
      CurrentUom,
      NewUom,
      QuanChangeFlag,
      UomChangeFlag,
      SwwWiID,
      SwwWistat,
      SwwAed,
      WfLevel1,
      WfLevel2,
      WfLevel3,
      PlantTypeIMM,
      PlantTypeNewIMMTL,
      Autoapp,
      PackageCN,
      PlantType,
      PlantTypeNew,

      ChildPartTL,
      TLNumber,
      LeadCN,
      PackCN,
      CommentText,
      CommentText2,

      LocalLastChangedAt,
      LocalCreatedAt,
      @ObjectModel.text.element: [ 'LocalCreatedByU' ]
      LocalCreatedBy,
      @ObjectModel.text.element: [ 'LocalLastChangedByU' ]
      LocalLastChangedBy,

      /*descriptions*/
      _LocalCreatedByU.UserName     as LocalCreatedByU,
      _LocalLastChangedByU.UserName as LocalLastChangedByU,
      _TextView.text                as StatusText,

      /*associations*/
      _LocalCreatedByU,
      _LocalLastChangedByU,
      _Header : redirected to parent ZCJS_C_TLR_HEAD

}
