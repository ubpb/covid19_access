class Admin::CheckinController < Admin::ApplicationController

  def new
    load_global_stats
    load_last_registrations
  end

  def create
    barcode = params[:scan_form][:barcode].presence
    redirect_to(admin_new_checkin_registration_path(barcode: barcode))
  end

  def new_registration
    if barcode = get_filtered_barcode(params[:barcode]).presence
      # Do some checks
      check_for_valid_barcode(barcode) or return
      check_for_non_active_registration(barcode) or return

      # Load data from Aleph
      bib_data = AlephClient.new.get_bib_data_for(barcode)
      check_bib_data(barcode, bib_data) or return

      # Try to find a previous registration that has more data to speed
      # up the registration process.
      unless params[:reload_aleph_data]
        previous_registration = Registration.order("entered_at desc").find_by(barcode: barcode)
        if previous_registration.present?
          bib_data[:name]   = previous_registration.name.presence   || bib_data[:name]
          bib_data[:street] = previous_registration.street.presence || bib_data[:street]
          bib_data[:city]   = previous_registration.city.presence   || bib_data[:city]
          bib_data[:phone]  = previous_registration.phone.presence  || bib_data[:phone]
        end
      end

      # Build registration
      @registration         = Registration.new(barcode: barcode)
      @registration.uid     = bib_data[:id]
      @registration.name    = bib_data[:name]
      @registration.street  = bib_data[:street]
      @registration.city    = bib_data[:city]
      @registration.phone   = bib_data[:phone]
    else
      flash[:error] = "Bitte eine Ausweisnummer scannen oder eintippen."
      redirect_to(admin_new_checkin_path)
    end
  end

  def create_registration
    # Permit params
    permitted_params = params.require(:registration).permit(
      :uid, :barcode, :name, :street, :city, :phone
    )

    # Create registration
    @registration = Registration.new(permitted_params)
    @registration.entered_at = Time.zone.now

    if @registration.save
      flash["success"] = "Einlass OK für '#{@registration.name} (#{@registration.barcode})'"
      redirect_to(admin_registration_path(@registration))
    else
      render :new_registration
    end
  end

private

  def load_last_registrations
    @last_registrations = Registration.order("updated_at desc").limit(10)
  end

  def check_for_valid_barcode(barcode)
    matchers = Rails.configuration.application.valid_barcodes || []

    if matchers.none?{|r| r.match(barcode)}
      flash["error"] = "Ausweis-Nr. #{barcode} ist ungültig."
      redirect_to(admin_new_checkin_path)
      return false
    else
      return true
    end
  end

  def check_for_non_active_registration(barcode)
    registration = Registration.find_by(barcode: barcode, exited_at: nil)

    if registration.present?
      if registration.in_break?
        now = Time.zone.now

        registration.update_columns(
          last_break_started_at: registration.current_break_started_at,
          last_break_ended_at: now,
          current_break_started_at: nil,
          updated_at: now
        )

        flash["warning"] = "OK: Ausweis-Nr. #{barcode} war in der Pause. Die Pause wurde nun aufgehoben."
        redirect_to(admin_new_checkin_path)
        return false
      else
        flash["error"] = "Ausweis-Nr. #{barcode} befindet sich bereits im Gebäude. Möglicherweise wurde die Auslassbuchung nicht erfasst."
        redirect_to(admin_new_checkin_path)
        return false
      end
    end

    return true
  end

  def check_bib_data(barcode, bib_data)
    if bib_data.nil?
      flash["error"] = "Ausweis-Nr. #{barcode} ist in Aleph unbekannt."
      redirect_to(admin_new_checkin_path)
      return false
    end

    return true
  end

end
