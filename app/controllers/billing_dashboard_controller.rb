class BillingDashboardController < ApplicationController
  before_action do
    authorize_action_for BillingDashboard
  end

  def show
  end
end
