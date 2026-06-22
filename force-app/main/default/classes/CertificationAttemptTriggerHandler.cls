public without sharing class CertificationAttemptTriggerHandler {

    public static void createCertificationHeld(List<Certification_Attempt__c> certAttempts, Map<Id, Certification_Attempt__c> oldMap) {

        /**
         * If a Contact successfully passes a Certification Attempt, then the code
         * will gather the data necessary to perform a query for related Certification
         * Attempt records.
         */

        System.Debug('Calling the createCertificationHeld method');

        // The set of candidates and certifications. Used to filter SOQL query when looking
        // at existing cert attempt records
        Set<Id> candidates = new Set<Id>();
        Set<Id> certifications = new Set<Id>();

        /** TODO #1: Declare a variable of type map that uses the type String for the key
         *           and the type Integer for the value, named passCounts and initialize it to
         *           a newly constructed map.
         */

		Map <String , Integer> passCounts = new Map <String , Integer>();
        
        // Extract candidates and certifications from incoming records that have the status 'Complete/Pass'
         for(Certification_Attempt__c attempt : certAttempts){
            if (attempt.Status__c== 'Complete/Pass' && (oldMap==null || oldMap.get(attempt.Id).Status__c!='Complete/Pass')) {
                candidates.add(attempt.Certification_Candidate__c);
                certifications.add(attempt.Certification_Id__c);
            }
        }

        for (List<Certification_Attempt__c> cAs : [SELECT Id, Certification_Id__c, Certification_Candidate__c, Number_of_Elements_for_Cert__c
                                                   FROM Certification_Attempt__c
                                                   WHERE Certification_Candidate__c IN :candidates
                                                   AND Status__c = 'Complete/Pass' AND Certification_element__r.Certification__c IN :certifications]) {
            for (Certification_Attempt__c cA : cAs) {
                System.debug('Retrieved certAttempt id: ' + cA.id +
                             ' candidate id: ' + cA.Certification_Candidate__c +
                             ' certification id: ' + cA.Certification_Id__c);
                /** TODO #2: Create an if statement that contains the following logic:
                 *         - If passCounts contains a key that is equal to the candidate id + certification id
                 *            - Retrieve the current value for that key from the map.
                 *            - Add 1 to that value
                 *            - Put the newly calculated value back in the map using the same key
                 *          - Otherwise
                 *            - create a new map entry whose key is equal to the candidate id + certification id
                 *              and whose value is 1.
                 */
                if (passCounts.containsKey('cA.Certification_Candidate__c' + 'Certification_Id__c' )){
                    Integer key_value = passCounts.get('cA.Certification_Candidate__c' + 'Certification_Id__c') +1;
                    passCounts.put('cA.Certification_Candidate__c' + 'Certification_Id__c',key_value);
                }
                else {
                    passCounts.put(('cA.Certification_Candidate__c' + 'Certification_Id__c') , 1);
                }
            }
        }
        /** TODO #3: Call the debug method of the System class and pass in a parameter that is
         *           the concatenation of:
         *           -- The string literal 'Size of passCounts = '
         *           -- results returned by calling the size method for the passCounts variable
         */
		System.debug ('Size of passCounts = ' + passCounts.size());

    }



    public static void validateCertificationAttempt(List<Certification_Attempt__c> triggerNew) {

        /**
         *  If a Contact is trying to create a Certification Attempt
         *  for an element that was already marked as "Complete/Pass"
         *  or "In Progress", then do not allow the attempt to be
         *  created and pass back an error
         */

        System.debug('Starting the Validate Certification Attempt logic');

        // All Certification_Attempt__c records which are 'In Progress' OR 'Complete/Pass' will be stored here for comparison purposes
        Set<String> concatStudentElement = new Set<String>();
                Set<ID> candidateIDs = new Set<ID>();
        for (Certification_Attempt__c dbca : triggerNew) {
            candidateIDs.add(dbca.Certification_Candidate__c);
        }
        for (Certification_Attempt__c dbca : [SELECT Certification_Candidate__c, Certification_Element__c, Status__c
                                               FROM Certification_Attempt__c
                                              WHERE Status__c IN ('In Progress', 'Complete/Pass')
                                                AND Certification_Candidate__c IN :candidateIDs]) {
            // We need to know 1. Which student 2. Which element they have attempted (lab or multiple choice) 3. The status
            concatStudentElement.add((String)dbca.Certification_Candidate__c + (String)dbca.Certification_Element__c + (String)dbca.Status__c);
        }

        for (Certification_Attempt__c ca : triggerNew) {
            // If any element is In Progress or Complete/Pass, new attempts should not be allowed for those elements
            if (concatStudentElement.contains((String)ca.Certification_Candidate__c + (String)ca.Certification_Element__c + 'In Progress') ||
                concatStudentElement.contains((String)ca.Certification_Candidate__c + (String)ca.Certification_Element__c + 'Complete/Pass')) {
                   ca.addError('Cannot attempt cert for element already in progress or completed');
            }
        }
    }
}