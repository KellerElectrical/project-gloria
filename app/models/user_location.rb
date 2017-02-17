class UserLocation < ApplicationRecord
	belongs_to :user

	validates :user_id, :ip, presence: true	
	# Tell geocoder which method returns a geocodable address
	geocoded_by :ip
	reverse_geocoded_by :latitude, :longitude, address: :address
	after_validation :geocode, :reverse_geocode

	before_validation :check_user_exists

	def check_user_exists
		user = User.find(self.user_id)
		return false if user.nil?
		self.ip = user.current_sign_in_ip.to_s
	end
end
