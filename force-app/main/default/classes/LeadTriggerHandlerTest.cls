@IsTest
public with sharing class LeadTriggerHandlerTest {
    @IsTest
    public static void testLeadTitleVicePresident(){
        List<Lead> vpLeads = new List<Lead>();
        List<Lead> vicepresidentLeads = new List<Lead>();
        List<Lead> vpLeadsBatch2 = new List<Lead>();
        List<Lead> sfDevLeads = new List<Lead>();
        for(Integer i = 0; i < 40; i++){
            if(i < 10){
                //Lead records with Title = 'vp'
                vpLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'vp', Country = 'Japan', City = 'Hyd' ));
            }
            else if(i>= 10 && i < 20){
                //Lead Records with Title = 'v.p.'
                vicepresidentLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'vice president', Country = 'Italy', City = 'Hyd'));
            }
            else if(i>= 20 && i < 30){
                //Lead Records with Title = 'vice president'
                vpLeadsBatch2.add(new Lead(LastName = 'Test '+i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'v.p.', Country = 'Italy', City = 'Hyd'));
            }
            else if(i>= 30 && i < 40) {
                //Lead Records where Title is Other than above three
                sfDevLeads.add(new Lead(LastName = 'Test Lead'+i , Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'Salesforce Dev', Country = 'Italy', City = 'Bangalore'));
            }
        }
        ////Testing for Before Insert of the Leads - Vice President
        Test.startTest();
        insert vpLeads;
        insert vicepresidentLeads;
        insert vpLeadsBatch2;
        insert sfDevLeads;
        Test.stopTest();
            //Check if the all the records inserted above are updated with Title = 'Vice President'
            List<Lead> insertedLeads = [SELECT Id, Title FROM Lead WHERE Company = 'Salesforce'];

            System.Assert.areEqual(40, insertedLeads.size(), 'Leads are not created as expected');
            List<Lead> leads = new List<Lead>();

            List<Lead> leadsUpdated = [SELECT Id, Title FROM Lead WHERE City = 'Hyd'];
            for(Lead lead : leadsUpdated){
                //Positive Testing
                System.Assert.areEqual('Vice President', lead.Title, 'Lead Title is not updated as expected.');
            }
            for(Lead lead : leadsUpdated){
                //Negative Testing
                System.Assert.areNotEqual('v.p.', lead.Title, 'Lead Title should be Vice President.');
            }
            List<Lead> leadsSFDev = [SELECT Id, Title FROM Lead WHERE Name LIKE 'Test Lead'];
            for(Lead lead : leadsSFDev){
                System.Assert.areEqual('Salesforce Dev', lead.Title, 'Lead Title should be not be changed here');
            }

            //////Testing for Before Update of the Leads Title - Vice President
            for(Lead lead : vpLeads){
                lead.Title = 'vp ap'; //Updating the Title of Leads to 'vp ap'. No change in Title is expected.
            }
            for(Lead lead : vicepresidentLeads){
                lead.Title = 'vice president Technical Support'; //Updating the Title of Leads. The Before trigger updates the Title to 'Vice President'
            }
            for(Lead lead : vpLeadsBatch2){
                lead.Title = 'v.p. CRM'; //Updating the Title of Leads to 'v.p. CRM'. The Before trigger updates the Title to 'Vice President'
            }
            for(Lead lead : sfDevLeads){
                lead.Title = 'vp'; //Updating the Title of the Leads to 'vp'. The before trigger updates the Title to 'Vice President'
            }

            
            update vpLeads;
            update vicepresidentLeads;
            update vpLeadsBatch2;
            update sfDevLeads;
            

            List<Lead> updatedLeads = [SELECT Id, Title FROM Lead WHERE Country = 'Italy'];
            for (Lead lead : updatedLeads) {
                System.Assert.areEqual('Vice President', lead.Title, 'Lead Title is not updated as expected'); //Asserting if the Lead Title is updated to 'Vice President'
            }
            for(Lead lead : updatedLeads){
                System.Assert.areNotEqual('vp', lead.Title, 'Lead Title should be Vice President'); //Negative assertion of the Lead Title
            }
            List<Lead> japanLeads = [SELECT Id, Title FROM Lead WHERE Country = 'Japan'];
            for (Lead lead : japanLeads) {
                System.Assert.areEqual('vp ap', lead.Title, 'Lead Title should be vp ap');
            }

    }

    @IsTest
    public static void testLeadTitleManager(){
        List<Lead> mgrLeads = new List<Lead>();
        List<Lead> manageLeads = new List<Lead>();
        List<Lead> hodLeads = new List<Lead>();
        List<Lead> jrLeads = new List<Lead>();
    
    for(Integer i = 0; i < 40; i++){
        if(i < 10){
            //Lead records with Title = 'mgr'
            mgrLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'mgrxx', Country = 'Japan', City = 'Hyd'));
        }
        else if(i>= 10 && i < 20){
            //Lead Records with Title = 'Manage'
            manageLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'manager', Country = 'Italy', City = 'Hyd'));
        }
        else if(i>= 20 && i < 30){
            //Lead Records with Title = 'head of department'
            hodLeads.add(new Lead(LastName = 'Test '+i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'head of department - sales', Country = 'Italy', City = 'Hyd'));
        }
        else if(i>= 30 && i < 40) {
            //Lead Records with Title = Junior Asst
            jrLeads.add(new Lead(LastName = 'Test '+i , Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'Junior Asst', Country = 'Italy', City = 'Bangalore'));
        }
    }
        Test.startTest();
            insert mgrLeads;
            insert manageLeads;
            insert hodLeads;
            insert jrLeads;
        Test.stopTest();

            List<Lead> leads = [SELECT Id, Title FROM Lead WHERE Company = 'Salesforce'];
            System.Assert.areEqual(40, leads.size(), 'Leads are not created as expected'); //Asserting the total number of Leads created

            List<Lead> titleUpdatedLeads = [SELECT Id, Title FROM Lead WHERE City = 'Hyd'];

            for(Lead lead : titleUpdatedLeads){
                //Positive Testing
                System.Assert.areEqual('Manager', lead.Title, 'Lead Title is not updated as expected.'); //Asserting if the Lead Title is updated to Manager.
            }
            for(Lead lead : titleUpdatedLeads){
                //Negative Testing
                System.Assert.areNotEqual('mgr', lead.Title, 'Lead Title should be Manager.'); //Negative assertion of the Lead Title updation.
            }

            List<Lead> jrAsstLeads = [SELECT Id, Title FROM Lead WHERE City = 'Bangalore'];

            for(Lead lead : jrAsstLeads){
                System.Assert.areEqual('Junior Asst', lead.Title, 'Lead Title should be not be changed here');
            }

            //////Testing for Before Update of the Leads Title - Vice President
            for(Lead lead : mgrLeads){
                lead.Title = 'Sr Asst'; //Updating the Title of Leads to 'Sr Asst'. No change in Title is expected.
            }
            for(Lead lead : manageLeads){
                lead.Title = 'sr sales manager'; //Updating the Title of Leads. The Before trigger updates the Title to 'Manager'
            }
            for(Lead lead : hodLeads){
                lead.Title = 'head of department - services'; //Updating the Title of Leads to 'head of department - services'. The Before trigger updates the Title to 'Manager'
            }
            for(Lead lead : jrLeads){
                lead.Title = 'xyzusmgr'; //Updating the Title of the Leads to 'xyzusmgr'. The before trigger updates the Title to 'Manager'
            }

            update mgrLeads;
            update manageLeads;
            update hodLeads;
            update jrLeads;

            List<Lead> updatedLeads = [SELECT Id, Title FROM Lead WHERE Country = 'Italy'];
            for (Lead lead : updatedLeads) {
                System.Assert.areEqual('Manager', lead.Title, 'Lead Title is not updated as expected'); //Asserting if the Lead Title is updated to 'Manager'
            }
            for(Lead lead : updatedLeads){
                System.Assert.areNotEqual('xyzusmgr', lead.Title, 'Lead Title should be Manager'); //Negative assertion of the Lead Title
            }
            List<Lead> japanLeads = [SELECT Id, Title FROM Lead WHERE Country = 'Japan'];
            for (Lead lead : japanLeads) {
                System.Assert.areEqual('Sr Asst', lead.Title, 'Lead Title should be Sr Asst');
            }
    }

    @IsTest
    public static void testLeadTitleExecutive(){

        List<Lead> execLeads = new List<Lead>();
        List<Lead> chiefLeads = new List<Lead>();
        List<Lead> headLeads = new List<Lead>();
        List<Lead> archLeads = new List<Lead>();
    
    for(Integer i = 0; i < 40; i++){
        if(i < 10){
            //Lead records with Title = 'execute'
            execLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'execute', Country = 'Japan', City = 'Hyd', PostalCode = '1234' ));
        }
        else if(i>= 10 && i < 20){
            //Lead Records with Title = 'chief'
            chiefLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'chief', Country = 'Italy', City = 'Hyd', PostalCode = '67891'));
        }
        else if(i>= 20 && i < 30){
            //Lead Records with Title = 'head -marketing'
            headLeads.add(new Lead(LastName = 'Test '+i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'head - marketing', Country = 'Italy', City = 'Hyd', PostalCode = '1234'));
        }
        else if(i>= 30 && i < 40) {
            //Lead Records with Title = architect
            archLeads.add(new Lead(LastName = 'Test '+i , Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'architect', Country = 'Italy', City = 'Bangalore', PostalCode = '1234'));
        }
    }
        Test.startTest();
            insert execLeads;
            insert chiefLeads;
            insert headLeads;
            insert archLeads;
        Test.stopTest();

            List<Lead> leads = [SELECT Id, Title FROM Lead WHERE Company = 'Salesforce'];
            System.Assert.areEqual(40, leads.size(), 'Leads are not created as expected'); //Asserting the total number of Leads created

            List<Lead> titleUpdatedLeads = [SELECT Id, Title FROM Lead WHERE City = 'Hyd'];

            for(Lead lead : titleUpdatedLeads){
                //Positive Testing
                System.Assert.areEqual('Executive', lead.Title, 'Lead Title is not updated as expected.'); //Asserting if the Lead Title is updated to Executive.
            }
            for(Lead lead : titleUpdatedLeads){
                //Negative Testing
                System.Assert.areNotEqual('chief', lead.Title, 'Lead Title should be Executive.'); //Negative assertion of the Lead Title updation.
            }

            List<Lead> architectLeads = [SELECT Id, Title FROM Lead WHERE City = 'Bangalore'];

            for(Lead lead : architectLeads){
                System.Assert.areEqual('architect', lead.Title, 'Lead Title should be not be changed here');
            }

            //////Testing for Before Update of the Leads Title - Vice President
            for(Lead lead : execLeads){
                lead.Title = 'executer'; //Updating the Title of Leads to 'executer' and the Title should be updated to 'Executive'.
            }
            for(Lead lead : chiefLeads){
                lead.Title = 'mini chief '; //Updating the Title of Leads to mini chief. No update is expected for the Lead Title here.
            }
            for(Lead lead : headLeads){
                lead.Title = 'head - HR'; //Updating the Title of Leads to 'head - HR'. The Before trigger updates the Title to 'Executive'.
            }
            for(Lead lead : archLeads){
                lead.Title = 'chief'; //Updating the Title of the Leads to 'chief'. The before trigger updates the Title to 'Executive'
            }

            update execLeads;
            update chiefLeads;
            update headLeads;
            update archLeads;

            List<Lead> updatedLeads = [SELECT Id, Title FROM Lead WHERE PostalCode = '1234'];
            for (Lead lead : updatedLeads) {
                System.Assert.areEqual('Executive', lead.Title, 'Lead Title is not updated as expected'); //Asserting if the Lead Title is updated to 'Executive'
            }
            for(Lead lead : updatedLeads){
                System.Assert.areNotEqual('executer', lead.Title, 'Lead Title should be Executive'); //Negative assertion of the Lead Title
            }
            List<Lead> archtLeads = [SELECT Id, Title FROM Lead WHERE PostalCode = '67891'];
            for (Lead lead : archtLeads) {
                System.Assert.areEqual('mini chief', lead.Title, 'Lead Title should be mini chief');
            }
    }


    @IsTest
    public static void testLeadTitleAssistant(){

        List<Lead> assistLeads = new List<Lead>();
        List<Lead> deputyLeads = new List<Lead>();
        List<Lead> jrLeads = new List<Lead>();
        List<Lead> srLeads = new List<Lead>();
    
    for(Integer i = 0; i < 40; i++){
        if(i < 10){
            //Lead records with Title = 'assist'
            assistLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'assist', Country = 'Japan', City = 'Hyd', PostalCode = '12345' ));
        }
        else if(i>= 10 && i < 20){
            //Lead Records with Title = 'deputy'
            deputyLeads.add(new Lead(LastName = 'Test '+ i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'deputy', Country = 'Italy', City = 'Hyd', PostalCode = '12345'));
        }
        else if(i>= 20 && i < 30){
            //Lead Records with Title = 'jr'
            jrLeads.add(new Lead(LastName = 'Test '+i, Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'jr', Country = 'Italy', City = 'Hyd', PostalCode = '678910'));
        }
        else if(i>= 30 && i < 40) {
            //Lead Records with Title = Senior
            srLeads.add(new Lead(LastName = 'Test '+i , Company = 'Salesforce', Status = 'Open - Not Contacted', Title = 'Senior', Country = 'Italy', City = 'Bangalore', PostalCode = '12345'));
        }
    }
        Test.startTest();
            insert assistLeads;
            insert deputyLeads;
            insert jrLeads;
            insert srLeads;
        Test.stopTest();

            List<Lead> leads = [SELECT Id, Title FROM Lead WHERE Company = 'Salesforce'];
            System.Assert.areEqual(40, leads.size(), 'Leads are not created as expected'); //Asserting the total number of Leads created

            List<Lead> titleUpdatedLeads = [SELECT Id, Title FROM Lead WHERE City = 'Hyd'];

            for(Lead lead : titleUpdatedLeads){
                //Positive Testing
                System.Assert.areEqual('Assistant', lead.Title, 'Lead Title is not updated as expected.'); //Asserting if the Lead Title is updated to Assistant.
            }
            for(Lead lead : titleUpdatedLeads){
                //Negative Testing
                System.Assert.areNotEqual('deputy', lead.Title, 'Lead Title should be Assitant.'); //Negative assertion of the Lead Title updation.
            }

            List<Lead> architectLeads = [SELECT Id, Title FROM Lead WHERE City = 'Bangalore'];

            for(Lead lead : architectLeads){
                System.Assert.areEqual('Senior', lead.Title, 'Lead Title should be not be changed here');
            }

            //////Testing for Before Update of the Leads Title - Vice President
            for(Lead lead : assistLeads){
                lead.Title = 'assistant'; //Updating the Title of Leads to 'assistant' and the Title should be updated to 'Assistant'.
            }
            for(Lead lead : deputyLeads){
                lead.Title = 'deputy man'; //Updating the Title of Leads to deputy manager and the Title should be updated to 'Assistant'.
            }
            for(Lead lead : jrLeads){
                lead.Title = 'Junior'; //Updating the Title of Leads to 'Junior' and no update should be made to Lead Title.
            }
            for(Lead lead : srLeads){
                lead.Title = 'jr'; //Updating the Title of the Leads to 'jr'. The before trigger updates the Title to 'Assistant'
            }

            update assistLeads;
            update deputyLeads;
            update jrLeads;
            update srLeads;

            List<Lead> updatedLeads = [SELECT Id, Title FROM Lead WHERE PostalCode = '12345'];
            for (Lead lead : updatedLeads) {
                System.Assert.areEqual('Assistant', lead.Title, 'Lead Title is not updated as expected'); //Asserting if the Lead Title is updated to 'Assistant'
            }
            for(Lead lead : updatedLeads){
                System.Assert.areNotEqual('jr', lead.Title, 'Lead Title should be Assistant'); //Negative assertion of the Lead Title
            }
            List<Lead> juniorLeads = [SELECT Id, Title FROM Lead WHERE PostalCode = '678910'];
            for (Lead lead : juniorLeads) {
                System.Assert.areEqual('Junior', lead.Title, 'Lead Title should be Junior');
            }
    }

    @IsTest
    static void testHandleAutoLeadScoring() {

        // Create test data
        Lead lead1 = new Lead(
            LastName = 'Doe',
            Company = 'Acme Corp',
            LeadSource = 'Web',
            Email = 'john.doe@example.com', //3 Points
            Phone = '1234567890', //5 points
            Industry = 'Technology', //10 points
            Status = 'Open - Not Contacted'
        );

        Lead lead2 = new Lead(
            LastName = 'Smith',
            Company = 'Beta Inc',
            LeadSource = 'Partner Referral', //0 points as LeadSource is not Website
            Phone = '9876543210', //5 points as Phone is not null
            Industry = 'Finance', //0 points as Industry is not Technology
            Status = 'Open - Not Contacted'
        );

        Lead lead3 = new Lead(
            LastName = 'Brown',
            Company = 'Gamma LLC',
            LeadSource = 'Web',
            Email = 'jane.brown@example.com', // 3 points as Email is not null
            Industry = 'Technology',// 10 points as Industry is Technology
            Status = 'Open - Not Contacted'
        );

        Lead lead4 = new Lead(
            LastName = 'Johnson',
            Company = 'Delta Ltd',
            LeadSource = 'Purchased List', // 0 points as LeadSource is not Website
            Industry = 'Healthcare', //0 points as Industry is not Technology
            Status = 'Open - Not Contacted'
        );
        List<Lead> leadsToInsert = new List<Lead> {lead1, lead2, lead3, lead4 };
        // Insert the test leads
        Test.startTest();
        insert leadsToInsert;
        Test.stopTest();

        // Query the leads to get their IDs
        List<Lead> leadsToScoreInserted = [SELECT Id, LeadSource, Email, Phone, Industry, Lead_Score__c FROM Lead WHERE Id IN :new List<Id> { lead1.Id, lead2.Id, lead3.Id, lead4.Id }];

        // Assert the expected scores
        System.Assert.areEqual(18, leadsToScoreInserted[0].Lead_Score__c,'Lead Score should be 18'); // Lead 1: Website + Email + Phone = 18 points
        System.Assert.areEqual(5, leadsToScoreInserted[1].Lead_Score__c, 'Lead Score should be 5'); // Lead 2: Phone = 5 points
        System.Assert.areEqual(13, leadsToScoreInserted[2].Lead_Score__c, 'Lead Score should be 13'); // Lead 3: Website + Email + Industry = 13 points
        System.Assert.areEqual(0, leadsToScoreInserted[3].Lead_Score__c, 'Lead Score should be 0'); // Lead 4: No conditions met = 0 points

        //Negative Assertion
        System.Assert.areNotEqual(5, leadsToScoreInserted[0].Lead_Score__c,'Lead Score should not be 5');
        System.Assert.areNotEqual(10, leadsToScoreInserted[1].Lead_Score__c, 'Lead Score should not be 10'); 
        System.Assert.areNotEqual(3, leadsToScoreInserted[2].Lead_Score__c, 'Lead Score should not be 13'); 
        System.Assert.areNotEqual(10, leadsToScoreInserted[3].Lead_Score__c, 'Lead Score should not be 10');

        // Update the leads to reflect the new scores
        lead1.LeadSource = 'Phone Inquiry'; //15 points
        lead2.LeadSource = 'Web'; 
        lead2.Email = 'test@test.com';//8 points
        lead3.Industry = 'Healthcare'; //3 points
        lead4.Industry = 'Technology'; //10 points
    
        update new List<Lead>{ lead1, lead2, lead3, lead4 };

        // Re-query the leads to verify the scores
        List<Lead> leadsToScore = [SELECT Lead_Score__c FROM Lead WHERE Id IN :new List<Id> { lead1.Id, lead2.Id, lead3.Id, lead4.Id }];

        // Assert the expected scores
        System.Assert.areEqual(15, leadsToScore[0].Lead_Score__c, 'Lead Score should be 15'); // Lead 1: Industry + Phone = 15 points
        System.Assert.areEqual(8, leadsToScore[1].Lead_Score__c, 'Lead Score should be 8'); // Lead 2: Website + Email + Phone = 8 points
        System.Assert.areEqual(3, leadsToScore[2].Lead_Score__c, 'Lead Score should be 3'); // Lead 3: Website + Email = 3 points
        System.Assert.areEqual(10, leadsToScore[3].Lead_Score__c, 'Lead Score should be 10'); // Lead 4: Industry = 10 points

        System.Assert.areNotEqual(5, leadsToScore[0].Lead_Score__c, 'Lead Score should not be 5');
        System.Assert.areNotEqual(3, leadsToScore[1].Lead_Score__c, 'Lead Score should not be 3');
        System.Assert.areNotEqual(8, leadsToScore[2].Lead_Score__c, 'Lead Score should not be 8');
        System.Assert.areNotEqual(18, leadsToScore[3].Lead_Score__c, 'Lead Score should not be 18');
    }


    @IsTest
    static void testHandleLeadAutoConvertInsert(){
        //Account to be used as convertedAccountId
        Account account = new Account (Name = 'Test Account', Phone = '9876543210');
        insert account;
        //Contact to be used as convertedContactId
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i<10; i++){

            //Contacts with matching email as Leads that are supposed to be converted
            if(i<5){
                contacts.add(new Contact(LastName = 'Test' +i, Email = 'test' + i +'@salesforce.com', AccountId = account.Id));
            }

            //Contacts with duplicate email address so that leads with same email are not converted
            if(i >= 5 && i < 10){
                contacts.add(new Contact(LastName = 'Test' +i, Email = 'test@salesforce.com', AccountId = account.Id));
            }
            
        }
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.insert(contacts, dml);

        List<Lead> leadsToBeConverted = new List<Lead>();
        List<Lead> leadsNotToBeConverted = new List<Lead>();

        for(Integer i = 0; i < 20; i++){

            //Leads that will be converted as Email != null AND IsConverted = False
            if(i<5){
                leadsToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'test' + i + '@salesforce.com', Country = 'Japan'));
            }

            //Leads that will not be converted as there are multiple contacts with the Email - 'test@salesforce'
            if(i>=5 && i <10){
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'test@salesforce.com', Country = 'USA'));
            }

            //Leads that will not be converted as Email = null
            if(i>=10 && i < 15){
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', Country = 'Italy'));
            }

            //Leads that will not be converted as there are no contacts with this email
            if(1 >= 15 && i < 20){
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Country = 'Russia', Email = 'unique@salesforce.com'));
            }

        }

        //Insert the above Leads to trigger the handleLeadAutoConvert method
        Test.startTest();
        insert leadsToBeConverted;
        insert leadsNotToBeConverted;
        Test.stopTest();

        //Asserting if the Leads are converted as expected
        List<Lead> convertedLeads = [SELECT Id, IsConverted FROM Lead WHERE Country = 'Japan'];
        for(Lead lead : convertedLeads){
            //Positive Assertion
            System.Assert.areEqual(True, lead.IsConverted, 'The Leads are not Converted as Expected'); //Asserting if the leads are converted or not
            //Negative Assertion
            System.Assert.areNotEqual(False, lead.IsConverted, 'The Leads should be converted here but they did not'); //Negative Assertion if the Leads are converted or not
        }

        List<Lead> unconvertedLeads = [SELECT Id, IsConverted FROM Lead WHERE Country IN ('USA', 'Italy', 'Russia')];

        for(Lead lead : unconvertedLeads){
            //Positive Assertion
            System.Assert.areEqual(False, lead.IsConverted, 'The Leads Should not be converted'); //Asserting that the leads are not converted.
            //Negative Assertion
            System.Assert.areNotEqual(True, lead.IsConverted, 'The leads should not be converted but they got');
        }
    }

    @IsTest
    static void testHandleLeadAutoConvertUpdate(){
        //Account to be used as convertedAccountId
        Account account = new Account (Name = 'Test Account', Phone = '9876543210');
        insert account;
        //Contact to be used as convertedContactId
        List<Contact> contacts = new List<Contact>();
        for( Integer i = 0; i < 15; i++){
            if(i < 10 ){
                contacts.add(new Contact(LastName = 'Test' +i, Email = 'test' + i +'@salesforce.com', AccountId = account.Id));
            }
            if(i >= 10 && i < 15){
                contacts.add(new Contact(LastName = 'Test' +i, Email = 'boom@salesforce.com', AccountId = account.Id));
            }
            
        }
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.insert(contacts, dml);

        List<Lead> leadsToBeConverted = new List<Lead>();
        List<Lead> leadsNotToBeConverted = new List<Lead>();

        for(Integer i = 0; i < 20; i++){

            //None of the emails will get converted upon creation as per the test data.
            ///Will update these leads email as per the above created contacts and expecting to be Converted.

            if(i<5){ 
                leadsToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'random@salesforce.com', Country = 'USA'));
            }

            /* Will update these leads email as 'unique@salesforce.com' so that the leads will not 
            find any contacts with matching email to auto-convert resulting not getting converted.*/

            if(i>= 5 && i < 10){  
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'random@salesforce.com', Country = 'Japan'));
            }

            ///Will update these leads email as 'test@salesforce.com' so that the leads will find multiple contacts 
            ///with same email and not get converted.
            if(i >= 10 && i < 15 ){
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'random@salesforce.com', Country = 'Italy'));
            }

            //Will not update the leads email for these. As there is no change in the email address before and after update, 
            //leads should not get converted.
            if(i >= 15 && i < 20){
                leadsNotToBeConverted.add(new Lead(LastName = 'Test' + i, Company = 'Salesforce', Status = 'Open - Not Contacted', 
                Email = 'random@salesforce.com', Country = 'Russia'));
            }
        }

        //Creating the leads to be updated later
        insert leadsToBeConverted;
        insert leadsNotToBeConverted;

        List<Lead> leadBatch1 = [SELECT Id, LastName, Email FROM Lead WHERE Country = 'USA'];

        //Iterate over leadBatch1 to update the email of the lead per the contacts created above to auto-convert
        for(Lead lead : leadBatch1){
            lead.Email = 'test' + lead.LastName.substringAfterLast('t') + '@salesforce.com';
        }

        List<Lead> leadBatch2 = [SELECT Id, Email FROM Lead WHERE Country = 'Japan'];

        //Iterate over leadBatch2 to update the email to 'unique@salesforce.com' but still the leads will 
        //not get converted as there are no contacts created with this email

        for(Lead lead : leadBatch2){
            lead.Email = 'unique@salesforce.com';
        }

        List<Lead> leadBatch3 = [SELECT Id, Email FROM Lead WHERE Country = 'Italy'];
        
        /*Iterate over leadBatch3 to update the email to 'test@salesforce.com' but still the leads will 
        not get converted as there are more than one contact with the same email.*/

        for(Lead lead : leadBatch3){
            lead.Email = 'boom@salesforce.com';
        }

        List<Lead> leadBatch4 = [SELECT Id, Email, Country FROM Lead WHERE Country = 'Russia'];

        //Iterate over leadBatch4 and not updating the leads email

        for(Lead lead : leadBatch4){
            lead.Country = 'Singapore';
        }

        Test.startTest();
        update leadBatch1;
        update leadBatch2;
        update leadBatch3;
        update leadBatch4;
        Test.stopTest();

        //Assertion of the leads if they are auto-converted or not.

        List<Lead> convertedLeads = [SELECT Id, IsConverted, Country, Email FROM Lead WHERE Country = 'USA'];
        List<Lead> notConvertedLeads = [SELECT Id, IsConverted, Country, Email FROM Lead WHERE Country IN ('Japan', 'Italy','Singapore')];

        //Iterating over Converted Leads
        for(Lead lead : convertedLeads){

            System.Assert.areEqual(True, lead.IsConverted, 'The Lead is not converted as Expected.');

            System.Assert.areNotEqual(False, lead.IsConverted, 'The Lead should be Converted but it did not');

        }

        //Iterating over unconverted leads
        for(Lead lead : notConvertedLeads){

            System.Assert.areEqual(False, lead.IsConverted, 'The Lead should not be Converted.');

            System.Assert.areNotEqual(True, lead.IsConverted, 'The Lead should not be Converted.');

        }
    }
}