class RenameIlsidToBarcode < ActiveRecord::Migration[6.0]
  def up
    rename_column :registrations, :ilsid, :barcode
    add_column :registrations, :uid, :string, null: false, index: true
  end
end
