public with sharing class Exercice3 {

    public static void handleBeforeInsert(List<Competitor__c> newCompetitors) {
        preventDuplicateCompetitors(newCompetitors);
    }

    public static void handleAfterInsert(List<Competitor__c> newCompetitors) {
        // FIX 1 (Line 8): Replaced the non-existent 'syncCompetitorToOpportunity' call 
        // with your actual method 'assignCompetitorToAccount'
        assignCompetitorToAccount(newCompetitors, null);
    }

    private static void preventDuplicateCompetitors(List<Competitor__c> newCompetitors) {
        Set<Id> accIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();

        for (Competitor__c comp : newCompetitors) {
            if (comp.Competitor_Account__c != null) accIds.add(comp.Competitor_Account__c);
            if (comp.Opportunity__c != null) oppIds.add(comp.Opportunity__c);
        }

        Set<String> existingOppComps = new Set<String>();
        if (!oppIds.isEmpty() && !accIds.isEmpty()) {
            for (Competitor__c existing : [
                SELECT Opportunity__c, Competitor_Account__c 
                FROM Competitor__c 
                WHERE Competitor_Account__c IN :accIds 
                AND Opportunity__c IN :oppIds
            ]) {
                existingOppComps.add(existing.Opportunity__c + '-' + existing.Competitor_Account__c);
            }
        }

        for (Competitor__c comp : newCompetitors) {
            if (comp.Opportunity__c != null && comp.Competitor_Account__c != null) {
                String key = comp.Opportunity__c + '-' + comp.Competitor_Account__c;
                if (existingOppComps.contains(key)) {
                    comp.addError('This Competitor Account is already tracking against this Opportunity.');
                }
            }
        }
    }

    public static void assignCompetitorToAccount(List<Competitor__c> newList, Map<Id, Competitor__c> oldMap) {
        Map<Id, Id> quoteIdToAccountId = new Map<Id, Id>();

        for (Competitor__c comp : newList) {
            // FIX 2 (Line 53): Changed 'Account__c' to 'Competitor_Account__c'
            if ((oldMap == null || oldMap.get(comp.Id).Quote__c != comp.Quote__c) && comp.Quote__c != null && comp.Competitor_Account__c != null) {
                quoteIdToAccountId.put(comp.Quote__c, comp.Competitor_Account__c);
            }
        }

        if (!quoteIdToAccountId.isEmpty()) {
            List<Competitor__c> compList = new List<Competitor__c>();

            for (Quote quote : [SELECT OpportunityId, Opportunity.Name FROM Quote WHERE Id IN :quoteIdToAccountId.keySet()]) {
                // FIX 3 (Line 70): Changed 'Account__c' to 'Competitor_Account__c'
                Competitor__c comp = new Competitor__c(
                    Competitor_Account__c = quoteIdToAccountId.get(quote.Id), 
                    Opportunity__c = quote.OpportunityId,
                    Name = 'Comp ' + quote.Opportunity.Name
                );
                compList.add(comp);
            }

            if (!compList.isEmpty()) {
                Database.insert(compList, false);
            }
        }
    }
}