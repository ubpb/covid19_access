class Admin::ApplicationController < ApplicationController

  before_action :authenticate!

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

end
