# Updates feeds of all location calendars
class FeedUpdater
  
  # Updates all location feeds
  def update_all
    Location.with_feed.each { |l| update(l) }
  end
  
  # Updates location feed
  def update(location)
    puts "Updating: #{location.name} (#{location.keyword})"
    
    # Update location record
    location.vcalendar = read_vcalendar(location)
    location.feed_updated_at = Time.now
    location.save
  rescue => e
    # Report somewhere
  end

  private
  
  # Returns associated vcalendar feed text
  def read_vcalendar(location)
    uri = URI.parse(location.feed_url)
    res = Net::HTTP.get_response(uri)
    res.body
  end

end