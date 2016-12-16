Rails.application.routes.draw do
	root to: 'static_pages#index'

  devise_for :users
  devise_scope :user do
	  get 'sign_in', to: 'devise/sessions#new'
		get 'sign_up', to: 'devise/registrations#new'
	end

	resources :jobs, only: [:new, :show, :create, :index, :destroy]
	resources :tasks, only: [:create, :destroy, :update]
	resources :timecards, except: [:destroy]

	get 'jobs/:id/get_tasks', to: 'jobs#get_tasks'

end
