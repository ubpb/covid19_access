class Account::ReservationsController < Account::ApplicationController

  def index
    @reservations = current_user.reservations.order(begin_date: :asc)
  end

  def select_date
    @reservable_dates = [Date.today, Date.today + 1.day, Date.today + 2.days, Date.today + 3.days] # TODO: Check Öffnungszeiten
    @selected_date = if params[:date].present?
      begin
        Date.parse(params[:date])
      rescue
        nil
      end
    end

    if @selected_date && @reservable_dates.include?(@selected_date)
      @resources = Resource
        .joins(:resource_group, :resource_location)
        .order("resource_groups.title, resource_locations.title, resources.title")
    else
      redirect_to(select_date_account_reservations_path(date: @reservable_dates.first))
    end
  end

  def new
    @reservable_dates = [Date.today, Date.today + 1.day, Date.today + 2.days, Date.today + 3.days] # TODO: Check Öffnungszeiten
    @selected_date = if params[:date].present? # TODO: Check Öffnungszeiten
      begin
        Date.parse(params[:date])
      rescue
        nil
      end
    end

    if @selected_date && @reservable_dates.include?(@selected_date) && params[:resource_id].present?
      @resource = Resource.includes(:resource_group, :resource_location).find(params[:resource_id])
      @reservation = current_user.reservations.build
      @reservation.resource = @resource
    else
      redirect_to(select_date_account_reservations_path)
    end
  end

  def create
    permitted_params = params.require(:reservation).permit(:begin_date)

    @reservable_dates = [Date.today, Date.today + 1.day, Date.today + 2.days, Date.today + 3.days] # TODO: Check Öffnungszeiten
    @selected_date = if params.dig(:reservation, :selected_date).present? # TODO: Check Öffnungszeiten
      begin
        Date.parse(params.dig(:reservation, :selected_date))
      rescue
        nil
      end
    end

    if @selected_date && @reservable_dates.include?(@selected_date)
      @resource = Resource.includes(:resource_group, :resource_location).find(params.dig(:reservation, :resource_id))
      @reservation = current_user.reservations.build(permitted_params)
      @reservation.resource = @resource
      @reservation.begin_date = Time.zone.parse("#{@selected_date.strftime("%d.%m.%Y")} #{@reservation.begin_date.strftime("%H:%M")}")

      if @reservation.save
        flash[:success] = "Reservierung gespeichert."
        redirect_to(account_reservations_path)
      else
        flash[:error] = "Fehler: Reservierung konnte nicht gespeichert werden."
        redirect_to(account_reservations_path)
      end
    else
      redirect_to(select_date_account_reservations_path)
    end
  end

  def destroy
    reservation = current_user.reservations.find(params[:id])

    if reservation.destroy
      flash[:success] = "Reservierung gelöscht."
    else
      flash[:error] = "Fehler: Reservierung konnte nicht gelöscht werden."
    end

    redirect_to(account_reservations_path)
  end

end
