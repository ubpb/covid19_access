class Admin::ResetController < Admin::ApplicationController

  def create
    Registration.reset
    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
