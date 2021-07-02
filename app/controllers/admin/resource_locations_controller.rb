class Admin::ResourceLocationsController < Admin::ApplicationController

  def index
    @resource_locations = ResourceLocation.includes(:resources).order(:title)
  end

  def new
    @resource_location = ResourceLocation.new
  end

  def create
    @resource_location = ResourceLocation.new(permitted_params)

    if @resource_location.save
      flash[:success] = "Neuen Ressource-Bereich gespeichert."
      redirect_to(admin_resource_locations_path)
    else
      render :new
    end
  end

  def edit
    @resource_location = ResourceLocation.find(params[:id])
  end

  def update
    @resource_location = ResourceLocation.find(params[:id])

    if @resource_location.update(permitted_params)
      flash[:success] = "Ressource-Bereich gespeichert."
      redirect_to(admin_resource_locations_path)
    else
      render :edit
    end
  end

  def destroy
    Resource.transaction do
      @resource_location = ResourceLocation.find(params[:id])

      if @resource_location.deleteable? && @resource_location.destroy
        flash[:success] = "Ressource-Bereich gelöscht."
      else
        flash[:error] = "Fehler: Ressource-Bereich konnte nicht gelöscht werden."
      end

      redirect_to(admin_resource_locations_path)
    end
  end

private

  def permitted_params
    params.require(:resource_location).permit(:title, :disable_dates)
  end

end
