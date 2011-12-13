require "spec_helper"

describe Coordinate do
  it "should have the x and y values set" do
    should validate_presence_of :x
    should validate_presence_of :y
  end

  it "association: has many" do
    should have_and_belong_to_many :moments
  end
end