/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : Integration_Connection_Test
** Description         : This class is a test class for Integration_Connection Class
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                    June-2016                1.0                          Created
**
************************************************************************************/ 

@isTest
private class Integration_Connection_Test {
    @isTest static void test_positive() {
        try{
                // Initialize the Integration Utility
                Integration_Connection utility = new Integration_Connection();
                
                test.StartTest();
                utility.getConnectionDetails('CBOSS','Target_Credentail_User_Id__c');    
                test.StopTest();
                
                System.Assert(utility.getConnectionDetails('CBOSS','Target_Credentail_User_Id__c') != '');
                System.Assert(utility.getConnectionDetails('CBOSS','Target_Connection_Port__c') != '');
                System.Assert(utility.getConnectionDetails('CBOSS','Target_Connection_URL__c') != '');            
                System.Assert(utility.getConnectionDetails('CBOSS','Target_Credentail_Token_OAuth_Key__c') != '');
                System.Assert(utility.getConnectionDetails('CBOSS','Target_Credentail_User_Password__c') != '');
                System.Assert(utility.getConnectionDetails('CBOSS','Attribute_1_Value__c') != '');  
                System.Assert(utility.getConnectionDetails('CBOSS','Attribute_2_Value__c') != '');  
                System.Assert(utility.getConnectionDetails('CBOSS','Attribute_3_Value__c') != '');  
                System.Assert(utility.getConnectionDetails('CBOSS','Enable_Debug__c') != '');                  
               
            }catch(Exception e){
                System.debug(e);
            }//End Catch
    }//End Test Positive
}//End Class