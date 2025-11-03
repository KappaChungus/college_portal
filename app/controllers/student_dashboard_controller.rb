class StudentDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_student

  def index
  end

  private

  def require_student
    redirect_to unauthenticated_root_path, alert: "Access denied." unless current_user.student?
  end
end
