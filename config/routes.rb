Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :meals, only: [:index, :show] do
    collection do
      post 'upload'
    end
  end
end
