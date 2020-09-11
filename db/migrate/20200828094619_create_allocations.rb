class CreateAllocations < ActiveRecord::Migration[6.0]
  def change
    create_table :allocations do |t|
      t.belongs_to :registration, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.belongs_to :resource, null: false, index: {unique: true}, foreign_key: { on_delete: :restrict }
      t.datetime   :created_at, null: false, index: true
    end

    create_table :released_allocations do |t|
      t.belongs_to :registration, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.belongs_to :resource, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.datetime   :created_at, null: false, index: true
      t.datetime   :released_at, null: false, index: true
    end
  end
end
