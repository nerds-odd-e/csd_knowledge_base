# frozen_string_literal: true

# This migration comes from yaw (originally 20180509042022)
class AddIndexFromWikiPage < ActiveRecord::Migration[5.1]
  def change
    add_index :wiki_pages, :path
  end
end
