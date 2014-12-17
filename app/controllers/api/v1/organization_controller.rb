module Api
  module V1
    class OrganizationController < ApiController
      before_filter :verify_admin, only: [:update]

      def show
        respond_with @organization
      end

      def update
        @organization.update_attributes(organization_params)
        respond_with @organization
      end

      private

      def organization_params
        params.require(:organization).permit(:name)
      end

    end
  end
end
