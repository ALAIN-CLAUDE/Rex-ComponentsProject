public class FindDuplicatesAccounts implements Database.Batchable<Sobject> {
    
   public  Database.QueryLocator start(Database.BatchableContext ctx) {                  
    return Database.getQuerylocator([select id ,Full_Name__c, FirstName,lastName,ItADuplicateRecord__c,CreatedFirstNotDup__c from account ORDER BY createddate ASC]); 
}

public void execute(Database.BatchableContext BC, List<Account> scope ) {
    
List<String> myAccountNames = new List<String>();
    for(Account acct :scope ){
    myAccountNames.add(acct.Full_Name__c);
}


 account [] updateAccList = new list<account>();
Map<string,Account> FirstTimeNamesNotDup = new Map<string,Account>();



for(Account acc :[SELECT Id,Full_Name__c FROM Account WHERE Full_Name__c IN :myAccountNames]){
 
    if(FirstTimeNamesNotDup.containskey(acc.Full_Name__c) ){
     
        acc.ItADuplicateRecord__c= true;
           updateAccList.add(acc);
    }else{
   
		FirstTimeNamesNotDup.put(acc.Full_Name__c,acc);
        acc.CreatedFirstNotDup__c = true;
        updateAccList.add(acc);
    }
}

  update updateAccList;





}

public void finish(Database.BatchableContext BC) {
    
    

}



}