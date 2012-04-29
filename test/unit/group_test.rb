require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "grouping of locations" do
    l = Location.create(:name => "n", :keyword => "k")
    g = Group.create(:name => "g")
    g.locations << l
    g.reload
    assert_equal l, g.locations.first
  end

end
