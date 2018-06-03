# frozen_string_literal: true
# frozen_string_literal: true

class WikiPageRevision < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_page, inverse_of: :wiki_page_revisions
  end
