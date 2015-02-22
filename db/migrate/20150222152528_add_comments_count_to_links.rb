class AddCommentsCountToLinks < ActiveRecord::Migration
  def change
    add_column :links, :comments_count, :integer, null: false, default: 0
  end
end
