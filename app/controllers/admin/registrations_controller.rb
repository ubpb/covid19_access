class Admin::RegistrationsController < Admin::ApplicationController

  def new
    if ilsid = get_filtered_ilsid(params[:ilsid]).presence
      verify_ilsid(ilsid, admin_checkin_index_path) or return
      verify_registration_for(ilsid) or return

      # Load data from Aleph
      bib_data = AlephClient.new.get_bib_data_for(ilsid)
      verify_bib_data(ilsid, bib_data) or return

      # Try to find a previous registration that has more data to speed
      # up the registration process.
      unless params[:reload_aleph_data]
        previous_registration = Registration.order("entered_at desc").find_by(ilsid: ilsid)
        if previous_registration.present?
          bib_data[:name]   = previous_registration.name.presence   || bib_data[:name]
          bib_data[:street] = previous_registration.street.presence || bib_data[:street]
          bib_data[:city]   = previous_registration.city.presence   || bib_data[:city]
          bib_data[:phone]  = previous_registration.phone.presence  || bib_data[:phone]
        end
      end

      @registration        = Registration.new(ilsid: ilsid)
      @registration.name   = bib_data[:name]
      @registration.street = bib_data[:street]
      @registration.city   = bib_data[:city]
      @registration.phone  = bib_data[:phone]
    else
      redirect_to(admin_checkin_index_path)
    end
  end

  def create
    # Permit params
    permitted_params = params.require(:registration).permit(
      :ilsid, :name, :street, :city, :phone
    )

    ilsid = permitted_params[:ilsid]
    verify_registration_for(ilsid) or return

    @registration = Registration.new(permitted_params)
    @registration.entered_at = Time.zone.now

    if @registration.save
      flash["success"] = "OK: #{@registration.ilsid}"
      redirect_to(admin_checkin_index_path)
    else
      render :new
    end
  end

end
