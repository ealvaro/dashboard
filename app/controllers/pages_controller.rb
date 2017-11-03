class PagesController < ApplicationController
  before_action :authenticate_user!
  def home
    @active_tab = 'Active'
  end
end
