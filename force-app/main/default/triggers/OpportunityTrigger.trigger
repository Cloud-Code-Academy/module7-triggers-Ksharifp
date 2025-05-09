trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.beforeUpdateAmountCheck(Trigger.new);
            OpportunityTriggerHandler.beforeUpdateSetContact(Trigger.new);   
        }
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.beforeDeleteAccountCheck(Trigger.old);
        }
    }
}