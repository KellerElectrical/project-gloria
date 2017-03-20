namespace :db do
  desc "Deletes all Jobs Tasks Timecards and UserLocations"
  task :weekly_delete do
    if DateTime.now.strftime("%A") == "Sunday" && (DateTime.now.strftime("%U").to_i % 2 == 1)
      Job.delete_all
      Task.delete_all
      Timecard.delete_all
      TimecardJoin.delete_all
      UserLocation.delete_all
    end
  end
end
