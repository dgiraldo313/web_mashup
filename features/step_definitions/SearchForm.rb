Given(/^I am on the home page$/) do
  visit '/'
end

Then(/^I should see "([^"]*)"$/) do |text|
  page.should have_content
end

Then(/^I should see  "([^"]*)"$/) do |path|
  page.should have_button button, content: path
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
