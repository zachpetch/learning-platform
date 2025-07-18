class DashboardController < ApplicationController
  def index
    @schools = search_schools(params[:school_search]).page(params[:schools_page]).per(8)
    @terms = search_terms(params[:term_search]).page(params[:terms_page]).per(8)
    @courses = search_courses(params[:course_search]).page(params[:courses_page]).per(8)
    @students = search_students(params[:student_search]).page(params[:students_page]).per(6)
  end

  def search_schools_ajax
    @schools = search_schools(params[:school_search]).page(params[:schools_page]).per(8)
    render partial: "schools_grid", locals: { schools: @schools }
  end

  def search_terms_ajax
    @terms = search_terms(params[:term_search]).page(params[:terms_page]).per(8)
    render partial: "terms_grid", locals: { terms: @terms }
  end

  def search_courses_ajax
    @courses = search_courses(params[:course_search]).page(params[:courses_page]).per(8)
    render partial: "courses_grid", locals: { courses: @courses }
  end

  def search_students_ajax
    @students = search_students(params[:student_search]).page(params[:students_page]).per(6)
    render partial: "students_grid", locals: { students: @students }
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

  def search_terms(query)
    terms = Term.all

    if query.present?
      terms = terms.where(
        "LOWER(name) LIKE ?",
        "%#{query.downcase}%"
      )
    end

    terms.order(:name)
  end

  def search_courses(query)
    courses = Course.all

    if query.present?
      courses = courses.where(
        "LOWER(subject) LIKE ? OR number LIKE ? OR LOWER(name) LIKE ? OR LOWER(subject || ' ' || number) LIKE ?",
        "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%"
      )
    end

    courses.order(:subject, :number)
  end

  def search_students(query)
    students = User.all

    if query.present?
      students = students.where(
        "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(first_name || ' ' || last_name) LIKE ? OR LOWER(email_address) LIKE ?",
        "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%"
      )
    end

    students.order(:first_name, :last_name)
  end
end
