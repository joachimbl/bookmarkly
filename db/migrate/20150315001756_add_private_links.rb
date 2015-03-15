class AddPrivateLinks < ActiveRecord::Migration
  def change
    add_column :links, :private_links, :string
  end
end
