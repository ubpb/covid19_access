class AddMissingIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :people, :entered_at
    add_index :people, :exited_at
  end
end
