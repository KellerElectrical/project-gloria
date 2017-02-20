class UserLocationsController < ApplicationController
	def update
		# take an ajax post request with coordinate
		ul = current_user.user_locations.create!(	latitude: params[:lat].to_f, longitude: params[:long].to_f)
		respond_to do |format|
		  format.json do
		    render json: {address: ul.address }.to_json
		  end
		end

	end
end
