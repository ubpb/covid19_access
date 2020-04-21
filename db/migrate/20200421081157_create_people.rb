class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string   :ilsid,      null: false, index: true
      t.datetime :entered_at, null: false
      t.datetime :exited_at,  null: true
      t.timestamps
    end
  end
end
