class Admin::ApplicationController < ApplicationController

  before_action :authenticate!

  def stats
    setup_stats

    render partial: "admin/application/stats", locals: {
      number_of_people_entered: @number_of_people_entered,
      max_number_of_people: @max_number_of_people
    }
  end

  def log
    setup_log

    render partial: "admin/application/log", locals: {
      last_registrations: @last_registrations
    }
  end

private

  def authenticate!
    config_username = Rails.configuration.application.username
    config_password = Rails.configuration.application.password

    if config_username.present? && config_password.present?
      authenticate_or_request_with_http_basic do |username, password|
        secure_password = BCrypt::Password.new(
           BCrypt::Password.create(password)
        )

        username == config_username && secure_password == config_password
      end
    else
      false
    end
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

  def setup_stats
    @number_of_people_entered = Registration.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    now = Time.zone.now
    @number_of_people_entered_last_hour = Registration.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Registration.where(exited_at: (now - 1.hour)..now).count
  end

  def setup_log
    @last_registrations = Registration.order("updated_at desc").limit(10)
  end

end
