class Resource < ApplicationRecord

  # Relations
  belongs_to :resource_group
  belongs_to :resource_location

  has_many :allocations
  has_many :registrations, through: :allocations
  has_many :released_allocations
  has_many :registrations, through: :released_allocations

  # Validations
  validates :title, presence: true


  def allocated?
    allocations.exists?
  end

  def available?
    !allocated?
  end

end
