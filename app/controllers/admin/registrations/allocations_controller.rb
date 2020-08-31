class Admin::Registrations::AllocationsController < Admin::Registrations::ApplicationController

  def index
    redirect_to(admin_registration_path(@registration))
  end

  def new
    can_create_allocation? or return

    @allocation = @registration.allocations.build
    @resources = Resource.includes(:resource_group, :resource_location)
    @allocated_resource_ids = Resource.joins(:allocations).pluck(:id)
  end

  def create
    can_create_allocation? or return

    permitted_params = params.require(:allocation).permit(:resource_id)
    @allocation = @registration.allocations.build(permitted_params)
    @allocation.created_at = Time.zone.now

    if @allocation.save
      flash[:success] = "Ressource erfolgreich zugeordnet"
    else
      flash[:error] = "Fehler: Ressource konnte nicht zugeordnet werden"
    end

    redirect_to(admin_registration_allocations_path(@registration))
  end

  def destroy
    allocation = @registration.allocations.find(params[:id])

    if allocation && allocation.release
      flash[:success] = "Ressource erfolgreich freigegeben"
    else
      flash[:error] = "Fehler: Ressource konnte nicht freigegeben werden"
    end

    redirect_to(admin_registration_allocations_path(@registration))
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