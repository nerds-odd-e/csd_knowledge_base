# frozen_string_literal: true

When("I edited the page with context {string}") do |wiki_link|
  fill_in "body".humanize, with: wiki_link
  find('input[name="commit"]').click
end

Then('I should see a link {string} to {string}') do |link, url|
  expect(page).to have_link(link, href: url)
end

Then('I should not see a link {string} to {string}') do |link, url|
  expect(page).not_to have_link(link, href: url)
end

Then("{string}というテキストが存在する") do |text|
  expect(page).to have_text(text)
end
