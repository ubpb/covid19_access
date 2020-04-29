class CreateAccessLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :access_logs do |t|
      t.string :ilsid, null: false, index: true
      t.string :direction, null: false, index: true
      t.datetime :timestamp, null: false, index: true
      t.timestamps
    end
  end
end
