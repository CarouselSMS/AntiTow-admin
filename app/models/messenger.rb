class Messenger

  # Sends messages related to a given location to clients
  def self.send_messages(location, messages)
    return if messages.blank? || location.blank?
    
    keyword = location.keyword
    messages.each do |message|
      send_message(keyword, message)
    end
  end

  # Sends a subscription message for a given keyword
  def self.send_message(keyword, message)
    if RAILS_ENV == 'development' || RAILS_ENV == 'test'
      puts "Sending '#{message}' to '#{keyword}'"
    else
      url = SERVICE_LAYER_API_URL + "/send_subscription_message"
      data = {
        :api_key          => SERVICE_LAYER_API_KEY,
        :body             => message,
        :tags             => keyword
      }
    
      Net::HTTP.post_form(URI.parse(url), data)
    end
  end
  
end