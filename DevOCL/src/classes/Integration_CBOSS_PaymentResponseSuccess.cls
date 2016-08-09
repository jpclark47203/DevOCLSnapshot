/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_PaymentResponseSuccess
** Description      : Controller Class for handling CBOSS Success Payment authorization
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 


public with sharing class Integration_CBOSS_PaymentResponseSuccess{
        public Map<String, String> paramMap{get; set;}
        private String Integration_DebugFlag{get; set;}
        public String token {get; set;}
        public String response {get; set;}
        
 public Integration_CBOSS_PaymentResponseSuccess(){
        Integration_DebugFlag  = new Integration_Connection().getConnectionDetails('CBOSS','Enable_Debug__c');
        token = ApexPages.currentPage().getParameters().get('id');
        CBOSS_deTokenizeResponse();
 }
 
 @testVisible private void CBOSS_deTokenizeResponse()
    {
       if (String.isNotEmpty(token)){
            
            Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization CBOSS= new Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization();
            response = CBOSS.DeTokenize(token);
            
            if (Integration_DebugFlag.equals('true')){system.debug('INTEGRATION-CBOSS-SuccessResponseToken:'+token);}                    
            if (Integration_DebugFlag.equals('true')){system.debug('INTEGRATION-CBOSS-SuccessResponseData:'+response);}                    
    
            paramMap = new Map<String, String>();
            List<String> params = response.split('&');
            for(String param : params)
            {
                List<String> paramSplit = param.split('=', 2);
                paramMap.put(paramSplit[0], EncodingUtil.urlDecode(paramSplit[1], 'UTF-8'));
            }
        }//end if token Not Empty
    }//End function


 //Method invoked from Apex page to Log integration messages
 @testVisible public void Integration_LogCBOSSData(){
     //Use CBOSS Token as Integration UID, this will avoide duplicate error logging for page refresh issues
     String logMessages = new Integration_Connection().getConnectionDetails('CBOSS','Capture_Messages__c');
     if (logMessages.equals('true') && String.isNotEmpty(response)){
         Integration_Transaction_Logs.LogMessage('INT-006.3', token,token ,EncodingUtil.urlDecode(response,'UTF-8'),'200',''); //INT6.3 Detokenized transactcion log
     } //end if
  }//end function    
 
    
}//End Class