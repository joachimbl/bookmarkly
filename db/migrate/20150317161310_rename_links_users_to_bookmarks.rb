class RenameLinksUsersToBookmarks < ActiveRecord::Migration
  Bookmark = Class.new(ActiveRecord::Base)

  def change
    rename_table :links_users, :bookmarks
    add_column :bookmarks, :id, :primary_key
    add_timestamps(:bookmarks)

    reversible do |dir|
      dir.up do
        Bookmark.all.each do |bookmark|
          bookmark.update(created_at: Time.zone.now, updated_at: Time.zone.now)
        end
      end
    end

    change_column_null(:bookmarks, :created_at, false)
    change_column_null(:bookmarks, :updated_at, false)
  end
end
