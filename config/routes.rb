Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :items, only: [:new, :create, :index, :destroy, :edit, :update]
  resources :item_categories, only: [:new, :create, :edit, :update]
  resources :batches, only: [:new, :create, :show] do
    patch 'approve', on: :member
  end
  resources :batch_items, only: [:create]
  delete 'batch_items', to: 'batch_items#delete_many'
end
