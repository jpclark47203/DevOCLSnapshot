@isTest
Public Class TestOpportunityTest_V0003
{
    Public static testMethod Opportunity setDummyValues()
    {
        Opportunity primaryObj = new Opportunity();
        primaryObj.name = 'Test';
        primaryObj.stagename = 'Qualification';
        primaryObj.closedate = System.Today();
        return primaryObj;
    }
    Public static testMethod Active_Rule__c setCustomSetting()
    {
        Active_Rule__c myrule = new Active_Rule__c();
        myrule.Name = 'Opportunity Test';
        myrule.Class_Name__c = 'OpportunityTest_V0003';
        insert myrule;
        return myrule;
    }
}