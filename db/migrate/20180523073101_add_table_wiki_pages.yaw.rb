# frozen_string_literal: true

# This migration comes from yaw (originally 20180508080612)
class AddTableWikiPages < ActiveRecord::Migration[5.1]
  def change
    create_table :wikis do |t|
      t.string :title
      t.timestamps
    end
  end
end
