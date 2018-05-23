# This migration comes from yaw (originally 20180509093458)
class RenameTableWikisToWikiSpaces < ActiveRecord::Migration[5.1]
  def change
    rename_table :wikis, :wiki_spaces
  end
end
