namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      date = 4.weeks.ago

      Person.where("created_at < ?", date).each do |p|
        p.update_columns(
          ilsid: p.ilsid[0..2].ljust(10, "*")
        )
      end

      AccessLog.where("created_at < ?", date).destroy_all
    end
  end
end
