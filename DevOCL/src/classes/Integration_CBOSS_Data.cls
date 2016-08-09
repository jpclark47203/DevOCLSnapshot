/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : Integration_CBOSS_Data
** Description      : This class is created after consuming CBOSS WSDL
** Version          : 1.0
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Sanjeev Chahar                 June-2016                    1.0                          Created
**
************************************************************************************/ 
public class Integration_CBOSS_Data {
    public class NotFoundFault {
        public String Message;
        private String[] Message_type_info = new String[]{'Message','http://schemas.datacontract.org/2004/07/Cboss.DataTransferTokenizer.Application.Presentation','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/Cboss.DataTransferTokenizer.Application.Presentation','true','false'};
        private String[] field_order_type_info = new String[]{'Message'};
    } //End method
}//End Class