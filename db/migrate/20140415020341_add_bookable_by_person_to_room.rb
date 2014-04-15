class AddBookableByPersonToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :only_group, :boolean
  end
end
