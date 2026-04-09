@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BMR Child Interface View - Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZBMR_I_ITM_22IT018
  as select from zbmr_itm_22it018
  association to parent ZBMR_I_HDR_22IT018 as _MaintHeader
    on $projection.RequestNo = _MaintHeader.RequestNo
{
  key requestno           as RequestNo,
  key itemnumber          as ItemNumber,
  worktype                as WorkType,
  workerAssigned          as WorkerAssigned,
  sparepartno             as SparePartNo,
  sparedescription        as SpareDescription,
  @Semantics.quantity.unitOfMeasure: 'Uom'
  quantity                as Quantity,
  uom                     as Uom,
  @Semantics.amount.currencyCode: 'Currency'
  itemcost                as ItemCost,
  currency                as Currency,
  @Semantics.user.createdBy: true
  local_created_by        as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at        as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by   as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at   as LocalLastChangedAt,
  /* Associations */
  _MaintHeader
}
