class Admin::StatisticsController < Admin::ApplicationController

  def index
    load_reservation_stats
    load_registration_stats
    load_allocation_stats
    load_break_stats
  end

private

  def load_reservation_stats
    @reservation_stats = {}

    # Count reservations
    raw_results = ReservationStatRecord
      .where(begin_date: (Time.zone.today - 30.days)..Time.zone.today)
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

  def load_registration_stats
    @registration_stats = {}

    # Count total
    raw_results = Registration
      .where(entered_at: (Time.zone.today - 30.days)..Time.zone.today)
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .count

    raw_results.each do |date, count|
      @registration_stats[date] ||= {}
      @registration_stats[date]["TOTAL"] = count
    end

    # Count non checkout
    raw_results = Registration
      .where(entered_at: (Time.zone.today - 30.days)..Time.zone.today)
      .where("TIME(CONVERT_TZ(exited_at, '+00:00', @@global.time_zone)) = '23:59:59'")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .count

    raw_results.each do |date, count|
      @registration_stats[date] ||= {}
      @registration_stats[date]["NON_CHECKOUT"] = count
    end

    # Average time
    raw_results = Registration
      .where(entered_at: (Time.zone.today - 30.days)..Time.zone.today)
      .where("TIME(CONVERT_TZ(exited_at, '+00:00', @@global.time_zone)) != '23:59:59'")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .average("TIME_TO_SEC(TIMEDIFF(exited_at, entered_at))")

    raw_results.each do |date, average_time|
      @registration_stats[date] ||= {}
      @registration_stats[date]["AVERAGE_TIME"] = average_time.to_i
    end

    # Calculate / tweek data
    @registration_stats.each do |k, v|
      v["TOTAL"]        ||= 0
      v["NON_CHECKOUT"] ||= 0
      v["AVERAGE_TIME"] ||= 0
    end
  end

  def load_allocation_stats
    @allocation_stats = {}

    # Count
    raw_results = ReleasedAllocation
      .where(created_at: (Time.zone.today - 30.days)..Time.zone.today)
      .group("DATE(created_at)")
      .order("DATE(created_at)")
      .count

    raw_results.each do |date, count|
      @allocation_stats[date] ||= {}
      @allocation_stats[date]["TOTAL"] = count
    end

    # Average time
    raw_results = ReleasedAllocation
      .where(created_at: (Time.zone.today - 30.days)..Time.zone.today)
      .group("DATE(created_at)")
      .order("DATE(created_at)")
      .average("TIME_TO_SEC(TIMEDIFF(created_at, released_at))")

    raw_results.each do |date, average_time|
      @allocation_stats[date] ||= {}
      @allocation_stats[date]["AVERAGE_TIME"] = average_time.to_i
    end

    # Calculate / tweek data
    @allocation_stats.each do |k, v|
      v["TOTAL"]        ||= 0
      v["AVERAGE_TIME"] ||= 0
    end
  end

  def load_break_stats
    @break_stats = {}

    # Returned breaks
    raw_results = Registration
      .where(created_at: (Time.zone.today - 30.days)..Time.zone.today)
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
      .where(created_at: (Time.zone.today - 30.days)..Time.zone.today)
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
      .where(created_at: (Time.zone.today - 30.days)..Time.zone.today)
      .where("last_break_started_at is not null AND last_break_ended_at is not null")
      .group("DATE(entered_at)")
      .order("DATE(entered_at)")
      .average("TIME_TO_SEC(TIMEDIFF(last_break_ended_at, last_break_started_at))")

    raw_results.each do |date, average_time|
      @break_stats[date] ||= {}
      @break_stats[date]["AVERAGE_TIME_SECONDS"] = average_time.to_i
      @break_stats[date]["AVERAGE_TIME_MINUTES"] = average_time.to_i / 60
    end

    # Calculate / tweek data
    @break_stats.each do |k, v|
      v["RETURNED"]             ||= 0
      v["OVERDUE"]              ||= 0
      v["AVERAGE_TIME_SECONDS"] ||= 0
      v["AVERAGE_TIME_MINUTES"] ||= 0
      v["TOTAL"]                 = v["RETURNED"] + v["OVERDUE"]
    end
  end

end
