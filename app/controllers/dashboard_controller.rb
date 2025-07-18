class DashboardController < ApplicationController
  def index
    # @schools = School.order(:name).page(params[:schools_page]).per(8)
    # @students = User.order(:last_name).page(params[:students_page]).per(6)

    @schools = search_schools(params[:school_search]).page(params[:schools_page]).per(8)
    @students = search_students(params[:student_search]).page(params[:students_page]).per(6)
  end

  private

  def search_schools(query)
    schools = School.all

    if query.present?
      schools = schools.where(
        "LOWER(name) LIKE ? OR LOWER(short_name) LIKE ?",
        "%#{query.downcase}%", "%#{query.downcase}%"
      )
    end

    schools.order(:name)
  end

  def search_students(query)
    students = User.all

    if query.present?
      students = students.where(
        "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(first_name || ' ' || last_name) LIKE ?",
        "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%"
      )
    end

    students.order(:first_name, :last_name)
  end
end
