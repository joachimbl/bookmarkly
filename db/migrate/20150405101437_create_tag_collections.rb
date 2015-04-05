class CreateTagCollections < ActiveRecord::Migration
  def change
    create_table :tag_collections do |t|

      t.timestamps null: false
    end
  end
end
