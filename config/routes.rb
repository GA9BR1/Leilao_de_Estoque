Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :items, only: [:new, :create, :index, :destroy, :edit, :update]
  resources :item_categories, only: [:new, :create, :edit, :update]
  resources :batches, only: [:new, :create, :show, :index] do
    get 'admin', on: :member, to: 'batches#show_admin', as: 'show_admin'
    get 'in_progress', on: :collection
    get 'future', on: :collection
    resources :bids, only: [:create, :new]
    resources :doubts, only: [:create, :new] do
      resources :answers, only: [:create, :new]
    end
    get 'expired', on: :collection
    get 'batches_with_my_bids', on: :collection
    patch 'approve', on: :member
    patch 'cancel', on: :member
    patch 'close', on: :member
  end
  resources :batch_items, only: [:create]
  patch 'doubts/:id/set_answered', to: 'doubts#set_answered', as: 'set_doubt_answered'
  get 'doubts/not_answered', to: 'doubts#not_answered'
  get 'doubts/:id/checked_answered_adm_button', to: 'doubts#answered_checked', as: 'answered_button_checked'
  get 'doubts/:id/unchecked_answered_adm_button', to: 'doubts#answered_unchecked', as: 'answered_button_unchecked'
  get 'doubts/:id/visible', to: 'doubts#visible', as: 'doubts_visible'
  get 'doubts/:id/not_visible', to: 'doubts#not_visible', as: 'doubts_not_visible'
  get 'doubts/:id/name_not_ocult', to: 'doubts#name_not_ocult', as: 'doubts_name_not_ocult'
  get 'doubts/:id/name_ocult', to: 'doubts#name_ocult', as: 'doubts_name_ocult'
  patch 'doubts/:id/set_visibility', to: 'doubts#set_visiblity', as: 'set_doubt_visibility'
  delete 'batch_items', to: 'batch_items#delete_many'
end
