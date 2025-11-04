Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  authenticated :user, ->(u) { u.is_a?(Teacher) } do
    root to: "teacher_frontend#index", as: :teacher_root
  end

  authenticated :user, ->(u) { u.is_a?(Student) } do
    #front
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
  end


  
end
