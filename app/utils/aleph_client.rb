class AlephClient

  def get_bib_data_for(ilsid)
    aleph_data = aleph_x_client.get(
      op: "bor_info",
      bor_id: ilsid,
      cash: "N",
      loans: "N",
      hold: "N"
    )
    aleph_xml = Nokogiri.parse(aleph_data)

    #puts aleph_xml

    if aleph_xml.at_xpath("//error")&.text
      nil
    else
      bib_data = {}

      bib_data[:name] = aleph_xml.at_xpath("//z304/z304-address-0")&.text
      bib_data[:street] = aleph_xml.at_xpath("//z304/z304-address-1")&.text
      bib_data[:city] = aleph_xml.at_xpath("//z304/z304-address-2")&.text
      bib_data[:phone] = aleph_xml.at_xpath("//z304/z304-telephone")&.text
      bib_data[:email] = aleph_xml.at_xpath("//z304/z304-email-address")&.text

      # Handle edge cases
      if ilsid =~ /\AP[AL]{1}/
        bib_data[:street] = nil
        bib_data[:city] = nil
        bib_data[:phone] = nil
      end

      if bib_data[:phone] == "-"
        bib_data[:phone] = nil
      end

      bib_data
    end
  end

private

  def aleph_x_client
    url = Rails.configuration.application.aleph_x_services_url || "http://localhost:8991/X"
    @aleph_x_client ||= AlephApi::XServicesClient.new(url: url)
  end

end
