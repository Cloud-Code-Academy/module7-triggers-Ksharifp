/*
* Complete the following exercises based on the tests.
* Create triggers on account and on opportunity.
*
*
* Opportunity trigger should do the following:
* 1. Validate that the amount is greater than 5000.
* 2. Prevent the deletion of a closed won opportunity for a banking account.
* 3. Set the primary contact on the opportunity to the contact with the title of CEO.
*/


trigger OpportunityTrigger on Opportunity (before Update, after update, before delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        HW7OppoTriggerHandler.beforeUpdateOppoHandler();
    } 

    if (Trigger.isAfter && Trigger.isUpdate) {
        HW7OppoTriggerHandler.afterUpdateSetCEOContact();
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        HW7OppoTriggerHandler.beforeDeleteClosedWon();
    }

}

