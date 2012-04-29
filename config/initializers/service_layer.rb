# The service layer URL
SERVICE_LAYER_API_URL = ENV['RAILS_ENV'] == 'production' ? "http://sl.recessmobile.com/api" : "http://localhost:4000/api"

# The key from the service layer that is used for communication
SERVICE_LAYER_API_KEY = ENV['RAILS_ENV'] == 'production' ? "[YOUR API KEY]" : ""