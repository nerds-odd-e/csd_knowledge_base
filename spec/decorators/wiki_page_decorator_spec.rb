# frozen_string_literal: true

require 'rails_helper'

describe WikiPageDecorator, type: :decorator do
  subject { create(:wiki_page).decorate }

  test_cases_with_exist_check = [
    { context: 'the page with a link',
      body: '[[something here]]',
      link_label: 'something here',
      link_page: 'something here',
      url: 'something here' },
    { context: 'the page with link and label',
      body: '[[link|text]]',
      link_label: 'text',
      link_page: 'link',
      url: 'link' },
    { context: 'アンカーが設定されているリンク',
      body: '[[link#anchor]]',
      link_label: 'link#anchor',
      link_page: 'link%23anchor',
      url: 'link#anchor' },
    { context: 'アンカーとエイリアスが設定されているリンク',
      body: '[[link#anchor|other]]',
      link_label: 'other',
      link_page: 'link%23anchor',
      url: 'link#anchor' },
    { context: 'wikispaceの中にあるwikipageへのリンク',
      body: '[[wikispace:wikipage]]',
      link_label: 'wikipage',
      link_page: 'wikispace/wikipage',
      url: 'wikispace/wikipage' },
    { context: 'スラッシュ付きでwikipageへのリンク',
      body: '[[wikispace/wikipage|wikipage]]',
      link_label: 'wikipage',
      link_page: 'wikispace/wikipage',
      url: 'wikispace/wikipage' },
    { context: 'エスケープされたパイプの前にバックスラッシュがある',
      body: '[[link\\\\|text]]',
      link_label: 'text',
      link_page: 'link\\',
      url: 'link\\' },
    { context: 'パイプがエスケープされている',
      body: '[[link\\|text]]',
      link_label: 'link|text',
      link_page: 'link|text',
      url: 'link|text' },
    { context: 'リンク先が設定されていないエイリアス',
      body: '[[|text]]',
      link_label: '|text',
      link_page: '|text',
      url: '|text' },
    { context: 'エイリアスが設定されていない',
      body: '[[link|]]',
      link_label: 'link|',
      link_page: 'link|',
      url: 'link|' },
    { context: 'パイプが二つ設定されている',
      body: '[[link||]]',
      link_label: 'link||',
      link_page: 'link||',
      url: 'link||' },
    { context: 'エイリアスはあるがパイプが二つ設定されている',
      body: '[[link||text]]',
      link_label: 'link||text',
      link_page: 'link||text',
      url: 'link||text' },
    { context: '閉じ括弧の直前にパイプ | を挿入すると、生成時に半角括弧部分を除いた文字列をリンク名として表示する',
      body: '[[a (b)|]]',
      link_label: 'a',
      link_page: 'a (b)',
      url: 'a (b)'},
    { context: '閉じ括弧の直前にパイプ | を挿入すると、生成時に半角括弧部分を除いた文字列をリンク名として表示する(ただしスペースがふたつ)',
      body: '[[a  (b)|]]',
      link_label: 'a',
      link_page: 'a  (b)',
      url: 'a  (b)'},
  ]
  test_cases_with_exist_check.each do |test_case|
    context test_case[:context] do
      before { subject.body = test_case[:body] }
      its(:render_body) {
        should have_link(
          test_case[:link_label],
          href:h.wiki_space_wiki_page_path(subject.wiki_space, test_case[:url]),
          class: 'absent'
        )
      }

      context 'when the linked page exists' do
        before { create :wiki_page, path: test_case[:link_page], wiki_space: subject.wiki_space }
        its(:render_body) { should_not have_link(
          test_case[:link_label],
          href:h.wiki_space_wiki_page_path(subject.wiki_space, test_case[:url]),
          class: 'absent'
          )
        }
        its(:render_body) { should have_link(
          test_case[:link_label],
          href:h.wiki_space_wiki_page_path(subject.wiki_space, test_case[:url]),
          class: 'internal'
          )
        }
      end
    end
  end
  context 'Test case for anchor' do
    before { subject.body = '[[a#b]]' }
    its(:render_body) {
      should have_link(
        'a#b',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'a#b'),
        class: 'absent'
      )
    }
    context 'when the not linked page exists' do
      before { create :wiki_page, path: 'a', wiki_space: subject.wiki_space }
      its(:render_body) { should have_link(
        'a#b',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'a#b'),
        class: 'absent'
        )
      }
    end
  end
end