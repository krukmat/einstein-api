# Einstein API - Sentiment and Intent APIs

This is a POC how to use the Einstein APIs.

## Details
![This is an output](https://github.com/krukmat/einstein-api/blob/fd651c1c440c75711c2df3278c5991463e8d589c/image/einsteinapi-case.png)
This implementation is based on the sentiment analysis of cases' descriptions and subject. There's a field that show which is the sentiment inferred based on the default salesforce dataset: CommunitySentiment. 
1. Create an scratch org and deploy all the development in the default folder. 
2. Configure the Einstein API Private API Token that you can get in: https://api.einstein.ai/signup. You will get a private RSA key it can be downloaded as ‘einstein_platform.pem’ 
3.![This is an output](https://github.com/krukmat/einstein-api/blob/7dec4cf67b47e1ec56933d2d4fc1b6638f03d090/image/config-api-setup.png) 
After have this key, go to the org => setup => custom metadata type => JSON Web Token => Manage => Edit RSA Key (with the one generate above) and the edit the susbscriber field with the email you used to signup in the step commented above as well. The rest can remain as it is. 
4. Then you can check it creating a case by any means: manually, email-to-case, web-to-case. And check the response from the Einstein API. The fields are: sam_dev_Sentiments__c (Negative, Positive, Neutral) and sentimentResponse (JSON Response from the API with the raw  response)
5. For the manual cases, a LWC => sentimentLWC was created to refresh the sentiment fields (due the callout is done in a @future method). Also a Platform event called => Refresh__e it's subscribed by the LWC to have been updated when API response is ready in the case object.

