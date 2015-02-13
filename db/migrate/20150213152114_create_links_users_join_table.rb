class CreateLinksUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :links, :users do |t|
      t.index :link_id
      t.index :user_id
    end
  end
end
