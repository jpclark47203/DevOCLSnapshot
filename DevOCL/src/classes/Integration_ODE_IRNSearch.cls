/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_ODE_IRNSearch
** Description      : Class to search ODE IRN 
                       the references to fetch the endpoint and authorization details 
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 July-2016                    1.0                          Created
**
************************************************************************************/ 

public with sharing class Integration_ODE_IRNSearch{
    public String searchIRN { get; set; }   //Input - Update this varaible with the IRN Number
    public String searchType  { get; set; }   //Input - Update this varaible with the IRN TYPE - BIRN or DIRN
    
    public Integration_ODE_IRNSearch_JSON Result;    //Output - ODE IRN Details
    
    
    public ODE_Result_error Result_error;  //Output - Error in search
    class ODE_Result_error {
        public String ErrorMessage;
        public String ErrorCode;
    }
    
    
public void searchODEIRN(){
        //Below parameters for integration logging
        String Integration_DebugFlag  = new Integration_Connection().getConnectionDetails('IIB_ODE_IRN_SEARCH','Enable_Debug__c');
        String logMessages = new Integration_Connection().getConnectionDetails('IIB_ODE_IRN_SEARCH','Capture_Messages__c');
        String txnUID = null;
          
         //generate uniqueId if transaction monitor log is enabled
        if (logMessages.equals('true')){txnUID = new Integration_Transaction_Logs().GUID();}

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('username', new Integration_Connection().getConnectionDetails('IIB_ODE_IRN_SEARCH','Target_Credentail_User_Id__c')); //IIB user name
        req.setHeader('password',new Integration_Connection().getConnectionDetails('IIB_ODE_IRN_SEARCH','Target_Credentail_User_Password__c')); //IIB password
        req.setEndpoint(new Integration_Connection().getConnectionDetails('IIB_ODE_IRN_SEARCH'  ,'Target_Connection_URL__c') + '?id=' + searchIRN + '&searchType=' + searchType ); //Connection details
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String json_Result =   res.getBody() ;
        
        String IIB_responseCode= res.getHeader('IIB-Code');
        
        if (Integration_DebugFlag.equals('true')){
                System.debug('IIB_ODE_IRN_SEARCH: Response: '+res.toString());
                System.debug('IIB_ODE_IRN_SEARCH: Body: '+res.getBody());
                System.debug('IIB_ODE_IRN_SEARCH: HTTP Status:'+res.getStatus());
                System.debug('IIB_ODE_IRN_SEARCH:HTTP Status Code:'+res.getStatusCode());
                System.debug('IIB_ODE_IRN_SEARCH:IIB Status Code:'+IIB_responseCode);                
        }//end if system debug
        
          if (IIB_responseCode.equals('200')){
                Result =  (Integration_ODE_IRNSearch_JSON)JSON.deserialize(json_Result , Integration_ODE_IRNSearch_JSON.class);  //Result data from Integration-success
               //Success Response Data
               
            } else{
                Result_error =  (ODE_Result_error)JSON.deserialize(json_Result , ODE_Result_error.class);  //Result data from Integration-error
                //Response Error
                
        }//end if error response
       
        //Log response messages
        if (logMessages.equals('true')){
           Integration_Transaction_Logs.LogMessage('INT-009.1', txnUID,req.getEndpoint(),json_Result,IIB_responseCode,'');
        }//End Log messages into monitor            
    }//end Function
}//End Class