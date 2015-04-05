class CreateTagCollectionsUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :tag_collections, :users do |t|
      t.index [:tag_collection_id, :user_id], unique: true
    end
  end
end
