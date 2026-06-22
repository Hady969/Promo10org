trigger CompetitorTrigger on Competitor__c (before insert, after insert) {
    CompetitorTriggerHandler handler = new CompetitorTriggerHandler();
    
    if (handler.isDisabled()) return;
    
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert();
    } else if (Trigger.isAfter && Trigger.isInsert) {
        handler.afterInsert();
    }
}