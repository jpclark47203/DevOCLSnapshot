/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_MockImpl
** Description      : Test Class for CBOSS Integration
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
@isTest
public class Integration_CBOSS_MockImpl implements WebServiceMock {
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
       
        System.debug(LoggingLevel.INFO, 'OCLQS_CBOSS_MockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf Integration_CBOSS_Tokenizer.Detokenize_element) {
            response.put( 'response_x', new Integration_CBOSS_Tokenizer.DetokenizeResponse_element());
        }
        else if(request instanceOf Integration_CBOSS_Tokenizer.Tokenize_element) {
            response.put( 'response_x', new Integration_CBOSS_Tokenizer.TokenizeResponse_element());
        }
    }
}//End Class