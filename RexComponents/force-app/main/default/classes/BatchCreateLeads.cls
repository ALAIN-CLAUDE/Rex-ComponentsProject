public class BatchCreateLeads implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query  = 'SELECT Id, Status, OwnerId FROM Lead';
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<lead> scope){
        
        lead [] ldList = new list<lead>(); 
        set<id> setLdId = new set<id>();
        
        for(lead ld : scope){
            setLdId.add(ld.id);
        }
       
        
        for(lead ld1 : [SELECT id from lead where id in : setLdId and Status ='Open' and OwnerId = '0054Q00000FPvBqQAL']){
    	ldList.add(ld1);
     
    
}
        delete ldList;
       
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    


}