class Admin::RegistrationsController < Admin::ApplicationController

  def index
    if @barcode = get_filtered_barcode(params.dig("scan_form", "barcode")).presence
      @filtered = true
      @registrations = Registration.where(barcode: @barcode).order("entered_at desc")
    end

    @last_registrations = Registration.where(exited_at: nil).order("entered_at desc").limit(10)
  end

  def show
    @registration = Registration.find(params[:id])
    @allocations = @registration.allocations.includes(resource: [:resource_group, :resource_location])
    @released_allocations = @registration.released_allocations.includes(resource: [:resource_group, :resource_location])
  end

  def edit
    @registration = Registration.find(params[:id])
  end

  def update
    # Permit params
    permitted_params = params.require(:registration).permit(
      :street, :city, :phone, :entered_at, :exited_at
    )

    @registration = Registration.find(params[:id])

    if @registration.update_attributes(permitted_params)
      flash[:success] = "Registrierung erfolgreich gespeichert."
      redirect_to(admin_registration_path(@registration))
    else
      render :edit
    end
  end

end
