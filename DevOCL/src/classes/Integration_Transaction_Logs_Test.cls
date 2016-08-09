/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : Integration_Transaction_Logs_Test
** Description         : This class is a test class for Integration_Transaction_Logs Class
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
private class Integration_Transaction_Logs_Test {
    @isTest static void test_positive() {
        try{
                // Initialize the Integration Utility
                Integration_Transaction_Logs txnLogs = new Integration_Transaction_Logs();
                
                
                 User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
                 System.runAs(thisUser) {
                       test.StartTest();
                       Integration_Transaction_Logs.LogMessage('xxx','xxx','2','resp','200','other details');
                       test.StopTest();
                  }
                                
                System.Assert(txnLogs.GUID() != '');
            }catch(Exception e){
                System.debug(e);
            }//End Catch
    }//End Test Positive
}//End Class