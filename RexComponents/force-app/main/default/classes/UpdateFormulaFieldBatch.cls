public class UpdateFormulaFieldBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT PersonEmail, Website, PersonMailingCity, PersonMailingStreet, PersonMailingState, DomainAndPhone__c, DomainName__c, Organization__pc, Phone FROM ACCount Where RecordType.Name = 'Person Account' AND DomainAndPhone__c = null]);
    }
    
    public void execute(Database.BatchableContext BC, List<ACCount> accountRecord){
        List<Account> listAccount = new List<Account>();
        Set<String> setNonCoporateDomain = new Set<String>{'gmail' , 'yahoo', 'aol', 'office', 'icloud', 'mozilla', 'protonmail', 'proton.me','att.net', 'comcast.net', 'yandex.com'};
        for(Account acc : accountRecord){
            acc.DomainAndPhone__c = '';
            String accEmail = acc.PersonEmail != null ? acc.PersonEmail.split('@').get(1) : '';
            if(!String.isEmpty(accEmail) &&
               (!accEmail.containsIgnoreCase('gmail') && !accEmail.containsIgnoreCase('yahoo') && !accEmail.containsIgnoreCase('outlook') && !accEmail.containsIgnoreCase('hotmail') &&
                !accEmail.containsIgnoreCase('aol') && !accEmail.containsIgnoreCase('office') && !accEmail.containsIgnoreCase('icloud') && !accEmail.containsIgnoreCase('mozilla') &&
                !accEmail.containsIgnoreCase('protonmail') && !accEmail.containsIgnoreCase('proton.me') && !accEmail.containsIgnoreCase('att.net') && !accEmail.containsIgnoreCase('comcast.net') && !accEmail.containsIgnoreCase('yandex.com'))){
                    
                    acc.DomainName__c = accEmail.substringBefore('.');
                    acc.DomainAndPhone__c = accEmail.substringBefore('.');
                    System.debug('domain>>'+acc.DomainName__c);
                    
            }
            if(acc.Organization__pc != null){
                 acc.DomainName__c = acc.Organization__pc;
            }
            if(String.isEmpty(acc.DomainAndPhone__c) && acc.Website != null){
                acc.DomainAndPhone__c = acc.Website.substringBefore('.');
                acc.DomainName__c = acc.DomainAndPhone__c;
            }
            if(String.isEmpty(acc.DomainAndPhone__c) && acc.Website != null){
                acc.DomainAndPhone__c = acc.Website.substringBefore('.');
                acc.DomainName__c = acc.DomainAndPhone__c;
            }
            if(String.isEmpty(acc.DomainAndPhone__c) && acc.PersonMailingStreet != null && acc.PersonMailingCity != null){
                acc.DomainAndPhone__c += acc.PersonMailingStreet + ', ' + acc.PersonMailingCity;
            }
            if(String.isEmpty(acc.DomainAndPhone__c) && acc.Phone != null){
                acc.DomainAndPhone__c = acc.Phone;
            }
            listAccount.add(acc);
        }
        
        if(!listAccount.isEmpty()){
            update listAccount;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        CreateBusinessAccountBatch cba = new CreateBusinessAccountBatch('');
        Database.executeBatch(cba, 200);
    }
}