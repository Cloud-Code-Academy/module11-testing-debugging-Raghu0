public with sharing class LeadHelperClass {
   /* 
	 * Question 1
	 * Requirement Lead Title Normalization - handleTitleNormalization
	 * Occasionally, users input titles in a variety of ways. Streamline these titles for consistency:
	 *
	 * Criteria:
	 * - If the title contains terms such as 'vp', 'v.p.', or 'vice president',
	 *   change the title to 'Vice President'.
	 * - If the title contains terms like 'mgr', 'manage', or 'head of department',
	 *   change the title to 'Manager'.
	 * - Should the title include words like 'exec', 'chief', or 'head',
	 *   change the title to 'Executive'.
	 * - If the title contains terms like 'assist', 'deputy', or 'jr',
	 *   change the title to 'Assistant'.
	 */
	public static void handleTitleNormalization(List<Lead> leadsToNormalize) {
		for (Lead ld : leadsToNormalize) {
            if(ld.Title != null){
                if (ld.title == 'vp' || ld.title.contains('v.p.') || ld.title.contains('vice president')) {
                    ld.Title = 'Vice President';
                } else if (ld.title.contains('mgr') || ld.title.contains('manage') || ld.title.contains('head of department')) {
                    ld.Title = 'Manager';
                } else if (ld.title.contains('exec') || ld.title == 'chief' || ld.title.contains('head')) {
                    ld.Title = 'Executive';
                } else if (ld.title.contains('assist') || ld.title.contains('deputy') || ld.title == 'jr') {
                    ld.Title = 'Assistant';
                }

            }

		}
	}

	/* 
	 * Question 2
	 * Requirement Auto Lead Scoring - handleAutoLeadScoring
	 * Implement logic to automatically assign scores to leads based on specific criteria.
	 * 18 should be highest possible score a lead can have.
	 *
	 * Criteria:
	 * - If the lead source is from the website and an email exists, increment score by 3 points.
	 * - If the lead provides a phone number, increment score by 5 points.
	 * - If the lead belongs to the 'Technology' industry, increment score by another 10 points.
	 */
	public static void handleAutoLeadScoring(List<Lead> leadsToScore) {
		for (Lead ld : leadsToScore) {
			Integer score = 0;

			// Check and add points based on the specified conditions
			if (ld.LeadSource == 'Web' && ld.Email != null) {
				score +=3;
			}

			if (ld.Phone != null) {
				score += 5;
			}

			if (ld.Industry == 'Technology') {
				score += 10;
			}

			ld.Lead_Score__c = score; // Set the computed score back to the lead
		}
	}

	/* 
	 * Question 3
	 * Requirement Automatic Lead Conversion Based on Email Match - handleLeadAutoConvert
	 * Whenever a new Lead is created or an existing Lead's email address is updated,
	 * check for a matching Contact based on the email address. If a single matching
	 * Contact is identified, auto-convert the Lead.
	 * Use the Salesforce report Converted Lead to verify that the Lead was converted to the correct Contact.
	 *
	 * Criteria:
	 * - Monitor the "Email" field on the Lead object for creation or updates.
	 * - On Lead creation or email update, search the Contact object for records with the
	 *   same email address.
	 * - If a single matching Contact is identified:
	 *     - Auto-convert the Lead.
	 *     - Merge the Lead details with the existing Contact, ensuring that crucial
	 *       Contact information is preserved.
	 * - If multiple Contacts with the same email are found or no match is identified,
	 *   leave the Lead unconverted.
	 * 
	 * Hint: 
	 * - One of the errors is recursion related. Check if the lead is already converted or check if the email has changed/is null
	 * - One of the errors is map related. Make sure you are using the correct contact map key
	 */
	public static void handleLeadAutoConvert(List<Lead> leads) {
		// Step 1: Gather all lead emails
		Map<Id, Lead> oldLeads = (Trigger.isUpdate) ? (Map<Id,Lead>) Trigger.oldMap : null;
        Map<Id,String> leadToEmailMap = new Map<Id,String>();
		for (Lead lead : leads) {
			if(!lead.IsConverted && lead.Email != null && (Trigger.isInsert || (Trigger.isUpdate && lead.Email != oldLeads.get(lead.Id).Email)) ){
				leadToEmailMap.put(lead.Id, lead.Email);
			}
			
		}

		// Step 2: Find matching contacts based on email'
        
		Map<String, List<Contact>> emailToContactsMap = new Map<String, List<Contact>>();

		for (Contact c : [SELECT Id, Email, AccountId FROM Contact WHERE Email IN :leadToEmailMap.values()]) {

			if(c.Email != null){
				if (!emailToContactsMap.containsKey(c.Email)) {
					//A new entry is created in the map with the email as the key and a new list containing the current contact (c) as the value.
					emailToContactsMap.put(c.Email, new List<Contact>{c});
				} else {
					// If we found another contact with the same email, we don't auto-convert.
					// So we remove the email from the map.
					//If the email does exist as a key in the map, the current contact (c) is added to the existing list of contacts associated with that email.
					emailToContactsMap.get(c.Email).add(c);
				}
			}
		}

		System.debug('emailToContactMap:::' +emailToContactsMap);

		// Step 3: Auto-convert leads
		List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];
		for (Id leadId : leadToEmailMap.keySet()) {
            String leadEmail = leadToEmailMap.get(leadId);
			if (emailToContactsMap.containsKey(leadEmail) && emailToContactsMap.get(leadEmail).size() == 1) {
				Contact matchingContact = emailToContactsMap.get(leadEmail)[0];
				Database.LeadConvert lc = new Database.LeadConvert();
				lc.setLeadId(leadId);
				lc.setContactId(matchingContact.Id); // Use existing Contact Id
				lc.setAccountId(matchingContact.AccountId); // Use existing Account Id
				lc.setDoNotCreateOpportunity(true); // Assuming we don't want to create an opportunity
				lc.setConvertedStatus(convertStatus.MasterLabel); // Set the converted status
				leadConverts.add(lc);
			}
		}

		if (!leadConverts.isEmpty()) {
			List<Database.LeadConvertResult> lcrs = Database.convertLead(leadConverts);
		}

		System.debug('Converted Leads:::::' + leadConverts);
		System.debug('Converted Leads Size::::' +leadConverts.size());
		
	}
}