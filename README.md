# Learning Platform

A demonstration of Ruby on Rails via a simple Learning Platform web app.


## Setup / Run

#### Step 1: Run Migrations
`bin/rails db:migrate`

#### Step 2: Load Fixtures (optional)
`bin/rails db:fixtures:load`

#### Step 3: Launch Server
`bin/rails server`


## Database Overview
- **User**
  - id (Primary Key, Int)
  - first_name (String)
  - last_name (String)
  - verified_at (DateTime, Nullable)
  - created_at (DateTime)
  - updated_at (DateTime)
- **School**
  - id (Primary Key, Int)
  - name (String)
  - created_at (DateTime)
  - updated_at (DateTime)
- **Term**
  - id (Primary Key, Int)
  - school_id (Foreign Key, Int)
  - name (String)
  - year (Int)
  - sequence_num (Int)
  - start_date (Date)
  - end_date (Date)
  - created_at (DateTime)
  - updated_at (DateTime)
- **Course**
  - id (Primary Key, Int)
  - school_id (Foreign Key, Int)
  - subject (String)
  - number (Int)
  - name (String, Nullable)
  - created_at (DateTime)
  - updated_at (DateTime)
- **CourseOffering**
  - id (Primary Key, Int)
  - course_id (Foreign Key, Int)
  - term_id (Foreign Key, Int)
  - created_at (DateTime)
  - updated_at (DateTime)
- **License**
  - id (Primary Key, Int)
  - code (String)
  - term_count (Int)
  - created_at (DateTime)
  - updated_at (DateTime)
- **Subscription**
  - id (Primary Key, Int)
  - user_id (Foreign Key, Int)
  - term_id (Foreign Key, Int)
  - license_id (Foreign Key, Int, Nullable)
  - payment_id (Foreign Key, Int, Nullable)
  - status (Int)
  - created_at (DateTime)
  - updated_at (DateTime)
- **Payment**
  - id (Primary Key, Int)
  - user_id (Foreign Key, Int)
  - subscription_id (Foreign Key, Int, Nullable)
  - course_offering_id (Foreign Key, Int, Nullable)
  - amount (Int)
  - provider (String)
  - provider_transaction_id (String)
  - completed_at (DateTime, Nullable)
  - refunded_at (DateTime, Nullable)
  - created_at (DateTime)
  - updated_at (DateTime)


## Notes

### Models/Migrations

#### Payments
I created a Payment model with a provider and provider_transaction_id rather than credit card details. In my experience, credit card payments are generally handled quite reliably/safely/easily by a third party provider. Then, all that is required to be stored on our own system is a transaction ID that can be used to retrieve details or handle refunds, etc.

Storing both a `provider` and `provider_transaction_id` also enables multiple providers to be used for multiple possible methods of payment (CC, PayPal, Interac, etc.). If this was a real project for production, this would all be part of precursory discussions and decision-making, but this is how I opted to handle it for this demo project (though I did not implement anything resembling connecting to payment provider APIs, which would, of course, be required in practice). 

The `completed_at` field is meant to be null if the payment has not gone through, and to contain a DateTime value when it's successfully completed. Similarly, the `refunded_at` field is meant to be null unless the payment was later refuneded, at which point the `refunded_at` field would contain the DateTime that the refund was completed.

I've intentionally ignored the possibility for partial refunds, which may require a separate refunds model/table. It felt like unnecessary complexity for the purposes of this assignment.

#### Courses
I intentionally left the course name nullable, as it seemed reasonable that the name of a course could simply be its subject and number (e.g. "Math 101"), but an administrator could optionally give it a name (e.g. "Intro to Calculus").

#### Course Offerings
I have assumed this is an online platform, so there are no seat limitations regarding how many people can access a course. If there could be in-person classes, we could add an optional `seats` field (or similar) to the model/table, and schools could set to be the number of available spots in the class, and it would be considered unavailable once the number of users signed up for it reached the number of available spots. There would also be additional complexity to ensure the courses weren't overbooked, and it could be nice to add a waitlist feature in this case as well.

### Soft Deletion
I like the idea of using soft-deletion for posterity. Looking into best practices, it seems like there are useful gems for handling this, like the `discard` gem. With that said, in the context of the assignment, I didn't want to spend too much time figuring that out this week, so the models are using destructive deletion that cascades to dependent models. In practice, however, it would be worth determining what data should be kept after deletion, or nullifying associations on deletion of dependent records rather than deleting the records entirely.