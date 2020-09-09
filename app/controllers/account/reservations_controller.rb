class Account::ReservationsController < Account::ApplicationController

  def index
    @reservations = current_user.reservations.order(begin_date: :asc)
  end

  def select_date
    set_and_check_dates(selected_date: params[:date]) or return

    @resources = Resource
      .joins(:resource_group, :resource_location)
      .order("resource_groups.title, resource_locations.title, resources.title")
  end

  def new
    Resource.transaction do
      set_and_check_dates(selected_date: params[:date]) or return
      set_and_check_resource(resource_id: params[:resource_id]) or return
      check_users_existing_reservations or return

      @reservation = current_user.reservations.build
      @reservation.resource = @resource
      @opening_time, @closing_time = Reservation.get_opening_and_closing_times(@selected_date)
    end
  end

  def create
    Resource.transaction do
      set_and_check_dates(selected_date: params.dig(:reservation, :selected_date)) or return
      set_and_check_resource(resource_id: params.dig(:reservation, :resource_id)) or return
      check_users_existing_reservations or return

      permitted_params = params.require(:reservation).permit(:begin_date)
      @reservation = current_user.reservations.build(permitted_params)
      @reservation.resource = @resource
      @reservation.begin_date = begin
        Time.zone.parse("#{@selected_date.strftime("%d.%m.%Y")} #{@reservation.begin_date.strftime("%H:%M")}")
      rescue
        nil
      end

      check_reservation_begin_date(@reservation.begin_date) or return

      if @reservation.save
        flash[:success] = "Reservierung gespeichert."
        redirect_to(account_reservations_path)
      else
        flash[:error] = "Fehler: Reservierung konnte nicht gespeichert werden."
        redirect_to(account_reservations_path)
      end
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

private

  def set_and_check_dates(selected_date:)
    # Set reservable dates
    @reservable_dates = Reservation.next_reservable_dates

    # Set selected date
    @selected_date = if selected_date.present?
      begin
        Date.parse(selected_date)
      rescue
        nil
      end
    end

    # Check dates
    if @reservable_dates.blank?
      flash[:error] = "Aktuell können keine Reservierungen vorgenommen werden."
      redirect_to(account_reservations_path)
      return false
    elsif @selected_date.blank?
      redirect_to(select_date_account_reservations_path(date: @reservable_dates.first))
      return false
    elsif !@reservable_dates.include?(@selected_date)
      flash[:error] = "An dem gewählten Datum kann keine Reservierung vorgenommen werden."
      redirect_to(select_date_account_reservations_path(date: @reservable_dates.first))
      return false
    else
      return true
    end
  end

  def set_and_check_resource(resource_id:)
    if resource_id.blank?
      flash[:error] = "Sie müssen eine Ressource auswählen."
      redirect_to(new_account_reservation_path)
      return false
    else
      @resource = Resource
        .includes(:resource_group, :resource_location, :allocation, :reservations)
        .find(resource_id)

      if (@selected_date == Time.zone.today && @resource.allocated?) || @resource.reserved_today?(@selected_date)
        flash[:error] = "Bitte wählen Sie eine freie Ressource aus. Die gewählte Ressource ist bereits belegt oder reserviert."
        redirect_to(select_date_account_reservations_path(date: @selected_date))
        return false
      else
        return true
      end
    end
  end

  def check_users_existing_reservations
    if current_user.has_reservations_today?(@selected_date)
      flash[:error] = "Für den gewählten Tag haben Sie bereits eine Reservierung. Sie können pro Tag max. eine Reservierung anlegen."
      redirect_to(select_date_account_reservations_path(date: @selected_date))
      return false
    else
      return true
    end
  end

  def check_reservation_begin_date(begin_date)
    today = Time.zone.today
    now = Time.zone.now

    opening_time, closing_time = Reservation.get_opening_and_closing_times(begin_date)
    during_opening_hours = opening_time.seconds_since_midnight < now.seconds_since_midnight &&
      closing_time.seconds_since_midnight > now.seconds_since_midnight

    if begin_date < now
      flash[:error] = "Die Reservierung darf nicht in der Vergangenheit liegen. Bitte wählen Sie eine passende Reservierungszeit."
      redirect_to(new_account_reservation_path(date: begin_date, resource_id: @resource.id))
      return false
    elsif begin_date.to_date == today && during_opening_hours && begin_date < (now + 1.hour)
      flash[:error] = "Die Reservierung muss min. 1 Stunde in der Zukunft liegen."
      redirect_to(new_account_reservation_path(date: begin_date, resource_id: @resource.id))
      return false
    elsif begin_date.seconds_since_midnight < opening_time.seconds_since_midnight
      flash[:error] = "Die Reservierung darf nicht vor dem Beginn der Öffungszeit liegen."
      redirect_to(new_account_reservation_path(date: begin_date, resource_id: @resource.id))
      return false
    elsif begin_date.seconds_since_midnight > closing_time.seconds_since_midnight
      flash[:error] = "Die Reservierung darf nicht nach dem Ende der Öffungszeit liegen."
      redirect_to(new_account_reservation_path(date: begin_date, resource_id: @resource.id))
      return false
    elsif begin_date.seconds_since_midnight > (closing_time - 1.hour).seconds_since_midnight
      flash[:error] = "Die Reservierung muss min. 1 Stunde vor dem Ende der Öffungszeit liegen."
      redirect_to(new_account_reservation_path(date: begin_date, resource_id: @resource.id))
      return false
    else
      return true
    end
  end

end
