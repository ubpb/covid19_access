class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.string   :ilsid,      null: false, index: true
      t.datetime :entered_at, null: false, index: true
      t.datetime :exited_at,  null: true, index: true
      t.timestamps
    end
  end
end
