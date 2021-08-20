class Admin::RegistrationsController < Admin::ApplicationController

  def index
    if @barcode = get_filtered_barcode(params.dig("scan_form", "barcode")).presence
      @filtered = true
      @registrations = Registration.where(barcode: @barcode).order("entered_at desc")
    end
  end

  def show
    @registration = Registration.find(params[:id])
    @allocations = @registration.allocations.includes(resource: [:resource_group, :resource_location])
    @released_allocations = @registration.released_allocations.includes(resource: [:resource_group, :resource_location])
    @todays_reservations = @registration.todays_reservations
  end

  def edit
    @registration = Registration.find(params[:id])
  end

  def update
    # Permit params
    permitted_params = params.require(:registration).permit(
      :street, :city, :phone, :entered_at, :exited_at
    )

    @omit_personal_data = Rails.configuration.application.omit_personal_data_on_checkin || false
    @registration = Registration.find(params[:id])
    @registration.omit_personal_data = @omit_personal_data

    if @registration.update(permitted_params)
      flash[:success] = "Registrierung erfolgreich gespeichert."
      redirect_to(admin_registration_path(@registration))
    else
      render :edit
    end
  end

end
