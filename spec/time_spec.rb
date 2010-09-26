require File.join(File.dirname(__FILE__), "spec_helper")

describe Fixnum do
  it "full times to string" do
    distance_of_time_in_words(month).should == "1 month"
    distance_of_time_in_words(week).should == "1 week"
    distance_of_time_in_words(day).should == "1 day"
    distance_of_time_in_words(hour).should == "1 hour"
    distance_of_time_in_words(minute).should == "1 minute"
  end
  
  it "2 time intervals to string" do
    distance_of_time_in_words(2.months).should == "2 months"
    distance_of_time_in_words(2.weeks).should == "2 weeks"
    distance_of_time_in_words(2.days).should == "2 days"
    distance_of_time_in_words(2.hours).should == "2 hours"
    distance_of_time_in_words(2.minutes).should == "2 minutes"
  end
  
  it "difficult time intervals to string" do
    distance_of_time_in_words(2.months + 3.days).should == "2 months, 3 days"
    distance_of_time_in_words(2.weeks - 7.days).should == "1 week"
    distance_of_time_in_words(30.minutes + 1.day).should == "1 day, 30 minutes"
    distance_of_time_in_words(10.month + 2.days + 3.hours).should == "10 months, 2 days, 3 hours"
  end
end
