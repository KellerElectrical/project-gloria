Rails.application.routes.draw do
	root to: 'static_pages#index'

  devise_for :users
  devise_scope :user do
	  get 'sign_in', to: 'devise/sessions#new'
		get 'sign_up', to: 'devise/registrations#new'
	end

	resources :jobs, only: [:show, :create, :index, :destroy]
	resource :tasks, only: [:create, :destroy]

end
