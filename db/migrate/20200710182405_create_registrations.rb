class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.string   :ilsid,      null: false, index: true
      t.datetime :entered_at, null: false, index: true
      t.datetime :exited_at,  null: true, index: true
      t.string   :name,       null: true
      t.string   :street,     null: true
      t.string   :city,       null: true
      t.string   :phone,      null: true
      t.timestamps
    end
  end
end
