class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all

  # Calculate Functions
  FUNCTIONS = %w(min max avg)
end
