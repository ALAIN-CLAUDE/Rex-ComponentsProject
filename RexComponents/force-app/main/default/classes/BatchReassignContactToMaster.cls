global class BatchReassignContactToMaster implements Database.Batchable<Sobject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id, name,FirstName,lastName,ItADuplicateRecord__c,CreatedFirstNotDup__c from account ORDER BY createddate ASC');
    }
    global void execute(Database.BatchableContext bc,List<account> scope){
        
        map<id,account> dupMap = new map<id,account>();
        map<id,account> mastMap = new map<id,account>();
        
        
        for(account acc : scope){
            if(acc.ItADuplicateRecord__c == false){
                 mastMap.put(acc.ID,acc);
            }
            if(acc.ItADuplicateRecord__c == true){
                 dupMap.put(acc.ID,acc);
            }
           
        }
        
        
        task [] tskList = [select id,whatId,Account.name from task where accountId in:dupMap.keySet()];
        

        list<task> conUpdate = new list<task>();
        for(account acc : mastMap.values()){
            for(Task cc : tskList){
                if(cc.Account.name == acc.name){
                    cc.whatId = acc.id;
                    cc.New_Parent__c = acc.id;
                    cc.Old_Parent__c = cc.AccountId;
                    cc.processed__c = true;
                    cc.Old_Parent_Name__c = cc.Account.name;
                    conUpdate.add(cc);
                }
            }
        }
        
        map<id,task> upMapping = new map<id,task>();
        upMapping.putAll(conUpdate);
        update upMapping.values();
        
    }
    public void finish(Database.BatchableContext bc){
        
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