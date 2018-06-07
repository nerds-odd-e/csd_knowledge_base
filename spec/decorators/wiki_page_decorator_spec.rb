# frozen_string_literal: true

require 'rails_helper'

describe WikiPageDecorator, type: :decorator do
  subject { create(:wiki_page).decorate }

  context 'the page with a link' do
    before { subject.body = '[[something here]]' }
    its(:render_body) {
      should have_link(
        'something here',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'something here'),
        class: 'absent'
      )
    }

    context 'when the linked page exists' do
      before { create :wiki_page, path: 'something here', wiki_space: subject.wiki_space }
      its(:render_body) { should_not have_link(
        'something here',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'something here'),
        class: 'absent'
        )
      }
      its(:render_body) { should have_link(
        'something here',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'something here'),
        class: 'internal'
        )
      }
    end
  end

  context 'the page with link and label' do
    before { subject.body = '[[link|text]]' }
    its(:render_body) { should have_link('text', exact: true) }
    its(:render_body) { should have_link(href: h.wiki_space_wiki_page_path(subject.wiki_space, 'link')) }
    its(:render_body) { should have_link(class: 'absent') }
    its(:render_body) {
      should have_link(
        'text',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link'),
        class: 'absent'
      )
    }

    context 'when the linked page exists' do
      before { create :wiki_page, path: 'link', wiki_space: subject.wiki_space }
      its(:render_body) { should_not have_link(
        'text',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link'),
        class: 'absent'
        )
      }
      its(:render_body) { should have_link(
        'text',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link'),
        class: 'internal'
        )
      }
    end
  end


  context 'アンカーが設定されているリンク' do
    before { subject.body = '[[link#anchor]]' }
    its(:render_body) {
      should have_link(
        'link#anchor',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#anchor'),
        class: 'absent',
        exact: true
      )
    }

    context 'リンクされたページが存在している' do
      before { create :wiki_page, path: 'link', wiki_space: subject.wiki_space }
      its(:render_body) { should have_link(
        'link#anchor',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#anchor'),
        class: 'internal',
        exact: true
        )
      }
    end
  end

  context 'アンカーとエイリアスが設定されている' do
    before { subject.body = '[[link#anchor|other]]' }
    xit(:render_body) {
      should have_link(
        'other',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#anchor'),
        class: 'absent',
        exact: true
      )
    }

    context 'リンクされたページが存在している' do
      before { create :wiki_page, path: 'link', wiki_space: subject.wiki_space }
      xit(:render_body) { should have_link(
        'link#anchor',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#anchor'),
        class: 'internal',
        exact: true
        )
      }
    end
  end

  test_cases = [
    # context, body, link_label, url
    {context: 'wikispaceの中にあるwikipageへのリンク', body: '[[wikispace:wikipage]]', link_label: 'wikipage', url: 'wikispace/wikipage'},
    {context: 'スラッシュ付きでwikipageへのリンク', body: '[[wikispace/wikipage|wikipage]]', link_label: 'wikipage', url: 'wikispace/wikipage'},
    {context: 'エスケープされたパイプの前にバックスラッシュがある', body: '[[link\\\\|text]]', link_label: 'text', url: 'link\\'},
    {context: 'パイプがエスケープされている', body: '[[link\\|text]]', link_label: 'link|text', url: 'link|text'},
    {context: 'リンク先が設定されていないエイリアス', body: '[[|text]]', link_label: '|text', url: '|text'},
    {context: 'エイリアスが設定されていない', body: '[[link|]]', link_label: 'link|', url: 'link|'},
    {context: 'パイプが二つ設定されている', body: '[[link||]]', link_label: 'link||', url: 'link||'},
    {context: 'エイリアスはあるがパイプが二つ設定されている', body: '[[link||text]]', link_label: 'link||text', url: 'link||text'},  
  ]
  test_cases.each do |test_case|
    context test_case[:context] do
      before { subject.body = test_case[:body] }
      its(:render_body) { should have_link(test_case[:link_label], href:h.wiki_space_wiki_page_path(subject.wiki_space, test_case[:url]), exact: true) }
    end
  end
end
