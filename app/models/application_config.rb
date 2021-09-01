class ApplicationConfig

  # TODO: Wrap all config flags from config/application.yml
  # here.

  def self.registration_required?
    rr = Rails.configuration.application.registration_required
    rr = true if rr.nil?
    rr == true
  end

end
