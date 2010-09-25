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

def distance_of_time_in_words(seconds, first = true)
  if seconds >= month
    r = seconds % month
    s = "#{(seconds - r) / month} month" + ((seconds - r) / month > 1 ? "s" : "")
  elsif seconds >= week
    r = seconds % week
    s = "#{(seconds - r) / week} week" + ((seconds - r) / week > 1 ? "s" : "")
  elsif seconds >= day
    r = seconds % day
    s = "#{(seconds - r) / day} day" + ((seconds - r) / day > 1 ? "s" : "")
  elsif seconds >= hour
    r = seconds % hour
    s = "#{(seconds - r) / hour} hour" + ((seconds - r) / hour > 1 ? "s" : "")
  elsif seconds >= minute
    r = seconds % minute
    s = "#{(seconds - r) / minute} minute" + ((seconds - r) / minute > 1 ? "s" : "")
  end
  if r < minute
    s += " and #{r} seconds"
  else
    s += ", #{distance_of_time_in_words(r, false)}"
  end if r > 0
  s
end
