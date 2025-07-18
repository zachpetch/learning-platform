class SchoolsController < ApplicationController
  before_action :set_school, only: %i[ show edit update destroy ]

  # GET /schools or /schools.json
  def index
    @schools = School.all
  end

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

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools or /schools.json
  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: "School was successfully created." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1 or /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to @school, notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1 or /schools/1.json
  def destroy
    @school.destroy!

    respond_to do |format|
      format.html { redirect_to schools_path, status: :see_other, notice: "School was successfully destroyed." }
      format.json { head :no_content }
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
