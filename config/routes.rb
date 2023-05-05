Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :items, only: [:new, :create, :index, :destroy, :edit, :update]
  resources :item_categories, only: [:new, :create, :edit, :update]
  resources :batches, only: [:new, :create, :show, :index] do
    patch 'approve', on: :member
    get 'in_progress', on: :collection
    get 'future', on: :collection
  end
  resources :batch_items, only: [:create]
  delete 'batch_items', to: 'batch_items#delete_many'
  resources :bids, only: [:new, :create]
end
