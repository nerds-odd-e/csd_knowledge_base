# frozen_string_literal: true
ParameterType(
    name: 'user',
      regexp: /user .*?/,
      transformer: ->(des) { User.find_by(name: des.split.last) }
)


Given("{string} is a user") do |user_name|
  FactoryBot.create :user, name: user_name, password: "12345678"
end

Given("I log in as {user}") do |user|
  visit new_user_session_url()
  fill_in 'Email', with: user.email
  fill_in 'Password', with: "12345678"
  click_button 'Sign in'
end
