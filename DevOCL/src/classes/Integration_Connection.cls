/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_Connection
** Description      : This class is a utility class that fetches the endpoint for the integration then makes
                       the references to fetch the endpoint and authorization details 
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 

public with sharing class Integration_Connection {
    public static List <OCLQS_Integration_Settings__mdt> listIntegrationDetails;
    
/**
    ** Method           : Integration_Connection
    ** Description      : Constructor
    ** Parameter        : None
    ** Return Type      : None
    **/
    public Integration_Connection() {
        String currenEnvName;
            
        currenEnvName = URL.getSalesforceBaseUrl().getHost().substringBetween('--','--');

        if (String.IsBlank(currenEnvName)){currenEnvName = URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');}
        if (!String.IsBlank(currenEnvName)){currenEnvName = currenEnvName.trim().touppercase();}
        
        listIntegrationDetails = [Select Capture_Messages__c, Enable_Debug__c, Attribute_1_Value__c, Attribute_2_Value__c, Attribute_3_Value__c, DeveloperName, Target_Connection_Port__c,Target_Connection_URL__c,Target_Credentail_Token_OAuth_Key__c,Target_Credentail_User_Id__c,Target_Credentail_User_Password__c, Environment_Name__c from OCLQS_Integration_Settings__mdt where Environment_Name__c =:currenEnvName];
    }//End Constructor
    
    /**
    ** Method           : getConnectionDetails
    ** Description      : This method returns the integration parameter value
    ** Parameter        : DeveloperName and MetaData Type Object field name
    ** Return Type      : String
    **/
    public String getConnectionDetails(String TransactionId, String paraType){
      try{ 
           String data='--METADATA--NOT--FOUND--'; //Default value
           if(!listIntegrationDetails.isEmpty() && listIntegrationDetails.size() > 0){
                   for(OCLQS_Integration_Settings__mdt integration : listIntegrationDetails){
                       if (integration.DeveloperName.trim().touppercase().equals(TransactionId.trim().touppercase())){
                               
                               if (paraType.trim().touppercase().equals('Target_Connection_URL__c'.trim().touppercase())){                
                                   data = integration.Target_Connection_URL__c;
                               } else if (paraType.trim().touppercase().equals('Target_Connection_Port__c'.trim().touppercase())){                
                                   data = integration.Target_Connection_Port__c;
                               } else if (paraType.trim().touppercase().equals('Target_Credentail_Token_OAuth_Key__c'.trim().touppercase())){                
                                   data = integration.Target_Credentail_Token_OAuth_Key__c;
                               } else if (paraType.trim().touppercase().equals('Target_Credentail_User_Id__c'.trim().touppercase())){                
                                   data = integration.Target_Credentail_User_Id__c;
                               } else if (paraType.trim().touppercase().equals('Target_Credentail_User_Password__c'.trim().touppercase())){                
                                   data = integration.Target_Credentail_User_Password__c;
                               } else if (paraType.trim().touppercase().equals('Attribute_1_Value__c'.trim().touppercase())){                
                                   data = integration.Attribute_1_Value__c;
                               } else if (paraType.trim().touppercase().equals('Attribute_2_Value__c'.trim().touppercase())){                
                                   data = integration.Attribute_2_Value__c;
                               } else if (paraType.trim().touppercase().equals('Attribute_3_Value__c'.trim().touppercase())){                
                                   data = integration.Attribute_3_Value__c;         
                               } else if (paraType.trim().touppercase().equals('Enable_Debug__c'.trim().touppercase())){                
                                   data = string.valueOf(integration.Enable_Debug__c);         
                               } else if (paraType.trim().touppercase().equals('Capture_Messages__c'.trim().touppercase())){                
                                   data = string.valueOf(integration.Capture_Messages__c);         
                               }//End if
                               
                               
                               
                               
                               
                               break;  
                       }//End if Match Transaction Id
                   }//End for Loop
           }//End if iterator
           
           return data.trim();
       
       } catch(Exception e){
            System.debug(e);
            return null;
       }//End Catch
       
    }//End getConnectionDetails

}//End Class