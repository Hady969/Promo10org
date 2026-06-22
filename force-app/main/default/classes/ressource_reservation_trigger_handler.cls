public with sharing class ressource_reservation_trigger_handler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Ressource_reservation__c> newMap;
    private Map<Id, Ressource_reservation__c> oldMap;
    private List<Ressource_reservation__c> TriggerNew;
    private List<Ressource_reservation__c> TriggerOld;
    
    public ressource_reservation_trigger_handler(){
        this.newMap = (Map<Id, Ressource_reservation__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Ressource_reservation__c>) Trigger.oldMap;
        this.TriggerNew= (List<Ressource_reservation__c>) Trigger.New;
        this.TriggerOld= (List<Ressource_reservation__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        Ressource_Reservation.Check_If_ressource_available(TriggerNew, oldMap);
    }
    public override void afterInsert() {
      
    }
    public  override void beforeUpdate() {
        Ressource_Reservation.Check_If_ressource_available(TriggerNew, oldMap);
    }
    public override void afterUpdate() {
     
    }
    
    public override void beforeDelete() {
        
    }
    
    public override void afterDelete() {
        
    }
    
    public override void afterUnDelete() {
        
    }
}