class AddBlacklistToWhitelistItems < ActiveRecord::Migration
  def change
    add_column :whitelist_items, :blacklist, :boolean
  end
end
