public with sharing class CLQ_VisitModeAttachmentController {

	private final CLQ_Rules_Inspected__c ruleInspected;
    public Attachment attachment{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public CLQ_VisitModeAttachmentController(ApexPages.StandardController stdController) {
        this.ruleInspected = (CLQ_Rules_Inspected__c)stdController.getRecord();
        attachment = new Attachment();
    }

    //Method to upload the attachemtn 
    //@param: none
    //@return : pagereference
    public PageReference upload(){
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ruleInspected.id;
        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        return null;
    }

}