# frozen_string_literal: true
class WikiLink
  attr_accessor :link, :text
  def escape_from_pipe(wiki_link_raw)
    if wiki_link_raw.include?('\\\\|')
      @link.gsub!('\\|', "|")
      textlink = @link.split("|")
      @link = textlink[0]
      @text = textlink[1]
      return true
    elsif wiki_link_raw.include?('\\|')
      @link.delete!("\\")
      return true
    end
    false
  end

  def coloner(wiki_link_raw)
    if wiki_link_raw.split(":").length == 2
      @link = wiki_link_raw.gsub(":", "/")
      @text = wiki_link_raw.split(":")[1]
      return true
    end
    false
  end

  def invalid_pipe(wiki_link_raw)
    if wiki_link_raw.first == "|" || wiki_link_raw.last == "|"
      return true
    end
    false
  end

  def construct(wiki_link_raw) 
    @link = wiki_link_raw
    @text = wiki_link_raw
    if escape_from_pipe(wiki_link_raw) || invalid_pipe(wiki_link_raw) || coloner(wiki_link_raw)
      return
    end
    a = wiki_link_raw.split("|")
    if a.length == 2
      if wiki_link_raw.split("\\").length < 2
        @link = a[0]
        @text = a[1]
      end
    end
  end

end

class WikiPageDecorator < Draper::Decorator
  delegate_all
  def render_body
    # rubocop:disable all
    render_body_html_unsafe
    # rubocop:enable all
  end
  
  private
  def get_link_text(matched)
    wikilink = WikiLink.new
    wikilink.construct(matched)

    return wikilink.link, wikilink.text
  end

  def get_ancor(link)
    ancor = link
    ancorlink = link.split("#")
    if ancorlink.length == 2
      ancor = ancorlink[0]
    end
    ancor
  end

  def render_body_html_unsafe
    nowiki_reg = /<nowiki>(\[\[[^\]]+\]\])<\/nowiki>/
    body.gsub(nowiki_reg) do |match|
      return match[nowiki_reg, 1]
    end
    link_reg = /\[\[([^\]]+)\]\]/
    body.gsub(link_reg) do |match|
      matched = match[link_reg, 1]
      link, text = get_link_text(matched)

      options = { class: 'internal' }
      options[:class] = 'absent' if find_sibling(get_ancor(link)).blank?

      h.link_to text, h.wiki_space_wiki_page_path(wiki_space, link), options
    end.html_safe
  end
  
end
