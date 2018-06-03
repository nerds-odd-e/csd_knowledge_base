# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "person#{n}@odd-e.com"
  end

  factory :user do
    name 'Test User'
    email
    password 'please123'
  end
end
