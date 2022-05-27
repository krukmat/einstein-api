public class fetchSentiments {
    
    public static String text = '';
    public static String updateCaseId;
    public static string sentimentModelId = 'CommunitySentiment';
    public static string intentModelId = 'ZPMTRRAAK44I37FTHQUD4SGAMY';
    public static String token = EinsteinServicesAPIAuthenticationHandler.getAccessToken('RS256');
    class Output {
        public String sentiment;
        public String output;
    }
    @future(callout=true) 
    public static void updateSentiments(List<Id> CaseIds){
        String sentiment;
        List<Case> cases =  [SELECT Id,	Subject, Comments,Description, sam_dev_Sentiments__c FROM Case WHERE ID IN :CaseIds];
        for(Case selectedCase : cases){
            text = selectedCase.Subject + '. ' + selectedCase.Description;
            Output out = connectEinsteinSentimentAPI(text);
            selectedCase.sam_dev_Sentiments__c = out.sentiment;
            selectedCase.sentimentResponse__c = out.output;
        }
        update cases;
        List<Refresh__e> refreshCases = new List<Refresh__e>();
        refreshCases.add(new Refresh__e());
        List<Database.SaveResult> results = EventBus.publish(refreshCases);
    }
    
    @future(callout=true) 
    public static void updateIntents(List<Id> CaseIds){
        String sentiment;
        List<Case> cases =  [SELECT Id,	Subject, Comments,Description, sam_dev_Sentiments__c FROM Case WHERE ID IN :CaseIds];
        for(Case selectedCase : cases){
            text = selectedCase.Subject + '. ' + selectedCase.Description;
            Output out = connectEinsteinIntentAPI(text);
            selectedCase.sam_dev_Sentiments__c = out.sentiment;
            selectedCase.sentimentResponse__c = out.output;
        }
        update cases;
    }
    public static Output connectEinsteinSentimentAPI(String text){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod( 'POST' );
        req.setEndpoint( 'https://api.einstein.ai/v2/language/sentiment' );
        req.setHeader( 'Authorization', 'Bearer ' + token );
        req.setHeader( 'Content-type', 'application/json' );
        
        String body = '{\"modelId\":\"'+ sentimentModelId + '\",\"document\":\"' + text + '\"}';
        req.setBody( body );
        
        HTTPResponse res = http.send( req );
        Output out = new Output();
        
        SentimentResponse resp = ( SentimentResponse ) JSON.deserialize( res.getBody(), SentimentResponse.class );
        out.output = res.getBody();
        Map<Double,String> maplabelprobablity = new Map<Double,String>();
        List<SentimentResponse.Probabilities > labelWithProbablity = new List<SentimentResponse.Probabilities >();
        if (resp.Probabilities != null){
            for(SentimentResponse.Probabilities selected : resp.Probabilities){
                SentimentResponse.Probabilities selteced = new SentimentResponse.Probabilities();
                selteced.label = selected.label;
                selteced.probability = selected.probability;
                maplabelprobablity.put(selteced.probability,selteced.label);
                labelWithProbablity.add(selteced);
            }
            if(labelWithProbablity.size()>0){
                case updateCase = new case();
                updateCase.Id = updateCaseId;
                out.sentiment = maplabelprobablity.get(labelWithProbablity[0].probability);
                return out;
            }
        } else {
            out.sentiment = '';
            return out;
        }
        return null;
    }
    
    public static Output connectEinsteinIntentAPI(String text){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod( 'POST' );
        req.setEndpoint( 'https://api.einstein.ai/v2/language/intent' );
        req.setHeader( 'Authorization', 'Bearer ' + token );
        req.setHeader( 'Content-type', 'application/json' );
        
        String body = '{\"modelId\":\"'+ intentModelId + '\",\"document\":\"' + text + '\"}';
        req.setBody( body );
        
        HTTPResponse res = http.send( req );
        Output out = new Output();
        
        SentimentResponse resp = ( SentimentResponse ) JSON.deserialize( res.getBody(), SentimentResponse.class );
        out.output = res.getBody();
        Map<Double,String> maplabelprobablity = new Map<Double,String>();
        List<SentimentResponse.Probabilities > labelWithProbablity = new List<SentimentResponse.Probabilities >();
        if (resp.Probabilities != null){
            for(SentimentResponse.Probabilities selected : resp.Probabilities){
                SentimentResponse.Probabilities selteced = new SentimentResponse.Probabilities();
                selteced.label = selected.label;
                selteced.probability = selected.probability;
                maplabelprobablity.put(selteced.probability,selteced.label);
                labelWithProbablity.add(selteced);
            }
            if(labelWithProbablity.size()>0){
                case updateCase = new case();
                updateCase.Id = updateCaseId;
                out.sentiment = maplabelprobablity.get(labelWithProbablity[0].probability);
                return out;
            }
        } else {
            out.sentiment = '';
            return out;
        }
        return null;
    }
}