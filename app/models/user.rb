class User < ApplicationRecord

  # Relations
  has_many :reservations

  # Validations
  validates :uid, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def name
    [first_name, last_name].map(&:presence).compact.join(" ").presence
  end

  def name_reversed
    [last_name, first_name].map(&:presence).compact.join(", ").presence
  end

  def todays_reservations(today = Time.zone.today)
    reservations.where(begin_date: (today.beginning_of_day..today.end_of_day)).order(begin_date: :asc)
  end

  def has_reservations_today?(today = Time.zone.today)
    todays_reservations(today).exists?
  end

end
