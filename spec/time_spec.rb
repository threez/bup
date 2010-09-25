require File.join(File.dirname(__FILE__), "spec_helper")

describe Fixnum do
  it "should be possible to transform seconds in an human readable string" do
    distance_of_time_in_words(month).should == "month"
    distance_of_time_in_words(week).should == "week"
    distance_of_time_in_words(day).should == "day"
    distance_of_time_in_words(hour).should == "hour"
    distance_of_time_in_words(minute).should == "minute"
  end
end