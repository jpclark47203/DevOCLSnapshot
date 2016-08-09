public with sharing class CLQ_NotifyApplicant {

   public list<CLQ_Program_Transaction__c>PTList;
   public list< CLQ_Transaction_Document__c>TDList=new list<CLQ_Transaction_Document__c>();
   public list< CLQ_Role__c>rolelist=new list<CLQ_Role__c>();
   ID PTid; 
   string emailadd;
   public String redirectUrl;
   list<string> emailids=new list<string>();
   String eBody;
   string eSubject;
   string tname;
   EmailTemplate emailtemplate;
   list<Messaging.SingleEmailMessage> maillist = new list<Messaging.SingleEmailMessage>();

 public pagereference notification(){

   PTid=ApexPages.currentPage().getParameters().get('id');
   CLQ_Program_Transaction__c PT = [select id,name,recordtypeid,recordtype.name,CLQ_Program__r.Recordtype.name,CLQ_Program__r.CLQ_Associated_Organization__r.name,CLQ_Program__r.name,CLQ_Program__r.CLQ_Associated_Organization__c,CLQ_Program__r.CLQ_Program_Number__c,CLQ_Program__r.CLQ_Program_Email__c from CLQ_Program_Transaction__c where id=:PTid];
   TDList = [select id,name,CLQ_Document_Status__c,CLQ_Program_Transaction__c from CLQ_Transaction_Document__c where CLQ_Program_Transaction__c =:PTid and CLQ_Document_Status__c='Returned for Revision'];
   system.debug('MMMMMMM'+TDList.size());
   rolelist=[select id,name,CLQ_Contact__c,CLQ_Contact__r.email,CLQ_Program__c from CLQ_Role__c where CLQ_Program__c =:PT.CLQ_Program__r.id];
  
     if(TDList.size()>0){
        System.debug('MMMMMM'+PT.CLQ_Program__r.Recordtype.name);
        if(PT.CLQ_Program__r.Recordtype.name == 'Child Care Center'||PT.CLQ_Program__r.Recordtype.name.contains('FCC')){
        if(rolelist.size()>0){
            for(CLQ_Role__c role : rolelist){
          emailadd=role.CLQ_Contact__r.email;
         }
        }
        system.debug('MMMMMM'+emailadd);
        if(emailadd !=null)
        emailids.add(emailadd);
       emailids.add(PT.CLQ_Program__r.CLQ_Program_Email__c);
       system.debug('MMMMMM'+emailids);
       emailtemplate=[Select e.id, e.markup, e.subject, e.body,e.HtmlValue from emailtemplate e where developername='CLQ_NotifyApplicant_ODJFS'];
       eBody = emailtemplate.Body;
       ebody = ebody.replace('{!CLQ_Program__c.Name}',PT.CLQ_Program__r.name);
       ebody = ebody.replace('{!CLQ_Program__c.CLQ_Program_Number__c}',PT.CLQ_Program__r.CLQ_Program_Number__c);
       eSubject = emailtemplate.subject;
       esubject = esubject.replace('{!CLQ_Program__c.Name}',PT.CLQ_Program__r.name);
       esubject = esubject.replace('{!CLQ_Program__c.CLQ_Program_Number__c}',PT.CLQ_Program__r.CLQ_Program_Number__c);
       esubject = esubject.replace('{!CLQ_Program_Transaction__c.RecordTypeId}',PT.recordtype.name);
       esubject = esubject.replace('{!CLQ_Program__c.CLQ_Associated_OrganizationId__c}',PT.CLQ_Program__r.CLQ_Associated_Organization__c);
       tname='';
       for(CLQ_Transaction_Document__c TD : TDList){
        
         if(tname!=null && tname!='')
         tname= tname+','+TD.name;
         else
           tname=td.name;
           system.debug('MMMMM'+tname);
          }
      ebody = ebody.replace('{!CLQ_Transaction_Document__c.Name}',tname);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 

                 Mail.setToAddresses(emailids);
                 Mail.setPlaintextBody(ebody);        
                 Mail.SetSubject(esubject);
                 Mail.setReplyTo('noreply@salesforce.com');
                 //mail.setUseSignature(false);
                 Mail.setSenderDisplayName('OCLQS');   
                 maillist.add(mail);
           
           system.debug('MMMMMMM'+maillist.size());

      if(maillist!=null && maillist.size()>0){
         Messaging.sendEmailResult[] EmailResult=Messaging.sendEmail(maillist,false);
         system.debug('MMMMM'+emailresult);
      }
    }
    
   if(PT.CLQ_Program__r.Recordtype.name.contains('School')){
        if(rolelist.size()>0){
            for(CLQ_Role__c role : rolelist){
          emailadd=role.CLQ_Contact__r.email;
         }
        }
        system.debug('MMMMMM'+emailadd);
        if(emailadd !=null)
        emailids.add(emailadd);
       emailids.add(PT.CLQ_Program__r.CLQ_Program_Email__c);
       system.debug('MMMMMM'+emailids);
       emailtemplate=[Select e.id, e.markup, e.subject, e.body,e.HtmlValue from emailtemplate e where developername='CLQ_NotifyApplicant_ODE'];
       eBody = emailtemplate.Body;
       ebody = ebody.replace('{!CLQ_Program__c.Name}',PT.CLQ_Program__r.name);
       ebody = ebody.replace('{!CLQ_Program__c.CLQ_Program_Number__c}',PT.CLQ_Program__r.CLQ_Program_Number__c);
       eSubject = emailtemplate.subject;
       esubject = esubject.replace('{!CLQ_Program__c.Name}',PT.CLQ_Program__r.name);
       esubject = esubject.replace('{!CLQ_Program__c.CLQ_Program_Number__c}',PT.CLQ_Program__r.CLQ_Program_Number__c);
       esubject = esubject.replace('{!CLQ_Program_Transaction__c.RecordTypeId}',PT.recordtype.name);
       esubject = esubject.replace('{!CLQ_Program__c.CLQ_Associated_Organization__c}',PT.CLQ_Program__r.CLQ_Associated_Organization__c);
       tname='';
       for(CLQ_Transaction_Document__c TD : TDList){
        
         if(tname!=null && tname !='')
         tname= tname+','+TD.name;
         else
           tname=td.name;
           system.debug('MMMMM'+tname);
          }
      ebody = ebody.replace('{!CLQ_Transaction_Document__c.Name}',tname);
      ebody = ebody.replace('{!CLQ_Program__c.CLQ_Associated_Organization__c}',PT.CLQ_Program__r.CLQ_Associated_Organization__r.name);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 

                 Mail.setToAddresses(emailids);
                 Mail.setPlaintextBody(ebody);        
                 Mail.SetSubject(esubject);
                 Mail.setReplyTo('noreply@salesforce.com');
                 //mail.setUseSignature(false);
                 Mail.setSenderDisplayName('OCLQS');   
                 maillist.add(mail);
           
           system.debug('MMMMMMM'+maillist.size());

      if(maillist!=null && maillist.size()>0){
         Messaging.sendEmailResult[] EmailResult=Messaging.sendEmail(maillist,false);
         system.debug('MMMMM'+emailresult);
      }
    }
  }
     redirecturl ='/'+PT.id;
     pageReference newpage=new pagereference(redirecturl);
     newpage.setRedirect(true);
     return newpage;
 }

}