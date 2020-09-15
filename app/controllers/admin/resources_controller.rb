class Admin::ResourcesController < Admin::ApplicationController

  def index
    @resources = Resource
      .joins(:resource_group, :resource_location)
      .order("resource_groups.title, resource_locations.title, resources.title")
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(permitted_params)

    if @resource.save
      flash[:success] = "Neuen Ressource gespeichert."
      redirect_to(admin_resources_path)
    else
      render :new
    end
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])

    if @resource.update(permitted_params)
      flash[:success] = "Ressource gespeichert."
      redirect_to(admin_resources_path)
    else
      render :edit
    end
  end

  def destroy
    Resource.transaction do
      @resource = Resource.find(params[:id])

      if @resource.deleteable? && @resource.destroy
        flash[:success] = "Ressource gelöscht."
      else
        flash[:error] = "Fehler: Ressource konnte nicht gelöscht werden."
      end

      redirect_to(admin_resources_path)
    end
  end

private

  def permitted_params
    params.require(:resource).permit(:resource_group_id, :resource_location_id, :title)
  end

end
