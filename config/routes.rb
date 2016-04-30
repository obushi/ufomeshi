date_constraints = lambda { |req|
  return true if req.params[:date].blank?
  Date.valid_date?(
    req.params[:date][0..3].to_i,
    req.params[:date][4..5].to_i,
    req.params[:date][6..7].to_i)
  }

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'meals#show'

  resources :meals, only: [:index, :show], param: :date, constraints: date_constraints do
    collection do
      post 'upload'
    end
  end

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :meals, only: [:index, :show], param: :date, constraints: date_constraints do
        collection do
          get 'search'
        end
      end
    end
  end
  # match '*path' => 'application#error404', via: :all
end
