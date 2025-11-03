class TeacherDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_teacher

  def index
  end

  private

  def require_teacher
    redirect_to unauthenticated_root_path, alert: "Access denied." unless current_user.teacher?
  end
end
