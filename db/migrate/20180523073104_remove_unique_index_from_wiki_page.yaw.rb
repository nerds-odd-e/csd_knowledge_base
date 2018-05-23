# This migration comes from yaw (originally 20180509041839)
class RemoveUniqueIndexFromWikiPage < ActiveRecord::Migration[5.1]
  def change
    remove_index :wiki_pages, column: :path
  end
end
