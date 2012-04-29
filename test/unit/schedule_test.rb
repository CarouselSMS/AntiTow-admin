require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase

  context "offset to suffix" do
    should "return nothing for a 0-offset" do
      assert_equal "", Schedule.offset_to_suffix(0)
    end
    
    should "return 'today'" do
      offs = (Time.now.end_of_day - Time.now) / 2 / 1.hour
      assert_equal "today", Schedule.offset_to_suffix(offs)
    end
    
    should "return 'tomorrow'" do
      offs = ((Time.now.end_of_day - Time.now) + 1.hour) / 1.hour
      assert_equal "tomorrow", Schedule.offset_to_suffix(offs)
    end
    
    should "return 'in 3 days'" do
      offs = ((Time.now.end_of_day - Time.now) + 1.hour + 2.days) / 1.hour
      assert_equal "in 3 days", Schedule.offset_to_suffix(offs)
    end
  end

  context "init calendar" do
    setup do
      @location = Location.new(:vcalendar => get_calendar_data)
      @calendar = Schedule.send(:init_calendar, @location.vcalendar)
    end
    
    should "return a working calendar" do
      assert_not_nil @calendar
    end
    
    should "contain two events" do
      assert_equal 2, @calendar.components(Vpim::Icalendar::Vevent).size
    end
  end

  context "events in range" do
    setup do
      @location = Location.new(:vcalendar => get_calendar_data(Date.today, mktime_today(5)), :alert_offsets => "0")
      @schedule = Schedule.new(@location)
    end
    
    should "return all-day even when in range 7:45am 8:15am" do
      events = @schedule.send(:events_in_range, mktime_today(7, 45), mktime_today(8, 15))
      assert_equal [ "All day" ], events.map(&:summary)
    end
    
    should "return timely event when in range 4:45am 5:15am" do
      events = @schedule.send(:events_in_range, mktime_today(4, 45), mktime_today(5, 15))
      assert_equal [ "Timely" ], events.map(&:summary)
    end
    
    should "not return any events when in range 4:30am 4:59am" do
      events = @schedule.send(:events_in_range, mktime_today(4, 30), mktime_today(4, 59))
      assert events.empty?
    end
  end
  
  context "messages to send since" do
    setup do
      @group    = Group.create(:name => "g", :sponsor => "SPONSOR")
      @location = Location.new(:vcalendar => get_calendar_data(Date.today, mktime_today(5)), :alert_offsets => "0,1,25", :group_id => @group.id)
      @schedule = Schedule.new(@location)
    end

    should "pick events for 0hr" do
      messages  = @schedule.messages_to_send_since(mktime_today(4, 55), mktime_today(5, 10))
      assert_equal [ "Full description\nSPONSOR" ], messages
    end
    
    should "pick events for -1hr" do
      messages  = @schedule.messages_to_send_since(mktime_today(3, 55), mktime_today(4, 10))
      assert_equal [ "Full description (today, 08:00AM)\nSPONSOR" ], messages
    end
    
    should "pick events for -25hrs" do
      messages  = @schedule.messages_to_send_since(mktime_today(3, 55) - 1.day, mktime_today(4, 10) - 1.day)
      assert_equal [ "Full description (tomorrow, 08:00AM)\nSPONSOR" ], messages
    end
    
    should "pick events next week at 0hr" do
      messages  = @schedule.messages_to_send_since(mktime_today(4, 55) + 7.days, mktime_today(5, 10) + 7.days)
      assert_equal [ "Full description\nSPONSOR" ], messages
    end
    
    should "return summary if no description is entered" do
      messages  = @schedule.messages_to_send_since(mktime_today(7, 55), mktime_today(8, 10))
      assert_equal [ "All day\nSPONSOR" ], messages
    end
  end
  
  context "time zones" do
    should "return correct timezone" do
      cal = get_calendar
      assert_equal TZInfo::Timezone.get("America/New_York"), Schedule.send(:get_timezone, cal)
    end
    
    should "return time in correct timezone" do
      tz = TZInfo::Timezone.get("America/New_York")
      now = Time.now.hour
      assert_equal now - 4, Schedule.send(:with_timezone, Time.now, tz).hour
    end
  end
  
  context "sponsor messages" do
    setup do
      @location = Location.new(:vcalendar => get_calendar_data(Date.today, mktime_today(5)), :alert_offsets => "0,1,25")
      @schedule = Schedule.new(@location)

      @dtstart  = Time.parse("10am UTC")
      @time     = Schedule.with_timezone(@dtstart, @schedule.timezone).to_s(:message)
    end

    should "combine all components" do
      event = stub(:description => "description", :dtstart => @dtstart)
      assert_equal "description (today, #{@time})\nBrought to you by ...",
        @schedule.send(:compose_message, event, 'today', 'Brought to you by ...')
    end
    
    should "trim text to fix sponsor message" do
      event = stub(:description => 'D' * 200, :dtstart => @dtstart)
      assert_equal "#{'D' * 120} (today, #{@time})\nBrought to you by ...",
        @schedule.send(:compose_message, event, 'today', 'Brought to you by ...')
    end
  end
  
  # Returns the calendar data
  def get_calendar_data(date = Date.today, time = Time.now)
    data = File.open("#{RAILS_ROOT}/test/fixtures/simple.ics").read
    data.gsub!("{DATE}", date.to_s(:vcalendar_date))
    data.gsub!("{DATE2}", (date + 1.day).to_s(:vcalendar_date))
    data.gsub!("{DATETIME}", time.to_s(:vcalendar_time))
    data.gsub!("{DATETIME2}", (time + 1.hour).to_s(:vcalendar_time))
    data
  end
  
  def mktime_today(h, m = 0)
    Time.now.beginning_of_day + h.hours + m.minutes
  end
  
  def get_calendar
    Schedule.send(:init_calendar, File.open("#{RAILS_ROOT}/test/fixtures/neil.ics").read)
  end
end