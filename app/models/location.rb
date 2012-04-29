class Location < ActiveRecord::Base

  belongs_to :group

  validates_presence_of   :name
  validates_presence_of   :keyword
  validates_uniqueness_of :keyword
  validates_format_of     :alert_offsets, :with => /^(\d+(,\d+)*)?$/, :message => "has invalid format. Comma-separated hours please (0,1,25)"

  before_create :init_checked_at
  
  # All locations with feed urls set
  named_scope :with_feed, :conditions => "feed_url IS NOT NULL"
  
  # Returns the array of integers
  def alert_offset_list
    self.alert_offsets.blank? ? [] : self.alert_offsets.split(/\s*,\s*/).map(&:to_i).uniq
  end

  def sponsor
    !group.nil? && group.sponsor
  end
  
  private
  
  # Initializes checked_at
  def init_checked_at
    self.checked_at = Time.now
  end
  
end
