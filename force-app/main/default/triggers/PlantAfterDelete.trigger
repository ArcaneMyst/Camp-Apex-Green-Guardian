trigger PlantAfterDelete on CAMPX__Plant__c (after delete) {

    //Collect List of garden Ids associated with the inserted plant
    List<CAMPX__Garden__c> gardensToUpdate = new List<CAMPX__Garden__c>();
    Set<Id> gardenIdsToUpdate = new Set<Id>();

    for (CAMPX__Plant__c plant : Trigger.old){
        if (plant.CAMPX__Garden__c != null){
            gardenIdsToUpdate.add(plant.CAMPX__Garden__c);
        }

    }

    if(!gardenIdsToUpdate.isEmpty()){
        GardenCalculator.updateGardenPlants(new List<Id>(gardenIdsToUpdate));
    }

}