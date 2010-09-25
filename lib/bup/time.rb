# helpers to deal with time

class Fixnum
  def month
    self * 30.days
  end

  def week
    self * 7.days
  end
  
  def day
    self * 24.hours
  end
  
  def hour
    self * 60.minutes
  end
  
  def minute
    self * 60 # seconds
  end
  
  alias months month
  alias weeks week
  alias days day
  alias hours hour
  alias minutes minute
end

def month
  1.month
end

def week
  1.week
end

def day
  1.day
end

def hour
  1.hour
end

def minute
  1.minute
end

def distance_of_time_in_words(seconds)
  single = {
    month => "month",
    week => "week",
    day => "day",
    hour => "hour",
    minute => "minute"
  }[seconds]
  
  unless single
  
  else
    single
  end
end