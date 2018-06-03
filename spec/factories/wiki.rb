# frozen_string_literal: true

FactoryBot.define do
  sequence :path do |n|
    "path/to/page#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  factory :wiki_page, class: 'WikiPage' do
    wiki_space
    path
    user
    title  'a wiki'
    body   'is a page'
  end

  factory :wiki_space, class: 'WikiSpace' do
    title
  end
end
