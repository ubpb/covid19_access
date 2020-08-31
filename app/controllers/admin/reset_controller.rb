class Admin::ResetController < Admin::ApplicationController

  def create
    Registration.where(exited_at: nil).each do |reg|
      reg.close
    end

    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
