class Person < ApplicationRecord

  validates :ilsid, presence: true
  validates :entered_at, presence: true

  def self.enter(id)
    id = clean_id(id)
    entered_person = Person.find_by(ilsid: id, exited_at: nil)

    if entered_person.present?
      false
    else
      person = Person.new(ilsid: id, entered_at: Time.zone.now, exited_at: nil)
      person.save
    end
  end

  def self.exit(id)
    id = clean_id(id)
    entered_person = Person.find_by(ilsid: id, exited_at: nil)

    if entered_person.present?
      entered_person.exited_at = Time.zone.now
      entered_person.save
    else
      false
    end
  end

  def self.reset
    timestamp = Time.zone.now.end_of_day

    Person.where(exited_at: nil).update(exited_at: timestamp)

    true
  end

  def self.number_of_people_entered
    Person.where(exited_at: nil).count
  end

private

  def self.clean_id(id)
    id.strip.upcase
  end

end
