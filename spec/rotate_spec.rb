require_relative "spec_helper"

describe "Rotator" do
  it "rotate file every call" do
    r = Eye::Rotator.new(TEST_FILE, :count => 3)
    create_test_file

    file.should == test_content
    file(1).should == -1
    file(2).should == -1
    file(3).should == -1
    file(4).should == -1

    r.rotate_if_needed
    file.should == ""
    file(1).should == test_content
    file(2).should == -1
    file(3).should == -1
    file(4).should == -1

    r.rotate_if_needed
    file.should == ""
    file(1).should == ""
    file(2).should == test_content
    file(3).should == -1
    file(4).should == -1

    File.open(TEST_FILE, 'w') { |f| f.write "a" }

    r.rotate_if_needed
    file.should == ""
    file(1).should == "a"
    file(2).should == ""
    file(3).should == test_content
    file(4).should == -1

    r.rotate_if_needed
    file.should == ""
    file(1).should == ""
    file(2).should == "a"
    file(3).should == ""
    file(4).should == -1

    r.rotate_if_needed
    file.should == ""
    file(1).should == ""
    file(2).should == ""
    file(3).should == "a"
    file(4).should == -1

    r.rotate_if_needed
    file.should == ""
    file(1).should == ""
    file(2).should == ""
    file(3).should == ""
    file(4).should == -1
  end

  it "rotate file every call with Gzip" do
    r = Eye::Rotator.new(TEST_FILE, :count => 3, :gzip => true)
    create_test_file

    filegz.should == test_content
    filegz(1).should == -1
    filegz(2).should == -1
    filegz(3).should == -1
    filegz(4).should == -1

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == test_content
    filegz(2).should == -1
    filegz(3).should == -1
    filegz(4).should == -1

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == ""
    filegz(2).should == test_content
    filegz(3).should == -1
    filegz(4).should == -1

    File.open(TEST_FILE, 'w') { |f| f.write "a" }

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == "a"
    filegz(2).should == ""
    filegz(3).should == test_content
    filegz(4).should == -1

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == ""
    filegz(2).should == "a"
    filegz(3).should == ""
    filegz(4).should == -1

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == ""
    filegz(2).should == ""
    filegz(3).should == "a"
    filegz(4).should == -1

    r.rotate_if_needed
    filegz.should == ""
    filegz(1).should == ""
    filegz(2).should == ""
    filegz(3).should == ""
    filegz(4).should == -1
  end

  it "correctly truncate, not loose descriptor" do
    Thread.new do
      File.open(TEST_FILE, 'w'){ |f| loop{ f.puts("someting"); f.flush; sleep 0.3 } }
    end

    r = Eye::Rotator.new(TEST_FILE, :count => 3)
    sleep 0.35

    r.rotate_if_needed
    file.should == ""
    file(1).should == "someting\nsometing\n"
    file(2).should == -1
    file(3).should == -1

    sleep 0.3

    r.rotate_if_needed
    file.should == ""
    file(1).should == "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000someting\n"
    file(2).should == "someting\nsometing\n"
    file(3).should == -1
  end

  it "rotate only if file > than min_size" do
    r = Eye::Rotator.new(TEST_FILE, :count => 3, :min_size => 2000)
    create_test_file

    r.rotate_if_needed
    r.rotate_if_needed
    r.rotate_if_needed

    file.should == test_content
    file(1).should == -1
    file(2).should == -1
    file(3).should == -1
    file(4).should == -1

    File.open(TEST_FILE, 'w') { |f| f.write("a" * 2500) }

    r.rotate_if_needed
    file.should == ""
    file(1).should == "a" * 2500
    file(2).should == -1
    file(3).should == -1
    file(4).should == -1
  end
end
