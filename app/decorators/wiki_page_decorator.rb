# frozen_string_literal: true
# frozen_string_literal: true

class WikiPageDecorator < Draper::Decorator
  delegate_all
  
  def render_body
    # rubocop:disable all
    link_reg = /\[\[([^\]]+)\]\]/
    body.gsub(link_reg) do |match|
      matched = match[link_reg, 1]
      linktext =  matched.split("|")
      link = matched
      text = matched
      if matched.first == "|"
        # do nothing
      elsif matched.last == "|"
        # do nothing
      elsif linktext.length == 2
        link = linktext[0]
        text = linktext[1]
      end
      options = { class: 'internal' }
      options[:class] = 'absent' if find_sibling(link).blank?
      h.link_to text, h.wiki_space_wiki_page_path(wiki_space, link), options
    end.html_safe
    # rubocop:enable all
  end
  end
