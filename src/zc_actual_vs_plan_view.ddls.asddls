@AbapCatalog.sqlViewName: 'ZC_ACTUALPLAN'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual V/S plan'
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
                                                                           
@VDM.viewType: #BASIC
@Analytics.dataCategory: #CUBE
//@VDM.viewType: #COMPOSITE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZC_ACTUAL_VS_PLAN_VIEW
 as select from salesplan_item
 
  association [1..1] to I_SalesPlan             as _SalesPlan           on $projection.SalesPlanUUID = _SalesPlan.SalesPlanUUID
  association [0..1] to I_SalesOrganization     as _SalesOrganization   on $projection.SalesOrganization = _SalesOrganization.SalesOrganization
  association [0..1] to I_DistributionChannel   as _DistributionChannel on $projection.DistributionChannel = _DistributionChannel.DistributionChannel
  association [0..1] to I_Division              as _Division            on $projection.Division = _Division.Division
  association [0..1] to I_CustomerGroup         as _CustomerGroup       on $projection.CustomerGroup = _CustomerGroup.CustomerGroup
  association [0..1] to I_Customer              as _Customer            on $projection.Customer = _Customer.Customer
  association [0..1] to I_Product               as _Product             on $projection.Product = _Product.Product
  association [0..1] to I_ProductGroup_2        as _ProductGroup        on $projection.ProductGroup = _ProductGroup.ProductGroup
  association [0..1] to I_MaterialGroup         as _MaterialGroup       on $projection.MaterialGroup = _MaterialGroup.MaterialGroup
  association [0..1] to I_Material              as _Material            on $projection.Material = _Material.Material
  //association [0..1] to I_Employee            as _SalesEmployee         on $projection.SalesEmployee = _SalesEmployee.PersonnelNumber
  association [0..1] to I_PersonWorkAgreement_1 as _SalesEmployee       on $projection.SalesEmployee = _SalesEmployee.PersonWorkAgreement
  association [0..1] to I_Currency              as _SalesPlanCurrency   on $projection.SalesPlanCurrency = _SalesPlanCurrency.Currency
  association [0..1] to I_UnitOfMeasure         as _SalesPlanUnit       on $projection.SalesPlanUnit = _SalesPlanUnit.UnitOfMeasure
   association [0..1] to   I_CalendarDate                                                                                                                    
as CalendarDate           on salesplan_item.salesplanperiod = CalendarDate.CalendarDate
   association [0..1] to I_CalendarDate                                                                                                                    
as CalendarDateSalesOrder on salesplan_item.salesplanperiod = CalendarDateSalesOrder.CalendarDate
{

  key salesplanitemuuid                as    SalesPlanItemUUID,
      @ObjectModel.foreignKey.association: '_SalesPlan'
      salesplan_item.salesplanuuid     as    SalesPlanUUID,
//    naga
   @Semantics.calendar.year
      cast(CalendarDateSalesOrder.CalendarYear as sales_order_date_year)                    as SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      cast(CalendarDateSalesOrder.YearQuarter as sales_order_date_year_quarter)             as SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      cast(CalendarDateSalesOrder.YearMonth as sales_order_date_year_month)                 as SalesOrderDateYearMonth,
//naga
      //Dimensions
      // Organization
      @ObjectModel.foreignKey.association: '_SalesOrganization'
      salesorganization                as    SalesOrganization,
      @ObjectModel.foreignKey.association: '_DistributionChannel'
      distributionchannel              as    DistributionChannel,
      organizationdivision             as    OrganizationDivision,
      salesoffice                      as    SalesOffice,
      salesgroup                       as    SalesGroup,
      salesdistrict                    as    SalesDistrict,

      // Customer
      @ObjectModel.foreignKey.association: '_Customer'
      customer                         as    Customer,
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      customergroup                    as    CustomerGroup,
      shiptoparty                      as    ShipToParty,
      billtoparty                      as    BillToParty,
      payerparty                       as    PayerParty,
      additionalcustomergroup1         as    AdditionalCustomerGroup1,
      additionalcustomergroup2         as    AdditionalCustomerGroup2,
      additionalcustomergroup3         as    AdditionalCustomerGroup3,
      additionalcustomergroup4         as    AdditionalCustomerGroup4,
      additionalcustomergroup5         as    AdditionalCustomerGroup5,

      // Product
      @ObjectModel.foreignKey.association: '_Division'
      division                         as    Division,
      @ObjectModel.foreignKey.association: '_Product'
      cast (product as productnumber preserving type ) as Product,
      @ObjectModel.foreignKey.association: '_ProductGroup'
      cast (productgroup as productgroup preserving type ) as ProductGroup,
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'Product'       
      @ObjectModel.foreignKey.association: '_Material'
      material                         as    Material,
      @VDM.lifecycle.status:    #DEPRECATED
      @VDM.lifecycle.successor: 'ProductGroup'      
      @ObjectModel.foreignKey.association: '_MaterialGroup'
      materialgroup                    as    MaterialGroup,
      additionalmaterialgroup1         as    AdditionalMaterialGroup1,
      additionalmaterialgroup2         as    AdditionalMaterialGroup2,
      additionalmaterialgroup3         as    AdditionalMaterialGroup3,
      additionalmaterialgroup4         as    AdditionalMaterialGroup4,
      additionalmaterialgroup5         as    AdditionalMaterialGroup5,

      // Employee
      @ObjectModel.foreignKey.association: '_SalesEmployee'
      salesemployee                    as    SalesEmployee,

      // Shipping
      plant                            as    Plant,
      shippingtype                     as    ShippingType,

      // Cost
      profitcenter                     as    ProfitCenter,
      costcenter                       as    CostCenter,
      companycode                      as    CompanyCode,
      controllingarea                  as    ControllingArea,
      businessarea                     as    BusinessArea,

      // Geography
      country                          as    Country,
      billtopartycountry               as    BillToPartyCountry,
      region                           as    Region,
      billtopartyregion                as    BillToPartyRegion,

      //Plan Item Data
      salesplanperiod                  as    SalesPlanPeriod,
      @Semantics.amount.currencyCode: 'SalesPlanCurrency'
      salesplanamount                  as    SalesPlanAmount,
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: '_SalesPlanCurrency'
      salesplan_item.salesplancurrency as    SalesPlanCurrency,

      //Quantity Planning
      @Semantics.quantity.unitOfMeasure: 'SalesPlanUnit'
      salesplanquantity                as    SalesPlanQuantity,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_SalesPlanUnit'
      salesplanunit                    as    SalesPlanUnit,

      //Association
      @ObjectModel.association.type: [ #TO_COMPOSITION_ROOT, #TO_COMPOSITION_PARENT ]
      _SalesPlan,
      _SalesOrganization,
      _DistributionChannel,
      _Division,
      _CustomerGroup,
      _Customer,
      _Product,
      _ProductGroup,
      @VDM.lifecycle.status: #DEPRECATED
      @VDM.lifecycle.successor: '_ProductGroup'
      _MaterialGroup,
      @VDM.lifecycle.status: #DEPRECATED
      @VDM.lifecycle.successor: '_Product'
      _Material,
      _SalesEmployee,
      _SalesPlanCurrency,
      _SalesPlanUnit

}
