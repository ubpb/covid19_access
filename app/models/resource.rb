class Resource < ApplicationRecord

  # Relations
  belongs_to :resource_group
  belongs_to :resource_location

  has_one  :allocation
  has_one  :registration, through: :allocation
  has_many :released_allocations
  has_many :registrations, through: :released_allocations
  has_many :reservations

  # Validations
  validates :title, presence: true


  def allocated?
    allocation.present?
  end

  def reserved_today?
    todays_reservations.exists?
  end

  def todays_reservations
    today = Time.zone.today
    reservations.where(begin_date: (today.beginning_of_day..today.end_of_day)).order(begin_date: :asc)
  end

  def available?
    !allocated?
  end

end
