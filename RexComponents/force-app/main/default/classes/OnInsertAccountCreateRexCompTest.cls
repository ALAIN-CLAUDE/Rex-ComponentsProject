@IsTest
public class OnInsertAccountCreateRexCompTest {
    @IsTest
    private static void CapOpsAccount() {
        Profile prof= [Select Id from profile where Name='CapOps Admin']; 
        
        User user = new User();
        user.LastName = 'CapOpslast';
        user.Email = 'puser000@CapOps.com';
        user.Username = 'puser000@CapOps.com';
        user.CompanyName = 'CapOpsTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'CapOpsTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
        @IsTest
    private static void JobCallAccount() {
        Profile prof= [Select Id from profile where Name='JobCall']; 
        
        User user = new User();
        user.LastName = 'JobCallslast';
        user.Email = 'puser000@JobCalls.com';
        user.Username = 'puser000@JobCall.com';
        user.CompanyName = 'JobCallTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'JobCallTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
        @IsTest
    private static void InsureProAccount() {
        Profile prof= [Select Id from profile where Name='InsurePro']; 
        
        User user = new User();
        user.LastName = 'InsureProlast';
        user.Email = 'puser000@InsurePro.com';
        user.Username = 'puser000@InsurePro.com';
        user.CompanyName = 'InsureProTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'InsureProTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
        
        @IsTest
    private static void GetDoneAccount() {
        Profile prof= [Select Id from profile where Name='GetDone']; 
        
        User user = new User();
        user.LastName = 'GetDonelast';
        user.Email = 'puser000@GetDone.com';
        user.Username = 'puser000@GetDone.com';
        user.CompanyName = 'GetDoneTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'GetDoneTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
        
        @IsTest
    private static void IDcoreAccount() {
        Profile prof= [Select Id from profile where Name='IDcore']; 
        
        User user = new User();
        user.LastName = 'IDcorelast';
        user.Email = 'puser000@IDcore.com';
        user.Username = 'puser000@IDcore.com';
        user.CompanyName = 'IDcoreTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'IDcoreTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
        
        @IsTest
    private static void OwnPropAccount() {
        Profile prof= [Select Id from profile where Name='OwnProp']; 
        
        User user = new User();
        user.LastName = 'OwnProplast';
        user.Email = 'puser000@OwnProp.com';
        user.Username = 'puser000@OwnProp.com';
        user.CompanyName = 'OwnPropTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'OwnPropTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
        
        @IsTest
    private static void PayUpAccount() {
        Profile prof= [Select Id from profile where Name='PayUp']; 
        
        User user = new User();
        user.LastName = 'PayUplast';
        user.Email = 'puser000@PayUp.com';
        user.Username = 'puser000@PayUp.com';
        user.CompanyName = 'PayUpTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'PayUpTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
        
        @IsTest
    private static void PrimeProAccount() {
        Profile prof= [Select Id from profile where Name='PrimePro']; 
        
        User user = new User();
        user.LastName = 'PrimeProlast';
        user.Email = 'puser000@PrimePro.com';
        user.Username = 'puser000@PrimePro.com';
        user.CompanyName = 'PrimeProTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'PrimeProTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
        
        @IsTest
    private static void PropDataAccount() {
        Profile prof= [Select Id from profile where Name='PropData']; 
        
        User user = new User();
        user.LastName = 'PropDatalast';
        user.Email = 'puser000@PropData.com';
        user.Username = 'puser000@PropData.com';
        user.CompanyName = 'PropDataTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'PropDataTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
            @IsTest
    private static void ShopSupplyAccount() {
        Profile prof= [Select Id from profile where Name='ShopSupply']; 
        
        User user = new User();
        user.LastName = 'ShopSupplylast';
        user.Email = 'puser000@ShopSupply.com';
        user.Username = 'puser000@ShopSupply.com';
        user.CompanyName = 'ShopSupplyTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'ShopSupplyTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
            @IsTest
    private static void SmartPropAccount() {
        Profile prof= [Select Id from profile where Name='SmartFuse'];
        
        User user = new User();
        user.LastName = 'SmartProplast';
        user.Email = 'puser000@SmartProp.com';
        user.Username = 'puser000@SmartProp.com';
        user.CompanyName = 'SmartPropTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;
        
        insert user;
        system.runAs(user){
            Account account = new Account(
                Name = 'SmartPropTest'
            );
            
            
            Test.startTest();
            insert account;
            Test.stopTest();
        }  
        
    }
    
    
}