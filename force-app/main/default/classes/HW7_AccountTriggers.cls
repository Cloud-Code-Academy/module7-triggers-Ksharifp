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


Trigger q1AccountTrigger on Account (after insert) {
    HW7AccountTriggerHandler.afterAccountInsertHandler(Trigger.new);
}