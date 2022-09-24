public class OnInsertAccountCreateRexCompany {
    public static void onInsert(map<id,account> newAcc){
        list<account> accList = new list<account>();
        map<string,user> profileMap = new map<string,user>();
        for(user u : [SELECT Id,name,Profile.Name FROM User WHERE Profile.Name IN ('CapOps Admin','JobCall','InsurePro','GetDone','IDcore','OwnProp','PayUp','PrimePro','PropData','ShopSupply','SmartProp') and id =:UserInfo.getUserID()]){
            profileMap.put(u.Profile.Name,u);
        }
        
        for(account acc : [select id ,Rex_Companies__c from account where ownerId =: UserInfo.getUserID() and id in : newAcc.keyset()]){
            for(user u : profileMap.values()){
                
                if(u.Profile.Name == 'CapOps Admin'){
                    acc.Rex_Companies__c = 'CapOps';
                    accList.add(acc);
                }
                
                if(u.Profile.Name == 'JobCall'){
                    acc.Rex_Companies__c = 'JobCall';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'InsurePro'){
                    acc.Rex_Companies__c = 'InsurePro';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'GetDone'){
                    acc.Rex_Companies__c = 'GetDone';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'IDcore'){
                    acc.Rex_Companies__c = 'IDcore';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'OwnProp'){
                    acc.Rex_Companies__c = 'OwnProp';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'PayUp'){
                    acc.Rex_Companies__c = 'PayUp';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'PrimePro'){
                    acc.Rex_Companies__c = 'PrimePro';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'PropData'){
                    acc.Rex_Companies__c = 'PropData';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'ShopSupply'){
                    acc.Rex_Companies__c = 'ShopSupply';
                    accList.add(acc);
                }
                if(u.Profile.Name == 'SmartProp'){
                    acc.Rex_Companies__c = 'SmartProp';
                    accList.add(acc);
                }
                
            }
        }
        
        if(!accList.isEmpty()){
            update accList;
        }
        
    }
    
}