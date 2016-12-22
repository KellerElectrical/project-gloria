class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, timeout_in: 16.hours

  after_save :skip_confirmation!

  has_many :tasks
  has_many :timecards

  def get_todays_timecard
  	Timecard.order(created_at: :desc).where({
  		user_id: self.id,
  		created_at: Time.now.midnight..(Time.now.midnight + 1.day)
  	}).first
  end
end
