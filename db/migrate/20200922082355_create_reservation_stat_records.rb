class CreateReservationStatRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_stat_records do |t|
      t.string :action, null: false, index: true
      t.string :uid, null: false, index: true
      t.datetime :begin_date, null: false, index: true
      t.belongs_to :resource_group, null: true, index: true, foreign_key: { on_delete: :nullify }
      t.belongs_to :resource_location, null: true, index: true, foreign_key: { on_delete: :nullify }
      t.timestamps
    end
  end
end
