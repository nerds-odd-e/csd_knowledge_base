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

  context 'リンク先が設定されていないエイリアス' do
    before { subject.body = '[[|text]]' }
    its(:render_body) { should have_link('|text', exact: true) }
  end

  context 'エイリアスが設定されていない' do
    before { subject.body = '[[link|]]' }
    its(:render_body) { should have_link('link|', exact: true) }
  end

  context 'パイプが二つ設定されている' do
    before { subject.body = '[[link||]]' }
    its(:render_body) { should have_link('link||', exact: true) }
  end

  context 'エイリアスはあるがパイプが二つ設定されている' do
    before { subject.body = '[[link||text]]' }
    its(:render_body) { should have_link('link||text', exact: true) }
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
      before { create :wiki_page, path: '', wiki_space: subject.wiki_space }
      xit(:render_body) { should have_link(
        'link#anchor',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#anchor'),
        class: 'internal',
        exact: true
        )
      }
    end
  end

  context 'パイプがエスケープされている' do
    before { subject.body = "[[link\\|text]]" }
    its(:render_body) { should have_link('link|text', exact: true) }
  end

  context 'エスケープされたパイプの前にバックスラッシュがある' do
    before { subject.body = "[[link\\\\|text]]" }
    its(:render_body) { should have_link(
      'text',
      href:h.wiki_space_wiki_page_path(subject.wiki_space, "link\\"),
      exact: true
    ) }
  end

  test_list = [
    ['wikispaceの中にあるwikipageへのリンク', '[[wikispace:wikipage]]', 'wikipage', 'wikispace/wikipage'],
    ['スラッシュ付きでwikipageへのリンク', '[[wikispace/wikipage|wikipage]]', 'wikipage', 'wikispace/wikipage'],
  ]
  test_list.each do |test|
    context test[0] do
      before { subject.body = test[1] }
      its(:render_body) { should have_link(test[2], href:h.wiki_space_wiki_page_path(subject.wiki_space, test[3]), exact: true) }
    end
  end
<<<<<<< HEAD
=======

  context 'nowiki tag囲まれていたらwikilinkとして機能しないこと' do
    before { subject.body = "<nowiki>[[a]]<nowiki>" }
    its(:render_body) { should_not have_link('[[a]]', href:h.wiki_space_wiki_page_path(subject.wiki_space, "a"), exact: true) }
    its(:render_body) { should_not have_link('[[a]]', exact: true) }
  end

>>>>>>> nowiki着手
end
