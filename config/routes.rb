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
	end

	get 'jobs/:id/get_tasks', to: 'jobs#get_tasks'
	get 'timecards/:id/cost_code', to: 'timecards#cost_code', as: :cost_code
end
