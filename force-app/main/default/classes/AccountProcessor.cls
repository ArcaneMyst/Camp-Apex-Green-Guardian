public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        // Ensure the list of account IDs is not null or empty
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        // Query for the number of contacts grouped by Account ID
        Map<Id, Integer> contactCountMap = new Map<Id, Integer>();
        for (AggregateResult result : [
            SELECT AccountId, COUNT(Id) counts 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ]) {
            contactCountMap.put((Id)result.get('AccountId'), (Integer)result.get('counts'));
        }

        // Update the Number_Of_Contacts__c field on each Account
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Integer contactCount = contactCountMap.get(accountId);
            accountsToUpdate.add(new Account(
                Id = accountId,
                Number_Of_Contacts__c = contactCount != null ? contactCount : 0
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
