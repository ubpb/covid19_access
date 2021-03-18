class SelfCheckoutController < ApplicationController

  def create
    flash[:self_checkout_result] = {}

    if barcode = get_filtered_barcode(params[:scan_form][:barcode]).presence
      if registration = Registration.find_by(barcode: barcode, exited_at: nil)
        close_registration(registration)
      else
        flash[:self_checkout_result][:error] = "Sie wurden nicht am Einlass erfasst oder wurden bereits ausgecheckt. Bitte wenden Sie sich an die Ortsleihe."
      end
    else
      flash[:self_checkout_result][:error] = "Bitte einen Bibliotheksausweis scannen. Für Fragen wenden Sie sich bitte an die Ortsleihe."
    end

    redirect_to(self_checkout_path)
  end

  def show
  end

private

  def close_registration(registration)
    has_allocations = registration.allocations.exists?

    if registration.close
      message_html = "<strong>Vielen Dank für Ihren Besuch. Auf Wiedersehen.</strong>"

      if has_allocations
        message_html << "<br/>Hinweis: Der von Ihnen belegte Arbeitsplatz wurde wieder zur Nutzung freigegeben."
      end

      flash[:self_checkout_result][:success] = message_html
    else
      flash[:self_checkout_result][:error] = "Es ist ein Fehler aufgetreten. Bitte wenden Sie sich an die Ortsleihe."
    end
  end

end
