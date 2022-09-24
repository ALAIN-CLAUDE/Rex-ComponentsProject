@isTest
public class Twilio_API_Scheduled_Test {
 
    @isTest static void testGetCallout() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TwilioCalloutTest');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        HttpResponse result = Twilio_API_Scheduled.callout();
        // Verify mock response is not null
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        // Verify status code
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');

    }   
    
    @isTest static void parse() {
        List<String> numbers = Twilio_API_Scheduled.parseData('[{ "to" : "+16032756869"}, { "to": "+12222222222"}]');
        System.assertEquals(numbers.size(), 2);
    }
    
    @isTest static void add() {
        List<String> numbers = new List<String>();
        numbers.add('+16032756869');
        numbers.add('+12222222222');
       
        Lead newLead = new Lead();
        newLead.Phone = '+16032756869';
        newLead.SentText__c = 1;
        newLead.LastName = 'Test';
        
        Lead newLead2 = new Lead();
        newLead2.Phone = '+12222222222';
        newLead2.LastName = 'Test';
        
        insert newLead;
        insert newLead2;
        
        String done = Twilio_API_Scheduled.add(numbers);
		System.assertEquals('DONE', done);
    }
	
    /*
    @isTest static void schedule() {
        Test.startTest();
        Twilio_API_Scheduled m = new Twilio_API_Scheduled();
		String sch = '0 0 * * * ?';
		String jobID = system.schedule('Track text messages Twilio', sch, m);
        Test.stopTest();
    }
	*/
    
	   static testMethod void test() {
            
      	List<String> numbers = new List<String>();
        numbers.add('+16032756869');
        numbers.add('+12222222222');
        List<Lead> leadsMatchingNumbers = [SELECT id, SentText__c FROM Lead WHERE Phone in: numbers];
		System.debug(leadsMatchingNumbers);
          for (Lead lead: leadsMatchingNumbers) {
            if (lead.SentText__c != null) {
                lead.SentText__c = lead.SentText__c + 1;       
            } else {
                lead.SentText__c = 1;
                System.assertEquals(1, lead.SentText__c);
            }
        }
        update leadsMatchingNumbers;
           

        
       	List<Lead> leadsMatchingMobileNumbers = [SELECT id, SentText__c FROM Lead WHERE MobilePhone in: numbers];
		for (Lead lead: leadsMatchingMobileNumbers) {
            if (lead.SentText__c != null) {
                lead.SentText__c = lead.SentText__c + 1;                
            } else {
                lead.SentText__c = 1;
            }
        }
        update leadsMatchingMobileNumbers;
    }
}