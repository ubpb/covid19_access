class StatisticsController < ApplicationController

  def index
    @resource_statistics = []
    now = Time.zone.now
    load_global_stats(now)

    ResourceGroup.includes(:resources).order(:title).each do |rg|
      resources = rg.resources.joins(:resource_location).includes(:allocation, :reservations).order("resource_locations.title, resources.title").to_a
      resources = resources.select{|r| r.allocatable?(Date.today)}
      num_total = resources.count
      num_allocated = Allocation.joins(:resource).where("resources.resource_group": rg).count
      number_of_allocations_last_hour = Allocation.joins(:resource).where("resources.resource_group": rg).where(created_at: (now - 1.hour)..now).count +
        ReleasedAllocation.joins(:resource).where("resources.resource_group": rg).where(created_at: (now - 1.hour)..now).count
      number_of_released_allocations_last_hour = ReleasedAllocation.joins(:resource).where("resources.resource_group": rg).where(released_at: (now - 1.hour)..now).count

      @resource_statistics << {
        resource_group: rg,
        resources: resources,
        has_reservations: resources.any?{|r| r.reserved_today?},
        num_total: num_total,
        num_allocated: num_allocated,
        utilization: ((u = num_allocated.fdiv(num_total) * 100) >= 100.0 ? 100.0 : u),
        number_of_allocations_last_hour: number_of_allocations_last_hour,
        number_of_released_allocations_last_hour: number_of_released_allocations_last_hour
      }
    end
  end

end
