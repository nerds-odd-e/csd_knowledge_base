# frozen_string_literal: true
# frozen_string_literal: true

class WikiPage < ApplicationRecord
  delegate :title=, :body=, :user=, to: :dirty_revision
  after_save :reset_dirty_revision
  belongs_to :wiki_space, required: true, inverse_of: :wiki_pages
  validates :path, uniqueness: { scope: :wiki_space_id }
  has_many :wiki_page_revisions,
           -> { order id: :desc },
           autosave: true,
           inverse_of: :wiki_page

  def current_revision
    @dirty_revision || wiki_page_revisions.first
  end

  def to_param
    path
  end

  delegate :body, to: :current_revision, allow_nil: true
  def title
    current_revision&.title || path&.split('/')&.last
  end

  delegate :render_body, to: :decorate

  def find_sibling(path)
    wiki_space.wiki_pages.find_by(path: path)
  end

  private

  def dirty_revision
    @dirty_revision ||= wiki_page_revisions.build
  end

  def reset_dirty_revision
    @dirty_revision = nil
  end
  end
