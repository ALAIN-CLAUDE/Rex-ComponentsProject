global class BatchApexTestExample implements Database.Batchable<Sobject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id ,Full_Name__c, FirstName,lastName,ItADuplicateRecord__c,CreatedFirstNotDup__c from account ORDER BY createddate ASC');
    }
    global void execute(Database.BatchableContext bc,List<account> scope){
        Map<string,Account> FirstTimeNamesNotDup = new Map<string,Account>();
        for(Account acc : scope){
            if(FirstTimeNamesNotDup.containskey(acc.Full_Name__c) ){
     
        acc.ItADuplicateRecord__c= true;
         
    }else{
   
		FirstTimeNamesNotDup.put(acc.Full_Name__c,acc);
        acc.CreatedFirstNotDup__c = true;
    }
        }
        update scope;
    }
    public void finish(Database.BatchableContext bc){
         
    }
}