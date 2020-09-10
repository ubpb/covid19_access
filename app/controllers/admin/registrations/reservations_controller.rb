class Admin::Registrations::ReservationsController < Admin::Registrations::ApplicationController

  def allocate
    Resource.transaction do
      # Load reservation
      reservation = @registration.todays_reservations.find(params[:id])

      if reservation.allocateable?
        # Get resource from reservation
        resource = reservation.resource

        # Release existing allocation if resource is currently allocated
        resource.allocation.release if resource.allocated?
        # Create new allocation for reservation
        allocation = @registration.allocations.build
        allocation.resource = resource
        allocation.created_at = Time.zone.now

        if allocation.save && reservation.destroy
          flash[:success] = "Reservierung erfolgreich zugeteilt"
          redirect_to(print_admin_registration_allocations_path(@registration))
        else
          flash[:error] = "Fehler: Reservierung konnte nicht in eine Belegung umgewandelt werden"
        end
      else
        flash[:error] = "Die Reservierung kann erst 15 Minuten vor der Reservierungszeit in Anspruch genommen werden."
        redirect_to(admin_registration_path(@registration))
      end
    end
  end

end