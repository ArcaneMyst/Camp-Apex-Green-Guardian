trigger PlantAfterUpdate on CAMPX__Plant__c (after update) {

    //Collect List of garden Ids associated with the inserted plant
    List<CAMPX__Garden__c> gardensToUpdate = new List<CAMPX__Garden__c>();
    Set<Id> gardenIdsToUpdate = new Set<Id>();

    for (CAMPX__Plant__c plant : Trigger.new){
        if (plant.CAMPX__Garden__c != null){
            gardenIdsToUpdate.add(plant.CAMPX__Garden__c);
        }

        Id oldGardenId = Trigger.oldMap.get(plant.Id).CAMPX__Garden__c;
        if(oldGardenId != plant.CAMPX__Garden__c){
            gardenIdsToUpdate.add(oldGardenId);
        }

    }

    if(!gardenIdsToUpdate.isEmpty()){
        GardenCalculator.updateGardenPlants(new List<Id>(gardenIdsToUpdate));
    }

}