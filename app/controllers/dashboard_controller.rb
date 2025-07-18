class DashboardController < ApplicationController
  def index
    @schools = School.order(:name).page(params[:schools_page]).per(8)
    @students = User.order(:last_name).page(params[:students_page]).per(12)
  end
end
