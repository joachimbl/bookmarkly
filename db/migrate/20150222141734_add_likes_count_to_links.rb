class AddLikesCountToLinks < ActiveRecord::Migration
  def change
    add_column :links, :likes_count, :integer, null: false, default: 0
  end
end
