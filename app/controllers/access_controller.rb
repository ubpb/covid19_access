class AccessController < ApplicationController

  def enter_index
    setup_stats
    setup_log
  end

  def enter
    if permitted_params[:ilsid].present?
      id = permitted_params[:ilsid].strip.upcase
      timestamp = Time.zone.now

      Person.enter(id, timestamp)
      flash[:success] = "#{id}: OK"
    end

    redirect_to enter_index_path
  end

  def exit_index
    setup_stats
    setup_log
  end

  def exit
    if permitted_params[:ilsid].present?
      id = permitted_params[:ilsid].strip.upcase
      timestamp = Time.zone.now

      Person.exit(id, timestamp)
      flash[:success] = "#{id}: OK"
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
      people: @last_people
    }
  end

private

  def setup_stats
    @number_of_people_entered = Person.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    now = Time.zone.now
    @number_of_people_entered_last_hour = Person.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Person.where(exited_at: (now - 1.hour)..now).count
  end

  def setup_log
    @last_people = Person.order(entered_at: :desc).limit(5)
  end

  def permitted_params
    params.require(:person).permit(:ilsid)
  end

end
