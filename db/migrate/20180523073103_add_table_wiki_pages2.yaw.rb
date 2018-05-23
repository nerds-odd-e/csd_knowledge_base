# This migration comes from yaw (originally 20180508082549)
class AddTableWikiPages2 < ActiveRecord::Migration[5.1]
  def change
    create_table :wiki_page_revisions do |t|
      t.references :user, foreign_key: true, type: :integer
      t.references :wiki_page, foreign_key: true
      t.string :title
      t.text :body
      t.timestamps
    end
  end
end
