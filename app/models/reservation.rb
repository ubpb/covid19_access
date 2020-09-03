class Reservation < ApplicationRecord

  # Relations
  belongs_to :user
  belongs_to :resource

  # Validations
  validates :begin_date, presence: true

end
