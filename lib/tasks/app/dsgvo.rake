namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      date = 4.weeks.ago

      Registration.where("created_at < ?", date).each do |p|
        p.update_columns(
          ilsid: p.ilsid[0..2].ljust(10, "*"),
          name: nil,
          street: nil,
          city: nil,
          phone: nil,
          email: nil
        )
      end
    end
  end
end
