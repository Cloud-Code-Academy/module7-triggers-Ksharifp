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


Trigger q1OpportunityTrigger on Account (after insert) {
    HW7OppoTriggerHandler.
}