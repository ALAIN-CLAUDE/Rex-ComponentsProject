public class BatchMapNewName implements Database.Batchable<sObject> {
		   public Database.QueryLocator start(Database.BatchableContext BC){
        String query  = 'select id,new_name_2__c ,No_name__c,New_Name__c,LastName__c,firstName__c FROM Account_field_map__c where firstName__c != null and LastName__c !=null';
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account_field_map__c> scope){
        
        list<Account_field_map__c > dell = new list<Account_field_map__c >();
        set<id> setAccId = new set<id>();
        
        for(Account_field_map__c afm : scope){
            setAccId.add(afm.id);
            
        }
        
        
     
	list<Account_field_map__c> accup = new list<Account_field_map__c>();        
          for(Account_field_map__c acc : [select id,new_name_2__c ,No_name__c,New_Name__c,LastName__c,firstName__c FROM Account_field_map__c where firstName__c != null and LastName__c !=null and id in: setAccId ]){
            if(acc.firstNAME__c != null & acc.LastName__c !=null){
              
                acc.new_name_2__c =acc.firstNAME__c+' '+acc.LastName__c;
                system.debug('name==> '+ acc.new_name_2__c);
                accup.add(acc);
            }
            
        }
        
         map<id,Account_field_map__c> accMap = new map<id,Account_field_map__c>();
        accMap.putAll(accup);
        if(!accMap.isEmpty()){
          update accMap.values();  
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