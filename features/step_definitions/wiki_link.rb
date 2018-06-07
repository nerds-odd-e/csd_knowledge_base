# frozen_string_literal: true

Given('there is a wiki page with path {string} by {user}') do |path, user|
  WikiPage.create! path: path, title: 'title', body: 'body', user: user, wiki_space: @wiki_space
end

Then('I should see a link {string} to {string}') do |link, url|
  expect(page).to have_link(link, href: url)
end

Then("{string}というテキストが存在する") do |text|
  expect(page).to have_text(text)
end

When('I click Edit This Wiki Page') do
  click_on 'Edit This Wiki Page'
end

When("I edited the page with context {string}") do |wikilink|
  fill_in "body".humanize, with: wikilink
  find('input[name="commit"]').click
end
