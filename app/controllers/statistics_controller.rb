class StatisticsController < ApplicationController

  def index
    @resource_statistics = []
    now = Time.zone.now

    ResourceGroup.includes(:resources).order(:title).each do |rg|
      resources = rg.resources.joins(:resource_location).includes(:allocation, :reservations).order("resource_locations.title, resources.title").to_a
      num_total = resources.count
      num_allocated = Allocation.joins(:resource).where("resources.resource_group": rg).count
      number_of_allocations_last_hour = Allocation.joins(:resource).where("resources.resource_group": rg).where(created_at: (now - 1.hour)..now).count +
        ReleasedAllocation.joins(:resource).where("resources.resource_group": rg).where(created_at: (now - 1.hour)..now).count
      number_of_released_allocations_last_hour = ReleasedAllocation.joins(:resource).where("resources.resource_group": rg).where(released_at: (now - 1.hour)..now).count

      @resource_statistics << {
        resource_group: rg,
        resources: resources,
        num_total: num_total,
        num_allocated: num_allocated,
        utilization: num_allocated.fdiv(num_total) * 100,
        number_of_allocations_last_hour: number_of_allocations_last_hour,
        number_of_released_allocations_last_hour: number_of_released_allocations_last_hour
      }
    end

    @number_of_people_entered = Registration.number_of_people_entered
    @max_number_of_people = Rails.configuration.application.max_people || 40
    @number_of_people_entered_last_hour = Registration.where(entered_at: (now - 1.hour)..now).count
    @number_of_people_exited_last_hour = Registration.where(exited_at: (now - 1.hour)..now).count
  end

end
