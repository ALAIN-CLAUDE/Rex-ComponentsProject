public class AccountAndContactFieldsBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query  = 'SELECT  AccountId, Id, Minimum_Investment__c,Type,Background__c,Investor_Tier__c,Accredited_Investor__c,Qualified_Purchaser__c,InvestRes_Investor__c,LinkedIn__c,Location__c FROM opportunity';
        System.debug('query>>'+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> oppList){
        System.debug('oppList>>'+oppList);
        Set<Id> setOppIds = (new Map<Id,SObject>(oppList)).keySet();
        System.debug('setOppIds>>'+setOppIds);
        Map<Id, Id> mapOppIdWithContactId = new Map<Id, Id> ();
        List<OpportunityContactRole> listOppContactRole = [SELECT ID, OpportunityID, ContactId,IsPrimary FROM OpportunityContactRole WHERE OpportunityID IN: setOppIds];
        for(OpportunityContactRole  oppContactRole: listOppContactRole){
            if(listOppContactRole.size()==1 || (listOppContactRole.size()>1 && oppContactRole.IsPrimary)){
                mapOppIdWithContactId.put(oppContactRole.OpportunityID, oppContactRole.ContactId);
            }
        }
        
        List<Account> listAcc = new List<Account> ();
        List<Contact> listCon = new List<Contact> ();
        Set<Id> accIds = new Set<Id> ();
        for(Opportunity opp : oppList){
            if(!accIds.contains(opp.AccountId)){
                Account acc = new Account(Id = opp.AccountId);
                acc.Minimum_Investment__c = opp.Minimum_Investment__c;
                acc.Type = opp.Type;
                acc.Investor_Tier__c = opp.Investor_Tier__c;
                acc.Background__c = opp.Background__c;
                acc.Accredited_Investor__c = opp.Accredited_Investor__c;
                acc.Qualified_Purchaser__c = opp.Qualified_Purchaser__c;
                acc.InvestRes_Investor__c = opp.InvestRes_Investor__c;
                listAcc.add(acc);
                accIds.add(opp.AccountId);   
            }
            
            
            if(mapOppIdWithContactId.containsKey(opp.Id)){
                Contact con = new Contact( Id = mapOppIdWithContactId.get(opp.Id));
                con.LinkedIn__c = opp.LinkedIn__c;
                con.Location__c = opp.Location__c;
                listCon.add(con);
            }
        }
        
        
        System.debug('listAcc>>'+listAcc);
        if(!listAcc.isEmpty()){
            update listAcc;
        }
        
        
        System.debug('listCon>>'+listCon);
        if(!listCon.isEmpty()){
            update listCon;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    
}