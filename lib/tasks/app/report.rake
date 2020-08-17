namespace :app do
  namespace :report do
    desc "Create report"
    task :create => :environment do
      cli = HighLine.new

      begin_date_time = cli.ask("Begin (TT.MM.YYYY [HH:MM:SS])", Time)
      end_date_time = cli.ask("Ende (TT.MM.YYYY [HH:MM:SS])", Time)

      cli.say("Erstelle Report für den Zeitraum #{begin_date_time} bis #{end_date_time}.")

      registrations = Registration.where("entered_at >= ? AND exited_at <= ?", begin_date_time, end_date_time)
      create_report(registrations)
    end

  private

    def create_report(registrations)
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: "Report") do |sheet|
          headers = [
            "Bib. Ausweis Nr.",
            "Einlass",
            "Auslass",
            "Name",
            "Straße",
            "PLZ / Stadt",
            "Telefon"
          ]

          sheet.add_row(headers)

          registrations.each do |registration|
            values = [
              registration.ilsid,
              I18n.l(registration.entered_at),
              I18n.l(registration.exited_at),
              registration.name.presence,
              registration.street.presence,
              registration.city.presence,
              registration.phone.presence
            ]

            style = p.workbook.styles.add_style(alignment: {wrap_text: true, vertical: :top})
            sheet.add_row(values, style: style, types: :string)
          end
        end

        p.serialize(File.join(Rails.root, "tmp", "report.xlsx"))
      end
    end

  end
end
