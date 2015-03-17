class AddPrivateLinks < ActiveRecord::Migration
  def change
    add_column :links, :private, :boolean, null: false, default: false
  end
end
