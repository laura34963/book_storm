class BusinessHour < ApplicationRecord
  before_save :check_close_time
  before_save :detect_open_hour

  LARGE_TIME_INT = 70000

  def display_info
    {
      open: display_time(opentime),
      close: display_time(closetime)
    }
  end

  private

  def check_close_time
    return if closetime >= opentime
    self.closetime += LARGE_TIME_INT
  end

  def detect_open_hour
    open_datetime = DateTime.parse(display_time(opentime))
    close_datetime = DateTime.parse(display_time(closetime))
    close_datetime += 7.days if close_datetime < open_datetime
    self.open_hour = (close_datetime - open_datetime) * 1.0 / 60 / 60
  end

  def display_time(time)
    time_matches = /(\d)(\d{2})(\d{2})/.match(time.to_s)
    week = time_matches[1]
    hour = time_matches[2]
    min = time_matches[3]
    "#{Date::DAYNAMES[week.to_i]}, #{hour}:#{min}"
  end

end
