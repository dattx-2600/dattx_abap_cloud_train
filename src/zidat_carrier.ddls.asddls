@AbapCatalog.sqlViewName: 'ZIDATCARRVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds carriver for value help'
@Metadata.ignorePropagatedAnnotations: true
define view ZIDAT_Carrier as select from /dmo/carrier
{
    @UI.lineItem: 
    [{ position: 10 , importance: #HIGH }]
    key carrier_id as AirlineID,
    
    @UI.lineItem: 
    [{ position: 10 , importance: #HIGH }]
    key name as CarrierName   
}
