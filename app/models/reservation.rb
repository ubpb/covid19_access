class Reservation < ApplicationRecord

  # Relations
  belongs_to :user
  belongs_to :resource

  # Validations
  validates :begin_date, presence: true


  def self.next_reservable_dates
    opening_hours = Rails.application.config.application.opening_hours || {}
    special_closing_dates = Rails.application.config.application.special_closing_dates || []

    day = Time.zone.today
    now = Time.zone.now
    reservable_dates = []
    tries = 0 # To protect against infinite loop due to improper config

    loop do
      # Check if generally open the tested day
      dayname = day.strftime("%A").downcase.to_sym
      is_generally_open = opening_hours[dayname].present?

      # In case we are open, check if already closed due to current time.
      # We only allow reservations if at least one hour until closing.
      already_closed = false
      if day == Time.zone.today
        opening_time, closing_time = self.get_opening_and_closing_times(day)
        already_closed = true if now > (closing_time - 1.hour)
      end

      # Check if the tested day is a special closing day
      is_special_closing_day = special_closing_dates.include?(day)

      # The tested day is reservable if open
      if is_generally_open && !already_closed && !is_special_closing_day
        reservable_dates << day
      end

      # Check / Setup the loop
      day += 1.day
      tries += 1
      break if reservable_dates.count >= 4
      break if tries >= 100
    end

    # Return our list of reservable dates
    reservable_dates
  end

  def self.get_opening_and_closing_times(date)
    opening_hours = Rails.application.config.application.opening_hours || {}
    dayname = date.strftime("%A").downcase.to_sym
    open_time_string, close_time_string = opening_hours[dayname].split("-")
    open_time = Time.zone.parse(open_time_string)
    close_time = Time.zone.parse(close_time_string)

    [open_time, close_time]
  end

  def allocateable?
    self.begin_date - 15.minutes <= Time.zone.now
  end

end
