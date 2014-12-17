module Api
  module V1
    class ApiController < ApplicationController
      before_filter :verify_access
      before_filter :verify_rate_limit
      before_filter :set_organization

      respond_to :json

      private

      def verify_access
        authenticate_or_request_with_http_token do |token, options|
          puts "TOKEN:::: #{token}"
          (@api_key = ApiKey.find_by_token(token)).present?
        end
        # render json: { error: 'Invalid API key.' }, status: :unauthorized
      end

      def verify_rate_limit
        return if ApiCall.bump!(@api_key) <= @api_key.hourly_rate_limit
        render json: { error: 'Rate limit exceeded for the current hour.' },
               status: :too_many_requests
      end

      def verify_admin
        return if @api_key.user.admin?
        render json: { error: 'API key is not authorized for that function.' },
               status: :unauthorized
      end

      def set_organization
        @organization = @api_key.organization
      end

    end
  end
end
