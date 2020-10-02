class Admin::StatisticsController < Admin::ApplicationController

  def index
    load_reservations_stats
    load_break_stats
  end

private

  def load_reservations_stats
    @reservation_stats = {}

    raw_results = ReservationStatRecord
      .where(begin_date: (Time.zone.today - 30.days)..(Time.zone.today))
      .group("DATE(begin_date)", "action")
      .order("DATE(begin_date)")
      .count

    raw_results.each do |k, count|
      date, action = k
      @reservation_stats[date] ||= {}
      @reservation_stats[date][action] = count
    end

    # Calculate / tweek data
    @reservation_stats.each do |k, v|
      v["ASSIGNED"]         ||= 0
      v["EXPIRED"]          ||= 0
      v["CREATED_BY_USER"]  ||= 0
      v["DELETED_BY_USER"]  ||= 0
      v["DELETED_BY_STAFF"] ||= 0
      v["TOTAL"]              = v["ASSIGNED"] + v["EXPIRED"]
    end
  end

  def load_break_stats
    @break_stats = {}

    # Returned breaks
    raw_results = Registration
      .where("last_break_started_at is not null AND last_break_ended_at is not null")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .count
    raw_results.each do |date, count|
      @break_stats[date] ||= {}
      @break_stats[date]["RETURNED"] = count
    end

    # Overdue breaks
    raw_results = Registration
      .where("last_break_started_at is not null AND last_break_ended_at is null")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .count
    raw_results.each do |date, count|
      @break_stats[date] ||= {}
      @break_stats[date]["OVERDUE"] = count
    end

    # Average time
    raw_results = Registration
      .where("last_break_started_at is not null AND last_break_ended_at is not null")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .average("TIMEDIFF(last_break_ended_at, last_break_started_at)")
    raw_results.each do |date, average_time|
      @break_stats[date] ||= {}
      @break_stats[date]["AVERAGE_TIME"] = average_time
    end

    # Calculate / tweek data
    @break_stats.each do |k, v|
      v["RETURNED"]     ||= 0
      v["OVERDUE"]      ||= 0
      v["AVERAGE_TIME"] ||= 0
      v["TOTAL"]          = v["RETURNED"] + v["OVERDUE"]
    end
  end

end
