@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TLR Status Desription'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define view entity ZCJS_I_TLR_Status_Description
  as select from zdjs_dd07t
{
  // key dd07t.domname as domain_name,
  // key dd07t.valpos as value_position,
  @Semantics.language: true
  ddlanguage as language,
  domvalue_l as valuelow,
  @Semantics.text: true
  ddtext     as text
}
where
      domname    = 'ZPLM_DO_TLR_STAT'
  and ddlanguage = $session.system_language
