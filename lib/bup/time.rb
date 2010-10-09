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

# returns a string for the passed seconds using the name and an interval_size
def unit_for(seconds, name, interval_size)
  non_dividable = seconds % interval_size
  units = (seconds - non_dividable) / interval_size
  string = "#{units} #{name}" + (units > 1 ? "s" : "") # pluralization (s)
  [non_dividable, string]
end

# returns a string that represents the seconds as string in english
def distance_of_time_in_words(seconds, first = true)
  # check the big numbers
  if seconds >= month
    rest, str = unit_for(seconds, "month", month)
  elsif seconds >= week
    rest, str = unit_for(seconds, "week", week)
  elsif seconds >= day
    rest, str = unit_for(seconds, "day", day)
  elsif seconds >= hour
    rest, str = unit_for(seconds, "hour", hour)
  elsif seconds >= minute
    rest, str = unit_for(seconds, "minute", minute)
  end
  
  # add recursive if bigger than a minute otherwise append the seconds
  if rest < minute
    str += " and #{rest} seconds"
  else
    str += ", #{distance_of_time_in_words(rest, false)}"
  end if rest > 0
  str
end
