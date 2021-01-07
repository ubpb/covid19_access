class Reservation < ApplicationRecord

  # Relations
  belongs_to :user
  belongs_to :resource

  # Validations
  validates :begin_date, presence: true


  def self.next_reservable_dates
    reservation_enabled = Rails.application.config.application.reservation_enabled || false

    day = Time.zone.today
    now = Time.zone.now
    special_closing_dates = Rails.application.config.application.special_closing_dates || []
    reservable_dates = []

    if reservation_enabled
      tries = 0 # To protect against infinite loop due to improper config

      loop do
        # Check if generally open the tested day
        dayname = day.strftime("%A").downcase.to_sym
        opening_time, closing_time = self.get_opening_and_closing_times(day)
        is_generally_open = opening_time.present? && closing_time.present?

        # In case we are open today, check if already closed due to current time.
        already_closed = is_generally_open && day == Time.zone.today && now >= closing_time

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

      # Remove dates that are too far (> 5 days) in the future
      #reservable_dates = reservable_dates.reject{|date| date > Time.zone.today + 5.days}
    end

    # Return our list of reservable dates
    reservable_dates
  end

  def self.get_opening_and_closing_times(date)
    opening_hours         = Rails.application.config.application.opening_hours || {}
    special_opening_hours = Rails.application.config.application.special_opening_hours || []
    special_closing_dates = Rails.application.config.application.special_closing_dates || []
    dayname = date.strftime("%A").downcase.to_sym

    unless special_closing_dates.include?(date) # Ignore days that are listed as closed
      # Regular times
      opening_time_string, closing_time_string = opening_hours[dayname]&.to_s&.split("-")

      # Check for special times
      if special_hours = special_opening_hours.find{ |t| t[:date] == date}
        opening_time_string, closing_time_string = special_hours&.to_s&.split("-")
      end

      # If times are present, try to parse them
      if opening_time_string.present? && closing_time_string.present?
        begin
          opening_time = Time.zone.parse(opening_time_string)
          closing_time = Time.zone.parse(closing_time_string)
          [opening_time, closing_time]
        rescue ArgumentError # error parsing date
          nil
        end
      end
    end
  end

  def allocateable?
    earliest_allocateable_date <= Time.zone.now
  end

  def earliest_allocateable_date
    self.begin_date - 15.minutes
  end

end
