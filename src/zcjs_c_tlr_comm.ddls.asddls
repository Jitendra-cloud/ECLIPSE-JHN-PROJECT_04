@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZPLM_I_TLR_COMM'
define view entity zcjs_c_tlr_comm
  as projection on ZCJS_I_TLR_COMM
{
  key TlUUID,
  key CommentUUID,
      UserProfile,
      TlItemNumber,
      CommentText,
      LocalLastChangedAt,
      LocalCreatedAt,
      @ObjectModel.text.element: [ 'LocalCreatedByU' ]
      LocalCreatedBy,
      @ObjectModel.text.element: [ 'LocalLastChangedByU' ]
      LocalLastChangedBy,


      /*descriptions*/
      _LocalCreatedByU.UserName     as LocalCreatedByU,
      _LocalLastChangedByU.UserName as LocalLastChangedByU,


      /*associations*/
      _LocalCreatedByU,
      _LocalLastChangedByU,

      _Header : redirected to parent ZCJS_C_TLR_HEAD



}
