Public with sharing class OpportunityTriggerHandler {

        //A method to change the account type to 'Prospect'(before insert)
        //A method to copy the shipping address to the billing address.(before insert and update)
        //A method to set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value. (before insert and update)
        //A method to create a contact related to the account with the following default values:(after insert)


    
    // Validate CRUD permissions for Opportunity object
    

    Public static void beforeUpdateAmountCheck (List<Opportunity> newOpps) {

        // Validate CRUD permissions for Opportunity object

        if (!Schema.sObjectType.Opportunity.isAccessible()) {
        throw new System.SecurityException('You do not have access to Opportunity records.');
        }

        // Going through new opps to validate the amount 
        
        for(Opportunity opp: newOpps) {
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');    
            }
        }
    }


    Public static void beforeDeleteAccountCheck (List<Opportunity> deletedOpps) {
        /*
        I need to query the account to get the account industry field.
        I need a map to set the account industry with the opportunity. 
        I need to check if the account.industry is Banking.
        I don't need the account ID. 

        */
        Set<Id> accIds = new Set<Id>();

        for (Opportunity opp : deletedOpps) {
            accIds.add(opp.AccountId);
        }

        // Validate CRUD permissions for Account object

        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new System.SecurityException('You do not have access to Account records.');
        }

        List<Account> relatedAcc = [SELECT Id, Industry FROM Account WHERE Id IN :accIds];

        Map<Id, String> oppIdAccIndustry = new Map<Id, String>();

        for (Account acc : relatedAcc){
            oppIdAccIndustry.put(acc.Id, acc.Industry);
        }

        for (Opportunity opp : deletedOpps) {
            if (opp.StageName == 'Closed Won' &&
            oppIdAccIndustry.get(opp.AccountId) == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        } 
        
    }


    Public static void beforeUpdateSetContact (List<Opportunity> newOpps) {
        
        // Validate CRUD permissions for Contact object

        if (!Schema.sObjectType.Contact.isAccessible()) {
                throw new System.SecurityException('You do not have access to Contact records.');
            }

        // Validate CRUD permissions for Account object

        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new System.SecurityException('You do not have access to Account records.');
        }

        if (!Schema.sObjectType.Opportunity.fields.Primary_Contact__c.isUpdateable()) {
            throw new System.SecurityException('You do not have permission to update the Primary Contact field.');
        }

        
        //I am querying the opps so that I can look at the title of the contact on the account and also use its Id.

        Set<Id> accId = new Set<Id>();

        for (Opportunity opp: newOpps) {
            accId.add(opp.AccountId);
        }

        // I filtered this query to find the primary contacts who have a title of CEO. 
        // The Child Relationship Name of the Contact Lookup field on the Account is Called "Organizations"


        List<Contact> conCEO = [SELECT Id, Title, AccountId 
                                From Contact
                                Where Title LIKE 'CEO' AND AccountId IN :accId];

        Map<Id,Id> accIdContactId = new Map<Id,Id>();

        for (Contact con : conCEO) {

            accIdContactId.put(con.AccountId, con.Id);

        }

        for (Opportunity opp: newOpps) {
            
            opp.Primary_Contact__c = accIdContactId.get(opp.AccountId);

        }
    }

}

