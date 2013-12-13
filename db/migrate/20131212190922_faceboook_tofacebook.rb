class FaceboookTofacebook < ActiveRecord::Migration
  def up
	rename_column :restaurants, :faceboook_url, :facebook_url
  end
  def down
	rename_column :restaurants, :facebook_url, :faceboook_url
  end
end
