class StudentFrontendController < ApplicationController
  before_action :authenticate_user!
  before_action :require_student

  layout "student"
  def index
  end

  def study_progress; end
  def schedule; end
  def petitions; end
  def new_petition; end
  def surveys; end
  private

  def require_student
    redirect_to unauthenticated_root_path, alert: "Access denied." unless current_user.is_a?(Student)
  end
end
