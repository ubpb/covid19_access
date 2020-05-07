class FixExitedAtDates < ActiveRecord::Migration[6.0]
  def change
    Person.where("DATE(exited_at) > DATE(entered_at)").each do |p|
      p.update(exited_at: p.entered_at.end_of_day)
    end
  end
end
