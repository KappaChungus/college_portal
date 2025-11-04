Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  authenticated :user, ->(u) { u.is_a?(Teacher) } do
    root to: "teacher_dashboard#index", as: :teacher_root
  end

  authenticated :user, ->(u) { u.is_a?(Student) } do
    root to: "student_dashboard#index", as: :student_root
  end

  get "teacher_dashboard/index"
  get "student_dashboard/index"

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  get "dashboard", to: "student_dashboard#index"
  get "study_progress", to: "student_dashboard#study_progress"
  get "schedule", to: "student_dashboard#schedule"
  get "petitions", to: "student_dashboard#petitions"
  get "surveys", to: "student_dashboard#surveys"
end
