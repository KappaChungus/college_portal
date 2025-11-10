module Api
  module Teacher
    class BaseController < ApplicationController
      before_action :authenticate_user!
      before_action :require_teacher

      private

      def require_teacher
        render json: { error: "Access denied" }, status: :forbidden unless current_user.is_a?(::Teacher)
      end

      def current_teacher
        @current_teacher ||= current_user.becomes(::Teacher)
      end
    end
  end
end
