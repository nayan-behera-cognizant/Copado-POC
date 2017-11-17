public without sharing class CaseAssociationHelper {

    public static void guestDAZNUserBehaviour(List<Case> beaforeInsertCases) {
        List<Case> casesForInsert = new List<Case>();
        Map<String, Case> caseMap = new Map<String, Case>();
        Map<String, Account> accountDAZNMap = new Map<String, Account>();
        if (beaforeInsertCases != null && beaforeInsertCases.size() > 0) {
            for (Case newCase : beaforeInsertCases) {
                if (String.isNotBlank(newCase.Provider_Type__c)) {
                    if (newCase.Provider_Type__c == 'DAZN') {
                        if (newCase.Contact_us_email__c != null) {
                            caseMap.put(newCase.Contact_us_email__c, newCase);
                        }
                    }
                }
            }  
        }
        Partner_Account_Configuration__c pac = Partner_Account_Configuration__c.getInstance('Docomo');

        if (pac != null) {
            String docomoUserType = pac.Partner_Type__c;
            if (String.isNotBlank(docomoUserType)) {
                List<Account> accountList= [
                    SELECT Id, PersonContactId, PersonEmail, Type, Partner_ID__c, Notification_Language_Code__c, Notification_Country_Code__c
                    FROM Account 
                    WHERE PersonEmail IN :caseMap.keySet() LIMIT :(Limits.getLimitQUeryRows() - Limits.getQueryRows())
                ];
                if (accountList!= null && accountList.size() > 0) {
                    Set<String> accountDAZNDuplicateSet = new Set<String>();
                    for (Account acc : accountList) {
                        if (!(String.isNotBlank(acc.Type) && acc.Type.equals(docomoUserType) && String.isNotBlank(acc.Partner_ID__c))) {
                            if (accountDAZNMap.containsKey(acc.PersonEmail)) {
                                if (!accountDAZNDuplicateSet.contains(acc.PersonEmail)) {
                                    accountDAZNDuplicateSet.add(acc.PersonEmail);
                                }
                            }
                            else {
                                accountDAZNMap.put(acc.PersonEmail, acc);
                            }
                        }
                    }
                    
                    for (Case caseobj :caseMap.values()) {
                        Account acc = null;
                        if (caseobj.Provider_Type__c == 'DAZN') {
                            if (accountDAZNMap.containsKey(caseobj.Contact_us_email__c) && !accountDAZNDuplicateSet.contains(caseobj.Contact_us_email__c)) {
                                acc = accountDAZNMap.get(caseobj.Contact_us_email__c);
                            }
                        }

                        if (acc != null) {
                            caseobj.accountId = acc.id;
                            caseObj.ContactId = acc.PersonContactId;
                            caseobj.Notification_Country_Code__c = acc.Notification_Country_Code__c;
                            caseobj.Notification_Language_Code__c = acc.Notification_Language_Code__c;
                            casesForInsert.add(caseobj);
                        }
                    }
                }
            }
        }
        if (!casesForInsert.isEmpty()) {
            insert casesForInsert;
        } else {
        	insert beaforeInsertCases;
        }
    }

}