/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_Tokenizer_Test
** Description      : Test Class for CBOSS Payment Class Integration_CBOSS_Tokenizer
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 

@isTest
private class Integration_CBOSS_Tokenizer_Test{
    
    @isTest static void coverGeneratedCodeTypes() {
        Test.setMock(WebServiceMock.class, new Integration_CBOSS_MockImpl());
        Integration_CBOSS_Tokenizer parentObject = new Integration_CBOSS_Tokenizer();
        new Integration_CBOSS_Data.NotFoundFault();
        new Integration_CBOSS_Tokenizer.Detokenize_element();
        new Integration_CBOSS_Tokenizer.DetokenizeResponse_element();
        new Integration_CBOSS_Tokenizer.Tokenize_element();
        new Integration_CBOSS_Tokenizer.TokenizeResponse_element();
    }
    @isTest static void coverCodeForDetokenize(){
        Test.setMock(WebServiceMock.class, new Integration_CBOSS_MockImpl());
        Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization testObject = new Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization();
        System.assertEquals(null, testObject.Detokenize(null));
    }
    @isTest static void coverCodeForTokenize(){
       Test.setMock(WebServiceMock.class, new Integration_CBOSS_MockImpl());
       Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization testObject = new Integration_CBOSS_Tokenizer.BasicHttpBinding_Tokenization();
       System.assertEquals(null, testObject.Tokenize(null));
    }
}