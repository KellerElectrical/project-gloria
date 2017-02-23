module ApplicationHelper


	def use_auth_view?
  	return (action_name == "new" &&
  					(["devise/sessions", "devise/registrations"].include? params[:controller]))
  end

  def units
  	units = ["units", "feet", "inches", "miles"]
  end

  def zone(datetime)
  	datetime.in_time_zone("Arizona")
  end

  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end

end
