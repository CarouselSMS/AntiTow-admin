require 'test_helper'

class LocationsControllerTest < ActionController::TestCase

  setup do
    setup
    
  end
  
  context "index" do
    setup { login; get :index }
    should_assign_to(:locations) { Location.all }
    should_render_template :index
  end

  context "new" do
    setup { login; get :new }
    should_assign_to(:location)
    should_render_template :new
  end

  context "create" do
    setup { login }
    context "valid" do
      setup { get :create, :location => { :name => "business", :keyword => "business" }}
      should "create record" do
        assert_not_nil Location.find_by_name("business")
      end
      should_redirect_to("Locations") { locations_url }
    end
    
    context "invalid" do
      setup { get :create, :location => { } }
      should_render_template :new
    end
  end

  context "edit" do
    setup do
      login
      get :edit, :id => locations(:downtown).id
    end
    should_assign_to(:location) { locations(:downtown) }
    should_render_template :edit
  end
  
  context "update" do
    setup { login }
    context "valid" do
      setup do
        get :update, :id => locations(:downtown).id, :location => { :name => "new name" }
      end
      should_redirect_to("Location") { location_url(locations(:downtown)) }
      should "update db" do
        location = locations(:downtown)
        location.reload
        assert_equal "new name", location.name
      end
    end
    
    context "feed link change" do
      setup do
        get :update, :id => locations(:downtown).id, :location => { :feed_url => "new feed url" }
      end
      should "reset timestamps and cached vcalendar" do
        time = Time.now.to_i
        loc = locations(:downtown)
        loc.reload
        
        assert_not_nil  loc.checked_at
        assert          loc.checked_at.to_i >= time
        assert_nil      loc.feed_updated_at
        assert_nil      loc.vcalendar
      end
    end
    
    context "invalid" do
      setup do
        get :update, :id => locations(:downtown).id, :location => { :name => "" }
      end
      should_render_template :edit
    end
  end

  context "show" do
    setup do
      login
      get :show, :id => locations(:downtown).id
    end
    should_assign_to(:location) { locations(:downtown) }
    should_render_template :show
  end

  context "destroy" do
    setup do
      login
      get :destroy, :id => locations(:downtown).id
    end
    should_change "Location.count", :by => -1
    should_redirect_to("Locations list") { locations_url }
  end

end
