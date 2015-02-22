class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user
      t.references :link

      t.timestamps null: false
    end
    add_index :likes, [:link_id, :user_id], unique: true

    add_foreign_key :likes, :users
    add_foreign_key :likes, :links
  end
end
