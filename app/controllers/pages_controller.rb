class PagesController < ApplicationController

  def homepage
    now = Time.zone.now
    @number_of_people_entered = Registration.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    @number_of_people_entered_last_hour = Registration.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Registration.where(exited_at: (now - 1.hour)..now).count
  end

end
