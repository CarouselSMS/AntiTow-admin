class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string    :name,          :null => false
      t.string    :keyword,       :null => false
      t.text      :description
      t.text      :vcalendar
      t.string    :feed_url
      t.string    :alert_offsets

      t.datetime  :checked_at
      t.datetime  :feed_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
