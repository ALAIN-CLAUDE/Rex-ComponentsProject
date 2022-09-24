/**
 * Created by EvgeniyMalahovskiy on 7/28/2022.
 */

@IsTest
private class UserServiceTest {
    @IsTest
    private static void addUserToPublicGroupTest() {
        Trigger_Settings__c userTrigger = new Trigger_Settings__c(
                Name = 'UserTrigger',
                Is_Active__c = true
        );
        insert userTrigger;
        Group groupItem = new Group(
            Name = 'OwnProp Group'
        );

        insert groupItem;

        Profile prof= [Select Id from profile where Name='OwnProp'];
        Profile profForUpdate= [Select Id from profile where Name='JobCall'];

        User user = new User();
        user.LastName = 'OwnProp';
        user.Email = 'puser000@SmartProp.com';
        user.Username = 'puser000@SmartProp.com';
        user.CompanyName = 'OwnPropTEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.ProfileId= prof.id;

        Integer previousGroupMemberSize = [SELECT ID FROM GroupMember].size();
        Test.startTest();
        insert user;
        Test.stopTest();

        System.assert([SELECT ID FROM GroupMember].size() > previousGroupMemberSize);
    }
}