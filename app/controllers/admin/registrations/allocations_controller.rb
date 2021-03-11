class Admin::Registrations::AllocationsController < Admin::Registrations::ApplicationController

  def index
    redirect_to(admin_registration_path(@registration))
  end

  def new
    Resource.transaction do
      can_create_allocation? or return

      @allocation = @registration.allocations.build
      @resource_locations = ResourceLocation.eager_load(
        resources: [:resource_group, :allocation, :reservations]
      ).order(:title)
      @allocated_resource_ids = Resource.joins(:allocation).pluck(:id)
    end
  end

  def create
    Resource.transaction do
      can_create_allocation? or return

      permitted_params = params.require(:allocation).permit(:resource_id)

      was_reserved = params[:allocation][:was_reserved]
      resource = Resource.find(permitted_params[:resource_id])

      if !resource.allocatable?
        flash[:error] = "Die Ressource steht aktuell nicht zur Verfügung und kann nicht belegt werden."
        redirect_to(new_admin_registration_allocation_path(@registration))
      elsif resource.reserved_today? && was_reserved == "false"
        flash[:error] = "Die Ressource wurde in der Zwischenzeit reserviert. Bitte Auswahl prüfen."
        redirect_to(new_admin_registration_allocation_path(@registration))
      else
        @allocation = @registration.allocations.build(permitted_params)
        @allocation.created_at = Time.zone.now

        if @allocation.save
          flash[:success] = "Ressource erfolgreich zugeordnet"
          redirect_to(print_admin_registration_allocation_path(@registration, @allocation))
        else
          flash[:error] = "Ressource wurde in der Zwischenzeit belegt. Bitte einen anderen Platz auswählen."
          redirect_to(new_admin_registration_allocation_path(@registration))
        end
      end
    end
  end

  def destroy
    Resource.transaction do
      allocation = @registration.allocations.find(params[:id])

      if allocation && allocation.release
        flash[:success] = "Ressource erfolgreich freigegeben"
      else
        flash[:error] = "Fehler: Ressource konnte nicht freigegeben werden"
      end

      redirect_to(admin_registration_allocations_path(@registration))
    end
  end

  def print
    @allocation = @registration.allocations.includes(resource: [:resource_group, :resource_location, :reservations]).find(params[:id])
  end

private

  def can_create_allocation?
    if @registration.closed? # Person has left the building
      flash[:error] = "Für eine abgeschlossene Registrerung (Person wurde ausgecheckt) kann keine Ressource zugeordnet werden."
      redirect_to(admin_registration_allocations_path(@registration))
      return false
    else
      return true
    end
  end

end
