class DashboardController < ApplicationController
  def index
    @schools = School.search(params[:school_search]).page(params[:schools_page])
    @terms = Term.search(params[:term_search]).page(params[:terms_page])
    @courses = Course.search(params[:course_search]).page(params[:courses_page])
    @students = User.search(params[:student_search]).page(params[:students_page]).per(6)
  end

  def search_schools_ajax
    begin
      @schools = School.search(params[:school_search]).page(params[:schools_page])
      render partial: "schools_grid", locals: { schools: @schools }
    rescue => e
      Rails.logger.error "Search schools error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Search failed: #{e.message}" }, status: 500
    end
  end

  def search_terms_ajax
    begin
      @terms = Term.search(params[:term_search]).page(params[:terms_page])
      render partial: "terms_grid", locals: { terms: @terms }
    rescue => e
      Rails.logger.error "Search terms error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Search failed: #{e.message}" }, status: 500
    end
  end

  def search_courses_ajax
    begin
      @courses = Course.search(params[:course_search]).page(params[:courses_page])
      render partial: "courses_grid", locals: { courses: @courses }
    rescue => e
      Rails.logger.error "Search courses error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Search failed: #{e.message}" }, status: 500
    end
  end

  def search_students_ajax
    begin
      @students = User.search(params[:student_search]).page(params[:students_page]).per(6)
      render partial: "students_grid", locals: { students: @students }
    rescue => e
      Rails.logger.error "Search students error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Search failed: #{e.message}" }, status: 500
    end
  end

  private

  def search_schools(query)
    schools = School.all

    if query.present?
      search_query = "%#{query.downcase}%"
      schools = schools.where(
        "LOWER(name) LIKE ? OR LOWER(short_name) LIKE ?",
        search_query, search_query
      )
    end

    schools.order(:name)
  end

  def search_terms(query)
    terms = Term.includes(:school)

    if query.present?
      search_query = "%#{query.downcase}%"
      terms = terms.joins(:school).where(
        "LOWER(terms.name) LIKE ? OR LOWER(schools.name) LIKE ? OR LOWER(schools.short_name) LIKE ?",
        search_query, search_query, search_query
      )
    end

    terms.order(:id)
  end

  def search_courses(query)
    courses = Course.includes(:school)

    if query.present?
      search_query = "%#{query.downcase}%"
      courses = courses.joins(:school).where(
        "LOWER(courses.subject) LIKE ? OR CAST(courses.number AS TEXT) LIKE ? OR LOWER(courses.name) LIKE ? OR LOWER(courses.subject || ' ' || CAST(courses.number AS TEXT)) LIKE ? OR LOWER(schools.name) LIKE ? OR LOWER(schools.short_name) LIKE ?",
        search_query, search_query, search_query, search_query, search_query, search_query
      )
    end

    courses.order(:subject, :number)
  end

  def search_students(query)
    students = User.all

    if query.present?
      search_query = "%#{query.downcase}%"
      students = students.where(
        "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(first_name || ' ' || last_name) LIKE ? OR LOWER(email_address) LIKE ?",
        search_query, search_query, search_query, search_query
      )
    end

    students.order(:first_name, :last_name)
  end
end
