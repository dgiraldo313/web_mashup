Given(/^I am on the home page$/) do
  visit '/'
end

Then(/^I should see "([^"]*)"$/) do |text|
  config.expect_content = true
  page.should have_content:'Signup'
end

Then(/^I should see  "([^"]*)"$/) do |path|
  expected_content = /Search/
  page.should have_button, content: path
end

Then(/^I should input "([^"]*)"$/) do |text|
  expected_content = /Personal_details/
  page.should have_field, content: path
end

Given(/^I am on the Signup page$/) do
  visit ('/')
  messages = @Signup.link
  should_not_continue = true if  Signup_link.failed
end

When(/^I see  Signup link$/) do |message|
  visit('/Signup_link')
  message.should inlcude: text
end

When(/^I should click$/) do |message|
  visit('/click')
  #pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see input information page$/) do
  expected_content = /information_page/
  page.should have_information, content: path
  #pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should type personal information$/) do
  expected_content = /personal_information/
  page.should have_information, content: path
  #pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I am on the Search page$/) do
  visit ('/')
end

When(/^I see "([^"]*)"$/) do |arg1|
  visit('Title')
  #name, with: text
end

When(/^I type "([^"]*)"$/) do |arg1|
  visit('Ruby_on_rails')
  #type_Author element
end

Given(/^I am on the Hathi Trust result page$/) do
  visit('/')
  messages = HathiTrust.page
  should_not_continue = true if  Signup_link.failed
end

When(/^I see relevant search results$/) do |arg1|
  visit('revelant_search')
  #page.content : display
end

Then(/^I should see numbers of results displayed$/) do
  expected_content = /number_of_results/
  page.should not_appear: path
end
