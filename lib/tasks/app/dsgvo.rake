namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      date = 4.weeks.ago.end_of_day
      Registration.anonymize_all!(date)
    end
  end
end
