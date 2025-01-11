trigger GardenAfterUpdate on CAMPX__Garden__c (after update) {
    // List to store tasks to be created
    List<Task> tasksToInsert = new List<Task>();
    List<Task> tasksToUpdate = new List<Task>();

    // Iterate through the updated Garden records
    for(CAMPX__Garden__c garden : Trigger.new) {
        // Check if CAMPX__Manager__c is populated
        if (Trigger.OldMap.get(garden.Id).CAMPX__Manager__c == null && garden.CAMPX__Manager__c != null) {
            // Create a Task related to this Garden
            Task newTask = new Task(
                WhatId = garden.Id, // Relates the Task to the Garden record
                Subject = 'Acquire Plants',
                OwnerId = garden.CAMPX__Manager__c // Assign the Task to the Manager
            );
            tasksToInsert.add(newTask);
        }

        if (Trigger.OldMap.get(garden.Id).CAMPX__Manager__c !=null && Trigger.OldMap.get(garden.Id).CAMPX__Manager__c != garden.CAMPX__Manager__c) {
            // Find if a Task related to this Garden is still not complete with the old manager                
            List<Task> taskToReassign = [SELECT Id, Status, Subject, WhatId, OwnerId FROM Task WHERE WhatId = :garden.Id AND Subject = 'Acquire Plants' AND Status != 'Completed'];
            if(!taskToReassign.isEmpty()){
                for(Task returnedTask : taskToReassign){
                    returnedTask.OwnerId = garden.CAMPX__Manager__c;
                    tasksToUpdate.add(returnedTask);
                }
            }             
        }
    }

    // Insert tasks if there are any to create
    if (!tasksToInsert.isEmpty()) {
        try {
            insert tasksToInsert;
        } catch (DmlException e) {
            // Log error (optional) or handle it appropriately
            System.debug('Error inserting tasks: ' + e.getMessage());
        }
    }

    // Update any tasks if manager has changed
    if (!tasksToUpdate.isEmpty()) {
        try {
            update tasksToUpdate;
        } catch (DmlException e) {
            // Log error (optional) or handle it appropriately
            System.debug('Error updating tasks: ' + e.getMessage());
        }
    }
}
