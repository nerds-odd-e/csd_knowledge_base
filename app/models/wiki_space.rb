# frozen_string_literal: true
# frozen_string_literal: true

class WikiSpace < ApplicationRecord
  has_many :wiki_pages, inverse_of: :wiki_space, dependent: :destroy
  def to_param
    title
  end
  end
