global class Twilio_API_Scheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        track_sent();
    }
    
    @future(callout=true)
    public static void track_sent() {
       	HttpResponse res = callout();
     	List<String> numbers = parseData(res.getBody());
		String done = add(numbers);    
    }
   
    
    public static List<String> parseData(String respBody) {
        JSONParser parser = JSON.createParser(respBody);
        List<String> numbers = new List<String>();
        while (parser.nextToken() != null) {
            if (parser.getText() == 'to') {
                parser.nextToken();
                String phone = parser.getText();
                numbers.add(phone);
            }
        }
        return numbers;
    }
    
    public static String add(List<String> numbers) {
        List<Lead> leadsMatchingNumbers = [SELECT id, SentText__c, Status FROM Lead WHERE Phone in: numbers];
        for (Lead lead: leadsMatchingNumbers) {
            if (lead.SentText__c != null) {
                lead.SentText__c = lead.SentText__c + 1;                
            } else {
                lead.SentText__c = 1;
            }
            if (lead.Status == 'Open') {
                lead.Status = 'Activating';
            }
        }
        update leadsMatchingNumbers;
        return 'DONE';
    }
    
    public static HttpResponse callout() {
        Datetime before = Datetime.now().addHours(-1).addMinutes(-2);
        Datetime now = Datetime.now();
        String formatNow = now.formatGmt('yyyy-MM-dd') + 'T' + EncodingUtil.urlEncode(now.formatGmt('HH:mm:ss'), 'utf-8') + 'Z';
        String formatBefore = before.formatGmt('yyyy-MM-dd') + 'T' + EncodingUtil.urlEncode(before.formatGmt('HH:mm:ss'), 'utf-8') + 'Z';
        String query = ('DateSent%3E=' + formatBefore + '&DateSent%3C=' + formatNow);
        HttpRequest req= new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/ACd80fbfb16adf51728b0b04e2342c5ff5/Messages.json?PageSize=1000&' + query);
        req.setMethod('GET');
        Blob headerValue = Blob.valueOf('ACd80fbfb16adf51728b0b04e2342c5ff5' + ':' + '02582530c78f9cea1eae3d1d7a1f6c43');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json; charset=utf-8');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
    
}