class CreateLinksUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :links, :users do |t|
      t.index [:link_id, :user_id], unique: true
    end
  end
end
