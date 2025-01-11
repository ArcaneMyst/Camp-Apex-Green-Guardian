@isTest
public class GardenAfterUpdateTest {
    @isTest
    static void testTaskCreationOnManagerUpdate() {
        // Create a test Garden record with no Manager
        CAMPX__Garden__c garden = new CAMPX__Garden__c(
            Name = 'Test Garden'
        );
        insert garden;

        // Update the Garden record to assign a Manager
        User testManager = [SELECT Id FROM User LIMIT 1]; // Use any test user
        garden.CAMPX__Manager__c = testManager.Id;
        update garden;

        // Verify that a Task was created
        Task createdTask = [SELECT Id, Subject, WhatId, OwnerId FROM Task WHERE WhatId = :garden.Id LIMIT 1];
        System.assertNotEquals(null, createdTask, 'A Task should be created for the Garden');
        System.assertEquals('Acquire Plants', createdTask.Subject, 'The Task subject should be "Acquire Plants"');
        System.assertEquals(testManager.Id, createdTask.OwnerId, 'The Task owner should match the Garden Manager');
    }

    @isTest
    static void testNoTaskCreationIfManagerNotUpdated() {
        // Create a test Garden record with a Manager already assigned
        User testManager = [SELECT Id FROM User LIMIT 1]; // Use any test user
        CAMPX__Garden__c garden = new CAMPX__Garden__c(
            Name = 'Garden With Manager',
            CAMPX__Manager__c = testManager.Id
        );
        insert garden;

        // Perform an update without changing the Manager
        update garden;

        // Verify no Task was created
        Task createdTask = [SELECT Id, Subject, WhatId, OwnerId FROM Task WHERE WhatId = :garden.Id LIMIT 1];
        System.assertEquals(testManager.Id, createdTask.OwnerId, 'The Task owner should match the Garden Manager');
    }
}
