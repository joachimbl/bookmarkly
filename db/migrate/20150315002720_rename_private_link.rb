class RenamePrivateLink < ActiveRecord::Migration
  def change
    change_table :links do |t|
      t.rename :private_links, :private_link
    end
  end
end
