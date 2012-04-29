require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  should_validate_presence_of   :name, :keyword
  should_validate_uniqueness_of :keyword

  context "creating" do
    should "initialize checked_at with current date time" do
      l = Location.create!(:name => "test", :keyword => "test")
      assert_not_nil l.checked_at

      l.reload
      assert_not_nil l.checked_at
    end
  end
  
  context "alert_offset_list" do
    should "return empty list for no alerts" do
      assert_equal [], Location.new(:alert_offsets => nil).alert_offset_list
      assert_equal [], Location.new(:alert_offsets => "").alert_offset_list
      assert_equal [], Location.new(:alert_offsets => " ").alert_offset_list
    end
    
    should "return single item" do
      assert_equal [ 1 ], Location.new(:alert_offsets => " 1 ").alert_offset_list
    end
    
    should "return deduplicated list" do
      assert_equal [ 1, 2 ], Location.new(:alert_offsets => " 1, 2,1 ").alert_offset_list
    end
    
    should "return ints" do
      assert_equal [ 1, 2 ], Location.new(:alert_offsets => " 1, 2.1 ").alert_offset_list
    end
  end
end
