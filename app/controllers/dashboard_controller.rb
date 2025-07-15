class DashboardController < ApplicationController
  def index
    users = User.includes(subscriptions: { term: :course_offerings })

    if params[:student_name].present?
      users = users.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:student_name]}%", "%#{params[:student_name]}%")
    end

    course_offerings = CourseOffering.includes(:course, :term)

    if params[:course].present?
      course_offerings = course_offerings.joins(:course).where("courses.subject LIKE ? OR CAST(courses.number AS TEXT) LIKE ?", "%#{params[:course]}%", "%#{params[:course]}%")
    end

    if params[:term_id].present?
      course_offerings = course_offerings.where(term_id: params[:term_id])
    end

    @accesses = []

    users.each do |user|
      user.subscriptions.each do |subscription|
        next unless subscription.term.present?

        subscription.term.course_offerings.each do |offering|
          next unless course_offerings.find { |co| co.id == offering.id }

          access = access_status(subscription.status, offering.term)
          next if params[:status].present? && access.downcase != params[:status].downcase

          @accesses << {
            user: user,
            course: offering.course,
            term: offering.term,
            access: access
          }
        end
      end
    end
  end

  private

  def access_status(status, term)
    # return "Inactive" unless status.to_s == "active" || status.to_i == 1

    today = Date.today
    if today < term.start_date
      "Upcoming"
    elsif today > term.end_date
      "Past"
    else
      "Current"
    end
  end
end
