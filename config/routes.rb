Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  authenticated :user, ->(u) { u.is_a?(Teacher) } do
    root to: "teacher_frontend#index", as: :teacher_root
  end

  authenticated :user, ->(u) { u.is_a?(Student) } do
    # front
    root to: "student_frontend#index", as: :student_root
    get "dashboard", to: "student_frontend#index"
    get "study_progress", to: "student_frontend#study_progress"
    get "schedule", to: "student_frontend#schedule"
    get "petitions", to: "student_frontend#petitions"
    get "petitions/new", to: "student_frontend#new_petition", as: :new_petition
    get "surveys", to: "student_frontend#surveys"
  end

  get "teacher_frontend/index"
  get "student_frontend/index"

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :student do
      get "courses", to: "student_api#courses"
      get "groups", to: "student_api#groups"
      get "current_teachers", to: "surveys_api#current_teachers"
      get "teachers/:teacher_id/rated", to: "surveys_api#teacher_rated"
      post "surveys", to: "surveys_api#create"
      get "surveys", to: "surveys_api#index"

      get "petitions", to: "petitions_api#my_petitions"
      post "petitions", to: "petitions_api#create"

      get "profile", to: "student_api#profile"
      put "profile", to: "student_api#update_profile"
      patch "profile", to: "student_api#update_profile"

      get "schedule", to: "schedules#index"
      get "topics", to: "petitions_api#topics"
    end

    namespace :teacher do
      get "surveys", to: "surveys#index"
      get "schedule", to: "schedules#index"
      resources :manage_courses, path: "courses", only: [ :index, :show ] do
        member do
          get "students"
          post "student/:student_id/mark", to: "manage_courses#mark"
          get "student/:student_id/marks", to: "manage_courses#marks"
        end
      end
      resources :manage_courses, path: "courses", only: [ :index, :show ] do
        member do
          get "students"
          post "student/:student_id/mark", to: "manage_courses#mark"
          get "student/:student_id/marks", to: "manage_courses#marks"
        end
      end
    end

    # Schedule (was class_sessions)
    get "groups/:group_id/schedule", to: "schedules#index"
    post "groups/:group_id/schedule", to: "schedules#create"

    resources :schedules, only: [ :update, :destroy ]
  end
end
