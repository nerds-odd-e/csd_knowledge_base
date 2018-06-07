# frozen_string_literal: true

require 'rails_helper'

describe WikiPageDecorator, type: :decorator do
  subject { create(:wiki_page).decorate }

  context 'the page with a link' do
    before { subject.body = '[[something here]]' }
    its(:render_body) { should have_link('something here') }
    its(:render_body) { should have_link(href: h.wiki_space_wiki_page_path(subject.wiki_space, 'something here')) }
    its(:render_body) { should have_link(class: 'absent') }
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

  context 'the page with a link and text' do
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

  context 'もしもwikilinksの最初がpipeだったらそのまま出たらいいなぁ' do
    before { subject.body = '[[|text]]' }
    its(:render_body) { should have_link('|text', exact: true) }
  end

  context 'もしもwikilinksの最後がpipeだったらそのまま出たらいいなぁ' do
    before { subject.body = '[[link2|]]' }
    its(:render_body) { should have_link('link2|', exact: true) }
  end

  context 'もしもwikilinksの最後がpipe 2つだったらそのまま出たらいいなぁ' do
    before { subject.body = '[[link2||]]' }
    its(:render_body) { should have_link('link2||', exact: true) }
  end

  context 'もしもパイプが2つだったらそのまま出たらいいなぁ' do
    before { subject.body = '[[link2||text]]' }
    its(:render_body) { should have_link('link2||text', exact: true) }
  end

  context 'もしもwikilinksに#がきたら、テキストとリンクになるといいなぁ' do
    before { subject.body = '[[link#section]]' }
    its(:render_body) {
      should have_link(
        'link#section',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#section'),
        class: 'absent',
        exact: true
      )
    }

    context 'when the linked page exists' do
      before { create :wiki_page, path: 'link', wiki_space: subject.wiki_space }
      its(:render_body) { should have_link(
        'link#section',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#section'),
        class: 'internal',
        exact: true
        )
      }
    end
  end

  context 'もしもwikilinksに#とpipeがきたら、いい感じになるといいなぁ' do
    before { subject.body = '[[link#section|other]]' }
    xit(:render_body) {
      should have_link(
        'other',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#section'),
        class: 'absent',
        exact: true
      )
    }

    context 'when the linked page exists' do
      before { create :wiki_page, path: '', wiki_space: subject.wiki_space }
      xit(:render_body) { should have_link(
        'link#section',
        href:h.wiki_space_wiki_page_path(subject.wiki_space, 'link#section'),
        class: 'internal',
        exact: true
        )
      }
    end
  end

  context 'pipeがエスケープされているときはただの縦棒だ！' do
    before { subject.body = "[[link\\|text]]" }
    its(:render_body) { should have_link('link|text', exact: true) }
  end

  context 'バックスラッシュがエスケープされているときはただのバックスラッシュだ！' do
    before { subject.body = "[[link\\\\|text]]" }
    its(:render_body) { should have_link(
      'text',
      href:h.wiki_space_wiki_page_path(subject.wiki_space, "link\\"),
      exact: true
    ) }
  end

  context 'create wikipage link in wikispace' do
    before { subject.body = "[[wikispace:wikipage]]" }
    its(:render_body) { should have_link('wikipage', href:h.wiki_space_wiki_page_path(subject.wiki_space, "wikispace/wikipage"), exact: true) }
  end

  context 'create wikipage link in wikispace without colon' do
    before { subject.body = "[[wikispace/wikipage|wikipage]]" }
    its(:render_body) { should have_link('wikipage', href:h.wiki_space_wiki_page_path(subject.wiki_space, "wikispace/wikipage"), exact: true) }
  end

end
