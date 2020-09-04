class FixUidFromBarcodeForRegistrations < ActiveRecord::Migration[6.0]

  class Registration < ApplicationRecord
    self.table_name = "registrations"
  end

  def up
    aleph_client = AlephClient.new
    errors = []

    Registration.where.not(name: nil).each do |reg|
      if reg.uid.blank?
        bib_data = aleph_client.get_bib_data_for(reg.barcode)

        if bib_data.present?
          reg.update(uid: bib_data[:id])
          puts "Created uid=#{bib_data[:id]} for barcode=#{reg.barcode}"
        else
          errors << reg.barcode
          puts "Error for barcode=#{reg.barcode}"
        end
      end
    end

    puts "DONE. Errors: #{errors.join(", ")}"
  end
end
