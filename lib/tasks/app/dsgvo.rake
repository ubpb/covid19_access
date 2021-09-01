namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      registration_required = ApplicationConfig.registration_required?
      date = registration_required ? 4.weeks.ago.end_of_day : 1.day.ago.end_of_day

      Registration.anonymize!(date)
    end
  end
end
