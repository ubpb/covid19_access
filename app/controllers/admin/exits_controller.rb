class Admin::ExitsController < Admin::ApplicationController

  def index
  end

  def create
    if ilsid = get_filtered_ilsid(params[:scan_form][:ilsid]).presence
      verify_ilsid(ilsid, admin_exits_path) or return

      registration = Registration.find_by(ilsid: ilsid, exited_at: nil)

      if registration.present?
        registration.exited_at = Time.zone.now
        registration.save!

        flash[:success] = "OK: #{ilsid}"
      else
        flash[:error] = "Ausweis-Nr. #{ilsid} wurde nicht am Einlass erfasst."
      end

      redirect_to(admin_exits_path)
    else
      redirect_to(admin_entries_path)
    end
  end

end
