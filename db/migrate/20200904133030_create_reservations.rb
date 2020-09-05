class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :resource, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.datetime :begin_date, null: false, index: true
      t.timestamps
    end
  end
end
