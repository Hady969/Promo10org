public with sharing class AccountController{
    public static string createNewAccount(string accountName){
        Account acc = new Account(Name = accountName); 

        insert acc;
        return acc.Id;
    }

    @AuraEnabled(cacheable=true) 
    public static List<Account> getAccounts(Integer maxRecords){
        return [SELECT Id, Name FROM Account LIMIT :maxRecords];
    }
}