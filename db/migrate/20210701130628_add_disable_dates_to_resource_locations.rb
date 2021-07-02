class AddDisableDatesToResourceLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :resource_locations, :disable_dates, :string, null: true
  end
end
