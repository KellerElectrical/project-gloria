Rails.application.routes.draw do
	root to: 'static_pages#index'

  devise_for :users, controllers: { sessions: 'users/sessions', confirmations: 'users/confirmations' }
  devise_scope :user do
	  get 'sign_in', to: 'devise/sessions#new'
		get 'sign_up', to: 'devise/registrations#new'
	end

	resources :jobs, only: [:new, :show, :create, :index, :destroy]
	resources :tasks, only: [:create, :destroy, :update]
	resources :timecards, except: [:destroy]

	resources :user, only: [:show] do 
		resources :timecards, only: [:index]
		get 'weeks', to: 'timecards#show_user_weeks', as: :weeks
		get 'confirm_week', to: 'timecards#confirm_week', as: :confirm_week
	end

	post 'send_week_email', to: 'timecards#send_week_email', as: :send_week_email
	get 'download_week_csv', to: 'timecards#download_week_csv', as: :download_week_csv

	resource :user_locations, only: [:update]

	get 'jobs/:id/get_tasks', to: 'jobs#get_tasks'
	get 'timecards/:id/cost_code', to: 'timecards#cost_code', as: :cost_code

	delete 'admin_db_clear', to: 'application#admin_db_clear', as: :admin_db_clear
	patch 'user/:id', to: 'application#update_user_admin', as: :update_user_admin

end
