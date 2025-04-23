Public with sharing class AccountTriggerHandler {

        //A method to change the account type to 'Prospect'(before insert)
        //A method to copy the shipping address to the billing address.(before insert and update)
        //A method to set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value. (before insert and update)
        //A method to create a contact related to the account with the following default values:(after insert)


        // Validating CRUD : basically copy/pasting the code in here just changing the error message.


        // Validate field-level security if necessary (such a pain!) Is this even needed?
        

    static {

        if(!Schema.sObjectType.Account.isUpdateable()) {

            throw new System.SecurityException('You do not have access to this record.');

        }

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

    }

    // Class-level variable to store queried accounts
    private static List<Account> newlyInsertedAccounts;

    
    // Method to query accounts (executed only once)
    private static void queryNewlyInsertedAccounts(Set<Id> accountIds) {
        if (newlyInsertedAccounts == null) {
            newlyInsertedAccounts = [
                SELECT Id, Type, Rating, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,
                       ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet, Fax, Phone, Website
                FROM Account
                WHERE Id IN :accountIds
            ];
        }
    }
    

    Public static void beforeInsertSetType (List<Account> newAccounts) {
        queryNewlyInsertedAccounts(newAccounts);

        //Going through new accounts without Type to set the Type field values

        for(Account acc1: newlyInsertedAccounts) {
            if (acc1.Type == null) {
                acc1.Type = 'Prospect';
            }
        }
    }


    Public static void beforeInsertUpdateAddressCopy (List<Account> newAccounts) {
        queryNewlyInsertedAccounts(newAccounts);

        //Going through new accounts without Type to set the Billing Address field values
        for(Account acc1: newlyInsertedAccounts) {
            if (acc1.ShippingAddress != null) {
                acc1.BillingStreet = acc1.ShippingStreet;
                acc1.BillingCity = acc1.ShippingCity;
                acc1.BillingState = acc1.ShippingState;
                acc1.BillingCountry = acc1.ShippingCountry;
                acc1.BillingPostalCode = acc1.ShippingPostalCode; 
            }
        }
    }


    Public static void beforeInsertUpdateRating (List<Account> newAccounts) {
        queryNewlyInsertedAccounts(newAccounts);
        
        //Going through new accounts without Type to set the Rating field values
        for(Account acc1: newlyInsertedAccounts) {
            if (acc1.Fax != null && acc1.Phone != null && acc1.Website != null) {

                acc1.Rating = 'Hot';

            }
        }
    }


    Public static void afterInsertContactCreate (List<Account> newAccounts) {

        // Validate CRUD permissions for inserting Contact
        if (!Schema.sObjectType.Contact.isCreateable()) {
            throw new System.SecurityException('You do not have permission to create Contact records.');
        }
                
        // Validate CRUD permission for insering Contact fields
        if (!Schema.sObjectType.Contact.fields.LastName.isAccessible() || 
            !Schema.sObjectType.Contact.fields.AccountId.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Email.isAccessible() ||
            !Schema.sObjectType.Contact.fields.Id.isAccessible()) {
            throw new System.SecurityException('You do not have access to one or more fields on Contact.');
        }

        //Going through all new accounts to create related contacts
        for (Account acc3 : newAccounts) {
            //this was a short line of code I found on the help docs.
            relatedContacts.add(new Contact(LastName = 'DefaultContact', AccountId = acc3.Id, Email = 'default@email.com')); 

        }

    }
    
}