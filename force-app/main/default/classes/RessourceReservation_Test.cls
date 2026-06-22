@isTest
public class RessourceReservation_Test {

    @testSetup
    static void setupData() {
        Datetime startDate = Datetime.newInstance(2008, 2, 5, 8, 30, 12);
        Datetime endDate = Datetime.newInstance(2028, 2, 5, 8, 30, 12);
        Ressource_reservation__c res = new Ressource_reservation__c(Name='Test', Start_data_of_use__c= startDate,End_data_of_use__c= endDate,Reserved_ressource__c= 'Room 1');
        insert res;
    }

    @isTest
    public static void verifyReservation(){
        
        Ressource_reservation__c res = [SELECT Id, Reserved_ressource__c, Start_data_of_use__c, End_data_of_use__c FROM Ressource_reservation__c LIMIT 1];
        
        Test.startTest();
        
        Datetime startDate = Datetime.newInstance(2008, 2, 5, 8, 30, 12);
        Datetime endDate = Datetime.newInstance(2028, 2, 5, 8, 30, 12);
        
        Ressource_reservation__c res1 = new Ressource_reservation__c(Name='Test2', Start_data_of_use__c= startDate,End_data_of_use__c= endDate,Reserved_ressource__c= 'Room 2');
        insert res1;

        Ressource_reservation__c res2 = new Ressource_reservation__c(Name='Test2', Start_data_of_use__c= startDate,End_data_of_use__c= endDate,Reserved_ressource__c= 'Room 1');
        
        res1.Reserved_ressource__c ='Room 1';
        
        Test.stopTest();

    }
}