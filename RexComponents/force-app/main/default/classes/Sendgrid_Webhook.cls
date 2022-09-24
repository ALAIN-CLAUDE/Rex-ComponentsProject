@RestResource(urlMapping='/Webhook/*')
global class Sendgrid_Webhook {
    
    @HttpGet
    global static String doGet() {
        return 'Test';
    }
    
	@HttpPost
	global static String doPost() {
        RestRequest req = RestContext.request;
    	Blob body = req.requestBody;
    	String requestString = body.toString();
		System.debug(requestString);
        parseBody(requestString);
        return 'DONE';
	}
    
    global static void parseBody(String requestString) {
        JSONParser parser = JSON.createParser(requestString);
    	List<String> emails = new List<String>();
        List<String> eventTypes = new List<String>();
       	List<String> industries = new List<String>();
        List<String> owners = new List<String>();
        while (parser.nextToken() != null) {
            if (parser.getText() == 'email') {
                parser.nextToken();
                String email = parser.getText();
                emails.add(email);
            }
            if (parser.getText() == 'event') {
                parser.nextToken();
                String eventType = parser.getText();
                eventTypes.add(eventType);
            }
            if (parser.getText() == 'category') {
                while (parser.nextToken() != JSONTOKEN.END_ARRAY) {
                    if (parser.getText() == 'Betsy') {
                        owners.add('0054Q00000FALmC');
                    } else if (parser.getText() == 'Mike') {
                        owners.add('0054Q00000FPy28');
                    } else if (parser.getText() == 'Nikhail') {
                        owners.add('0054Q00000FALmH');
                    } else if (parser.getText() == 'Zach') {
                        owners.add('0054Q00000FPyuo');
                    } else if (parser.getText() == 'Madison') {
                        owners.add('0054Q00000FPy1o');
                    } else if (parser.getText() == 'Miranda') {
                        owners.add('0054Q00000FQ3NQ');
                    } else if (parser.getText() == 'Venture Capital') {
                        industries.add('Venture Capital');
                    } else if (parser.getText() == 'Real Estate') {
                        industries.add('Real Estate');
                    } else if (parser.getText() == 'Technology') {
                        industries.add('Technology');
                    } else if (parser.getText() == 'Unknown') {
                        industries.add('Unknown');
                    }
                }
            }
        }

        System.debug(emails);
		System.debug(eventTypes);
		System.debug(industries);
		System.debug(owners);
        //If any email / event doesn't have 2 categories the lists will be misaligned
        updateLeads(emails, eventTypes, industries, owners);
    }
    
    global static void updateLeads(List<String> emails, List<String> eventTypes, List<String> industries, List<String> owners) {
             
        List<Lead> leadsMatchingEmails = [SELECT id, Email, Status, Sent__c, OwnerId, Industry, DO_NOT_SOLICIT__c FROM Lead WHERE Email in: emails];
        
        for(Integer i = 0; i < leadsMatchingEmails.size(); i++){
            Lead lead = leadsMatchingEmails[i];
            Integer matchingIndex = emails.indexOf(lead.Email);
            String eventType = eventTypes[matchingIndex];
       
            if (eventType == 'delivered') {
            	if (lead.Sent__c != null) {
					lead.Sent__c = lead.Sent__c + 1;                
            	} else {
                	lead.Sent__c = 1;
            	}
                if (lead.Status == 'Open') {
                	lead.Status = 'Activating';
            	}
                lead.OwnerId = owners[matchingIndex];
                String industry = industries[matchingIndex];
                if (industry != 'Unknown') {
                    lead.Industry = industry;
                }
            } else if (eventType == 'spamreport' || eventType == 'unsubscribe') {
                lead.DO_NOT_SOLICIT__c = true;
            } else {
                
            }
        }
  
        update leadsMatchingEmails;
    }
}