Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations, :passwords ]

  # front for teachers

  authenticated :user, ->(u) { u.is_a?(Teacher) } do
    root to: "teacher_frontend#dashboard", as: :teacher_root
    get "dashboard", to: "teacher_frontend#dashboard"
    get "schedule", to: "teacher_frontend#schedule"
    get "surveys", to: "teacher_frontend#surveys"
    get "manage_courses", to: "teacher_frontend#manage_courses"
    get "course/:id", to: "teacher_frontend#course", as: :teacher_course
    get "profile", to: "teacher_frontend#profile"
  end

  # front for students
  authenticated :user, ->(u) { u.is_a?(Student) } do
    root to: "student_frontend#dashboard", as: :student_root
    get "dashboard", to: "student_frontend#dashboard"
    get "study_progress", to: "student_frontend#study_progress"
    get "schedule", to: "student_frontend#schedule"
    get "petitions", to: "student_frontend#petitions"
    get "petitions/new", to: "student_frontend#new_petition", as: :new_petition
    get "surveys", to: "student_frontend#surveys"
  end


  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :student do
      get "courses", to: "study_progress#courses"
      get "courses/:course_id/grades", to: "study_progress#grades"
      get "groups", to: "study_progress#groups"
      get "current_teachers", to: "surveys_api#current_teachers"
      get "teachers/:teacher_id/rated", to: "surveys_api#teacher_rated"
      post "surveys", to: "surveys_api#create"
      get "surveys", to: "surveys_api#index"

      get "petitions", to: "petitions_api#my_petitions"
      post "petitions", to: "petitions_api#create"

      get "profile", to: "study_progress#profile"
      put "profile", to: "study_progress#update_profile"
      patch "profile", to: "study_progress#update_profile"

      get "schedule", to: "schedules#index"
      get "topics", to: "petitions_api#topics"

      # Dashboard
      get "announcements", to: "dashboard#announcements"
      get "latest_grades", to: "dashboard#latest_grades"
    end

    namespace :teacher do
      get "surveys", to: "surveys#surveys"
      get "surveys/averages", to: "surveys#averages"
      get "schedule", to: "schedules#schedule"
      resources :manage_courses, path: "courses", only: [ :index, :show ] do
        member do
          get "students"
          post "student/:student_id/mark", to: "manage_courses#mark"
          get "student/:student_id/marks", to: "manage_courses#marks"
          get "student/:student_id/grades", to: "manage_courses#grades"
          put "student/:student_id/grade/:grade_index", to: "manage_courses#update_grade"
          delete "student/:student_id/grade/:grade_index", to: "manage_courses#delete_grade"
        end
      end

      # Dashboard
      get "announcements", to: "dashboard#announcements"
      post "announcements", to: "dashboard#create_announcement"
      put "announcements/:id", to: "dashboard#update_announcement"
      delete "announcements/:id", to: "dashboard#delete_announcement"

      # Profile
      get "profile", to: "profile#show"
      get "profile/stats", to: "profile#stats"
      put "profile", to: "profile#update"
      patch "profile", to: "profile#update"
    end

    # Schedule (was class_sessions)
    get "groups/:group_id/schedule", to: "schedules#index"
    post "groups/:group_id/schedule", to: "schedules#create"

    resources :schedules, only: [ :update, :destroy ]
  end
end
