@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_ADDATCONNECTION
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_ADDATCONNECTION
{
  key Uuid,
  Carried,
  Connid,
  AirportFrom,
  CityFrom,
  CountryFrom,
  AirportTo,
  CityTo,
  CountryTo,
  LacalCreatedBy,
  LacalCreatedAt,
  LacalLastChangedBy,
  LacalLastChangedAt,
  LacalChangedAt
  
}
