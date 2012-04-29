require 'test_helper'

class FeedUpdaterTest < ActiveSupport::TestCase

  should "pick all calendars for updates" do
    @fu = FeedUpdater.new

    locations = Location.with_feed
    locations.each { |location| @fu.expects(:update).with(location) }

    @fu.update_all
  end

  should "request calendar feed text" do
    now = Time.now.to_i
    @fu = FeedUpdater.new
    
    location = Location.with_feed.first
    @fu.expects(:read_vcalendar).with(location).returns("new vcal")
    
    @fu.update(location)
    location.reload
    
    assert_equal "new vcal", location.vcalendar
    assert       location.feed_updated_at.to_i >= now
  end
  
end