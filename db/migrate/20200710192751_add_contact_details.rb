class AddContactDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :registrations, :name, :string
    add_column :registrations, :street, :string
    add_column :registrations, :city, :string
    add_column :registrations, :phone, :string
    add_column :registrations, :email, :string
  end
end
