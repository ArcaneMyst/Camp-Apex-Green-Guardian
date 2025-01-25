trigger GardenBeforeUpdate on CAMPX__Garden__c (before update) {

    for(CAMPX__Garden__c garden : Trigger.new) {

        //Check if the manager has been populated fresh or changed       
        if (Trigger.OldMap.get(garden.Id).CAMPX__Manager__c != garden.CAMPX__Manager__c && garden.CAMPX__Manager__c != null){
            garden.CAMPX__Manager_Start_Date__c = Date.today();
        }

        //Check if the manager has been removed     
        if (Trigger.OldMap.get(garden.Id).CAMPX__Manager__c != null && garden.CAMPX__Manager__c == null){
            garden.CAMPX__Manager_Start_Date__c = null;
        }

    }

}