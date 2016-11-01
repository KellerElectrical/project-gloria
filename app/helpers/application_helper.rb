module ApplicationHelper

	def use_auth_view?
  	return (action_name == "new" &&
  					(["devise/sessions", "devise/registrations"].include? params[:controller]))
  end
end
