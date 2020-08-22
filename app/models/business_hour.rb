class BusinessHour < ApplicationRecord
  before_save :check_close_time

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

  def display_time(time)
    time_matches = /(\d)(\d{2})(\d{2})/.match(time.to_s)
    week = time_matches[1]
    hour = time_matches[2]
    min = time_matches[3]
    "#{Date::DAYNAMES[week.to_i]}, #{hour}:#{min}"
  end

end
