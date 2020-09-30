class Registration < ApplicationRecord

  # Relations
  has_many :allocations
  has_many :resources, through: :allocations
  has_many :released_allocations
  has_many :resources, through: :released_allocations

  # Validations
  validates :uid, presence: true
  validates :barcode, presence: true
  validates :entered_at, presence: true
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :phone, presence: true

  def self.number_of_people_entered
    self.where(exited_at: nil).count
  end

  def closed?
    self.exited_at.present?
  end

  def close(reset: false)
    Registration.transaction do
      now = Time.zone.now
      exited_at = reset ? self.entered_at.end_of_day : now
      update_columns(exited_at: exited_at, updated_at: now)

      if in_break?
        update_columns(
          current_break_started_at: nil,
          last_break_started_at: self.current_break_started_at,
          last_break_ended_at: nil # indicates that the person did not return in time
        )
      end

      allocations.each do |allocation|
        allocation.release
      end
    end

    true
  end

  def in_break?
    self.current_break_started_at.present?
  end

  def todays_reservations
    if self.uid.present?
      today = Time.zone.today
      Reservation
        .joins(:user)
        .includes(resource: [:resource_group, :resource_location])
        .where("users.uid": self.uid, begin_date: (today.beginning_of_day..today.end_of_day))
        .order(begin_date: :asc)
    else
      []
    end
  end

end
