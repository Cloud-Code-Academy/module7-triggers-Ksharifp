/*
* Complete the following exercises based on the tests.
* Create triggers on account and on opportunity.
*
* Account trigger should do the following:
* 1. Set the account type to prospect.
* 2. Copy the shipping address to the billing address.
* 3. Set the account rating to hot.
* 4. Create a contact for each account inserted.
*
*/


trigger accountAfterInsertTrigger on Account (before insert, before update, after insert) {
    //before insert is for the rating
    //before insert and before update is for copying shipping address
    //after insert is for creating the contact and make the relationship with account Id
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsertSetType(Trigger.new);
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsertUpdateRating(Trigger.new);
            AccountTriggerHandler.beforeInsertUpdateAddressCopy(Trigger.new);
        }
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.afterInsertContactCreate(Trigger.new);
    }
    
}