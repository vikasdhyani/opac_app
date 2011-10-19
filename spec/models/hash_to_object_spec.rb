require "spec_helper"

describe HashToObject do
  it "creates a new object with given parameters" do
    object = HashToObject.new({:membership_no => "M1"}, :membership_no)
    object.membership_no.should == "M1"
  end

  it "responds to whatever is passed in the constructor" do
    object = HashToObject.new({}, :foo, :bar)
    object.should respond_to(:foo)
    object.should respond_to(:bar)
    object.should_not respond_to(:baz)
  end

  it "should respond to the string version" do
    object = HashToObject.new({}, :foo, :bar)
    object.should respond_to("foo")
    object.should respond_to("bar")
    object.should_not respond_to("baz")
  end

  it "returns nil for nonexistant methods" do
    object = HashToObject.new({}, :bar)
    object.bar.should be_nil
  end
end