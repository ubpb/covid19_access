class Resource < ApplicationRecord

  # Relations
  belongs_to :resource_group
  belongs_to :resource_location

  has_one  :allocation
  has_one  :registration, through: :allocation
  has_many :released_allocations
  has_many :registrations, through: :released_allocations

  # Validations
  validates :title, presence: true


  def allocated?
    allocation.present?
  end

  def available?
    !allocated?
  end

end
