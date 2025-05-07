trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.beforeUpdateAmountCheck(Trigger.new);    
        }
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.beforeDeleteAccountCheck(Trigger.old);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            OpportunityTriggerHandler.afterUpdateSetContact(Trigger.old);
        }
    }
}