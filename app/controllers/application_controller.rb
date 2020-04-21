class ApplicationController < ActionController::Base

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

end
