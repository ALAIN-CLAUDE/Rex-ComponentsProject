public class CreateBusinessAccountBatch implements Database.Batchable<sObject>{
    
    public final String batchType;
    public Integer counter = 1;
    public CreateBusinessAccountBatch(String bt ){
        batchType= bt; 
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query ='';
        String businessAcc = 'Business Account';
        String personAcc = 'Person Account';
        if(batchType == 'Merge'){
            query = 'SELECT  PersonEmail,Website,PersonMailingCity,PersonMailingStreet,PersonMailingState,DomainAndPhone__c,DomainName__c, Phone, Organization__pc FROM Account Where RecordType.Name =: businessAcc AND DomainAndPhone__c != null Order BY DomainAndPhone__c';
        }else if(batchType == 'UpdateName'){
            query = 'SELECT  PersonEmail,Organization__pc,Website,PersonMailingCity,PersonMailingStreet,PersonMailingState,DomainAndPhone__c,DomainName__c, Phone FROM Account Where RecordType.Name =: businessAcc AND DomainName__c != null Order BY DomainAndPhone__c';
        }else{
            query= 'SELECT  PersonEmail,Website,PersonMailingCity,PersonMailingStreet,PersonMailingState,DomainAndPhone__c,DomainName__c, Phone, Organization__pc FROM Account Where RecordType.Name =: personAcc Order BY DomainName__c';
        }
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<ACCount> accountRecord){
        try{
            if(batchType == 'UpdateName'){
                System.debug('accountRecord>>'+accountRecord);
                List<Account> listAcc = new List<Account>();
                 for(Account acc :  accountRecord){
                     if(acc.DomainName__c != null || acc.Organization__pc != null){
                         acc.Name = acc.Organization__pc != null ?  acc.Organization__pc : acc.DomainName__c;
                     }
                     listAcc.add(acc);
                 }
                 
                update listAcc;
            }
            else if(batchType == 'Merge'){
                Map<String, List<Account>> mapDomainAndAccount = new Map<String, List<Account>>();
               
                System.debug('accountRecord>>'+accountRecord);
                
                for(Account acc :  accountRecord){
                    if(!mapDomainAndAccount.containsKey(acc.DomainAndPhone__c)){
                        mapDomainAndAccount.put(acc.DomainAndPhone__c, new List<Account>());
                    }
                    mapDomainAndAccount.get(acc.DomainAndPhone__c).add(acc);
                }
                
                System.debug('mapDomainAndAccount>>'+mapDomainAndAccount);
                for(String key : mapDomainAndAccount.keySet()){ 
                    List<Account> lstAccountsFoundDuplicate = mapDomainAndAccount.get(key); 
                    if(lstAccountsFoundDuplicate.size() > 1 ) {
                        Account masterAcc = lstAccountsFoundDuplicate[0];
                        for(Account acc : lstAccountsFoundDuplicate){
                            if(acc.Organization__pc != null) {
                                masterAcc = acc;
                                break;
                            }
                        }
                        List<Account> listDuplicateAccount = new List<Account>(); 
                        for(Integer i = 0; i < lstAccountsFoundDuplicate.size(); i++){
                            if(masterAcc.Id == lstAccountsFoundDuplicate[i].Id){
                                continue;
                            }
                            if(masterAcc.Organization__pc != NULL){
                            	lstAccountsFoundDuplicate[i].Organization__pc = masterAcc.Organization__pc;  
                            }
                            if(listDuplicateAccount.size() == 2){
                                Database.MergeResult[] results = Database.merge(masterAcc, listDuplicateAccount);
                                listDuplicateAccount = new List<Account>();
                            }
                            else{
                                listDuplicateAccount.add(lstAccountsFoundDuplicate[i]);
                            }
                        }
                        if(listDuplicateAccount.size() > 0){
                            Database.MergeResult[] results =Database.merge(masterAcc, listDuplicateAccount);
                        }
                    }
                }
                
            }else{   
                Map<String, List<Account>> mapDuplicateAccount = new Map<String, List<Account>>();
                Set<Id> setAccountId = new Set<Id>();
                
                Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
                System.debug('devRecordTypeId>>'+devRecordTypeId);
                System.debug('accountRecord>>'+accountRecord);
                for(Account acc :  accountRecord){
                    if(acc.DomainAndPhone__c != null){
                        if(!mapDuplicateAccount.containsKey(acc.DomainAndPhone__c)){
                            mapDuplicateAccount.put(acc.DomainAndPhone__c, new List<Account>());
                        }
                        mapDuplicateAccount.get(acc.DomainAndPhone__c).add(acc);
                        setAccountId.add(acc.Id);
                    }
                }
                
                System.debug('mapDuplicateAccount>>'+mapDuplicateAccount);
                
                List<Account> listBusinessAcc = new List<Account>(); 
                
                for(String key : mapDuplicateAccount.keySet()){
                    if(mapDuplicateAccount.get(key).size()>1){
                        System.debug('key>>'+key);
                        for(Account acc : mapDuplicateAccount.get(key)){
                            System.debug('acc>>'+acc);
                            
                            Account bAcc = new Account(Id= acc.ID);
                            bAcc.RecordTypeId =  devRecordTypeId ; 
                            
                            listBusinessAcc.add(bAcc);
                        }
                    }
                }
                
                System.debug('listBusinessAcc>>'+listBusinessAcc);
                if(!listBusinessAcc.isEmpty()){
                    update listBusinessAcc;
                }
            }
            
        }catch(Exception e){
            System.debug('Exception>>>'+e.getMessage()+e.getLineNumber());
        }
    }
    
    public void finish(Database.BatchableContext BC){
        if(batchType == ''){
            CreateBusinessAccountBatch cba = new CreateBusinessAccountBatch('UpdateName');
            Database.executeBatch(cba, 200);
        }     
        else if(batchType == 'UpdateName'){
            CreateBusinessAccountBatch cba = new CreateBusinessAccountBatch('Merge');
            cba.counter = 1;
            Database.executeBatch(cba, 200);
        }
        else if(batchType == 'Merge' && this.counter < 3 ){
            CreateBusinessAccountBatch cba = new CreateBusinessAccountBatch('Merge');
            cba.counter = ++this.counter;
            //Database.executeBatch(cba, 200);
        }
    }

}