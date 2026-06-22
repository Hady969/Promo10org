public with sharing class Ressource_Reservation{
    
    public static void Check_If_ressource_available(List<Ressource_reservation__c> newRessources, Map<Id, Ressource_reservation__c> oldMap) {
        Map<String, Ressource_reservation__c> ressourceMap = new Map<String,Ressource_reservation__c>();   
        for ( Ressource_reservation__c Ressource : newRessources) {

            if (( oldMap == null || oldMap.get(Ressource.Id).Start_data_of_use__c != Ressource.Start_data_of_use__c || oldMap.get(Ressource.Id).End_data_of_use__c != Ressource.End_data_of_use__c || oldMap.get(Ressource.Id).Reserved_ressource__c != Ressource.Reserved_ressource__c) && Ressource.Start_data_of_use__c != null && Ressource.End_data_of_use__c  != null && Ressource.Reserved_ressource__c  != null){
               ressourceMap.put(Ressource.Reserved_ressource__c, Ressource);
        }
        }
    
        List <Ressource_reservation__c> queryRessources =  [SELECT Start_data_of_use__c , End_data_of_use__c , Reserved_ressource__c FROM Ressource_reservation__c WHERE Reserved_ressource__c IN: ressourceMap.keySet() ];

        for ( Ressource_reservation__c Ressource_to_insert : newRessources ){
         for (Ressource_reservation__c Ressource : queryRessources )
                {
                    if (Ressource_to_insert.Start_data_of_use__c <= Ressource.End_data_of_use__c && Ressource_to_insert.End_data_of_use__c >= Ressource.Start_data_of_use__c) {
                        Ressource_to_insert.addError('This ressource is already reserved for the selected dates.');
                    }
                    else if (Ressource.Start_data_of_use__c <= Ressource_to_insert.End_data_of_use__c && Ressource.End_data_of_use__c >= Ressource_to_insert.Start_data_of_use__c) {
                        Ressource_to_insert.addError('This ressource is already reserved for the selected dates.');
                    }
                    
                }
                }
    }
}