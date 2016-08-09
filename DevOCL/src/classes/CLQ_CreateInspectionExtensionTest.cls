/* Name : CLQ_CreateInspectionExtensionTest
* Description : This class/extension contains all test methods for CLQ_CreateInspectionExtension class. 
* CLQ_CreateInspectionExtension 96%
* CLQ_UtilityClass 100%
**/
@isTest
private class CLQ_CreateInspectionExtensionTest {
    
    @isTest static void test_onLoad() {

         Case caseRecord = prepareTestData();
         insert caseRecord; 
        //Test start
        Test.startTest();
        PageReference pageRef = Page.CLQ_CreateInspection;
        pageRef.getParameters().put('id',caseRecord.id);

        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(caseRecord);
        CLQ_CreateInspectionExtension extensionObject = new CLQ_CreateInspectionExtension(controller);
        extensionObject.onLoad();
        extensionObject.onOK();
        Test.stopTest();

    }
    
    //Method to do negative testing
    @isTest static void test_validationTest() {
         Case caseRecord = prepareTestData(); 
         caseRecord.CLQ_No_Investigation_Required__c = true;
                 caseRecord.CLQ_Reason_for_No_Investigation__c ='test'; 
         insert caseRecord;
        // Implement test code
        //Test start
        Test.startTest();
        PageReference pageRef = Page.CLQ_CreateInspection;
        pageRef.getParameters().put('id',caseRecord.id);

        //Set the current page
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(caseRecord);
        CLQ_CreateInspectionExtension extensionObject = new CLQ_CreateInspectionExtension(controller);
        extensionObject.onLoad();
        
        Test.stopTest();
    }

    //Method to prepare the data
    public static case prepareTestData(){
                //insert configuration record
        CLQ_OCLQS_Configuration__c configRecord = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type B Home');
        insert configRecord; 
        
        //Create account record
        Account accountrecord = new Account(Name='Test Account',CLQ_DIRN__c = '1234'); 
        insert accountrecord ;
        
        //Insert contact
        Contact contactrecord = new Contact(Firstname='test', lastName = 'Test',Accountid = accountrecord.id,Email='test@clq.com' );
        insert contactrecord ;
        
        //Create a program record
        CLQ_Program__c programRecord = new CLQ_Program__c();
        programRecord.Name = 'Test';
        programRecord.CLQ_Associated_Organization__c = accountrecord.id;
        programRecord.CLQ_Street_Address_1__c = 'test';
        programRecord.recordTypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('FCC - Type B Home').getRecordTypeId();
        programRecord.CLQ_Licensing_Specialist__c = UserInfo.getUserid();
        insert programRecord ;
        
        //Create Room Space record
        CLQ_Room_Space__c roomSpace = new CLQ_Room_Space__c();
        roomSpace.CLQ_Program__c = programRecord.id;
        roomSpace.CLQ_Number_of_Children_Under_2__c = 2;
        roomSpace.CLQ_Used_By_Under_or_Over_2__c = 'Both';
        //roomSpace.CLQ_Number_of_Children_Under_2_5__c = 2 ;
        //roomSpace.CLQ_Used_by_Under_or_Over_2_1_2__c = 'Under';
        insert roomSpace;

        //Insert case for program
        Case caseRecord = new Case();
        caseRecord.recordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        caseRecord.ContactId = contactrecord.id;
        caseRecord.CLQ_Program__c = programRecord.id;
        caseRecord.CLQ_Approver_s_Email__c = 'test@CLQ.com';
        caseRecord.CLQ_Assigned_to_Email__c = 'test@CLQ.com'; 
        caseRecord.CLQ_Intake_Date__c = Date.today();
        caseRecord.CLQ_Assigned_To__c = UserInfo.getUserid();
        //insert caseRecord;
         
        return caseRecord;  
    }
}