class Registration < ApplicationRecord

  # Relations
  has_many :allocations
  has_many :resources, through: :allocations
  has_many :released_allocations
  has_many :resources, through: :released_allocations

  # Validations
  validates :ilsid, presence: true
  validates :entered_at, presence: true
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :phone, presence: true

  def self.number_of_people_entered
    self.where(exited_at: nil).count
  end

  def closed?
    exited_at.present?
  end

  def close
    Registration.transaction do
      update(exited_at: Time.zone.now)
      allocations.each do |allocation|
        allocation.release
      end
    end

    true
  end

end
