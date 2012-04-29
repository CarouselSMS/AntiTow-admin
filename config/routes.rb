ActionController::Routing::Routes.draw do |map|

  map.resources   :locations
  map.resources   :groups
  
  map.root        :controller => "locations"
  
end
