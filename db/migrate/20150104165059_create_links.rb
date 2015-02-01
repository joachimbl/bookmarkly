class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :favicon_url
      t.string :provider_name
      t.string :provider_url
      t.text :html
      t.string :thumbnail_url
      t.integer :media_type

      t.timestamps null: false
    end
  end
end
