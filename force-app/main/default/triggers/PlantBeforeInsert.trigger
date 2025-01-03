trigger PlantBeforeInsert on CAMPX__Plant__c (before insert) {
    // Collect Garden IDs from the incoming Plant records
    Set<Id> gardenIds = new Set<Id>();
    for (CAMPX__Plant__c plant : Trigger.new) {
        if (plant.CAMPX__Garden__c != null) {
            gardenIds.add(plant.CAMPX__Garden__c);
        }
    }

    // Query related Gardens and store their Sun Exposure values in a map
    Map<Id, String> gardenToSunExposureMap = new Map<Id, String>();
    if (!gardenIds.isEmpty()) {
        for (CAMPX__Garden__c garden : [
            SELECT Id, CAMPX__Sun_Exposure__c
            FROM CAMPX__Garden__c
            WHERE Id IN :gardenIds
        ]) {
            gardenToSunExposureMap.put(garden.Id, garden.CAMPX__Sun_Exposure__c);
        }
    }

    // Iterate over the Plant records and set the fields
    for (CAMPX__Plant__c plant : Trigger.new) {
        // Default soil type if not provided
        if (String.isBlank(plant.CAMPX__Soil_Type__c)) {
            plant.CAMPX__Soil_Type__c = 'All Purpose Potting Soil';
        }

        // Default water if not provided
        if (String.isBlank(plant.CAMPX__Water__c)) {
            plant.CAMPX__Water__c = 'Once Weekly';
        }

        // Set the Sunlight field based on the related Garden's Sun Exposure or default to "Partial Sun"
        if (plant.CAMPX__Garden__c != null) {
            plant.CAMPX__Sunlight__c = gardenToSunExposureMap.get(plant.CAMPX__Garden__c);
        }
        if (String.isBlank(plant.CAMPX__Sunlight__c)) {
            plant.CAMPX__Sunlight__c = 'Partial Sun';
        }
    }
}
