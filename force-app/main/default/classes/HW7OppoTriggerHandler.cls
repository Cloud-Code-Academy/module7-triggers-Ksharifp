Public with sharing class HW7OppoTriggerHandler {
    
    Public static void beforeUpdateOppoHandler (List<Opportunity> updatedOppo) {

        
        // Validating CRUD : basically copy/pasting the code in here just changing the error message.
        if(!Schema.sObjectType.Opportunity.isAccessible()) {
            throw new System.SecurityException('You do not have access to this opportunity record.');
        }


        // Validate field-level security if necessary
        if (!Schema.sObjectType.Opportunity.fields.Id.isAccessible() ||
            !Schema.sObjectType.Opportunity.fields.Name.isAccessible() ||
            !Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible() ||
            !Schema.sObjectType.Opportunity.fields.StageName.isAccessible() ||
            !Schema.sObjectType.Opportunity.fields.Amount.isAccessible() ||
            !Schema.sObjectType.Opportunity.fields.Primary_Contact__r.Id.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Opportunity.');
        }


        // Validating CRUD : basically copy/pasting the code in here just changing the error message.
        if(!Schema.sObjectType.Account.isAccessible()) {
            throw new System.SecurityException('You do not have access to this record.');
        }


        // Validate field-level security if necessary
        if (!Schema.sObjectType.Account.fields.Industry.isAccessible() ||
            !Schema.sObjectType.Account.fields.Primary_Contact__r.Id.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Account.');
        }


        // Validate CRUD permissions for inserting Contact
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.SecurityException('You do not have permission to access Contact records.');
        }
                

        // Validate CRUD permission for insering Contact fields
        if (!Schema.sObjectType.Contact.fields.Id.isAccessible() || 
            !Schema.sObjectType.Contact.fields.AccountId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Title.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Contact.');
        }
       

        List<Opportunity> updatedOppsLessFiveGrand = [
            SELECT Id, Amount, StageName, Account.Id  
            FROM Opportunity 
            WHERE Id IN :updatedOppo AND Amount <= 5000];


        if (!updatedOppsLessFiveGrand.isEmpty()) {
            for (Opportunity opp : updatedOppsLessFiveGrand) {
                if (opp.Amount <= 5000) {
                    opp.addError('Opportunity amount must be greater than 5000.');
                }
            }
        }


    }


    Public static void beforeDeleteClosedWon (List<Opportunity> deletedOppo) {

        // Validating CRUD : basically copy/pasting the code in here just changing the error message.
        if(!Schema.sObjectType.Account.isAccessible()) {
            throw new System.SecurityException('You do not have access to this record.');
        }


        // Validate field-level security if necessary
        if (!Schema.sObjectType.Account.fields.Industry.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Account.');
        }


        for (Opportunity oppNotDelete : deletedOppo) {
            if (oppNotDelete.StageName == 'ClosedWon' && oppNotDelete.Account.Industry == 'Banking') {
                oppNotDelete.addError('You cannot delete a Closed Won opportunity for a Banking account.');
            }
        }
    }

    Public static void afterUpdateSetCEOContact (List<Opportunity> updatedOppo) {

        if(!Schema.sObjectType.Account.isAccessible()) {
            throw new System.SecurityException('You do not have access to this record.');
        }


        // Validate field-level security if necessary
        if (!Schema.sObjectType.Account.fields.Primary_Contact__r.Id.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Account.');
        }


        // Validate CRUD permissions for inserting Contact
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.SecurityException('You do not have permission to access Contact records.');
        }
                

        // Validate CRUD permission for insering Contact fields
        if (!Schema.sObjectType.Contact.fields.Id.isAccessible() || 
            !Schema.sObjectType.Contact.fields.AccountId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Title.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Contact.');
        }


        List<Opportunity> oppsUpdatedWithCEOonAccount = [ 
            SELECT Id, Account.Primary_Contact__c, Account.Primary_Contact__r.Title
            FROM Opportunity 
            WHERE Id IN :updatedOppo AND Account.Primary_Contact__r.Title = 'CEO'];

        List<Opportunity> oppsToSetCEO = new List<Opportunity>();
        

        for (Opportunity opp : updatedOppo) {
            if (opp.Account.Primary_Contact__r != null && opp.Account.Primary_Contact__r.Title == 'CEO') {
                opp.Primary_Contact__c = opp.Account.Primary_Contact_c;
                oppsToSetCEO.add(opp);
            }

        }
        update oppsToSetCEO;

    }
}