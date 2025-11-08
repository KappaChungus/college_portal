class TeacherFrontendController < ApplicationController
  before_action :authenticate_user!
  before_action :require_teacher
  layout "teacher"

  def index
  end

  def dashboard
  end

  def schedule
  end

  def surveys
  end

  def manage_courses
  end

  def profile
  end

  def course
  end

  private

  def require_teacher
    redirect_to unauthenticated_root_path, alert: "Access denied." unless current_user.is_a?(Teacher)
  end
end
