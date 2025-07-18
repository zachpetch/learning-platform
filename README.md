# Learning Platform

A demonstration of Ruby on Rails via a simple Learning Platform web app.

## Setup / Run

#### Step 1: Run Migrations

`bin/rails db:migrate`

#### Step 2: Seed the database (optional)

`bin/rails db:seed`

#### Step 3: Launch Server

`bin/rails server`

#### Step 4: Check it out

- Visit http://localhost:3000/ in your browser.
- Sign in with admin@example.com (password is "password")
- OR create your own account

## Notes

### Models/Migrations

#### Users(/Students)

I have not yet looked into how to use the built-in authentication using a different model than `User`. I like the idea
of having `Students` be the primary user of the platform, but with the default generated authentication creating a User
model/table, I opted to simply go ahead with that, but refer to the model as Students in the views. There is potential
for this to be confusing, and it is one of the things I'd want to change with a bit more time, either by figuring out
how to have Students be the default authentication model, or by considering two different models. Users who can access
the platform (who may not be students, but admins for schools, etc), and separate student models for users who have
access to courses/subscriptions.

#### Payments

I created a Payment model with a provider and provider_transaction_id rather than credit card details. In my experience,
credit card payments are generally handled quite reliably/safely/easily by a third party provider. Then, all that is
required to be stored on our own system is a transaction ID that can be used to retrieve details or handle refunds, etc.

Storing both a `provider` and `provider_transaction_id` also enables multiple providers to be used for multiple possible
methods of payment (CC, PayPal, Interac, etc.). If this was a real project for production, this would all be part of
precursory discussions and decision-making, but this is how I opted to handle it for this demo project (though I did not
implement anything resembling connecting to payment provider APIs, which would, of course, be required in practice).

The `completed_at` field is meant to be null if the payment has not gone through, and to contain a DateTime value when
it's successfully completed. Similarly, the `refunded_at` field is meant to be null unless the payment was later
refuneded, at which point the `refunded_at` field would contain the DateTime that the refund was completed.

I've intentionally ignored the possibility for partial refunds, which may require a separate refunds model/table. It
felt like unnecessary complexity for the purposes of this assignment.

#### Courses

I intentionally left the course name/description nullable, as it seemed reasonable that the name of a course could
simply be its subject and number (e.g. "Math 101"), but an administrator could optionally give it a name (e.g. "Intro to
Calculus") and/or add a description if desired.

#### Course Offerings

I have assumed this is an online platform, so there are no seat limitations regarding how many people can access a
course. If there could be in-person classes, we could add an optional `seats` field (or similar) to the model/table, and
schools could set to be the number of available spots in the class, and it would be considered unavailable once the
number of users signed up for it reached the number of available spots. There would also be additional complexity to
ensure the courses weren't overbooked, and it could be nice to add a waitlist feature in this case as well.

#### Licenses and Subscriptions

My thoughts behind setting these up is that there would be some system for generating a license code for a set number of
terms, whether it's the schools or some other entity that does the generating, and a person could redeem the code for a
term at one school, which would grant them a subscription to that term at that school, giving them access to all the
courses available at that time. Obviously the entire application isn't fleshed out such that this process is possible,
and there would need to be checks in place to ensure a license code could not be redeemed for more subscriptions than
were assigned to it, etc., but that is what I had in my mind for the implementation, and it is an element of the project
that I felt may be unclear while looking through the schema or the rest of the code.
Ultimately, this flow could probably be done better, or at least be considered more carefully, to ensure it's the best
way forward. But I've opted to not spend more time on it for now.

### Database Seeding

I suspect there are more efficient ways to add CSV data into the database than what I've set up in the
`db/seeds.rb` file, like converting the CSV files into arrays that can be inserted into the DB with a singular query.
But it's another example of something that seemed like it wasn't a priority to spend time sorting out for the purpose of
this task.

In the payment seeding section, it is randomly assigning course offering IDs, which risks duplicate course offerings
being purchased by the same user. In production, the unique requirement set on the table should prevent that (though,
obviously, there's work to do to implement the error handling, etc.), but I'm hoping for the sake of seeding the
database with demo content, it will be ok to leave it as is, rather than spending the time to create sets and check for
uniqueness.

### HTML/Views

I used TailwindCSS, as it's a UI framework I'm familiar with. And though I see there is a gem for importing it, I've
just used the standard TailwindCSS CDN for the time being. In either case, there are a lot of design improvements that
could be made to make this look more polished.

Note: I wrote this next part before starting to figure out the way partials work, and I've since started implementing
a couple of view elements with them, but didn't have the time to re-do it all to be more cleanly put together.
In that context, as well, I would like to learn a bit more about templating and components (whether this is done with
React, or if there are standard Rails best practices in this regard) as, ideally, there wouldn't be a lot of repeated
utility classes in each of the similarly styled components (like search fields or cards), but the style would be defined
on a single component that would be then re-used wherever needed. This is another thing I would tackle given a bit more
time, but seemed less important to do here, where the primary goal of developing the domain logic.

There are a couple places I used icons from TailwindCSS's Heroicons library. For the sake of quickness, I just copied
and pasted the SVG code from heroicons.com, but in practice I would probably pull in the library (or a similar one)
through a gem, or something along those lines.

#### Pagination and Searching/Filtering

I wanted to do as much of this project using built-in Rails functionality, or other gems considered "best practice", but
though there are some frameworks that enable searching/filtering and pagination without refreshing the whole page, I was
not able to figure out how to do that with Rails before I was feeling pressed for time. So, I've implemented this
functionality using AJAX to make the requests, and set up the controller to recognize AJAX requests differently than
standard GET requests, returning only the parts of the page that need to be updated, rather than refreshing the entire
page.

With that said, I'd be very interested to know if there is a built-in method in Rails, or what the standard practice is
for doing this. I just started to come across some info about using "remote: true" to essentially send an async request.
But not in time to make changes to how I put this together.

### Soft Deletion

I like the idea of using soft-deletion for posterity. It seems like there are useful gems for handling this, like the
`discard` gem. With that said, in the context of the assignment, I didn't want to spend too much time figuring that out
this week, so the models are using destructive deletion that cascades to dependent models. In practice, however, it
would be worth setting the database up to opt for soft-deletion (or deactivation) of records, or at least determining
what data should be kept after deletion (for example, nullifying associations on deletion of dependent records rather
than deleting the records entirely).
