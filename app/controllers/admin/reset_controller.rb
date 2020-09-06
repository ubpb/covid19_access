class Admin::ResetController < Admin::ApplicationController

  def create
    Registration.transaction do
      Registration.where(exited_at: nil).each do |reg|
        reg.update_column(:exited_at, reg.entered_at.end_of_day)
        reg.allocations.each do |allocation|
          allocation.release
        end
      end
    end

    flash[:success] = "Reset erfolgreich durchgeführt."
    redirect_to admin_reset_index_path
  end

end
