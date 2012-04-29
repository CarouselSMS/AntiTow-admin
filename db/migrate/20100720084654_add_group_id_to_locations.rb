class AddGroupIdToLocations < ActiveRecord::Migration
  def self.up
    add_column    :locations, :group_id, :integer
    add_index     :locations, :group_id
  end

  def self.down
    remove_index  :locations, :group_id
    remove_column :locations, :group_id
  end
end
