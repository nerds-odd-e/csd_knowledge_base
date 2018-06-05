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

end
