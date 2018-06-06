# frozen_string_literal: true

class WikiPageDecorator < Draper::Decorator
  delegate_all
  def render_body
    # rubocop:disable all
    render_body_html_unsafe
    # rubocop:enable all
  end
  
  private
  def get_link_text(matched)
    link = matched
    text = matched
      if matched.first == "|"
        # do nothing
      elsif matched.last == "|"
        # do nothing
      elsif matched.include?('\\\\|')
        link.gsub!('\\|', "|")
        textlink = link.split("|")
        link = textlink[0]
        text = textlink[1]
      elsif matched.include?('\\|')
        link.delete!("\\")
      elsif matched.split("|").length == 2
        if matched.split("\\").length < 2
          link = matched.split("|")[0]
          text = matched.split("|")[1]
        end
      end

      return link, text
  end

  def render_body_html_unsafe
    link_reg = /\[\[([^\]]+)\]\]/
    body.gsub(link_reg) do |match|
      matched = match[link_reg, 1]
      link, text = get_link_text(matched)

      ancor = link
      ancorlink = link.split("#")
      if ancorlink.length == 2
        ancor = ancorlink[0]
      end
      options = { class: 'internal' }
      options[:class] = 'absent' if find_sibling(ancor).blank?
    
      h.link_to text, h.wiki_space_wiki_page_path(wiki_space, link), options
    end.html_safe
  end
  
end
