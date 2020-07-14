class DropAccessLog < ActiveRecord::Migration[6.0]
  def up
    drop_table :access_logs
  end
end
