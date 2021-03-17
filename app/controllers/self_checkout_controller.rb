class SelfCheckoutController < ApplicationController

  def create
    if barcode = get_filtered_barcode(params[:scan_form][:barcode]).presence
      if registration = Registration.find_by(barcode: barcode, exited_at: nil)
        close_registration(registration)
      else
        flash[:error] = "Ausweis-Nr. #{barcode} wurde nicht am Einlass erfasst oder wurde bereits ausgecheckt."
        redirect_to(new_self_checkout_path)
      end
    else
      flash[:error] = "Bitte einen Bibliotheksausweis scannen."
      redirect_to(new_self_checkout_path)
    end
  end

private

  def close_registration(registration)
    has_allocations = registration.allocations.exists?

    if registration.close
      flash[:success] = "Vielen Dank für Ihren Besuch. Auf Wiedersehen."

      if has_allocations
        flash[:warning] = "Bitte beachten Sie: Der von Ihnen belegte Arbeitsplatz wurde wieder zur Nutzung freigegeben."
      end
    else
      flash[:error] = "Es ist ein Fehler aufgetreten. Bitte wenden Sie sich an die Ortsleihe."
    end

    redirect_to(new_self_checkout_path)
  end

end
