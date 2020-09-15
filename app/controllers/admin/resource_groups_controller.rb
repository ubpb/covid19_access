class Admin::ResourceGroupsController < Admin::ApplicationController

  def index
    @resource_groups = ResourceGroup.includes(:resources).order(:title)
  end

  def new
    @resource_group = ResourceGroup.new
  end

  def create
    @resource_group = ResourceGroup.new(permitted_params)

    if @resource_group.save
      flash[:success] = "Neue Ressource-Gruppe gespeichert."
      redirect_to(admin_resource_groups_path)
    else
      render :new
    end
  end

  def edit
    @resource_group = ResourceGroup.find(params[:id])
  end

  def update
    @resource_group = ResourceGroup.find(params[:id])

    if @resource_group.update(permitted_params)
      flash[:success] = "Ressource-Gruppe gespeichert."
      redirect_to(admin_resource_groups_path)
    else
      render :edit
    end
  end

  def destroy
    Resource.transaction do
      @resource_group = ResourceGroup.find(params[:id])

      if @resource_group.resources.exists?
        flash[:error] = "Ressource-Gruppe kann nicht gelöscht werden, weil Ressourcen zugeordnet sind."
      elsif @resource_group.destroy
        flash[:success] = "Ressource-Gruppe gelöscht."
      else
        flash[:success] = "Fehler: Ressource-Gruppe konnte nicht gelöscht werden."
      end

      redirect_to(admin_resource_groups_path)
    end
  end

private

  def permitted_params
    params.require(:resource_group).permit(:title)
  end

end
