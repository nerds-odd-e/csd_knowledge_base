# frozen_string_literal: true
# frozen_string_literal: true

class WikiPageDecorator < Draper::Decorator
  delegate_all

  def render_body
    # rubocop:disable all
    link_reg = /\[\[([^\]]+)\]\]/
    body.gsub(link_reg) do |match|
      matched = match[link_reg, 1]
      pipe = matched.index("|")
      if pipe.nil? 
        link = matched
        text = matched
      else
        linktext =  matched.split("|") 
        if linktext[0].empty?
          link = matched
          text = matched
        else
          link = linktext[0]
          text = linktext[1]
        end
      end
      options = { class: 'internal' }
      options[:class] = 'absent' if find_sibling(link).blank?
      h.link_to text, h.wiki_space_wiki_page_path(wiki_space, link), options
    end.html_safe
    # rubocop:enable all
  end
  end
