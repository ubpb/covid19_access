namespace :app do
  namespace :dsgvo do
    desc "Cleanup personal information to be DSGVO compliant"
    task :cleanup => :environment do
      omit_personal_data = Rails.configuration.application.omit_personal_data_on_checkin || false
      date = omit_personal_data ? 1.day.ago.end_of_day : 4.weeks.ago.end_of_day
      Registration.anonymize!(date)
    end
  end
end
