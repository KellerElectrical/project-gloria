Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
	  get 'sign_in', to: 'devise/sessions#new'
		get 'sign_up', to: 'devise/registrations#new'
	end

	root to: 'static_pages#index'
end
