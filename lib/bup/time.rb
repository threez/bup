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
  rest = seconds % interval_size
  units = (seconds - rest) / interval_size
  str = "#{units} #{name}" + (units > 1 ? "s" : "") # pluralization (s)
  [rest, str]
end

# returns a string that represents the seconds as string in english
def distance_of_time_in_words(seconds)
  # check the big numbers
  rest, str = if    seconds >= month  then unit_for(seconds, "month", month)
              elsif seconds >= week   then unit_for(seconds, "week", week)
              elsif seconds >= day    then unit_for(seconds, "day", day)
              elsif seconds >= hour   then unit_for(seconds, "hour", hour)
              elsif seconds >= minute then unit_for(seconds, "minute", minute)
              end
  
  if rest > 0
    # add recursive if bigger than a minute otherwise append the seconds
    str += (rest < minute) ? " and " + units_for(seconds, "second", 1) :
                             ", "    + distance_of_time_in_words(rest)
  else
    str # complete units string
  end
end
