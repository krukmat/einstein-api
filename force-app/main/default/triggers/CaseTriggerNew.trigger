trigger CaseTriggerNew on Case (after insert, after update) {
    if(System.IsBatch() == false && System.isFuture() == false){ 
        List<Id> casesIds = new List<Id>();
        for (Case sCase: (List<Case>)Trigger.New){
            casesIds.add(sCase.Id);
        }
        fetchSentiments.updateSentiments(casesIds);
        //fetchSentiments.updateIntents(casesIds);
    }
}