@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZPLM_I_TLR_HEAD'
@ObjectModel.semanticKey: [ 'TlNumber' ]
define root view entity ZCJS_C_TLR_HEAD
  provider contract transactional_query
  as projection on zcjs_i_tlr_head
{
  key TlUUID,
      TlNumber,

      @ObjectModel.text: {
      element: [ 'HeaderStatusText' ] }
      @UI.textArrangement: #TEXT_ONLY
      TlStatus,
      TlReference,
      CtReference,
      Aennr,
      SwwWiID,
      SwwWistat,
      SwwAed,
      WfLevel1,
      WfLevel2,
      WfLevel3,
      Werks,
      Autoapp,
      LeadCN,
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
      _HeaderStatus.text            as HeaderStatusText,

      /*associations*/
      _LocalCreatedByU,
      _LocalLastChangedByU,
      _Item     : redirected to composition child ZCJS_C_TLR_ITEM,
      _Comments : redirected to composition child zcjs_c_tlr_comm

}
