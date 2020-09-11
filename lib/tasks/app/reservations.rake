namespace :app do
  namespace :reservations do
    desc "Cleanup overdue reservations"
    task :cleanup => :environment do
      Reservation.where("begin_date <= ?", 30.minutes.ago).destroy_all
    end
  end
end
