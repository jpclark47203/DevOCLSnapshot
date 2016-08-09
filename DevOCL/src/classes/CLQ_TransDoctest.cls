@istest
private class CLQ_TransDoctest {
    
    static testMethod void thisTest (){
    //insert configuration record
    list<CLQ_OCLQS_Configuration__c> configurationRecordList = new list<CLQ_OCLQS_Configuration__c>();
    CLQ_OCLQS_Configuration__c configRecordTypeA = new CLQ_OCLQS_Configuration__c(Name = 'FCC - Type A Home');
    CLQ_OCLQS_Configuration__c configRecordCCC = new CLQ_OCLQS_Configuration__c(Name = 'Child Care Center');
    CLQ_OCLQS_Configuration__c configRecordschool = new CLQ_OCLQS_Configuration__c(Name = 'Pre School');
    configurationRecordList.add(configRecordTypeA);
    configurationRecordList.add(configRecordCCC);
    configurationRecordList.add(configRecordschool);
    insert configurationRecordList;
    
    Account A = new Account(Name='Test account');
    insert A;
        CLQ_County__c C = new CLQ_County__c(Name='Franklin');
    insert C;
        CLQ_Program__c P = new CLQ_Program__c(Name = 'Test Prog',CLQ_Open_Date__c=date.today()+2,CLQ_Associated_Organization__c=A.id,CLQ_License_Registration_Status__c ='excempt',CLQ_License_Type__c='Continous',
                                               CLQ_Total_Staff__c=5,CLQ_Estimated_Enrollment__c=9,CLQ_Full_Day_Option__c='No',CLQ_Funding__c='Local',CLQ_Food_Service__c='Food Service License',CLQ_Street_Address_1__c='392 western ave',
                                               CLQ_City__c='chicago',CLQ_State__c='Illinois',Recordtypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Child Care Center').getRecordTypeId(),
                                               CLQ_Zip_Code__c='98780',CLQ_County__c=c.id);
    insert P;
      CLQ_Program__c P1 = new CLQ_Program__c(Name = 'Test Prog1',CLQ_Open_Date__c=date.today()+2,CLQ_Associated_Organization__c=A.id,CLQ_License_Registration_Status__c ='excempt',CLQ_License_Type__c='Continous',
                                               CLQ_Total_Staff__c=5,CLQ_Estimated_Enrollment__c=9,CLQ_Full_Day_Option__c='No',CLQ_Funding__c='Local',CLQ_Food_Service__c='Food Service License',CLQ_Street_Address_1__c='392 western ave',
                                               CLQ_City__c='chicago',CLQ_State__c='Illinois',Recordtypeid = Schema.SObjectType.CLQ_Program__c.getRecordTypeInfosByName().get('Pre School').getRecordTypeId(),
                                               CLQ_Zip_Code__c='98780',CLQ_County__c=c.id);
    insert P1;
        CLQ_Program_Transaction__c PT = new CLQ_Program_Transaction__c(CLQ_Transaction_Assigned_To__c=UserInfo.getUserid(),CLQ_Program__c=p.id);
        
    insert PT;
        CLQ_Program_Transaction__c PT1 = new CLQ_Program_Transaction__c(CLQ_Transaction_Assigned_To__c=UserInfo.getUserid(),CLQ_Program__c=p1.id);
        
    insert PT1;
        CLQ_Transaction_Document__c TD = new CLQ_Transaction_Document__c(Name = 'Test',CLQ_Document_Status__c='Returned for Revision',CLQ_Program_Transaction__c=PT.id);
     
     insert TD;
        CLQ_Transaction_Document__c TD1 = new CLQ_Transaction_Document__c(Name = 'Test1',CLQ_Document_Status__c='Returned for Revision',CLQ_Program_Transaction__c=PT1.id);
     
     insert TD1;
       CLQ_Role__c Role = new CLQ_Role__c(CLQ_Program__c = p.id);
     insert role;
       CLQ_Role__c Role1 = new CLQ_Role__c(CLQ_Program__c = p1.id);
     insert role1;
     emailmessage em = new emailmessage();
                em.fromaddress = 'Test@test.com';
                em.toaddress = 'test1@test.com';
                em.subject = 'Test Email';
                em.textbody = 'testing';
                //em.parentid = t1.id;
     
     Test.startTest();    
     //Test.setCurrentPage(new pageReference('/apex/CLQTransDocApprovedPage'));
     //System.currentPageReference().getParameters().put('id',TD.id);
     //CLQTransDocApprove App = new CLQTransDocApprove();
     //App.statusupdateApp(); //Commented out by Vrajesh as there is no CLQTransDocApprove class now : Date:07/13/2016
     //Test.setCurrentPage(new pageReference('/apex/CLQTransDocRevisionPage'));
     //System.currentPageReference().getParameters().put('id',TD.id);
     //CLQTransDocreturnForRevision Rev=new CLQTransDocreturnForRevision();
     //Rev.statusupdate(); //Commented out by Vrajesh as there is no CLQTransDocreturnForRevision class now : Date:07/13/2016
     Test.setCurrentPage(new pageReference('/apex/CLQ_NotifyApplicantPage'));
     System.currentPageReference().getParameters().put('id',PT.id);
     CLQ_NotifyApplicant NOtify=new CLQ_NotifyApplicant();
     Notify.notification();
    insert em;
    Test.setCurrentPage(new pageReference('/apex/CLQ_NotifyApplicantPage'));
     System.currentPageReference().getParameters().put('id',PT1.id);
     CLQ_NotifyApplicant NOtify1=new CLQ_NotifyApplicant();
     Notify1.notification();
    //insert em;
     
     test.stoptest();
    }
}