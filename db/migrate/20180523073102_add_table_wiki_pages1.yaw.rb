# frozen_string_literal: true

# This migration comes from yaw (originally 20180508082530)
class AddTableWikiPages1 < ActiveRecord::Migration[5.1]
  def change
    create_table :wiki_pages do |t|
      t.references :wiki, foreign_key: true
      t.string :path, null: false
      t.timestamps
    end
    add_index :wiki_pages, :path, unique: true
  end
end
