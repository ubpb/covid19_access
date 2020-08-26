class Admin::EntriesController < Admin::ApplicationController

  def index
  end

  def create
    if ilsid = get_filtered_ilsid(params[:scan_form][:ilsid]).presence
      redirect_to(admin_new_registration_path(ilsid: ilsid))
    else
      redirect_to(admin_entries_path)
    end
  end

end
