class AddBreakTimeToRegistration < ActiveRecord::Migration[6.0]
  def change
    add_column :registrations, :current_break_started_at, :datetime, null: true, index: true
    add_column :registrations, :last_break_started_at, :datetime, null: true
    add_column :registrations, :last_break_ended_at, :datetime, null: true
  end
end
