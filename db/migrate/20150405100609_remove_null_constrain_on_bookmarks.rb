class RemoveNullConstrainOnBookmarks < ActiveRecord::Migration
  def change
    change_column_null :bookmarks, :link_id, true
    change_column_null :bookmarks, :user_id, true
  end
end
