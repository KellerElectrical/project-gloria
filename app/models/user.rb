class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, timeout_in: 16.hours

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
