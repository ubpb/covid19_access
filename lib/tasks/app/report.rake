namespace :app do
  namespace :report do
    desc "Create report"
    task :create => :environment do
      cli = HighLine.new

      aleph_x_services_url = Rails.configuration.application.aleph_x_services_url
      if aleph_x_services_url
        @aleph_x_client = AlephApi::XServicesClient.new(url: aleph_x_services_url)
      end

      begin_date_time = cli.ask("Begin (TT.MM.YYYY [HH:MM:SS])", Time)
      end_date_time = cli.ask("Ende (TT.MM.YYYY [HH:MM:SS])", Time)

      cli.say("Erstelle Report für den Zeitraum #{begin_date_time} bis #{end_date_time}.")

      people = Person.where("entered_at >= ? AND exited_at <= ?", begin_date_time, end_date_time)
      create_report(people)
    end

  private

    def create_report(people)
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: "Report") do |sheet|
          headers = [
            "Bib. Ausweis Nr.",
            "Bor. Status",
            "Einlass",
            "Auslass",
            "Name",
            "Straße",
            "PLZ / Stadt",
            "Telefon",
            "E-Mail"
          ]

          sheet.add_row(headers)

          people.each do |person|
            bib_data = @aleph_x_client ? get_bib_data(person.ilsid) : {}

            values = [
              person.ilsid,
              bib_data[:bor_status],
              I18n.l(person.entered_at),
              I18n.l(person.exited_at),
              bib_data[:name],
              bib_data[:street],
              bib_data[:city],
              bib_data[:phone],
              bib_data[:email]
            ]

            style = p.workbook.styles.add_style(alignment: {wrap_text: true, vertical: :top})
            sheet.add_row(values, style: style, types: :string)
          end
        end

        p.serialize(File.join(Rails.root, "tmp", "report.xlsx"))
      end
    end

    def get_bib_data(ilsid)
      aleph_data = @aleph_x_client.get(
        op: "bor_info",
        bor_id: ilsid,
        cash: "N",
        loans: "N",
        hold: "N"
      )
      aleph_xml = Nokogiri.parse(aleph_data)

      #puts aleph_xml

      bib_data = {}

      unless aleph_xml.at_xpath("//error")&.text
        bib_data[:name] = aleph_xml.at_xpath("//z304/z304-address-0")&.text
        bib_data[:email] = aleph_xml.at_xpath("//z304/z304-email-address")&.text
        bib_data[:phone] = aleph_xml.at_xpath("//z304/z304-telephone")&.text
        bib_data[:street] = aleph_xml.at_xpath("//z304/z304-address-1")&.text
        bib_data[:city] = aleph_xml.at_xpath("//z304/z304-address-2")&.text
        bib_data[:bor_status] = aleph_xml.at_xpath("//z305/z305-bor-status")&.text
      end

      bib_data
    end

  end
end
