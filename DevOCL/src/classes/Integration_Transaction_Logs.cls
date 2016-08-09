/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_Transaction_Logs
** Description      : This class is a utility class that insert/update logs into Salesforce Transaction Monitor
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 
global class Integration_Transaction_Logs {
       
    /**
    ** Method           : Integration_Transaction_Logs
    ** Description      : Constructor
    ** Parameter        : None
    ** Return Type      : None
    **/
    public Integration_Transaction_Logs() { }//End Constructor

    /**
    ** Method           : LogMessage
    ** Description      : This method used for transaction logging
    **/
    @future(callout=true)
    public static void LogMessage(String transactionID,String uniqueID,String requestMessage,String responseMessage,String HTTPResponseCode,String transactionDetails){
        try{ 
                String parentId  = [SELECT Id  FROM OCLQS_Transaction_Log__c where Name=:transactionID].Id;

                if (String.isNotBlank(parentId)){
                    OCLQS_Transaction_Monitor__c txnMonitor = new OCLQS_Transaction_Monitor__c();
                    txnMonitor.User_Name__c = UserInfo.getUserName();
                    if (String.isNotBlank(transactionDetails)){ txnMonitor.Details__c = transactionDetails.trim();}
                    if (String.isNotBlank(requestMessage)) {    txnMonitor.Request_Message__c = requestMessage.trim();}
                    if (String.isNotBlank(responseMessage)){txnMonitor.Response_Message__c = responseMessage.trim();}
                    if (String.isNotBlank(uniqueID)){   txnMonitor.Correlation_Id__c = uniqueID.trim();}
                    
                    if (String.isNotBlank(HTTPResponseCode)){
                        HTTPResponseCode = HTTPResponseCode.trim();
                        txnMonitor.Response_Code__c = HTTPResponseCode;
                        
                        if(HTTPResponseCode.equals('200')){
                            txnMonitor.Status__c = 'Pass';
                        }else{
                            txnMonitor.Status__c = 'Fail';
                        } 
                    }//End if HTTPResponseCode

                    txnMonitor.Transaction_Log__c = parentId.trim(); //ref to parent record
                    upsert txnMonitor OCLQS_Transaction_Monitor__c.Fields.Correlation_Id__c;
                }//End if parentID is not empty
           } catch(Exception e){
            System.debug(e);
       }//End Catch
    }//End method LogMessage


    /**
    ** Method           : getConnectionDetails
    ** Description      : This method returns unique id for corelation
    **/
    Public String GUID(){
        try{
            String kHexChars = '0123456789abcdef';  
            String returnValue = '';
            Integer nextByte = 0;

            for (Integer i=0; i<16; i++) {
                if (i==4 || i==6 || i==8 || i==10) 
                    returnValue += '-';

                nextByte = (Math.round(Math.random() * 255)-128) & 255;

                if (i==6) {
                    nextByte = nextByte & 15;
                    nextByte = nextByte | (4 << 4);
                }

                if (i==8) {
                    nextByte = nextByte & 63;
                    nextByte = nextByte | 128;
                }

                returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
                returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }//End for Loop

        return returnValue;
            
        } catch(Exception e){
            System.debug(e);
            return null;
       }//End Catch
    }//End methods GUID
    
    static String getCharAtIndex(String str, Integer index) {
        if (str == null) return null;
        if (str.length() <= 0) return str;    
        if (index == str.length()) return null;    
        return str.substring(index, index+1);
    }//end function getCharAtIndex
}//End Integration_Transaction_Logs