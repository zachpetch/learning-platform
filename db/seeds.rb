# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'
require 'faker'
require 'securerandom'

OFFERINGS_PER_TERM = 25
MAX_SUBSCRIBERS_PER_TERM = 30
TERMS_PER_SCHOOL = 7
SCHOOL_COUNT = 29
USER_COUNT = 18000
LICENSE_COUNT = 2000
MAX_COURSES_PER_USER = 8
MIN_COURSE_COST = 20000
MAX_COURSE_COST = 80000
MIN_SUBSCRIPTION_COST = 100000
MAX_SUBSCRIPTION_COST = 250000
DEFAULT_PASSWORD = BCrypt::Password.create("password")

# Importing schools from CSV
CSV.foreach(Rails.root.join("db/data/school_data.csv"), headers: true) do |row|
  School.create!(
    id: row["id"],
    name: row["name"],
    short_name: row["short_name"],
    created_at: Time.now,
    updated_at: Time.now
  )
end

# Importing terms from CSV
CSV.foreach(Rails.root.join("db/data/terms_data.csv"), headers: true) do |row|
  Term.create!(
    id: row["id"],
    school_id: row["school_id"],
    name: row["name"],
    year: row["year"],
    sequence_num: row["sequence_num"],
    start_date: row["start_date"],
    end_date: row["end_date"],
    created_at: Time.now,
    updated_at: Time.now
  )
end

# Importing Courses from CSV
CSV.foreach(Rails.root.join("db/data/course_data.csv"), headers: true).with_index do |row, j|
  SCHOOL_COUNT.times do |i|
    Course.create!(
      id: i + j * SCHOOL_COUNT,
      school_id: i + 1,
      subject: row["subject"],
      number: row["number"],
      name: row["name"],
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end

# Course Offerings
course_ids = Course.pluck(:id)
course_offerings = []

Term.find_each do |term|
  selected_course_ids = course_ids.sample(OFFERINGS_PER_TERM)
  selected_course_ids.each do |course_id|
    course_offerings << {
      term_id: term.id,
      course_id: course_id,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

CourseOffering.insert_all(course_offerings)

# Users/Students
users = []

USER_COUNT.times do
  first = Faker::Name.first_name
  last = Faker::Name.last_name
  email = Faker::Internet.unique.email(name: "#{first}.#{last}")

  users << {
    first_name: first,
    last_name: last,
    email_address: email,
    password_digest: DEFAULT_PASSWORD,
    created_at: Time.now,
    updated_at: Time.now
  }
end

users.each_slice(1000) do |batch|
  User.insert_all(batch)
end

# Payments for Course Offerings
course_offering_ids = CourseOffering.pluck(:id)
payments = []

existing_payment_pairs = Set.new

User.find_each do |user|
  selected_offerings = course_offering_ids.sample(rand(MAX_COURSES_PER_USER + 1))

  selected_offerings.each do |offering_id|
    pair = [ user.id, offering_id ]
    next if existing_payment_pairs.include?(pair)

    existing_payment_pairs << pair

    payments << {
      user_id: user.id,
      course_offering_id: offering_id,
      amount: rand(MIN_COURSE_COST..MAX_COURSE_COST),
      provider: "Credit Card",
      provider_transaction_id: SecureRandom.uuid,
      completed_at: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

Payment.insert_all(payments)

# Subscriptions
user_ids = User.pluck(:id)
subscriptions = []

Term.find_each do |term|
  sample_size = rand(1..MAX_SUBSCRIBERS_PER_TERM)
  selected_user_ids = user_ids.sample(sample_size)
  selected_user_ids.each do |user_id|
    subscriptions << {
      user_id: user_id,
      term_id: term.id,
      status: 0,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

Subscription.insert_all(subscriptions)

# Licenses
licenses = []

LICENSE_COUNT.times do
  licenses << {
    code: SecureRandom.uuid,
    term_count: rand(1..TERMS_PER_SCHOOL + 1),
    created_at: Time.now,
    updated_at: Time.now
  }
end

License.insert_all(licenses)

# Payments for Subscriptions
subscriptions = Subscription.order("RANDOM()").limit(Subscription.count / 2)
payments = []

subscriptions.each do |subscription|
  payments << {
    user_id: subscription.user.id,
    subscription_id: subscription.id,
    amount: rand(MIN_SUBSCRIPTION_COST..MAX_SUBSCRIPTION_COST),
    provider: "Credit Card",
    provider_transaction_id: SecureRandom.uuid,
    completed_at: Time.now,
    created_at: Time.now,
    updated_at: Time.now
  }
end

Payment.insert_all(payments)

# Subscriptions bought with licenses

paid_subscription_ids = Payment.where.not(subscription_id: nil).pluck(:subscription_id)
subscriptions = Subscription.where.not(id: paid_subscription_ids)
license_ids = License.order("RANDOM()").limit(subscriptions.count).pluck(:id)
license_ids = license_ids.cycle.take(subscriptions.count)

subscriptions.each_with_index do |subscription, i|
  subscription.update!(license_id: license_ids[i])
end

# Admin-specific account without any courses/subscriptions, etc.
User.create!(first_name: "Admin", last_name: "Account", email_address: "admin@example.com", password_digest: DEFAULT_PASSWORD)
