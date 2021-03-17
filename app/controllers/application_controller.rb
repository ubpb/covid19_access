class ApplicationController < ActionController::Base

  helper_method :current_user

  def current_user
    @current_user ||= begin
      if user_id = session[:current_user_id]
        User.find_by(id: user_id)
      end
    end
  end

  def load_global_stats(now = Time.zone.now)
    @number_of_people_entered = Registration.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    @number_of_people_entered_last_hour = Registration.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Registration.where(exited_at: (now - 1.hour)..now).count
    @opening_time, @closing_time = Reservation.get_opening_and_closing_times(Time.zone.today)
  end

  def get_filtered_barcode(barcode)
    if barcode.present?
      filter_proc = ->(barcode) { barcode.gsub(/\s+/, "").upcase } # default filter proc

      if filter_proc_string = Rails.configuration.application.barcode_filter_proc
        filter_proc = eval(filter_proc_string)
      end

      filter_proc.(barcode)
    end
  end

private

  def authenticate!
    redirect_to(new_session_path) unless current_user
  end

end
