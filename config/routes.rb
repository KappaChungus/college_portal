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
    get "student/courses", to: "student_api#courses"
    get "student/groups", to: "student_api#groups"
    get "student/current_teachers", to: "surveys_api#current_teachers"
    get "student/teachers/:teacher_id/rated", to: "surveys_api#teacher_rated"
    post "student/surveys", to: "surveys_api#create"
    get "student/petitions", to: "petitions_api#my_petitions"
    post "student/petitions", to: "petitions_api#create"
    get "student/profile", to: "student_api#profile"
    put "student/profile", to: "student_api#update_profile"
    patch "student/profile", to: "student_api#update_profile"
    get "student/surveys", to: "surveys_api#index"
    # Schedule (was class_sessions)
    get "groups/:group_id/schedule", to: "schedules#index"
    post "groups/:group_id/schedule", to: "schedules#create"
    get "student/schedule", to: "schedules#student_schedule"
    resources :schedules, only: [ :update, :destroy ]
  end
end
