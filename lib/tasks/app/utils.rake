namespace :app do
  namespace :utils do
    desc "Reset/closes all 'open' registrations. WARNING: Do not run during opening hours."
    task :reset_open_registrations => :environment do
      Registration.transaction do
        Registration.where(exited_at: nil).each do |reg|
          reg.close(reset: true)
        end
      end
    end

    desc "Reset/closes all registrations that took a too long break."
    task :reset_overdue_registrations => :environment do
      Registration.transaction do
        Registration.where("exited_at is null and current_break_started_at <= ?", 60.minutes.ago).each do |reg|
          reg.close(reset: true)
        end
      end
    end

    desc "Import resources"
    task :import_resources => :environment do
      filename = "db/resources.csv"

      unless File.exists?(filename)
        puts "'db/resources.csv' does not exist"
        exit(0)
      end

      # For now we only use "Einzelarbeitsplätze".
      # TODO: Make this more generic
      resource_group = ResourceGroup.where(title: "Einzelarbeitsplatz").first_or_create! do |rg|
        rg.title = "Einzelarbeitsplatz"
      end

      CSV.foreach(filename, headers: true, col_sep: ";") do |row|
        # use row here...
        location_title  = row[0].presence
        resource_number = row[1].presence
        add_info        = row[2].presence
        enabled         = row[3] == "1"

        if enabled
          resource_location = ResourceLocation.where(title: location_title).first_or_create! do |rl|
            rl.title = location_title
          end

          resource_title = "Platz #{resource_number.to_s.rjust(3, "0")}"
          resource_title += " (#{add_info})" if add_info.present?

          Resource.where(
            resource_group: resource_group,
            resource_location: resource_location,
            title: resource_title
          ).first_or_create! do |r|
            r.resource_group = resource_group
            r.resource_location = resource_location
            r.title = resource_title
          end
        end
      end
    end
  end
end
