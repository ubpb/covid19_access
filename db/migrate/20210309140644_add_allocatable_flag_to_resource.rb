class AddAllocatableFlagToResource < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :allocatable, :boolean, null: false, index: true, default: true
  end
end
