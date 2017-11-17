/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class zCharge {
    global String CHARGE_TYPE {
        get;
    }
    global SObject chargeObject {
        get;
        set;
    }
    global List<zqu__QuoteCharge_Tier__c> chargeTiersObjects {
        get;
    }
    global Map<String,String> customfieldNameValueMap {
        get;
        set;
    }
    global String DISCOUNT {
        get;
        set;
    }
    global String EFFECTIVE_PRICE {
        get;
        set;
    }
    global List<String> fieldsChangedInRulesEngine {
        get;
        set;
    }
    global Boolean hasCustomTiers {
        get;
        set;
    }
    global Id Id {
        get;
    }
    global String INCLUDED_UNITS {
        get;
        set;
    }
    global Boolean isDiscountEditable {
        get;
    }
    global Boolean isEffectivePriceEditable {
        get;
    }
    global Boolean isIncludedUnitsEditable {
        get;
    }
    global Boolean isQuantityEditable {
        get;
    }
    global Boolean isTotalEditable {
        get;
    }
    global String LIST_PRICE {
        get;
    }
    global String LIST_TOTAL {
        get;
    }
    global String MODEL {
        get;
    }
    global String NAME {
        get;
    }
    global String PERIOD {
        get;
    }
    global String PRODUCT_RATE_PLAN_CHARGE_SFDC_ID {
        get;
    }
    global String PRODUCT_RATE_PLAN_CHARGE_ZUORA_ID {
        get;
    }
    global String QUANTITY {
        get;
        set;
    }
    global String SUBSCRIPTION_RATE_PLAN_CHARGE_ID {
        get;
    }
    global String TOTAL {
        get;
        set;
    }
    global String UNIT_OF_MEASURE {
        get;
    }
    global zCharge() {

    }
    global String getQuoteRatePlanChargeZuoraId() {
        return null;
    }
    global void populateCustomChargeTiers(List<zqu__QuoteCharge_Tier__c> tiers) {

    }
}
