class AccessController < ApplicationController

  def enter_index
    setup_stats
    setup_log
  end

  def enter
    if id = get_id
      timestamp = Time.zone.now

      if valid_id?(id)
        Person.enter(id, timestamp)
        AccessLog.create(ilsid: id, timestamp: timestamp, direction: "enter")

        if data_matching_required_for?(id)
          flash[:warning] = "#{id}: Bitte Datenabgleich durchführen"
        else
          flash[:success] = "#{id}: OK"
        end
      else
        flash[:error] = "#{id}: Unzulässige Ausweisnummer"
      end
    end

    redirect_to enter_index_path
  end

  def exit_index
    setup_stats
    setup_log
  end

  def exit
    if id = get_id
      timestamp = Time.zone.now

      if valid_id?(id)
        Person.exit(id, timestamp)
        AccessLog.create(ilsid: id, timestamp: timestamp, direction: "exit")
        flash[:success] = "#{id}: OK"
      else
        flash[:error] = "#{id}: Unzulässige Ausweisnummer"
      end
    end

    redirect_to exit_index_path
  end

  def stats
    setup_stats

    render partial: "access/stats", locals: {
      number_of_people_entered: @number_of_people_entered,
      max_number_of_people: @max_number_of_people
    }
  end

  def log
    setup_log

    render partial: "access/log", locals: {
      access_log: @access_log
    }
  end

private

  def get_id
    if id = permitted_params[:ilsid]
      filter_proc = ->(id) { id.gsub(/\s+/, "").upcase } # default filter proc

      if filter_proc_string = Rails.configuration.application.id_filter_proc
        filter_proc = eval(filter_proc_string)
      end

      filter_proc.(id)
    end
  end

  def setup_stats
    @number_of_people_entered = Person.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    now = Time.zone.now
    @number_of_people_entered_last_hour = Person.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Person.where(exited_at: (now - 1.hour)..now).count
  end

  def setup_log
    @access_log = AccessLog.order(timestamp: :desc).limit(10)
  end

  def permitted_params
    params.require(:person).permit(:ilsid)
  end

  def valid_id?(id)
    matchers = Rails.configuration.application.valid_ids || []
    matchers.any?{|r| r.match(id)}
  end

  def data_matching_required_for?(id)
    matchers = Rails.configuration.application.data_matching_required_for_ids || []
    matchers.any?{|r| r.match(id)}
  end

end
