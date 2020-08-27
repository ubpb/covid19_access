class AlephClient

  def authenticate(username, password)
    response = aleph_x_client.get(
      op: :"bor-auth",
      bor_id: username,
      library: Rails.configuration.application.aleph_user_library || "PAD50",
      verification: password
    )
    aleph_xml = Nokogiri.parse(response)

    if aleph_xml.at_xpath("//error")&.text
      false
    else
      user_data = {}
      user_data[:id]         = aleph_xml.at_xpath("//z303/z303-id")&.text
      user_data[:first_name] = aleph_xml.at_xpath("//z303/z303-name")&.text&.split(",")&.last&.strip
      user_data[:last_name]  = aleph_xml.at_xpath("//z303/z303-name")&.text&.split(",")&.first&.strip
      user_data[:email]      = aleph_xml.at_xpath("//z304/z304-email-address")&.text
      user_data
    end
  end

  def get_bib_data_for(ilsid)
    response = aleph_x_client.get(
      op: "bor_info",
      bor_id: ilsid,
      cash: "N",
      loans: "N",
      hold: "N"
    )
    aleph_xml = Nokogiri.parse(response)

    if aleph_xml.at_xpath("//error")&.text
      nil
    else
      bib_data = {}

      bib_data[:name] = aleph_xml.at_xpath("//z304/z304-address-0")&.text
      bib_data[:street] = aleph_xml.at_xpath("//z304/z304-address-1")&.text
      bib_data[:city] = aleph_xml.at_xpath("//z304/z304-address-2")&.text
      bib_data[:phone] = aleph_xml.at_xpath("//z304/z304-telephone")&.text

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
