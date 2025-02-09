public with sharing class GardenCalculator {
    public static void updateGardenPlants(List<Id> gardenIds) {
        if (gardenIds == null || gardenIds.isEmpty()) {
            return; // Exit if no valid garden IDs provided
        }

        // Map to store Garden Ids and their respective plant count
        Map<Id, Integer> gardenToPlantCount = new Map<Id, Integer>();

        // Aggregate query to count number of plants per garden
        for (AggregateResult ar : [
            SELECT CAMPX__Garden__c Id, COUNT(Id) plantCount
            FROM CAMPX__Plant__c
            WHERE CAMPX__Garden__c IN :gardenIds
            GROUP BY CAMPX__Garden__c
        ]) {
            gardenToPlantCount.put((Id) ar.get('Id'), (Integer) ar.get('plantCount'));
        }

        // List to store Gardens that need updates
        List<CAMPX__Garden__c> gardensToUpdate = new List<CAMPX__Garden__c>();

        // Loop through garden IDs and update the count (default to 0 if no plants)
        for (Id gardenId : gardenIds) {
            gardensToUpdate.add(new CAMPX__Garden__c(
                Id = gardenId,
                CAMPX__Total_Plant_Count__c = gardenToPlantCount.containsKey(gardenId) ? gardenToPlantCount.get(gardenId) : 0
            ));
        }

        // Perform the update if there are gardens to update
        if (!gardensToUpdate.isEmpty()) {
            update gardensToUpdate;
        }
    }
}
