class SchoolsController < ApplicationController
  before_action :set_school, only: %i[ show edit update destroy ]

  # GET /schools/1 or /schools/1.json
  def show
    # Get the current term for this school
    @current_term = @school.terms.current.first

    if @current_term
      # Count students with subscriptions to the current term
      @subscription_count = @current_term.subscriptions.joins(:user).distinct.count("users.id")

      # Count students with payments for course offerings in the current term
      @course_payment_count = Payment.joins(:course_offering, :user)
                                     .where(course_offerings: { term: @current_term })
                                     .where.not(completed_at: nil)
                                     .distinct
                                     .count("users.id")

      # Get total unique students (combining subscriptions and course payments)
      @total_student_count = calculate_total_students
    else
      @subscription_count = 0
      @course_payment_count = 0
      @total_student_count = 0
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def school_params
    params.expect(school: [ :name, :short_name ])
  end

  def calculate_total_students
    return 0 unless @current_term

    subscription_user_ids = @current_term.subscriptions.select(:user_id)
    payment_user_ids = Payment.joins(:course_offering)
                              .where(course_offerings: { term: @current_term })
                              .where.not(completed_at: nil)
                              .select(:user_id)

    union_query = User.from("(#{subscription_user_ids.to_sql} UNION #{payment_user_ids.to_sql}) AS combined_users")
    union_query.count
  end
end
