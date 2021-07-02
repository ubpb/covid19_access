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

  # Scopes
  scope :allocatable, -> { where(allocatable: true) }

  def allocatable(date = Date.today)
    self.allocatable?
  end

  def allocatable?(date = Date.today)
    rl_disable_dates = resource_location.disable_dates || ""
    rl_disable_dates = rl_disable_dates.split(",")
      .map(&:strip)
      .map(&:presence)
      .map{|d| Date.parse(d) rescue nil}
      .compact

    if rl_disable_dates.present?
      self[:allocatable] && !rl_disable_dates.include?(date)
    else
      self[:allocatable]
    end
  end

  def allocated?
    allocation.present?
  end

  def available?
    !allocated?
  end

  def todays_reservations(today = Time.zone.today)
    reservations.where(begin_date: (today.beginning_of_day..today.end_of_day)).order(begin_date: :asc)
  end

  def reserved_today?(today = Time.zone.today)
    todays_reservations(today).exists?
  end

  def deleteable?
    self.allocation.blank? && !self.released_allocations.exists? && !self.reservations.exists?
  end

end
