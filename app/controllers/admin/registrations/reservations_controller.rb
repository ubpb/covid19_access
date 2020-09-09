class Admin::Registrations::ReservationsController < Admin::Registrations::ApplicationController

  def allocate
    # Load reservation
    reservation = @registration.todays_reservations.find(params[:id])
    # TODO: Check reservation is valid

    # Get resource from reservation
    resource = reservation.resource

    Resource.transaction do
      # Release existing allocation if resource is currently allocated
      resource.allocation.release if resource.allocated?
      # Create new allocation for reservation
      allocation = @registration.allocations.build
      allocation.resource = resource
      allocation.created_at = Time.zone.now

      if allocation.save && reservation.destroy
        flash[:success] = "Reservierung erfolgreich in Belegung umgewandelt"
      else
        flash[:error] = "Fehler: Reservierung konnte nicht in eine Belegung umgewandelt werden"
      end
    end

    redirect_to(admin_registration_path(@registration))
  end

end
