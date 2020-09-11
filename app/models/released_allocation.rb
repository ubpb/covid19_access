class ReleasedAllocation < ApplicationRecord

  # Relations
  belongs_to :registration
  belongs_to :resource

  # Validations
  validates :created_at, presence: true
  validates :released_at, presence: true

end
