class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, timeout_in: 2.weeks

  after_create :send_confirmation_instructions
  after_save :skip_confirmation!

  has_many :tasks
  has_many :timecards

  has_many :user_locations



  def get_todays_timecard
  	Timecard.order(created_at: :desc).where({
  		user_id: self.id,
  		created_at: Time.now.midnight..(Time.now.midnight + 1.day)
  	}).first
  end

  def get_weeks_timecard(date)
    sunday = date.beginning_of_week - 1.day
    Timecard.order(created_at: :desc).where({
      user_id: self.id,
      created_at: sunday...(sunday + 7.days)
    })
  end

  def get_user_week(day)
    timecards = self.get_weeks_timecard(day)
    if timecards.empty?
      return nil
    else
      # Organize by {job1: {costcode: , totals: [1.5, 0, ... 0], comments: ""}, job2:  }
      hsh = {}
      timecards.each do |tc|
        tc.tasks.each do |task|
          next if task.job_id == 0
          job = Job.find(task.job_id)
          key = job.name || job.job_number.to_s
          hsh[key] ||= {costcode: (tc.cost_code || "N/A"), totals: [0] * 7, comments: task.comments, confirmed: tc.confirmed, team_members: tc.team_members}
          hsh[key][:totals][tc.created_at.wday] += task.hours
        end
      end
      rows = [] # 2d array with [jobname, costcode, 7 day values, and 1 total, and comments]
      sum = 0.to_f
      hsh.each do |jobname, jobhash|
          arr = jobhash[:totals]
          row = []
          row << jobname
          row << jobhash[:costcode]
          row.concat(arr[0..6])
          row << arr[0..6].sum
          sum += arr[0..6].sum
          row << jobhash[:comments]
          row << jobhash[:confirmed]
          row << jobhash[:team_members]
          rows << row
      end
      return nil if rows.empty?
      {day: day, rows: rows, sum_total: sum}
    end
  end

  def requires_locate?
    self.user_locations.empty? || (self.current_sign_in_ip != self.last_sign_in_ip) || self.user_locations.last.latitude.nil?
  end

  def locate_on_ip_change
    if requires_locate?
      self.user_locations.create!
    end
  end

  # def after_database_authentication
  #   locate_on_ip_change
  # end
end
