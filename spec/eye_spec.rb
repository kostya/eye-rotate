require_relative "spec_helper"

describe "Integration" do
  subject{ Eye::Controller.new }

  it "should rotate for process" do
    subject.load(fixture("manual.eye"))

    sleep 10 # 3 rotation steps here

    filegz.size.should > 1
    filegz(1).size.should > 1
    filegz(2).size.should > 1
    filegz(3).should == -1
    filegz(4).should == -1
  end

  it "should rotate for all processes" do
    subject.load(fixture("default.eye"))

    sleep 10 # 3 rotation steps here

    filegz.size.should > 1
    filegz(1).size.should > 1
    filegz(2).size.should > 1
    filegz(3).should == -1
    filegz(4).should == -1
  end

  it "should rotate for filename" do
    subject.load(fixture("filename.eye"))

    sleep 10 # 3 rotation steps here

    filegz.size.should > 1
    filegz(1).size.should > 1
    filegz(2).size.should > 1
    filegz(3).should == -1
    filegz(4).should == -1
  end

end
