# frozen_string_literal: true

Given('I visit {string}') do |url|
  visit url
end

Given('There is a wiki space named {string}') do |name|
  @wiki_space = WikiSpace.create!(title: name)
end

When('I edited the page with') do |table|
  pp table.hashes.first
  table.hashes.first.each do |key, value|
    fill_in key.humanize, with: value
  end
  find('input[name="commit"]').click
end

Then('I should see the wiki page containing') do |table|
  table.hashes.each do |row|
    row.each do |key, value|
      expect(page).to have_selector(".wiki-#{key}", text: value)
    end
  end
end

Given('there is a wiki page with path {string} by {user}') do |path, user|
  WikiPage.create! path: path, title: 'title', body: 'body', user: user, wiki_space: @wiki_space
end

Then('I should see a link {string} to {string}') do |link, url|
  expect(page).to have_link(link, href: url)
end

Then('I should not see a link {string} to {string}') do |link, url|
  expect(page).to !have_link(link, href: url)
end

Then("{string}というテキストが存在する") do |text|
  expect(page).to have_text(text)
end

When('I click Edit This Wiki Page') do
  click_on 'Edit This Wiki Page'
end
