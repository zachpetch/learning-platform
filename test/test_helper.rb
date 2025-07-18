ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out(user)
      session.delete(:user_id)
    end

    def current_user
      User.find(session[:user_id]) if session[:user_id]
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
    end

    def sign_out(user)
      delete session_url
    end
  end
end
