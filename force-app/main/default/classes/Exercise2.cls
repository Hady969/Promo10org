public with sharing class Exercise2 {
    
    public static void countContactOccurrences(List<Contact> contactList, Map<Id, Contact> oldMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        
        // 1. Collect affected Account IDs
        if (contactList != null) {
            for (Contact con : contactList) {
                // For Update: Check if Account changed OR if the targeted criteria fields changed
                if (oldMap != null && oldMap.containsKey(con.Id)) {
                    Contact oldCon = oldMap.get(con.Id);
                    if (con.AccountId != oldCon.AccountId || 
                        con.FirstName != oldCon.FirstName || 
                        con.LastName != oldCon.LastName) {
                        
                        if (con.AccountId != null) accountIdsToUpdate.add(con.AccountId);
                        if (oldCon.AccountId != null) accountIdsToUpdate.add(oldCon.AccountId);
                    }
                } else {
                    // For Insert / Undelete
                    if (con.AccountId != null) {
                        accountIdsToUpdate.add(con.AccountId);
                    }
                }
            }
        } else if (oldMap != null) {
            // For Delete (contactList is null, we use oldMap)
            for (Contact oldCon : oldMap.values()) {
                if (oldCon.AccountId != null) {
                    accountIdsToUpdate.add(oldCon.AccountId);
                }
            }
        }
        
        // 2. Recalculate and Update Accounts
        if (!accountIdsToUpdate.isEmpty()) {
            updateAccountContactCounts(accountIdsToUpdate);
        }
    }
    
    private static void updateAccountContactCounts(Set<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        
        // Initialize all target accounts with 0 to handle cases where no contacts match anymore
        for (Id accId : accountIds) {
            accountsToUpdate.add(new Account(
                Id = accId, 
                Number_of_Special_Contacts__c = 0 // Replace with your actual custom field API name
            ));
        }
        Map<Id, Account> accountMap = new Map<Id, Account>(accountsToUpdate);
        
        // Aggregate Query to count contacts matching: FirstName = NULL OR LastName = 'Smith'
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) total
            FROM Contact
            WHERE AccountId IN :accountIds 
            AND (FirstName = null OR LastName = 'Smith')
            GROUP BY AccountId
        ];
        
        // Populate the actual counts from the query
        for (AggregateResult ar : results) {
            Id accId = (Id) ar.get('AccountId');
            Integer count = (Integer) ar.get('total');
            
            if (accountMap.containsKey(accId)) {
                accountMap.get(accId).Number_of_Special_Contacts__c = count;
            }
        }
        
        // DML Update
        if (!accountMap.isEmpty()) {
            update accountMap.values();
        }
    }
}