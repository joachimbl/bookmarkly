class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :link, index: true
      t.text :body
      t.references :user, index: true, null: false
      t.references :parent
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end

  end

  def self.down
    drop_table :comments
  end
end
