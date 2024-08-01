Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for(
    :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      confirmations: "users/confirmations",
      passwords: "users/passwords"
    },
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      password: "secret",
      confirmation: "verification",
      registration: "register",
      sign_up: "sign_up" }
  )
  scope :v1 do
    use_doorkeeper
  end

  namespace :v1 do
    resources :projects, only: %i[index show update destroy create] do
      resources :message_board, only: %i[index]
      resources :messages, only: %i[index show update destroy create]
      match "message_board", to: "message_board#update", via: [:patch, :put]
      resources :invites, only: %i[index show update destroy create], shallow: true
      resources :chats, only: %i[index show destroy create]
    end
  end
end
