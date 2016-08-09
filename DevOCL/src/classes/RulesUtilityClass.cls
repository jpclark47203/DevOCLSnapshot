/************************************************************************
* Name   : RulesUtilityClass                                            *
* Author : Sujila R Nair                                                *
* Desc   : Utility Class                                                *
* ----------------------------------------------------------------------*
* Developer     |  Date        |  Description                           *
* ----------------------------------------------------------------------*
* Sujila R Nair |  04/22/2016  |  Original Version                      *
*************************************************************************/
public class RulesUtilityClass {
    //Get fields details from any SOBject by ObjectName. General function
    public Static string getFieldsbyObject(String objName){
        SObjectType objectType = Schema.getGlobalDescribe().get(objName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();        
        List<String> fns=new List<String>();
        fns.addAll(mfields.keyset());
        String fn_s=String.join(fns, ',');
        return fn_s;        
    }
    
    //Get fields details from any SOBject. General function 
    public static string getFields(Id objId){
        SObjectType objectType = Schema.getGlobalDescribe().get(objId.getSObjectType().getDescribe().getName());
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();        
        List<String> fns=new List<String>();
        fns.addAll(mfields.keyset());
        String fn_s=String.join(fns, ',');
        return fn_s;        
    }
    public static HttpRequest createHttpRequest(String endpoint, String method){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + endpoint);
        req.setMethod(method);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        return req;
    }
    public static HttpResponse getResponse(HttpRequest req){
        Http httpreq = new Http();
        HttpResponse res = httpreq.send(req);
        return res;
    }
}