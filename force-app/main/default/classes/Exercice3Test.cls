@isTest
private class Exercice3Test {

    @testSetup
    static void setupTestData() {
        // Create test Accounts (one standard, one competitor)
        Account standardAcc = new Account(Name = 'Test Client Account');
        Account compAcc = new Account(Name = 'Test Competitor Account');
        insert new List<Account>{standardAcc, compAcc};

        // Create a test Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            AccountId = standardAcc.Id
        );
        insert opp;

        // Create a test Quote linked to the Opportunity
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id
        );
        insert testQuote;
    }

    @isTest
    static void testPreventDuplicateCompetitors_Positive() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Account compAcc = [SELECT Id FROM Account WHERE Name = 'Test Competitor Account' LIMIT 1];

        // First insert should succeed
        Competitor__c comp1 = new Competitor__c(
            Opportunity__c = opp.Id,
            Competitor_Account__c = compAcc.Id
        );
        
        Test.startTest();
        Database.SaveResult result1 = Database.insert(comp1, false);
        Test.stopTest();

        System.assert(result1.isSuccess(), 'The first competitor record should insert successfully.');
    }

    @isTest
    static void testPreventDuplicateCompetitors_Negative() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Account compAcc = [SELECT Id FROM Account WHERE Name = 'Test Competitor Account' LIMIT 1];

        // Insert initial tracking record
        Competitor__c comp1 = new Competitor__c(
            Opportunity__c = opp.Id,
            Competitor_Account__c = compAcc.Id
        );
        insert comp1;

        // Attempting to insert a duplicate record for the same Opp and Competitor Account
        Competitor__c duplicateComp = new Competitor__c(
            Opportunity__c = opp.Id,
            Competitor_Account__c = compAcc.Id
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateComp, false);
        Test.stopTest();

        // Verification
        System.assert(!result.isSuccess(), 'The duplicate competitor record insertion should have failed.');
        System.assertEquals('This Competitor Account is already tracking against this Opportunity.', result.getErrors()[0].getMessage());
    }

    @isTest
    static void testAssignCompetitorToAccount_AfterInsert() {
        Quote testQuote = [SELECT Id, OpportunityId, Opportunity.Name FROM Quote LIMIT 1];
        Account compAcc = [SELECT Id FROM Account WHERE Name = 'Test Competitor Account' LIMIT 1];

        // This competitor is tied to a Quote. The trigger should fire assignCompetitorToAccount
        // and spawn a *new* Competitor record mapped directly to the Quote's Opportunity.
        Competitor__c compWithQuote = new Competitor__c(
            Quote__c = testQuote.Id,
            Competitor_Account__c = compAcc.Id
        );

        Test.startTest();
        insert compWithQuote;
        Test.stopTest();

        // Verify that the trigger asynchronously/automatically spawned the new Competitor record mapped to the Opp
        List<Competitor__c> spawnedCompetitors = [
            SELECT Id, Name, Opportunity__c, Competitor_Account__c 
            FROM Competitor__c 
            WHERE Opportunity__c = :testQuote.OpportunityId 
            AND Competitor_Account__c = :compAcc.Id
        ];

        System.assertEquals(1, spawnedCompetitors.size(), 'A secondary competitor record should have been spawned for the Opportunity.');
        System.assertEquals('Comp ' + testQuote.Opportunity.Name, spawnedCompetitors[0].Name, 'The auto-generated name format is incorrect.');
    }

    @isTest
    static void testAssignCompetitorToAccount_Bulk() {
        Account compAcc = [SELECT Id FROM Account WHERE Name = 'Test Competitor Account' LIMIT 1];
        Account standardAcc = [SELECT Id FROM Account WHERE Name = 'Test Client Account' LIMIT 1];
        
        // Setup bulk opportunities and quotes
        List<Opportunity> bulkOpps = new List<Opportunity>();
        for (Integer i = 0; i < 20; i++) {
            bulkOpps.add(new Opportunity(
                Name = 'Bulk Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = System.today().addDays(30),
                AccountId = standardAcc.Id
            ));
        }
        insert bulkOpps;

        List<Quote> bulkQuotes = new List<Quote>();
        for (Opportunity opp : bulkOpps) {
            bulkQuotes.add(new Quote(Name = 'Quote for ' + opp.Name, OpportunityId = opp.Id));
        }
        insert bulkQuotes;

        // Build a list of competitor records referencing those quotes
        List<Competitor__c> bulkComps = new List<Competitor__c>();
        for (Quote q : bulkQuotes) {
            bulkComps.add(new Competitor__c(
                Quote__c = q.Id,
                Competitor_Account__c = compAcc.Id
            ));
        }

        Test.startTest();
        insert bulkComps;
        Test.stopTest();

        // Verify bulk execution successfully generated 20 relationship tracking records
        List<Competitor__c> totalOpportuntiyCompetitors = [
            SELECT Id FROM Competitor__c WHERE Opportunity__c IN :bulkOpps
        ];
        System.assertEquals(20, totalOpportuntiyCompetitors.size(), 'Bulk creation should seamlessly handle 20 cross-reference records.');
    }
}