namespace :antitow do
  
  desc "Updates all feeds"
  task :update_feeds => :environment do
    begin
      Lockfile.new("#{RAILS_ROOT}/log/update_feeds.lock", :retries => 0) do
        fu = FeedUpdater.new
        fu.update_all
      end
    rescue Lockfile::MaxTriesLockError => e
      # Clean exit, another task is running
    end
  end
  
  desc "Checks all locations and sends corresponding messages"
  task :send_messages => :environment do
    begin
      Lockfile.new("#{RAILS_ROOT}/log/send_messages.lock", :retries => 0) do
        Location.with_feed.each do |location|
          schedule = Schedule.new(location)
          messages = schedule.messages_to_send_since(15.minutes.ago)
          Messenger.send_messages(location, messages)
          
          location.update_attribute(:checked_at, Time.now)
        end
      end
    rescue Lockfile::MaxTriesLockError => e
      # Clean exit, another task is running
    end
  end
end