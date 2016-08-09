/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_SAFE_GetRoles
** Description      : Class to get SAFE Integration User Roles and IRN Details
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

public with sharing class Integration_SAFE_GetRoles{
    public String loginUserName { get; set; }   //Input - Update this varaible with the SAFE user id for which role details are required
    
    public List<safeUserRoles_Result> Result;    //Output - SAFE User role details - Success
    public class safeUserRoles_Result {
        public String RoleName;
        public String Irn;
        public String organizationType;
        public boolean IsParent;
    }//end class to store SAFE user role details
    
    
    public safeUserRoles_Result_error Result_error;  //Output - SAFE User role details - Error
    class safeUserRoles_Result_error {
        public String ErrorMessage;
        public String ErrorCode;
    }
    
    
public void getSAFEUserRolesDetails(){
        //Below parameters for integration logging
        String Integration_DebugFlag  = new Integration_Connection().getConnectionDetails('IIB_Safe_Roles','Enable_Debug__c');
        String logMessages = new Integration_Connection().getConnectionDetails('IIB_Safe_Roles','Capture_Messages__c');
        String txnUID = null;
          
         //generate uniqueId if transaction monitor log is enabled
        if (logMessages.equals('true')){txnUID = new Integration_Transaction_Logs().GUID();}

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('username', new Integration_Connection().getConnectionDetails('IIB_Safe_Roles','Target_Credentail_User_Id__c')); //IIB user name
        req.setHeader('password',new Integration_Connection().getConnectionDetails('IIB_Safe_Roles','Target_Credentail_User_Password__c')); //IIB password
        req.setEndpoint(new Integration_Connection().getConnectionDetails('IIB_Safe_Roles'  ,'Target_Connection_URL__c') + '?SAFEUserId=' + loginUserName ); //Connection details
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String json_Result =   res.getBody() ;
        
        String IIB_responseCode= res.getHeader('IIB-Code');
        
        if (Integration_DebugFlag.equals('true')){
                System.debug('IIB_Safe_Roles: Response: '+res.toString());
                System.debug('IIB_Safe_Roles: Body: '+res.getBody());
                System.debug('IIB_Safe_Roles: HTTP Status:'+res.getStatus());
                System.debug('IIB_Safe_Roles:HTTP Status Code:'+res.getStatusCode());
                System.debug('IIB_Safe_Roles:IIB Status Code:'+IIB_responseCode);                
        }//end if system debug
        
        if (IIB_responseCode.equals('200')){
             List<safeUserRoles_Result> deserializedInvoices =  (List<safeUserRoles_Result>)JSON.deserialize(json_Result , List<safeUserRoles_Result>.class);  //Result data from Integration-success
               //Success Response Data
             Result =   deserializedInvoices;
        } else{
            safeUserRoles_Result_error Result_error =  (safeUserRoles_Result_error)JSON.deserialize(json_Result , safeUserRoles_Result_error.class);  //Result data from Integration-error
            //Response Error
            
        }//end if error response
       
        //Log response messages
        if (logMessages.equals('true')){
           Integration_Transaction_Logs.LogMessage('INT-005.1', txnUID,req.getEndpoint(),json_Result,IIB_responseCode,'');
        }//End Log messages into monitor    
        
                 
    }//end Function
}//End Class