class Admin::ResetController < Admin::ApplicationController

  def create
    Registration.transaction do
      Registration.where(exited_at: nil).each do |reg|
        reg.close(reset: true)
      end
    end

    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
