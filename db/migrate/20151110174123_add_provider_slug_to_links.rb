class AddProviderSlugToLinks < ActiveRecord::Migration
  def change
    add_column :links, :provider_slug, :string
    add_index :links, :provider_slug
  end
end
