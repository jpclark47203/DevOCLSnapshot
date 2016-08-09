/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_Tokenizer
** Description      : This class generated from CBOSS WSDL for invoking CBOSS integration
**                  Methods Included: Detokenize, Tokenize  
**                  Primary Port Class Name: BasicHttpBinding_Tokenization   
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 
 
public class Integration_CBOSS_Tokenizer {

    public class BasicHttpBinding_Tokenization {
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.cboss.com/DataTransferTokenizer/1.0','Integration_CBOSS_Tokenizer','http://schemas.datacontract.org/2004/07/Cboss.DataTransferTokenizer.Application.Presentation','Integration_CBOSS_Data','http://schemas.microsoft.com/2003/10/Serialization/','Integration_CBOSS_Serial'};

        public BasicHttpBinding_Tokenization() {
                endpoint_x = new Integration_Connection().getConnectionDetails('CBOSS','Target_Connection_URL__c');
        }//End Constructor


        public String Detokenize(String token) {
            Integration_CBOSS_Tokenizer.Detokenize_element request_x = new Integration_CBOSS_Tokenizer.Detokenize_element();
            Integration_CBOSS_Tokenizer.DetokenizeResponse_element response_x;
            request_x.token = token;
            Map<String, Integration_CBOSS_Tokenizer.DetokenizeResponse_element> response_map_x = new Map<String, Integration_CBOSS_Tokenizer.DetokenizeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'http://www.cboss.com/DataTransferTokenizer/1.0/Tokenization/Detokenize',
                'http://www.cboss.com/DataTransferTokenizer/1.0',
                'Detokenize',
                'http://www.cboss.com/DataTransferTokenizer/1.0',
                'DetokenizeResponse',
                'Integration_CBOSS_Tokenizer.DetokenizeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            
  
            
            return response_x.DetokenizeResult;
            
            
            
        }

        public String Tokenize(String data) {
            Integration_CBOSS_Tokenizer.Tokenize_element request_x = new Integration_CBOSS_Tokenizer.Tokenize_element();
            Integration_CBOSS_Tokenizer.TokenizeResponse_element response_x;
            request_x.data = data;
            Map<String, Integration_CBOSS_Tokenizer.TokenizeResponse_element> response_map_x = new Map<String, Integration_CBOSS_Tokenizer.TokenizeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'http://www.cboss.com/DataTransferTokenizer/1.0/Tokenization/Tokenize',
                'http://www.cboss.com/DataTransferTokenizer/1.0',
                'Tokenize',
                'http://www.cboss.com/DataTransferTokenizer/1.0',
                'TokenizeResponse',
                'Integration_CBOSS_Tokenizer.TokenizeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.TokenizeResult;
        }
    }
    public class Detokenize_element {
        public String token;
        private String[] token_type_info = new String[]{'token','http://www.cboss.com/DataTransferTokenizer/1.0','guid','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.cboss.com/DataTransferTokenizer/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'token'};
    }
    public class DetokenizeResponse_element {
        public String DetokenizeResult;
        private String[] DetokenizeResult_type_info = new String[]{'DetokenizeResult','http://www.cboss.com/DataTransferTokenizer/1.0','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.cboss.com/DataTransferTokenizer/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'DetokenizeResult'};
    }
    public class Tokenize_element {
        public String data;
        private String[] data_type_info = new String[]{'data','http://www.cboss.com/DataTransferTokenizer/1.0','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.cboss.com/DataTransferTokenizer/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'data'};
    }
    public class TokenizeResponse_element {
        public String TokenizeResult;
        private String[] TokenizeResult_type_info = new String[]{'TokenizeResult','http://www.cboss.com/DataTransferTokenizer/1.0','guid','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.cboss.com/DataTransferTokenizer/1.0','true','false'};
        private String[] field_order_type_info = new String[]{'TokenizeResult'};
    }
}