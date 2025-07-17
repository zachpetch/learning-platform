class DashboardController < ApplicationController
  def index
    @schools = School.all
    @students = User.all
  end
end
