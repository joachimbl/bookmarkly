class AddPrivateLinksUsers < ActiveRecord::Migration
  def change
    add_column :links_users, :private, :boolean, null: false, default: false
  end
end
