public class UndoBatchJob implements Database.Batchable<Sobject> {
	    
   public  Database.QueryLocator start(Database.BatchableContext ctx) {                  
    return Database.getQuerylocator([select id ,ItADuplicateRecord__c,CreatedFirstNotDup__c from account ORDER BY createddate ASC]); 
}

public void execute(Database.BatchableContext BC, List<Account> accounts ) {



for(Account acc :accounts){

        acc.ItADuplicateRecord__c= false;
	
        acc.CreatedFirstNotDup__c = false;
    
    }


  update accounts;




}

public void finish(Database.BatchableContext BC) {
    
    

}



}