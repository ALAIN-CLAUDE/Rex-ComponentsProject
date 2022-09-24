public class BatchUpdateNoName implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query  = 'select id,Name,No_name__c, Id__c FROM Account_field_map__c';
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account_field_map__c> scope){
        
        list<Account_field_map__c > dell = new list<Account_field_map__c >();
        set<id> setAccId = new set<id>();
        
        for(Account_field_map__c afm : scope){
            setAccId.add(afm.id);
            
        }
        
        
        
        for(Account_field_map__c acc : [select id,No_name__c,Name, Id__c FROM Account_field_map__c where id in : setAccId ]){
            if(string.valueOf(acc.id).contains(acc.Name)){
                system.debug('acc name ==> '+acc.Name + 'acc id ==> '+acc.id);
                acc.No_name__c = true;
                dell.add(acc);
            }
            
        }
        
        map<id,Account_field_map__c> mapAcc = new map<id,Account_field_map__c>();
        mapAcc.putAll(dell);
        
        if(!mapAcc.isEmpty()){
            update mapAcc.values();
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