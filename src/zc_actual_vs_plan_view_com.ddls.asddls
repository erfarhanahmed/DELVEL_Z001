@AbapCatalog.sqlViewName: 'ZC_ACTUALPLAN1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual V/S plan Composite view'

@Analytics:{
    dataExtraction: {
        enabled: true,
        delta.changeDataCapture.automatic: true
    }
}
@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                     
                                      ]
// @ObjectModel.transactionalProcessingEnabled: false
                                                                           
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZC_ACTUAL_VS_PLAN_VIEW_COM 
as select from ZC_ACTUAL_VS_PLAN_VIEW
{
   
  /* Keys */
  key SalesPlanItemUUID,
      SalesPlanUUID,
//   naga 
     @Semantics.calendar.year
     SalesOrderDateYear,
//       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      SalesOrderDateYearMonth,
//naga
  /* Organization */
      SalesOrganization,
      DistributionChannel,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      SalesDistrict,

  /* Customer */
      Customer,
      CustomerGroup,
      ShipToParty,
      BillToParty,
      PayerParty,
      AdditionalCustomerGroup1,
      AdditionalCustomerGroup2,
      AdditionalCustomerGroup3,
      AdditionalCustomerGroup4,
      AdditionalCustomerGroup5,

  /* Product */
      Division,
      Product,
      ProductGroup,

  /* Employee */
      SalesEmployee,

  /* Shipping */
      Plant,
      ShippingType,

  /* Cost Objects */
      ProfitCenter,
      CostCenter,
      CompanyCode,
      ControllingArea,
      BusinessArea,

  /* Geography */
      Country,
      BillToPartyCountry,
      Region,
      BillToPartyRegion,

  /* Time */
      SalesPlanPeriod,

  /* Measures */
      
      @DefaultAggregation: #SUM
      SalesPlanAmount,
 @Semantics.currencyCode: true
      SalesPlanCurrency,

    
      @DefaultAggregation: #SUM
      SalesPlanQuantity,

      SalesPlanUnit,

  /* Associations */
      _SalesPlan,
      _SalesOrganization,
      _DistributionChannel,
      _Division,
      _Customer,
      _CustomerGroup,
      _Product,
      _ProductGroup,
      _SalesEmployee,
      _SalesPlanCurrency,
      _SalesPlanUnit

    
}
