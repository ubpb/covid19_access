class Admin::Registrations::ApplicationController < Admin::ApplicationController

  before_action :load_registration

private

  def load_registration
    @registration = Registration.find(params[:registration_id])
  end

end
