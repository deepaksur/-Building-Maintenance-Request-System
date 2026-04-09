@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BMR Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZBMR_C_ITM_22IT018
  as projection on ZBMR_I_ITM_22IT018
{
  key RequestNo,
  key ItemNumber,
  @Search.defaultSearchElement: true
  WorkType,
  WorkerAssigned,
  SparePartNo,
  SpareDescription,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  Quantity,
  Uom,
  @Semantics.amount.currencyCode: 'Currency'
  ItemCost,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  /* Associations */
  _MaintHeader : redirected to parent ZBMR_C_HDR_22IT018
}
