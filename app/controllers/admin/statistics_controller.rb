class Admin::StatisticsController < Admin::ApplicationController

  def index
    @reservation_stats = {}

    raw_results = ReservationStatRecord
      .where(begin_date: (Time.zone.today - 30.days)..(Time.zone.today - 1.day))
      .group("DATE(begin_date)", "action")
      .order("DATE(begin_date)").count

    raw_results.each do |k, count|
      date, action = k
      @reservation_stats[date] ||= {}
      @reservation_stats[date][action] = count
    end
  end

end
