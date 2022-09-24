@isTest
public class Sendgrid_Webhook_Test {
    @isTest static void test() {
    }
    @isTest static void body() {
        String body = '[{"event": "delivered", "email": "willgu29@gmail.com", "category": ["Betsy", "Real Estate", "Mike", "Venture Capital", "Technology", "Unknown", "Miranda", "Madison", "Nikhail"]}]';
        Sendgrid_Webhook.parseBody(body);
    }
    
    @isTest static void insertStuff() {
        Lead newLead = new Lead();
        newLead.Email = 'willgu28@gmail.com';
        newLead.LastName = 'Test';
        newLead.Website = 'http://test.com';
        
        Lead newLead2 = new Lead();
        newLead2.Email = 'willgu29@gmail.com';
        newLead2.LastName = 'Tes3';
        newLead2.Website = 'http://test.com';

        
        Lead newLead3 = new Lead();
        newLead3.Email = 'test@example.com';
        newLead3.LastName = 'Tes2';
        newLead3.Sent__c = 1;
        newLead3.Website = 'http://test.com';
        
        insert newLead;
        insert newLead2;
        insert newLead3;
        
        List<String> emails = new List<String>();
        List<String> eventTypes = new List<String>();
       	List<String> industries = new List<String>();
        List<String> owners = new List<String>();
        emails.add('willgu28@gmail.com');
        emails.add('willgu29@gmail.com');
        emails.add('test@example.com');
        eventTypes.add('delivered');
        eventTypes.add('unsubscribe');
        eventTypes.add('delivered');
        industries.add('Real Estate');
        industries.add('Venture Capital');
        industries.add('Venture Capital');
        owners.add('0054Q00000FPyuo');
        owners.add('0054Q00000FPy1o');
        owners.add('0054Q00000FPy1o');
        Sendgrid_Webhook.updateLeads(emails, eventTypes, industries, owners);
    }
    
    @isTest static void testLeadOwner() {
        List<String> emails = new List<String>();
        emails.add('willgu29@gmail.com');
        List<Lead> leadsMatchingEmails = [SELECT id, Sent__c, OwnerId FROM Lead WHERE Email in: emails];
		for (Lead lead: leadsMatchingEmails) {
            System.debug(lead.OwnerId);
            lead.OwnerId = '0054Q00000FPy1o';
        }
        update leadsMatchingEmails;
    }
}