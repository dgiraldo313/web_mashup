Given(/^I am on the home page$/) do
  visit '/'
end

Then(/^I should see "([^"]*)"$/) do |text|
  page.should have_content: path
end

Then(/^I should see  "([^"]*)"$/) do |path|
  page.should have_button, content: path
end

Then(/^I should input "([^"]*)"$/) do |text|
  #@message = @ personal_details.text
end

Given(/^I am on the Signup page$/) do
  #@messages = @Signup.link
  #should_not_continue = true if  Signup_link.failed
end

When(/^I see  Signup link$/) do |message|
  #@message.should inlcude(message)
end

When(/^I should click$/) do |message|
  #pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see input information page$/) do
  #pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should type personal information$/) do
  #pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I am on the Search page$/) do
  visit '/'
end

When(/^I see "([^"]*)"$/) do |arg1|
  #name, with: text
end

When(/^I type "([^"]*)"$/) do |arg1|
  #type_Author element
end

Given(/^I am on the Hathi Trust result page$/) do
  visit '/'
end

When(/^I see relevant search results$/) do |arg1|
#page.content : display
end

Then(/^I should see numbers of results displayed$/) do
#page.should not_appear: path
end
