public with sharing class CompetitorTriggerHandler extends TriggerHandler implements ITriggerHandler {

    private Map<Id, Competitor__c> newMap;
    private Map<Id, Competitor__c> oldMap;
    private List<Competitor__c> TriggerNew;
    private List<Competitor__c> TriggerOld;
    
    public CompetitorTriggerHandler(){
        this.newMap = (Map<Id, Competitor__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Competitor__c>) Trigger.oldMap;
        this.TriggerNew = (List<Competitor__c>) Trigger.New;
        this.TriggerOld = (List<Competitor__c>) Trigger.Old;
    }
    
    public static Boolean TriggerDisabled = false;
    
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        // Changed to 'Exercice3' to match your class name exactly
        Exercice3.handleBeforeInsert(TriggerNew);
    }
    
    public override void afterInsert() {
        // Changed to 'Exercice3' to match your class name exactly
        Exercice3.handleAfterInsert(TriggerNew);
    }
    
    public override void beforeUpdate() {}
    public override void afterUpdate() {}
    public override void beforeDelete() {}
    public override void afterDelete() {}
    public override void afterUnDelete() {}
}