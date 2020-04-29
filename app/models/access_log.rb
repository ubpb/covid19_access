class AccessLog < ApplicationRecord

  validates :ilsid, presence: true
  validates :direction, presence: true
  validates :timestamp, presence: true

end
