Public with sharing class HW7AccountTriggerHandler {
    
    Public static void afterAccountInsertHandler (List<Account> newAccounts) {

        
        // Validating CRUD : basically copy/pasting the code in here just changing the error message.
        if(!Schema.sObjectType.Account.isUpdateable()) {
            throw new System.SecurityException('You do not have access to this record.');
        }


        // Validate field-level security if necessary (such a pain!)
        if (!Schema.sObjectType.Account.fields.Id.isAccessible() || 
            !Schema.sObjectType.Account.fields.Rating.isAccessible() || 
            !Schema.sObjectType.Account.fields.Type.isAccessible() || 
            !Schema.sObjectType.Account.fields.BillingStreet.isAccessible() ||
            !Schema.sObjectType.Account.fields.BillingCity.isAccessible() ||
            !Schema.sObjectType.Account.fields.BillingState.isAccessible() ||
            !Schema.sObjectType.Account.fields.BillingCountry.isAccessible() ||
            !Schema.sObjectType.Account.fields.BillingPostalCode.isAccessible() ||
            !Schema.sObjectType.Account.fields.ShippingStreet.isAccessible() ||
            !Schema.sObjectType.Account.fields.ShippingCity.isAccessible() ||
            !Schema.sObjectType.Account.fields.ShippingState.isAccessible() ||
            !Schema.sObjectType.Account.fields.ShippingCountry.isAccessible() ||
            !Schema.sObjectType.Account.fields.ShippingPostalCode.isAccessible() ||
            !Schema.sObjectType.Account.fields.Primary_Contact__c.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Account.');
        }


        //Getting Accounts with type = null
        List<Account> newlyInsertedAccounts = [
            SELECT Id,Type,Rating,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,
                    ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
            FROM Account
            WHERE Id IN :newAccounts];
        
        
        //List of accounts to be updated
        List<Account> accToUpdate = new List<Account>();

        //Going through new accounts without Type to set the fields values
        for(Account acc1: newlyInsertedAccounts) {
            if (acc1.ShippingAddress != null) {
                acc1.BillingStreet = acc1.ShippingStreet;
                acc1.BillingCity = acc1.ShippingCity;
                acc1.BillingState = acc1.ShippingState;
                acc1.BillingCountry = acc1.ShippingCountry;
                acc1.BillingPostalCode = acc1.ShippingPostalCode; 
            }

            if (acc1.Type = null) {
                acc1.Type = 'Prospect';
            }

            if (acc1.Fax != null && acc1.Phone != null && acc1.Website != null) {
                acc1.Rating = 'Hot';
            }
           
            accToUpdate.add(acc1);
        }

        update accToUpdate();


        // Validate CRUD permissions for inserting Contact
        if (!Schema.sObjectType.Contact.isCreateable()) {
            throw new System.SecurityException('You do not have permission to create Contact records.');
        }
                
        // Validate CRUD permission for insering Contact fields
        if (!Schema.sObjectType.Contact.fields.LastName.isAccessible() || 
            !Schema.sObjectType.Contact.fields.AccountId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Email.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Contact.');
        }
                
        //List of contacts to be inserted
        List<Contact> relatedContacts = new List<Contact>();

        //Going through all new accounts to create related contacts
        for (Account acc3 : newAccounts) {
            //this was a short line of code I found on the help docs.
            relatedContacts.add(new Contact(LastName = 'DefaultContact', AccountId = acc3.Id, Email = 'default@email.com')); 

        }

        insert relatedContacts;

    }
    
}