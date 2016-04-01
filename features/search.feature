#encoding utf-8
Feature: Perform search on external resources
	As a researcher, I want to have a tool
	that will search and return results for external research resources
	so I can streamline my research process. 

Scenario: Retrieving XML doc
	Given a set of options to search for in the page
	When I enter the fields into the page
	Then I will retrieve an XML document

Scenario: Parsing link from XML 
	Given an XML doc
	When the doc is returned
	Then I will see the links to resources automatically 