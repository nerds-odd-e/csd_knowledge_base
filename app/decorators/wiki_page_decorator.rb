# frozen_string_literal: true
# frozen_string_literal: true

class WikiPageDecorator < Draper::Decorator
  delegate_all

  def render_body
    # rubocop:disable all
    link_reg = /\[\[([^\]]+)\]\]/
    body.gsub(link_reg) do |match|
      matched = match[link_reg, 1]
      options = { class: 'internal' }
      options[:class] = 'absent' if find_sibling(matched).blank?
      h.link_to matched, h.wiki_space_wiki_page_path(wiki_space, matched), options
    end.html_safe
    # rubocop:enable all
  end
  end
