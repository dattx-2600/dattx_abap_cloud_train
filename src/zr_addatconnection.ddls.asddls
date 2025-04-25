@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_ADDATCONNECTION
  as select from ZADDATCONNECTION as ZMODEL_CON_DATTX
{
  key uuid as Uuid,
  carried as Carried,
  connid as Connid,
  airport_from as AirportFrom,
  city_from as CityFrom,
  country_from as CountryFrom,
  airport_to as AirportTo,
  city_to as CityTo,
  country_to as CountryTo,
  @Semantics.user.createdBy: true
  lacal_created_by as LacalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  lacal_created_at as LacalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  lacal_last_changed_by as LacalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lacal_last_changed_at as LacalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  lacal_changed_at as LacalChangedAt
  
}
