ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :details          => '%A %m/%d/%Y',
  :vcalendar_date   => '%Y%m%d'
)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :details          => '%A %m/%d/%Y at %I:%M:%S%p %Z',
  :message          => '%I:%M%p',
  :vcalendar_time   => '%Y%m%dT%I%M%S'
)