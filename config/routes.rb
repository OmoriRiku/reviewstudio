Rails.application.routes.draw do
  # 管理者用
  # URL /customers/sign_in ...
  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }
  
  # ユーザー用
  # URL /users/sign_in ...
  devise_for :end_users, path: 'users/', controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
