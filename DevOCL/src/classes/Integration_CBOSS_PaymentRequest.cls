/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_PaymentRequest
** Description      : This class is for CBOSS Payment Request to initial Online Payment
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

public with sharing class Integration_CBOSS_PaymentRequest{
     public String billingAddLine1 {get; set;}
     public String billingAddLine2 {get; set;}
     public String billingAddCity {get; set;}     
     public String billingAddCountry {get; set;}     
     public String billingAddPhone {get; set;}     
     public String billingAddState {get; set;}     
     public String billingAddZip {get; set;}     
     public String billingAmount {get; set;}     
     public String billingFName {get; set;}     
     public String billingLName {get; set;}     
     public String billingMName {get; set;}     
     public String billingEmail {get; set;}     
     
     
 
public PageReference redirectToPaymentGateway(){
          List<String> queryParameters = new List<String>();
          String Integration_DebugFlag  = new Integration_Connection().getConnectionDetails('CBOSS','Enable_Debug__c');
          String logMessages = new Integration_Connection().getConnectionDetails('CBOSS','Capture_Messages__c');
          String txnUID = null;
          
          //generate uniqueId if transaction monitor log is enabled
          if (logMessages.equals('true')){txnUID = new Integration_Transaction_Logs().GUID();}
          
                       
          //Required Input Parameters for CBOSS Payment
          queryParameters.add('ClientAccount'   + '=' + EncodingUtil.urlEncode(new Integration_Connection().getConnectionDetails('CBOSS','Attribute_1_Value__c'), 'UTF-8'));        //Don't Change this Parameter, Value configred in Custom MetaData
          queryParameters.add('OriginatorID'    + '=' + EncodingUtil.urlEncode(new Integration_Connection().getConnectionDetails('CBOSS','Attribute_2_Value__c'), 'UTF-8'));        //Don't Change this Parameter, Value configred in Custom MetaData
          
          queryParameters.add('PaymentType'     + '=' + EncodingUtil.urlEncode('Credit', 'UTF-8'));
          queryParameters.add('Amount'          + '=' + EncodingUtil.urlEncode(billingAmount, 'UTF-8'));     //Payment Amount
          queryParameters.add('SuccessfulURL'   + '=' + EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Integration_CBOSS_PaymentResponseSuccess', 'UTF-8'));  //SFDC Page which will be displayed after Successful Payment processing ex: SFDC Receipt Page
          queryParameters.add('UnsuccessfulURL' + '=' + EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Integration_CBOSS_PaymentResponseFailure', 'UTF-8'));     //SFDC Page which will be displayed after Failed Payment processing ex: SFDC Failure Page
          queryParameters.add('CancelURL'       + '=' + EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Integration_CBOSS_PaymentRequest', 'UTF-8'));                 //SFDC Page which will be displayed when user click Cancel button at CBOSS Page
          queryParameters.add('HomeURL'         + '=' + EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Integration_CBOSS_PaymentRequest', 'UTF-8'));                 //SFDC Page which will be displayed when user click Home button at CBOSS Page
           
          //Other Input Parameters for CBOSS Payment - Use below fields on need basis
          // queryParameters.add('AmountLine1Name'        + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('AmountLine1Value'       + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('AmountLine2Name'        + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('AmountLine2Value'       + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('Number'                 + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('Comment1'               + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('Comment2'               + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemCount'              + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemDescription1'       + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemPrice1'             + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemQuantity1'          + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemDescription2'       + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemPrice2'             + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
          // queryParameters.add('ItemQuantity2'          + '=' + EncodingUtil.urlEncode('', 'UTF-8'));
             queryParameters.add('BillingAddressLine1'    + '=' + EncodingUtil.urlEncode(billingAddLine1, 'UTF-8'));
             queryParameters.add('BillingAddressLine2'    + '=' + EncodingUtil.urlEncode(billingAddLine1, 'UTF-8'));
             queryParameters.add('BillingCity'            + '=' + EncodingUtil.urlEncode(billingAddCity, 'UTF-8'));
             queryParameters.add('BillingCountry'         + '=' + EncodingUtil.urlEncode(billingAddCountry, 'UTF-8'));
             queryParameters.add('BillingEmail'           + '=' + EncodingUtil.urlEncode(billingEmail, 'UTF-8'));
             queryParameters.add('BillingFirstName'       + '=' + EncodingUtil.urlEncode(billingFName, 'UTF-8'));
             queryParameters.add('BillingLastName'        + '=' + EncodingUtil.urlEncode(billingLName, 'UTF-8'));
             queryParameters.add('BillingMiddleName'      + '=' + EncodingUtil.urlEncode(billingLName, 'UTF-8'));
          //   queryParameters.add('BillingPhoneAreaCode'   + '=' + EncodingUtil.urlEncode('615', 'UTF-8'));
             queryParameters.add('BillingPhoneNumber'     + '=' + EncodingUtil.urlEncode(billingAddPhone, 'UTF-8'));
             queryParameters.add('BillingState'           + '=' + EncodingUtil.urlEncode(billingAddState, 'UTF-8'));
             queryParameters.add('BillingZip'             + '=' + EncodingUtil.urlEncode(billingAddZip, 'UTF-8'));
           
          String queryString = String.join(queryParameters, '&');
          if (Integration_DebugFlag.equals('true')){system.debug('INTEGRATION-CBOSS-QueryString:'+queryString);}            
         
          
          Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization class_CBOSS = new  Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization();
          String token =  class_CBOSS.Tokenize(queryString);
          
          if (Integration_DebugFlag.equals('true')){system.debug('INTEGRATION-CBOSS-RequestToken:'+token);}            
          
           //check if need log messages
           if (logMessages.equals('true')){
                //Log INT-006.2 Tokenized payment inforation
                Integration_Transaction_Logs.LogMessage('INT-006.2', txnUID,EncodingUtil.urlDecode(queryString, 'UTF-8'),token,'200','');
                txnUID = new Integration_Transaction_Logs().GUID(); //Get new token for below logging

                //Log INT-006.1 Send Payment Details                
                Integration_Transaction_Logs.LogMessage('INT-006.1', txnUID, new Integration_Connection().getConnectionDetails('CBOSS','Attribute_3_Value__c') + '/' +  token,'','200',''); 
           }//End Log messages into monitor            

          PageReference CBOSS_pr;
          CBOSS_pr = new PageReference(new Integration_Connection().getConnectionDetails('CBOSS','Attribute_3_Value__c')); //Get CBOSS Payment Web-Page URL - Redirect Mode
          CBOSS_pr.getParameters().put('id', token);

          return CBOSS_pr;
    }//end Function
}//End Class