/*
 * The `LeadTriggerHandler` class contains methods designed to handle various business requirements around
 * the Lead object in Salesforce. This includes functionality like normalizing the title field of a lead, 
 * automatically scoring leads based on certain criteria, and auto-converting leads when certain conditions are met.
 *
 * Students should note:
 * - This class may contain intentional errors that need to be fixed for proper functionality.
 * - Create a corresponding test class for `LeadTriggerHandler` to ensure all methods work as expected.
 *   Both positive and negative test cases should be considered.
 *
 * Documentation on Lead conversion and Test Classes can be found here:
 * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_convertLead.htm
 * https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_test.htm
 */
public with sharing class LeadTriggerHandler extends TriggerHandler {

	public List<Lead> oldRecords;
	public List<Lead> newRecords;
	public Map<Id,Lead> oldLeadMap;
	public Map<Id,Lead> newLeadMap;

	public LeadTriggerHandler(){
		this.oldRecords = Trigger.old;
		this.newRecords = Trigger.new;
		this.oldLeadMap = (Map<Id,Lead>)Trigger.oldMap;
		this.newLeadMap = (Map<Id,Lead>)Trigger.newMap;
	}

	public override void beforeInsert(){
		LeadHelperClass.handleTitleNormalization(newRecords);
		LeadHelperClass.handleAutoLeadScoring(newRecords);
	}

	public override void afterInsert(){
		LeadHelperClass.handleLeadAutoConvert(newRecords);
	}

	public override void beforeUpdate(){
		LeadHelperClass.handleTitleNormalization(newRecords);
		LeadHelperClass.handleAutoLeadScoring(newRecords);
	}
	public override void afterUpdate(){
		LeadHelperClass.handleLeadAutoConvert(newRecords);
	}
}