class RegistrationsController < ApplicationController

  def new
    if ilsid = get_filtered_ilsid(params[:ilsid]).presence
      verify_ilsid(ilsid, entries_path) or return
      verify_registration_for(ilsid) or return

      bib_data = AlephClient.new.get_bib_data_for(ilsid)
      verify_bib_data(ilsid, bib_data) or return

      @registration        = Registration.new(ilsid: ilsid)
      @registration.name   = bib_data[:name]
      @registration.street = bib_data[:street]
      @registration.city   = bib_data[:city]
      @registration.phone  = bib_data[:phone]
      @registration.email  = bib_data[:email]
    else
      redirect_to(entries_path)
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
      redirect_to(entries_path)
    else
      render :new
    end
  end

end
