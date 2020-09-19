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
      already_closed = false
      if day == Time.zone.today
        opening_time, closing_time = self.get_opening_and_closing_times(day)
        if closing_time
          already_closed = true if now >= closing_time
        end
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
      break if reservable_dates.include?(Time.zone.today) ? reservable_dates.count >= 4 : reservable_dates.count >= 3
      break if tries >= 100
    end

    # Return our list of reservable dates
    reservable_dates
  end

  def self.get_opening_and_closing_times(date)
    opening_hours = Rails.application.config.application.opening_hours || {}
    dayname = date.strftime("%A").downcase.to_sym
    opening_time_string, closing_time_string = opening_hours[dayname]&.split("-")
    opening_time = opening_time_string ? Time.zone.parse(opening_time_string) : nil
    closing_time = closing_time_string ? Time.zone.parse(closing_time_string) : nil

    [opening_time, closing_time]
  end

  def allocateable?
    earliest_allocateable_date <= Time.zone.now
  end

  def earliest_allocateable_date
    self.begin_date - 15.minutes
  end

end
