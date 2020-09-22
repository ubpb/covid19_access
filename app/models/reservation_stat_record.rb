class ReservationStatRecord < ApplicationRecord

  ACTIONS = {
    created_by_user: "CREATED_BY_USER",
    deleted_by_user: "DELETED_BY_USER",
    deleted_by_staff: "DELETED_BY_STAFF",
    assigned: "ASSIGNED",
    expired: "EXPIRED"
  }.freeze

  # Relations
  belongs_to :resource_group
  belongs_to :resource_location

  # Validations
  validates :action, presence: true, inclusion: { in: ACTIONS.values }
  validates :uid, presence: true
  validates :begin_date, presence: true
  validates :resource_group, presence: true
  validates :resource_location, presence: true

end
