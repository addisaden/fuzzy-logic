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

temp[:cool] = Proc.new { |n|
  temp[:mid].call(n)*temp[:cold].call(n)*4
}


(0..30).to_a.each { |inp|
  next if inp % 2 == 1
  puts "--- Testing #{ inp } °C"
  temp.each { |n,f|
    puts "Is the weather #{ n }?\t%.2f" % f.call(inp)
  }
}
