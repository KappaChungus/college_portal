module Api
  module Student
    class BaseController < ApplicationController
      before_action :authenticate_user!
      before_action :require_student

      private

      def require_student
        render json: { error: "Access denied" }, status: :forbidden unless current_user.is_a?(::Student)
      end

      def current_student
        @current_student ||= current_user.becomes(::Student)
      end
    end
  end
end
