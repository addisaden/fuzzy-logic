# encoding: utf-8

temp = {}

temp[:warm] = Proc.new { |n|
  out = 0
  if n >= 28
    out = 1
  elsif n < 28 and n >= 15
    out = 1 - (28.0-n)/(28.0-15)
  end
  out
}

temp[:cold] = Proc.new { |n|
  out = 0
  if n <= 0
    out = 1
  elsif n < 15 and n >= 0
    out = 1 - n/15.0
  end
  out
}

temp[:mid] = Proc.new { |n|
  [(1 - temp[:cold].call(n)),(1 - temp[:warm].call(n))].min
}


[0,1,14,15,16,20,27,30].each { |inp|
puts "--- Testing #{ inp } °C"
  temp.each { |n,f|
    puts "Is the weather #{ n }? #{ f.call(inp) }"
  }
}