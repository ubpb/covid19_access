class RenameIlsidToBarcode < ActiveRecord::Migration[6.0]
  def change
    rename_column :registrations, :ilsid, :barcode
  end
end
