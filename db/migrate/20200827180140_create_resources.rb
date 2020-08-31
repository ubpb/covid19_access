class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resource_groups do |t|
      t.string :title, null: false
      t.timestamps
    end

    create_table :resource_locations do |t|
      t.string :title, null: false
      t.timestamps
    end

    create_table :resources do |t|
      t.belongs_to :resource_group, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.belongs_to :resource_location, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.string :title, null: false
      t.timestamps
    end
  end
end
