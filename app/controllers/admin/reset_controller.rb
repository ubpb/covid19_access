class Admin::ResetController < Admin::ApplicationController

  def create
    Registration.where(exited_at: nil).each do |p|
      p.update_attribute(:exited_at, p.entered_at.end_of_day)
    end

    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
