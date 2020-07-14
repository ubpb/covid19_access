class Registration < ApplicationRecord

  validates :ilsid, presence: true
  validates :entered_at, presence: true
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :phone, presence: true

  def self.number_of_people_entered
    self.where(exited_at: nil).count
  end

end
