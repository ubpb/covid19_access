class Admin::ResetController < Admin::ApplicationController

  def create
    Person.reset(Time.zone.now.end_of_day)
    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
