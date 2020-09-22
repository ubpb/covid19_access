namespace :app do
  namespace :reservations do
    desc "Cleanup overdue reservations"
    task :cleanup => :environment do
      Reservation.where("begin_date <= ?", 30.minutes.ago).each do |reservation|
        if reservation.destroy
          ReservationStatRecord.create!(
            action: ReservationStatRecord::ACTIONS[:expired],
            uid: reservation.user.uid,
            begin_date: reservation.begin_date,
            resource_group: reservation.resource.resource_group,
            resource_location: reservation.resource.resource_location
          )
        end
      end
    end
  end
end
