module Admin
  class DashboardController < BaseAdminController

    before_action do
      authorize_action_for AdminDashboard
    end

    def show
    end
  end
end
