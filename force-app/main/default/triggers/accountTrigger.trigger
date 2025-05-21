trigger accountTrigger on Account (before insert, before update, after insert) {
    
	//before insert is for the Type, shipping address and setting Rating
    //after insert is for creating the contact and make the relationship with account Id


    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsertSetType(Trigger.new);
            AccountTriggerHandler.beforeInsertUpdateRating(Trigger.new);
            AccountTriggerHandler.beforeInsertUpdateAddressCopy(Trigger.new);
    	}	
        //if (Trigger.isUpdate) {
            //AccountTriggerHandler.beforeInsertUpdateAddressCopy(Trigger.new);
        //}
    }


    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.afterInsertContactCreate(Trigger.new);
        }
    }
    
}