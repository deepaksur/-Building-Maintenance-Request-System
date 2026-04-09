@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BMR Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZBMR_C_HDR_22IT018
  provider contract transactional_query
  as projection on ZBMR_I_HDR_22IT018
{
  key RequestNo,
  RequestType,
  Priority,
  Location,
  Building,
  Floor,
  Room,
  @Search.defaultSearchElement: true
  Description,
  Status,
  RequestedBy,
  @Semantics.amount.currencyCode: 'Currency'
  EstimatedCost,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  /* Associations */
  _MaintItem : redirected to composition child ZBMR_C_ITM_22IT018
}
