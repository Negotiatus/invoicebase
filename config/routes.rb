Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: redirect('/users/auth/google_oauth2'), as: :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  authenticate :user do
  end

  root 'static#home'
end
