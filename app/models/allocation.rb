class Allocation < ApplicationRecord

  # Relations
  belongs_to :registration
  belongs_to :resource

  # Validations
  validates :created_at, presence: true
  validates :resource, uniqueness: true


  def release
    Allocation.transaction do
      released_allocation = ReleasedAllocation.new
      released_allocation.registration = self.registration
      released_allocation.resource = self.resource
      released_allocation.created_at = self.created_at
      released_allocation.released_at = Time.zone.now

      self.destroy && released_allocation.save
    end
  end

end
