Feature: Viewer visits the home page and search
  In order to read the page
  As a viewer
  I want to see the page of welcome home
  Type search information
  Find results

  Scenario: View home page
    Given I am on the home page
    And I should see "Welcome home"
    Then I should see "Search"

  Scenario: Find the heading on home page
    Given I am on the home page
    And I should see "API DOCS and two buttons (Signup and Search)"
    Then I should see "Search"

  Scenario: Signup and Search
    Given I am on the Search page
    When I see "Signup"
    And I see "Search"
    Then I should input "Personal details"

  Scenario: Sign Up
    Given I am on the Signup page
    When I see  Signup link
    And I should click
    Then I should see input information page
    And I should type personal information

  Scenario: Find the link to the search page
    Given I am on the Search page
    When I see "Title"
    And I see "Author"
    And I see "Pub date"
    Then I should see "Search"

  Scenario: Typing the search query on the search page
    Given I am on the Search page
    When I type "Ruby on rails"
    And I type "Barry Burd"
    And I type "2001"
    Then I should see "Failed to search content"

  Scenario: Page Hathi Trust should appear with search results
    Given I am on the Hathi Trust result page
    When I see "multiple results"
    And I see relevant search results
    Then I should see numbers of results displayed
