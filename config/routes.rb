Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'meals#show'

  resources :meals, only: [:index, :show], param: :date do
    collection do
      post 'upload'
    end
  end

  # match '*path' => 'application#error404', via: :all
end
