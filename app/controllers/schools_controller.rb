class SchoolsController < ApplicationController
  before_action :set_school, only: %i[ show edit update destroy ]

  # GET /schools/1 or /schools/1.json
  def show
    terms = @school.terms.includes(:subscriptions, course_offerings: :payments)

    @past_terms = terms.past
    @current_terms = terms.current
    @upcoming_terms = terms.upcoming

    @total_subscriptions_count = count_subscriptions(@past_terms + @current_terms + @upcoming_terms)
    @past_subscriptions_count = count_subscriptions(@past_terms)
    @current_subscriptions_count = count_subscriptions(@current_terms)
    @upcoming_subscriptions_count = count_subscriptions(@upcoming_terms)

    @total_paid_subscriptions_count = count_paid_subscriptions(@past_terms + @current_terms + @upcoming_terms)
    @past_paid_subscriptions_count = count_paid_subscriptions(@past_terms)
    @current_paid_subscriptions_count = count_paid_subscriptions(@current_terms)
    @upcoming_paid_subscriptions_count = count_paid_subscriptions(@upcoming_terms)

    @total_licensed_subscriptions_count = count_licensed_subscriptions(@past_terms + @current_terms + @upcoming_terms)
    @past_licensed_subscriptions_count = count_licensed_subscriptions(@past_terms)
    @current_licensed_subscriptions_count = count_licensed_subscriptions(@current_terms)
    @upcoming_licensed_subscriptions_count = count_licensed_subscriptions(@upcoming_terms)

    @total_course_offering_count = count_course_payment_users(@past_terms + @current_terms + @upcoming_terms)
    @past_course_offering_count = count_course_payment_users(@past_terms)
    @current_course_offering_count = count_course_payment_users(@current_terms)
    @upcoming_course_offering_count = count_course_payment_users(@upcoming_terms)

    @total_student_count = unique_student_count(@past_terms + @current_terms + @upcoming_terms)
    @past_student_count = unique_student_count(@past_terms)
    @current_student_count = unique_student_count(@current_terms)
    @upcoming_student_count = unique_student_count(@upcoming_terms)
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

  def count_subscriptions(terms)
    Subscription.where(term: terms).joins(:user).distinct.count("users.id")
  end

  def count_paid_subscriptions(terms)
    Subscription
      .where(term: terms)
      .joins(:payments)
      .distinct
      .count("subscriptions.id")
  end

  def count_licensed_subscriptions(terms)
    Subscription
      .where(term: terms)
      .where.not(license_id: nil)
      .distinct
      .count("subscriptions.id")
  end

  def count_course_payment_users(terms)
    Payment.joins(:course_offering, :user)
           .where(course_offerings: { term_id: terms.pluck(:id) })
           .where.not(completed_at: nil)
           .distinct
           .count("users.id")
  end

  def unique_student_count(terms)
    sub_ids = Subscription.where(term: terms).select(:user_id)
    pay_ids = Payment.joins(:course_offering)
                     .where(course_offerings: { term_id: terms.pluck(:id) })
                     .where.not(completed_at: nil)
                     .select(:user_id)

    User.from("(#{sub_ids.to_sql} UNION #{pay_ids.to_sql}) AS combined_users").count
  end
end
