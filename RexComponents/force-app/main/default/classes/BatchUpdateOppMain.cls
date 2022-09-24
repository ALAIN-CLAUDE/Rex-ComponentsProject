public class BatchUpdateOppMain implements Database.Batchable<sObject>{
		 
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query  = 'SELECT Id, Name__c, Track_AccountId__c,Track_Account_Name__c, AccountId__c FROM Opportunity_main_upload__c';
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity_main_upload__c> scope){
        
        Opportunity_main_upload__c [] opcList = new list<Opportunity_main_upload__c>(); 
        map<id,Opportunity_main_upload__c> mapOpp = new map<id,Opportunity_main_upload__c>();
        set<id> setAccId = new set<id>();
        
        for(Opportunity_main_upload__c opp : scope){
            setAccId.add(opp.AccountId__c);
            mapOpp.put(opp.Id,opp);
        }
       
        
        for(Account_field_map__c acc : [SELECT  Name, Id__c FROM Account_field_map__c where Id__c in :setAccId and No_name__c != true]){
            for(Opportunity_main_upload__c ops :mapOpp.values()){
                if(ops.AccountId__c == acc.Id__c){
                    ops.Track_Account_Name__c= acc.Name;
                    ops.Track_AccountId__c = acc.Id__c;
                    opcList.add(ops);
                }
            }
     
    
}
        map<id,Opportunity_main_upload__c>  mapoo = new map<id,Opportunity_main_upload__c>();
        mapoo.putAll(opcList);
        if(!mapoo.isEmpty()){
             update mapoo.values();
        }
       
       
        
    }
    
    public void finish(Database.BatchableContext BC){
                
        string m= 'vvvvvvv';
        string m1= 'vvvvvvv';
        string m2= 'vvvvvvv';
        string m3= 'vvvvvvv';
        string m4= 'vvvvvvv';
        string m5= 'vvvvvvv';
        string m6= 'vvvvvvv';
        string m11= 'vvvvvvv';
        string m21= 'vvvvvvv';
        string m31= 'vvvvvvv';
        string m41= 'vvvvvvv';
        string m51= 'vvvvvvv';
        string m61= 'vvvvvvv';
        string m26= 'vvvvvvv';
        string m121= 'vvvvvvv';
        string m221= 'vvvvvvv';
        string m321= 'vvvvvvv';
        string m421= 'vvvvvvv';
        string m521= 'vvvvvvv';
        string m621= 'vvvvvvv';
    }
    


}