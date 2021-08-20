class UidAndBarcodeCanBeNullForRegistrations < ActiveRecord::Migration[6.1]
  def change
    change_column_null :registrations, :uid, true
    change_column_null :registrations, :barcode, true
  end
end
