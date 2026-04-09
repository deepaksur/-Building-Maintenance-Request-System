@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BMR Root Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZBMR_I_HDR_22IT018
  as select from zbmr_hdr_22it018 as MaintHeader
  composition [0..*] of ZBMR_I_ITM_22IT018 as _MaintItem
{
  key requestno          as RequestNo,
  requesttype            as RequestType,
  priority               as Priority,
  location               as Location,
  building               as Building,
  floor                  as Floor,
  room                   as Room,
  description            as Description,
  status                 as Status,
  requestedby            as RequestedBy,
  @Semantics.amount.currencyCode: 'Currency'
  estimatedcost          as EstimatedCost,
  currency               as Currency,
  @Semantics.user.createdBy: true
  local_created_by       as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at       as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by  as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at  as LocalLastChangedAt,
  /* Associations */
  _MaintItem
}
