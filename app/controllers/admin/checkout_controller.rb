class Admin::CheckoutController < Admin::ApplicationController

  def index
  end

  def create
    if ilsid = get_filtered_ilsid(params[:scan_form][:ilsid]).presence
      verify_ilsid(ilsid, admin_checkout_index_path) or return

      registration = Registration.find_by(ilsid: ilsid, exited_at: nil)

      if registration.present?
        if registration.close
          flash[:success] = "OK: #{ilsid}"
        else
          flash[:error] = "Fehler: Person konnte nicht ausgecheckt werden. Bitte Registrierung überprüfen."
        end
      else
        flash[:error] = "Ausweis-Nr. #{ilsid} wurde nicht am Einlass erfasst."
      end

      redirect_to(admin_checkout_index_path)
    else
      redirect_to(admin_checkin_index_path)
    end
  end

end
