class Registration < ApplicationRecord

  validates :ilsid, presence: true
  validates :entered_at, presence: true

  def self.enter(id, timestamp)
    registration = self.find_by(ilsid: id, exited_at: nil)

    if registration.present?
      # we ignore this case
    else
      registration = self.new(ilsid: id, entered_at: timestamp, exited_at: nil)
      registration.save!
    end
  end

  def self.exit(id, timestamp)
    registration = self.find_by(ilsid: id, exited_at: nil)

    if registration.present?
      registration.exited_at = timestamp
      registration.save!
    else
      registration = self.new(ilsid: id, entered_at: timestamp.to_date.beginning_of_day, exited_at: timestamp)
      registration.save!
    end
  end

  def self.reset
    self.where(exited_at: nil).each do |p|
      p.update(exited_at: p.entered_at.end_of_day)
    end

    true
  end

  def self.number_of_people_entered
    self.where(exited_at: nil).count
  end

end
