Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :items, only: [:new, :create, :index, :destroy, :edit, :update]
  resources :item_categories, only: [:new, :create, :edit, :update]
  resources :batches, only: [:new, :create, :show, :index] do
    get 'in_progress', on: :collection
    get 'future', on: :collection
    resources :bids, only: [:create, :new]
    get 'expired', on: :collection
    get 'batches_with_my_bids', on: :collection
    patch 'approve', on: :member
    patch 'cancel', on: :member
    patch 'close', on: :member
  end
  resources :batch_items, only: [:create]
  delete 'batch_items', to: 'batch_items#delete_many'
end
