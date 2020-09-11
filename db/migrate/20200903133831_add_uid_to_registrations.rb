class AddUidToRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_column :registrations, :uid, :string, null: false, index: true
  end
end
