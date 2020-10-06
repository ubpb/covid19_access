class Admin::CheckoutController < Admin::ApplicationController

  def create
    if barcode = get_filtered_barcode(params[:scan_form][:barcode]).presence
      if registration = Registration.find_by(barcode: barcode, exited_at: nil)
        if registration.in_break?
          flash[:error] = "Ausweis-Nr. #{barcode} befindet sich in der Pause. Bitte am Einlass erfassen!"
          redirect_to(admin_new_checkout_path)
        else
          redirect_to(admin_checkout_registration_path(registration))
        end
      else
        flash[:error] = "Ausweis-Nr. #{barcode} wurde nicht am Einlass erfasst oder bereits ausgecheckt."
        redirect_to(admin_new_checkout_path)
      end
    else
      flash[:error] = "Bitte eine Ausweisnummer scannen oder eintippen."
      redirect_to(admin_new_checkout_path)
    end
  end

  def show
    @registration = Registration.find(params[:id])
    @has_allocations = @registration.allocations.exists?

    if @has_allocations
      render :show
    else
      close_registration(@registration)
    end
  end

  def destroy
    registration = Registration.find(params[:id])
    close_registration(registration)
  end

  def break
    registration = Registration.find(params[:id])
    break_time = Time.zone.now
    break_time_end = break_time + 60.minutes

    registration.update_columns(
      current_break_started_at: break_time
    )

    flash[:success] = "Pause gespeichert. Die Pause endet um #{l(break_time_end, format: "%H:%M Uhr")}."
    redirect_to(admin_new_checkout_path)
  end

private

  def close_registration(registration)
    if registration.close
      flash[:success] = "Check-Out für Ausweis-Nr. #{registration.barcode} erfolgreich."
      redirect_to(admin_new_checkout_path)
    else
      flash[:error] = "Fehler: Check-Out konnte nicht abgeschlossen werden. Bitte überprüfen Sie die Registrierung."
      redirect_to(admin_registration_path(registration))
    end
  end

end
