trigger GardenAfterInsert on CAMPX__Garden__c (after insert) {
    // List to store tasks to be created
    List<Task> tasksToInsert = new List<Task>();

    // Iterate through the inserted Garden records
    for (CAMPX__Garden__c garden : Trigger.new) {
        // Check if CAMPX__Manager__c is populated
        if (garden.CAMPX__Manager__c != null) {
            // Create a Task related to this Garden
            Task newTask = new Task(
                WhatId = garden.Id, // Relates the Task to the Garden record
                Subject = 'Acquire Plants',
                OwnerId = garden.CAMPX__Manager__c // Assign the Task to the Manager
            );
            tasksToInsert.add(newTask);
        }
    }

    // Insert tasks if there are any to create
    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
}
