require "spec_helper"

describe Moment do
  it "should have the year and month values set" do
    should validate_presence_of :year
    should validate_presence_of :month
  end

  it "associations" do
    should have_many :values
    should have_and_belong_to_many :coordinates
  end
end