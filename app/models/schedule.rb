class Schedule

  MSG_LENGTH = 160
  
  attr_reader :timezone
  
  # Initializes the model with some calendar
  def initialize(location)
    @location = location
    if location.nil? || location.alert_offsets.blank?
      @calendar = nil
      @timezone = nil
    else
      @calendar = Schedule.init_calendar(location.vcalendar)
      @timezone = Schedule.get_timezone(@calendar)
    end
  end
  
  # Returns messages array to send for the time frame since the given #time#
  # to the present.
  def messages_to_send_since(start_time, end_time = Time.now)
    return [] if @calendar.nil?

    messages = []
    
    @location.alert_offset_list.each do |offset|
      events = events_in_range(start_time + offset.hours, end_time + offset.hours)
      unless events.empty?
        suffix    = Schedule.offset_to_suffix(offset)
        messages += events.map do |event|
          compose_message(event, suffix, @location.sponsor)
        end
      end
    end
    
    return messages
  end
  
  private
  
  # Initializes calendar from data
  def self.init_calendar(data)
    return nil if data.blank?
    calendars = Vpim::Icalendar.decode(data)
    calendars.first
  rescue => e
    # Log the error somewhere
    return nil
  end
  
  # Returns the timezone if present in the calendar feed
  def self.get_timezone(calendar)
    field = calendar.fields.find { |f| f.name == 'X-WR-TIMEZONE' }
    field.nil? ? nil : TZInfo::Timezone.get(field.value)
  rescue => e
    return nil
  end
  
  # Returns time in the feed timezone or time itself
  def self.with_timezone(time, timezone)
    timezone.nil? ? time : timezone.utc_to_local(time)
  end
  
  # Returns suffix with textual description of the offset
  def self.offset_to_suffix(offset)
    return "" if offset == 0

    now  = Time.now
    nxt  = now + offset.hours
    diff = (nxt.beginning_of_day - now.beginning_of_day) / 1.day.to_i
    
    if diff < 1
      return "today"
    elsif diff < 2
      return "tomorrow"
    else
      return "in #{diff.to_i} days"
    end
  end
  
  # Returns events with alerts in the given time frame
  def events_in_range(start_time, end_time)
    @calendar.components(Vpim::Icalendar::Vevent).select do |event|
      event_in_range(event, start_time, end_time)
    end
  end

  # Returns TRUE if an event is in range. All-day events are checked as starting at 8am.
  def event_in_range(event, start_time, end_time)
    occurs = event.occurs_in?(start_time, end_time)
    if occurs
      if event.duration == 1.day 
        mark = start_time.beginning_of_day + 8.hours
      else
        offs = event.dtstart - event.dtstart.beginning_of_day
        mark = start_time.beginning_of_day + offs
      end
      
      return start_time < mark && mark <= end_time
    else
      return occurs
    end
  end

  def compose_message(event, suffix, sponsor)
    text = event.description || event.summary
    
    unless suffix.blank?
      t = Schedule.with_timezone(event.dtstart, @timezone)
      suffix = " (#{suffix}, #{t.to_s(:message)})"
    end

    unless sponsor.blank?
      max_text_len = MSG_LENGTH - (sponsor.length + 1) - (suffix.to_s.length + 1)
      sponsor      = "\n#{sponsor}"
      text         = text[0, max_text_len]
    end
    
    [ text, suffix, sponsor ].reject(&:blank?).join
  end
end