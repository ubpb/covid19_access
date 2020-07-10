class DeletePeople < ActiveRecord::Migration[6.0]
  def up
    drop_table :people
  end
end
