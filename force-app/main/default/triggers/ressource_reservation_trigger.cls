trigger ressource_reservation_trigger on Ressource_Reservation__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    new ressource_reservation_trigger_handler().run();
}